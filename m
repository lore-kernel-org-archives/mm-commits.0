From: akpm@linux-foundation.org
Subject: - memoryless-nodes-update-memory-policy-and-page-migration.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:00 -0700
Message-ID: <200710162034.l9GKY055014878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933734AbXJPVwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Memoryless nodes: Update memory policy and page migration
has been removed from the -mm tree.  Its filename was
     memoryless-nodes-update-memory-policy-and-page-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Memoryless nodes: Update memory policy and page migration
From: Christoph Lameter <clameter@sgi.com>

Online nodes now may have no memory.  The checks and initialization must
therefore be changed to no longer use the online functions.

This will correctly initialize the interleave on bootup to only target nodes
with memory and will make sys_move_pages return an error when a page is to be
moved to a memoryless node.  Similarly we will get an error if MPOL_BIND and
MPOL_INTERLEAVE is used on a memoryless node.

These are somewhat new semantics.  So far one could specify memoryless nodes
and we would maybe do the right thing and just ignore the node (or we'd do
something strange like with MPOL_INTERLEAVE).  If we want to allow the
specification of memoryless nodes via memory policies then we need to keep
checking for online nodes.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Tested-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Bob Picco <bob.picco@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   10 +++++-----
 mm/migrate.c   |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/mempolicy.c~memoryless-nodes-update-memory-policy-and-page-migration mm/mempolicy.c
--- a/mm/mempolicy.c~memoryless-nodes-update-memory-policy-and-page-migration
+++ a/mm/mempolicy.c
@@ -494,9 +494,9 @@ static void get_zonemask(struct mempolic
 		*nodes = p->v.nodes;
 		break;
 	case MPOL_PREFERRED:
-		/* or use current node instead of online map? */
+		/* or use current node instead of memory_map? */
 		if (p->v.preferred_node < 0)
-			*nodes = node_online_map;
+			*nodes = node_states[N_HIGH_MEMORY];
 		else
 			node_set(p->v.preferred_node, *nodes);
 		break;
@@ -1687,7 +1687,7 @@ void __init numa_policy_init(void)
 	 * fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_HIGH_MEMORY) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -1973,7 +1973,7 @@ int show_numa_map(struct seq_file *m, vo
 		seq_printf(m, " huge");
 	} else {
 		check_pgd_range(vma, vma->vm_start, vma->vm_end,
-				&node_online_map, MPOL_MF_STATS, md);
+			&node_states[N_HIGH_MEMORY], MPOL_MF_STATS, md);
 	}
 
 	if (!md->pages)
@@ -2000,7 +2000,7 @@ int show_numa_map(struct seq_file *m, vo
 	if (md->writeback)
 		seq_printf(m," writeback=%lu", md->writeback);
 
-	for_each_online_node(n)
+	for_each_node_state(n, N_HIGH_MEMORY)
 		if (md->node[n])
 			seq_printf(m, " N%d=%lu", n, md->node[n]);
 out:
diff -puN mm/migrate.c~memoryless-nodes-update-memory-policy-and-page-migration mm/migrate.c
--- a/mm/migrate.c~memoryless-nodes-update-memory-policy-and-page-migration
+++ a/mm/migrate.c
@@ -986,7 +986,7 @@ asmlinkage long sys_move_pages(pid_t pid
 				goto out;
 
 			err = -ENODEV;
-			if (!node_online(node))
+			if (!node_state(node, N_HIGH_MEMORY))
 				goto out;
 
 			err = -EACCES;
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
