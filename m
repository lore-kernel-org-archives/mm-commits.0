From: akpm@linux-foundation.org
Subject: [patch 033/101] mm, page_alloc: consider dirtyable memory in
 terms of nodes
Date: Thu, 28 Jul 2016 15:46:11 -0700
Message-ID: <579a8b33.t9m1Ur9EiMKyReaj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbcG1WqM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: consider dirtyable memory in terms of nodes

Historically dirty pages were spread among zones but now that LRUs are
per-node it is more appropriate to consider dirty pages in a node.

Link: http://lkml.kernel.org/r/1467970510-21195-17-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h    |   12 ++--
 include/linux/writeback.h |    2 
 mm/page-writeback.c       |   91 ++++++++++++++++++++++++------------
 mm/page_alloc.c           |   26 ++++------
 4 files changed, 79 insertions(+), 52 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes
+++ a/include/linux/mmzone.h
@@ -363,12 +363,6 @@ struct zone {
 	struct pglist_data	*zone_pgdat;
 	struct per_cpu_pageset __percpu *pageset;
 
-	/*
-	 * This is a per-zone reserve of pages that are not available
-	 * to userspace allocations.
-	 */
-	unsigned long		totalreserve_pages;
-
 #ifndef CONFIG_SPARSEMEM
 	/*
 	 * Flags for a pageblock_nr_pages block. See pageblock-flags.h.
@@ -687,6 +681,12 @@ typedef struct pglist_data {
 	/* Number of pages migrated during the rate limiting time interval */
 	unsigned long numabalancing_migrate_nr_pages;
 #endif
+	/*
+	 * This is a per-node reserve of pages that are not available
+	 * to userspace allocations.
+	 */
+	unsigned long		totalreserve_pages;
+
 	/* Write-intensive fields used by page reclaim */
 	ZONE_PADDING(_pad1_)
 	spinlock_t		lru_lock;
diff -puN include/linux/writeback.h~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes include/linux/writeback.h
--- a/include/linux/writeback.h~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes
+++ a/include/linux/writeback.h
@@ -320,7 +320,7 @@ void laptop_mode_timer_fn(unsigned long
 static inline void laptop_sync_completion(void) { }
 #endif
 void throttle_vm_writeout(gfp_t gfp_mask);
-bool zone_dirty_ok(struct zone *zone);
+bool node_dirty_ok(struct pglist_data *pgdat);
 int wb_domain_init(struct wb_domain *dom, gfp_t gfp);
 #ifdef CONFIG_CGROUP_WRITEBACK
 void wb_domain_exit(struct wb_domain *dom);
diff -puN mm/page-writeback.c~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes
+++ a/mm/page-writeback.c
@@ -267,26 +267,35 @@ static void wb_min_max_ratio(struct bdi_
  */
 
 /**
- * zone_dirtyable_memory - number of dirtyable pages in a zone
- * @zone: the zone
+ * node_dirtyable_memory - number of dirtyable pages in a node
+ * @pgdat: the node
  *
- * Returns the zone's number of pages potentially available for dirty
- * page cache.  This is the base value for the per-zone dirty limits.
+ * Returns the node's number of pages potentially available for dirty
+ * page cache.  This is the base value for the per-node dirty limits.
  */
-static unsigned long zone_dirtyable_memory(struct zone *zone)
+static unsigned long node_dirtyable_memory(struct pglist_data *pgdat)
 {
-	unsigned long nr_pages;
+	unsigned long nr_pages = 0;
+	int z;
+
+	for (z = 0; z < MAX_NR_ZONES; z++) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		if (!populated_zone(zone))
+			continue;
+
+		nr_pages += zone_page_state(zone, NR_FREE_PAGES);
+	}
 
-	nr_pages = zone_page_state(zone, NR_FREE_PAGES);
 	/*
 	 * Pages reserved for the kernel should not be considered
 	 * dirtyable, to prevent a situation where reclaim has to
 	 * clean pages in order to balance the zones.
 	 */
-	nr_pages -= min(nr_pages, zone->totalreserve_pages);
+	nr_pages -= min(nr_pages, pgdat->totalreserve_pages);
 
-	nr_pages += node_page_state(zone->zone_pgdat, NR_INACTIVE_FILE);
-	nr_pages += node_page_state(zone->zone_pgdat, NR_ACTIVE_FILE);
+	nr_pages += node_page_state(pgdat, NR_INACTIVE_FILE);
+	nr_pages += node_page_state(pgdat, NR_ACTIVE_FILE);
 
 	return nr_pages;
 }
@@ -299,13 +308,24 @@ static unsigned long highmem_dirtyable_m
 	int i;
 
 	for_each_node_state(node, N_HIGH_MEMORY) {
-		for (i = 0; i < MAX_NR_ZONES; i++) {
-			struct zone *z = &NODE_DATA(node)->node_zones[i];
+		for (i = ZONE_NORMAL + 1; i < MAX_NR_ZONES; i++) {
+			struct zone *z;
+			unsigned long dirtyable;
+
+			if (!is_highmem_idx(i))
+				continue;
+
+			z = &NODE_DATA(node)->node_zones[i];
+			dirtyable = zone_page_state(z, NR_FREE_PAGES) +
+				zone_page_state(z, NR_ZONE_LRU_FILE);
 
-			if (is_highmem(z))
-				x += zone_dirtyable_memory(z);
+			/* watch for underflows */
+			dirtyable -= min(dirtyable, high_wmark_pages(z));
+
+			x += dirtyable;
 		}
 	}
+
 	/*
 	 * Unreclaimable memory (kernel memory or anonymous memory
 	 * without swap) can bring down the dirtyable pages below
@@ -445,23 +465,23 @@ void global_dirty_limits(unsigned long *
 }
 
 /**
- * zone_dirty_limit - maximum number of dirty pages allowed in a zone
- * @zone: the zone
+ * node_dirty_limit - maximum number of dirty pages allowed in a node
+ * @pgdat: the node
  *
- * Returns the maximum number of dirty pages allowed in a zone, based
- * on the zone's dirtyable memory.
+ * Returns the maximum number of dirty pages allowed in a node, based
+ * on the node's dirtyable memory.
  */
-static unsigned long zone_dirty_limit(struct zone *zone)
+static unsigned long node_dirty_limit(struct pglist_data *pgdat)
 {
-	unsigned long zone_memory = zone_dirtyable_memory(zone);
+	unsigned long node_memory = node_dirtyable_memory(pgdat);
 	struct task_struct *tsk = current;
 	unsigned long dirty;
 
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE) *
-			zone_memory / global_dirtyable_memory();
+			node_memory / global_dirtyable_memory();
 	else
-		dirty = vm_dirty_ratio * zone_memory / 100;
+		dirty = vm_dirty_ratio * node_memory / 100;
 
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk))
 		dirty += dirty / 4;
@@ -470,19 +490,30 @@ static unsigned long zone_dirty_limit(st
 }
 
 /**
- * zone_dirty_ok - tells whether a zone is within its dirty limits
- * @zone: the zone to check
+ * node_dirty_ok - tells whether a node is within its dirty limits
+ * @pgdat: the node to check
  *
- * Returns %true when the dirty pages in @zone are within the zone's
+ * Returns %true when the dirty pages in @pgdat are within the node's
  * dirty limit, %false if the limit is exceeded.
  */
-bool zone_dirty_ok(struct zone *zone)
+bool node_dirty_ok(struct pglist_data *pgdat)
 {
-	unsigned long limit = zone_dirty_limit(zone);
+	int z;
+	unsigned long limit = node_dirty_limit(pgdat);
+	unsigned long nr_pages = 0;
+
+	for (z = 0; z < MAX_NR_ZONES; z++) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		if (!populated_zone(zone))
+			continue;
+
+		nr_pages += zone_page_state(zone, NR_FILE_DIRTY);
+		nr_pages += zone_page_state(zone, NR_UNSTABLE_NFS);
+		nr_pages += zone_page_state(zone, NR_WRITEBACK);
+	}
 
-	return zone_page_state(zone, NR_FILE_DIRTY) +
-	       zone_page_state(zone, NR_UNSTABLE_NFS) +
-	       zone_page_state(zone, NR_WRITEBACK) <= limit;
+	return nr_pages <= limit;
 }
 
 int dirty_background_ratio_handler(struct ctl_table *table, int write,
diff -puN mm/page_alloc.c~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes
+++ a/mm/page_alloc.c
@@ -2912,31 +2912,24 @@ zonelist_scan:
 		}
 		/*
 		 * When allocating a page cache page for writing, we
-		 * want to get it from a zone that is within its dirty
-		 * limit, such that no single zone holds more than its
+		 * want to get it from a node that is within its dirty
+		 * limit, such that no single node holds more than its
 		 * proportional share of globally allowed dirty pages.
-		 * The dirty limits take into account the zone's
+		 * The dirty limits take into account the node's
 		 * lowmem reserves and high watermark so that kswapd
 		 * should be able to balance it without having to
 		 * write pages from its LRU list.
 		 *
-		 * This may look like it could increase pressure on
-		 * lower zones by failing allocations in higher zones
-		 * before they are full.  But the pages that do spill
-		 * over are limited as the lower zones are protected
-		 * by this very same mechanism.  It should not become
-		 * a practical burden to them.
-		 *
 		 * XXX: For now, allow allocations to potentially
-		 * exceed the per-zone dirty limit in the slowpath
+		 * exceed the per-node dirty limit in the slowpath
 		 * (spread_dirty_pages unset) before going into reclaim,
 		 * which is important when on a NUMA setup the allowed
-		 * zones are together not big enough to reach the
+		 * nodes are together not big enough to reach the
 		 * global limit.  The proper fix for these situations
-		 * will require awareness of zones in the
+		 * will require awareness of nodes in the
 		 * dirty-throttling and the flusher threads.
 		 */
-		if (ac->spread_dirty_pages && !zone_dirty_ok(zone))
+		if (ac->spread_dirty_pages && !node_dirty_ok(zone->zone_pgdat))
 			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
@@ -6701,6 +6694,9 @@ static void calculate_totalreserve_pages
 	enum zone_type i, j;
 
 	for_each_online_pgdat(pgdat) {
+
+		pgdat->totalreserve_pages = 0;
+
 		for (i = 0; i < MAX_NR_ZONES; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 			long max = 0;
@@ -6717,7 +6713,7 @@ static void calculate_totalreserve_pages
 			if (max > zone->managed_pages)
 				max = zone->managed_pages;
 
-			zone->totalreserve_pages = max;
+			pgdat->totalreserve_pages += max;
 
 			reserve_pages += max;
 		}
_
