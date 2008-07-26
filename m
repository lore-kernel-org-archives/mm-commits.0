From: akpm@linux-foundation.org
Subject: - x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:34 -0700
Message-ID: <200807262113.m6QLDY6q019607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758022AbYGZVUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexisb@us.ibm.com, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 calgary: fix handling of devices that aren't behind the Calgary
has been removed from the -mm tree.  Its filename was
     x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 calgary: fix handling of devices that aren't behind the Calgary
From: Alexis Bruemmer <alexisb@us.ibm.com>

The calgary code can give drivers addresses above 4GB which is very bad
for hardware that is only 32bit DMA addressable.

With this patch, the calgary code sets the global dma_ops to swiotlb or
nommu properly, and the dma_ops of devices behind the Calgary/CalIOC2
to calgary_dma_ops.  So the calgary code can handle devices safely that
aren't behind the Calgary/CalIOC2.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |   71 ++++++++++-------------------
 include/asm-x86/iommu.h          |    1 
 2 files changed, 27 insertions(+), 45 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -37,6 +37,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+
 #include <asm/iommu.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -413,22 +414,6 @@ static void calgary_unmap_sg(struct devi
 	}
 }
 
-static int calgary_nontranslate_map_sg(struct device* dev,
-	struct scatterlist *sg, int nelems, int direction)
-{
-	struct scatterlist *s;
-	int i;
-
-	for_each_sg(sg, s, nelems, i) {
-		struct page *p = sg_page(s);
-
-		BUG_ON(!p);
-		s->dma_address = virt_to_bus(sg_virt(s));
-		s->dma_length = s->length;
-	}
-	return nelems;
-}
-
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
@@ -439,9 +424,6 @@ static int calgary_map_sg(struct device 
 	unsigned long entry;
 	int i;
 
-	if (!translation_enabled(tbl))
-		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
-
 	for_each_sg(sg, s, nelems, i) {
 		BUG_ON(!sg_page(s));
 
@@ -477,7 +459,6 @@ error:
 static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 	size_t size, int direction)
 {
-	dma_addr_t dma_handle = bad_dma_address;
 	void *vaddr = phys_to_virt(paddr);
 	unsigned long uaddr;
 	unsigned int npages;
@@ -486,12 +467,7 @@ static dma_addr_t calgary_map_single(str
 	uaddr = (unsigned long)vaddr;
 	npages = num_dma_pages(uaddr, size);
 
-	if (translation_enabled(tbl))
-		dma_handle = iommu_alloc(dev, tbl, vaddr, npages, direction);
-	else
-		dma_handle = virt_to_bus(vaddr);
-
-	return dma_handle;
+	return iommu_alloc(dev, tbl, vaddr, npages, direction);
 }
 
 static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
@@ -500,9 +476,6 @@ static void calgary_unmap_single(struct 
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	if (!translation_enabled(tbl))
-		return;
-
 	npages = num_dma_pages(dma_handle, size);
 	iommu_free(tbl, dma_handle, npages);
 }
@@ -525,18 +498,12 @@ static void* calgary_alloc_coherent(stru
 		goto error;
 	memset(ret, 0, size);
 
-	if (translation_enabled(tbl)) {
-		/* set up tces to cover the allocated range */
-		mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
-		if (mapping == bad_dma_address)
-			goto free;
-
-		*dma_handle = mapping;
-	} else /* non translated slot */
-		*dma_handle = virt_to_bus(ret);
-
+	/* set up tces to cover the allocated range */
+	mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
+	if (mapping == bad_dma_address)
+		goto free;
+	*dma_handle = mapping;
 	return ret;
-
 free:
 	free_pages((unsigned long)ret, get_order(size));
 	ret = NULL;
@@ -1241,6 +1208,16 @@ static int __init calgary_init(void)
 			goto error;
 	} while (1);
 
+	dev = NULL;
+	for_each_pci_dev(dev) {
+		struct iommu_table *tbl;
+
+		tbl = find_iommu_table(&dev->dev);
+
+		if (translation_enabled(tbl))
+			dev->dev.archdata.dma_ops = &calgary_dma_ops;
+	}
+
 	return ret;
 
 error:
@@ -1262,6 +1239,7 @@ error:
 		calgary_disable_translation(dev);
 		calgary_free_bus(dev);
 		pci_dev_put(dev); /* Undo calgary_init_one()'s pci_dev_get() */
+		dev->dev.archdata.dma_ops = NULL;
 	} while (1);
 
 	return ret;
@@ -1503,6 +1481,10 @@ void __init detect_calgary(void)
 		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d, "
 		       "CONFIG_IOMMU_DEBUG is %s.\n", specified_table_size,
 		       debugging ? "enabled" : "disabled");
+
+		/* swiotlb for devices that aren't behind the Calgary. */
+		if (max_pfn > MAX_DMA32_PFN)
+			swiotlb = 1;
 	}
 	return;
 
@@ -1519,7 +1501,7 @@ int __init calgary_iommu_init(void)
 {
 	int ret;
 
-	if (no_iommu || swiotlb)
+	if (no_iommu || (swiotlb && !calgary_detected))
 		return -ENODEV;
 
 	if (!calgary_detected)
@@ -1532,15 +1514,14 @@ int __init calgary_iommu_init(void)
 	if (ret) {
 		printk(KERN_ERR "PCI-DMA: Calgary init failed %d, "
 		       "falling back to no_iommu\n", ret);
-		if (max_pfn > MAX_DMA32_PFN)
-			printk(KERN_ERR "WARNING more than 4GB of memory, "
-					"32bit PCI may malfunction.\n");
 		return ret;
 	}
 
 	force_iommu = 1;
 	bad_dma_address = 0x0;
-	dma_ops = &calgary_dma_ops;
+	/* dma_ops is set to swiotlb or nommu */
+	if (!dma_ops)
+		dma_ops = &nommu_dma_ops;
 
 	return 0;
 }
diff -puN include/asm-x86/iommu.h~x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary include/asm-x86/iommu.h
--- a/include/asm-x86/iommu.h~x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary
+++ a/include/asm-x86/iommu.h
@@ -3,6 +3,7 @@
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
+extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
_

Patches currently in -mm which might be from alexisb@us.ibm.com are

origin.patch

