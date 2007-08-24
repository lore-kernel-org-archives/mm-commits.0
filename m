From: akpm@linux-foundation.org
Subject: + memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:28:05 -0700
Message-ID: <200708242228.l7OMS5fU017948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760705AbXHXW21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, balbir@linux.vnet.ibm.com, clameter@sgi.com, jeremy@sgi.com, kamalesh@linux.vnet.ibm.com, lee.schermerhorn@hp.com, mel@skynet.ie, tony.luck@intel.com, y-goto@jp.fujitsu.com


The patch titled
     memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code fix
has been added to the -mm tree.  Its filename is
     memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code fix
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Against 2.6.23-rc3-mm1

V1 -> V2:
+ moved population of N_HIGH_MEMORY node state mask to
  free_area_init_nodes(), as this is called before we
  build zonelists.  So, we can use this mask in
  find_next_best_node.  Still need to keep the duplicate
  code in early_calculate_totalpages() for zone movable
  setup.

mm/page_alloc.c:find_next_best_node()

	visit only nodes with memory [N_HIGH_MEMORY mask]
	looking for next best node for fallback zonelists.

mm/page_alloc.c:find_zone_movable_pfns_for_nodes()

	spread kernelcore over nodes with memory.

	This required calling early_calculate_totalpages()
	unconditionally, and populating N_HIGH_MEMORY node
	state therein from nodes in the early_node_map[].
	This duplicates the code in free_area_init_nodes(), but
	I don't want to depend on this copy if ZONE_MOVABLE
	might go away, taking early_calculate_totalpages()
	with it.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Jeremy Higdon <jeremy@sgi.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   48 +++++++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 28 deletions(-)

diff -puN mm/page_alloc.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix
+++ a/mm/page_alloc.c
@@ -1814,18 +1814,10 @@ static int find_next_best_node(int node,
 		return node;
 	}
 
-	for_each_online_node(n) {
+	for_each_node_state(n, N_HIGH_MEMORY) {
 		pg_data_t *pgdat = NODE_DATA(n);
 		cpumask_t tmp;
 
-		/*
-		 * skip nodes w/o memory.
-		 * Note:  N_HIGH_MEMORY state not guaranteed to be
-		 *        populated yet.
-		 */
-		if (pgdat->node_present_pages)
-			continue;
-
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
 			continue;
@@ -2120,20 +2112,6 @@ static void build_zonelist_cache(pg_data
 
 #endif	/* CONFIG_NUMA */
 
-/* Any regular memory on that node ? */
-static void check_for_regular_memory(pg_data_t *pgdat)
-{
-#ifdef CONFIG_HIGHMEM
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
-		struct zone *zone = &pgdat->node_zones[zone_type];
-		if (zone->present_pages)
-			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
-	}
-#endif
-}
-
 /* return values int ....just for stop_machine_run() */
 static int __build_all_zonelists(void *dummy)
 {
@@ -2144,11 +2122,6 @@ static int __build_all_zonelists(void *d
 
 		build_zonelists(pgdat);
 		build_zonelist_cache(pgdat);
-
-		/* Any memory on that node */
-		if (pgdat->node_present_pages)
-			node_set_state(nid, N_HIGH_MEMORY);
-		check_for_regular_memory(pgdat);
 	}
 	return 0;
 }
@@ -3462,6 +3435,20 @@ restart:
 			roundup(zone_movable_pfn[nid], MAX_ORDER_NR_PAGES);
 }
 
+/* Any regular memory on that node ? */
+static void check_for_regular_memory(pg_data_t *pgdat)
+{
+#ifdef CONFIG_HIGHMEM
+	enum zone_type zone_type;
+
+	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+		if (zone->present_pages)
+			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+	}
+#endif
+}
+
 /**
  * free_area_init_nodes - Initialise all pg_data_t and zone data
  * @max_zone_pfn: an array of max PFNs for each zone
@@ -3536,6 +3523,11 @@ void __init free_area_init_nodes(unsigne
 		pg_data_t *pgdat = NODE_DATA(nid);
 		free_area_init_node(nid, pgdat, NULL,
 				find_min_pfn_for_node(nid), NULL);
+
+		/* Any memory on that node */
+		if (pgdat->node_present_pages)
+			node_set_state(nid, N_HIGH_MEMORY);
+		check_for_regular_memory(pgdat);
 	}
 }
 
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
