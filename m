From: akpm@linux-foundation.org
Subject: - slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:34:10 -0700
Message-ID: <200710160434.l9G4YA5A008978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbXJPEet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:34:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab fix
has been removed from the -mm tree.  Its filename was
     slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch

This patch was dropped because it was folded into slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch

------------------------------------------------------
Subject: slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab fix
From: Christoph Lameter <clameter@sgi.com>

SLUB: Fix slab object counting.

We can only use the node value of the per cpu structure for counting if it
is positive. A negative value indicates that the slab is not valid.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix mm/slub.c
--- a/mm/slub.c~slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix
+++ a/mm/slub.c
@@ -3250,12 +3250,16 @@ static unsigned long slab_objects(struct
 
 	for_each_possible_cpu(cpu) {
 		struct page *page;
+		int node;
 		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 
 		if (!c)
 			continue;
 
 		page = c->page;
+		node = c->node;
+		if (node < 0)
+			continue;
 		if (page) {
 			if (flags & SO_CPU) {
 				int x = 0;
@@ -3265,9 +3269,9 @@ static unsigned long slab_objects(struct
 				else
 					x = 1;
 				total += x;
-				nodes[c->node] += x;
+				nodes[node] += x;
 			}
-			per_cpu[c->node]++;
+			per_cpu[node]++;
 		}
 	}
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
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
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
categorize-gfp-flags.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
slub-do-not-use-page-mapping.patch
slub-move-page-offset-to-kmem_cache_cpu-offset.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab-fix.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way-fix.patch
slub-optimize-cacheline-use-for-zeroing.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
hugetlb-fix-hugepage-allocation-with-memoryless-nodes.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
add-node-states-sysfs-class-attributes-v5.patch
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
