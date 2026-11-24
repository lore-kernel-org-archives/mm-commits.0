Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795536172;
	b=a5ZQwpiDmaKOT45/2pPAxjMPovj1ghmR7qA+kNA5nYEb/DnqVnbJfX6NFqFb/DKqDXTh
	 kGOoho48JzEV5GulcT3rEeJyXX84YMiugbRQi4ynBU2FXZuAnNHIbTI7/qzbopuPryLpr
	 kHnOaQG+pvNu8wfPaFxj2jzMrCJ0eqvTfNxlD+qL6z+oqNoqZUk3EBE/xxU3FylJV7w6l
	 O/Ubg/jVjLsG+t6rZ6iJ7ibzfQhuQpAGxnF0qOX1t/YekONqO+jKAfItu71NUdoB8dVGR
	 s9zDkUKazQvwMvF3G+QF4fttTdiajShWGdtnAJCfn4ETETOGy6rosdQy5W0LZBAc8lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536172;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=AiZLtA/3YMgR6YZc3hcO/tiSfg7h3YiULHCkBE637o8=;
	b=J1V0FG6WFbRxuc8tpq7Swsz2E4tgZmQPaCpMoGCp3fl4jCNC2ZWtSjqvQbMtlYUVGRCi
	 gSeturuFQ9Kwdj8wUYn2FnmqLr9Ft+ESVSu3NwjZgQSGLuFKCFyaKRUt9NA6eiRMSFN7Y
	 XhAfMKWtCJx3gn7ep9lNrxZ7jl7MuXXk5qskpopsk9paLLsbz+6q+XYPaN+vkXQ/+ZMJb
	 /N1h18ARgpYQokH142tP1jojW3WyLUmgOkkRhMKvgTIVsofYLjXEU2DKL6//d43zaBqld
	 NGNpoQUjSkElPrBXnpweQ41s3WVr6Qh0uUrw8y9KGbQYnisqR9b/n/cbMmQzZnTUz+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INNJCb92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D207606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INNJCb92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318D11F000EB;
	Tue, 24 Nov 2026 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536171;
	bh=AiZLtA/3YMgR6YZc3hcO/tiSfg7h3YiULHCkBE637o8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=INNJCb92BCPMoeQ/s4NhkF2nZaTJFjgvUpD5wG9n1i7TV4Aya9aB3wnFjILth/kJE
	 R4g8yiMCnb2oddKPa67H+BG5mL+LIB0C+bQPBnj1UcUvo0ZjT7N87oNYcIwZXryuSp
	 +mX9J1k9rKjaCt+m+C4D/ERKuXNw+lgo/x4VU+MxHur1JIjj8EaNdMnFbWwWpvspr5
	 l4sPkne+H308Ai/Zr3prs5rDdo/U5qoaGdeE/vLpDdjhNnZeJax0ixfEqhS0eiDTb3
	 My5Xpj2Hu/eQZUbDXEpV0nIHGVxFoCRNvqnPSyRHy5qkKGpMQnaVzdpG3hd2hlU2hY
	 yPp99kzZ6RUeg==
Date: Tue, 24 Nov 2026 18:02:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
Message-ID: <awW1JUdzBHiL4Kuf@kernel.org>
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
 <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
 <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
 <7ebcd1fe-8a98-4c12-9508-0399570e6a6d@kernel.org>
 <f2dc7958-638d-45f8-845b-a35b50355988@kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2dc7958-638d-45f8-845b-a35b50355988@kernel.org>

On Tue, Nov 24, 2026 at 10:54:04AM +0100, David Hildenbrand (Arm) wrote:
> On 11/24/26 10:49, Vlastimil Babka (SUSE) wrote:
> > On 11/24/26 09:22, David Hildenbrand (Arm) wrote:
> >> On 11/19/26 11:07, Vlastimil Babka (SUSE) wrote:
> >>>
> >>> Seems it is, thanks a lot!
> >>>
> >>>
> >>> Yes "just to the original" is what I meant.
> >>>
> >>>
> >>> Yeah. After all, the same is true for lore.kernel.org :)
> >>
> >> I works but it makes b4 go nuts when I try to pick something that Andrew picked (too ;) ) early.
> > 
> > Hmm wonder if there's a way to make b4 filter those out, or we ask
> > Konstantin to add that way.
> 
> One has to use --single-message, but that won't work on multi-patch series.
> Maybe "-P 1-3" etc will work.

Not sure it'll still work with -M or -H though
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.
