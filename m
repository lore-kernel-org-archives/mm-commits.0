Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D69C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D05561919
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEKWG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhEKWG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCA26186A;
        Tue, 11 May 2021 22:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620770719;
        bh=SjOpnnEToQR5QnEQwle9qJm6dr5dQ6KDYzgvKAchMfk=;
        h=Date:From:To:Subject:From;
        b=Wx3BFDAzBg32+xFgFqucKAJqHis6MdoFQyEqMS0gGabdCcue4c5tfgVYqeabSfHJJ
         J+JggDmJO/b2cOQVv9hEWjq9f8HoaAZ/Fm60N9qpMbm4L1l45gn9e5Xcs3jaEKxcS0
         oY3xy3lMrwp+t5fAAe3rnjn+ZX4pBeV/6m/Pn17c=
Date:   Tue, 11 May 2021 15:05:17 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, david@redhat.com, hannes@cmpxchg.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, riel@surriel.com,
        shy828301@gmail.com, songliubraving@fb.com,
        william.kucharski@oracle.com, willy@infradead.org, ziy@nvidia.com
Subject:  +
 =?US-ASCII?Q?mm-huge=5Fmemoryc-remove-unnecessary-tlb=5Fremove=5Fpage=5F?=
 =?US-ASCII?Q?size-for-huge-zero-pmd.patch?= added to -mm tree
Message-ID: <20210511220517.Ur8P0hA14%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove unnecessary tlb_remove_page_size() for huge zero pmd
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: remove unnecessary tlb_remove_page_size() for huge zero pmd

Commit aa88b68c3b1d ("thp: keep huge zero page pinned until tlb flush")
introduced tlb_remove_page() for huge zero page to keep it pinned until
flush is complete and prevents the page from being split under us.  But
huge zero page is kept pinned until all relevant mm_users reach zero since
the commit 6fcb52a56ff6 ("thp: reduce usage of huge zero page's atomic
counter").  So tlb_remove_page_size() for huge zero pmd is unnecessary
now.

Link: https://lkml.kernel.org/r/20210511134857.1581273-5-linmiaohe@huawei.com
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd
+++ a/mm/huge_memory.c
@@ -1683,12 +1683,9 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		if (is_huge_zero_pmd(orig_pmd))
-			tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
 		zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		tlb_remove_page_size(tlb, pmd_page(orig_pmd), HPAGE_PMD_SIZE);
 	} else {
 		struct page *page = NULL;
 		int flush_needed = 1;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch

