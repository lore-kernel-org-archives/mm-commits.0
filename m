From: akpm@linux-foundation.org
Subject: - memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:11 -0700
Message-ID: <200710162034.l9GKYBX7014907@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965862AbXJPVlF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, clameter@sgi.com, lee.schermerhorn@hp.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     memoryless nodes: fixup uses of node_online_map in generic code
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix warnings]
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c      |    4 +-
 mm/page-writeback.c |    2 -
 mm/page_alloc.c     |   69 +++++++++++++++++++++++-------------------
 mm/shmem.c          |   13 ++++---
 4 files changed, 50 insertions(+), 38 deletions(-)

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
@@ -965,7 +965,7 @@ asmlinkage long sys_migrate_pages(pid_t 
 		goto out;
 	}
 
-	if (!nodes_subset(new, node_online_map)) {
+	if (!nodes_subset(new, node_states[N_HIGH_MEMORY])) {
 		err = -EINVAL;
 		goto out;
 	}
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
 
@@ -1802,7 +1802,7 @@ static int find_next_best_node(int node,
 		return node;
 	}
 
-	for_each_online_node(n) {
+	for_each_node_state(n, N_HIGH_MEMORY) {
 		cpumask_t tmp;
 
 		/* Don't want a node to appear more than once */
@@ -1939,7 +1939,8 @@ static int default_zonelist_order(void)
   	 * If there is a node whose DMA/DMA32 memory is very big area on
  	 * local memory, NODE_ORDER may be suitable.
          */
-	average_size = total_size / (num_online_nodes() + 1);
+	average_size = total_size /
+				(nodes_weight(node_states[N_HIGH_MEMORY]) + 1);
 	for_each_online_node(nid) {
 		low_kmem_size = 0;
 		total_size = 0;
@@ -2098,20 +2099,6 @@ static void build_zonelist_cache(pg_data
 
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
@@ -2122,11 +2109,6 @@ static int __build_all_zonelists(void *d
 
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
@@ -3282,16 +3264,24 @@ unsigned long __init find_max_pfn_with_a
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
@@ -3305,7 +3295,8 @@ void __init find_zone_movable_pfns_for_n
 	int i, nid;
 	unsigned long usable_startpfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
-	int usable_nodes = num_online_nodes();
+	unsigned long totalpages = early_calculate_totalpages();
+	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
 
 	/*
 	 * If movablecore was specified, calculate what size of
@@ -3316,7 +3307,6 @@ void __init find_zone_movable_pfns_for_n
 	 * what movablecore would have allowed.
 	 */
 	if (required_movablecore) {
-		unsigned long totalpages = early_calculate_totalpages();
 		unsigned long corepages;
 
 		/*
@@ -3341,7 +3331,7 @@ void __init find_zone_movable_pfns_for_n
 restart:
 	/* Spread kernelcore memory as evenly as possible throughout nodes */
 	kernelcore_node = required_kernelcore / usable_nodes;
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_HIGH_MEMORY) {
 		/*
 		 * Recalculate kernelcore_node if the division per node
 		 * now exceeds what is necessary to satisfy the requested
@@ -3433,6 +3423,20 @@ restart:
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
@@ -3507,6 +3511,11 @@ void __init free_area_init_nodes(unsigne
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
@@ -2238,7 +2241,7 @@ static int shmem_fill_super(struct super
 	unsigned long blocks = 0;
 	unsigned long inodes = 0;
 	int policy = MPOL_DEFAULT;
-	nodemask_t policy_nodes = node_online_map;
+	nodemask_t policy_nodes = node_states[N_HIGH_MEMORY];
 
 #ifdef CONFIG_TMPFS
 	/*
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
