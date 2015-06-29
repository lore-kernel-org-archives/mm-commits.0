From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:38:08 -0700
Message-ID: <5591acb0.oiEJk4+5qP/K4f8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbbF2UiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory hotplug: init the zone's size when calculating node totalpages
has been removed from the -mm tree.  Its filename was
     mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: mm/memory hotplug: init the zone's size when calculating node totalpages

Init the zone's size when calculating node totalpages to avoid duplicated
operations in free_area_init_core().

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff -puN mm/page_alloc.c~mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages
+++ a/mm/page_alloc.c
@@ -4756,22 +4756,28 @@ static void __meminit calculate_node_tot
 						unsigned long *zones_size,
 						unsigned long *zholes_size)
 {
-	unsigned long realtotalpages, totalpages = 0;
+	unsigned long realtotalpages = 0, totalpages = 0;
 	enum zone_type i;
 
-	for (i = 0; i < MAX_NR_ZONES; i++)
-		totalpages += zone_spanned_pages_in_node(pgdat->node_id, i,
-							 node_start_pfn,
-							 node_end_pfn,
-							 zones_size);
-	pgdat->node_spanned_pages = totalpages;
-
-	realtotalpages = totalpages;
-	for (i = 0; i < MAX_NR_ZONES; i++)
-		realtotalpages -=
-			zone_absent_pages_in_node(pgdat->node_id, i,
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		struct zone *zone = pgdat->node_zones + i;
+		unsigned long size, real_size;
+
+		size = zone_spanned_pages_in_node(pgdat->node_id, i,
+						  node_start_pfn,
+						  node_end_pfn,
+						  zones_size);
+		real_size = size - zone_absent_pages_in_node(pgdat->node_id, i,
 						  node_start_pfn, node_end_pfn,
 						  zholes_size);
+		zone->spanned_pages = size;
+		zone->present_pages = real_size;
+
+		totalpages += size;
+		realtotalpages += real_size;
+	}
+
+	pgdat->node_spanned_pages = totalpages;
 	pgdat->node_present_pages = realtotalpages;
 	printk(KERN_DEBUG "On node %d totalpages: %lu\n", pgdat->node_id,
 							realtotalpages);
@@ -4881,8 +4887,7 @@ static unsigned long __paginginit calc_m
  * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
-		unsigned long node_start_pfn, unsigned long node_end_pfn,
-		unsigned long *zones_size, unsigned long *zholes_size)
+		unsigned long node_start_pfn, unsigned long node_end_pfn)
 {
 	enum zone_type j;
 	int nid = pgdat->node_id;
@@ -4903,12 +4908,8 @@ static void __paginginit free_area_init_
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
 
-		size = zone_spanned_pages_in_node(nid, j, node_start_pfn,
-						  node_end_pfn, zones_size);
-		realsize = freesize = size - zone_absent_pages_in_node(nid, j,
-								node_start_pfn,
-								node_end_pfn,
-								zholes_size);
+		size = zone->spanned_pages;
+		realsize = freesize = zone->present_pages;
 
 		/*
 		 * Adjust freesize so that it accounts for how much memory
@@ -4943,8 +4944,6 @@ static void __paginginit free_area_init_
 			nr_kernel_pages -= memmap_pages;
 		nr_all_pages += freesize;
 
-		zone->spanned_pages = size;
-		zone->present_pages = realsize;
 		/*
 		 * Set an approximate value for lowmem here, it will be adjusted
 		 * when the bootmem allocator frees pages into the buddy system.
@@ -5050,8 +5049,7 @@ void __paginginit free_area_init_node(in
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
-	free_area_init_core(pgdat, start_pfn, end_pfn,
-			    zones_size, zholes_size);
+	free_area_init_core(pgdat, start_pfn, end_pfn);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

origin.patch

