From: akpm@linux-foundation.org
Subject: + memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:38:11 -0700
Message-ID: <200708072038.l77KcB2D002803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbXHGUjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com


The patch titled
     Memoryless nodes: Generic management of nodemasks for various purposes
has been added to the -mm tree.  Its filename is
     memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Memoryless nodes: Generic management of nodemasks for various purposes
From: Christoph Lameter <clameter@sgi.com>

Preparation for memoryless node patches.

Provide a generic way to keep nodemasks describing various characteristics of
NUMA nodes.

Remove the node_online_map and the node_possible map and realize the same
functionality using two nodes stats: N_POSSIBLE and N_ONLINE.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   87 ++++++++++++++++++++++++++++++-------
 mm/page_alloc.c          |   13 ++---
 2 files changed, 78 insertions(+), 22 deletions(-)

diff -puN include/linux/nodemask.h~memoryless-nodes-generic-management-of-nodemasks-for-various-purposes include/linux/nodemask.h
--- a/include/linux/nodemask.h~memoryless-nodes-generic-management-of-nodemasks-for-various-purposes
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
+	for ( (node) = 0; (node) == 0; (node) = 1)
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
diff -puN mm/page_alloc.c~memoryless-nodes-generic-management-of-nodemasks-for-various-purposes mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-generic-management-of-nodemasks-for-various-purposes
+++ a/mm/page_alloc.c
@@ -47,13 +47,14 @@
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

Patches currently in -mm which might be from clameter@sgi.com are

apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
document-linux-memory-policy-v3.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
