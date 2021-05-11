Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3035C433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F4E6162A
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhEKWGT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhEKWGS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:06:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 293C66186A;
        Tue, 11 May 2021 22:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620770712;
        bh=EFxtgroGz9auTpcofLPaQZ8q5BnH7gkTPkK44r6b9uc=;
        h=Date:From:To:Subject:From;
        b=SOJTCIMIC+Nlj3tS8HYgCGpohU9dPM8uxHiCC3LrlM/kMDqkZXcpQnl/5/GGRdRRQ
         mz/T82RrAkQklonqs0kSOMUH0aQqQPaWNUlnV9op3qOPiKQL1qRxyW3LEvG4xi5GZJ
         AiSQqb3qi6xnj4vwfmX0YszE0ipXCiCZpTPG/RUY=
Date:   Tue, 11 May 2021 15:05:10 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, aneesh.kumar@linux.ibm.com,
        anshuman.khandual@arm.com, david@redhat.com, hannes@cmpxchg.org,
        hughd@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rcampbell@nvidia.com, riel@surriel.com,
        shy828301@gmail.com, songliubraving@fb.com,
        william.kucharski@oracle.com, willy@infradead.org, ziy@nvidia.com
Subject:  + mm-huge_memoryc-use-page-deferred_list.patch added to
 -mm tree
Message-ID: <20210511220510.8_Iw_PIvM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: use page->deferred_list
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-use-page-deferred_list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-use-page-deferred_list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-use-page-deferred_list.patch

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
Subject: mm/huge_memory.c: use page->deferred_list

Now that we can represent the location of ->deferred_list instead of
->mapping + ->index, make use of it to improve readability.

Link: https://lkml.kernel.org/r/20210511134857.1581273-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-use-page-deferred_list
+++ a/mm/huge_memory.c
@@ -2868,7 +2868,7 @@ static unsigned long deferred_split_scan
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	/* Take pin on all head pages to avoid freeing them under us */
 	list_for_each_safe(pos, next, &ds_queue->split_queue) {
-		page = list_entry((void *)pos, struct page, mapping);
+		page = list_entry((void *)pos, struct page, deferred_list);
 		page = compound_head(page);
 		if (get_page_unless_zero(page)) {
 			list_move(page_deferred_list(page), &list);
@@ -2883,7 +2883,7 @@ static unsigned long deferred_split_scan
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 
 	list_for_each_safe(pos, next, &list) {
-		page = list_entry((void *)pos, struct page, mapping);
+		page = list_entry((void *)pos, struct page, deferred_list);
 		if (!trylock_page(page))
 			goto next;
 		/* split_huge_page() removes page from list on success */
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

