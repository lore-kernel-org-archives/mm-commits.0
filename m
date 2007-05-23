From: akpm@linux-foundation.org
Subject: - round_up-macro-cleanup-in-drivers-parisc.patch removed from -mm tree
Date: Wed, 23 May 2007 13:21:06 -0700
Message-ID: <200705232021.l4NKL5ug031006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757101AbXEWUWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, grundler@parisc-linux.org, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     ROUNDUP macro cleanup in drivers/parisc
has been removed from the -mm tree.  Its filename was
     round_up-macro-cleanup-in-drivers-parisc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ROUNDUP macro cleanup in drivers/parisc
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

Clean up ROUNDUP, Use ALIGN where ever appropriate.

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c      |    8 ++++----
 drivers/parisc/iommu-helpers.h |    4 ++--
 drivers/parisc/sba_iommu.c     |    6 ++----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~round_up-macro-cleanup-in-drivers-parisc drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~round_up-macro-cleanup-in-drivers-parisc
+++ a/drivers/parisc/ccio-dma.c
@@ -32,6 +32,7 @@
 */
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/spinlock.h>
@@ -292,7 +293,6 @@ static int ioc_count;
 #define PDIR_INDEX(iovp)    ((iovp)>>IOVP_SHIFT)
 #define MKIOVP(pdir_idx)    ((long)(pdir_idx) << IOVP_SHIFT)
 #define MKIOVA(iovp,offset) (dma_addr_t)((long)iovp | (long)offset)
-#define ROUNDUP(x,y) ((x + ((y)-1)) & ~((y)-1))
 
 /*
 ** Don't worry about the 150% average search length on a miss.
@@ -668,7 +668,7 @@ ccio_mark_invalid(struct ioc *ioc, dma_a
 	size_t saved_byte_cnt;
 
 	/* round up to nearest page size */
-	saved_byte_cnt = byte_cnt = ROUNDUP(byte_cnt, IOVP_SIZE);
+	saved_byte_cnt = byte_cnt = ALIGN(byte_cnt, IOVP_SIZE);
 
 	while(byte_cnt > 0) {
 		/* invalidate one page at a time */
@@ -751,7 +751,7 @@ ccio_map_single(struct device *dev, void
 	offset = ((unsigned long) addr) & ~IOVP_MASK;
 
 	/* round up to nearest IOVP_SIZE */
-	size = ROUNDUP(size + offset, IOVP_SIZE);
+	size = ALIGN(size + offset, IOVP_SIZE);
 	spin_lock_irqsave(&ioc->res_lock, flags);
 
 #ifdef CCIO_MAP_STATS
@@ -814,7 +814,7 @@ ccio_unmap_single(struct device *dev, dm
 
 	iova ^= offset;        /* clear offset bits */
 	size += offset;
-	size = ROUNDUP(size, IOVP_SIZE);
+	size = ALIGN(size, IOVP_SIZE);
 
 	spin_lock_irqsave(&ioc->res_lock, flags);
 
diff -puN drivers/parisc/iommu-helpers.h~round_up-macro-cleanup-in-drivers-parisc drivers/parisc/iommu-helpers.h
--- a/drivers/parisc/iommu-helpers.h~round_up-macro-cleanup-in-drivers-parisc
+++ a/drivers/parisc/iommu-helpers.h
@@ -138,7 +138,7 @@ iommu_coalesce_chunks(struct ioc *ioc, s
 			** exceed DMA_CHUNK_SIZE if we coalesce the
 			** next entry.
 			*/   
-			if(unlikely(ROUNDUP(dma_len + dma_offset + startsg->length,
+			if(unlikely(ALIGN(dma_len + dma_offset + startsg->length,
 					    IOVP_SIZE) > DMA_CHUNK_SIZE))
 				break;
 
@@ -158,7 +158,7 @@ iommu_coalesce_chunks(struct ioc *ioc, s
 		** Allocate space for DMA stream.
 		*/
 		sg_dma_len(contig_sg) = dma_len;
-		dma_len = ROUNDUP(dma_len + dma_offset, IOVP_SIZE);
+		dma_len = ALIGN(dma_len + dma_offset, IOVP_SIZE);
 		sg_dma_address(contig_sg) =
 			PIDE_FLAG 
 			| (iommu_alloc_range(ioc, dma_len) << IOVP_SHIFT)
diff -puN drivers/parisc/sba_iommu.c~round_up-macro-cleanup-in-drivers-parisc drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~round_up-macro-cleanup-in-drivers-parisc
+++ a/drivers/parisc/sba_iommu.c
@@ -113,8 +113,6 @@ module_param(sba_reserve_agpgart, int, 0
 MODULE_PARM_DESC(sba_reserve_agpgart, "Reserve half of IO pdir as AGPGART");
 #endif
 
-#define ROUNDUP(x,y) ((x + ((y)-1)) & ~((y)-1))
-
 
 /************************************
 ** SBA register read and write support
@@ -352,7 +350,7 @@ sba_search_bitmap(struct ioc *ioc, unsig
 		** SBA HW features in the unmap path.
 		*/
 		unsigned long o = 1 << get_order(bits_wanted << PAGE_SHIFT);
-		uint bitshiftcnt = ROUNDUP(ioc->res_bitshift, o);
+		uint bitshiftcnt = ALIGN(ioc->res_bitshift, o);
 		unsigned long mask;
 
 		if (bitshiftcnt >= BITS_PER_LONG) {
@@ -779,7 +777,7 @@ sba_unmap_single(struct device *dev, dma
 	offset = iova & ~IOVP_MASK;
 	iova ^= offset;        /* clear offset bits */
 	size += offset;
-	size = ROUNDUP(size, IOVP_SIZE);
+	size = ALIGN(size, IOVP_SIZE);
 
 	spin_lock_irqsave(&ioc->res_lock, flags);
 
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
