From: akpm@linux-foundation.org
Subject: [merged] mm-try-to-distribute-dirty-pages-fairly-across-zones.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:28 -0800
Message-ID: <20120111212729.4C57B10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933986Ab2AKV1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:30 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: try to distribute dirty pages fairly across zones
has been removed from the -mm tree.  Its filename was
     mm-try-to-distribute-dirty-pages-fairly-across-zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: try to distribute dirty pages fairly across zones

The maximum number of dirty pages that exist in the system at any time is
determined by a number of pages considered dirtyable and a user-configured
percentage of those, or an absolute number in bytes.

This number of dirtyable pages is the sum of memory provided by all the
zones in the system minus their lowmem reserves and high watermarks, so
that the system can retain a healthy number of free pages without having
to reclaim dirty pages.

But there is a flaw in that we have a zoned page allocator which does not
care about the global state but rather the state of individual memory
zones.  And right now there is nothing that prevents one zone from filling
up with dirty pages while other zones are spared, which frequently leads
to situations where kswapd, in order to restore the watermark of free
pages, does indeed have to write pages from that zone's LRU list.  This
can interfere so badly with IO from the flusher threads that major
filesystems (btrfs, xfs, ext4) mostly ignore write requests from reclaim
already, taking away the VM's only possibility to keep such a zone
balanced, aside from hoping the flushers will soon clean pages from that
zone.

Enter per-zone dirty limits.  They are to a zone's dirtyable memory what
the global limit is to the global amount of dirtyable memory, and try to
make sure that no single zone receives more than its fair share of the
globally allowed dirty pages in the first place.  As the number of pages
considered dirtyable excludes the zones' lowmem reserves and high
watermarks, the maximum number of dirty pages in a zone is such that the
zone can always be balanced without requiring page cleaning.

As this is a placement decision in the page allocator and pages are
dirtied only after the allocation, this patch allows allocators to pass
__GFP_WRITE when they know in advance that the page will be written to and
become dirty soon.  The page allocator will then attempt to allocate from
the first zone of the zonelist - which on NUMA is determined by the task's
NUMA memory policy - that has not exceeded its dirty limit.

At first glance, it would appear that the diversion to lower zones can
increase pressure on them, but this is not the case.  With a full high
zone, allocations will be diverted to lower zones eventually, so it is
more of a shift in timing of the lower zone allocations.  Workloads that
previously could fit their dirty pages completely in the higher zone may
be forced to allocate from lower zones, but the amount of pages that
"spill over" are limited themselves by the lower zones' dirty constraints,
and thus unlikely to become a problem.

For now, the problem of unfair dirty page distribution remains for NUMA
configurations where the zones allowed for allocation are in sum not big
enough to trigger the global dirty limits, wake up the flusher threads and
remedy the situation.  Because of this, an allocation that could not
succeed on any of the considered zones is allowed to ignore the dirty
limits before going into direct reclaim or even failing the allocation,
until a future patch changes the global dirty throttling and flusher
thread activation so that they take individual zone states into account.

			Test results

15M DMA + 3246M DMA32 + 504 Normal = 3765M memory
40% dirty ratio
16G USB thumb drive
10 runs of dd if=/dev/zero of=disk/zeroes bs=32k count=$((10 << 15))

		seconds			nr_vmscan_write
		        (stddev)	       min|     median|        max
xfs
vanilla:	 549.747( 3.492)	     0.000|      0.000|      0.000
patched:	 550.996( 3.802)	     0.000|      0.000|      0.000

fuse-ntfs
vanilla:	1183.094(53.178)	 54349.000|  59341.000|  65163.000
patched:	 558.049(17.914)	     0.000|      0.000|     43.000

btrfs
vanilla:	 573.679(14.015)	156657.000| 460178.000| 606926.000
patched:	 563.365(11.368)	     0.000|      0.000|   1362.000

ext4
vanilla:	 561.197(15.782)	     0.000|2725438.000|4143837.000
patched:	 568.806(17.496)	     0.000|      0.000|      0.000

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h       |    4 +
 include/linux/writeback.h |    1 
 mm/page-writeback.c       |   82 ++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c           |   29 ++++++++++++
 4 files changed, 115 insertions(+), 1 deletion(-)

diff -puN include/linux/gfp.h~mm-try-to-distribute-dirty-pages-fairly-across-zones include/linux/gfp.h
--- a/include/linux/gfp.h~mm-try-to-distribute-dirty-pages-fairly-across-zones
+++ a/include/linux/gfp.h
@@ -36,6 +36,7 @@ struct vm_area_struct;
 #endif
 #define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
