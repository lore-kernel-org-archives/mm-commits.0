From: akpm@linux-foundation.org
Subject: - iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:43 -0800
Message-ID: <200802052228.m15MSOxJ011880@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762821AbYBEWpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mingo@elte.hu, mulix@mulix.org, tglx@linutronix.de, mm-


The patch titled
     iommu sg: x86: convert gart IOMMU to use the IOMMU helper
has been removed from the -mm tree.  Its filename was
     iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg: x86: convert gart IOMMU to use the IOMMU helper
From: FUJITA Tomonori <tomof@acm.org>

This patch converts gart IOMMU to use the IOMMU helper functions. The
IOMMU doesn't allocate a memory area spanning LLD's segment boundary
anymore.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Muli Ben-Yehuda <mulix@mulix.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig              |    2 -
 arch/x86/kernel/pci-gart_64.c |   41 +++++++++++++++++++-------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff -puN arch/x86/Kconfig~iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper arch/x86/Kconfig
--- a/arch/x86/Kconfig~iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper
+++ a/arch/x86/Kconfig
@@ -466,7 +466,7 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  If unsure, say Y.
 
 config IOMMU_HELPER
-	def_bool CALGARY_IOMMU
+	def_bool (CALGARY_IOMMU || GART_IOMMU)
 
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
diff -puN arch/x86/kernel/pci-gart_64.c~iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -25,6 +25,7 @@
 #include <linux/bitops.h>
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 #include <asm/atomic.h>
 #include <asm/io.h>
 #include <asm/mtrr.h>
@@ -82,17 +83,24 @@ AGPEXTERN __u32 *agp_gatt_table;
 static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
 static int need_flush;		/* global flush state. set for each gart wrap */
 
-static unsigned long alloc_iommu(int size)
+static unsigned long alloc_iommu(struct device *dev, int size)
 {
 	unsigned long offset, flags;
+	unsigned long boundary_size;
+	unsigned long base_index;
+
+	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
+			   PAGE_SIZE) >> PAGE_SHIFT;
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
-	offset = find_next_zero_string(iommu_gart_bitmap, next_bit,
-					iommu_pages, size);
+	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
+				  size, base_index, boundary_size, 0);
 	if (offset == -1) {
 		need_flush = 1;
-		offset = find_next_zero_string(iommu_gart_bitmap, 0,
-						iommu_pages, size);
+		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
+					  size, base_index, boundary_size, 0);
 	}
 	if (offset != -1) {
 		set_bit_string(iommu_gart_bitmap, offset, size);
@@ -114,7 +122,7 @@ static void free_iommu(unsigned long off
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
-	__clear_bit_string(iommu_gart_bitmap, offset, size);
+	iommu_area_free(iommu_gart_bitmap, offset, size);
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
 }
 
@@ -235,7 +243,7 @@ static dma_addr_t dma_map_area(struct de
 				size_t size, int dir)
 {
 	unsigned long npages = to_pages(phys_mem, size);
-	unsigned long iommu_page = alloc_iommu(npages);
+	unsigned long iommu_page = alloc_iommu(dev, npages);
 	int i;
 
 	if (iommu_page == -1) {
@@ -355,10 +363,11 @@ static int dma_map_sg_nonforce(struct de
 }
 
 /* Map multiple scatterlist entries continuous into the first. */
-static int __dma_map_cont(struct scatterlist *start, int nelems,
-			  struct scatterlist *sout, unsigned long pages)
+static int __dma_map_cont(struct device *dev, struct scatterlist *start,
+			  int nelems, struct scatterlist *sout,
+			  unsigned long pages)
 {
-	unsigned long iommu_start = alloc_iommu(pages);
+	unsigned long iommu_start = alloc_iommu(dev, pages);
 	unsigned long iommu_page = iommu_start;
 	struct scatterlist *s;
 	int i;
@@ -394,8 +403,8 @@ static int __dma_map_cont(struct scatter
 }
 
 static inline int
-dma_map_cont(struct scatterlist *start, int nelems, struct scatterlist *sout,
-	     unsigned long pages, int need)
+dma_map_cont(struct device *dev, struct scatterlist *start, int nelems,
+	     struct scatterlist *sout, unsigned long pages, int need)
 {
 	if (!need) {
 		BUG_ON(nelems != 1);
@@ -403,7 +412,7 @@ dma_map_cont(struct scatterlist *start, 
 		sout->dma_length = start->length;
 		return 0;
 	}
-	return __dma_map_cont(start, nelems, sout, pages);
+	return __dma_map_cont(dev, start, nelems, sout, pages);
 }
 
 /*
@@ -449,8 +458,8 @@ gart_map_sg(struct device *dev, struct s
 			if (!iommu_merge || !nextneed || !need || s->offset ||
 			    (s->length + seg_size > max_seg_size) ||
 			    (ps->offset + ps->length) % PAGE_SIZE) {
-				if (dma_map_cont(start_sg, i - start, sgmap,
-						  pages, need) < 0)
+				if (dma_map_cont(dev, start_sg, i - start,
+						 sgmap, pages, need) < 0)
 					goto error;
 				out++;
 				seg_size = 0;
@@ -466,7 +475,7 @@ gart_map_sg(struct device *dev, struct s
 		pages += to_pages(s->offset, s->length);
 		ps = s;
 	}
-	if (dma_map_cont(start_sg, i - start, sgmap, pages, need) < 0)
+	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
 		goto error;
 	out++;
 	flush_gart();
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
