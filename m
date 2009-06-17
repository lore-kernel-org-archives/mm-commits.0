From: akpm@linux-foundation.org
Subject: [merged] page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:26 -0700
Message-ID: <200906171834.n5HIYQDt000456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbZFQSfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux-foundation.org, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: use a pre-calculated value instead of num_online_nodes() in fast paths
has been removed from the -mm tree.  Its filename was
     page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: use a pre-calculated value instead of num_online_nodes() in fast paths
From: Christoph Lameter <cl@linux-foundation.org>

num_online_nodes() is called in a number of places but most often by the
page allocator when deciding whether the zonelist needs to be filtered
based on cpusets or the zonelist cache.  This is actually a heavy function
and touches a number of cache lines.

This patch stores the number of online nodes at boot time and updates the
value when nodes get onlined and offlined.  The value is then used in a
number of important paths in place of num_online_nodes().

[rientjes@google.com: do not override definition of node_set_online() with macro]
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   19 ++++++++++++++++---
 mm/hugetlb.c             |    4 ++--
 mm/page_alloc.c          |   10 ++++++----
 mm/slub.c                |    2 +-
 net/sunrpc/svc.c         |    2 +-
 5 files changed, 26 insertions(+), 11 deletions(-)

diff -puN include/linux/nodemask.h~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths include/linux/nodemask.h
--- a/include/linux/nodemask.h~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/include/linux/nodemask.h
@@ -408,6 +408,19 @@ static inline int num_node_state(enum no
 #define next_online_node(nid)	next_node((nid), node_states[N_ONLINE])
 
 extern int nr_node_ids;
+extern int nr_online_nodes;
+
+static inline void node_set_online(int nid)
+{
+	node_set_state(nid, N_ONLINE);
+	nr_online_nodes = num_node_state(N_ONLINE);
+}
+
+static inline void node_set_offline(int nid)
+{
+	node_clear_state(nid, N_ONLINE);
+	nr_online_nodes = num_node_state(N_ONLINE);
+}
 #else
 
 static inline int node_state(int node, enum node_states state)
@@ -434,7 +447,10 @@ static inline int num_node_state(enum no
 #define first_online_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
+#define nr_online_nodes		1
 
+#define node_set_online(node)	   node_set_state((node), N_ONLINE)
+#define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
 #endif
 
 #define node_online_map 	node_states[N_ONLINE]
@@ -454,9 +470,6 @@ static inline int num_node_state(enum no
 #define node_online(node)	node_state((node), N_ONLINE)
 #define node_possible(node)	node_state((node), N_POSSIBLE)
 
-#define node_set_online(node)	   node_set_state((node), N_ONLINE)
-#define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
-
 #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 
diff -puN mm/hugetlb.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths mm/hugetlb.c
--- a/mm/hugetlb.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/mm/hugetlb.c
@@ -875,7 +875,7 @@ static void return_unused_surplus_pages(
 	 * can no longer free unreserved surplus pages. This occurs when
 	 * the nodes with surplus pages have no free pages.
 	 */
-	unsigned long remaining_iterations = num_online_nodes();
+	unsigned long remaining_iterations = nr_online_nodes;
 
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
@@ -904,7 +904,7 @@ static void return_unused_surplus_pages(
 			h->surplus_huge_pages--;
 			h->surplus_huge_pages_node[nid]--;
 			nr_pages--;
-			remaining_iterations = num_online_nodes();
+			remaining_iterations = nr_online_nodes;
 		}
 	}
 }
diff -puN mm/page_alloc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/mm/page_alloc.c
@@ -161,7 +161,9 @@ static unsigned long __meminitdata dma_r
 
 #if MAX_NUMNODES > 1
 int nr_node_ids __read_mostly = MAX_NUMNODES;
+int nr_online_nodes __read_mostly = 1;
 EXPORT_SYMBOL(nr_node_ids);
+EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
 int page_group_by_mobility_disabled __read_mostly;
@@ -1466,7 +1468,7 @@ this_zone_full:
 		if (NUMA_BUILD)
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
-		if (NUMA_BUILD && !did_zlc_setup && num_online_nodes() > 1) {
+		if (NUMA_BUILD && !did_zlc_setup && nr_online_nodes > 1) {
 			/*
 			 * we do zlc_setup after the first zone is tried but only
 			 * if there are multiple nodes make it worthwhile
@@ -2265,7 +2267,7 @@ int numa_zonelist_order_handler(ctl_tabl
 }
 
 
-#define MAX_NODE_LOAD (num_online_nodes())
+#define MAX_NODE_LOAD (nr_online_nodes)
 static int node_load[MAX_NUMNODES];
 
 /**
@@ -2474,7 +2476,7 @@ static void build_zonelists(pg_data_t *p
 
 	/* NUMA-aware ordering of nodes */
 	local_node = pgdat->node_id;
-	load = num_online_nodes();
+	load = nr_online_nodes;
 	prev_node = local_node;
 	nodes_clear(used_mask);
 
@@ -2625,7 +2627,7 @@ void build_all_zonelists(void)
 
 	printk("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
-			num_online_nodes(),
+			nr_online_nodes,
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
diff -puN mm/slub.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths mm/slub.c
--- a/mm/slub.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/mm/slub.c
@@ -3737,7 +3737,7 @@ static int list_locations(struct kmem_ca
 						 to_cpumask(l->cpus));
 		}
 
-		if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
+		if (nr_online_nodes > 1 && !nodes_empty(l->nodes) &&
 				len < PAGE_SIZE - 60) {
 			len += sprintf(buf + len, " nodes=");
 			len += nodelist_scnprintf(buf + len, PAGE_SIZE - len - 50,
diff -puN net/sunrpc/svc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths
+++ a/net/sunrpc/svc.c
@@ -124,7 +124,7 @@ svc_pool_map_choose_mode(void)
 {
 	unsigned int node;
 
-	if (num_online_nodes() > 1) {
+	if (nr_online_nodes > 1) {
 		/*
 		 * Actually have multiple NUMA nodes,
 		 * so split pools on NUMA node boundaries
_

Patches currently in -mm which might be from cl@linux-foundation.org are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
reiser4.patch
slab-leaks3-default-y.patch

