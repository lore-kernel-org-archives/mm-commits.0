Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B7FC43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiGDBLM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiGDBKQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669A762E5
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2116DB803F6
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63F5C341CF;
        Mon,  4 Jul 2022 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897012;
        bh=u/igq8Yfe0nKL+mR+o/Y+Dn8yVWIrseGPXyivzOmhCg=;
        h=Date:To:From:Subject:From;
        b=lqLFYafO5kiXugxotpc8Zi8jeI6oKMOPARkmHAYkpPTxXnB3XLRzD+rJQRsPqpI7y
         shTLVKQaqCOvlgBFu89tGnifIQ27sTLxEU0kv6t1R8A3WkdpTmj0GQMByd980ym6rb
         WZL0EtoSKWkOiNCEXmbg1ADKrCNg6Ch74kiz69oU=
Date:   Sun, 03 Jul 2022 18:10:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-add-folio_batch_move_lru.patch removed from -mm tree
Message-Id: <20220704011012.C63F5C341CF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: add folio_batch_move_lru()
has been removed from the -mm tree.  Its filename was
     mm-swap-add-folio_batch_move_lru.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: add folio_batch_move_lru()
Date: Fri, 17 Jun 2022 18:50:00 +0100

Start converting the LRU from pagevecs to folio_batches.

Combine the functionality of pagevec_add_and_need_flush() with
pagevec_lru_move_fn() in the new folio_batch_add_and_move().

Convert the lru_rotate pagevec to a folio_batch.

Adds 223 bytes total to kernel text, because we're duplicating
infrastructure.  This will be more than made up for in future patches.

Link: https://lkml.kernel.org/r/20220617175020.717127-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   78 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 22 deletions(-)

--- a/mm/swap.c~mm-swap-add-folio_batch_move_lru
+++ a/mm/swap.c
@@ -46,10 +46,10 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
-/* Protecting only lru_rotate.pvec which requires disabling interrupts */
+/* Protecting only lru_rotate.fbatch which requires disabling interrupts */
 struct lru_rotate {
 	local_lock_t lock;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 };
 static DEFINE_PER_CPU(struct lru_rotate, lru_rotate) = {
 	.lock = INIT_LOCAL_LOCK(lock),
@@ -214,18 +214,6 @@ static void pagevec_lru_move_fn(struct p
 	pagevec_reinit(pvec);
 }
 
-static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
-{
-	struct folio *folio = page_folio(page);
-
-	if (!folio_test_unevictable(folio)) {
-		lruvec_del_folio(lruvec, folio);
-		folio_clear_active(folio);
-		lruvec_add_folio_tail(lruvec, folio);
-		__count_vm_events(PGROTATED, folio_nr_pages(folio));
-	}
-}
-
 /* return true if pagevec needs to drain */
 static bool pagevec_add_and_need_flush(struct pagevec *pvec, struct page *page)
 {
@@ -238,6 +226,52 @@ static bool pagevec_add_and_need_flush(s
 	return ret;
 }
 
+typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
+
+static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
+{
+	int i;
+	struct lruvec *lruvec = NULL;
+	unsigned long flags = 0;
+
+	for (i = 0; i < folio_batch_count(fbatch); i++) {
+		struct folio *folio = fbatch->folios[i];
+
+		/* block memcg migration while the folio moves between lru */
+		if (!folio_test_clear_lru(folio))
+			continue;
+
+		lruvec = folio_lruvec_relock_irqsave(folio, lruvec, &flags);
+		move_fn(lruvec, folio);
+
+		folio_set_lru(folio);
+	}
+
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
+	folios_put(fbatch->folios, folio_batch_count(fbatch));
+	folio_batch_init(fbatch);
+}
+
+static void folio_batch_add_and_move(struct folio_batch *fbatch,
+		struct folio *folio, move_fn_t move_fn)
+{
+	if (folio_batch_add(fbatch, folio) && !folio_test_large(folio) &&
+	    !lru_cache_disabled())
+		return;
+	folio_batch_move_lru(fbatch, move_fn);
+}
+
+static void lru_move_tail_fn(struct lruvec *lruvec, struct folio *folio)
+{
+	if (!folio_test_unevictable(folio)) {
+		lruvec_del_folio(lruvec, folio);
+		folio_clear_active(folio);
+		lruvec_add_folio_tail(lruvec, folio);
+		__count_vm_events(PGROTATED, folio_nr_pages(folio));
+	}
+}
+
 /*
  * Writeback is about to end against a folio which has been marked for
  * immediate reclaim.  If it still appears to be reclaimable, move it
@@ -249,14 +283,13 @@ void folio_rotate_reclaimable(struct fol
 {
 	if (!folio_test_locked(folio) && !folio_test_dirty(folio) &&
 	    !folio_test_unevictable(folio) && folio_test_lru(folio)) {
-		struct pagevec *pvec;
+		struct folio_batch *fbatch;
 		unsigned long flags;
 
 		folio_get(folio);
 		local_lock_irqsave(&lru_rotate.lock, flags);
-		pvec = this_cpu_ptr(&lru_rotate.pvec);
-		if (pagevec_add_and_need_flush(pvec, &folio->page))
-			pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
+		fbatch = this_cpu_ptr(&lru_rotate.fbatch);
+		folio_batch_add_and_move(fbatch, folio, lru_move_tail_fn);
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
 }
@@ -595,19 +628,20 @@ static void lru_lazyfree_fn(struct page
  */
 void lru_add_drain_cpu(int cpu)
 {
+	struct folio_batch *fbatch;
 	struct pagevec *pvec = &per_cpu(lru_pvecs.lru_add, cpu);
 
 	if (pagevec_count(pvec))
 		__pagevec_lru_add(pvec);
 
-	pvec = &per_cpu(lru_rotate.pvec, cpu);
+	fbatch = &per_cpu(lru_rotate.fbatch, cpu);
 	/* Disabling interrupts below acts as a compiler barrier. */
-	if (data_race(pagevec_count(pvec))) {
+	if (data_race(folio_batch_count(fbatch))) {
 		unsigned long flags;
 
 		/* No harm done if a racing interrupt already did this */
 		local_lock_irqsave(&lru_rotate.lock, flags);
-		pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
+		folio_batch_move_lru(fbatch, lru_move_tail_fn);
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
 
@@ -824,7 +858,7 @@ static inline void __lru_add_drain_all(b
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
 		if (pagevec_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
-		    data_race(pagevec_count(&per_cpu(lru_rotate.pvec, cpu))) ||
+		    data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
 		    pagevec_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
_

Patches currently in -mm which might be from willy@infradead.org are

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

