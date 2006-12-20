From: akpm@osdl.org
Subject: + avoid-excessive-sorting-of-early_node_map.patch added to -mm tree
Date: Wed, 20 Dec 2006 15:47:37 -0800
Message-ID: <200612202347.kBKNlbt4010105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161022AbWLTXrp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 18:47:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Avoid excessive sorting of early_node_map[]
has been added to the -mm tree.  Its filename is
     avoid-excessive-sorting-of-early_node_map.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid excessive sorting of early_node_map[]
From: Mel Gorman <mel@csn.ul.ie>

find_min_pfn_for_node() and find_min_pfn_with_active_regions() sort
early_node_map[] on every call.  This is an excessive amount of sorting and
that can be avoided.  This patch always searches the whole early_node_map[]
in find_min_pfn_for_node() instead of returning the first value found.  The
map is then only sorted once when required.  Successfully boot tested on a
number of machines.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~avoid-excessive-sorting-of-early_node_map mm/page_alloc.c
--- a/mm/page_alloc.c~avoid-excessive-sorting-of-early_node_map
+++ a/mm/page_alloc.c
@@ -2865,20 +2865,23 @@ static void __init sort_node_map(void)
 			cmp_node_active_region, NULL);
 }
 
-/* Find the lowest pfn for a node. This depends on a sorted early_node_map */
+/* Find the lowest pfn for a node */
 unsigned long __init find_min_pfn_for_node(unsigned long nid)
 {
 	int i;
-
-	/* Regions in the early_node_map can be in any order */
-	sort_node_map();
+	unsigned long min_pfn = -1UL;
 
 	/* Assuming a sorted map, the first range found has the starting pfn */
 	for_each_active_range_index_in_nid(i, nid)
-		return early_node_map[i].start_pfn;
+		min_pfn = min(min_pfn, early_node_map[i].start_pfn);
 
-	printk(KERN_WARNING "Could not find start_pfn for node %lu\n", nid);
-	return 0;
+	if (min_pfn == -1UL) {
+		printk(KERN_WARNING
+			"Could not find start_pfn for node %lu\n", nid);
+		return 0;
+	}
+
+	return min_pfn;
 }
 
 /**
@@ -2927,6 +2930,9 @@ void __init free_area_init_nodes(unsigne
 	unsigned long nid;
 	enum zone_type i;
 
+	/* Sort early_node_map as initialisation assumes it is sorted */
+	sort_node_map();
+
 	/* Record where the zone boundaries are */
 	memset(arch_zone_lowest_possible_pfn, 0,
 				sizeof(arch_zone_lowest_possible_pfn));
_

Patches currently in -mm which might be from mel@csn.ul.ie are

avoid-excessive-sorting-of-early_node_map.patch
ext2-reservations.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch

