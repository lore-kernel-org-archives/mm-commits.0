From: akpm@linux-foundation.org
Subject: + page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch added to -mm tree
Date: Thu, 15 Nov 2012 16:35:21 -0800
Message-ID: <20121116003522.4A122100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:65079 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2KPAfX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 19:35:23 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so247855vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 16:35:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, cl@linux.com, dhillf@gmail.com, linfeng@cn.fujitsu.com, rientjes@google.com, wency@cn.fujitsu.com


The patch titled
     Subject: page_alloc: use N_MEMORY instead N_HIGH_MEMORY change the node_states initialization
has been added to the -mm tree.  Its filename is
     page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: page_alloc: use N_MEMORY instead N_HIGH_MEMORY change the node_states initialization

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Since we introduced N_MEMORY, we update the initialization of node_states.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    4 +++-
 mm/page_alloc.c       |   40 ++++++++++++++++++++++------------------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff -puN arch/x86/mm/init_64.c~page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization
+++ a/arch/x86/mm/init_64.c
@@ -630,7 +630,9 @@ void __init paging_init(void)
 	 *	 numa support is not compiled in, and later node_set_state
 	 *	 will not set it back.
 	 */
-	node_clear_state(0, N_NORMAL_MEMORY);
+	node_clear_state(0, N_MEMORY);
+	if (N_MEMORY != N_NORMAL_MEMORY)
+		node_clear_state(0, N_NORMAL_MEMORY);
 
 	zone_sizes_init();
 }
diff -puN mm/page_alloc.c~page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization
+++ a/mm/page_alloc.c
@@ -1695,7 +1695,7 @@ bool zone_watermark_ok_safe(struct zone 
  *
  * If the zonelist cache is present in the passed in zonelist, then
  * returns a pointer to the allowed node mask (either the current
- * tasks mems_allowed, or node_states[N_HIGH_MEMORY].)
+ * tasks mems_allowed, or node_states[N_MEMORY].)
  *
  * If the zonelist cache is not available for this zonelist, does
  * nothing and returns NULL.
@@ -1724,7 +1724,7 @@ static nodemask_t *zlc_setup(struct zone
 
 	allowednodes = !in_interrupt() && (alloc_flags & ALLOC_CPUSET) ?
 					&cpuset_current_mems_allowed :
-					&node_states[N_HIGH_MEMORY];
+					&node_states[N_MEMORY];
 	return allowednodes;
 }
 
@@ -3272,7 +3272,7 @@ static int find_next_best_node(int node,
 		return node;
 	}
 
-	for_each_node_state(n, N_HIGH_MEMORY) {
+	for_each_node_state(n, N_MEMORY) {
 
 		/* Don't want a node to appear more than once */
 		if (node_isset(n, *used_node_mask))
@@ -3414,7 +3414,7 @@ static int default_zonelist_order(void)
  	 * local memory, NODE_ORDER may be suitable.
          */
 	average_size = total_size /
-				(nodes_weight(node_states[N_HIGH_MEMORY]) + 1);
+				(nodes_weight(node_states[N_MEMORY]) + 1);
 	for_each_online_node(nid) {
 		low_kmem_size = 0;
 		total_size = 0;
@@ -4768,7 +4768,7 @@ unsigned long __init find_min_pfn_with_a
 /*
  * early_calculate_totalpages()
  * Sum pages in active regions for movable zone.
- * Populate N_HIGH_MEMORY for calculating usable_nodes.
+ * Populate N_MEMORY for calculating usable_nodes.
  */
 static unsigned long __init early_calculate_totalpages(void)
 {
@@ -4781,7 +4781,7 @@ static unsigned long __init early_calcul
 
 		totalpages += pages;
 		if (pages)
-			node_set_state(nid, N_HIGH_MEMORY);
+			node_set_state(nid, N_MEMORY);
 	}
   	return totalpages;
 }
@@ -4798,9 +4798,9 @@ static void __init find_zone_movable_pfn
 	unsigned long usable_startpfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
 	/* save the state before borrow the nodemask */
-	nodemask_t saved_node_state = node_states[N_HIGH_MEMORY];
+	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
-	int usable_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
+	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
 
 	/*
 	 * If movablecore was specified, calculate what size of
@@ -4835,7 +4835,7 @@ static void __init find_zone_movable_pfn
 restart:
 	/* Spread kernelcore memory as evenly as possible throughout nodes */
 	kernelcore_node = required_kernelcore / usable_nodes;
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long start_pfn, end_pfn;
 
 		/*
@@ -4927,23 +4927,27 @@ restart:
 
 out:
 	/* restore the node_state */
-	node_states[N_HIGH_MEMORY] = saved_node_state;
+	node_states[N_MEMORY] = saved_node_state;
 }
 
-/* Any regular memory on that node ? */
-static void __init check_for_regular_memory(pg_data_t *pgdat)
+/* Any regular or high memory on that node ? */
+static void check_for_memory(pg_data_t *pgdat, int nid)
 {
-#ifdef CONFIG_HIGHMEM
 	enum zone_type zone_type;
 
-	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
+	if (N_MEMORY == N_NORMAL_MEMORY)
+		return;
+
+	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
 		if (zone->present_pages) {
-			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
+			node_set_state(nid, N_HIGH_MEMORY);
+			if (N_NORMAL_MEMORY != N_HIGH_MEMORY &&
+			    zone_type <= ZONE_NORMAL)
+				node_set_state(nid, N_NORMAL_MEMORY);
 			break;
 		}
 	}
-#endif
 }
 
 /**
@@ -5026,8 +5030,8 @@ void __init free_area_init_nodes(unsigne
 
 		/* Any memory on that node */
 		if (pgdat->node_present_pages)
-			node_set_state(nid, N_HIGH_MEMORY);
-		check_for_regular_memory(pgdat);
+			node_set_state(nid, N_MEMORY);
+		check_for_memory(pgdat, nid);
 	}
 }
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drivers-base-nodec-cleanup-node_state_attr.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
node_states-introduce-n_memory.patch
cpuset-use-n_memory-instead-n_high_memory.patch
procfs-use-n_memory-instead-n_high_memory.patch
memcontrol-use-n_memory-instead-n_high_memory.patch
oom-use-n_memory-instead-n_high_memory.patch
mmmigrate-use-n_memory-instead-n_high_memory.patch
mempolicy-use-n_memory-instead-n_high_memory.patch
hugetlb-use-n_memory-instead-n_high_memory.patch
vmstat-use-n_memory-instead-n_high_memory.patch
kthread-use-n_memory-instead-n_high_memory.patch
init-use-n_memory-instead-n_high_memory.patch
vmscan-use-n_memory-instead-n_high_memory.patch
page_alloc-use-n_memory-instead-n_high_memory-change-the-node_states-initialization.patch
hotplug-update-nodemasks-management.patch

