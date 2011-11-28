From: akpm@linux-foundation.org
Subject: + mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch added to -mm tree
Date: Mon, 28 Nov 2011 14:30:05 -0800
Message-ID: <201111282230.pASMU5NN030656@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65130 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab1K1WaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 17:30:10 -0500
Received: by eeuu44 with SMTP id u44so49497eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 14:30:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mel@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com


The patch titled
     Subject: mm: writeback: cleanups in preparation for per-zone dirty limits
has been added to the -mm tree.  Its filename is
     mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -173,12 +174,12 @@ static unsigned long highmem_dirtyable_m
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
 
@@ -192,6 +193,47 @@ static unsigned long determine_dirtyable
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
@@ -203,7 +245,7 @@ static int calc_period_shift(void)
 	if (vm_dirty_bytes)
 		dirty_total = vm_dirty_bytes / PAGE_SIZE;
 	else
-		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
+		dirty_total = (vm_dirty_ratio * global_dirtyable_memory()) /
 				100;
 	return 2 + ilog2(dirty_total - 1);
 }
@@ -363,47 +405,6 @@ static unsigned long hard_dirty_limit(un
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
Subject: Subject: mm: writeback: cleanups in preparation for per-zone dirty limits

Patches currently in -mm which might be from jweiner@redhat.com are

mm-add-extra-free-kbytes-tunable.patch
mm-migrate-one-less-atomic-operation.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
fadvise-only-initiate-writeback-for-specified-range-with-fadv_dontneed.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-writeback-cleanups-in-preparation-for-per-zone-dirty-limits.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
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
thp-improve-the-error-code-path.patch
thp-remove-unnecessary-tlb-flush-for-mprotect.patch
thp-add-tlb_remove_pmd_tlb_entry.patch
thp-improve-order-in-lru-list-for-split-huge-page.patch

