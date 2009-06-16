From: akpm@linux-foundation.org
Subject: [folded] page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:54:34 -0700
Message-ID: <200906162154.n5GLsY5I024089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762891AbZFPVzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     page allocator: replace the watermark-related union in struct zone with a watermark[] array
has been removed from the -mm tree.  Its filename was
     page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch

This patch was dropped because it was folded into page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: replace the watermark-related union in struct zone with a watermark[] array
From: Mel Gorman <mel@csn.ul.ie>

Patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark in
-mm added a union to struct zone where the watermarks could be accessed
with either zone->pages_* or a pages_mark array.  The concern was that
this aliasing caused more confusion that it helped.

This patch replaces the union with a watermark array that is indexed with
WMARK_* defines accessed via helpers.  All call sites that use
zone->pages_* are updated to use the helpers for accessing the values and
the array offsets for setting.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   11 ++++-----
 Documentation/vm/balance    |   18 +++++++-------
 arch/m32r/mm/discontig.c    |    6 ++--
 include/linux/mmzone.h      |   20 +++++++++++-----
 mm/page_alloc.c             |   41 +++++++++++++++++-----------------
 mm/vmscan.c                 |   39 +++++++++++++++++---------------
 mm/vmstat.c                 |    6 ++--
 7 files changed, 77 insertions(+), 64 deletions(-)

diff -puN Documentation/sysctl/vm.txt~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array
+++ a/Documentation/sysctl/vm.txt
@@ -233,8 +233,8 @@ These protections are added to score to 
 for page allocation or should be reclaimed.
 
 In this example, if normal pages (index=2) are required to this DMA zone and
-pages_high is used for watermark, the kernel judges this zone should not be
-used because pages_free(1355) is smaller than watermark + protection[2]
+watermark[WMARK_HIGH] is used for watermark, the kernel judges this zone should
+not be used because pages_free(1355) is smaller than watermark + protection[2]
 (4 + 2004 = 2008). If this protection value is 0, this zone would be used for
 normal page requirement. If requirement is DMA zone(index=0), protection[0]
 (=0) is used.
@@ -280,9 +280,10 @@ The default value is 65536.
 min_free_kbytes:
 
 This is used to force the Linux VM to keep a minimum number
-of kilobytes free.  The VM uses this number to compute a pages_min
-value for each lowmem zone in the system.  Each lowmem zone gets
-a number of reserved free pages based proportionally on its size.
+of kilobytes free.  The VM uses this number to compute a
+watermark[WMARK_MIN] value for each lowmem zone in the system.
+Each lowmem zone gets a number of reserved free pages based
+proportionally on its size.
 
 Some minimal amount of memory is needed to satisfy PF_MEMALLOC
 allocations; if you set this to lower than 1024KB, your system will
diff -puN Documentation/vm/balance~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array Documentation/vm/balance
--- a/Documentation/vm/balance~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array
+++ a/Documentation/vm/balance
@@ -75,15 +75,15 @@ Page stealing from process memory and sh
 alleviate memory pressure on any zone in the page's node that has fallen below
 its watermark.
 
-pages_min/pages_low/pages_high/low_on_memory/zone_wake_kswapd: These are 
-per-zone fields, used to determine when a zone needs to be balanced. When
-the number of pages falls below pages_min, the hysteric field low_on_memory
-gets set. This stays set till the number of free pages becomes pages_high.
-When low_on_memory is set, page allocation requests will try to free some
-pages in the zone (providing GFP_WAIT is set in the request). Orthogonal
-to this, is the decision to poke kswapd to free some zone pages. That
-decision is not hysteresis based, and is done when the number of free
-pages is below pages_low; in which case zone_wake_kswapd is also set.
+watemark[WMARK_MIN/WMARK_LOW/WMARK_HIGH]/low_on_memory/zone_wake_kswapd: These
+are per-zone fields, used to determine when a zone needs to be balanced. When
+the number of pages falls below watermark[WMARK_MIN], the hysteric field
+low_on_memory gets set. This stays set till the number of free pages becomes
+watermark[WMARK_HIGH]. When low_on_memory is set, page allocation requests will
+try to free some pages in the zone (providing GFP_WAIT is set in the request).
+Orthogonal to this, is the decision to poke kswapd to free some zone pages.
+That decision is not hysteresis based, and is done when the number of free
+pages is below watermark[WMARK_LOW]; in which case zone_wake_kswapd is also set.
 
 
 (Good) Ideas that I have heard:
