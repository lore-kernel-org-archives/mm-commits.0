From: akpm@linux-foundation.org
Subject: [merged] page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:18 -0700
Message-ID: <200906171834.n5HIYIsu032765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757185AbZFQS4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: use allocation flags as an index to the zone watermark
has been removed from the -mm tree.  Its filename was
     page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: use allocation flags as an index to the zone watermark
From: Mel Gorman <mel@csn.ul.ie>

ALLOC_WMARK_MIN, ALLOC_WMARK_LOW and ALLOC_WMARK_HIGH determin whether
pages_min, pages_low or pages_high is used as the zone watermark when
allocating the pages.  Two branches in the allocator hotpath determine
which watermark to use.

This patch uses the flags as an array index into a watermark array that is
indexed with WMARK_* defines accessed via helpers.  All call sites that
use zone->pages_* are updated to use the helpers for accessing the values
and the array offsets for setting.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   11 ++++---
 Documentation/vm/balance    |   18 ++++++------
 arch/m32r/mm/discontig.c    |    6 ++--
 include/linux/mmzone.h      |   16 ++++++++++
 mm/page_alloc.c             |   51 +++++++++++++++++-----------------
 mm/vmscan.c                 |   39 ++++++++++++++------------
 mm/vmstat.c                 |    6 ++--
 7 files changed, 83 insertions(+), 64 deletions(-)

diff -puN Documentation/sysctl/vm.txt~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
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
diff -puN Documentation/vm/balance~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark Documentation/vm/balance
--- a/Documentation/vm/balance~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
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
diff -puN arch/m32r/mm/discontig.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark arch/m32r/mm/discontig.c
--- a/arch/m32r/mm/discontig.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
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
diff -puN include/linux/mmzone.h~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark include/linux/mmzone.h
--- a/include/linux/mmzone.h~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
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
@@ -275,7 +286,10 @@ struct zone_reclaim_stat {
 
 struct zone {
 	/* Fields commonly accessed by the page allocator */
-	unsigned long		pages_min, pages_low, pages_high;
+
+	/* zone watermarks, access with *_wmark_pages(zone) macros */
+	unsigned long watermark[NR_WMARK];
+
 	/*
 	 * We don't know if the memory that we're going to allocate will be freeable
 	 * or/and it will be released eventually, so to avoid totally wasting several
diff -puN mm/page_alloc.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
+++ a/mm/page_alloc.c
@@ -1150,10 +1150,15 @@ failed:
 	return NULL;
 }
 
-#define ALLOC_NO_WATERMARKS	0x01 /* don't check watermarks at all */
-#define ALLOC_WMARK_MIN		0x02 /* use pages_min watermark */
-#define ALLOC_WMARK_LOW		0x04 /* use pages_low watermark */
-#define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
+/* The ALLOC_WMARK bits are used as an index to zone->watermark */
+#define ALLOC_WMARK_MIN		WMARK_MIN
+#define ALLOC_WMARK_LOW		WMARK_LOW
+#define ALLOC_WMARK_HIGH	WMARK_HIGH
+#define ALLOC_NO_WATERMARKS	0x04 /* don't check watermarks at all */
+
+/* Mask to get the watermark bits */
+#define ALLOC_WMARK_MASK	(ALLOC_NO_WATERMARKS-1)
+
 #define ALLOC_HARDER		0x10 /* try to alloc harder */
 #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
 #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
@@ -1440,14 +1445,10 @@ zonelist_scan:
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				goto try_next_zone;
 
+		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
 			unsigned long mark;
-			if (alloc_flags & ALLOC_WMARK_MIN)
-				mark = zone->pages_min;
-			else if (alloc_flags & ALLOC_WMARK_LOW)
-				mark = zone->pages_low;
-			else
-				mark = zone->pages_high;
+			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
 			if (!zone_watermark_ok(zone, order, mark,
 				    classzone_idx, alloc_flags)) {
 				if (!zone_reclaim_mode ||
@@ -1959,7 +1960,7 @@ static unsigned int nr_free_zone_pages(i
 
 	for_each_zone_zonelist(zone, z, zonelist, offset) {
 		unsigned long size = zone->present_pages;
-		unsigned long high = zone->pages_high;
+		unsigned long high = high_wmark_pages(zone);
 		if (size > high)
 			sum += size - high;
 	}
@@ -2096,9 +2097,9 @@ void show_free_areas(void)
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
@@ -2702,8 +2703,8 @@ static inline unsigned long wait_table_b
 
 /*
  * Mark a number of pageblocks as MIGRATE_RESERVE. The number
- * of blocks reserved is based on zone->pages_min. The memory within the
- * reserve will tend to store contiguous free pages. Setting min_free_kbytes
+ * of blocks reserved is based on min_wmark_pages(zone). The memory within
+ * the reserve will tend to store contiguous free pages. Setting min_free_kbytes
  * higher will lead to a bigger reserve which will get freed as contiguous
  * blocks as reclaim kicks in
  */
@@ -2716,7 +2717,7 @@ static void setup_zone_migrate_reserve(s
 	/* Get the start pfn, end pfn and the number of blocks to reserve */
 	start_pfn = zone->zone_start_pfn;
 	end_pfn = start_pfn + zone->spanned_pages;
-	reserve = roundup(zone->pages_min, pageblock_nr_pages) >>
+	reserve = roundup(min_wmark_pages(zone), pageblock_nr_pages) >>
 							pageblock_order;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages) {
@@ -4319,8 +4320,8 @@ static void calculate_totalreserve_pages
 					max = zone->lowmem_reserve[j];
 			}
 
-			/* we treat pages_high as reserved pages. */
-			max += zone->pages_high;
+			/* we treat the high watermark as reserved pages. */
+			max += high_wmark_pages(zone);
 
 			if (max > zone->present_pages)
 				max = zone->present_pages;
@@ -4400,7 +4401,7 @@ void setup_per_zone_pages_min(void)
 			 * need highmem pages, so cap pages_min to a small
 			 * value here.
 			 *
-			 * The (pages_high-pages_low) and (pages_low-pages_min)
+			 * The WMARK_HIGH-WMARK_LOW and (WMARK_LOW-WMARK_MIN)
 			 * deltas controls asynch page reclaim, and so should
 			 * not be capped for highmem.
 			 */
@@ -4411,17 +4412,17 @@ void setup_per_zone_pages_min(void)
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
@@ -4566,7 +4567,7 @@ int sysctl_min_slab_ratio_sysctl_handler
  *	whenever sysctl_lowmem_reserve_ratio changes.
  *
  * The reserve ratio obviously has absolutely no relation with the
- * pages_min watermarks. The lowmem reserve ratio can only make sense
+ * minimum watermarks. The lowmem reserve ratio can only make sense
  * if in function of the boot time zone sizes.
  */
 int lowmem_reserve_ratio_sysctl_handler(ctl_table *table, int write,
diff -puN mm/vmscan.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark mm/vmscan.c
--- a/mm/vmscan.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
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
diff -puN mm/vmstat.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark mm/vmstat.c
--- a/mm/vmstat.c~page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark
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
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

