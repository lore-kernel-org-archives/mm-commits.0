Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDAF5C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbiGDBLs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiGDBKw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:10:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C71634F
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5545EB80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0962CC341C7;
        Mon,  4 Jul 2022 01:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897030;
        bh=JR8QXu6/ySabTDCWv7IAz+gdw9kGWjKzPKvvJTgYjAc=;
        h=Date:To:From:Subject:From;
        b=N8ijIyu/CNQgV7yv2M46pmQxjpYrl9c6hMBlf/x0YtxD4JpCSEEoKQ4f+DPz6L6de
         Vw1pKwxNiy5bxgxSzvDjnl8tnx2jTzk8wh1x0UjFwLjfNuMOvLl/smS/iEtI0+a2Pq
         Q/g0Uv+ASyFpHAbJvRCMIE+q3utExiKCFGDxxeuM=
Date:   Sun, 03 Jul 2022 18:10:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch removed from -mm tree
Message-Id: <20220704011030.0962CC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: rename lru_pvecs to cpu_fbatches
has been removed from the -mm tree.  Its filename was
     mm-swap-rename-lru_pvecs-to-cpu_fbatches.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: rename lru_pvecs to cpu_fbatches
Date: Fri, 17 Jun 2022 18:50:07 +0100

No change to generated code, but this struct no longer contains any
pagevecs, and not all the folio batches it contains are lru.

Link: https://lkml.kernel.org/r/20220617175020.717127-10-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   90 ++++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

--- a/mm/swap.c~mm-swap-rename-lru_pvecs-to-cpu_fbatches
+++ a/mm/swap.c
@@ -56,10 +56,10 @@ static DEFINE_PER_CPU(struct lru_rotate,
 };
 
 /*
- * The following struct pagevec are grouped together because they are protected
+ * The following folio batches are grouped together because they are protected
  * by disabling preemption (and interrupts remain enabled).
  */
