Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8308311187;
	Thu,  5 Dec 2024 08:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733388126; cv=none; b=RjDEMItJRP1kYoCf0MqM1ZmgRrQ7eiozLoM68CjdgLRP9UoiFUuKA6oKrOxT7uvDrAvivsg32/kGGEJeIjKqbvRb4pxD4LPzy6n2sWcGRWDz+4fSKPKcHKtnlu2TCs+g0Qn2o1byW4vVpnHq6lWk9m7em/oHmlZvuzMigT/XbqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733388126; c=relaxed/simple;
	bh=K2XVuwkWj4x2vRF5UcLRYoQFukIVJv9muDblx/R+Fx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpPPI0XOOQD8m5C0OkSfEnD1sL4kdhU/eatmdX58daDJ0t3s0jKgfAyILRYZj0Gp8aShOgMvCoxLlqIdCqiKvoos9kZ4761U28wdBlgeJNmB3N70Uthf0DZXVRZ+CiELWimFi9NNA1ocxHk4NDDJSVkPYQsDIjK7aQ9QyIuO+wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jM7wkGMk; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jM7wkGMk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DFdPo6fbjzdhugCh7Y3iyZ8/q3+c6id6vD9TWfAIVks=; b=jM7wkGMkR86xEFziHjQYDtUtCF
	c4vKqaE+9eDjTfCXBFSj9+kVSUeoWgbd5DyPgS4q8DxV1pe9bM2eWZnLiMYYQ28pGeGMq4C92f98s
	t0eoRNxmITymMBxJNU4PcRn9DAmqiES66l8C2MfZ8Tja6aK/BEagv8PvxQ4m7LDG0cuLFMnPE6foS
	EFUyJnI50JCkEKsbhNYUMl3XFNVmN6Dd81/kzQBjY524YbD/ZRaNd+Z57Tq+9+x8Xn0cL7MD7J3/4
	GEYyCsH5uwQV1A1YPibaMVBEq4fv15gheMBNghbxjvnihW9RAfkzPBEWv5Ls2bA4xmyy8k9luoPH7
	9vpkAEKQ==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tJ7QN-0000000ClHP-2tps;
	Thu, 05 Dec 2024 08:41:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2E0E630040C; Thu,  5 Dec 2024 09:41:28 +0100 (CET)
Date: Thu, 5 Dec 2024 09:41:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	will@kernel.org, vgupta@kernel.org, urezki@gmail.com,
	tsbogend@alpha.franken.de, tglx@linutronix.de, surenb@google.com,
	song@kernel.org, shorne@gmail.com, rostedt@goodmis.org,
	richard@nod.at, palmer@dabbelt.com, oleg@redhat.com,
	mpe@ellerman.id.au, monstr@monstr.eu, mingo@redhat.com,
	mhiramat@kernel.org, mcgrof@kernel.org, mattst88@gmail.com,
	mark.rutland@arm.com, luto@kernel.org, linux@armlinux.org.uk,
	Liam.Howlett@oracle.com, kent.overstreet@linux.dev,
	kdevops@lists.linux.dev, johannes@sipsolutions.net,
	jcmvbkbc@gmail.com, hch@lst.de, guoren@kernel.org,
	glaubitz@physik.fu-berlin.de, geert@linux-m68k.org,
	dinguyen@kernel.org, deller@gmx.de, dave.hansen@linux.intel.com,
	christophe.leroy@csgroup.eu, chenhuacai@kernel.org,
	catalin.marinas@arm.com, bp@alien8.de, bcain@quicinc.com,
	arnd@arndb.de, ardb@kernel.org, andreas@gaisler.com
Subject: Re: [merged mm-stable]
 x86-module-prepare-module-loading-for-rox-allocations-of-text.patch removed
 from -mm tree
Message-ID: <20241205084128.GH8562@noisy.programming.kicks-ass.net>
References: <20241106010048.77E63C4CED1@smtp.kernel.org>
 <ZysRwR29Ji8CcbXc@kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZysRwR29Ji8CcbXc@kernel.org>

On Wed, Nov 06, 2024 at 08:50:41AM +0200, Mike Rapoport wrote:
> Hi Andrew,
> 
> Yesterday Nathan discovered and I fixed another small issue with fineibt.
> I suspect it's too late to add this as a fixup, so here's a formal patch
> with the fix.
> 
> From b31fd8493c4e1b6042776642a812690f16575b51 Mon Sep 17 00:00:00 2001
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Date: Tue, 5 Nov 2024 10:49:57 +0200
> Subject: [PATCH] x86/alternatives: fix writable address in cfi_rewrite_endbr()
> 
> Commit a159950eb69f ("x86/module: prepare module loading for ROX
> allocations of text") missed the offset that should be added to the
> writable address passed to poison_endbr() from cfi_rewrite_endbr() and
> this causes boot failures on kernels running with cfi=fineibt on
> machines that support IBT.
> 
> Add required offset to wr_addr argument to fix the issue.
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Fixes: a159950eb69f ("x86/module: prepare module loading for ROX allocations of text")
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/x86/kernel/alternative.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 3407efc26528..243843e44e89 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -1241,7 +1241,7 @@ static void cfi_rewrite_endbr(s32 *start, s32 *end, struct module *mod)
>  		void *addr = (void *)s + *s;
>  		void *wr_addr = module_writable_address(mod, addr);
>  
> -		poison_endbr(addr+16, wr_addr, false);
> +		poison_endbr(addr + 16, wr_addr + 16, false);
>  	}
>  }

So... *sigh*. I had to rebase quite a few patches on top of this, and
while doing do I got quite annoyed at how messy all this is, so I
cleaned it all up.

Only to find out that it's all broken, even with the above fix (my ADL
will currently die when it tries to load a module).

So it's a good thing these patches got an ack from the x86 people I
suppose :-(((

Anyway, while noodling with all that, I think there's a fairly
fundamental error in all of this. The mem->rw_copy should not be a whole
second allocation, it should be a (page granular) RW alias of the
(large) ROX map.

That also gets rid of that whole copy operation.

I'm having to chase a few regressions of my own first, but after that
I'll look at reworking all this.