+#define ___GFP_WRITE		0x1000000u
 
 /*
  * GFP bitmasks..
@@ -85,6 +86,7 @@ struct vm_area_struct;
 
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
+#define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
 /*
  * This may seem redundant, but it's a way of annotating false positives vs.
@@ -92,7 +94,7 @@ struct vm_area_struct;
  */
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 
-#define __GFP_BITS_SHIFT 24	/* Room for N __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
diff -puN include/linux/writeback.h~mm-try-to-distribute-dirty-pages-fairly-across-zones include/linux/writeback.h
--- a/include/linux/writeback.h~mm-try-to-distribute-dirty-pages-fairly-across-zones
+++ a/include/linux/writeback.h
@@ -124,6 +124,7 @@ void laptop_mode_timer_fn(unsigned long 
 static inline void laptop_sync_completion(void) { }
 #endif
 void throttle_vm_writeout(gfp_t gfp_mask);
+bool zone_dirty_ok(struct zone *zone);
 
 extern unsigned long global_dirty_limit;
 
diff -puN mm/page-writeback.c~mm-try-to-distribute-dirty-pages-fairly-across-zones mm/page-writeback.c
--- a/mm/page-writeback.c~mm-try-to-distribute-dirty-pages-fairly-across-zones
+++ a/mm/page-writeback.c
@@ -147,6 +147,24 @@ static struct prop_descriptor vm_complet
  * clamping level.
  */
 
+/*
+ * In a memory zone, there is a certain amount of pages we consider
+ * available for the page cache, which is essentially the number of
+ * free and reclaimable pages, minus some zone reserves to protect
+ * lowmem and the ability to uphold the zone's watermarks without
+ * requiring writeback.
+ *
+ * This number of dirtyable pages is the base value of which the
+ * user-configurable dirty ratio is the effictive number of pages that
+ * are allowed to be actually dirtied.  Per individual zone, or
+ * globally by using the sum of dirtyable pages over all zones.
+ *
+ * Because the user is allowed to specify the dirty limit globally as
+ * absolute number of bytes, calculating the per-zone dirty limit can
+ * require translating the configured limit into a percentage of
+ * global dirtyable memory first.
+ */
+
 static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
@@ -232,6 +250,70 @@ void global_dirty_limits(unsigned long *
 	trace_global_dirty_state(background, dirty);
 }
 
+/**
+ * zone_dirtyable_memory - number of dirtyable pages in a zone
+ * @zone: the zone
+ *
+ * Returns the zone's number of pages potentially available for dirty
+ * page cache.  This is the base value for the per-zone dirty limits.
+ */
+static unsigned long zone_dirtyable_memory(struct zone *zone)
+{
+	/*
+	 * The effective global number of dirtyable pages may exclude
+	 * highmem as a big-picture measure to keep the ratio between
+	 * dirty memory and lowmem reasonable.
+	 *
+	 * But this function is purely about the individual zone and a
+	 * highmem zone can hold its share of dirty pages, so we don't
+	 * care about vm_highmem_is_dirtyable here.
+	 */
+	return zone_page_state(zone, NR_FREE_PAGES) +
+	       zone_reclaimable_pages(zone) -
+	       zone->dirty_balance_reserve;
+}
+
+/**
+ * zone_dirty_limit - maximum number of dirty pages allowed in a zone
+ * @zone: the zone
+ *
+ * Returns the maximum number of dirty pages allowed in a zone, based
+ * on the zone's dirtyable memory.
+ */
+static unsigned long zone_dirty_limit(struct zone *zone)
+{
+	unsigned long zone_memory = zone_dirtyable_memory(zone);
+	struct task_struct *tsk = current;
+	unsigned long dirty;
+
+	if (vm_dirty_bytes)
+		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE) *
+			zone_memory / global_dirtyable_memory();
+	else
+		dirty = vm_dirty_ratio * zone_memory / 100;
+
+	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk))
+		dirty += dirty / 4;
+
+	return dirty;
+}
+
+/**
+ * zone_dirty_ok - tells whether a zone is within its dirty limits
+ * @zone: the zone to check
+ *
+ * Returns %true when the dirty pages in @zone are within the zone's
+ * dirty limit, %false if the limit is exceeded.
+ */
+bool zone_dirty_ok(struct zone *zone)
+{
+	unsigned long limit = zone_dirty_limit(zone);
+
+	return zone_page_state(zone, NR_FILE_DIRTY) +
+	       zone_page_state(zone, NR_UNSTABLE_NFS) +
+	       zone_page_state(zone, NR_WRITEBACK) <= limit;
+}
+
 /*
  * couple the period to the dirty_ratio:
  *
diff -puN mm/page_alloc.c~mm-try-to-distribute-dirty-pages-fairly-across-zones mm/page_alloc.c
--- a/mm/page_alloc.c~mm-try-to-distribute-dirty-pages-fairly-across-zones
+++ a/mm/page_alloc.c
@@ -1735,6 +1735,35 @@ zonelist_scan:
 		if ((alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
+		/*
+		 * When allocating a page cache page for writing, we
+		 * want to get it from a zone that is within its dirty
+		 * limit, such that no single zone holds more than its
+		 * proportional share of globally allowed dirty pages.
+		 * The dirty limits take into account the zone's
+		 * lowmem reserves and high watermark so that kswapd
+		 * should be able to balance it without having to
+		 * write pages from its LRU list.
+		 *
+		 * This may look like it could increase pressure on
+		 * lower zones by failing allocations in higher zones
+		 * before they are full.  But the pages that do spill
+		 * over are limited as the lower zones are protected
+		 * by this very same mechanism.  It should not become
+		 * a practical burden to them.
+		 *
+		 * XXX: For now, allow allocations to potentially
+		 * exceed the per-zone dirty limit in the slowpath
+		 * (ALLOC_WMARK_LOW unset) before going into reclaim,
+		 * which is important when on a NUMA setup the allowed
+		 * zones are together not big enough to reach the
+		 * global limit.  The proper fix for these situations
+		 * will require awareness of zones in the
+		 * dirty-throttling and the flusher threads.
+		 */
+		if ((alloc_flags & ALLOC_WMARK_LOW) &&
+		    (gfp_mask & __GFP_WRITE) && !zone_dirty_ok(zone))
+			goto this_zone_full;
 
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
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

