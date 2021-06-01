Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEFCC47082
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DC86124B
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhFAAy5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 20:54:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232207AbhFAAy4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 20:54:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622508795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4izayN94HGuQOQ/Ud+m0xYFXjoPm0n5/1ThzbgI75Pk=;
        b=V96UYEC6MMISue0/HdK51dc5G4iTin9xDuejyBhtW2Elu/0GiRfN/g3ZiDS4Z6QRjdteL7
        O5ga96S8+mJsHv65TtV9fLFd4PT6RfuWCNzmzl5ju9YQ7Qx9NRBp4pgH2s+z4Rr8Y7/WJu
        p0xmVeQmdHTDqKTxNmfv2RMvKaNgfR4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-yWQMKUJ6PoWtwY1Yss2jEg-1; Mon, 31 May 2021 20:53:14 -0400
X-MC-Unique: yWQMKUJ6PoWtwY1Yss2jEg-1
Received: by mail-qk1-f199.google.com with SMTP id a24-20020a05620a1038b02902fa6ba180ffso2105371qkk.0
        for <mm-commits@vger.kernel.org>; Mon, 31 May 2021 17:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4izayN94HGuQOQ/Ud+m0xYFXjoPm0n5/1ThzbgI75Pk=;
        b=bEe369yvlen7q+8xqBpG5DqOaQ7Rgi6YMCWLFB2PkqX+7YlnSQH8FsymveHWmFJbej
         cfIPfUNnAAEJWPQjNxmZOExqwvKNIaPC9r07u83Rl8POVGdfrtcdNq0XpvwdrcPY0W+Q
         ylyPBwRdJYMHZOTmUHRYBwjyHsZgNBkNzmYpD5kGd4nBhHmPeqvaJBy3qjbDXh6fLhVK
         B4auPkYQ1B3jy2rMA1CIaOiJbP8FuXuIjaR4DEI5elo3+WZvnFNTC45X96U3QKp1KoVA
         09pbVgS21echIS9iqXgyMSXXdT3ziXUYdgH5/aJST+OU3oY88vRMgYiT+gSlxyi/dJ4k
         OMsw==
X-Gm-Message-State: AOAM531Aub2Pa0DzwstWCO99N9w+ru4db8cVBgI6SRrVU1HSVz38x2AA
        zUaVzjcFPU3sWk9P2l02vjOJl2ASTJQl9HB2KuyvCjK4pBkNw9edHBPmYc8i+IfKJtNHDrSi17+
        IUn7V0Ur5KlutwaHn0qHwkg==
X-Received: by 2002:a0c:dc07:: with SMTP id s7mr19621932qvk.26.1622508792741;
        Mon, 31 May 2021 17:53:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLjLBgR/g/q99zc/jPdTMmp4yawokAUQg33ycFrMM3aUEPrxBS9I0ujQZmpie793k+iyPCpw==
X-Received: by 2002:a0c:dc07:: with SMTP id s7mr19621908qvk.26.1622508792348;
        Mon, 31 May 2021 17:53:12 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id e5sm9285260qtg.96.2021.05.31.17.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:53:11 -0700 (PDT)
Date:   Mon, 31 May 2021 20:53:10 -0400
From:   Peter Xu <peterx@redhat.com>
To:     akpm@linux-foundation.org
Cc:     aarcange@redhat.com, eugenis@google.com, kostyak@google.com,
        mm-commits@vger.kernel.org, pcc@google.com
Subject: Re: +
 mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch added to -mm
 tree
