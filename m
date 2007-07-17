From: akpm@linux-foundation.org
Subject: - slub-do-proper-locking-during-dma-slab-creation.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:14 -0700
Message-ID: <200707172301.l6HN1EDO011370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936424AbXGQXPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: do proper locking during dma slab creation
has been removed from the -mm tree.  Its filename was
     slub-do-proper-locking-during-dma-slab-creation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: do proper locking during dma slab creation
From: Christoph Lameter <clameter@sgi.com>

We modify the kmalloc_cache_dma[] array without proper locking.  Do the proper
locking and undo the dma cache creation if another processor has already
created it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-do-proper-locking-during-dma-slab-creation mm/slub.c
--- a/mm/slub.c~slub-do-proper-locking-during-dma-slab-creation
+++ a/mm/slub.c
@@ -2301,8 +2301,15 @@ static noinline struct kmem_cache *dma_k
 	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
 			(unsigned int)realsize);
 	s = create_kmalloc_cache(x, text, realsize, flags);
-	kmalloc_caches_dma[index] = s;
-	return s;
+	down_write(&slub_lock);
+	if (!kmalloc_caches_dma[index]) {
+		kmalloc_caches_dma[index] = s;
+		up_write(&slub_lock);
+		return s;
+	}
+	up_write(&slub_lock);
+	kmem_cache_destroy(s);
+	return kmalloc_caches_dma[index];
 }
 #endif
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
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
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
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
