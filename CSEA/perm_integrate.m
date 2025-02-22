function [p] = perm_integrate(null_dist,observed)
% Integrates a null distribution of permutations to calculate p value
% Need to provide observed as the value in tail

    % make histogram of null distribution
    h = histogram(null_dist);
    b = h.BinEdges;
    bb = [];

    % get midpoints of left- and right-endpoints in histogram; this forms
    % abscissae of interpolated gaussian
    for j = 1:length(b) - 1, bb = [bb;(b(j + 1) + b(j))/2]; end    

    % if we have enough abscissae
    if length(bb) > 2

        % get ordinates of null distribution
        v = h.Values;
        v = v/sum(v);
    
        % fit gaussian
        f = fit(bb,v','gauss1');
        fun = @(x,a,b,c) a*exp(-1*((x-b)/c).^2);
        
        % integrate        
        p = integral(@(x) fun(x,f.a1,f.b1,f.c1),observed,inf,'RelTol',1e-4,'AbsTol',1e-6);   

    % else, skip p-value calculation
    else
        p = NaN;
    end
end
