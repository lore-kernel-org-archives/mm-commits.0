From: akpm@osdl.org
Subject: + ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch added to -mm tree
Date: Wed, 03 Jan 2007 12:47:58 -0800
Message-ID: <200701032047.l03KlwRm030794@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48632 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbXACUsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 3 Jan 2007 15:48:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, muli@il.ibm.com, tony.luck@intel.com


The patch titled
     ia64: make swiotlb use bus_to_virt/virt_to_bus
has been added to the -mm tree.  Its filename is
     ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: make swiotlb use bus_to_virt/virt_to_bus
From: "Jan Beulich" <jbeulich@novell.com>

Convert all phys_to_virt/virt_to_phys uses to bus_to_virt/virt_to_bus, as is
what is meant and what is needed in (at least) some virtualized environments
like Xen.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/swiotlb.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff -puN lib/swiotlb.c~ia64-make-swiotlb-use-bus_to_virt-virt_to_bus lib/swiotlb.c
--- a/lib/swiotlb.c~ia64-make-swiotlb-use-bus_to_virt-virt_to_bus
+++ a/lib/swiotlb.c
@@ -36,7 +36,7 @@
 	                   ( (val) & ( (align) - 1)))
 
 #define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
-#define SG_ENT_PHYS_ADDRESS(SG)	virt_to_phys(SG_ENT_VIRT_ADDRESS(SG))
+#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
 
 /*
  * Maximum allowable number of contiguous slabs to map,
@@ -163,7 +163,7 @@ swiotlb_init_with_default_size (size_t d
 	 */
 	io_tlb_overflow_buffer = alloc_bootmem_low(io_tlb_overflow);
 	printk(KERN_INFO "Placing software IO TLB between 0x%lx - 0x%lx\n",
-	       virt_to_phys(io_tlb_start), virt_to_phys(io_tlb_end));
+	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
 }
 
 void
@@ -244,7 +244,7 @@ swiotlb_late_init_with_default_size (siz
 
 	printk(KERN_INFO "Placing %ldMB software IO TLB between 0x%lx - "
 	       "0x%lx\n", (io_tlb_nslabs * (1 << IO_TLB_SHIFT)) >> 20,
-	       virt_to_phys(io_tlb_start), virt_to_phys(io_tlb_end));
+	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
 
 	return 0;
 
@@ -445,7 +445,7 @@ swiotlb_alloc_coherent(struct device *hw
 	flags |= GFP_DMA;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && address_needs_mapping(hwdev, virt_to_phys(ret))) {
+	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -465,11 +465,11 @@ swiotlb_alloc_coherent(struct device *hw
 		if (swiotlb_dma_mapping_error(handle))
 			return NULL;
 
-		ret = phys_to_virt(handle);
+		ret = bus_to_virt(handle);
 	}
 
 	memset(ret, 0, size);
-	dev_addr = virt_to_phys(ret);
+	dev_addr = virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
 	if (address_needs_mapping(hwdev, dev_addr)) {
@@ -525,7 +525,7 @@ swiotlb_full(struct device *dev, size_t 
 dma_addr_t
 swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
 {
-	unsigned long dev_addr = virt_to_phys(ptr);
+	unsigned long dev_addr = virt_to_bus(ptr);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -546,7 +546,7 @@ swiotlb_map_single(struct device *hwdev,
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = virt_to_phys(map);
+	dev_addr = virt_to_bus(map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -569,7 +569,7 @@ void
 swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
 		     int dir)
 {
-	char *dma_addr = phys_to_virt(dev_addr);
+	char *dma_addr = bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
@@ -592,7 +592,7 @@ static inline void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = phys_to_virt(dev_addr);
+	char *dma_addr = bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
@@ -623,7 +623,7 @@ swiotlb_sync_single_range(struct device 
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = phys_to_virt(dev_addr) + offset;
+	char *dma_addr = bus_to_virt(dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
 	if (dma_addr >= io_tlb_start && dma_addr < io_tlb_end)
@@ -676,7 +676,7 @@ swiotlb_map_sg(struct device *hwdev, str
 
 	for (i = 0; i < nelems; i++, sg++) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dev_addr = virt_to_phys(addr);
+		dev_addr = virt_to_bus(addr);
 		if (swiotlb_force || address_needs_mapping(hwdev, dev_addr)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
 			if (!map) {
@@ -709,7 +709,8 @@ swiotlb_unmap_sg(struct device *hwdev, s
 
 	for (i = 0; i < nelems; i++, sg++)
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			unmap_single(hwdev, (void *) phys_to_virt(sg->dma_address), sg->dma_length, dir);
+			unmap_single(hwdev, bus_to_virt(sg->dma_address),
+				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
 }
@@ -731,7 +732,7 @@ swiotlb_sync_sg(struct device *hwdev, st
 
 	for (i = 0; i < nelems; i++, sg++)
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, phys_to_virt(sg->dma_address),
+			sync_single(hwdev, bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
@@ -754,7 +755,7 @@ swiotlb_sync_sg_for_device(struct device
 int
 swiotlb_dma_mapping_error(dma_addr_t dma_addr)
 {
-	return (dma_addr == virt_to_phys(io_tlb_overflow_buffer));
+	return (dma_addr == virt_to_bus(io_tlb_overflow_buffer));
 }
 
 /*
@@ -766,7 +767,7 @@ swiotlb_dma_mapping_error(dma_addr_t dma
 int
 swiotlb_dma_supported (struct device *hwdev, u64 mask)
 {
-	return virt_to_phys(io_tlb_end - 1) <= mask;
+	return virt_to_bus(io_tlb_end - 1) <= mask;
 }
 
 EXPORT_SYMBOL(swiotlb_init);
_

Patches currently in -mm which might be from jbeulich@novell.com are

ia64-swiotlb-bug-fixes.patch
ia64-make-swiotlb-use-bus_to_virt-virt_to_bus.patch
ia64-swiotlb-cleanup.patch
ia64-swiotlb-abstraction-eg-for-xen.patch
ia64-missing-exports-hwsw_sync_.patch
x86_64-do-not-always-end-the-stack-trace-with-ulong_max.patch
