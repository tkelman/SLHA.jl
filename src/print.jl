using Base.Cartesian

function show{label}(io::IO, m::MIME"text/plain",
                     block::SLHASimpleBlock{label, 1})
    @printf(io, "BLOCK %s Q= %+0.15E \n", label, block.scale)
    for n = 1:length(block.block)
        @printf(io, "%6d    % 0.15E \n",n, block.block[n])
    end
end

function show{label}(io::IO, m::MIME"text/plain",
                     block::SLHASimpleBlock{label, 2})
    @printf(io, "BLOCK %s Q= %+0.15E \n", label, block.scale)
    (nr,nc) = size(block.block)
    for c = 1:nc
        for r = 1:nr
            @printf(io, "%3d %2d    % 0.15E \n",r, c, block.block[r,c])
        end
    end
end

function show{label}(io::IO, m::MIME"text/plain",
                     block::SLHASimpleBlock{label, 3})
    @printf(io, "BLOCK %s Q= %+0.15E \n", label, block.scale)
    A = block.block
    @nloops 3 ind A begin
        @printf(io, "%3d %2d %2d % 0.15E \n", (@ntuple 3 ind)...,
                (@nref 3 A ind))
    end
end

# Why not... display arbitrary dim blocks. Only used for dim > 3
@generated function show{label, dim}(io::IO, m::MIME"text/plain",
                                     block::SLHASimpleBlock{label, dim})
    quote
        A = block.block
        @printf(io, "BLOCK %s Q= %+0.15E \n",label, block.scale)
        @nloops $dim ind A begin
            @printf(io, "%s % 0.15E \n",
                    string(map((n) -> @sprintf(" %2d", n),
                               (@ntuple $dim ind))...),
                    (@nref $dim A ind))
        end
    end
end

function show{label}(io::IO, m::MIME"text/plain", block::SLHADescBlock{label})
    println(io, "BLOCK $(label)")
    for (index, param) in block.block
        @printf(io, "%6d    %s \n", index, param)
    end
end

function show{label}(io::IO, m::MIME"text/plain",
                     block::SLHAParameterBlock{label})
    @printf(io, "BLOCK %s Q= %+0.15E \n",label, block.scale)
    for (index, param) in block.block
        @printf(io, "%6d    % 0.15E \n", index, param)
    end
end

function show{label}(io::IO, m::MIME"text/plain",
                     block::SLHANoScaleParameterBlock{label})
    println(io, "BLOCK $(label)")
    for (index, param) in block.block
        @printf(io, "%6d    % 0.15E \n", index, param)
    end
end

function show{label}(io::IO, m::MIME"text/plain", block::SLHASparseBlock{label})
    @printf(io, "BLOCK %s Q= %+0.15E \n",label, block.scale)
    rows = rowvals(block.block)
    vals = nonzeros(block.block)
    for col = 1:size(block.block, 2)
        for sparseind in nzrange(block.block, col)
            row = rows[sparseind]
            val = vals[sparseind]
            @printf(io, "%3d %2d    % 0.15E \n", row, col, val)
        end
    end
end

function show{label}(io::IO, m::MIME"text/plain",
                     block::SLHASingletonBlock{label})
    println(io, "BLOCK $(label)")
    @printf(io, "          % 0.15E \n", block.entry)
end

function show{T<:SLHABlock}(io::IO, m::MIME"text/plain", v::Array{T,1})
    for x in v
        show(io, m, x)
    end
end

function show{label}(io::IO, m::MIME"text/plain",
                     block::SLHAArbitraryBlock{label})
    if isnull(block.scale)
        println(io, "BLOCK $(label)")
    else
        @printf(io, "BLOCK %s Q= %+0.15E \n",label, block.scale)
    end
    for (index, param) in block.block
        for i in index
            @printf(" %2d", i)
        end
        @printf("    % 0.15E \n", param)
    end
end

