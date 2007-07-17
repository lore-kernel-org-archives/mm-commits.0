From: akpm@linux-foundation.org
Subject: - define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:50 -0700
Message-ID: <200707172301.l6HN1oMk011431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934519AbXGQXQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic
has been removed from the -mm tree.  Its filename was
     define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic
From: Christoph Lameter <clameter@sgi.com>

The bounce buffer logic is included on systems that do not need it.  If a
system does not have zones like ZONE_DMA and ZONE_HIGHMEM that can lead to
the use of bounce buffers then there is no need to reserve memory pools etc
etc.  This is true f.e.  for SGI Altix.

Also nicifies the Makefile and gets rid of the tricky "and" there.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    2 +-
 mm/Kconfig             |    4 ++++
 mm/Makefile            |    4 +---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/blkdev.h~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer include/linux/blkdev.h
--- a/include/linux/blkdev.h~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer
+++ a/include/linux/blkdev.h
@@ -624,7 +624,7 @@ extern unsigned long blk_max_low_pfn, bl
  */
 #define BLK_DEFAULT_SG_TIMEOUT	(60 * HZ)
 
-#ifdef CONFIG_MMU
+#ifdef CONFIG_BOUNCE
 extern int init_emergency_isa_pool(void);
 extern void blk_queue_bounce(request_queue_t *q, struct bio **bio);
 #else
diff -puN mm/Kconfig~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer mm/Kconfig
--- a/mm/Kconfig~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer
+++ a/mm/Kconfig
@@ -163,6 +163,10 @@ config ZONE_DMA_FLAG
 	default "0" if !ZONE_DMA
 	default "1"
 
+config BOUNCE
+	def_bool y
+	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
+
 config NR_QUICK
 	int
 	depends on QUICKLIST
diff -puN mm/Makefile~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer mm/Makefile
--- a/mm/Makefile~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer
+++ a/mm/Makefile
@@ -13,9 +13,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   $(mmu-y)
 
-ifeq ($(CONFIG_MMU)$(CONFIG_BLOCK),yy)
-obj-y			+= bounce.o
-endif
+obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
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
