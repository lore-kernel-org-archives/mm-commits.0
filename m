Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED192210DB
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 09:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733908349; cv=none; b=TiB4M+x7wqJ519hgIlgpySvI9QO0+lkz0iH8/ByfLUi7FCIUKTFIDLE2abuEADp+bEqxt/Nn2hOIFbgjKymAnluOAsa7koFIGhrco7UtbaGRaDjyzZtBTK79HI0Z8ohRQIEmfpihxc/oQud5PIA/ob7qjEV3vem5YlMoRPyHPks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733908349; c=relaxed/simple;
	bh=0YdkpaX0gm3k6ZvsJ0lzhreqsC04S8VY5VZoSAySFg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dsm4V89/dxSJaj7gMGQzL2Dc7jpe9WauWz7ADbJYfG3M7b26p4EKdMZjU/lOUhMBumqCukEOZj5aM+5uZyd9JkO3EFyz7eQ0GzpN/98wK6C8gWVdggQgwcL6b82aMmfRjImhaLFVavl9/vYUTJRPBxvUr3vq2q4DcnWOgL4szh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qznDWpC/; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qznDWpC/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y3qMtEeg7tZQepEp11rf9zPOPHWiuE6yoxW3iCLDI8Y=; b=qznDWpC/6xeDsu302dM8eEJrBf
	VGwdIa1eorFsGC0GmSwZqOEzlTACGfH4wfyinCEF84JrmgOwY7vLUaxUYYHTFBd8JQpuRi3/iXG/s
	DDjhJdpWK2V+yFmVXNySVN7KisTxQ+pBu55kVlNHuRpDOjK198Mxk0Xzci+G8Rkm13OgsaFhUvPLK
	VothUMAP+JiThSKZnxWJ/gkYULKn/evOIste/GqhN+Lg8hftqKTwaCx3L+7wdd0b2h97gxtHivfYF
	gCT5X11gReaUHKsWGIAlSRP/LPv37DrLmaHrxmzUdL51Qj8W8UwpovPrwvPz8PwHYXXm1Hp4v54Ay
	XceP5OXg==;
Received: from 77-249-17-89.cable.dynamic.v4.ziggo.nl ([77.249.17.89] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIlH-00000003nk2-1pEl;
	Wed, 11 Dec 2024 09:12:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B35C730035F; Wed, 11 Dec 2024 10:12:02 +0100 (CET)
Date: Wed, 11 Dec 2024 10:12:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zokeefe@google.com, willy@infradead.org,
	will@kernel.org, rientjes@google.com, peterx@redhat.com,
	muchun.song@linux.dev, mgorman@suse.de, luto@kernel.org,
	lorenzo.stoakes@oracle.com, jannh@google.com, hughd@google.com,
	david@redhat.com, dave.hansen@linux.intel.com,
	dan.carpenter@linaro.org, catalin.marinas@arm.com,
	zhengqi.arch@bytedance.com
Subject: Re: + mm-pgtable-make-ptlock-be-freed-by-rcu.patch added to
 mm-unstable branch
Message-ID: <20241211091202.GS21636@noisy.programming.kicks-ass.net>
References: <20241211030932.4DA94C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211030932.4DA94C4CED6@smtp.kernel.org>

On Tue, Dec 10, 2024 at 07:09:31PM -0800, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm: pgtable: make ptlock be freed by RCU
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-pgtable-make-ptlock-be-freed-by-rcu.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-make-ptlock-be-freed-by-rcu.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
> 
> ------------------------------------------------------
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> Subject: mm: pgtable: make ptlock be freed by RCU
> Date: Tue, 10 Dec 2024 16:44:31 +0800
> 
> If ALLOC_SPLIT_PTLOCKS is enabled, the ptdesc->ptl will be a pointer and a
> ptlock will be allocated for it, and it will be freed immediately before
> the PTE page is freed.  Once we support empty PTE page reclaimation, it
> may result in the following use-after-free problem:
> 
> 	CPU 0				CPU 1
> 
> 					pte_offset_map_rw_nolock(&ptlock)
> 					--> rcu_read_lock()
> 	madvise(MADV_DONTNEED)
> 	--> ptlock_free (free ptlock immediately!)
> 	    free PTE page via RCU
> 					/* UAF!! */
> 					spin_lock(ptlock)
> 
> To avoid this problem, make ptlock also be freed by RCU.
> 
> Link: https://lkml.kernel.org/r/20241210084431.91414-1-zhengqi.arch@bytedance.com
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

UURGGH... why can't we move the freeing of the lock into
__tlb_remove_table() ?
