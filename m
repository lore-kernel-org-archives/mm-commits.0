From: akpm@linux-foundation.org
Subject: + memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:31:09 -0700
Message-ID: <200708172031.l7HKV96M028149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbXHQUbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:31:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     memoryless nodes: fixup uses of node_online_map in generic code
has been added to the -mm tree.  Its filename is
     memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memoryless nodes: fixup uses of node_online_map in generic code
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Here's a cut at fixing up uses of the online node map in generic code. 

mm/shmem.c:shmem_parse_mpol()

	Ensure nodelist is subset of nodes with memory.
	Use node_states[N_HIGH_MEMORY] as default for missing
	nodelist for interleave policy.

mm/shmem.c:shmem_fill_super()

	initialize policy_nodes to node_states[N_HIGH_MEMORY]

mm/page-writeback.c:highmem_dirtyable_memory()

	sum over nodes with memory

mm/swap_prefetch.c:clear_last_prefetch_free()
                   clear_last_current_free()

	use nodes with memory for prefetch nodes.
	just in case ...

mm/page_alloc.c:zlc_setup()

	allowednodes - use nodes with memory.

mm/page_alloc.c:default_zonelist_order()

	average over nodes with memory.

mm/page_alloc.c:find_next_best_node()

	skip nodes w/o memory.
	N_HIGH_MEMORY state mask may not be initialized at this time,
	unless we want to depend on early_calculate_totalpages() [see
	below].  Will ZONE_MOVABLE ever be configurable?

mm/page_alloc.c:find_zone_movable_pfns_for_nodes()

	spread kernelcore over nodes with memory.

	This required calling early_calculate_totalpages()
	unconditionally, and populating N_HIGH_MEMORY node
	state therein from nodes in the early_node_map[].
	If we can depend on this, we can eliminate the
	population of N_HIGH_MEMORY mask from __build_all_zonelists()
	and use the N_HIGH_MEMORY mask in find_next_best_node().

mm/mempolicy.c:mpol_check_policy()

	Ensure nodes specified for policy are subset of
	nodes with memory.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c      |    2 +-
 mm/page-writeback.c |    2 +-
 mm/page_alloc.c     |   38 ++++++++++++++++++++++++++++----------
 mm/shmem.c          |   13 ++++++++-----
 4 files changed, 38 insertions(+), 17 deletions(-)

diff -puN mm/mempolicy.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code mm/mempolicy.c
--- a/mm/mempolicy.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code
+++ a/mm/mempolicy.c
@@ -126,7 +126,7 @@ static int mpol_check_policy(int mode, n
 			return -EINVAL;
 		break;
 	}
-	return nodes_subset(*nodes, node_online_map) ? 0 : -EINVAL;
+ 	return nodes_subset(*nodes, node_states[N_HIGH_MEMORY]) ? 0 : -EINVAL;
 }
 
 /* Generate a custom zonelist for the BIND policy. */
diff -puN mm/page-writeback.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code mm/page-writeback.c
--- a/mm/page-writeback.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code
+++ a/mm/page-writeback.c
@@ -126,7 +126,7 @@ static unsigned long highmem_dirtyable_m
 	int node;
 	unsigned long x = 0;
 
