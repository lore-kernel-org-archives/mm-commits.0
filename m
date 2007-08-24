From: akpm@linux-foundation.org
Subject: - slub-limit-the-maximum-size-of-merged-slab-caches.patch removed from -mm tree
Date: Fri, 24 Aug 2007 11:04:56 -0700
Message-ID: <200708241804.l7OI4u4T007741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933361AbXHXSKA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 14:10:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     slub: limit the maximum size of merged slab caches
has been removed from the -mm tree.  Its filename was
     slub-limit-the-maximum-size-of-merged-slab-caches.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: slub: limit the maximum size of merged slab caches
From: Christoph Lameter <clameter@sgi.com>

We always switch off the debugging bits of slabs that are too large for
free pointer relocationi (256k, 512k).  This means that we may create
kmem_cache structures that look as if they are satisfying the requirements
for merging even if slub_debug is set.  Sysfs handling may think they are
mergeable and thus creates unique ids that may then clash.

[Patches in the works are soon going to make that limit obsolete]

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-limit-the-maximum-size-of-merged-slab-caches mm/slub.c
--- a/mm/slub.c~slub-limit-the-maximum-size-of-merged-slab-caches
+++ a/mm/slub.c
@@ -209,6 +209,7 @@ static inline void ClearSlabDebug(struct
  * The page->inuse field is 16 bit thus we have this limitation
  */
 #define MAX_OBJECTS_PER_SLAB 65535
+#define MAX_MERGE_SIZE (MAX_OBJECTS_PER_SLAB * sizeof(void))
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
@@ -1000,7 +1001,7 @@ static void kmem_cache_open_debug_check(
 	 * Debugging or ctor may create a need to move the free
 	 * pointer. Fail if this happens.
 	 */
-	if (s->objsize >= 65535 * sizeof(void *)) {
+	if (s->objsize >= MAX_MERGE_SIZE) {
 		BUG_ON(s->flags & (SLAB_RED_ZONE | SLAB_POISON |
 				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
 		BUG_ON(s->ctor);
@@ -2656,6 +2657,12 @@ static int slab_unmergeable(struct kmem_
 	if (s->refcount < 0)
 		return 1;
 
+	/*
+	 * Or a slab that is too large for merging
+	 */
+	if (s->size >= MAX_MERGE_SIZE)
+		return 1;
+
 	return 0;
 }
 
@@ -2675,6 +2682,9 @@ static struct kmem_cache *find_mergeable
 	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
 
+	if (size >= MAX_MERGE_SIZE)
+		return NULL;
+
 	list_for_each_entry(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
document-linux-memory-policy-v3.patch
slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable.patch
slub-use-atomic_long_read-for-atomic_long-variables.patch
slub-do-not-fail-on-broken-memory-configurations.patch
process_zones-fix-recovery-code.patch
fix-rcu_read_lock-in-page-migraton.patch
do-not-fail-if-we-cannot-register-a-slab-with-sysfs.patch
slub-limit-the-maximum-size-of-merged-slab-caches.patch
slub-limit-the-maximum-size-of-merged-slab-caches-fix.patch
page-migration-do-not-accept-invalid-nodes-in-the-target-nodeset.patch
apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
infiniband-work-around-gcc-slub-problem.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
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
categorize-gfp-flags-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
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
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
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
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
