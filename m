From: akpm@linux-foundation.org
Subject: +
 mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch added to -mm tree
Date: Fri, 08 Jan 2016 15:16:39 -0800
Message-ID: <56904357.F0OBSWPRD28w1qTq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177AbcAHXQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 18:16:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: izumi.taku@jp.fujitsu.com, arnd@arndb.de, dave.hansen@intel.com, kamezawa.hiroyu@jp.fujitsu.com, matt@codeblueprint.co.uk, mel@csn.ul.ie, qiuxishi@huawei.com, steve.capper@linaro.org, sudeep.holla@arm.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: calculate zone_start_pfn at zone_spanned_pages_in_node()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: mm/page_alloc.c: calculate zone_start_pfn at zone_spanned_pages_in_node()

Xeon E7 v3 based systems supports Address Range Mirroring and UEFI BIOS
complied with UEFI spec 2.5 can notify which ranges are mirrored
(reliable) via EFI memory map.  Now Linux kernel utilize its information
and allocates boot time memory from reliable region.

My requirement is:
  - allocate kernel memory from mirrored region 
  - allocate user memory from non-mirrored region

In order to meet my requirement, ZONE_MOVABLE is useful.  By arranging
non-mirrored range into ZONE_MOVABLE, mirrored memory is used for kernel
allocations.

My idea is to extend existing "kernelcore" option and introduces
kernelcore=mirror option.  By specifying "mirror" instead of specifying
the amount of memory, non-mirrored region will be arranged into
ZONE_MOVABLE.

Earlier discussions are at: 
 https://lkml.org/lkml/2015/10/9/24
 https://lkml.org/lkml/2015/10/15/9
 https://lkml.org/lkml/2015/11/27/18
 https://lkml.org/lkml/2015/12/8/836

For example, suppose 2-nodes system with the following memory range: 

  node 0 [mem 0x0000000000001000-0x000000109fffffff] 
  node 1 [mem 0x00000010a0000000-0x000000209fffffff]
and the following ranges are marked as reliable (mirrored):
  [0x0000000000000000-0x0000000100000000] 
  [0x0000000100000000-0x0000000180000000] 
  [0x0000000800000000-0x0000000880000000] 
  [0x00000010a0000000-0x0000001120000000]
  [0x00000017a0000000-0x0000001820000000] 

If you specify kernelcore=mirror, ZONE_NORMAL and ZONE_MOVABLE are
arranged like bellow:

 - node 0:
  ZONE_NORMAL : [0x0000000100000000-0x00000010a0000000]
  ZONE_MOVABLE: [0x0000000180000000-0x00000010a0000000]
 - node 1: 
  ZONE_NORMAL : [0x00000010a0000000-0x00000020a0000000]
  ZONE_MOVABLE: [0x0000001120000000-0x00000020a0000000]

In overlapped range, pages to be ZONE_MOVABLE in ZONE_NORMAL are treated
as absent pages, and vice versa.


This patch (of 2):

Currently each zone's zone_start_pfn is calculated at
free_area_init_core().  However zone's range is fixed at the time when
invoking zone_spanned_pages_in_node().

This patch changes how each zone->zone_start_pfn is calculated in
zone_spanned_pages_in_node().

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node
+++ a/mm/page_alloc.c
@@ -5059,31 +5059,31 @@ static unsigned long __meminit zone_span
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
+					unsigned long *zone_start_pfn,
+					unsigned long *zone_end_pfn,
 					unsigned long *ignored)
 {
-	unsigned long zone_start_pfn, zone_end_pfn;
-
 	/* When hotadd a new node from cpu_up(), the node should be empty */
 	if (!node_start_pfn && !node_end_pfn)
 		return 0;
 
 	/* Get the start and end of the zone */
-	zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
-	zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
+	*zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
+	*zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
 	adjust_zone_range_for_zone_movable(nid, zone_type,
 				node_start_pfn, node_end_pfn,
-				&zone_start_pfn, &zone_end_pfn);
+				zone_start_pfn, zone_end_pfn);
 
 	/* Check that this node has pages within the zone's required range */
-	if (zone_end_pfn < node_start_pfn || zone_start_pfn > node_end_pfn)
+	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
 		return 0;
 
 	/* Move the zone boundaries inside the node if necessary */
-	zone_end_pfn = min(zone_end_pfn, node_end_pfn);
-	zone_start_pfn = max(zone_start_pfn, node_start_pfn);
+	*zone_end_pfn = min(*zone_end_pfn, node_end_pfn);
+	*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
 
 	/* Return the spanned pages */
-	return zone_end_pfn - zone_start_pfn;
+	return *zone_end_pfn - *zone_start_pfn;
 }
 
 /*
@@ -5148,8 +5148,18 @@ static inline unsigned long __meminit zo
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
+					unsigned long *zone_start_pfn,
+					unsigned long *zone_end_pfn,
 					unsigned long *zones_size)
 {
+	unsigned int zone;
+
+	*zone_start_pfn = node_start_pfn;
+	for (zone = 0; zone < zone_type; zone++)
+		*zone_start_pfn += zones_size[zone];
+
+	*zone_end_pfn = *zone_start_pfn + zones_size[zone_type];
+
 	return zones_size[zone_type];
 }
 
@@ -5178,15 +5188,22 @@ static void __meminit calculate_node_tot
 
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		struct zone *zone = pgdat->node_zones + i;
+		unsigned long zone_start_pfn, zone_end_pfn;
 		unsigned long size, real_size;
 
 		size = zone_spanned_pages_in_node(pgdat->node_id, i,
 						  node_start_pfn,
 						  node_end_pfn,
+						  &zone_start_pfn,
+						  &zone_end_pfn,
 						  zones_size);
 		real_size = size - zone_absent_pages_in_node(pgdat->node_id, i,
 						  node_start_pfn, node_end_pfn,
 						  zholes_size);
+		if (size)
+			zone->zone_start_pfn = zone_start_pfn;
+		else
+			zone->zone_start_pfn = 0;
 		zone->spanned_pages = size;
 		zone->present_pages = real_size;
 
@@ -5307,7 +5324,6 @@ static void __paginginit free_area_init_
 {
 	enum zone_type j;
 	int nid = pgdat->node_id;
-	unsigned long zone_start_pfn = pgdat->node_start_pfn;
 	int ret;
 
 	pgdat_resize_init(pgdat);
@@ -5323,6 +5339,7 @@ static void __paginginit free_area_init_
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
+		unsigned long zone_start_pfn = zone->zone_start_pfn;
 
 		size = zone->spanned_pages;
 		realsize = freesize = zone->present_pages;
@@ -5391,7 +5408,6 @@ static void __paginginit free_area_init_
 		ret = init_currently_empty_zone(zone, zone_start_pfn, size);
 		BUG_ON(ret);
 		memmap_init(size, nid, j, zone_start_pfn);
-		zone_start_pfn += size;
 	}
 }
 
@@ -5459,6 +5475,8 @@ void __paginginit free_area_init_node(in
 	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
 		(u64)start_pfn << PAGE_SHIFT,
 		end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
+#else
+	start_pfn = node_start_pfn;
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
_

Patches currently in -mm which might be from izumi.taku@jp.fujitsu.com are

mm-page_allocc-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch
mm-page_allocc-introduce-kernelcore=mirror-option.patch

