From: akpm@linux-foundation.org
Subject: - add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:36 -0700
Message-ID: <200707172301.l6HN1aq4011416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936586AbXGQXQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     Add VM_BUG_ON in case someone uses page_mapping on a slab page
has been removed from the -mm tree.  Its filename was
     add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add VM_BUG_ON in case someone uses page_mapping on a slab page
From: Christoph Lameter <clameter@sgi.com>

Detect slab objects being passed to the page oriented functions of the VM.

It is not sufficient to simply return NULL because the functions calling
page_mapping may depend on other items of the page_struct also to be setup
properly.  Moreover slab object may not be properly aligned.  The page
oriented functions of the VM expect to operate on page aligned, page sized
objects.  Operations on object straddling page boundaries may only affect the
objects partially which may lead to surprising results.

It is better to detect eventually remaining uses and eliminate them.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/mm.h~add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page include/linux/mm.h
--- a/include/linux/mm.h~add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page
+++ a/include/linux/mm.h
@@ -599,6 +599,7 @@ static inline struct address_space *page
 {
 	struct address_space *mapping = page->mapping;
 
+	VM_BUG_ON(PageSlab(page));
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
 #ifdef CONFIG_SLUB
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
