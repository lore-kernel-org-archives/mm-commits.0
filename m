From: akpm@linux-foundation.org
Subject: + swiotlb-remove-unnecessary-swiotlb_sync_single_range_.patch added to -mm tree
Date: Tue, 27 Apr 2010 15:27:05 -0700
Message-ID: <201004272227.o3RMR5lO023860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477Ab0D0W1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 18:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp


The patch titled
     swiotlb: remove unnecessary swiotlb_sync_single_range_*
has been added to the -mm tree.  Its filename is
     swiotlb-remove-unnecessary-swiotlb_sync_single_range_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swiotlb: remove unnecessary swiotlb_sync_single_range_*
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

swiotlb_sync_single_range_for_cpu and swiotlb_sync_single_range_for_device
are unnecessary because swiotlb_sync_single_for_cpu and
swiotlb_sync_single_for_device can be used instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swiotlb.h |   10 ----------
 lib/swiotlb.c           |   31 -------------------------------
 2 files changed, 41 deletions(-)

diff -puN include/linux/swiotlb.h~swiotlb-remove-unnecessary-swiotlb_sync_single_range_ include/linux/swiotlb.h
--- a/include/linux/swiotlb.h~swiotlb-remove-unnecessary-swiotlb_sync_single_range_
+++ a/include/linux/swiotlb.h
@@ -73,16 +73,6 @@ extern void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 			   int nelems, enum dma_data_direction dir);
 
-extern void
-swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size,
-				  enum dma_data_direction dir);
-
-extern void
-swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
-				     unsigned long offset, size_t size,
-				     enum dma_data_direction dir);
-
 extern int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 
diff -puN lib/swiotlb.c~swiotlb-remove-unnecessary-swiotlb_sync_single_range_ lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-remove-unnecessary-swiotlb_sync_single_range_
+++ a/lib/swiotlb.c
@@ -757,37 +757,6 @@ swiotlb_sync_single_for_device(struct de
 EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 
 /*
- * Same as above, but for a sub-range of the mapping.
- */
-static void
-swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
-			  unsigned long offset, size_t size,
-			  int dir, int target)
-{
-	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
-}
-
-void
-swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
-				  unsigned long offset, size_t size,
-				  enum dma_data_direction dir)
-{
-	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
-				  SYNC_FOR_CPU);
-}
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
-
-void
-swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
-				     unsigned long offset, size_t size,
-				     enum dma_data_direction dir)
-{
-	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
-				  SYNC_FOR_DEVICE);
-}
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
-
-/*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_page
  * interface.  Here the scatter gather list elements are each tagged with the
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
dma-mapping-fix-dma_sync_single_range_.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ia64-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
x86-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
powerpc-remove-unnecessary-sync_single_range_-in-swiotlb_dma_ops.patch
swiotlb-remove-unnecessary-swiotlb_sync_single_range_.patch
dma-mapping-remove-unnecessary-sync_single_range_-in-dma_map_ops.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch
asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch
asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch
x86_32-use-asm-generic-scatterlisth.patch
powerpc-use-asm-generic-scatterlisth.patch
arm-use-asm-generic-scatterlisth.patch
alpha-use-asm-generic-scatterlisth.patch
asm-generic-remove-arch_has_sg_chain-in-scatterlisth.patch
avr32-use-asm-generic-scatterlisth.patch
cris-use-asm-generic-scatterlisth.patch
h8300-use-asm-generic-scatterlisth.patch
m32r-use-use-asm-generic-scatterlisth.patch
m68k-use-asm-generic-scatterlisth.patch
mips-use-use-asm-generic-scatterlisth.patch
xtensa-use-use-asm-generic-scatterlisth.patch
blackfin-use-use-asm-generic-scatterlisth.patch
frv-use-asm-generic-scatterlisth.patch
mn10300-use-asm-generic-scatterlisth.patch
parisc-use-asm-generic-scatterlisth.patch

