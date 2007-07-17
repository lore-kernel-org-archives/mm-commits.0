From: akpm@linux-foundation.org
Subject: - slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:01 -0700
Message-ID: <200707172301.l6HN112x011341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46537 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936146AbXGQXB2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB Debug: fix initial object debug state of NUMA bootstrap objects
has been removed from the -mm tree.  Its filename was
     slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB Debug: fix initial object debug state of NUMA bootstrap objects
From: Christoph Lameter <clameter@sgi.com>

The function we are calling to initialize object debug state during early NUMA
bootstrap sets up an inactive object giving it the wrong redzone signature. 
The bootstrap nodes are active objects and should have active redzone
signatures.

Currently slab validation complains and reverts the object to active state.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects mm/slub.c
--- a/mm/slub.c~slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects
+++ a/mm/slub.c
@@ -1876,7 +1876,8 @@ static struct kmem_cache_node * __init e
 	page->freelist = get_freepointer(kmalloc_caches, n);
 	page->inuse++;
 	kmalloc_caches->node[node] = n;
-	setup_object_debug(kmalloc_caches, page, n);
+	init_object(kmalloc_caches, n, 1);
+	init_tracking(kmalloc_caches, n);
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
 	add_partial(n, page);
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
