From: akpm@linux-foundation.org
Subject: [merged] mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:22 -0800
Message-ID: <20120111212723.524B920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59956 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab2AKV11 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:27 -0500
Received: by eaad12 with SMTP id d12so32537eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mel@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: writeback: cleanups in preparation for per-zone dirty limits
has been removed from the -mm tree.  Its filename was
     mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: writeback: cleanups in preparation for per-zone dirty limits

The next patch will introduce per-zone dirty limiting functions in
addition to the traditional global dirty limiting.

Rename determine_dirtyable_memory() to global_dirtyable_memory() before
adding the zone-specific version, and fix up its documentation.

Also, move the functions to determine the dirtyable memory and the
function to calculate the dirty limit based on that together so that their
relationship is more apparent and that they can be commented on as a
group.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mel@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   93 +++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 46 deletions(-)

diff -puN mm/page-writeback.c~mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits mm/page-writeback.c
--- a/mm/page-writeback.c~mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits
+++ a/mm/page-writeback.c
@@ -146,6 +146,7 @@ static struct prop_descriptor vm_complet
  * We make sure that the background writeout level is below the adjusted
  * clamping level.
  */
+
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
@@ -172,12 +173,12 @@ static unsigned long highmem_dirtyable_m
 }
 
 /**
- * determine_dirtyable_memory - amount of memory that may be used
+ * global_dirtyable_memory - number of globally dirtyable pages
  *
- * Returns the numebr of pages that can currently be freed and used
- * by the kernel for direct mappings.
+ * Returns the global number of pages potentially available for dirty
+ * page cache.  This is the base value for the global dirty limits.
  */
-static unsigned long determine_dirtyable_memory(void)
+unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
@@ -191,6 +192,47 @@ static unsigned long determine_dirtyable
 }
 
 /*
+ * global_dirty_limits - background-writeback and dirty-throttling thresholds
+ *
+ * Calculate the dirty thresholds based on sysctl parameters
+ * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
+ * - vm.dirty_ratio             or  vm.dirty_bytes
+ * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
+ * real-time tasks.
+ */
+void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
+{
+	unsigned long background;
+	unsigned long dirty;
+	unsigned long uninitialized_var(available_memory);
+	struct task_struct *tsk;
+
+	if (!vm_dirty_bytes || !dirty_background_bytes)
+		available_memory = global_dirtyable_memory();
+
+	if (vm_dirty_bytes)
+		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
+	else
+		dirty = (vm_dirty_ratio * available_memory) / 100;
+
+	if (dirty_background_bytes)
+		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
+	else
+		background = (dirty_background_ratio * available_memory) / 100;
+
+	if (background >= dirty)
+		background = dirty / 2;
+	tsk = current;
+	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
+		background += background / 4;
+		dirty += dirty / 4;
+	}
+	*pbackground = background;
+	*pdirty = dirty;
+	trace_global_dirty_state(background, dirty);
+}
+
+/*
  * couple the period to the dirty_ratio:
  *
  *   period/2 ~ roundup_pow_of_two(dirty limit)
@@ -202,7 +244,7 @@ static int calc_period_shift(void)
 	if (vm_dirty_bytes)
 		dirty_total = vm_dirty_bytes / PAGE_SIZE;
 	else
-		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
+		dirty_total = (vm_dirty_ratio * global_dirtyable_memory()) /
 				100;
 	return 2 + ilog2(dirty_total - 1);
 }
@@ -362,47 +404,6 @@ static unsigned long hard_dirty_limit(un
 	return max(thresh, global_dirty_limit);
 }
 
-/*
- * global_dirty_limits - background-writeback and dirty-throttling thresholds
- *
- * Calculate the dirty thresholds based on sysctl parameters
- * - vm.dirty_background_ratio  or  vm.dirty_background_bytes
- * - vm.dirty_ratio             or  vm.dirty_bytes
- * The dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
- * real-time tasks.
- */
-void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
-{
-	unsigned long background;
-	unsigned long dirty;
-	unsigned long uninitialized_var(available_memory);
-	struct task_struct *tsk;
-
-	if (!vm_dirty_bytes || !dirty_background_bytes)
-		available_memory = determine_dirtyable_memory();
-
-	if (vm_dirty_bytes)
-		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
-	else
-		dirty = (vm_dirty_ratio * available_memory) / 100;
-
-	if (dirty_background_bytes)
-		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
-	else
-		background = (dirty_background_ratio * available_memory) / 100;
-
-	if (background >= dirty)
-		background = dirty / 2;
-	tsk = current;
-	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
-		background += background / 4;
-		dirty += dirty / 4;
-	}
-	*pbackground = background;
-	*pdirty = dirty;
-	trace_global_dirty_state(background, dirty);
-}
-
 /**
  * bdi_dirty_limit - @bdi's share of dirty throttling threshold
  * @bdi: the backing_dev_info to query
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch

