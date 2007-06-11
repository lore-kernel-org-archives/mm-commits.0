From: akpm@linux-foundation.org
Subject: + add-populated_map-to-account-for-memoryless-nodes.patch added to -mm tree
Date: Mon, 11 Jun 2007 16:13:12 -0700
Message-ID: <200706112313.l5BNDCeW031541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753551AbXFKXN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 19:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@us.ibm.com, anton@samba.org, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     Add populated_map to account for memoryless nodes
has been added to the -mm tree.  Its filename is
     add-populated_map-to-account-for-memoryless-nodes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add populated_map to account for memoryless nodes
From: Nishanth Aravamudan <nacc@us.ibm.com>

Split up Lee and Anton's original patch
(http://marc.info/?l=linux-mm&m=118133042025995&w=2), to allow for the
populated_map changes to go in on their own.

Add a populated_map nodemask to indicate a node has memory or not.  We have
run into a number of issues (in practice and in code) with assumptions
about every node having memory.  Having this nodemask allows us to fix
these issues; in particular, THISNODE allocations will come from the node
specified, only, and the INTERLEAVE policy will be able to do the right
thing with memoryless nodes.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Anton Blanchard <anton@samba.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   10 ++++++++++
 mm/page_alloc.c          |   10 ++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/nodemask.h~add-populated_map-to-account-for-memoryless-nodes include/linux/nodemask.h
--- a/include/linux/nodemask.h~add-populated_map-to-account-for-memoryless-nodes
+++ a/include/linux/nodemask.h
@@ -64,12 +64,16 @@
  *
  * int node_online(node)		Is some node online?
  * int node_possible(node)		Is some node possible?
+ * int node_populated(node)		Is some node populated?
  *
  * int any_online_node(mask)		First online node in mask
  *
  * node_set_online(node)		set bit 'node' in node_online_map
  * node_set_offline(node)		clear bit 'node' in node_online_map
  *
+ * node_set_populated(node)		set bit 'node' in node_populated_map
+ * node_not_populated(node)		clear bit 'node' in node_populated_map
+ *
  * for_each_node(node)			for-loop node over node_possible_map
  * for_each_online_node(node)		for-loop node over node_online_map
  *
@@ -344,12 +348,14 @@ static inline void __nodes_remap(nodemas
 
 extern nodemask_t node_online_map;
 extern nodemask_t node_possible_map;
+extern nodemask_t node_populated_map;
 
 #if MAX_NUMNODES > 1
 #define num_online_nodes()	nodes_weight(node_online_map)
 #define num_possible_nodes()	nodes_weight(node_possible_map)
 #define node_online(node)	node_isset((node), node_online_map)
 #define node_possible(node)	node_isset((node), node_possible_map)
+#define node_populated(node)	node_isset((node), node_populated_map)
 #define first_online_node	first_node(node_online_map)
 #define next_online_node(nid)	next_node((nid), node_online_map)
 extern int nr_node_ids;
@@ -358,6 +364,7 @@ extern int nr_node_ids;
 #define num_possible_nodes()	1
 #define node_online(node)	((node) == 0)
 #define node_possible(node)	((node) == 0)
+#define node_populated(node)	((node) == 0)
 #define first_online_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
@@ -375,6 +382,9 @@ extern int nr_node_ids;
 #define node_set_online(node)	   set_bit((node), node_online_map.bits)
 #define node_set_offline(node)	   clear_bit((node), node_online_map.bits)
 
+#define node_set_populated(node)   set_bit((node), node_populated_map.bits)
+#define node_not_populated(node)   clear_bit((node), node_populated_map.bits)
+
 #define for_each_node(node)	   for_each_node_mask((node), node_possible_map)
 #define for_each_online_node(node) for_each_node_mask((node), node_online_map)
 
diff -puN mm/page_alloc.c~add-populated_map-to-account-for-memoryless-nodes mm/page_alloc.c
--- a/mm/page_alloc.c~add-populated_map-to-account-for-memoryless-nodes
+++ a/mm/page_alloc.c
@@ -54,6 +54,9 @@ nodemask_t node_online_map __read_mostly
 EXPORT_SYMBOL(node_online_map);
 nodemask_t node_possible_map __read_mostly = NODE_MASK_ALL;
 EXPORT_SYMBOL(node_possible_map);
+nodemask_t node_populated_map __read_mostly = NODE_MASK_NONE;
+EXPORT_SYMBOL(node_populated_map);
+
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 long nr_swap_pages;
@@ -1967,6 +1970,13 @@ static void build_zonelists(pg_data_t *p
 		/* calculate node order -- i.e., DMA last! */
 		build_zonelists_in_zone_order(pgdat, j);
 	}
+
+	/*
+	 * record populated zones for use when INTERLEAVE'ing or using
+	 * GFP_THISNODE
+	 */
+	if (pgdat->node_present_pages)
+		node_set_populated(local_node);
 }
 
 /* Construct the zonelist performance cache - see further mmzone.h */
_

Patches currently in -mm which might be from nacc@us.ibm.com are

hugetlb-remove-unnecessary-nid-initialization.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
add-populated_map-to-account-for-memoryless-nodes.patch
