From: akpm@linux-foundation.org
Subject: - memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:39 -0700
Message-ID: <200710162033.l9GKXd66014814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965765AbXJPV4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, Lee.Schermerhorn@hp.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com, serge@hallyn.com, mm-commits@vger


The patch titled
     Memoryless nodes: Generic management of nodemasks for various purposes
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Memoryless nodes: Generic management of nodemasks for various purposes
From: Christoph Lameter <clameter@sgi.com>

Why do we need to support memoryless nodes?

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> For fujitsu, problem is called "empty" node.
> 
> When ACPI's SRAT table includes "possible nodes", ia64 bootstrap(acpi_numa_init)
> creates nodes, which includes no memory, no cpu.
> 
> I tried to remove empty-node in past, but that was denied.
> It was because we can hot-add cpu to the empty node.
> (node-hotplug triggered by cpu is not implemented now. and it will be ugly.)
> 
> 
> For HP, (Lee can comment on this later), they have memory-less-node.
> As far as I hear, HP's machine can have following configration.
> 
> (example)
> Node0: CPU0   memory AAA MB
> Node1: CPU1   memory AAA MB
> Node2: CPU2   memory AAA MB
> Node3: CPU3   memory AAA MB
> Node4: Memory XXX GB
> 
> AAA is very small value (below 16MB)  and will be omitted by ia64 bootstrap.
> After boot, only Node 4 has valid memory (but have no cpu.)
> 
> Maybe this is memory-interleave by firmware config.


Christoph Lameter <clameter@sgi.com> wrote:

> Future SGI platforms (actually also current one can have but nothing like 
> that is deployed to my knowledge) have nodes with only cpus. Current SGI 
> platforms have nodes with just I/O that we so far cannot manage in the 
> core. So the arch code maps them to the nearest memory node.


Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> For the HP platforms, we can configure each cell with from 0% to 100%
> "cell local memory".  When we configure with <100% CLM, the "missing
> percentages" are interleaved by hardware on a cache-line granularity to
> improve bandwidth at the expense of latency for numa-challenged
> applications [and OSes, but not our problem ;-)].  When we boot Linux on
> such a config, all of the real nodes have no memory--it all resides in a
> single interleaved pseudo-node.  
> 
> When we boot Linux on a 100% CLM configuration [== NUMA], we still have
> the interleaved pseudo-node.  It contains a few hundred MB stolen from
> the real nodes to contain the DMA zone.  [Interleaved memory resides at
> phys addr 0].  The memoryless-nodes patches, along with the zoneorder
> patches, support this config as well.
> 
> Also, when we boot a NUMA config with the "mem=" command line,
> specifying less memory than actually exists, Linux takes the excluded
> memory "off the top" rather than distributing it across the nodes.  This
> can result in memoryless nodes, as well.
> 


This patch:

Preparation for memoryless node patches.

Provide a generic way to keep nodemasks describing various characteristics of
NUMA nodes.

Remove the node_online_map and the node_possible map and realize the same
functionality using two nodes stats: N_POSSIBLE and N_ONLINE.

[Lee.Schermerhorn@hp.com: Initialize N_*_MEMORY and N_CPU masks for non-NUMA config]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   87 ++++++++++++++++++++++++++++++-------
 mm/page_alloc.c          |   20 +++++---
 2 files changed, 85 insertions(+), 22 deletions(-)

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
@@ -47,13 +47,21 @@
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
+	[N_ONLINE] = { { [0] = 1UL } },
+#ifndef CONFIG_NUMA
+	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
+#ifdef CONFIG_HIGHMEM
+	[N_HIGH_MEMORY] = { { [0] = 1UL } },
+#endif
+	[N_CPU] = { { [0] = 1UL } },
+#endif	/* NUMA */
+};
+EXPORT_SYMBOL(node_states);
+
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 long nr_swap_pages;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
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
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
documentation-vm-slabinfoc-clean-up-this-code.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
ext3-support-large-blocksize-up-to-pagesize.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