-struct lru_pvecs {
+struct cpu_fbatches {
 	local_lock_t lock;
 	struct folio_batch lru_add;
 	struct folio_batch lru_deactivate_file;
@@ -69,7 +69,7 @@ struct lru_pvecs {
 	struct folio_batch activate;
 #endif
 };
-static DEFINE_PER_CPU(struct lru_pvecs, lru_pvecs) = {
+static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
 	.lock = INIT_LOCAL_LOCK(lock),
 };
 
@@ -361,7 +361,7 @@ static void folio_activate_fn(struct lru
 #ifdef CONFIG_SMP
 static void folio_activate_drain(int cpu)
 {
-	struct folio_batch *fbatch = &per_cpu(lru_pvecs.activate, cpu);
+	struct folio_batch *fbatch = &per_cpu(cpu_fbatches.activate, cpu);
 
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, folio_activate_fn);
@@ -374,10 +374,10 @@ static void folio_activate(struct folio
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
-		local_lock(&lru_pvecs.lock);
-		fbatch = this_cpu_ptr(&lru_pvecs.activate);
+		local_lock(&cpu_fbatches.lock);
+		fbatch = this_cpu_ptr(&cpu_fbatches.activate);
 		folio_batch_add_and_move(fbatch, folio, folio_activate_fn);
-		local_unlock(&lru_pvecs.lock);
+		local_unlock(&cpu_fbatches.lock);
 	}
 }
 
@@ -404,8 +404,8 @@ static void __lru_cache_activate_folio(s
 	struct folio_batch *fbatch;
 	int i;
 
-	local_lock(&lru_pvecs.lock);
-	fbatch = this_cpu_ptr(&lru_pvecs.lru_add);
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
 
 	/*
 	 * Search backwards on the optimistic assumption that the folio being
@@ -426,7 +426,7 @@ static void __lru_cache_activate_folio(s
 		}
 	}
 
-	local_unlock(&lru_pvecs.lock);
+	local_unlock(&cpu_fbatches.lock);
 }
 
 /*
@@ -452,7 +452,7 @@ void folio_mark_accessed(struct folio *f
 	} else if (!folio_test_active(folio)) {
 		/*
 		 * If the folio is on the LRU, queue it for activation via
-		 * lru_pvecs.activate. Otherwise, assume the folio is in a
+		 * cpu_fbatches.activate. Otherwise, assume the folio is in a
 		 * folio_batch, mark it active and it'll be moved to the active
 		 * LRU on the next drain.
 		 */
@@ -474,7 +474,7 @@ EXPORT_SYMBOL(folio_mark_accessed);
  *
  * Queue the folio for addition to the LRU. The decision on whether
  * to add the page to the [in]active [file|anon] list is deferred until the
- * pagevec is drained. This gives a chance for the caller of folio_add_lru()
+ * folio_batch is drained. This gives a chance for the caller of folio_add_lru()
  * have the folio added to the active list using folio_mark_accessed().
  */
 void folio_add_lru(struct folio *folio)
@@ -486,10 +486,10 @@ void folio_add_lru(struct folio *folio)
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	folio_get(folio);
-	local_lock(&lru_pvecs.lock);
-	fbatch = this_cpu_ptr(&lru_pvecs.lru_add);
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
 	folio_batch_add_and_move(fbatch, folio, lru_add_fn);
-	local_unlock(&lru_pvecs.lock);
+	local_unlock(&cpu_fbatches.lock);
 }
 EXPORT_SYMBOL(folio_add_lru);
 
@@ -614,13 +614,13 @@ static void lru_lazyfree_fn(struct lruve
 }
 
 /*
- * Drain pages out of the cpu's pagevecs.
+ * Drain pages out of the cpu's folio_batch.
  * Either "cpu" is the current CPU, and preemption has already been
  * disabled; or "cpu" is being hot-unplugged, and is already dead.
  */
 void lru_add_drain_cpu(int cpu)
 {
-	struct folio_batch *fbatch = &per_cpu(lru_pvecs.lru_add, cpu);
+	struct folio_batch *fbatch = &per_cpu(cpu_fbatches.lru_add, cpu);
 
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_add_fn);
@@ -636,15 +636,15 @@ void lru_add_drain_cpu(int cpu)
 		local_unlock_irqrestore(&lru_rotate.lock, flags);
 	}
 
-	fbatch = &per_cpu(lru_pvecs.lru_deactivate_file, cpu);
+	fbatch = &per_cpu(cpu_fbatches.lru_deactivate_file, cpu);
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate_file_fn);
 
-	fbatch = &per_cpu(lru_pvecs.lru_deactivate, cpu);
+	fbatch = &per_cpu(cpu_fbatches.lru_deactivate, cpu);
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate_fn);
 
-	fbatch = &per_cpu(lru_pvecs.lru_lazyfree, cpu);
+	fbatch = &per_cpu(cpu_fbatches.lru_lazyfree, cpu);
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_lazyfree_fn);
 
@@ -670,10 +670,10 @@ void deactivate_file_folio(struct folio
 		return;
 
 	folio_get(folio);
-	local_lock(&lru_pvecs.lock);
-	fbatch = this_cpu_ptr(&lru_pvecs.lru_deactivate_file);
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate_file);
 	folio_batch_add_and_move(fbatch, folio, lru_deactivate_file_fn);
