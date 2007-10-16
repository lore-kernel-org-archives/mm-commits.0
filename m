From: akpm@linux-foundation.org
Subject: - memoryless-nodes-add-n_cpu-node-state.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:01 -0700
Message-ID: <200710162034.l9GKY1nl014881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965528AbXJPV4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless nodes: Add N_CPU node state
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-add-n_cpu-node-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Memoryless nodes: Add N_CPU node state
From: Christoph Lameter <clameter@sgi.com>

We need the check for a node with cpu in zone reclaim.  Zone reclaim will not
allow remote zone reclaim if a node has a cpu.

[Lee.Schermerhorn@hp.com: Move setup of N_CPU node state mask]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    1 +
 mm/page_alloc.c          |    5 ++++-
 mm/vmscan.c              |    4 +---
 3 files changed, 6 insertions(+), 4 deletions(-)

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
@@ -2353,6 +2353,9 @@ static struct per_cpu_pageset boot_pages
 static int __cpuinit process_zones(int cpu)
 {
 	struct zone *zone, *dzone;
+	int node = cpu_to_node(cpu);
+
+	node_set_state(node, N_CPU);	/* this node has a cpu */
 
 	for_each_zone(zone) {
 
@@ -2360,7 +2363,7 @@ static int __cpuinit process_zones(int c
 			continue;
 
 		zone_pcp(zone, cpu) = kmalloc_node(sizeof(struct per_cpu_pageset),
-					 GFP_KERNEL, cpu_to_node(cpu));
+					 GFP_KERNEL, node);
 		if (!zone_pcp(zone, cpu))
 			goto bad;
 
diff -puN mm/vmscan.c~memoryless-nodes-add-n_cpu-node-state mm/vmscan.c
--- a/mm/vmscan.c~memoryless-nodes-add-n_cpu-node-state
+++ a/mm/vmscan.c
@@ -1853,7 +1853,6 @@ static int __zone_reclaim(struct zone *z
 
 int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 {
-	cpumask_t mask;
 	int node_id;
 
 	/*
@@ -1890,8 +1889,7 @@ int zone_reclaim(struct zone *zone, gfp_
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
