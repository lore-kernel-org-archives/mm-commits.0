From: akpm@linux-foundation.org
Subject: - lib-proportion-fix-underflow-in-prop_norm_percpu.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:18 -0800
Message-ID: <200801072138.m07LcwX4013518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793AbYAGVjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, zhe.jiang@intel.com, mm-commits@vger.kernel.org


The patch titled
     lib: proportion: fix underflow in prop_norm_percpu()
has been removed from the -mm tree.  Its filename was
     lib-proportion-fix-underflow-in-prop_norm_percpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: proportion: fix underflow in prop_norm_percpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Zhe Jiang noticed that its possible to underflow pl->events in
prop_norm_percpu() when the value returned by percpu_counter_read() is less
than the error on that read and the period delay > 1.  In that case half might
not trigger the batch increment and the value will be identical on the next
iteration, causing the same half to be subtracted again and again.

Fix this by rewriting the division as a single subtraction instead of a
subtraction loop and using percpu_counter_sum() when the value returned by
percpu_counter_read() is smaller than the error.

The latter is still needed if we want pl->events to shrink properly in the
error region.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Jiang Zhe <zhe.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/proportions.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff -puN lib/proportions.c~lib-proportion-fix-underflow-in-prop_norm_percpu lib/proportions.c
--- a/lib/proportions.c~lib-proportion-fix-underflow-in-prop_norm_percpu
+++ a/lib/proportions.c
@@ -190,6 +190,8 @@ prop_adjust_shift(int *pl_shift, unsigne
  * PERCPU
  */
 
+#define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
+
 int prop_local_init_percpu(struct prop_local_percpu *pl)
 {
 	spin_lock_init(&pl->lock);
@@ -230,31 +232,24 @@ void prop_norm_percpu(struct prop_global
 
 	spin_lock_irqsave(&pl->lock, flags);
 	prop_adjust_shift(&pl->shift, &pl->period, pg->shift);
+
 	/*
 	 * For each missed period, we half the local counter.
 	 * basically:
 	 *   pl->events >> (global_period - pl->period);
-	 *
-	 * but since the distributed nature of percpu counters make division
-	 * rather hard, use a regular subtraction loop. This is safe, because
-	 * the events will only every be incremented, hence the subtraction
-	 * can never result in a negative number.
 	 */
-	while (pl->period != global_period) {
-		unsigned long val = percpu_counter_read(&pl->events);
-		unsigned long half = (val + 1) >> 1;
-
-		/*
-		 * Half of zero won't be much less, break out.
-		 * This limits the loop to shift iterations, even
-		 * if we missed a million.
-		 */
-		if (!val)
-			break;
-
-		percpu_counter_add(&pl->events, -half);
-		pl->period += period;
-	}
+	period = (global_period - pl->period) >> (pg->shift - 1);
+	if (period < BITS_PER_LONG) {
+		s64 val = percpu_counter_read(&pl->events);
+
+		if (val < (nr_cpu_ids * PROP_BATCH))
+			val = percpu_counter_sum(&pl->events);
+
+		__percpu_counter_add(&pl->events, -val + (val >> period),
+					PROP_BATCH);
+	} else
+		percpu_counter_set(&pl->events, 0);
+
 	pl->period = global_period;
 	spin_unlock_irqrestore(&pl->lock, flags);
 }
@@ -267,7 +262,7 @@ void __prop_inc_percpu(struct prop_descr
 	struct prop_global *pg = prop_get_global(pd);
 
 	prop_norm_percpu(pg, pl);
-	percpu_counter_add(&pl->events, 1);
+	__percpu_counter_add(&pl->events, 1, PROP_BATCH);
 	percpu_counter_add(&pg->events, 1);
 	prop_put_global(pd, pg);
 }
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

git-sched.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
mm-page-writeback-highmem_is_dirtyable-option.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
skip-writing-data-pages-when-inode-is-under-i_sync.patch
fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
