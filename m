From: akpm@linux-foundation.org
Subject: - slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:12:47 -0700
Message-ID: <200707092112.l69LClWW012068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53717 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647AbXGIVMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:12:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: use antifrag constant instead of hardcoding page order
has been removed from the -mm tree.  Its filename was
     slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch

This patch was dropped because it was folded into slub-reduce-antifrag-max-order.patch

------------------------------------------------------
Subject: SLUB: use antifrag constant instead of hardcoding page order
From: Christoph Lameter <clameter@sgi.com>

Andy suggested this change.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order mm/slub.c
--- a/mm/slub.c~slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order
+++ a/mm/slub.c
@@ -176,7 +176,7 @@ static inline void ClearSlabDebug(struct
  * If antifragmentation methods are in effect then increase the
  * slab sizes to increase performance
  */
-#define DEFAULT_ANTIFRAG_MAX_ORDER 3
+#define DEFAULT_ANTIFRAG_MAX_ORDER PAGE_ALLOC_COSTLY_ORDER
 #define DEFAULT_ANTIFRAG_MIN_OBJECTS 16
 
 /*
_

Patches currently in -mm which might be from clameter@sgi.com are

git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
change-zonelist-order-zonelist-order-selection-logic.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-support-slub_debug-on-by-default.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
numa-mempolicy-trivial-debug-fixes.patch
slob-initial-numa-support.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slab-allocators-support-__gfp_zero-in-all-allocators-fix.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix-2.patch
slub-simplify-dma-index-size-calculation.patch
mm-slubc-make-code-static.patch
slub-style-fix-up-the-loop-to-disable-small-slabs.patch
slub-do-not-use-length-parameter-in-slab_alloc.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-do-not-allocate-object-bit-array-on-stack.patch
slub-move-sysfs-operations-outside-of-slub_lock.patch
slub-fix-config_slub_debug-use-for-config_numa.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
revoke-core-code.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
