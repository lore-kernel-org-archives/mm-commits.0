From: akpm@linux-foundation.org
Subject: + define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch added to -mm tree
Date: Mon, 21 May 2007 21:15:22 -0700
Message-ID: <200705220415.l4M4FMR4027125@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbXEVERt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 00:17:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, jens.axboe@oracle.com


The patch titled
     CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic
has been added to the -mm tree.  Its filename is
     define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic
From: Christoph Lameter <clameter@sgi.com>

The bounce buffer logic is included on systems that do not need it.  If a
system does not have zones like ZONE_DMA and ZONE_HIGHMEM that can lead to
the use of bounce buffers then there is no need to reserve memory pools etc
etc.  This is true f.e.  for SGI Altix.

Also nicifies the Makefile and gets rid of the tricky "and" there.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    2 +-
 mm/Kconfig             |    4 ++++
 mm/Makefile            |    4 +---
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/blkdev.h~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer include/linux/blkdev.h
--- a/include/linux/blkdev.h~define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer
+++ a/include/linux/blkdev.h
@@ -607,7 +607,7 @@ extern unsigned long blk_max_low_pfn, bl
 #define BLK_BOUNCE_ANY		((u64)blk_max_pfn << PAGE_SHIFT)
 #define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)
 
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

slub-debug-fix-object-size-calculation.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slub-debug-fix-check-for-super-sized-slabs-512k-64bit-256k.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-use-ilog2-instead-of-series-of-constant-comparisons.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
