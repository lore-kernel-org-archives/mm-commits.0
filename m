From: akpm@linux-foundation.org
Subject: + mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch added to -mm tree
Date: Mon, 28 Dec 2015 14:32:36 -0800
Message-ID: <5681b884.KXh7p7VxdqthcHIq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbbL1Wch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Dec 2015 17:32:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: izumi.taku@jp.fujitsu.com, dave.hansen@intel.com, kamezawa.hiroyu@jp.fujitsu.com, matt@codeblueprint.co.uk, mel@csn.ul.ie, qiuxishi@huawei.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: calculate zone_start_pfn at zone_spanned_pages_in_node()
has been added to the -mm tree.  Its filename is
     mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch

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

For example, suppose 2-nodes system with the following memory
 range: 
  node 0 [mem 0x0000000000001000-0x000000109fffffff] 
  node 1 [mem 0x00000010a0000000-0x000000209fffffff]

and the following ranges are marked as reliable (mirrored):
  [0x0000000000000000-0x0000000100000000] 
  [0x0000000100000000-0x0000000180000000] 
  [0x0000000800000000-0x0000000880000000] 
  [0x00000010a0000000-0x0000001120000000]
  [0x00000017a0000000-0x0000001820000000] 

If you specify kernelcore=mirror, ZONE_NORMAL and ZONE_MOVABLE
are arranged like bellow:

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

This patch changes each zone->zone_start_pfn is calculated at
zone_spanned_pages_in_node().

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node
+++ a/mm/page_alloc.c
@@ -4920,31 +4920,31 @@ static unsigned long __meminit zone_span
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
@@ -5009,6 +5009,8 @@ static inline unsigned long __meminit zo
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
+					unsigned long *zone_start_pfn,
+					unsigned long *zone_end_pfn,
 					unsigned long *zones_size)
 {
 	return zones_size[zone_type];
@@ -5039,15 +5041,22 @@ static void __meminit calculate_node_tot
 
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
 
@@ -5168,7 +5177,6 @@ static void __paginginit free_area_init_
 {
 	enum zone_type j;
 	int nid = pgdat->node_id;
-	unsigned long zone_start_pfn = pgdat->node_start_pfn;
 	int ret;
 
 	pgdat_resize_init(pgdat);
@@ -5184,6 +5192,7 @@ static void __paginginit free_area_init_
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
+		unsigned long zone_start_pfn = zone->zone_start_pfn;
 
 		size = zone->spanned_pages;
 		realsize = freesize = zone->present_pages;
@@ -5252,7 +5261,6 @@ static void __paginginit free_area_init_
 		ret = init_currently_empty_zone(zone, zone_start_pfn, size);
 		BUG_ON(ret);
 		memmap_init(size, nid, j, zone_start_pfn);
-		zone_start_pfn += size;
 	}
 }
 
_

Patches currently in -mm which might be from izumi.taku@jp.fujitsu.com are

mm-calculate-zone_start_pfn-at-zone_spanned_pages_in_node.patch
mm-introduce-kernelcore=mirror-option.patch

