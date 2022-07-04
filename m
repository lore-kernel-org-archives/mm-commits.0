Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5F8C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiGDBLP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiGDBKi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F9A6310
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA79C61303
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D366C341C6;
        Mon,  4 Jul 2022 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897026;
        bh=VK0esOqzq3qw6hPpMiabesmF0t2HxCy1iUWIPp0/tbs=;
        h=Date:To:From:Subject:From;
        b=thUeR2sP2OR2dWo5yEBe3AL3rWb0iUzi4dbXyFMQQV7Nutrb0Rya17LhR2QG73Iwa
         t/PPCXk+lxVGRLqx7mQx21UOL+gabZYxIyojvHLasEuqUVL2fTN5erp17nq4qVSxg6
         pBF3q2smN+h8OPwAvYWagElrWn+v6TXSVJgqO/mc=
Date:   Sun, 03 Jul 2022 18:10:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch removed from -mm tree
Message-Id: <20220704011026.0D366C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert lru_deactivate_file to a folio_batch
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-lru_deactivate_file-to-a-folio_batch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert lru_deactivate_file to a folio_batch
Date: Fri, 17 Jun 2022 18:50:03 +0100

Use a folio throughout lru_deactivate_file_fn(), removing many hidden
calls to compound_head().  Shrinks the kernel by 864 bytes of text.

Link: https://lkml.kernel.org/r/20220617175020.717127-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   82 ++++++++++++++++++++++++----------------------------
 1 file changed, 39 insertions(+), 43 deletions(-)

