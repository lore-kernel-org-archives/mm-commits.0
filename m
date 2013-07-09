From: akpm@linux-foundation.org
Subject: [merged] mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:28 -0700
Message-ID: <51dc9a80.oWE23lLNky5NowcZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, fengguang.wu@intel.com, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,fengguang.wu@intel.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:28 -0700


The patch titled
     Subject: mm: remove duplicated call of get_pfn_range_for_nid
has been removed from the -mm tree.  Its filename was
     mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm: remove duplicated call of get_pfn_range_for_nid

When calculating pages in a node, for each zone in that node, we will have

  zone_spanned_pages_in_node
    --> get_pfn_range_for_nid
  zone_absent_pages_in_node
    --> get_pfn_range_for_nid

That is to say, we call the get_pfn_range_for_nid to get start_pfn and
end_pfn of the node for MAX_NR_ZONES * 2 times.  And this is totally
unnecessary if we call the get_pfn_range_for_nid before
zone_*_pages_in_node add two extra arguments node_start_pfn and
node_end_pfn for zone_*_pages_in_node, then we can remove the
get_pfn_range_in_node in zone_*_pages_in_node.

[akpm@linux-foundation.org: make definitions more readable]
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid
+++ a/mm/page_alloc.c
@@ -4421,13 +4421,13 @@ static void __meminit adjust_zone_range_
  */
 static unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *ignored)
 {
-	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	/* Get the start and end of the node and zone */
-	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
+	/* Get the start and end of the zone */
 	zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
 	zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
 	adjust_zone_range_for_zone_movable(nid, zone_type,
@@ -4482,14 +4482,14 @@ unsigned long __init absent_pages_in_ran
 /* Return the number of page frames in holes in a zone on a node */
 static unsigned long __meminit zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *ignored)
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
-	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
 	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
@@ -4502,6 +4502,8 @@ static unsigned long __meminit zone_abse
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *zones_size)
 {
 	return zones_size[zone_type];
@@ -4509,6 +4511,8 @@ static inline unsigned long __meminit zo
 
 static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 						unsigned long zone_type,
+						unsigned long node_start_pfn,
+						unsigned long node_end_pfn,
 						unsigned long *zholes_size)
 {
 	if (!zholes_size)
@@ -4520,21 +4524,27 @@ static inline unsigned long __meminit zo
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
-		unsigned long *zones_size, unsigned long *zholes_size)
+						unsigned long node_start_pfn,
+						unsigned long node_end_pfn,
+						unsigned long *zones_size,
+						unsigned long *zholes_size)
 {
 	unsigned long realtotalpages, totalpages = 0;
 	enum zone_type i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
 		totalpages += zone_spanned_pages_in_node(pgdat->node_id, i,
-								zones_size);
+							 node_start_pfn,
+							 node_end_pfn,
+							 zones_size);
 	pgdat->node_spanned_pages = totalpages;
 
 	realtotalpages = totalpages;
 	for (i = 0; i < MAX_NR_ZONES; i++)
 		realtotalpages -=
 			zone_absent_pages_in_node(pgdat->node_id, i,
-								zholes_size);
+						  node_start_pfn, node_end_pfn,
+						  zholes_size);
 	pgdat->node_present_pages = realtotalpages;
 	printk(KERN_DEBUG "On node %d totalpages: %lu\n", pgdat->node_id,
 							realtotalpages);
@@ -4643,6 +4653,7 @@ static unsigned long __paginginit calc_m
  * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
+		unsigned long node_start_pfn, unsigned long node_end_pfn,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	enum zone_type j;
@@ -4664,8 +4675,11 @@ static void __paginginit free_area_init_
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
 
-		size = zone_spanned_pages_in_node(nid, j, zones_size);
+		size = zone_spanned_pages_in_node(nid, j, node_start_pfn,
+						  node_end_pfn, zones_size);
 		realsize = freesize = size - zone_absent_pages_in_node(nid, j,
+								node_start_pfn,
+								node_end_pfn,
 								zholes_size);
 
 		/*
@@ -4779,6 +4793,8 @@ void __paginginit free_area_init_node(in
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long start_pfn = 0;
+	unsigned long end_pfn = 0;
 
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
@@ -4786,7 +4802,11 @@ void __paginginit free_area_init_node(in
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	init_zone_allows_reclaim(nid);
-	calculate_node_totalpages(pgdat, zones_size, zholes_size);
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+#endif
+	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
+				  zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
@@ -4795,7 +4815,8 @@ void __paginginit free_area_init_node(in
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
-	free_area_init_core(pgdat, zones_size, zholes_size);
+	free_area_init_core(pgdat, start_pfn, end_pfn,
+			    zones_size, zholes_size);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

