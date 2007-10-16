From: akpm@linux-foundation.org
Subject: - mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:08:50 -0700
Message-ID: <200710160408.l9G48oW2008024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829AbXJPEJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, hifumi.hisashi@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     move_tail_pages into lru_add_drain
has been removed from the -mm tree.  Its filename was
     mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch

This patch was dropped because it was folded into mm-use-pagevec-to-rotate-reclaimable-page.patch

------------------------------------------------------
Subject: move_tail_pages into lru_add_drain
From: Hugh Dickins <hugh@veritas.com>

a.k.a. mm-use-pagevec-to-rotate-reclaimable-page-cleanup-2.patch

Opinions may differ, but I'm uneasy with leaving pages to be rotated on
their pagevecs for too long: although they're still visible via the LRU,
their page counts are raised, which excludes them from some operations.

Memory hotplug and page migration clearly want to be draining them:
but rather than add move_tail_pages calls in various places, won't we
be safer just to drain them whenever we drain the lru_add pagevecs?

So merge move_tail_pages into __lru_add_drain, which lets us remove
cpu_movetail_callback.  Rename __lru_add_drain to drain_cpu_pagevecs,
and correct the misleading "CPU is dead" comment found there.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/swap.h~mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain include/linux/swap.h
--- a/include/linux/swap.h~mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain
+++ a/include/linux/swap.h
@@ -185,7 +185,6 @@ extern void FASTCALL(mark_page_accessed(
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern int rotate_reclaimable_page(struct page *page);
-extern void move_tail_pages(void);
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
diff -puN mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain mm/swap.c
--- a/mm/swap.c~mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain
+++ a/mm/swap.c
@@ -32,6 +32,10 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
+static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs) = { 0, };
+
 /*
  * This path almost never happens for VM activity - pages are normally
  * freed via pagevecs.  But it gets used by networking.
@@ -123,20 +127,6 @@ static void pagevec_move_tail(struct pag
 	pagevec_reinit(pvec);
 }
 
-static DEFINE_PER_CPU(struct pagevec, rotate_pvecs) = { 0, };
-
-void move_tail_pages(void)
-{
-	unsigned long flags;
-	struct pagevec *pvec;
-
-	local_irq_save(flags);
-	pvec = &__get_cpu_var(rotate_pvecs);
-	if (pagevec_count(pvec))
-		pagevec_move_tail(pvec);
-	local_irq_restore(flags);
-}
-
 /*
  * Writeback is about to end against a page which has been marked for immediate
  * reclaim.  If it still appears to be reclaimable, move it to the tail of the
@@ -211,9 +201,6 @@ EXPORT_SYMBOL(mark_page_accessed);
  * lru_cache_add: add a page to the page lists
  * @page: the page to add
  */
-static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
-static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
-
 void fastcall lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs);
@@ -234,21 +221,37 @@ void fastcall lru_cache_add_active(struc
 	put_cpu_var(lru_add_active_pvecs);
 }
 
-static void __lru_add_drain(int cpu)
+/*
+ * Drain pages out of the cpu's pagevecs.
+ * Either "cpu" is the current CPU, and preemption has already been
+ * disabled; or "cpu" is being hot-unplugged, and is already dead.
+ */
+static void drain_cpu_pagevecs(int cpu)
 {
-	struct pagevec *pvec = &per_cpu(lru_add_pvecs, cpu);
+	struct pagevec *pvec;
 
-	/* CPU is dead, so no locking needed. */
+	pvec = &per_cpu(lru_add_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add(pvec);
+
 	pvec = &per_cpu(lru_add_active_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add_active(pvec);
+
+	pvec = &per_cpu(lru_rotate_pvecs, cpu);
+	if (pagevec_count(pvec)) {
+		unsigned long flags;
+
+		/* No harm done if a racing interrupt already did this */
+		local_irq_save(flags);
+		pagevec_move_tail(pvec);
+		local_irq_restore(flags);
+	}
 }
 
 void lru_add_drain(void)
 {
-	__lru_add_drain(get_cpu());
+	drain_cpu_pagevecs(get_cpu());
 	put_cpu();
 }
 
@@ -530,25 +533,8 @@ static int cpu_swap_callback(struct noti
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		atomic_add(*committed, &vm_committed_space);
 		*committed = 0;
-		__lru_add_drain((long)hcpu);
-	}
-	return NOTIFY_OK;
-}
-
-static int cpu_movetail_callback(struct notifier_block *nfb,
-				 unsigned long action, void *hcpu)
-{
-	unsigned long flags;
-	struct pagevec *pvec;
-
-	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		local_irq_save(flags);
-		pvec = &per_cpu(rotate_pvecs, (long)hcpu);
-		if (pagevec_count(pvec))
-			pagevec_move_tail(pvec);
-		local_irq_restore(flags);
+		drain_cpu_pagevecs((long)hcpu);
 	}
-
 	return NOTIFY_OK;
 }
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -572,6 +558,5 @@ void __init swap_setup(void)
 	 */
 #ifdef CONFIG_HOTPLUG_CPU
 	hotcpu_notifier(cpu_swap_callback, 0);
-	hotcpu_notifier(cpu_movetail_callback, 0);
 #endif
 }
diff -puN mm/vmscan.c~mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain mm/vmscan.c
--- a/mm/vmscan.c~mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain
+++ a/mm/vmscan.c
@@ -792,7 +792,6 @@ static unsigned long shrink_inactive_lis
 
 	pagevec_init(&pvec, 1);
 
-	move_tail_pages();
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	do {
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
mm-use-pagevec-to-rotate-reclaimable-page.patch
mm-use-pagevec-to-rotate-reclaimable-page-move_tail_pages-into-lru_add_drain.patch
introduce-write_begin-write_end-aops-important-fix.patch
reiserfs-convert-to-new-aops-fix.patch
hostfs-convert-to-new-aops-fix.patch
affs-convert-to-new-aops-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
mm-shmemc-make-3-functions-static.patch
lib-percpu_counter_sub.patch
mm-per-device-dirty-threshold-fix.patch
ext2-reservations.patch
fix-for-ext2-reservation.patch
ext2-balloc-use-io_error-label.patch
memory-controller-memory-accounting-v7-fix-swapoff-breakage-however.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
prio_tree-debugging-patch.patch
