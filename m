Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C34C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 23:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiFQXPB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jun 2022 19:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiFQXOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Jun 2022 19:14:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402C36541A
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 16:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 482B6B82C03
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 23:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4314C3411B;
        Fri, 17 Jun 2022 23:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655507678;
        bh=mvoA91NmZcZZepg2Trit9nR49WiCqQK0LJgXAp5N5Mc=;
        h=Date:To:From:Subject:From;
        b=egP2+vju8uLfOR1r10WtaXqd7rCEOw1WzpeGfc7Q1zpP9cUjthvATEVRDr065S4a/
         zF7h2Xv3/hTgC5MJjzMwXw19ekzy/8oX+yOwwJwR5q2WF9+7qUdy+/OPAo3cmfQ4TP
         4ZyEaREm2yxmzRKQloAdrpQYYCMBROlez4m6zaSc=
Date:   Fri, 17 Jun 2022 16:14:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-convert-release_pages-to-use-a-folio-internally.patch added to mm-unstable branch
Message-Id: <20220617231437.E4314C3411B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: convert release_pages to use a folio internally
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-convert-release_pages-to-use-a-folio-internally.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-convert-release_pages-to-use-a-folio-internally.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-vmscan-convert-reclaim_clean_pages_from_list-to-folios.patch
mm-vmscan-convert-isolate_lru_pages-to-use-a-folio.patch
mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch
mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch
mm-vmscan-convert-reclaim_pages-to-use-a-folio.patch
mm-add-folios_put.patch
mm-swap-add-folio_batch_move_lru.patch
mm-swap-make-__pagevec_lru_add-static.patch
mm-swap-convert-lru_add-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch
mm-swap-convert-lru_deactivate-to-a-folio_batch.patch
mm-swap-convert-lru_lazyfree-to-a-folio_batch.patch
mm-swap-convert-activate_page-to-a-folio_batch.patch
mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch
mm-swap-pull-the-cpu-conditional-out-of-__lru_add_drain_all.patch
mm-swap-optimise-lru_add_drain_cpu.patch
mm-swap-convert-try_to_free_swap-to-use-a-folio.patch
mm-swap-convert-release_pages-to-use-a-folio-internally.patch
mm-swap-convert-put_pages_list-to-use-folios.patch
mm-swap-convert-__put_page-to-__folio_put.patch
mm-swap-convert-__put_single_page-to-__folio_put_small.patch
mm-swap-convert-__put_compound_page-to-__folio_put_large.patch
mm-swap-convert-__page_cache_release-to-use-a-folio.patch
mm-convert-destroy_compound_page-to-destroy_large_folio.patch
mm-convert-page_swap_flags-to-folio_swap_flags.patch
mm-swap-convert-delete_from_swap_cache-to-take-a-folio.patch
mm-swap-convert-__delete_from_swap_cache-to-a-folio.patch