diff -puN arch/m32r/mm/discontig.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array
+++ a/arch/m32r/mm/discontig.c
@@ -154,9 +154,9 @@ unsigned long __init zone_sizes_init(voi
 	 *  Use all area of internal RAM.
 	 *  see __alloc_pages()
 	 */
-	NODE_DATA(1)->node_zones->pages_min = 0;
-	NODE_DATA(1)->node_zones->pages_low = 0;
-	NODE_DATA(1)->node_zones->pages_high = 0;
+	NODE_DATA(1)->node_zones->watermark[WMARK_MIN] = 0;
+	NODE_DATA(1)->node_zones->watermark[WMARK_LOW] = 0;
+	NODE_DATA(1)->node_zones->watermark[WMARK_HIGH] = 0;
 
 	return holes;
 }
diff -puN include/linux/mmzone.h~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array include/linux/mmzone.h
--- a/include/linux/mmzone.h~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array
+++ a/include/linux/mmzone.h
@@ -163,6 +163,17 @@ static inline int is_unevictable_lru(enu
 #endif
 }
 
+enum zone_watermarks {
+	WMARK_MIN,
+	WMARK_LOW,
+	WMARK_HIGH,
+	NR_WMARK
+};
+
+#define min_wmark_pages(z) (z->watermark[WMARK_MIN])
+#define low_wmark_pages(z) (z->watermark[WMARK_LOW])
+#define high_wmark_pages(z) (z->watermark[WMARK_HIGH])
+
 struct per_cpu_pages {
 	int count;		/* number of pages in the list */
 	int high;		/* high watermark, emptying needed */
@@ -275,12 +286,9 @@ struct zone_reclaim_stat {
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */
-	union {
-		struct {
-			unsigned long	pages_min, pages_low, pages_high;
-		};
-		unsigned long pages_mark[3];
-	};
+
+	/* zone watermarks, access with *_wmark_pages(zone) macros */
+	unsigned long watermark[NR_WMARK];
 
 	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
diff -puN mm/page_alloc.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array
+++ a/mm/page_alloc.c
@@ -1169,10 +1169,10 @@ failed:
 	return NULL;
 }
 
-/* The WMARK bits are used as an index zone->pages_mark */
-#define ALLOC_WMARK_MIN		0x00 /* use pages_min watermark */
-#define ALLOC_WMARK_LOW		0x01 /* use pages_low watermark */
-#define ALLOC_WMARK_HIGH	0x02 /* use pages_high watermark */
+/* The ALLOC_WMARK bits are used as an index to zone->watermark */
+#define ALLOC_WMARK_MIN		WMARK_MIN
+#define ALLOC_WMARK_LOW		WMARK_LOW
+#define ALLOC_WMARK_HIGH	WMARK_HIGH
 #define ALLOC_NO_WATERMARKS	0x04 /* don't check watermarks at all */
 
 /* Mask to get the watermark bits */
@@ -1464,9 +1464,10 @@ zonelist_scan:
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				goto try_next_zone;
 
+		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
-			mark = zone->pages_mark[alloc_flags & ALLOC_WMARK_MASK];
+			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 			if (!zone_watermark_ok(zone, order, mark,
 				    classzone_idx, alloc_flags)) {
 				if (!zone_reclaim_mode ||
@@ -1981,7 +1982,7 @@ static unsigned int nr_free_zone_pages(i
 
 	for_each_zone_zonelist(zone, z, zonelist, offset) {
 		unsigned long size = zone->present_pages;
-		unsigned long high = zone->pages_high;
+		unsigned long high = high_wmark_pages(zone);
 		if (size > high)
 			sum += size - high;
 	}
@@ -2118,9 +2119,9 @@ void show_free_areas(void)
 			"\n",
 			zone->name,
 			K(zone_page_state(zone, NR_FREE_PAGES)),
-			K(zone->pages_min),
-			K(zone->pages_low),
-			K(zone->pages_high),
+			K(min_wmark_pages(zone)),
+			K(low_wmark_pages(zone)),
+			K(high_wmark_pages(zone)),
 			K(zone_page_state(zone, NR_ACTIVE_ANON)),
 			K(zone_page_state(zone, NR_INACTIVE_ANON)),
 			K(zone_page_state(zone, NR_ACTIVE_FILE)),
@@ -2724,8 +2725,8 @@ static inline unsigned long wait_table_b
 
 /*
  * Mark a number of pageblocks as MIGRATE_RESERVE. The number
- * of blocks reserved is based on zone->pages_min. The memory within the
- * reserve will tend to store contiguous free pages. Setting min_free_kbytes
+ * of blocks reserved is based on min_wmark_pages(zone). The memory within
+ * the reserve will tend to store contiguous free pages. Setting min_free_kbytes
  * higher will lead to a bigger reserve which will get freed as contiguous
  * blocks as reclaim kicks in
  */
@@ -2738,7 +2739,7 @@ static void setup_zone_migrate_reserve(s
 	/* Get the start pfn, end pfn and the number of blocks to reserve */
 	start_pfn = zone->zone_start_pfn;
 	end_pfn = start_pfn + zone->spanned_pages;
-	reserve = roundup(zone->pages_min, pageblock_nr_pages) >>
+	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
@@ -4406,8 +4407,8 @@ static void calculate_totalreserve_pages
 					max = zone->lowmem_reserve[j];
 			}
 
-			/* we treat pages_high as reserved pages. */
-			max += zone->pages_high;
+			/* we treat the high watermark as reserved pages. */
+			max += high_wmark_pages(zone);
 
 			if (max > zone->present_pages)
 				max = zone->present_pages;
@@ -4487,7 +4488,7 @@ void setup_per_zone_pages_min(void)
 			 * need highmem pages, so cap pages_min to a small
 			 * value here.
 			 *
-			 * The (pages_high-pages_low) and (pages_low-pages_min)
+			 * The WMARK_HIGH-WMARK_LOW and (WMARK_LOW-WMARK_MIN)
 			 * deltas controls asynch page reclaim, and so should
 			 * not be capped for highmem.
 			 */
@@ -4498,17 +4499,17 @@ void setup_per_zone_pages_min(void)
 				min_pages = SWAP_CLUSTER_MAX;
 			if (min_pages > 128)
 				min_pages = 128;
-			zone->pages_min = min_pages;
+			zone->watermark[WMARK_MIN] = min_pages;
 		} else {
 			/*
 			 * If it's a lowmem zone, reserve a number of pages
 			 * proportionate to the zone's size.
 			 */
-			zone->pages_min = tmp;
+			zone->watermark[WMARK_MIN] = tmp;
 		}
 
-		zone->pages_low   = zone->pages_min + (tmp >> 2);
-		zone->pages_high  = zone->pages_min + (tmp >> 1);
+		zone->watermark[WMARK_LOW]  = min_wmark_pages(zone) + (tmp >> 2);
+		zone->watermark[WMARK_HIGH] = min_wmark_pages(zone) + (tmp >> 1);
 		setup_zone_migrate_reserve(zone);
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
@@ -4653,7 +4654,7 @@ int sysctl_min_slab_ratio_sysctl_handler
  *	whenever sysctl_lowmem_reserve_ratio changes.
  *
  * The reserve ratio obviously has absolutely no relation with the
- * pages_min watermarks. The lowmem reserve ratio can only make sense
+ * minimum watermarks. The lowmem reserve ratio can only make sense
  * if in function of the boot time zone sizes.
  */
 int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
diff -puN mm/vmscan.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array mm/vmscan.c
--- a/mm/vmscan.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array
+++ a/mm/vmscan.c
@@ -1401,7 +1401,7 @@ static void get_scan_ratio(struct zone *
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
 		   force-scan anon pages. */
-		if (unlikely(file + free <= zone->pages_high)) {
+		if (unlikely(file + free <= high_wmark_pages(zone))) {
 			percent[0] = 100;
 			percent[1] = 0;
 			return;
@@ -1533,11 +1533,13 @@ static void shrink_zone(int priority, st
  * try to reclaim pages from zones which will satisfy the caller's allocation
  * request.
  *
- * We reclaim from a zone even if that zone is over pages_high.  Because:
+ * We reclaim from a zone even if that zone is over high_wmark_pages(zone).
+ * Because:
  * a) The caller may be trying to free *extra* pages to satisfy a higher-order
  *    allocation or
- * b) The zones may be over pages_high but they must go *over* pages_high to
- *    satisfy the `incremental min' zone defense algorithm.
+ * b) The target zone may be at high_wmark_pages(zone) but the lower zones
+ *    must go *over* high_wmark_pages(zone) to satisfy the `incremental min'
+ *    zone defense algorithm.
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
@@ -1743,7 +1745,7 @@ unsigned long try_to_free_mem_cgroup_pag
 
 /*
  * For kswapd, balance_pgdat() will work across all this node's zones until
- * they are all at pages_high.
+ * they are all at high_wmark_pages(zone).
  *
  * Returns the number of pages which were actually freed.
  *
@@ -1756,11 +1758,11 @@ unsigned long try_to_free_mem_cgroup_pag
  * the zone for when the problem goes away.
  *
  * kswapd scans the zones in the highmem->normal->dma direction.  It skips
- * zones which have free_pages > pages_high, but once a zone is found to have
- * free_pages <= pages_high, we scan that zone and the lower zones regardless
- * of the number of free pages in the lower zones.  This interoperates with
- * the page allocator fallback scheme to ensure that aging of pages is balanced
- * across the zones.
+ * zones which have free_pages > high_wmark_pages(zone), but once a zone is
+ * found to have free_pages <= high_wmark_pages(zone), we scan that zone and the
+ * lower zones regardless of the number of free pages in the lower zones. This
+ * interoperates with the page allocator fallback scheme to ensure that aging
+ * of pages is balanced across the zones.
  */
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 {
@@ -1781,7 +1783,8 @@ static unsigned long balance_pgdat(pg_da
 	};
 	/*
 	 * temp_priority is used to remember the scanning priority at which
-	 * this zone was successfully refilled to free_pages == pages_high.
+	 * this zone was successfully refilled to
+	 * free_pages == high_wmark_pages(zone).
 	 */
 	int temp_priority[MAX_NR_ZONES];
 
@@ -1826,8 +1829,8 @@ loop_again:
 				shrink_active_list(SWAP_CLUSTER_MAX, zone,
 							&sc, priority, 0);
 
-			if (!zone_watermark_ok(zone, order, zone->pages_high,
-					       0, 0)) {
+			if (!zone_watermark_ok(zone, order,
+					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
 				break;
 			}
@@ -1861,8 +1864,8 @@ loop_again:
 					priority != DEF_PRIORITY)
 				continue;
 
-			if (!zone_watermark_ok(zone, order, zone->pages_high,
-					       end_zone, 0))
+			if (!zone_watermark_ok(zone, order,
+					high_wmark_pages(zone), end_zone, 0))
 				all_zones_ok = 0;
 			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
@@ -1871,8 +1874,8 @@ loop_again:
 			 * We put equal pressure on every zone, unless one
 			 * zone has way too many pages free already.
 			 */
-			if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
-						end_zone, 0))
+			if (!zone_watermark_ok(zone, order,
+					8*high_wmark_pages(zone), end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
@@ -2038,7 +2041,7 @@ void wakeup_kswapd(struct zone *zone, in
 		return;
 
 	pgdat = zone->zone_pgdat;
-	if (zone_watermark_ok(zone, order, zone->pages_low, 0, 0))
+	if (zone_watermark_ok(zone, order, low_wmark_pages(zone), 0, 0))
 		return;
 	if (pgdat->kswapd_max_order < order)
 		pgdat->kswapd_max_order = order;
diff -puN mm/vmstat.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array mm/vmstat.c
--- a/mm/vmstat.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array
+++ a/mm/vmstat.c
@@ -714,9 +714,9 @@ static void zoneinfo_show_print(struct s
 		   "\n        spanned  %lu"
 		   "\n        present  %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
-		   zone->pages_min,
-		   zone->pages_low,
-		   zone->pages_high,
+		   min_wmark_pages(zone),
+		   low_wmark_pages(zone),
+		   high_wmark_pages(zone),
 		   zone->pages_scanned,
 		   zone->lru[LRU_ACTIVE_ANON].nr_scan,
 		   zone->lru[LRU_INACTIVE_ANON].nr_scan,
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-vmscan-fix-use-of-delta-in-zone_pagecache_reclaimable.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio.patch
vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch
mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch

