Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEC9C47087
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 02:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E6C6142B
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 02:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhEZCZj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 22:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhEZCZj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 May 2021 22:25:39 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C86C061574
        for <mm-commits@vger.kernel.org>; Tue, 25 May 2021 19:24:07 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id w127so63814oig.12
        for <mm-commits@vger.kernel.org>; Tue, 25 May 2021 19:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=T84rHy8b2gILU5iUPU6rpIRDsgXvXzuYN6WArYnc3Y4=;
        b=iimJt0xP4IThKrNmSPZnILx98iXIrci2RPRpU/R0TZLwif7GhIAKFEqXRmgbj1zdfh
         OKEvRGskVfyOtmDxn41begmJT2MGFanJ+XyP7hhjFC5d874X3gMwKDnXK2BaLdT3qd2C
         Xz3C+jFh9i1DP+kh/BdwT7RtRFOIlLj2jf+/kXR6EOPN97alUSDbcLA/pyEvlPqrTufV
         69fNtGnbbhGz21bIFTlDgE7MZfUhg1sSh+/fjt+ZRdworCZrGEzBwQq9Wpa+a+Kb3usD
         1GUzpRAYruxkNXj5E6hicG3Mdev3LFbL2fJSNTzCNNUbX52b4NHhd7oMym69OH8Yl/IN
         Z02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=T84rHy8b2gILU5iUPU6rpIRDsgXvXzuYN6WArYnc3Y4=;
        b=Z8+n4EeO5Zdt9gqxTeoWW+n2W160R+NXOpUfpy7paUqERHZBI6b5UPPGqfzqc6q1Y/
         UZl2Z/4jXgdo3kaWU6Cj7t0KxvJ0CA0fBU22TdT48Uag6ConVPyzqlyFJjBpRLlbMJt9
         y4wWDQ7532TpUp6gqWEsEqMyaUyPK7USHf3wjTKnk552UQh/yvrzt6ibM7xG+LA7JUgk
         CfCcpNsUz6vhid3S+3wokaVwsMrvK/2PpIeAzHXEwZCrmrY6fuvWfdL0h5uUeRLVOvey
         uOCIpzNUzW2m+D9X7IFHZD5CRBav495BY7e09OqYPx/RCJMhcqySJqIiMeEwzqXoun8s
         SBXg==
X-Gm-Message-State: AOAM531hLEJnCXDHGVsegHvCXCJNut0xlKvGoSQmrgY5+MmCEOxILDvL
        tVD+OKiksp0b1XA0ItRT0rBKFw==
X-Google-Smtp-Source: ABdhPJzwpXkXANlOnX7oRWa3OdmqDfoxf4XO/xwf2QiHAk26xIRjXIcQDxe5VIZ8a6uaFFQtbC0oCw==
X-Received: by 2002:a05:6808:1414:: with SMTP id w20mr395938oiv.136.1621995846653;
        Tue, 25 May 2021 19:24:06 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id d67sm3529698oia.56.2021.05.25.19.24.05
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Tue, 25 May 2021 19:24:06 -0700 (PDT)
Date:   Tue, 25 May 2021 19:23:53 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Andrew Morton <akpm@linux-foundation.org>
cc:     hughd@google.com, kirill.shutemov@linux.intel.com, lkp@intel.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, wangyugui@e16-tech.com, ziy@nvidia.com,
        apopple@nvidia.com
Subject: Re: + mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
 added to -mm tree
In-Reply-To: <20210526012553.qZEltjyeb%akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.11.2105251846400.10373@eggly.anvils>
References: <20210526012553.qZEltjyeb%akpm@linux-foundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 25 May 2021, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix
> has been added to the -mm tree.  Its filename is
>      mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
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
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix
> 
> fix the fix
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: kernel test robot <lkp@intel.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Wang Yugui <wangyugui@e16-tech.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I think this is the wrong way to go about it: since Yang Shi has a
replacement on the way, so it's not worth fix-fix-fixing the original;
and since this "fix" implies (I think) that mmotm's series file is
ordered with Yang's patch coming after Alistair's nouveau rmap rewrite.

Unfortunate timing. But I contend that we are going to want Yang's and
my fixes (I've extracted relevant Google fixes into a series against
5.13-rc, that I'm working to post in a few days) go into 5.13-rc and
backported to stable releases.  You'd be right to point out that they
are not fixing any regression new to 5.13: maybe you'll prefer them
to wait until 5.14-rc; but even then they will need to be backported.

The nouveau rmap reorganization adds another layer of backporting
difficulty: I think it's up to me to supply you with the relevant
adjustments to Alistair's patches on top of Yang's and mine - but
not before I'm satisfied with what I've assembled and posted it.

I suggest the right thing to do for the coming mmotm is to back out
Yang Shi's mm-thp-check-total_mapcount-instead-of-page_mapcount.patch
and its fixes, and give Alistair's nouveau series a spin.  But when
ready, insert Yang's and my THP fixes ahead of Alistair's series.

Thanks,
Hugh

> ---
> 
>  mm/huge_memory.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/mm/huge_memory.c~mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix
> +++ a/mm/huge_memory.c
> @@ -2352,7 +2352,7 @@ static void unmap_page(struct page *page
>  	VM_BUG_ON_PAGE(!PageHead(page), page);
>  
>  	if (PageAnon(page))
> -		unmap_success = try_to_migrate(page, ttu_flags);
> +		try_to_migrate(page, ttu_flags);
>  	else
>  		/*
>  		 * Don't install migration entries for file backed pages. This
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> mm-hugetlb-fix-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
> mm.patch
> mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
> mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
> mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
> binfmt-remove-in-tree-usage-of-map_executable-fix.patch
> mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
> powerpc-mm-book3s64-update-tlb-flush-routines-to-take-a-page-walk-cache-flush-argument-fix.patch
> mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
> mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
> mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
> mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
> mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix.patch
> mm-thp-check-total_mapcount-instead-of-page_mapcount-fix-fix-fix.patch
> nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
> mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
> kernelh-split-out-panic-and-oops-helpers-fix.patch
> lib-math-rational-add-kunit-test-cases-fix.patch
> lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
> linux-next-pre.patch
> linux-next-post.patch
> mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
> module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
> module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
