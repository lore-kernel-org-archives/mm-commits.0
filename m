From: akpm@linux-foundation.org
Subject: - memoryless-nodes-introduce-mask-of-nodes-with-memory.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:43 -0700
Message-ID: <200710162033.l9GKXhdi014819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933891AbXJPVyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, Lee.Schermerhorn@hp.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org, mel@skynet.ie, nacc@us.ibm.com, y-goto@jp.fujitsu.com, mm-commits@vger


The patch titled
     Memoryless nodes: introduce mask of nodes with memory
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-introduce-mask-of-nodes-with-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Memoryless nodes: introduce mask of nodes with memory
From: Christoph Lameter <clameter@sgi.com>

It is necessary to know if nodes have memory since we have recently begun to
add support for memoryless nodes.  For that purpose we introduce a two new
node states: N_HIGH_MEMORY and N_NORMAL_MEMORY.

A node has its bit in N_HIGH_MEMORY set if it has any memory regardless of the
type of mmemory.  If a node has memory then it has at least one zone defined
in its pgdat structure that is located in the pgdat itself.

A node has its bit in N_NORMAL_MEMORY set if it has a lower zone than
ZONE_HIGHMEM.  This means it is possible to allocate memory that is not
subject to kmap.

N_HIGH_MEMORY and N_NORMAL_MEMORY can then be used in various places to insure
that we do the right thing when we encounter a memoryless node.

[akpm@linux-foundation.org: build fix]
[Lee.Schermerhorn@hp.com: update N_HIGH_MEMORY node state for memory hotadd]
[y-goto@jp.fujitsu.com: Fix memory hotplug + sparsemem build]
Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   10 ++++++++--
 mm/memory_hotplug.c      |    7 ++++---
 mm/page_alloc.c          |   25 +++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 7 deletions(-)

diff -puN include/linux/nodemask.h~memoryless-nodes-introduce-mask-of-nodes-with-memory include/linux/nodemask.h
--- a/include/linux/nodemask.h~memoryless-nodes-introduce-mask-of-nodes-with-memory
+++ a/include/linux/nodemask.h
@@ -341,8 +341,14 @@ static inline void __nodes_remap(nodemas
  * Bitmasks that are kept for all the nodes.
  */
 enum node_states {
-	N_POSSIBLE,	/* The node could become online at some point */
-	N_ONLINE,	/* The node is online */
+	N_POSSIBLE,		/* The node could become online at some point */
+	N_ONLINE,		/* The node is online */
+	N_NORMAL_MEMORY,	/* The node has regular memory */
+#ifdef CONFIG_HIGHMEM
+	N_HIGH_MEMORY,		/* The node has regular or high memory */
+#else
+	N_HIGH_MEMORY = N_NORMAL_MEMORY,
+#endif
 	NR_NODE_STATES
 };
 
diff -puN mm/memory_hotplug.c~memoryless-nodes-introduce-mask-of-nodes-with-memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memoryless-nodes-introduce-mask-of-nodes-with-memory
+++ a/mm/memory_hotplug.c
@@ -217,6 +217,10 @@ int online_pages(unsigned long pfn, unsi
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
 	setup_per_zone_pages_min();
+	if (onlined_pages) {
+		kswapd_run(zone_to_nid(zone));
+		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
+	}
 
 	if (need_zonelists_rebuild)
 		build_all_zonelists();
@@ -271,9 +275,6 @@ int add_memory(int nid, u64 start, u64 s
 		if (!pgdat)
 			return -ENOMEM;
 		new_pgdat = 1;
-		ret = kswapd_run(nid);
-		if (ret)
-			goto error;
 	}
 
 	/* call arch's memory hotadd */
diff -puN mm/page_alloc.c~memoryless-nodes-introduce-mask-of-nodes-with-memory mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-introduce-mask-of-nodes-with-memory
+++ a/mm/page_alloc.c
@@ -2080,14 +2080,35 @@ static void build_zonelist_cache(pg_data
 
 #endif	/* CONFIG_NUMA */
 
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
 /* return values int ....just for stop_machine_run() */
 static int __build_all_zonelists(void *dummy)
 {
 	int nid;
 
 	for_each_online_node(nid) {
-		build_zonelists(NODE_DATA(nid));
-		build_zonelist_cache(NODE_DATA(nid));
+		pg_data_t *pgdat = NODE_DATA(nid);
+
+		build_zonelists(pgdat);
+		build_zonelist_cache(pgdat);
+
+		/* Any memory on that node */
+		if (pgdat->node_present_pages)
+			node_set_state(nid, N_HIGH_MEMORY);
+		check_for_regular_memory(pgdat);
 	}
 	return 0;
 }
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
