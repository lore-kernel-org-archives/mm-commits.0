Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D410B23FD00
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733921821; cv=none; b=tC/mKyaFqfHMR6lfu53f1g7RApyQ6mc/74QVmMsDMN9bNvSLC/jCEpa9gGjcL3H+jok3+Y4Oz94Aih3R6WBS5IwxIfMPRI//GHJ5gA32Yp8fgXPZKpFC0M4fNJulN+DOWMJ3vdYYSkGXVksaWwmES4iDxn5IKLcAWaq0nLu2PX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733921821; c=relaxed/simple;
	bh=tkOTaVE9WpkULN9c2cGn1LY05Ot0D0y8vCDvsmqBJ4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoAexTpECRLDqS9NvednsvaGpNx7yMRYvQA7L+SgANqtLPUX+KWh8iUfQ3nMALcIjt45sdMxmXQ7HHFo3/kP4MgPV8BDLIsAehbFM0g5wrSNa3PnmCp+SsW81eEbfW3z6o+XYdHefPJ7bmD2oHLtEyfKV8XQYFOMidnJSYx53mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OI0JcrlN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OI0JcrlN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YGRaAJeioZmWEKWecyvZdskpuTk/BPu1Zn8TgdIuYoM=; b=OI0JcrlNxelBjglRes0ytGSprI
	Kf3h8XPzcBcfgF3uJxQeLT5RC2N7ckL2cSmb2PLs/ECaUXXDPGY4wZZHEZP0+4ZwcLNMxsK6dKFfH
	q5UtX6SXIyk97O2bRzw4uepr526MfInYE3eWLxtBKNO/FXOYH34fiEGDRkZMbvWDKpZ1ln7l1NGXI
	lxGRph1eD4ggf+vZyzvUNejmBnKfnTnJ/QBK2KA/xhLn+7Q7NRCfUsgvva5KTEIj1kKZt4nRsupsj
	iVciWDANkeaBgDD5IXmEUwDGKhRY3lL6PaWreoYWz1JKIawChc9n1DKdrSFwX2KJAaGheEkH6FOmp
	8fDMgK0A==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLMGV-0000000G9h1-0vLM;
	Wed, 11 Dec 2024 12:56:32 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3C80030035F; Wed, 11 Dec 2024 13:56:30 +0100 (CET)
Date: Wed, 11 Dec 2024 13:56:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	zokeefe@google.com, willy@infradead.org, will@kernel.org,
	rientjes@google.com, peterx@redhat.com, muchun.song@linux.dev,
	mgorman@suse.de, luto@kernel.org, lorenzo.stoakes@oracle.com,
	jannh@google.com, hughd@google.com, david@redhat.com,
	dave.hansen@linux.intel.com, dan.carpenter@linaro.org,
	catalin.marinas@arm.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: + mm-pgtable-make-ptlock-be-freed-by-rcu.patch added to
 mm-unstable branch
Message-ID: <20241211125630.GT21636@noisy.programming.kicks-ass.net>
References: <20241211030932.4DA94C4CED6@smtp.kernel.org>
 <20241211091202.GS21636@noisy.programming.kicks-ass.net>
 <e8ec5fa7-8742-4e30-afbf-279d09c49d6c@bytedance.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8ec5fa7-8742-4e30-afbf-279d09c49d6c@bytedance.com>

On Wed, Dec 11, 2024 at 06:31:31PM +0800, Qi Zheng wrote:

> Now, it is also possible not to use the mmu gather mechanism to
> free PTE pages:
> 
> pte_free_tlb
> --> ___pte_free_tlb
>     --> pagetable_pte_dtor
> 	--> ptlock_free
>         paravirt_tlb_remove_table
> 	--> free PTE page
> 
> pte_free
> --> pagetable_pte_dtor
>     --> ptlock_free
>     pagetable_free
> 
> If we want to move the freeing of the ptlock into __tlb_remove_table(),
> we may need to define a pagetable_pte_dtor_no_ptlock() and let
> ___pte_free_tlb() to call it.
> 
> And ALLOC_SPLIT_PTLOCKS only be enabled when the spinlock debug function
> is turned on, so I finally choose to only change ptlock itself without
> changing the general path.

PREEMPT_RT will also have it on, and it feels a bit odd to have two
disparate RCU frees for something so very closely related.

We could push the whole of pagetable_*_dtor into tlb_remove_table(),
except that seems to cause trouble for p4d, which is not conforming.

Argh, all this is a giant trainwreck and needs some serious cleanup, and
I feel your patch is just making it worse.

Notably:

 - s390 pud isn't calling the existing pagetable_pud_[cd]tor()
 - none of the p4d things have pagetable_p4d_[cd]tor() (x86,arm64,s390,riscv)
   and they have inconsistent accounting
 - while much of the _ctor calls are in generic code, many of the _dtor
   calls are in arch code for hysterial raisins, this could easily be
   fixed
 - if we fix ptlock_free() to handle NULL, then all the _dtor()
   functions can use it, and we can observe they're all identical
   and can be folded

after all that cleanup, you can move the _dtor from *_free_tlb() into
tlb_remove_table() -- which for the above case, would then have it
called from __tlb_remove_table_free().

Thomas, you were looking for technical debt -- there's a ton of that
around here :/

