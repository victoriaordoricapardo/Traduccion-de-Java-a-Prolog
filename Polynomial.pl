%%% José Luis Sandín -- 179706
%%% Alejandro Cesar Moya --
%%% Victoria Ordorica Pardo --
%%% 

%%% Calculates the degree of the polynomial

degree([K|Poly], N) :- 
  	K \= 0, 
	length(Poly, N).
degree([_|Poly], N) :- 
  	degree(Poly, N).
	
% ?- degree([4,2],X).

%%% Adds two polynomials.

plus([],[],[]).

plus([KA|PA], [KB|PB], [KS|PS]) :- 
  	length(PA, NA), length(PB, NB), NA > NB,
	plus(PA, [KB|PB], PS), KS is KA.

plus([KA|PA], [KB|PB], [KS|PS]) :- 
  	length(PA, NA), length(PB, NB), NA < NB,
	plus([KA|PA], PB, PS), KS is KB.

plus([KA|PA], [KB|PB], [KS|PS]) :- 
  	plus(PA, PB, PS), KS is KA + KB.
	
% ?- plus([1,2],[2,3],X).
% ?- plus([4,8],[5,5],[9,13]).

%%% Substracts two polynomials

minus([],[],[]).

minus([KA|PA], [KB|PB], [KS|PS]) :- 
	length(PA, NA), length(PB, NB), NA > NB,
	minus(PA, [KB|PB], PS), KS is KA.
	
minus([KA|PA], [KB|PB], [KS|PS]) :- 
	length(PA, NA), length(PB, NB), NA < NB,
	minus([KA|PA], PB, PS), KS is -KB.
	
minus([KA|PA], [KB|PB], [KS|PS]) :- 
	minus(PA, PB, PS), KS is KA - KB.

% ?- minus([5,2],[3],[5,-1]).
% ?- minus([5],[3],[2]).

%%% Multiplies two polynomials

times([],[],[]).
times([KA],[KB],[KS]) :-
    !,
    KS is KA * KB.
times([KA],[KB|PB],[KS|PS]) :-
    !,
    KS is KA * KB,
    times([KA],PB,PS).
times([KA|PA],PB,KS) :-
    times([KA],PB,AS),
    times(PA,[0|PB],BS),
    times_plus(AS,BS,KS).
times_plus([],KB,KB) :- !.
times_plus(KA,[],KA) :- !.
times_plus([KA|PA],[KB|PB],[KS|PS]) :-
    times_plus(PA,PB,PS),
    KS is KA + KB.
    
% ?- times([4,5,6],[5,2],X).
% ?- times([23,2,1],[5,12],[115, 286, 29, 12]).

%%% Applies Horner's method to a polynomial

horner([], _, 0).

horner([K|P], X, R):-
	horner(P,X,RA),
	R is RA * X + K.
	
% ?- horner([5,2],3,X).
% ?- horner([61,2,24],5,671).
	
reverse([], P, P).
reverse([K|P], RP, A) :-
    reverse(P, RP, [K|A]).

%%% Evaluate polynomial P with X and output R

evaluate(P, X, R) :-
    reverse(P, PR),
    horner(PR, X, R).

%%% Differentiate polynomials

differentiate([K|P], [KR|PR]) :-
    length([K|P], D),
    diff([K|P], D, [KR|PR]).

diff(_, D, []) :-
    D =:= 1.

diff([K|P], D, [KR|PR]) :-
    diff(P, D - 1, PR),
    KR is (D - 1) * K.

