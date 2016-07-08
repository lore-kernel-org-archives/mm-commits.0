From: akpm@linux-foundation.org
Subject: + mm-convert-zone_reclaim-to-node_reclaim.patch added to -mm tree
Date: Fri, 08 Jul 2016 13:33:59 -0700
Message-ID: <57800e37.a0e+Gal62ZjX9BRz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbcGHUeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert zone_reclaim to node_reclaim
has been added to the -mm tree.  Its filename is
     mm-convert-zone_reclaim-to-node_reclaim.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-zone_reclaim-to-node_reclaim.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-zone_reclaim-to-node_reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: convert zone_reclaim to node_reclaim

As reclaim is now per-node based, convert zone_reclaim to be node_reclaim.
It is possible that a node will be reclaimed multiple times if it has
multiple zones but this is unavoidable without caching all nodes traversed
so far.  The documentation and interface to userspace is the same from a
configuration perspective and will will be similar in behaviour unless the
node-local allocation requests were also limited to lower zones.

Link: http://lkml.kernel.org/r/1467970510-21195-24-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h   |   18 ++++----
 include/linux/swap.h     |    9 ++--
 include/linux/topology.h |    2 
 kernel/sysctl.c          |    4 -
 mm/internal.h            |    8 +--
 mm/khugepaged.c          |    4 -
 mm/page_alloc.c          |   24 +++++++----
 mm/vmscan.c              |   77 ++++++++++++++++++-------------------
 8 files changed, 77 insertions(+), 69 deletions(-)

diff -puN include/linux/mmzone.h~mm-convert-zone_reclaim-to-node_reclaim include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-convert-zone_reclaim-to-node_reclaim
+++ a/include/linux/mmzone.h
@@ -372,14 +372,6 @@ struct zone {
 	unsigned long		*pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
 
-#ifdef CONFIG_NUMA
-	/*
-	 * zone reclaim becomes active if more unmapped pages exist.
-	 */
-	unsigned long		min_unmapped_pages;
-	unsigned long		min_slab_pages;
-#endif /* CONFIG_NUMA */
-
 	/* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
 	unsigned long		zone_start_pfn;
 
@@ -525,7 +517,6 @@ struct zone {
 } ____cacheline_internodealigned_in_smp;
 
 enum zone_flags {
-	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
 	ZONE_FAIR_DEPLETED,		/* fair zone policy batch depleted */
 };
 
@@ -540,6 +531,7 @@ enum pgdat_flags {
 	PGDAT_WRITEBACK,		/* reclaim scanning has recently found
 					 * many pages under writeback
 					 */
+	PGDAT_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
 };
 
 static inline unsigned long zone_end_pfn(const struct zone *zone)
