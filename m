From: akpm@linux-foundation.org
Subject: + slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch added to -mm tree
Date: Mon, 20 Aug 2007 12:49:12 -0700
Message-ID: <200708201949.l7KJnCe5019841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907AbXHTTuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mpm@selenic.com, penberg@cs.helsinki.fi


The patch titled
     Slab allocators: fail if ksize is called with a NULL parameter
has been added to the -mm tree.  Its filename is
     slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Slab allocators: fail if ksize is called with a NULL parameter
From: Christoph Lameter <clameter@sgi.com>

A NULL pointer means that the object was not allocated.  One cannot
determine the size of an object that has not been allocated.  Currently we
return 0 but we really should BUG() on attempts to determine the size of
something nonexistent.

krealloc() interprets NULL to mean a zero sized object.  Handle that
separately in krealloc().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 ++-
 mm/slob.c |    3 ++-
 mm/slub.c |    3 ++-
 mm/util.c |    6 ++++--
 4 files changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/slab.c
--- a/mm/slab.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/slab.c
@@ -4446,7 +4446,8 @@ const struct seq_operations slabstats_op
  */
 size_t ksize(const void *objp)
 {
-	if (unlikely(ZERO_OR_NULL_PTR(objp)))
+	BUG_ON(!objp);
+	if (unlikely(objp == ZERO_SIZE_PTR))
 		return 0;
 
 	return obj_size(virt_to_cache(objp));
diff -puN mm/slob.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/slob.c
--- a/mm/slob.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/slob.c
@@ -484,7 +484,8 @@ size_t ksize(const void *block)
 {
 	struct slob_page *sp;
 
-	if (unlikely(ZERO_OR_NULL_PTR(block)))
+	BUG_ON(!block);
+	if (unlikely(block == ZERO_SIZE_PTR))
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff -puN mm/slub.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/slub.c
--- a/mm/slub.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/slub.c
@@ -2441,7 +2441,8 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (unlikely(ZERO_OR_NULL_PTR(object)))
+	BUG_ON(!object);
+	if (unlikely(object == ZERO_SIZE_PTR))
 		return 0;
 
 	page = get_object_page(object);
diff -puN mm/util.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter mm/util.c
--- a/mm/util.c~slab-allocators-fail-if-ksize-is-called-with-a-null-parameter
+++ a/mm/util.c
@@ -81,14 +81,16 @@ EXPORT_SYMBOL(kmemdup);
 void *krealloc(const void *p, size_t new_size, gfp_t flags)
 {
 	void *ret;
-	size_t ks;
+	size_t ks = 0;
 
 	if (unlikely(!new_size)) {
 		kfree(p);
 		return ZERO_SIZE_PTR;
 	}
 
-	ks = ksize(p);
+	if (p)
+		ks = ksize(p);
+
 	if (ks >= new_size)
 		return (void *)p;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
document-linux-memory-policy-v3.patch
slab-skip-calling-cache_free_alien-when-the-platform-is-not-numa-capable.patch
slub-use-atomic_long_read-for-atomic_long-variables.patch
slub-do-not-fail-on-broken-memory-configurations.patch
apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
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
