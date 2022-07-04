Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B33C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiGDBL7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiGDBLE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936C56372
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34D1CB80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B2DC341C6;
        Mon,  4 Jul 2022 01:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897034;
        bh=nNhdiQYdOk/e922UyYAVuuxJtmNgimpR9x+H3vJ7+Gw=;
        h=Date:To:From:Subject:From;
        b=F2mUAc9/5bqnRyb8u4os2qfUZ9Rxx+svuLGHsA5r89Yu+YYwqT01sfQgDHs2wflNF
         ww+ak8X29nkZiRSY8gFqpk4GTAslWdIJXoqDAcwLa3hl/LtC5ySDseZBNHmIAi55ZV
         kLSsC02da4oLU0r/ItbD8DT3PWW2Cyo0SjC1KG0Q=
Date:   Sun, 03 Jul 2022 18:10:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-release_pages-to-use-a-folio-internally.patch removed from -mm tree
Message-Id: <20220704011033.E6B2DC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert release_pages to use a folio internally
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-release_pages-to-use-a-folio-internally.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert release_pages to use a folio internally
Date: Fri, 17 Jun 2022 18:50:11 +0100

This function was already calling compound_head(), but now it can
cache the result of calling compound_head() and avoid calling it again.
Saves 299 bytes of text by avoiding various calls to compound_page()
and avoiding checks of PageTail.

Link: https://lkml.kernel.org/r/20220617175020.717127-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/mm/swap.c~mm-swap-convert-release_pages-to-use-a-folio-internally
+++ a/mm/swap.c
@@ -941,8 +941,7 @@ void release_pages(struct page **pages,
 	unsigned int lock_batch;
 
 	for (i = 0; i < nr; i++) {
-		struct page *page = pages[i];
-		struct folio *folio = page_folio(page);
+		struct folio *folio = page_folio(pages[i]);
 
 		/*
 		 * Make sure the IRQ-safe lock-holding time does not get
@@ -954,35 +953,34 @@ void release_pages(struct page **pages,
 			lruvec = NULL;
 		}
 
-		page = &folio->page;
-		if (is_huge_zero_page(page))
+		if (is_huge_zero_page(&folio->page))
 			continue;
 
-		if (is_zone_device_page(page)) {
+		if (folio_is_zone_device(folio)) {
 			if (lruvec) {
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			if (put_devmap_managed_page(page))
+			if (put_devmap_managed_page(&folio->page))
 				continue;
-			if (put_page_testzero(page))
-				free_zone_device_page(page);
+			if (folio_put_testzero(folio))
+				free_zone_device_page(&folio->page);
 			continue;
 		}
 
-		if (!put_page_testzero(page))
+		if (!folio_put_testzero(folio))
 			continue;
 
-		if (PageCompound(page)) {
+		if (folio_test_large(folio)) {
 			if (lruvec) {
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			__put_compound_page(page);
+			__put_compound_page(&folio->page);
 			continue;
 		}
 
-		if (PageLRU(page)) {
+		if (folio_test_lru(folio)) {
 			struct lruvec *prev_lruvec = lruvec;
 
 			lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
@@ -990,8 +988,8 @@ void release_pages(struct page **pages,
 			if (prev_lruvec != lruvec)
 				lock_batch = 0;
 
-			del_page_from_lru_list(page, lruvec);
-			__clear_page_lru_flags(page);
+			lruvec_del_folio(lruvec, folio);
+			__folio_clear_lru_flags(folio);
 		}
 
 		/*
@@ -1000,13 +998,13 @@ void release_pages(struct page **pages,
 		 * found set here.  This does not indicate a problem, unless
 		 * "unevictable_pgs_cleared" appears worryingly large.
 		 */
-		if (unlikely(PageMlocked(page))) {
-			__ClearPageMlocked(page);
-			dec_zone_page_state(page, NR_MLOCK);
+		if (unlikely(folio_test_mlocked(folio))) {
+			__folio_clear_mlocked(folio);
+			zone_stat_sub_folio(folio, NR_MLOCK);
 			count_vm_event(UNEVICTABLE_PGCLEARED);
 		}
 
-		list_add(&page->lru, &pages_to_free);
+		list_add(&folio->lru, &pages_to_free);
 	}
 	if (lruvec)
 		unlock_page_lruvec_irqrestore(lruvec, flags);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch
mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch
mips-rename-pmd_order-to-pmd_table_order.patch