--- a/mm/swap.c~mm-swap-convert-lru_deactivate_file-to-a-folio_batch
+++ a/mm/swap.c
@@ -62,7 +62,7 @@ static DEFINE_PER_CPU(struct lru_rotate,
 struct lru_pvecs {
 	local_lock_t lock;
 	struct folio_batch lru_add;
-	struct pagevec lru_deactivate_file;
+	struct folio_batch lru_deactivate_file;
 	struct pagevec lru_deactivate;
 	struct pagevec lru_lazyfree;
 #ifdef CONFIG_SMP
@@ -562,56 +562,57 @@ void lru_cache_add_inactive_or_unevictab
 }
 
 /*
- * If the page can not be invalidated, it is moved to the
+ * If the folio cannot be invalidated, it is moved to the
  * inactive list to speed up its reclaim.  It is moved to the
  * head of the list, rather than the tail, to give the flusher
  * threads some time to write it out, as this is much more
  * effective than the single-page writeout from reclaim.
  *
- * If the page isn't page_mapped and dirty/writeback, the page
- * could reclaim asap using PG_reclaim.
+ * If the folio isn't mapped and dirty/writeback, the folio
+ * could be reclaimed asap using the reclaim flag.
  *
- * 1. active, mapped page -> none
- * 2. active, dirty/writeback page -> inactive, head, PG_reclaim
- * 3. inactive, mapped page -> none
- * 4. inactive, dirty/writeback page -> inactive, head, PG_reclaim
+ * 1. active, mapped folio -> none
+ * 2. active, dirty/writeback folio -> inactive, head, reclaim
+ * 3. inactive, mapped folio -> none
+ * 4. inactive, dirty/writeback folio -> inactive, head, reclaim
  * 5. inactive, clean -> inactive, tail
  * 6. Others -> none
  *
- * In 4, why it moves inactive's head, the VM expects the page would
- * be write it out by flusher threads as this is much more effective
+ * In 4, it moves to the head of the inactive list so the folio is
+ * written out by flusher threads as this is much more efficient
  * than the single-page writeout from reclaim.
  */
-static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec)
+static void lru_deactivate_file_fn(struct lruvec *lruvec, struct folio *folio)
 {
-	bool active = PageActive(page);
-	int nr_pages = thp_nr_pages(page);
+	bool active = folio_test_active(folio);
+	long nr_pages = folio_nr_pages(folio);
 
-	if (PageUnevictable(page))
+	if (folio_test_unevictable(folio))
 		return;
 
-	/* Some processes are using the page */
-	if (page_mapped(page))
+	/* Some processes are using the folio */
+	if (folio_mapped(folio))
 		return;
 
-	del_page_from_lru_list(page, lruvec);
-	ClearPageActive(page);
-	ClearPageReferenced(page);
+	lruvec_del_folio(lruvec, folio);
+	folio_clear_active(folio);
+	folio_clear_referenced(folio);
 
-	if (PageWriteback(page) || PageDirty(page)) {
+	if (folio_test_writeback(folio) || folio_test_dirty(folio)) {
 		/*
-		 * PG_reclaim could be raced with end_page_writeback
-		 * It can make readahead confusing.  But race window
-		 * is _really_ small and  it's non-critical problem.
+		 * Setting the reclaim flag could race with
+		 * folio_end_writeback() and confuse readahead.  But the
+		 * race window is _really_ small and  it's not a critical
+		 * problem.
 		 */
-		add_page_to_lru_list(page, lruvec);
-		SetPageReclaim(page);
+		lruvec_add_folio(lruvec, folio);
+		folio_set_reclaim(folio);
 	} else {
 		/*
-		 * The page's writeback ends up during pagevec
-		 * We move that page into tail of inactive.
+		 * The folio's writeback ended while it was in the batch.
+		 * We move that folio to the tail of the inactive list.
 		 */
-		add_page_to_lru_list_tail(page, lruvec);
+		lruvec_add_folio_tail(lruvec, folio);
 		__count_vm_events(PGROTATED, nr_pages);
 	}
 
@@ -685,9 +686,9 @@ void lru_add_drain_cpu(int cpu)
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
 
-	pvec = &per_cpu(lru_pvecs.lru_deactivate_file, cpu);
-	if (pagevec_count(pvec))
-		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
+	fbatch = &per_cpu(lru_pvecs.lru_deactivate_file, cpu);
+	if (folio_batch_count(fbatch))
+		folio_batch_move_lru(fbatch, lru_deactivate_file_fn);
 
 	pvec = &per_cpu(lru_pvecs.lru_deactivate, cpu);
 	if (pagevec_count(pvec))
@@ -701,32 +702,27 @@ void lru_add_drain_cpu(int cpu)
 }
 
 /**
- * deactivate_file_folio() - Forcefully deactivate a file folio.
+ * deactivate_file_folio() - Deactivate a file folio.
  * @folio: Folio to deactivate.
  *
  * This function hints to the VM that @folio is a good reclaim candidate,
  * for example if its invalidation fails due to the folio being dirty
  * or under writeback.
  *
- * Context: Caller holds a reference on the page.
+ * Context: Caller holds a reference on the folio.
  */
 void deactivate_file_folio(struct folio *folio)
 {
-	struct pagevec *pvec;
+	struct folio_batch *fbatch;
 
-	/*
-	 * In a workload with many unevictable pages such as mprotect,
-	 * unevictable folio deactivation for accelerating reclaim is pointless.
-	 */
+	/* Deactivating an unevictable folio will not accelerate reclaim */
 	if (folio_test_unevictable(folio))
 		return;
 
 	folio_get(folio);
 	local_lock(&lru_pvecs.lock);
-	pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate_file);
-
-	if (pagevec_add_and_need_flush(pvec, &folio->page))
-		pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
+	fbatch = this_cpu_ptr(&lru_pvecs.lru_deactivate_file);
+	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file_fn);
 	local_unlock(&lru_pvecs.lock);
 }
 
@@ -899,7 +895,7 @@ static inline void __lru_add_drain_all(b
 
 		if (folio_batch_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
 		    data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
-		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
+		    folio_batch_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
 		    need_activate_page_drain(cpu) ||
_

Patches currently in -mm which might be from willy@infradead.org are

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

