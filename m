From: akpm@linux-foundation.org
Subject: - memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:33:48 -0700
Message-ID: <200710162033.l9GKXmCd014845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966347AbXJPVuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless nodes: OOM: use N_HIGH_MEMORY map instead of constructing one on the fly
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Memoryless nodes: OOM: use N_HIGH_MEMORY map instead of constructing one on the fly
From: Christoph Lameter <clameter@sgi.com>

constrained_alloc() builds its own memory map for nodes with memory.  We have
that available in N_HIGH_MEMORY now.  So simplify the code.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN mm/oom_kill.c~memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly mm/oom_kill.c
--- a/mm/oom_kill.c~memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly
+++ a/mm/oom_kill.c
@@ -177,14 +177,7 @@ static inline int constrained_alloc(stru
 {
 #ifdef CONFIG_NUMA
 	struct zone **z;
-	nodemask_t nodes;
-	int node;
-
-	nodes_clear(nodes);
-	/* node has memory ? */
-	for_each_online_node(node)
-		if (NODE_DATA(node)->node_present_pages)
-			node_set(node, nodes);
+	nodemask_t nodes = node_states[N_HIGH_MEMORY];
 
 	for (z = zonelist->zones; *z; z++)
 		if (cpuset_zone_allowed_softwall(*z, gfp_mask))
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