-	local_unlock(&lru_pvecs.lock);
+	local_unlock(&cpu_fbatches.lock);
 }
 
 /*
@@ -693,10 +693,10 @@ void deactivate_page(struct page *page)
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
-		local_lock(&lru_pvecs.lock);
-		fbatch = this_cpu_ptr(&lru_pvecs.lru_deactivate);
+		local_lock(&cpu_fbatches.lock);
+		fbatch = this_cpu_ptr(&cpu_fbatches.lru_deactivate);
 		folio_batch_add_and_move(fbatch, folio, lru_deactivate_fn);
-		local_unlock(&lru_pvecs.lock);
+		local_unlock(&cpu_fbatches.lock);
 	}
 }
 
@@ -717,18 +717,18 @@ void mark_page_lazyfree(struct page *pag
 		struct folio_batch *fbatch;
 
 		folio_get(folio);
-		local_lock(&lru_pvecs.lock);
-		fbatch = this_cpu_ptr(&lru_pvecs.lru_lazyfree);
+		local_lock(&cpu_fbatches.lock);
+		fbatch = this_cpu_ptr(&cpu_fbatches.lru_lazyfree);
 		folio_batch_add_and_move(fbatch, folio, lru_lazyfree_fn);
-		local_unlock(&lru_pvecs.lock);
+		local_unlock(&cpu_fbatches.lock);
 	}
 }
 
 void lru_add_drain(void)
 {
-	local_lock(&lru_pvecs.lock);
+	local_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&lru_pvecs.lock);
+	local_unlock(&cpu_fbatches.lock);
 	mlock_page_drain_local();
 }
 
@@ -740,19 +740,19 @@ void lru_add_drain(void)
  */
 static void lru_add_and_bh_lrus_drain(void)
 {
-	local_lock(&lru_pvecs.lock);
+	local_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&lru_pvecs.lock);
+	local_unlock(&cpu_fbatches.lock);
 	invalidate_bh_lrus_cpu();
 	mlock_page_drain_local();
 }
 
 void lru_add_drain_cpu_zone(struct zone *zone)
 {
-	local_lock(&lru_pvecs.lock);
+	local_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
 	drain_local_pages(zone);
-	local_unlock(&lru_pvecs.lock);
+	local_unlock(&cpu_fbatches.lock);
 	mlock_page_drain_local();
 }
 
@@ -797,8 +797,9 @@ static inline void __lru_add_drain_all(b
 		return;
 
 	/*
-	 * Guarantee pagevec counter stores visible by this CPU are visible to
-	 * other CPUs before loading the current drain generation.
+	 * Guarantee folio_batch counter stores visible by this CPU
+	 * are visible to other CPUs before loading the current drain
+	 * generation.
 	 */
 	smp_mb();
 
@@ -824,8 +825,9 @@ static inline void __lru_add_drain_all(b
 	 * (D) Increment global generation number
 	 *
 	 * Pairs with smp_load_acquire() at (B), outside of the critical
-	 * section. Use a full memory barrier to guarantee that the new global
-	 * drain generation number is stored before loading pagevec counters.
+	 * section. Use a full memory barrier to guarantee that the
+	 * new global drain generation number is stored before loading
+	 * folio_batch counters.
 	 *
 	 * This pairing must be done here, before the for_each_online_cpu loop
 	 * below which drains the page vectors.
@@ -847,12 +849,12 @@ static inline void __lru_add_drain_all(b
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
 
-		if (folio_batch_count(&per_cpu(lru_pvecs.lru_add, cpu)) ||
+		if (folio_batch_count(&per_cpu(cpu_fbatches.lru_add, cpu)) ||
 		    data_race(folio_batch_count(&per_cpu(lru_rotate.fbatch, cpu))) ||
-		    folio_batch_count(&per_cpu(lru_pvecs.lru_deactivate_file, cpu)) ||
-		    folio_batch_count(&per_cpu(lru_pvecs.lru_deactivate, cpu)) ||
-		    folio_batch_count(&per_cpu(lru_pvecs.lru_lazyfree, cpu)) ||
-		    folio_batch_count(&per_cpu(lru_pvecs.activate, cpu)) ||
+		    folio_batch_count(&per_cpu(cpu_fbatches.lru_deactivate_file, cpu)) ||
+		    folio_batch_count(&per_cpu(cpu_fbatches.lru_deactivate, cpu)) ||
+		    folio_batch_count(&per_cpu(cpu_fbatches.lru_lazyfree, cpu)) ||
+		    folio_batch_count(&per_cpu(cpu_fbatches.activate, cpu)) ||
 		    need_mlock_page_drain(cpu) ||
 		    has_bh_in_lru(cpu, NULL)) {
 			INIT_WORK(work, lru_add_drain_per_cpu);
_

Patches currently in -mm which might be from willy@infradead.org are

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