@@ -688,6 +680,14 @@ typedef struct pglist_data {
 	 */
 	unsigned long		totalreserve_pages;
 
+#ifdef CONFIG_NUMA
+	/*
+	 * zone reclaim becomes active if more unmapped pages exist.
+	 */
+	unsigned long		min_unmapped_pages;
+	unsigned long		min_slab_pages;
+#endif /* CONFIG_NUMA */
+
 	/* Write-intensive fields used by page reclaim */
 	ZONE_PADDING(_pad1_)
 	spinlock_t		lru_lock;
diff -puN include/linux/swap.h~mm-convert-zone_reclaim-to-node_reclaim include/linux/swap.h
--- a/include/linux/swap.h~mm-convert-zone_reclaim-to-node_reclaim
+++ a/include/linux/swap.h
@@ -326,13 +326,14 @@ extern int remove_mapping(struct address
 extern unsigned long vm_total_pages;
 
 #ifdef CONFIG_NUMA
-extern int zone_reclaim_mode;
+extern int node_reclaim_mode;
 extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
-extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
+extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
 #else
-#define zone_reclaim_mode 0
-static inline int zone_reclaim(struct zone *z, gfp_t mask, unsigned int order)
+#define node_reclaim_mode 0
+static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
+				unsigned int order)
 {
 	return 0;
 }
diff -puN include/linux/topology.h~mm-convert-zone_reclaim-to-node_reclaim include/linux/topology.h
--- a/include/linux/topology.h~mm-convert-zone_reclaim-to-node_reclaim
+++ a/include/linux/topology.h
@@ -54,7 +54,7 @@ int arch_update_cpu_topology(void);
 /*
  * If the distance between nodes in a system is larger than RECLAIM_DISTANCE
  * (in whatever arch specific measurement units returned by node_distance())
- * and zone_reclaim_mode is enabled then the VM will only call zone_reclaim()
+ * and node_reclaim_mode is enabled then the VM will only call node_reclaim()
  * on nodes within this distance.
  */
 #define RECLAIM_DISTANCE 30
diff -puN kernel/sysctl.c~mm-convert-zone_reclaim-to-node_reclaim kernel/sysctl.c
--- a/kernel/sysctl.c~mm-convert-zone_reclaim-to-node_reclaim
+++ a/kernel/sysctl.c
@@ -1497,8 +1497,8 @@ static struct ctl_table vm_table[] = {
 #ifdef CONFIG_NUMA
 	{
 		.procname	= "zone_reclaim_mode",
-		.data		= &zone_reclaim_mode,
-		.maxlen		= sizeof(zone_reclaim_mode),
+		.data		= &node_reclaim_mode,
+		.maxlen		= sizeof(node_reclaim_mode),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
diff -puN mm/internal.h~mm-convert-zone_reclaim-to-node_reclaim mm/internal.h
--- a/mm/internal.h~mm-convert-zone_reclaim-to-node_reclaim
+++ a/mm/internal.h
@@ -433,10 +433,10 @@ static inline void mminit_validate_memmo
 }
 #endif /* CONFIG_SPARSEMEM */
 
-#define ZONE_RECLAIM_NOSCAN	-2
-#define ZONE_RECLAIM_FULL	-1
-#define ZONE_RECLAIM_SOME	0
-#define ZONE_RECLAIM_SUCCESS	1
+#define NODE_RECLAIM_NOSCAN	-2
+#define NODE_RECLAIM_FULL	-1
+#define NODE_RECLAIM_SOME	0
+#define NODE_RECLAIM_SUCCESS	1
 
 extern int hwpoison_filter(struct page *p);
 
diff -puN mm/khugepaged.c~mm-convert-zone_reclaim-to-node_reclaim mm/khugepaged.c
--- a/mm/khugepaged.c~mm-convert-zone_reclaim-to-node_reclaim
+++ a/mm/khugepaged.c
@@ -672,10 +672,10 @@ static bool khugepaged_scan_abort(int ni
 	int i;
 
 	/*
-	 * If zone_reclaim_mode is disabled, then no extra effort is made to
+	 * If node_reclaim_mode is disabled, then no extra effort is made to
 	 * allocate memory locally.
 	 */
-	if (!zone_reclaim_mode)
+	if (!node_reclaim_mode)
 		return false;
 
 	/* If there is a count for this node already, it must be acceptable */
diff -puN mm/page_alloc.c~mm-convert-zone_reclaim-to-node_reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~mm-convert-zone_reclaim-to-node_reclaim
+++ a/mm/page_alloc.c
@@ -2942,16 +2942,16 @@ zonelist_scan:
 			if (alloc_flags & ALLOC_NO_WATERMARKS)
 				goto try_this_zone;
 
-			if (zone_reclaim_mode == 0 ||
+			if (node_reclaim_mode == 0 ||
 			    !zone_allows_reclaim(ac->preferred_zoneref->zone, zone))
 				continue;
 
-			ret = zone_reclaim(zone, gfp_mask, order);
+			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
 			switch (ret) {
-			case ZONE_RECLAIM_NOSCAN:
+			case NODE_RECLAIM_NOSCAN:
 				/* did not scan */
 				continue;
-			case ZONE_RECLAIM_FULL:
+			case NODE_RECLAIM_FULL:
 				/* scanned but unreclaimable */
 				continue;
 			default:
@@ -5948,9 +5948,9 @@ static void __paginginit free_area_init_
 		zone->managed_pages = is_highmem_idx(j) ? realsize : freesize;
 #ifdef CONFIG_NUMA
 		zone->node = nid;
-		zone->min_unmapped_pages = (freesize*sysctl_min_unmapped_ratio)
+		pgdat->min_unmapped_pages += (freesize*sysctl_min_unmapped_ratio)
 						/ 100;
-		zone->min_slab_pages = (freesize * sysctl_min_slab_ratio) / 100;
+		pgdat->min_slab_pages += (freesize * sysctl_min_slab_ratio) / 100;
 #endif
 		zone->name = zone_names[j];
 		zone->zone_pgdat = pgdat;
@@ -6922,6 +6922,7 @@ int watermark_scale_factor_sysctl_handle
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
+	struct pglist_data *pgdat;
 	struct zone *zone;
 	int rc;
 
@@ -6929,8 +6930,11 @@ int sysctl_min_unmapped_ratio_sysctl_han
 	if (rc)
 		return rc;
 
+	for_each_online_pgdat(pgdat)
+		pgdat->min_slab_pages = 0;
+
 	for_each_zone(zone)
-		zone->min_unmapped_pages = (zone->managed_pages *
+		zone->zone_pgdat->min_unmapped_pages += (zone->managed_pages *
 				sysctl_min_unmapped_ratio) / 100;
 	return 0;
 }
@@ -6938,6 +6942,7 @@ int sysctl_min_unmapped_ratio_sysctl_han
 int sysctl_min_slab_ratio_sysctl_handler(struct ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
+	struct pglist_data *pgdat;
 	struct zone *zone;
 	int rc;
 
@@ -6945,8 +6950,11 @@ int sysctl_min_slab_ratio_sysctl_handler
 	if (rc)
 		return rc;
 
+	for_each_online_pgdat(pgdat)
+		pgdat->min_slab_pages = 0;
+
 	for_each_zone(zone)
-		zone->min_slab_pages = (zone->managed_pages *
+		zone->zone_pgdat->min_slab_pages += (zone->managed_pages *
 				sysctl_min_slab_ratio) / 100;
 	return 0;
 }
diff -puN mm/vmscan.c~mm-convert-zone_reclaim-to-node_reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-convert-zone_reclaim-to-node_reclaim
+++ a/mm/vmscan.c
@@ -3563,12 +3563,12 @@ module_init(kswapd_init)
 
 #ifdef CONFIG_NUMA
 /*
- * Zone reclaim mode
+ * Node reclaim mode
  *
- * If non-zero call zone_reclaim when the number of free pages falls below
+ * If non-zero call node_reclaim when the number of free pages falls below
  * the watermarks.
  */
-int zone_reclaim_mode __read_mostly;
+int node_reclaim_mode __read_mostly;
 
 #define RECLAIM_OFF 0
 #define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
@@ -3576,14 +3576,14 @@ int zone_reclaim_mode __read_mostly;
 #define RECLAIM_UNMAP (1<<2)	/* Unmap pages during reclaim */
 
 /*
- * Priority for ZONE_RECLAIM. This determines the fraction of pages
+ * Priority for NODE_RECLAIM. This determines the fraction of pages
  * of a node considered for each zone_reclaim. 4 scans 1/16th of
  * a zone.
  */
-#define ZONE_RECLAIM_PRIORITY 4
+#define NODE_RECLAIM_PRIORITY 4
 
 /*
- * Percentage of pages in a zone that must be unmapped for zone_reclaim to
+ * Percentage of pages in a zone that must be unmapped for node_reclaim to
  * occur.
  */
 int sysctl_min_unmapped_ratio = 1;
@@ -3609,7 +3609,7 @@ static inline unsigned long node_unmappe
 }
 
 /* Work out how many page cache pages we can reclaim in this reclaim_mode */
-static unsigned long zone_pagecache_reclaimable(struct zone *zone)
+static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
 {
 	unsigned long nr_pagecache_reclaimable;
 	unsigned long delta = 0;
@@ -3620,14 +3620,14 @@ static unsigned long zone_pagecache_recl
 	 * pages like swapcache and node_unmapped_file_pages() provides
 	 * a better estimate
 	 */
-	if (zone_reclaim_mode & RECLAIM_UNMAP)
-		nr_pagecache_reclaimable = node_page_state(zone->zone_pgdat, NR_FILE_PAGES);
+	if (node_reclaim_mode & RECLAIM_UNMAP)
+		nr_pagecache_reclaimable = node_page_state(pgdat, NR_FILE_PAGES);
 	else
-		nr_pagecache_reclaimable = node_unmapped_file_pages(zone->zone_pgdat);
+		nr_pagecache_reclaimable = node_unmapped_file_pages(pgdat);
 
 	/* If we can't clean pages, remove dirty pages from consideration */
-	if (!(zone_reclaim_mode & RECLAIM_WRITE))
-		delta += node_page_state(zone->zone_pgdat, NR_FILE_DIRTY);
+	if (!(node_reclaim_mode & RECLAIM_WRITE))
+		delta += node_page_state(pgdat, NR_FILE_DIRTY);
 
 	/* Watch for any possible underflows due to delta */
 	if (unlikely(delta > nr_pagecache_reclaimable))
@@ -3637,23 +3637,24 @@ static unsigned long zone_pagecache_recl
 }
 
 /*
- * Try to free up some pages from this zone through reclaim.
+ * Try to free up some pages from this node through reclaim.
  */
-static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
+static int __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
+	int classzone_idx = gfp_zone(gfp_mask);
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
 		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
 		.order = order,
-		.priority = ZONE_RECLAIM_PRIORITY,
-		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
-		.may_unmap = !!(zone_reclaim_mode & RECLAIM_UNMAP),
+		.priority = NODE_RECLAIM_PRIORITY,
+		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
+		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
 		.may_swap = 1,
-		.reclaim_idx = zone_idx(zone),
+		.reclaim_idx = classzone_idx,
 	};
 
 	cond_resched();
@@ -3667,13 +3668,13 @@ static int __zone_reclaim(struct zone *z
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
+	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages) {
 		/*
 		 * Free memory by calling shrink zone with increasing
 		 * priorities until we have enough memory freed.
 		 */
 		do {
-			shrink_node(zone->zone_pgdat, &sc, zone_idx(zone));
+			shrink_node(pgdat, &sc, classzone_idx);
 		} while (sc.nr_reclaimed < nr_pages && --sc.priority >= 0);
 	}
 
@@ -3683,49 +3684,47 @@ static int __zone_reclaim(struct zone *z
 	return sc.nr_reclaimed >= nr_pages;
 }
 
-int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
+int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 {
-	int node_id;
 	int ret;
 
 	/*
-	 * Zone reclaim reclaims unmapped file backed pages and
+	 * Node reclaim reclaims unmapped file backed pages and
 	 * slab pages if we are over the defined limits.
 	 *
 	 * A small portion of unmapped file backed pages is needed for
 	 * file I/O otherwise pages read by file I/O will be immediately
-	 * thrown out if the zone is overallocated. So we do not reclaim
-	 * if less than a specified percentage of the zone is used by
+	 * thrown out if the node is overallocated. So we do not reclaim
+	 * if less than a specified percentage of the node is used by
 	 * unmapped file backed pages.
 	 */
-	if (zone_pagecache_reclaimable(zone) <= zone->min_unmapped_pages &&
-	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
-		return ZONE_RECLAIM_FULL;
+	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
+	    sum_zone_node_page_state(pgdat->node_id, NR_SLAB_RECLAIMABLE) <= pgdat->min_slab_pages)
+		return NODE_RECLAIM_FULL;
 
-	if (!pgdat_reclaimable(zone->zone_pgdat))
-		return ZONE_RECLAIM_FULL;
+	if (!pgdat_reclaimable(pgdat))
+		return NODE_RECLAIM_FULL;
 
 	/*
 	 * Do not scan if the allocation should not be delayed.
 	 */
 	if (!gfpflags_allow_blocking(gfp_mask) || (current->flags & PF_MEMALLOC))
-		return ZONE_RECLAIM_NOSCAN;
+		return NODE_RECLAIM_NOSCAN;
 
 	/*
-	 * Only run zone reclaim on the local zone or on zones that do not
+	 * Only run node reclaim on the local node or on nodes that do not
 	 * have associated processors. This will favor the local processor
 	 * over remote processors and spread off node memory allocations
 	 * as wide as possible.
 	 */
-	node_id = zone_to_nid(zone);
-	if (node_state(node_id, N_CPU) && node_id != numa_node_id())
-		return ZONE_RECLAIM_NOSCAN;
+	if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id != numa_node_id())
+		return NODE_RECLAIM_NOSCAN;
 
-	if (test_and_set_bit(ZONE_RECLAIM_LOCKED, &zone->flags))
-		return ZONE_RECLAIM_NOSCAN;
+	if (test_and_set_bit(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
+		return NODE_RECLAIM_NOSCAN;
 
-	ret = __zone_reclaim(zone, gfp_mask, order);
-	clear_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
+	ret = __node_reclaim(pgdat, gfp_mask, order);
+	clear_bit(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
 	if (!ret)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch

