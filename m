From: akpm@linux-foundation.org
Subject: +
 mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages.patch
 added to -mm tree
Date: Thu, 14 May 2015 13:57:01 -0700
Message-ID: <55550c1d.TdiZ/C/E3Cy8U9Kj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933553AbbENU5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 16:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory hotplug: init the zone's size when calculating node totalpages
has been added to the -mm tree.  Its filename is
     mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5087,22 +5087,28 @@ static void __meminit calculate_node_tot
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
@@ -5212,8 +5218,7 @@ static unsigned long __paginginit calc_m
  * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
-		unsigned long node_start_pfn, unsigned long node_end_pfn,
-		unsigned long *zones_size, unsigned long *zholes_size)
+		unsigned long node_start_pfn, unsigned long node_end_pfn)
 {
 	enum zone_type j;
 	int nid = pgdat->node_id;
@@ -5234,12 +5239,8 @@ static void __paginginit free_area_init_
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
@@ -5274,8 +5275,6 @@ static void __paginginit free_area_init_
 			nr_kernel_pages -= memmap_pages;
 		nr_all_pages += freesize;
 
-		zone->spanned_pages = size;
-		zone->present_pages = realsize;
 		/*
 		 * Set an approximate value for lowmem here, it will be adjusted
 		 * when the bootmem allocator frees pages into the buddy system.
@@ -5382,8 +5381,7 @@ void __paginginit free_area_init_node(in
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
-	free_area_init_core(pgdat, start_pfn, end_pfn,
-			    zones_size, zholes_size);
+	free_area_init_core(pgdat, start_pfn, end_pfn);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

mm-memory-hotplug-init-the-zones-size-when-calculate-node-totalpages.patch

