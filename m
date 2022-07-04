Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A00C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiGDBLG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiGDBKN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191A562F5
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5FF1B80BEB
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B976C341C7;
        Mon,  4 Jul 2022 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897008;
        bh=W0myBk2IsdwSyDWB7mDWYKPgB1ZjzSzM00YulrFr1xw=;
        h=Date:To:From:Subject:From;
        b=RRP7WYSW0+GdiPtwRugENaPxUNGoHIbeIVyKxJcJ6mjESve97jakDiU/OFn+eYnEC
         s7ZZU67VUkAExyEcWewG9dmWKndpIRDjmOmqW0rfwQtf2CrbDngjP1vPRfwyTeQwx1
         IM+1yhTHylmtkJMyGC60uv/+Q2CK86WBij4g1Tf0=
Date:   Sun, 03 Jul 2022 18:10:07 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220704011008.7B976C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: convert move_pages_to_lru() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-move_pages_to_lru-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: convert move_pages_to_lru() to use a folio
Date: Fri, 17 Jun 2022 16:42:46 +0100

Remove a few hidden calls to compound_head, saving 387 bytes of text on
my test configuration.

Link: https://lkml.kernel.org/r/20220617154248.700416-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   54 +++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-move_pages_to_lru-to-use-a-folio
+++ a/mm/vmscan.c
@@ -2308,8 +2308,8 @@ static int too_many_isolated(struct pgli
 }
 
 /*
- * move_pages_to_lru() moves pages from private @list to appropriate LRU list.
- * On return, @list is reused as a list of pages to be freed by the caller.
+ * move_pages_to_lru() moves folios from private @list to appropriate LRU list.
+ * On return, @list is reused as a list of folios to be freed by the caller.
  *
  * Returns the number of pages moved to the given lruvec.
  */
@@ -2317,42 +2317,42 @@ static unsigned int move_pages_to_lru(st
 				      struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
-	LIST_HEAD(pages_to_free);
-	struct page *page;
+	LIST_HEAD(folios_to_free);
 
 	while (!list_empty(list)) {
-		page = lru_to_page(list);
-		VM_BUG_ON_PAGE(PageLRU(page), page);
-		list_del(&page->lru);
-		if (unlikely(!page_evictable(page))) {
+		struct folio *folio = lru_to_folio(list);
+
+		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
+		list_del(&folio->lru);
+		if (unlikely(!folio_evictable(folio))) {
 			spin_unlock_irq(&lruvec->lru_lock);
-			putback_lru_page(page);
+			folio_putback_lru(folio);
 			spin_lock_irq(&lruvec->lru_lock);
 			continue;
 		}
 
 		/*
-		 * The SetPageLRU needs to be kept here for list integrity.
+		 * The folio_set_lru needs to be kept here for list integrity.
 		 * Otherwise:
 		 *   #0 move_pages_to_lru             #1 release_pages
-		 *   if !put_page_testzero
-		 *				      if (put_page_testzero())
-		 *				        !PageLRU //skip lru_lock
-		 *     SetPageLRU()
-		 *     list_add(&page->lru,)
-		 *                                        list_add(&page->lru,)
+		 *   if (!folio_put_testzero())
+		 *				      if (folio_put_testzero())
+		 *				        !lru //skip lru_lock
+		 *     folio_set_lru()
+		 *     list_add(&folio->lru,)
+		 *                                        list_add(&folio->lru,)
 		 */
-		SetPageLRU(page);
+		folio_set_lru(folio);
 
-		if (unlikely(put_page_testzero(page))) {
-			__clear_page_lru_flags(page);
+		if (unlikely(folio_put_testzero(folio))) {
+			__folio_clear_lru_flags(folio);
 
-			if (unlikely(PageCompound(page))) {
+			if (unlikely(folio_test_large(folio))) {
 				spin_unlock_irq(&lruvec->lru_lock);
-				destroy_compound_page(page);
+				destroy_compound_page(&folio->page);
 				spin_lock_irq(&lruvec->lru_lock);
 			} else
-				list_add(&page->lru, &pages_to_free);
+				list_add(&folio->lru, &folios_to_free);
 
 			continue;
 		}
@@ -2361,18 +2361,18 @@ static unsigned int move_pages_to_lru(st
 		 * All pages were isolated from the same lruvec (and isolation
 		 * inhibits memcg migration).
 		 */
-		VM_BUG_ON_PAGE(!folio_matches_lruvec(page_folio(page), lruvec), page);
-		add_page_to_lru_list(page, lruvec);
-		nr_pages = thp_nr_pages(page);
+		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+		lruvec_add_folio(lruvec, folio);
+		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-		if (PageActive(page))
+		if (folio_test_active(folio))
 			workingset_age_nonresident(lruvec, nr_pages);
 	}
 
 	/*
 	 * To save our caller's stack, now use input list for pages to free.
 	 */
-	list_splice(&pages_to_free, list);
+	list_splice(&folios_to_free, list);
 
 	return nr_moved;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

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

