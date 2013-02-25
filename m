From: akpm@linux-foundation.org
Subject: [merged] mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:51:35 -0800
Message-ID: <20130225205136.0C59131C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:44221 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759657Ab3BYUvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:51:37 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70334qea.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:51:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liuj97@gmail.com, chris2553@googlemail.com, jiang.liu@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, maciej.rutecki@gmail.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, rientjes@google.com, rjw@sisk.pl, wency@cn.fujitsu.com, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use zone->present_pages instead of zone->managed_pages where appropriate
has been removed from the -mm tree.  Its filename was
     mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm: use zone->present_pages instead of zone->managed_pages where appropriate

Now we have zone->managed_pages for "pages managed by the buddy system in
the zone", so replace zone->present_pages with zone->managed_pages if what
the user really wants is number of allocatable pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Chris Clayton <chris2553@googlemail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   32 ++++++++++++++++----------------
 mm/vmscan.c     |   14 +++++++-------
 mm/vmstat.c     |    2 +-
 3 files changed, 24 insertions(+), 24 deletions(-)

diff -puN mm/page_alloc.c~mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate
+++ a/mm/page_alloc.c
@@ -2808,7 +2808,7 @@ static unsigned int nr_free_zone_pages(i
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), GFP_KERNEL);
 
 	for_each_zone_zonelist(zone, z, zonelist, offset) {
-		unsigned long size = zone->present_pages;
+		unsigned long size = zone->managed_pages;
 		unsigned long high = high_wmark_pages(zone);
 		if (size > high)
 			sum += size - high;
@@ -2861,7 +2861,7 @@ void si_meminfo_node(struct sysinfo *val
 	val->totalram = pgdat->node_present_pages;
 	val->freeram = node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
-	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].present_pages;
+	val->totalhigh = pgdat->node_zones[ZONE_HIGHMEM].managed_pages;
 	val->freehigh = zone_page_state(&pgdat->node_zones[ZONE_HIGHMEM],
 			NR_FREE_PAGES);
 #else
@@ -3939,7 +3939,7 @@ static int __meminit zone_batchsize(stru
 	 *
 	 * OK, so we don't know how big the cache is.  So guess.
 	 */
-	batch = zone->present_pages / 1024;
+	batch = zone->managed_pages / 1024;
 	if (batch * PAGE_SIZE > 512 * 1024)
 		batch = (512 * 1024) / PAGE_SIZE;
 	batch /= 4;		/* We effectively *= 4 below */
@@ -4023,7 +4023,7 @@ static void __meminit setup_zone_pageset
 
 		if (percpu_pagelist_fraction)
 			setup_pagelist_highmark(pcp,
-				(zone->present_pages /
+				(zone->managed_pages /
 					percpu_pagelist_fraction));
 	}
 }
@@ -5435,8 +5435,8 @@ static void calculate_totalreserve_pages
 			/* we treat the high watermark as reserved pages. */
 			max += high_wmark_pages(zone);
 
-			if (max > zone->present_pages)
-				max = zone->present_pages;
+			if (max > zone->managed_pages)
+				max = zone->managed_pages;
 			reserve_pages += max;
 			/*
 			 * Lowmem reserves are not available to
@@ -5468,7 +5468,7 @@ static void setup_per_zone_lowmem_reserv
 	for_each_online_pgdat(pgdat) {
 		for (j = 0; j < MAX_NR_ZONES; j++) {
 			struct zone *zone = pgdat->node_zones + j;
-			unsigned long present_pages = zone->present_pages;
+			unsigned long managed_pages = zone->managed_pages;
 
 			zone->lowmem_reserve[j] = 0;
 
@@ -5482,9 +5482,9 @@ static void setup_per_zone_lowmem_reserv
 					sysctl_lowmem_reserve_ratio[idx] = 1;
 
 				lower_zone = pgdat->node_zones + idx;
-				lower_zone->lowmem_reserve[j] = present_pages /
+				lower_zone->lowmem_reserve[j] = managed_pages /
 					sysctl_lowmem_reserve_ratio[idx];
-				present_pages += lower_zone->present_pages;
+				managed_pages += lower_zone->managed_pages;
 			}
 		}
 	}
@@ -5503,14 +5503,14 @@ static void __setup_per_zone_wmarks(void
 	/* Calculate total number of !ZONE_HIGHMEM pages */
 	for_each_zone(zone) {
 		if (!is_highmem(zone))
-			lowmem_pages += zone->present_pages;
+			lowmem_pages += zone->managed_pages;
 	}
 
 	for_each_zone(zone) {
 		u64 tmp;
 
 		spin_lock_irqsave(&zone->lock, flags);
-		tmp = (u64)pages_min * zone->present_pages;
+		tmp = (u64)pages_min * zone->managed_pages;
 		do_div(tmp, lowmem_pages);
 		if (is_highmem(zone)) {
 			/*
@@ -5524,7 +5524,7 @@ static void __setup_per_zone_wmarks(void
 			 */
 			unsigned long min_pages;
 
-			min_pages = zone->present_pages / 1024;
+			min_pages = zone->managed_pages / 1024;
 			min_pages = clamp(min_pages, SWAP_CLUSTER_MAX, 128UL);
 			zone->watermark[WMARK_MIN] = min_pages;
 		} else {
@@ -5586,7 +5586,7 @@ static void __meminit calculate_zone_ina
 	unsigned int gb, ratio;
 
 	/* Zone size in gigabytes */
-	gb = zone->present_pages >> (30 - PAGE_SHIFT);
+	gb = zone->managed_pages >> (30 - PAGE_SHIFT);
 	if (gb)
 		ratio = int_sqrt(10 * gb);
 	else
@@ -5672,7 +5672,7 @@ int sysctl_min_unmapped_ratio_sysctl_han
 		return rc;
 
 	for_each_zone(zone)
-		zone->min_unmapped_pages = (zone->present_pages *
+		zone->min_unmapped_pages = (zone->managed_pages *
 				sysctl_min_unmapped_ratio) / 100;
 	return 0;
 }
@@ -5688,7 +5688,7 @@ int sysctl_min_slab_ratio_sysctl_handler
 		return rc;
 
 	for_each_zone(zone)
-		zone->min_slab_pages = (zone->present_pages *
+		zone->min_slab_pages = (zone->managed_pages *
 				sysctl_min_slab_ratio) / 100;
 	return 0;
 }
@@ -5730,7 +5730,7 @@ int percpu_pagelist_fraction_sysctl_hand
 	for_each_populated_zone(zone) {
 		for_each_possible_cpu(cpu) {
 			unsigned long  high;
-			high = zone->present_pages / percpu_pagelist_fraction;
+			high = zone->managed_pages / percpu_pagelist_fraction;
 			setup_pagelist_highmark(
 				per_cpu_ptr(zone->pageset, cpu), high);
 		}
diff -puN mm/vmscan.c~mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate mm/vmscan.c
--- a/mm/vmscan.c~mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate
+++ a/mm/vmscan.c
@@ -2010,7 +2010,7 @@ static inline bool compaction_ready(stru
 	 * a reasonable chance of completing and allocating the page
 	 */
 	balance_gap = min(low_wmark_pages(zone),
-		(zone->present_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
+		(zone->managed_pages + KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 			KSWAPD_ZONE_BALANCE_GAP_RATIO);
 	watermark = high_wmark_pages(zone) + balance_gap + (2UL << sc->order);
 	watermark_ok = zone_watermark_ok_safe(zone, 0, watermark, 0, 0);
@@ -2525,7 +2525,7 @@ static bool zone_balanced(struct zone *z
  */
 static bool pgdat_balanced(pg_data_t *pgdat, int order, int classzone_idx)
 {
-	unsigned long present_pages = 0;
+	unsigned long managed_pages = 0;
 	unsigned long balanced_pages = 0;
 	int i;
 
@@ -2536,7 +2536,7 @@ static bool pgdat_balanced(pg_data_t *pg
 		if (!populated_zone(zone))
 			continue;
 
-		present_pages += zone->present_pages;
+		managed_pages += zone->managed_pages;
 
 		/*
 		 * A special case here:
@@ -2546,18 +2546,18 @@ static bool pgdat_balanced(pg_data_t *pg
 		 * they must be considered balanced here as well!
 		 */
 		if (zone->all_unreclaimable) {
-			balanced_pages += zone->present_pages;
+			balanced_pages += zone->managed_pages;
 			continue;
 		}
 
 		if (zone_balanced(zone, order, 0, i))
-			balanced_pages += zone->present_pages;
+			balanced_pages += zone->managed_pages;
 		else if (!order)
 			return false;
 	}
 
 	if (order)
-		return balanced_pages >= (present_pages >> 2);
+		return balanced_pages >= (managed_pages >> 2);
 	else
 		return true;
 }
@@ -2745,7 +2745,7 @@ loop_again:
 			 * of the zone, whichever is smaller.
 			 */
 			balance_gap = min(low_wmark_pages(zone),
-				(zone->present_pages +
+				(zone->managed_pages +
 					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
 			/*
diff -puN mm/vmstat.c~mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate mm/vmstat.c
--- a/mm/vmstat.c~mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate
+++ a/mm/vmstat.c
@@ -142,7 +142,7 @@ int calculate_normal_threshold(struct zo
 	 * 125		1024		10	16-32 GB	9
 	 */
 
-	mem = zone->present_pages >> (27 - PAGE_SHIFT);
+	mem = zone->managed_pages >> (27 - PAGE_SHIFT);
 
 	threshold = 2 * fls(num_online_cpus()) * (1 + fls(mem));
 
_

Patches currently in -mm which might be from liuj97@gmail.com are

origin.patch
linux-next.patch

