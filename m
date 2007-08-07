From: akpm@linux-foundation.org
Subject: + memoryless-nodes-add-n_cpu-node-state.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:38:31 -0700
Message-ID: <200708072038.l77KcVDX002837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937AbXHGUjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:39:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com


The patch titled
     Memoryless nodes: Add N_CPU node state
has been added to the -mm tree.  Its filename is
     memoryless-nodes-add-n_cpu-node-state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Memoryless nodes: Add N_CPU node state
From: Christoph Lameter <clameter@sgi.com>

We need the check for a node with cpu in zone reclaim.  Zone reclaim will not
allow remote zone reclaim if a node has a cpu.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    1 +
 mm/page_alloc.c          |    4 +++-
 mm/vmscan.c              |    4 +---
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN include/linux/nodemask.h~memoryless-nodes-add-n_cpu-node-state include/linux/nodemask.h
--- a/include/linux/nodemask.h~memoryless-nodes-add-n_cpu-node-state
+++ a/include/linux/nodemask.h
@@ -349,6 +349,7 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
+	N_CPU,		/* The node has one or more cpus */
 	NR_NODE_STATES
 };
 
diff -puN mm/page_alloc.c~memoryless-nodes-add-n_cpu-node-state mm/page_alloc.c
--- a/mm/page_alloc.c~memoryless-nodes-add-n_cpu-node-state
+++ a/mm/page_alloc.c
@@ -2345,6 +2345,7 @@ static struct per_cpu_pageset boot_pages
 static int __cpuinit process_zones(int cpu)
 {
 	struct zone *zone, *dzone;
+	int node = cpu_to_node(cpu);
 
 	for_each_zone(zone) {
 
@@ -2352,7 +2353,7 @@ static int __cpuinit process_zones(int c
 			continue;
 
 		zone_pcp(zone, cpu) = kmalloc_node(sizeof(struct per_cpu_pageset),
-					 GFP_KERNEL, cpu_to_node(cpu));
+					 GFP_KERNEL, node);
 		if (!zone_pcp(zone, cpu))
 			goto bad;
 
@@ -2363,6 +2364,7 @@ static int __cpuinit process_zones(int c
 			 	(zone->present_pages / percpu_pagelist_fraction));
 	}
 
+	node_set_state(node, N_CPU);
 	return 0;
 bad:
 	for_each_zone(dzone) {
diff -puN mm/vmscan.c~memoryless-nodes-add-n_cpu-node-state mm/vmscan.c
--- a/mm/vmscan.c~memoryless-nodes-add-n_cpu-node-state
+++ a/mm/vmscan.c
@@ -1842,7 +1842,6 @@ static int __zone_reclaim(struct zone *z
 
 int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 {
-	cpumask_t mask;
 	int node_id;
 
 	/*
@@ -1879,8 +1878,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	 * as wide as possible.
 	 */
 	node_id = zone_to_nid(zone);
-	mask = node_to_cpumask(node_id);
-	if (!cpus_empty(mask) && node_id != numa_node_id())
+	if (node_state(node_id, N_CPU) && node_id != numa_node_id())
 		return 0;
 	return __zone_reclaim(zone, gfp_mask, order);
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
