From: akpm@linux-foundation.org
Subject: - numa-generic-management-of-nodemasks-for-various-purposes.patch removed from -mm tree
Date: Fri, 03 Aug 2007 22:15:06 -0700
Message-ID: <200708040515.l745F7gq011708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbXHDFPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 4 Aug 2007 01:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     NUMA: Generic management of nodemasks for various purposes
has been removed from the -mm tree.  Its filename was
     numa-generic-management-of-nodemasks-for-various-purposes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: NUMA: Generic management of nodemasks for various purposes
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Preparation for memoryless node patches.

Provide a generic way to keep nodemasks describing various characteristics of
NUMA nodes.

Remove the node_online_map and the node_possible map and realize the whole
thing using two nodes stats: N_POSSIBLE and N_ONLINE.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   87 ++++++++++++++++++++++++++++++-------
 mm/page_alloc.c          |   13 ++---
 2 files changed, 78 insertions(+), 22 deletions(-)

diff -puN include/linux/nodemask.h~numa-generic-management-of-nodemasks-for-various-purposes include/linux/nodemask.h
--- a/include/linux/nodemask.h~numa-generic-management-of-nodemasks-for-various-purposes
+++ a/include/linux/nodemask.h
@@ -338,31 +338,81 @@ static inline void __nodes_remap(nodemas
 #endif /* MAX_NUMNODES */
 
 /*
+ * Bitmasks that are kept for all the nodes.
+ */
+enum node_states {
+	N_POSSIBLE,	/* The node could become online at some point */
+	N_ONLINE,	/* The node is online */
+	NR_NODE_STATES
+};
+
+/*
  * The following particular system nodemasks and operations
  * on them manage all possible and online nodes.
  */
 
-extern nodemask_t node_online_map;
-extern nodemask_t node_possible_map;
+extern nodemask_t node_states[NR_NODE_STATES];
 
 #if MAX_NUMNODES > 1
-#define num_online_nodes()	nodes_weight(node_online_map)
-#define num_possible_nodes()	nodes_weight(node_possible_map)
-#define node_online(node)	node_isset((node), node_online_map)
-#define node_possible(node)	node_isset((node), node_possible_map)
-#define first_online_node	first_node(node_online_map)
-#define next_online_node(nid)	next_node((nid), node_online_map)
+static inline int node_state(int node, enum node_states state)
+{
+	return node_isset(node, node_states[state]);
+}
+
+static inline void node_set_state(int node, enum node_states state)
+{
+	__node_set(node, &node_states[state]);
+}
+
+static inline void node_clear_state(int node, enum node_states state)
+{
+	__node_clear(node, &node_states[state]);
+}
+
+static inline int num_node_state(enum node_states state)
+{
+	return nodes_weight(node_states[state]);
+}
+
+#define for_each_node_state(__node, __state) \
+	for_each_node_mask((__node), node_states[__state])
+
+#define first_online_node	first_node(node_states[N_ONLINE])
+#define next_online_node(nid)	next_node((nid), node_states[N_ONLINE])
+
 extern int nr_node_ids;
 #else
-#define num_online_nodes()	1
-#define num_possible_nodes()	1
-#define node_online(node)	((node) == 0)
-#define node_possible(node)	((node) == 0)
+
+static inline int node_state(int node, enum node_states state)
+{
+	return node == 0;
+}
+
+static inline void node_set_state(int node, enum node_states state)
+{
+}
+
+static inline void node_clear_state(int node, enum node_states state)
+{
+}
+
+static inline int num_node_state(enum node_states state)
+{
+	return 1;
+}
+
+#define for_each_node_state(node, __state) \
+	for ( (node) = 0; (node) != 0; (node) = 1)
+
 #define first_online_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
+
 #endif
 
+#define node_online_map 	node_states[N_ONLINE]
+#define node_possible_map 	node_states[N_POSSIBLE]
+
 #define any_online_node(mask)			\
 ({						\
 	int node;				\
@@ -372,10 +422,15 @@ extern int nr_node_ids;
 	node;					\
 })
 
-#define node_set_online(node)	   set_bit((node), node_online_map.bits)
-#define node_set_offline(node)	   clear_bit((node), node_online_map.bits)
+#define num_online_nodes()	num_node_state(N_ONLINE)
+#define num_possible_nodes()	num_node_state(N_POSSIBLE)
+#define node_online(node)	node_state((node), N_ONLINE)
+#define node_possible(node)	node_state((node), N_POSSIBLE)
+
+#define node_set_online(node)	   node_set_state((node), N_ONLINE)
+#define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
 
-#define for_each_node(node)	   for_each_node_mask((node), node_possible_map)
-#define for_each_online_node(node) for_each_node_mask((node), node_online_map)
+#define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
+#define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 
 #endif /* __LINUX_NODEMASK_H */
diff -puN mm/page_alloc.c~numa-generic-management-of-nodemasks-for-various-purposes mm/page_alloc.c
--- a/mm/page_alloc.c~numa-generic-management-of-nodemasks-for-various-purposes
+++ a/mm/page_alloc.c
@@ -48,13 +48,14 @@
 #include "internal.h"
 
 /*
- * MCD - HACK: Find somewhere to initialize this EARLY, or make this
- * initializer cleaner
+ * Array of node states.
  */
-nodemask_t node_online_map __read_mostly = { { [0] = 1UL } };
-EXPORT_SYMBOL(node_online_map);
-nodemask_t node_possible_map __read_mostly = NODE_MASK_ALL;
-EXPORT_SYMBOL(node_possible_map);
+nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
+	[N_POSSIBLE] = NODE_MASK_ALL,
+	[N_ONLINE] = { { [0] = 1UL } }
+};
+EXPORT_SYMBOL(node_states);
+
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 long nr_swap_pages;
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

fix-missing-numa_zonelist_order-sysctl.patch
document-linux-memory-policy-v3.patch
numa-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior.patch
oom-use-the-n_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-node-slab-support.patch
memoryless-nodes-slub-support.patch
uncached-allocator-handle-memoryless-nodes.patch
memoryless-node-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
add-n_cpu-node-state.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-node_memory_map-for-cpusets.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
