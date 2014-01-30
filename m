From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch
 removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:04 -0800
Message-ID: <52eab070.vVwST3H0FdTreOkj%akpm__10421.1478065283$1391112331$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaA3UFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, fengguang.wu@intel.com, hannes@cmpxchg.org

Subject: [merged] mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch removed from -mm tree
To: hannes@cmpxchg.org,fengguang.wu@intel.com,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,stable@vger.kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:04 -0800


The patch titled
     Subject: mm/page-writeback.c: do not count anon pages as dirtyable memory
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm/page-writeback.c: do not count anon pages as dirtyable memory

The VM is currently heavily tuned to avoid swapping.  Whether that is good
or bad is a separate discussion, but as long as the VM won't swap to make
room for dirty cache, we can not consider anonymous pages when calculating
the amount of dirtyable memory, the baseline to which
dirty_background_ratio and dirty_ratio are applied.

A simple workload that occupies a significant size (40+%, depending on
memory layout, storage speeds etc.) of memory with anon/tmpfs pages and
uses the remainder for a streaming writer demonstrates this problem.  In
that case, the actual cache pages are a small fraction of what is
considered dirtyable overall, which results in an relatively large portion
of the cache pages to be dirtied.  As kswapd starts rotating these, random
tasks enter direct reclaim and stall on IO.

Only consider free pages and file pages dirtyable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Tested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 --
 mm/internal.h          |    1 -
 mm/page-writeback.c    |    6 ++++--
 mm/vmscan.c            |   23 +----------------------
 4 files changed, 5 insertions(+), 27 deletions(-)

diff -puN include/linux/vmstat.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/include/linux/vmstat.h
@@ -142,8 +142,6 @@ static inline unsigned long zone_page_st
 	return x;
 }
 
-extern unsigned long global_reclaimable_pages(void);
-
 #ifdef CONFIG_NUMA
 /*
  * Determine the per node value of a stat item. This function
diff -puN mm/internal.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory mm/internal.h
--- a/mm/internal.h~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/mm/internal.h
@@ -83,7 +83,6 @@ extern unsigned long highest_memmap_pfn;
  */
 extern int isolate_lru_page(struct page *page);
 extern void putback_lru_page(struct page *page);
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern bool zone_reclaimable(struct zone *zone);
 
 /*
diff -puN mm/page-writeback.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/mm/page-writeback.c
@@ -205,7 +205,8 @@ static unsigned long zone_dirtyable_memo
 	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
 	nr_pages -= min(nr_pages, zone->dirty_balance_reserve);
 
-	nr_pages += zone_reclaimable_pages(zone);
+	nr_pages += zone_page_state(zone, NR_INACTIVE_FILE);
+	nr_pages += zone_page_state(zone, NR_ACTIVE_FILE);
 
 	return nr_pages;
 }
@@ -258,7 +259,8 @@ static unsigned long global_dirtyable_me
 	x = global_page_state(NR_FREE_PAGES);
 	x -= min(x, dirty_balance_reserve);
 
-	x += global_reclaimable_pages();
+	x += global_page_state(NR_INACTIVE_FILE);
+	x += global_page_state(NR_ACTIVE_FILE);
 
 	if (!vm_highmem_is_dirtyable)
 		x -= highmem_dirtyable_memory(x);
diff -puN mm/vmscan.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory mm/vmscan.c
--- a/mm/vmscan.c~mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory
+++ a/mm/vmscan.c
@@ -147,7 +147,7 @@ static bool global_reclaim(struct scan_c
 }
 #endif
 
-unsigned long zone_reclaimable_pages(struct zone *zone)
+static unsigned long zone_reclaimable_pages(struct zone *zone)
 {
 	int nr;
 
@@ -3315,27 +3315,6 @@ void wakeup_kswapd(struct zone *zone, in
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
-/*
- * The reclaimable count would be mostly accurate.
- * The less reclaimable pages may be
- * - mlocked pages, which will be moved to unevictable list when encountered
- * - mapped pages, which may require several travels to be reclaimed
- * - dirty pages, which is not "instantly" reclaimable
- */
-unsigned long global_reclaimable_pages(void)
-{
-	int nr;
-
-	nr = global_page_state(NR_ACTIVE_FILE) +
-	     global_page_state(NR_INACTIVE_FILE);
-
-	if (get_nr_swap_pages() > 0)
-		nr += global_page_state(NR_ACTIVE_ANON) +
-		      global_page_state(NR_INACTIVE_ANON);
-
-	return nr;
-}
