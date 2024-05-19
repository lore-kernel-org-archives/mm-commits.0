Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BB045038;
	Sun, 19 May 2024 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716143800; cv=none; b=V4aPB6CDG76dVVQQAuoC533URUVn33BVHy1RSHHzGhp/J2FE4DMAhANKANwmFvT8xzFyviEFFBCSmHegsNaMyfmj4mENeTJPT9wqgSDeB3Dyu/kXGNwY/bR8ycy+k2miZfCw2Owlprllj22AJfk9cxga6Jn54jdDP+oqwnnP4yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716143800; c=relaxed/simple;
	bh=UUhwXxqUPl7s1YkfVggMn/rNgFKLSx/iqaAxFo+gv7w=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=oos0A+CEhoHlKluqSyczOHi+cnxwsvuOWc3S21D+DhJ6qRoutalVvi1KSEZ3kCLFkacAvcbDR1vXqKfD+pZYvU6iY8gKKG4Km9hoQcKvz2bbOGhJJqjAxmttk+sFRGCmhRqcu7m6uRHTbvBcAgdqz0g8fM2OoEVFBQehW7qYh7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CpFm2ZzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CpFm2ZzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29884C32781;
	Sun, 19 May 2024 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716143800;
	bh=UUhwXxqUPl7s1YkfVggMn/rNgFKLSx/iqaAxFo+gv7w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CpFm2ZzTjT7bt9pUpITHxMxR/vtK7evZs57rWz3tBtSlm/XOEFX3G9m1K6CGPK+kv
	 1FoUOPWtfpQWYJY+33Zak7EMr76YRoJl/9/PXFfU+OvzXBuqc0uGOpScWZVZDwvIP/
	 d94OEdp8flElEddq31aS8tKpn+K3F8NFhhSU2orc=
Date: Sun, 19 May 2024 11:36:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
Message-Id: <20240519113639.db3fe5f80d25be4e7666751e@linux-foundation.org>
In-Reply-To: <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
	<CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 19 May 2024 08:32:44 -0700 Linus Torvalds <torvalds@linuxfoundation.org> wrote:

> On Fri, 17 May 2024 at 19:22, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > include/linux/slab.h
> >         https://lkml.kernel.org/r/20240429114302.7af809e8@canb.auug.org.au
> 
> This is not only a merge conflict, your tree is actively buggy.
> 
> You have introduced changes like this:
> 
>   -static inline __alloc_size(1, 2) void *kvcalloc(size_t n, size_t
> size, gfp_t flags)
>   -{
>   - return kvmalloc_array(n, size, flags | __GFP_ZERO);
>   -}
>   +#define kvcalloc(_n, _size, _flags) kvmalloc_array(_n, _size,
> _flags|__GFP_ZERO)
> 
> and that's just completely wrong. Note the "_flags|__GFP_ZERO": yes,
> the bitwise or is fairly low down in the operator precedence rules,
> and it probably work sin practice because most cases will just pass in
> a simple expression for the flags, but it's still *horribly* wrong.
> 
> I'm going to take this pull and fix up the cases I find, but I'm not
> happy with this kind of trivial C preprocessor misuse.

Thanks, I've asked Suren and Kent to check it all over.

> I also note that you have *SEVEN* pointless merges that have no
> explanation for them. I'm happy that you use git, but that means that
> you also need to either
> 
>  (a) not do merges at all and treat it as a patch queue
> 
>  (b) do merges _properly_ and not throw them around like some madman
> 
> And doing them properly means not only writing good commit messages,
> but actually having good reasons for them. As it is, we have
> 
>   5d1bc760583f ("merge mm-hotfixes-stable into mm-nonmm-stable to pick
> up needed changes")
>   640958fde130 ("Merge branch 'master' into mm-stable")
>   4e2e36129225 ("Merge branch 'master' into mm-stable")
>   1dd4505cf4c8 ("Merge branch 'master' into mm-stable")
>   71919308943d ("Merge branch 'master' into mm-stable")
>   b228ab57e51b ("Merge branch 'master' into mm-stable")
>   5e2806112864 ("Merge branch 'master' into mm-stable")

This is me advancing the master branch once per week until we hit -rc4.

I don't understand why these merges were visible to this pull.  I sent:

: The following changes since commit 5d1bc760583f225032f91bd88853f4c26acaf4e0:
: 
:   merge mm-hotfixes-stable into mm-nonmm-stable to pick up needed changes (2024-04-25 20:54:12 -0700)
: 
: are available in the Git repository at:
: 
:   git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2024-05-17-19-19
: 
: for you to fetch changes up to 76edc534cc289308130272a2ac28694fc9b72a03:
: 
:   memcg, oom: cleanup unused memcg_oom_gfp_mask and memcg_oom_order (2024-05-11 15:41:37 -0700)
: 

This has worked OK before,
