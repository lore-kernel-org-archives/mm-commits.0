From: akpm@linux-foundation.org
Subject: + memoryless-nodes-introduce-mask-of-nodes-with-memory.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:38:13 -0700
Message-ID: <200708072038.l77KcDG5002806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbXHGUjE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, mel@skynet.ie, nacc@us.ibm.com


The patch titled
     Memoryless nodes: introduce mask of nodes with memory
has been added to the -mm tree.  Its filename is
     memoryless-nodes-introduce-mask-of-nodes-with-memory.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   10 ++++++++--
 mm/page_alloc.c          |   24 ++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

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
 
diff -puN mm/page_alloc.c~memoryless-nodes-introduce-mask-of-nodes-with-memory mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-introduce-mask-of-nodes-with-memory
+++ a/mm/page_alloc.c
@@ -2073,14 +2073,34 @@ static void build_zonelist_cache(pg_data
 
 #endif	/* CONFIG_NUMA */
 
+/* Any regular memory on that node ? */
+static void check_for_regular_memory(pg_data_t *pgdat)
+{
+#ifdef CONFIG_HIGHMEM
+	enum zone_type zone;
+
+	for (zone = 0; zone <= ZONE_NORMAL; zone++)
+		if (pgdat->node_zones[zone].present_pages)
+			node_set_state(nid, N_NORMAL_MEMORY);
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