Message-ID: <YLWE9q/I/ltB41vI@t490s>
References: <20210601004009.GHBJsNnLk%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210601004009.GHBJsNnLk%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, May 31, 2021 at 05:40:09PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> has been added to the -mm tree.  Its filename is
>      mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Peter Collingbourne <pcc@google.com>
> Subject: mm: improve mprotect(R|W) efficiency on pages referenced once
> 
> In the Scudo memory allocator [1] we would like to be able to detect
> use-after-free vulnerabilities involving large allocations by issuing
> mprotect(PROT_NONE) on the memory region used for the allocation when it
> is deallocated.  Later on, after the memory region has been "quarantined"
> for a sufficient period of time we would like to be able to use it for
> another allocation by issuing mprotect(PROT_READ|PROT_WRITE).
> 
> Before this patch, after removing the write protection, any writes to the
> memory region would result in page faults and entering the copy-on-write
> code path, even in the usual case where the pages are only referenced by a
> single PTE, harming performance unnecessarily.  Make it so that any pages
> in anonymous mappings that are only referenced by a single PTE are
> immediately made writable during the mprotect so that we can avoid the
> page faults.
> 
> This program shows the critical syscall sequence that we intend to use in
> the allocator:
> 
>   #include <string.h>
>   #include <sys/mman.h>
> 
>   enum { kSize = 131072 };
> 
>   int main(int argc, char **argv) {
>     char *addr = (char *)mmap(0, kSize, PROT_READ | PROT_WRITE,
>                               MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>     for (int i = 0; i != 100000; ++i) {
>       memset(addr, i, kSize);
>       mprotect((void *)addr, kSize, PROT_NONE);
>       mprotect((void *)addr, kSize, PROT_READ | PROT_WRITE);
>     }
>   }
> 
> The effect of this patch on the above program was measured on a
> DragonBoard 845c by taking the median real time execution time of 10 runs.
> 
> Before: 2.94s
> After:  0.66s
> 
> The effect was also measured using one of the microbenchmarks that we
> normally use to benchmark the allocator [2], after modifying it to make
> the appropriate mprotect calls [3].  With an allocation size of 131072
> bytes to trigger the allocator's "large allocation" code path the
> per-iteration time was measured as follows:
> 
> Before: 27450ns
> After:   6010ns
> 
> This patch means that we do more work during the mprotect call itself in
> exchange for less work when the pages are accessed.  In the worst case,
> the pages are not accessed at all.  The effect of this patch in such cases
> was measured using the following program:
> 
>   #include <string.h>
>   #include <sys/mman.h>
> 
>   enum { kSize = 131072 };
> 
>   int main(int argc, char **argv) {
>     char *addr = (char *)mmap(0, kSize, PROT_READ | PROT_WRITE,
>                               MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>     memset(addr, 1, kSize);
>     for (int i = 0; i != 100000; ++i) {
>   #ifdef PAGE_FAULT
>       memset(addr + (i * 4096) % kSize, i, 4096);
>   #endif
>       mprotect((void *)addr, kSize, PROT_NONE);
>       mprotect((void *)addr, kSize, PROT_READ | PROT_WRITE);
>     }
>   }
> 
> With PAGE_FAULT undefined (0 pages touched after removing write
> protection) the median real time execution time of 100 runs was measured
> as follows:
> 
> Before: 0.330260s
> After:  0.338836s
> 
> With PAGE_FAULT defined (1 page touched) the measurements were
> as follows:
> 
> Before: 0.438048s
> After:  0.355661s
> 
> So it seems that even with a single page fault the new approach is faster.
> 
> I saw similar results if I adjusted the programs to use a larger mapping
> size.  With kSize = 1048576 I get these numbers with PAGE_FAULT undefined:
> 
> Before: 1.428988s
> After:  1.512016s
> 
> i.e. around 5.5%.
> 
> And these with PAGE_FAULT defined:
> 
> Before: 1.518559s
> After:  1.524417s
> 
> i.e. about the same.
> 
> What I think we may conclude from these results is that for smaller
> mappings the advantage of the previous approach, although measurable, is
> wiped out by a single page fault.  I think we may expect that there should
> be at least one access resulting in a page fault (under the previous
> approach) after making the pages writable, since the program presumably
> made the pages writable for a reason.
> 
> For larger mappings we may guesstimate that the new approach wins if the
> density of future page faults is > 0.4%.  But for the mappings that are
> large enough for density to matter (not just the absolute number of page
> faults) it doesn't seem like the increase in mprotect latency would be
> very large relative to the total mprotect execution time.
> 
> Link: https://lkml.kernel.org/r/20210527190453.1259020-1-pcc@google.com
> Link: https://linux-review.googlesource.com/id/I98d75ef90e20330c578871c87494d64b1df3f1b8
> Link: [1] https://source.android.com/devices/tech/debug/scudo
> Link: [2] https://cs.android.com/android/platform/superproject/+/master:bionic/benchmarks/stdlib_benchmark.cpp;l=53;drc=e8693e78711e8f45ccd2b610e4dbe0b94d551cc9
> Link: [3] https://github.com/pcc/llvm-project/commit/scudo-mprotect-secondary2
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Cc: Kostya Kortchinsky <kostyak@google.com>
> Cc: Evgenii Stepanov <eugenis@google.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/mprotect.c |   29 ++++++++++++++++++++++++-----
>  1 file changed, 24 insertions(+), 5 deletions(-)
> 
> --- a/mm/mprotect.c~mm-improve-mprotectrw-efficiency-on-pages-referenced-once
> +++ a/mm/mprotect.c
> @@ -35,6 +35,29 @@
>  
>  #include "internal.h"
>  
> +static bool may_avoid_write_fault(pte_t pte, struct vm_area_struct *vma,
> +				  unsigned long cp_flags)
> +{

Andrew,

As raised in the original patch, IMHO we'd better add below:

        if (cp_flags & MM_CP_PROT_NUMA)
                return false;

Peter Collingbourne, could you confirm?

Thanks,

> +	if (!(cp_flags & MM_CP_DIRTY_ACCT)) {
> +		if (!(vma_is_anonymous(vma) && (vma->vm_flags & VM_WRITE)))
> +			return false;
> +
> +		if (page_count(pte_page(pte)) != 1)
> +			return false;
> +	}
> +
> +	if (!pte_dirty(pte))
> +		return false;
> +
> +	if (!pte_soft_dirty(pte) && (vma->vm_flags & VM_SOFTDIRTY))
> +		return false;
> +
> +	if (pte_uffd_wp(pte))
> +		return false;
> +
> +	return true;
> +}
> +
>  static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
>  		unsigned long addr, unsigned long end, pgprot_t newprot,
>  		unsigned long cp_flags)
> @@ -43,7 +66,6 @@ static unsigned long change_pte_range(st
>  	spinlock_t *ptl;
>  	unsigned long pages = 0;
>  	int target_node = NUMA_NO_NODE;
> -	bool dirty_accountable = cp_flags & MM_CP_DIRTY_ACCT;
>  	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
>  	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
>  	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> @@ -132,11 +154,8 @@ static unsigned long change_pte_range(st
>  			}
>  
>  			/* Avoid taking write faults for known dirty pages */
> -			if (dirty_accountable && pte_dirty(ptent) &&
> -					(pte_soft_dirty(ptent) ||
> -					 !(vma->vm_flags & VM_SOFTDIRTY))) {
> +			if (may_avoid_write_fault(ptent, vma, cp_flags))
>  				ptent = pte_mkwrite(ptent);
> -			}
>  			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
>  			pages++;
>  		} else if (is_swap_pte(oldpte)) {
> _
> 
> Patches currently in -mm which might be from pcc@google.com are
> 
> mm-improve-mprotectrw-efficiency-on-pages-referenced-once.patch
> 

-- 
Peter Xu

