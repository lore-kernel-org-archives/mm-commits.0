From: akpm@linux-foundation.org
Subject: - iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:40 -0800
Message-ID: <200802052228.m15MSLLw011877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762836AbYBEWo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mingo@elte.hu, mulix@mulix.org, tglx@linutronix.de, mm-


The patch titled
     iommu sg: x86: convert calgary IOMMU to use the IOMMU helper
has been removed from the -mm tree.  Its filename was
     iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg: x86: convert calgary IOMMU to use the IOMMU helper
From: FUJITA Tomonori <tomof@acm.org>

This patch converts calgary IOMMU to use the IOMMU helper
functions. The IOMMU doesn't allocate a memory area spanning LLD's
segment boundary anymore.

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

 arch/x86/Kconfig                 |    3 ++
 arch/x86/kernel/pci-calgary_64.c |   34 +++++++++++++++++------------
 2 files changed, 23 insertions(+), 14 deletions(-)

diff -puN arch/x86/Kconfig~iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper arch/x86/Kconfig
--- a/arch/x86/Kconfig~iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper
+++ a/arch/x86/Kconfig
@@ -465,6 +465,9 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
 	  If unsure, say Y.
 
+config IOMMU_HELPER
+	def_bool CALGARY_IOMMU
+
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
 	bool
diff -puN arch/x86/kernel/pci-calgary_64.c~iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -35,6 +35,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
+#include <linux/iommu-helper.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -260,22 +261,28 @@ static void iommu_range_reserve(struct i
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
-static unsigned long iommu_range_alloc(struct iommu_table *tbl,
-	unsigned int npages)
+static unsigned long iommu_range_alloc(struct device *dev,
+				       struct iommu_table *tbl,
+				       unsigned int npages)
 {
 	unsigned long flags;
 	unsigned long offset;
+	unsigned long boundary_size;
+
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	BUG_ON(npages == 0);
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	offset = find_next_zero_string(tbl->it_map, tbl->it_hint,
-				       tbl->it_size, npages);
+	offset = iommu_area_alloc(tbl->it_map, tbl->it_size, tbl->it_hint,
+				  npages, 0, boundary_size, 0);
 	if (offset == ~0UL) {
 		tbl->chip_ops->tce_cache_blast(tbl);
-		offset = find_next_zero_string(tbl->it_map, 0,
-					       tbl->it_size, npages);
+
+		offset = iommu_area_alloc(tbl->it_map, tbl->it_size, 0,
+					  npages, 0, boundary_size, 0);
 		if (offset == ~0UL) {
 			printk(KERN_WARNING "Calgary: IOMMU full.\n");
 			spin_unlock_irqrestore(&tbl->it_lock, flags);
@@ -286,7 +293,6 @@ static unsigned long iommu_range_alloc(s
 		}
 	}
 
-	set_bit_string(tbl->it_map, offset, npages);
 	tbl->it_hint = offset + npages;
 	BUG_ON(tbl->it_hint > tbl->it_size);
 
@@ -295,13 +301,13 @@ static unsigned long iommu_range_alloc(s
 	return offset;
 }
 
-static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *vaddr,
-	unsigned int npages, int direction)
+static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
+			      void *vaddr, unsigned int npages, int direction)
 {
 	unsigned long entry;
 	dma_addr_t ret = bad_dma_address;
 
-	entry = iommu_range_alloc(tbl, npages);
+	entry = iommu_range_alloc(dev, tbl, npages);
 
 	if (unlikely(entry == bad_dma_address))
 		goto error;
@@ -354,7 +360,7 @@ static void iommu_free(struct iommu_tabl
 			       badbit, tbl, dma_addr, entry, npages);
 	}
 
-	__clear_bit_string(tbl->it_map, entry, npages);
+	iommu_area_free(tbl->it_map, entry, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
@@ -438,7 +444,7 @@ static int calgary_map_sg(struct device 
 		vaddr = (unsigned long) sg_virt(s);
 		npages = num_dma_pages(vaddr, s->length);
 
-		entry = iommu_range_alloc(tbl, npages);
+		entry = iommu_range_alloc(dev, tbl, npages);
 		if (entry == bad_dma_address) {
 			/* makes sure unmap knows to stop */
 			s->dma_length = 0;
@@ -476,7 +482,7 @@ static dma_addr_t calgary_map_single(str
 	npages = num_dma_pages(uaddr, size);
 
 	if (translation_enabled(tbl))
-		dma_handle = iommu_alloc(tbl, vaddr, npages, direction);
+		dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction);
 	else
 		dma_handle = virt_to_bus(vaddr);
 
@@ -516,7 +522,7 @@ static void* calgary_alloc_coherent(stru
 
 	if (translation_enabled(tbl)) {
 		/* set up tces to cover the allocated range */
-		mapping = iommu_alloc(tbl, ret, npages, DMA_BIDIRECTIONAL);
+		mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
 		if (mapping == bad_dma_address)
 			goto free;
 
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