% ?- differentiate([3,2,5],X).
% ?- differentiate([3,2,5],

%%% Prints the polynomial

%%% We assume a polynomial starts with
%%% the highest power with a non-zero coefficient 
%%% associated with it, therefore for this function
%%% polynomials that 'start' with 0 will have two
%%% possible answers
%%% e.g. ?- printPoly([0,0,-2,11]).
%%% will give as an answer both -2x + 11 and 0x^3 -2x + 11.
%%% This implementation, therefore, assumes that polynomials
%%% must start with a coef. different than zero.

printPoly([]).
printPoly([K|P]) :-
    length([K|P], E),
    L is E,
    spp([K|P], E, L).
spp(_, E, _) :-
    E =:= 0.
spp([K|P], E, L) :-
    K =:= 0,
    spp(P, E - 1, L).
spp([K], E,_) :-
    E =:= 1,
    K < 0,
    format(' ~D', K).
spp([K], E, _) :-
    E =:= 1,
    K > 0,
    format(' + ~D', K).
spp([K|P], E, L) :-
    L =:= 2,
    format('~Dx', K),
    spp(P, E - 1, L),
    !.
spp([K|P], E, L) :-
    E =:= 2,
    K > 0,
    format(' + ~Dx', K),
    spp(P, E - 1, L).
spp([K|P], E, L) :-
    E =:= 2,
    K < 0,
    format(' ~Dx', K),
    spp(P, E - 1, L).
spp([K|P], E, L) :-
    L =:= E,
    format('~Dx^~D',[K, E - 1]),
    spp(P, E - 1, L),
    !.
spp([K|P], E, L) :-
    E > 2,
    K > 0,
    format(' + ~Dx^~D',[K, E - 1]),
    spp(P, E - 1, L),
    !.
spp([K|P], E, L) :-
    E > 2,
    K < 0,
    format(' ~Dx^~D',[K, E - 1]),
    spp(P, E - 1, L),
    !.

% ?- printPoly([-4,-3,-2,-1]).
% ?- printPoly([-4,-3,2,-1]).
% ?- printPoly([108,0,567,0,996,0,586]).

comp([],_,[]):-!.
comp([Wa|X],Z,W):-
    comp(X,Z,Tr),
    comp_2(Z,Tr,Pr),
    comp_3([Wa],Pr,W),
    !.
comp_1([],_,[]):-
    !.
comp_1([Wa|X], Rr, [Wc|W]) :-
   Wc is Wa*Rr,
   comp_1(X, Rr, W).
comp_2(_,[],[]):-
    !.
comp_2(X,[Wb|Z], W) :-
   comp_2(X,Z, Uu), 
   comp_1(X, Wb, Rr), 
   comp_3(Rr, [0|Uu], W), 
   !. 
comp_3(X,[],X) :- 
    X = [_|_].
comp_3([],Z,Z):- 
    !.
comp_3([Wa|X], [Wb|Z], [Wc|W]) :-
   Wc is Wa + Wb,
   comp_3(X,Z,W).

%?-comp([6,3,1,2],[9,5,3],C).


%%% Pruebas polynomials.java

% ?- printPoly([4,3,2,1]).
% ?- printPoly([3,0,5]).
% ?- plus([4,3,2,1],[3,0,5],X),printPoly(X).
% ?- times([4,3,2,1],[3,0,5],X),printPoly(X).
% ?- comp([4,3,2,1],[3,0,5],X).
% ?- minus([0],[4,3,2,1],X),printPoly(X).
% ?- evaluate([4,3,2,1],3,X).
% ?- differentiate([4,3,2,1],X),printPoly(X).
% ?- differentiate([4,3,2,1],X),differentiate(X,Y),printPoly(Y).

main:-
	write("zero(x)     = 0"),
	!,nl,
	write("p(x)        = "),printPoly([4,3,2,1]),
	!,nl,
	write("q(x)        = "),printPoly([3,0,5]),
	!,nl,
	write("p(x)+q(x)   = "),plus([4,3,2,1],[3,0,5],X), printPoly(X),
        !,nl,
	write("p(x)*q(x)   = "),times([4,3,2,1],[3,0,5],Y),printPoly(Y),
	!,nl,
	write("p(q(x))     = "),comp([4,3,2,1],[3,0,5],C),printPoly(C),
	!,nl,
	write("0-p(x)      = "),minus([0],[4,3,2,1],M),printPoly(M),
	!,nl,
	write("p(3)        = "),evaluate([4,3,2,1],3,B),write(B),
	!,nl,
	write("p'(x)       = "),differentiate([4,3,2,1],D),printPoly(D),
	!,nl,
	write("p''(x)      = "),differentiate([4,3,2,1],R),differentiate(R,J),printPoly(J),
        !,nl.
