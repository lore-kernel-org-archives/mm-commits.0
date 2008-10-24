From: akpm@linux-foundation.org
Subject: - x86-use-common-header-for-software-io-tlb.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:31:09 -0700
Message-ID: <200810241931.m9OJV9GU031476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbYJXTcL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:32:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: use common header for software IO/TLB
has been removed from the -mm tree.  Its filename was
     x86-use-common-header-for-software-io-tlb.patch

This patch was dropped because of linux-next rejects

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: use common header for software IO/TLB
From: Joerg Roedel <joerg.roedel@amd.com>

Remove the swiotlb prototypes from the architecture code and use the
common header file instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/swiotlb.h |   40 ------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff -puN include/asm-x86/swiotlb.h~x86-use-common-header-for-software-io-tlb include/asm-x86/swiotlb.h
--- a/include/asm-x86/swiotlb.h~x86-use-common-header-for-software-io-tlb
+++ a/include/asm-x86/swiotlb.h
@@ -1,45 +1,7 @@
 #ifndef ASM_X86__SWIOTLB_H
 #define ASM_X86__SWIOTLB_H
 
-#include <asm/dma-mapping.h>
-
-/* SWIOTLB interface */
-
-extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
-extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags);
-extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
-extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					dma_addr_t dev_addr,
-					size_t size, int dir);
-extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					   dma_addr_t dev_addr,
-					   size_t size, int dir);
-extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
-					      dma_addr_t dev_addr,
-					      unsigned long offset,
-					      size_t size, int dir);
-extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
-						 dma_addr_t dev_addr,
-						 unsigned long offset,
-						 size_t size, int dir);
-extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				    struct scatterlist *sg, int nelems,
-				    int dir);
-extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-				       struct scatterlist *sg, int nelems,
-				       int dir);
-extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
-extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
-extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle);
-extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
-extern void swiotlb_init(void);
+#include <linux/swiotlb.h>
 
 extern int swiotlb_force;
 
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

linux-next.patch
x86-use-common-header-for-software-io-tlb.patch
ia64-use-common-header-for-software-io-tlb.patch

