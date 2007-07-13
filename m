From: akpm@linux-foundation.org
Subject: - slub-mm-only-make-slub-the-default-slab-allocator.patch removed from -mm tree
Date: Fri, 13 Jul 2007 00:56:18 -0700
Message-ID: <200707130756.l6D7uIir006585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277AbXGMH40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 03:56:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: mm-only: Make SLUB the default slab allocator
has been removed from the -mm tree.  Its filename was
     slub-mm-only-make-slub-the-default-slab-allocator.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: SLUB: mm-only: Make SLUB the default slab allocator
From: Christoph Lameter <clameter@sgi.com>

Make SLUB the default slab allocator

WARNING: This is a new allocator. No guarantees.

Known areas of concern:

A. i386 and FRV arches have been disabled by setting
   ARCH_USES_SLAB_PAGE_STRUCT. SLUB cannot be enabled on those platforms.

   The issue is that both arches use the page->index and page->private field
   of memory allocated via the slab. SLUB uses these fields too. There are
   a variety of patches out there (some by me, some by Bill Irwin) to address
   this but without those you may be stuck until Bill Irwin comes up with a
   definite solution.

B. There may be undiscovered locations in arch code that are as badly
   behaved as i386 and FRV which will likely cause the arch not to boot
   and fail with mysterious error messages.

C. Unlike SLAB, SLUB does not special case page sized allocations. SLAB
   aligns kmallocs of page sized allocation on page boundaries.
   SLUB also does that most of the time but does not guarantee alignment
   beyond KMALLOC_ARCH_MINALIGN that is valid for other kmalloc slabs.
   In particular enabling debugging will add some tracking information
   to slabs which will usually cause page sized slabs to become no longer
   aligned on page boundaries.

   If there is arch code that relies on this behavior then we are likely
   to see funky behavior. Code that uses page sized allocations via kmalloc
   should either use the page allocator or explictly request page aligned
   data from the slab by creating a custom slab with the needed alignment.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~slub-mm-only-make-slub-the-default-slab-allocator init/Kconfig
--- a/init/Kconfig~slub-mm-only-make-slub-the-default-slab-allocator
+++ a/init/Kconfig
@@ -554,7 +554,7 @@ config SLUB_DEBUG
 
 choice
 	prompt "Choose SLAB allocator"
-	default SLAB
+	default SLUB
 	help
 	   This option allows to select a slab allocator.
 
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
slub-mm-only-make-slub-the-default-slab-allocator.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
slub-simplify-dma-index-size-calculation.patch
mm-slubc-make-code-static.patch
slub-style-fix-up-the-loop-to-disable-small-slabs.patch
slub-do-not-use-length-parameter-in-slab_alloc.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-do-not-allocate-object-bit-array-on-stack.patch
slub-move-sysfs-operations-outside-of-slub_lock.patch
slub-fix-config_slub_debug-use-for-config_numa.patch
make-slub-the-default-allocator.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
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
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
page-owner-tracking-leak-detector.patch
