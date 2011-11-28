From: akpm@linux-foundation.org
Subject: + mm-exclude-reserved-pages-from-dirtyable-memory.patch added to -mm tree
Date: Mon, 28 Nov 2011 14:29:58 -0800
Message-ID: <201111282229.pASMTwd4015469@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:65217 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1K1WaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 17:30:04 -0500
Received: by ggnp2 with SMTP id p2so587243ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 14:30:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jweiner@redhat.com, chris.mason@oracle.com, david@fromorbit.com, fengguang.wu@intel.com, hch@infradead.org, jack@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com


The patch titled
     Subject: mm: exclude reserved pages from dirtyable memory
has been added to the -mm tree.  Its filename is
     mm-exclude-reserved-pages-from-dirtyable-memory.patch

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
 mm/page-writeback.c    |    6 ++++--
 mm/page_alloc.c        |   19 +++++++++++++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

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
@@ -211,6 +211,7 @@ struct swap_list_t {
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
+extern unsigned long dirty_balance_reserve;
 extern int min_free_kbytes;
 extern int extra_free_kbytes;
 extern unsigned int nr_free_buffer_pages(void);
diff -puN mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-exclude-reserved-pages-from-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -157,7 +157,8 @@ static unsigned long highmem_dirtyable_m
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
 		x += zone_page_state(z, NR_FREE_PAGES) +
-		     zone_reclaimable_pages(z);
+		     zone_reclaimable_pages(z) -
+		     zone->dirty_balance_reserve;
 	}
 	/*
 	 * Make sure that the number of highmem pages is never larger
@@ -181,7 +182,8 @@ static unsigned long determine_dirtyable
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
 
@@ -5184,8 +5192,19 @@ static void calculate_totalreserve_pages
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
Subject: Subject: mm: exclude reserved pages from dirtyable memory

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

