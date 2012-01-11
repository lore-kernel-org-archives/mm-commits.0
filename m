From: akpm@linux-foundation.org
Subject: [merged] mm-exclude-reserved-pages-from-dirtyable-memory.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:27:18 -0800
Message-ID: <20120111212719.0BD6810004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:58611 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962Ab2AKV1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:27:20 -0500
Received: by mail-yw0-f74.google.com with SMTP id p56so153744yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:27:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: exclude reserved pages from dirtyable memory
has been removed from the -mm tree.  Its filename was
     mm-exclude-reserved-pages-from-dirtyable-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: exclude reserved pages from dirtyable memory

Per-zone dirty limits try to distribute page cache pages allocated for
writing across zones in proportion to the individual zone sizes, to reduce
the likelihood of reclaim having to write back individual pages from the
LRU lists in order to make progress.


This patch:

The amount of dirtyable pages should not include the full number of free
pages: there is a number of reserved pages that the page allocator and
kswapd always try to keep free.

The closer (reclaimable pages - dirty pages) is to the number of reserved
pages, the more likely it becomes for reclaim to run into dirty pages:

       +----------+ ---
       |   anon   |  |
       +----------+  |
       |          |  |
       |          |  -- dirty limit new    -- flusher new
       |   file   |  |                     |
       |          |  |                     |
       |          |  -- dirty limit old    -- flusher old
       |          |                        |
       +----------+                       --- reclaim
       | reserved |
       +----------+
       |  kernel  |
       +----------+

This patch introduces a per-zone dirty reserve that takes both the lowmem
reserve as well as the high watermark of the zone into account, and a
global sum of those per-zone values that is subtracted from the global
amount of dirtyable pages.  The lowmem reserve is unavailable to page
cache allocations and kswapd tries to keep the high watermark free.  We
don't want to end up in a situation where reclaim has to clean pages in
order to balance zones.

Not treating reserved pages as dirtyable on a global level is only a
conceptual fix.  In reality, dirty pages are not distributed equally
across zones and reclaim runs into dirty pages on a regular basis.

But it is important to get this right before tackling the problem on a
per-zone level, where the distance between reclaim and the dirty pages is
mostly much smaller in absolute numbers.

[akpm@linux-foundation.org: fix highmem build]
Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++++++
 include/linux/swap.h   |    1 +
 mm/page-writeback.c    |    5 +++--
 mm/page_alloc.c        |   19 +++++++++++++++++++
 4 files changed, 29 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-exclude-reserved-pages-from-dirtyable-memory include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-exclude-reserved-pages-from-dirtyable-memory
+++ a/include/linux/mmzone.h
@@ -317,6 +317,12 @@ struct zone {
 	 */
 	unsigned long		lowmem_reserve[MAX_NR_ZONES];
 
+	/*
+	 * This is a per-zone reserve of pages that should not be
+	 * considered dirtyable memory.
+	 */
+	unsigned long		dirty_balance_reserve;
+
 #ifdef CONFIG_NUMA
 	int node;
 	/*
diff -puN include/linux/swap.h~mm-exclude-reserved-pages-from-dirtyable-memory include/linux/swap.h
--- a/include/linux/swap.h~mm-exclude-reserved-pages-from-dirtyable-memory
+++ a/include/linux/swap.h
@@ -207,6 +207,7 @@ struct swap_list_t {
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
+extern unsigned long dirty_balance_reserve;
 extern unsigned int nr_free_buffer_pages(void);
 extern unsigned int nr_free_pagecache_pages(void);
 
diff -puN mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -157,7 +157,7 @@ static unsigned long highmem_dirtyable_m
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
 		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z);
+		     zone_reclaimable_pages(z) - z->dirty_balance_reserve;
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -181,7 +181,8 @@ static unsigned long determine_dirtyable
 {
 	unsigned long x;
 
-	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages();
+	x = global_page_state(NR_FREE_PAGES) + global_reclaimable_pages() -
+	    dirty_balance_reserve;
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff -puN mm/page_alloc.c~mm-exclude-reserved-pages-from-dirtyable-memory mm/page_alloc.c
--- a/mm/page_alloc.c~mm-exclude-reserved-pages-from-dirtyable-memory
+++ a/mm/page_alloc.c
@@ -97,6 +97,14 @@ EXPORT_SYMBOL(node_states);
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
+/*
+ * When calculating the number of globally allowed dirty pages, there
+ * is a certain number of per-zone reserves that should not be
+ * considered dirtyable memory.  This is the sum of those reserves
+ * over all existing zones that contribute dirtyable memory.
+ */
+unsigned long dirty_balance_reserve __read_mostly;
+
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
@@ -4822,8 +4830,19 @@ static void calculate_totalreserve_pages
 			if (max > zone->present_pages)
 				max = zone->present_pages;
 			reserve_pages += max;
+			/*
+			 * Lowmem reserves are not available to
+			 * GFP_HIGHUSER page cache allocations and
+			 * kswapd tries to balance zones to their high
+			 * watermark.  As a result, neither should be
+			 * regarded as dirtyable memory, to prevent a
+			 * situation where reclaim has to clean pages
+			 * in order to balance the zones.
+			 */
+			zone->dirty_balance_reserve = max;
 		}
 	}
+	dirty_balance_reserve = reserve_pages;
 	totalreserve_pages = reserve_pages;
 }
 
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

