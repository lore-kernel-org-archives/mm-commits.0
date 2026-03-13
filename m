Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556323612F8;
	Fri, 13 Mar 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417421; cv=none; b=S02lwEnA1spwQ8ZC0NpC7mSKBqVjpsN2COw+EK1lv/F+6iwwlXHyVc2AkHXkB0kvo5LfEmfxCbe9o6DPrEpW34mOangW3CXG3OprHq7HvIooQm5x/fOMpnOhcxJhpd4zD/hfFwiG6IdW5guY7kzM69UauQ5uBzA+VhAUKbW162w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417421; c=relaxed/simple;
	bh=tjA6ZHT/H6XdYLS3N4cTOXtVHbMODEOoeLhKB14a7bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPH8Aj2s3po3hpkYt2I5SSYKk9Y4owzqTbwI6Z3rfLXeJcUFzcBZ+JrWD1lN2ZeY1hUj+mdhCZH7rqMZVkYkpH5fbBSK93EL3qCF5y+gi/+X5y/pWHE3/VISMMMhnMB7+BW63ETJ4rEtkdEdWmXrUEFAUoiNqMayrU+6QevkPoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+1BIWP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+1BIWP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C99EC2BC86;
	Fri, 13 Mar 2026 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773417420;
	bh=tjA6ZHT/H6XdYLS3N4cTOXtVHbMODEOoeLhKB14a7bQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+1BIWP3w2Wy1aOs+F+uTSwL1Zz95lt1mPri3UK53cHEYoVX613jcupREm4t4OMJ+
	 ktfEwfwbHVCo0slFJv1ONRP92feoyg7k2G6+xzaC7njZ/z/rtNyufennVditBVhCfb
	 Ouexahegue9TIQdq2Fq4daAnViNPXquNqIV9je783rJ5bVy+vvQEJIp8a8EoZaO2PG
	 o1DqqG5dGDkJ3niBswSUBBpvm2v5DeEinf0oDVaN3peZXaPBjOPOmUPveeMtpBnkHg
	 AkG44dCYIy5IDHWNY1+sxZGGPd0eJgrQSzKF5LxGo6EkdT9gfS+v9QKwy/mNi4ruJL
	 dNod1/R+snlMQ==
Date: Fri, 13 Mar 2026 15:56:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Vlastimil Babka <vbabka@suse.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>, mm-commits@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add Josh Law as reviewer for library code
Message-ID: <3808b95a-bccb-493b-8097-9b75eb40d9f3@lucifer.local>
References: <20260307221931.2848601-1-objecting@objecting.org>
 <3cd25de5-3737-49f4-aa8b-eaaee471af50@lucifer.local>
 <ee644e1b-5759-477f-8aec-35c91a5a938e@suse.com>
 <20260307222154.2848660-1-objecting@objecting.org>
 <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com>
 <20260313-anvisiert-gemeckert-352414e3d58d@brauner>
 <20260313-halskette-annahme-94e782eb4ae4@brauner>
 <01a6bbcc-1442-48c7-be5b-14f07fe655c9@lucifer.local>
 <28175752-2775-476d-9485-499335a99aea@gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28175752-2775-476d-9485-499335a99aea@gmail.com>

On Fri, Mar 13, 2026 at 03:51:24PM +0000, Josh Law wrote:
> Well, it's already been merged into linux-next, I will keep constantly trying to prove myself as a trusted figure in the community, and I am learning new things every day about the rules, and when you talk about me making "trivial" patches, I also made some medium sized bug fixes, yeah my start was just "janitor" code, but I will try to prove myself,

The patch is not being taken.

As I said, it's nothing personal, you shouldn't be seeking this 1 week into
contributing to the kernel.

Keep contributing and get to learn the rules and etiquette, and only think of
MAINTAINERS say a year or so afterwards.

I started contributing in ~2014 and was added to MAINTAINERS in 2023 I think?

There's no rush :)

Thanks, Lorenzo
