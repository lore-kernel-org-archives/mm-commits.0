Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAF4C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbiGDBLI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbiGDBKN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5024C62F8
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBB51B80CEF
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACAAC341C6;
        Mon,  4 Jul 2022 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897009;
        bh=jSUqLGDs8F3YFYhZFPtx189SvuiVKaUiwC7CzxN9yFU=;
        h=Date:To:From:Subject:From;
        b=vWTkyI8+2XBdaW10l33R1HTPIp0QGRyQ9JNFqnFYUJLKvHd8y4+zz8tJsoqikwSB4
         FJL8/32QBJaqHOAIzXU1epyyrHLefcRUtigGjKqSd7mpm9kj7fPvhKMmqqLb9jO0wR
         oN5bIiMmliHaa1KTehbReUAM5vo1BPXgoTwBaJh4=
Date:   Sun, 03 Jul 2022 18:10:08 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220704011009.8ACAAC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: convert shrink_active_list() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-shrink_active_list-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/vmscan: convert shrink_active_list() to use a folio
Date: Fri, 17 Jun 2022 16:42:47 +0100

Remove a few hidden calls to compound_head, saving 411 bytes of text.

Link: https://lkml.kernel.org/r/20220617154248.700416-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   61 +++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-convert-shrink_active_list-to-use-a-folio
+++ a/mm/vmscan.c
@@ -26,8 +26,7 @@
 #include <linux/file.h>
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
-#include <linux/buffer_head.h>	/* for try_to_release_page(),
-					buffer_heads_over_limit */
+#include <linux/buffer_head.h>	/* for buffer_heads_over_limit */
 #include <linux/mm_inline.h>
 #include <linux/backing-dev.h>
 #include <linux/rmap.h>
@@ -2483,21 +2482,21 @@ shrink_inactive_list(unsigned long nr_to
 }
 
 /*
- * shrink_active_list() moves pages from the active LRU to the inactive LRU.
+ * shrink_active_list() moves folios from the active LRU to the inactive LRU.
  *
- * We move them the other way if the page is referenced by one or more
+ * We move them the other way if the folio is referenced by one or more
  * processes.
  *
- * If the pages are mostly unmapped, the processing is fast and it is
+ * If the folios are mostly unmapped, the processing is fast and it is
  * appropriate to hold lru_lock across the whole operation.  But if
- * the pages are mapped, the processing is slow (folio_referenced()), so
- * we should drop lru_lock around each page.  It's impossible to balance
- * this, so instead we remove the pages from the LRU while processing them.
- * It is safe to rely on PG_active against the non-LRU pages in here because
- * nobody will play with that bit on a non-LRU page.
+ * the folios are mapped, the processing is slow (folio_referenced()), so
+ * we should drop lru_lock around each folio.  It's impossible to balance
+ * this, so instead we remove the folios from the LRU while processing them.
+ * It is safe to rely on the active flag against the non-LRU folios in here
+ * because nobody will play with that bit on a non-LRU folio.
  *
- * The downside is that we have to touch page->_refcount against each page.
- * But we had to alter page->flags anyway.
+ * The downside is that we have to touch folio->_refcount against each folio.
+ * But we had to alter folio->flags anyway.
  */
 static void shrink_active_list(unsigned long nr_to_scan,
 			       struct lruvec *lruvec,
@@ -2507,7 +2506,7 @@ static void shrink_active_list(unsigned
 	unsigned long nr_taken;
 	unsigned long nr_scanned;
 	unsigned long vm_flags;
-	LIST_HEAD(l_hold);	/* The pages which were snipped off */
+	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	unsigned nr_deactivate, nr_activate;
@@ -2532,23 +2531,21 @@ static void shrink_active_list(unsigned
 
 	while (!list_empty(&l_hold)) {
 		struct folio *folio;
-		struct page *page;
 
 		cond_resched();
 		folio = lru_to_folio(&l_hold);
 		list_del(&folio->lru);
-		page = &folio->page;
 
-		if (unlikely(!page_evictable(page))) {
-			putback_lru_page(page);
+		if (unlikely(!folio_evictable(folio))) {
+			folio_putback_lru(folio);
 			continue;
 		}
 
 		if (unlikely(buffer_heads_over_limit)) {
-			if (page_has_private(page) && trylock_page(page)) {
-				if (page_has_private(page))
-					try_to_release_page(page, 0);
-				unlock_page(page);
+			if (folio_get_private(folio) && folio_trylock(folio)) {
+				if (folio_get_private(folio))
+					filemap_release_folio(folio, 0);
+				folio_unlock(folio);
 			}
 		}
 
@@ -2556,34 +2553,34 @@ static void shrink_active_list(unsigned
 		if (folio_referenced(folio, 0, sc->target_mem_cgroup,
 				     &vm_flags) != 0) {
 			/*
-			 * Identify referenced, file-backed active pages and
+			 * Identify referenced, file-backed active folios and
 			 * give them one more trip around the active list. So
 			 * that executable code get better chances to stay in
-			 * memory under moderate memory pressure.  Anon pages
+			 * memory under moderate memory pressure.  Anon folios
 			 * are not likely to be evicted by use-once streaming
-			 * IO, plus JVM can create lots of anon VM_EXEC pages,
+			 * IO, plus JVM can create lots of anon VM_EXEC folios,
 			 * so we ignore them here.
 			 */
-			if ((vm_flags & VM_EXEC) && page_is_file_lru(page)) {
-				nr_rotated += thp_nr_pages(page);
-				list_add(&page->lru, &l_active);
+			if ((vm_flags & VM_EXEC) && folio_is_file_lru(folio)) {
+				nr_rotated += folio_nr_pages(folio);
+				list_add(&folio->lru, &l_active);
 				continue;
 			}
 		}
 
-		ClearPageActive(page);	/* we are de-activating */
-		SetPageWorkingset(page);
-		list_add(&page->lru, &l_inactive);
+		folio_clear_active(folio);	/* we are de-activating */
+		folio_set_workingset(folio);
+		list_add(&folio->lru, &l_inactive);
 	}
 
 	/*
-	 * Move pages back to the lru list.
+	 * Move folios back to the lru list.
 	 */
 	spin_lock_irq(&lruvec->lru_lock);
 
 	nr_activate = move_pages_to_lru(lruvec, &l_active);
 	nr_deactivate = move_pages_to_lru(lruvec, &l_inactive);
-	/* Keep all free pages in l_active list */
+	/* Keep all free folios in l_active list */
 	list_splice(&l_inactive, &l_active);
 
 	__count_vm_events(PGDEACTIVATE, nr_deactivate);
_

Patches currently in -mm which might be from willy@infradead.org are

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

