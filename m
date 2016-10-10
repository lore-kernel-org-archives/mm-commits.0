From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-zonelist-name-instead-of-using-hardcoded-index.patch removed from
 -mm tree
Date: Mon, 10 Oct 2016 15:44:15 -0700
Message-ID: <57fc19bf.UDXb6Ah7dWIFGBxG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbcJJWoQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use zonelist name instead of using hardcoded index
has been removed from the -mm tree.  Its filename was
     mm-use-zonelist-name-instead-of-using-hardcoded-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: use zonelist name instead of using hardcoded index

Use the existing enums instead of hardcoded index when looking at the
zonelist.  This makes it more readable.  No functionality change by this
patch.

Link: http://lkml.kernel.org/r/1472227078-24852-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c  |    2 +-
 mm/page_alloc.c |    8 ++++----
 mm/vmscan.c     |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~mm-use-zonelist-name-instead-of-using-hardcoded-index mm/mempolicy.c
--- a/mm/mempolicy.c~mm-use-zonelist-name-instead-of-using-hardcoded-index
+++ a/mm/mempolicy.c
@@ -1749,7 +1749,7 @@ unsigned int mempolicy_slab_node(void)
 		 */
 		struct zonelist *zonelist;
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
-		zonelist = &NODE_DATA(node)->node_zonelists[0];
+		zonelist = &NODE_DATA(node)->node_zonelists[ZONELIST_FALLBACK];
 		z = first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes);
 		return z->zone ? z->zone->node : node;
diff -puN mm/page_alloc.c~mm-use-zonelist-name-instead-of-using-hardcoded-index mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-zonelist-name-instead-of-using-hardcoded-index
+++ a/mm/page_alloc.c
@@ -4574,7 +4574,7 @@ static void build_zonelists_in_node_orde
 	int j;
 	struct zonelist *zonelist;
 
-	zonelist = &pgdat->node_zonelists[0];
+	zonelist = &pgdat->node_zonelists[ZONELIST_FALLBACK];
 	for (j = 0; zonelist->_zonerefs[j].zone != NULL; j++)
 		;
 	j = build_zonelists_node(NODE_DATA(node), zonelist, j);
@@ -4590,7 +4590,7 @@ static void build_thisnode_zonelists(pg_
 	int j;
 	struct zonelist *zonelist;
 
-	zonelist = &pgdat->node_zonelists[1];
+	zonelist = &pgdat->node_zonelists[ZONELIST_NOFALLBACK];
 	j = build_zonelists_node(pgdat, zonelist, 0);
 	zonelist->_zonerefs[j].zone = NULL;
 	zonelist->_zonerefs[j].zone_idx = 0;
@@ -4611,7 +4611,7 @@ static void build_zonelists_in_zone_orde
 	struct zone *z;
 	struct zonelist *zonelist;
 
-	zonelist = &pgdat->node_zonelists[0];
+	zonelist = &pgdat->node_zonelists[ZONELIST_FALLBACK];
 	pos = 0;
 	for (zone_type = MAX_NR_ZONES - 1; zone_type >= 0; zone_type--) {
 		for (j = 0; j < nr_nodes; j++) {
@@ -4746,7 +4746,7 @@ static void build_zonelists(pg_data_t *p
 
 	local_node = pgdat->node_id;
 
-	zonelist = &pgdat->node_zonelists[0];
+	zonelist = &pgdat->node_zonelists[ZONELIST_FALLBACK];
 	j = build_zonelists_node(pgdat, zonelist, 0);
 
 	/*
diff -puN mm/vmscan.c~mm-use-zonelist-name-instead-of-using-hardcoded-index mm/vmscan.c
--- a/mm/vmscan.c~mm-use-zonelist-name-instead-of-using-hardcoded-index
+++ a/mm/vmscan.c
@@ -3036,7 +3036,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	 */
 	nid = mem_cgroup_select_victim_node(memcg);
 
-	zonelist = NODE_DATA(nid)->node_zonelists;
+	zonelist = &NODE_DATA(nid)->node_zonelists[ZONELIST_FALLBACK];
 
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