-	for_each_online_node(node) {
+	for_each_node_state(node, N_HIGH_MEMORY) {
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
diff -puN mm/page_alloc.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code
+++ a/mm/page_alloc.c
@@ -1040,7 +1040,7 @@ int zone_watermark_ok(struct zone *z, in
  *
  * If the zonelist cache is present in the passed in zonelist, then
  * returns a pointer to the allowed node mask (either the current
- * tasks mems_allowed, or node_online_map.)
+ * tasks mems_allowed, or node_states[N_HIGH_MEMORY].)
  *
  * If the zonelist cache is not available for this zonelist, does
  * nothing and returns NULL.
@@ -1069,7 +1069,7 @@ static nodemask_t *zlc_setup(struct zone
 
 	allowednodes = !in_interrupt() && (alloc_flags & ALLOC_CPUSET) ?
 					&cpuset_current_mems_allowed :
-					&node_online_map;
+					&node_states[N_HIGH_MEMORY];
 	return allowednodes;
 }
 
@@ -1803,8 +1803,17 @@ static int find_next_best_node(int node,
 	}
 
 	for_each_online_node(n) {
+		pg_data_t *pgdat = NODE_DATA(n);
 		cpumask_t tmp;
 
+		/*
+		 * skip nodes w/o memory.
+		 * Note:  N_HIGH_MEMORY state not guaranteed to be
+		 *        populated yet.
+		 */
+		if (pgdat->node_present_pages)
+			continue;
+
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
 			continue;
@@ -1939,7 +1948,8 @@ static int default_zonelist_order(void)
   	 * If there is a node whose DMA/DMA32 memory is very big area on
  	 * local memory, NODE_ORDER may be suitable.
          */
-	average_size = total_size / (num_online_nodes() + 1);
+	average_size = total_size /
+				(nodes_weight(node_states[N_HIGH_MEMORY]) + 1);
 	for_each_online_node(nid) {
 		low_kmem_size = 0;
 		total_size = 0;
@@ -3279,16 +3289,24 @@ unsigned long __init find_max_pfn_with_a
 	return max_pfn;
 }
 
+/*
+ * early_calculate_totalpages()
+ * Sum pages in active regions for movable zone.
+ * Populate N_HIGH_MEMORY for calculating usable_nodes.
+ */
 unsigned long __init early_calculate_totalpages(void)
 {
 	int i;
 	unsigned long totalpages = 0;
 
-	for (i = 0; i < nr_nodemap_entries; i++)
-		totalpages += early_node_map[i].end_pfn -
+	for (i = 0; i < nr_nodemap_entries; i++) {
+		unsigned long pages = early_node_map[i].end_pfn -
 						early_node_map[i].start_pfn;
-
-	return totalpages;
+		totalpages += pages;
+		if (pages)
+			node_set_state(early_node_map[i].nid, N_HIGH_MEMORY);
+	}
+  	return totalpages;
 }
 
 /*
@@ -3302,7 +3320,8 @@ void __init find_zone_movable_pfns_for_n
 	int i, nid;
 	unsigned long usable_startpfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
-	int usable_nodes = num_online_nodes();
+	unsigned long totalpages = early_calculate_totalpages();
+	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
 
 	/*
 	 * If movablecore was specified, calculate what size of
@@ -3313,7 +3332,6 @@ void __init find_zone_movable_pfns_for_n
 	 * what movablecore would have allowed.
 	 */
 	if (required_movablecore) {
-		unsigned long totalpages = early_calculate_totalpages();
 		unsigned long corepages;
 
 		/*
@@ -3338,7 +3356,7 @@ void __init find_zone_movable_pfns_for_n
 restart:
 	/* Spread kernelcore memory as evenly as possible throughout nodes */
 	kernelcore_node = required_kernelcore / usable_nodes;
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_HIGH_MEMORY) {
 		/*
 		 * Recalculate kernelcore_node if the division per node
 		 * now exceeds what is necessary to satisfy the requested
diff -puN mm/shmem.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code mm/shmem.c
--- a/mm/shmem.c~memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code
+++ a/mm/shmem.c
@@ -971,7 +971,7 @@ static inline int shmem_parse_mpol(char 
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, *policy_nodes))
 			goto out;
-		if (!nodes_subset(*policy_nodes, node_online_map))
+		if (!nodes_subset(*policy_nodes, node_states[N_HIGH_MEMORY]))
 			goto out;
 	}
 	if (!strcmp(value, "default")) {
@@ -996,9 +996,11 @@ static inline int shmem_parse_mpol(char 
 			err = 0;
 	} else if (!strcmp(value, "interleave")) {
 		*policy = MPOL_INTERLEAVE;
-		/* Default to nodes online if no nodelist */
+		/*
+		 * Default to online nodes with memory if no nodelist
+		 */
 		if (!nodelist)
-			*policy_nodes = node_online_map;
+			*policy_nodes = node_states[N_HIGH_MEMORY];
 		err = 0;
 	}
 out:
@@ -1060,7 +1062,8 @@ shmem_alloc_page(gfp_t gfp, struct shmem
 	return page;
 }
 #else
-static inline int shmem_parse_mpol(char *value, int *policy, nodemask_t *policy_nodes)
+static inline int shmem_parse_mpol(char *value, int *policy,
+						nodemask_t *policy_nodes)
 {
 	return 1;
 }
@@ -2239,7 +2242,7 @@ static int shmem_fill_super(struct super
 	unsigned long blocks = 0;
 	unsigned long inodes = 0;
 	int policy = MPOL_DEFAULT;
-	nodemask_t policy_nodes = node_online_map;
+	nodemask_t policy_nodes = node_states[N_HIGH_MEMORY];
 
 #ifdef CONFIG_TMPFS
 	/*
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

document-linux-memory-policy-v3.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
