From: akpm@linux-foundation.org
Subject: [merged] avr32-convert-to-dma_map_ops.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:48 -0800
Message-ID: <56a169b0.Y4z26A659/tKWn6l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcAUX2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, borntraeger@de.ibm.com, egtvedt@samfundet.no, hskinnemoen@gmail.com, jroedel@suse.de, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: convert to dma_map_ops
has been removed from the -mm tree.  Its filename was
     avr32-convert-to-dma_map_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: avr32: convert to dma_map_ops

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig                   |    1 
 arch/avr32/include/asm/dma-mapping.h |  342 -------------------------
 arch/avr32/mm/dma-coherent.c         |  115 +++++---
 3 files changed, 85 insertions(+), 373 deletions(-)

diff -puN arch/avr32/Kconfig~avr32-convert-to-dma_map_ops arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~avr32-convert-to-dma_map_ops
+++ a/arch/avr32/Kconfig
@@ -7,6 +7,7 @@ config AVR32
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select VIRT_TO_BUS
+	select HAVE_DMA_ATTRS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
diff -puN arch/avr32/include/asm/dma-mapping.h~avr32-convert-to-dma_map_ops arch/avr32/include/asm/dma-mapping.h
--- a/arch/avr32/include/asm/dma-mapping.h~avr32-convert-to-dma_map_ops
+++ a/arch/avr32/include/asm/dma-mapping.h
@@ -1,350 +1,16 @@
 #ifndef __ASM_AVR32_DMA_MAPPING_H
 #define __ASM_AVR32_DMA_MAPPING_H
 
-#include <linux/mm.h>
-#include <linux/device.h>
-#include <linux/scatterlist.h>
-#include <asm/processor.h>
-#include <asm/cacheflush.h>
-#include <asm/io.h>
-
 extern void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	int direction);
 
-/*
- * Return whether the given device DMA address mask can be supported
- * properly.  For example, if your device can only drive the low 24-bits
- * during bus mastering, then you would pass 0x00ffffff as the mask
- * to this function.
- */
-static inline int dma_supported(struct device *dev, u64 mask)
-{
-	/* Fix when needed. I really don't know of any limitations */
-	return 1;
-}
-
-static inline int dma_set_mask(struct device *dev, u64 dma_mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
-		return -EIO;
-
-	*dev->dma_mask = dma_mask;
-	return 0;
-}
-
-/*
- * dma_map_single can't fail as it is implemented now.
- */
-static inline int dma_mapping_error(struct device *dev, dma_addr_t addr)
-{
-	return 0;
-}
-
-/**
- * dma_alloc_coherent - allocate consistent memory for DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: required memory size
- * @handle: bus-specific DMA address
- *
- * Allocate some uncached, unbuffered memory for a device for
- * performing DMA.  This function allocates pages, and will
- * return the CPU-viewed address, and sets @handle to be the
- * device-viewed address.
- */
-extern void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *handle, gfp_t gfp);
-
-/**
- * dma_free_coherent - free memory allocated by dma_alloc_coherent
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: size of memory originally requested in dma_alloc_coherent
- * @cpu_addr: CPU-view address returned from dma_alloc_coherent
- * @handle: device-view address returned from dma_alloc_coherent
- *
- * Free (and unmap) a DMA buffer previously allocated by
- * dma_alloc_coherent().
- *
- * References to memory and mappings associated with cpu_addr/handle
- * during and after this call executing are illegal.
- */
-extern void dma_free_coherent(struct device *dev, size_t size,
-			      void *cpu_addr, dma_addr_t handle);
-
-/**
- * dma_alloc_writecombine - allocate write-combining memory for DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: required memory size
- * @handle: bus-specific DMA address
- *
- * Allocate some uncached, buffered memory for a device for
- * performing DMA.  This function allocates pages, and will
- * return the CPU-viewed address, and sets @handle to be the
- * device-viewed address.
- */
-extern void *dma_alloc_writecombine(struct device *dev, size_t size,
-				    dma_addr_t *handle, gfp_t gfp);
-
-/**
- * dma_free_coherent - free memory allocated by dma_alloc_writecombine
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @size: size of memory originally requested in dma_alloc_writecombine
- * @cpu_addr: CPU-view address returned from dma_alloc_writecombine
- * @handle: device-view address returned from dma_alloc_writecombine
- *
- * Free (and unmap) a DMA buffer previously allocated by
- * dma_alloc_writecombine().
- *
- * References to memory and mappings associated with cpu_addr/handle
- * during and after this call executing are illegal.
- */
-extern void dma_free_writecombine(struct device *dev, size_t size,
-				  void *cpu_addr, dma_addr_t handle);
-
-/**
- * dma_map_single - map a single buffer for streaming DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @cpu_addr: CPU direct mapped address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Ensure that any data held in the cache is appropriately discarded
- * or written back.
- *
- * The device owns this memory once this call has completed.  The CPU
- * can regain ownership by calling dma_unmap_single() or dma_sync_single().
- */
-static inline dma_addr_t
-dma_map_single(struct device *dev, void *cpu_addr, size_t size,
-	       enum dma_data_direction direction)
-{
-	dma_cache_sync(dev, cpu_addr, size, direction);
-	return virt_to_bus(cpu_addr);
-}
-
-/**
- * dma_unmap_single - unmap a single buffer previously mapped
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @handle: DMA address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Unmap a single streaming mode DMA translation.  The handle and size
- * must match what was provided in the previous dma_map_single() call.
- * All other usages are undefined.
- *
- * After this call, reads by the CPU to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-
-}
-
-/**
- * dma_map_page - map a portion of a page for streaming DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @page: page that buffer resides in
- * @offset: offset into page for start of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Ensure that any data held in the cache is appropriately discarded
- * or written back.
- *
- * The device owns this memory once this call has completed.  The CPU
- * can regain ownership by calling dma_unmap_page() or dma_sync_single().
- */
-static inline dma_addr_t
-dma_map_page(struct device *dev, struct page *page,
-	     unsigned long offset, size_t size,
-	     enum dma_data_direction direction)
-{
-	return dma_map_single(dev, page_address(page) + offset,
-			      size, direction);
-}
-
-/**
- * dma_unmap_page - unmap a buffer previously mapped through dma_map_page()
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @handle: DMA address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Unmap a single streaming mode DMA translation.  The handle and size
- * must match what was provided in the previous dma_map_single() call.
- * All other usages are undefined.
- *
- * After this call, reads by the CPU to the buffer are guaranteed to see
- * whatever the device wrote there.
- */
-static inline void
-dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-	       enum dma_data_direction direction)
-{
-	dma_unmap_single(dev, dma_address, size, direction);
-}
-
-/**
- * dma_map_sg - map a set of SG buffers for streaming mode DMA
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @sg: list of buffers
- * @nents: number of buffers to map
- * @dir: DMA transfer direction
- *
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scatter-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are
- * the same here.
- */
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	   enum dma_data_direction direction)
-{
-	int i;
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, nents, i) {
-		char *virt;
-
-		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
-		virt = sg_virt(sg);
-		dma_cache_sync(dev, virt, sg->length, direction);
-	}
-
-	return nents;
-}
-
-/**
- * dma_unmap_sg - unmap a set of SG buffers mapped by dma_map_sg
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @sg: list of buffers
- * @nents: number of buffers to map
- * @dir: DMA transfer direction
- *
- * Unmap a set of streaming mode DMA translations.
- * Again, CPU read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-
-}
-
-/**
- * dma_sync_single_for_cpu
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @handle: DMA address of buffer
- * @size: size of buffer to map
- * @dir: DMA transfer direction
- *
- * Make physical memory consistent for a single streaming mode DMA
- * translation after a transfer.
- *
- * If you perform a dma_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the DMA mapping,
- * you must call this function before doing so.  At the next point you
- * give the DMA address back to the card, you must first perform a
- * dma_sync_single_for_device, and then the device again owns the
- * buffer.
- */
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			size_t size, enum dma_data_direction direction)
-{
-	/*
-	 * No need to do anything since the CPU isn't supposed to
-	 * touch this memory after we flushed it at mapping- or
-	 * sync-for-device time.
-	 */
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-			   size_t size, enum dma_data_direction direction)
-{
-	dma_cache_sync(dev, bus_to_virt(dma_handle), size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_cpu(dev, dma_handle, offset+size, direction);
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	/* just sync everything, that's all the pci API can do */
-	dma_sync_single_for_device(dev, dma_handle, offset+size, direction);
-}
+extern struct dma_map_ops avr32_dma_ops;
 
-/**
- * dma_sync_sg_for_cpu
- * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
- * @sg: list of buffers
- * @nents: number of buffers to map
- * @dir: DMA transfer direction
- *
- * Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as dma_sync_single_for_* but for a scatter-gather list,
- * same rules and usage.
- */
-static inline void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
-		    int nents, enum dma_data_direction direction)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	/*
-	 * No need to do anything since the CPU isn't supposed to
-	 * touch this memory after we flushed it at mapping- or
-	 * sync-for-device time.
-	 */
+	return &avr32_dma_ops;
 }
 
-static inline void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
-		       int nents, enum dma_data_direction direction)
-{
-	int i;
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, nents, i)
-		dma_cache_sync(dev, sg_virt(sg), sg->length, direction);
-}
-
-/* Now for the API extensions over the pci_ one */
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-/* drivers/base/dma-mapping.c */
-extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
-			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
-extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
-				  void *cpu_addr, dma_addr_t dma_addr,
-				  size_t size);
-
-#define dma_mmap_coherent(d, v, c, h, s) dma_common_mmap(d, v, c, h, s)
-#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
+#include <asm-generic/dma-mapping-common.h>
 
 #endif /* __ASM_AVR32_DMA_MAPPING_H */
diff -puN arch/avr32/mm/dma-coherent.c~avr32-convert-to-dma_map_ops arch/avr32/mm/dma-coherent.c
--- a/arch/avr32/mm/dma-coherent.c~avr32-convert-to-dma_map_ops
+++ a/arch/avr32/mm/dma-coherent.c
@@ -9,9 +9,14 @@
 #include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 #include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/device.h>
+#include <linux/scatterlist.h>
 
-#include <asm/addrspace.h>
+#include <asm/processor.h>
 #include <asm/cacheflush.h>
+#include <asm/io.h>
+#include <asm/addrspace.h>
 
 void dma_cache_sync(struct device *dev, void *vaddr, size_t size, int direction)
 {
@@ -93,60 +98,100 @@ static void __dma_free(struct device *de
 		__free_page(page++);
 }
 
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *handle, gfp_t gfp)
+static void *avr32_dma_alloc(struct device *dev, size_t size,
+		dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
 {
 	struct page *page;
-	void *ret = NULL;
+	dma_addr_t phys;
 
 	page = __dma_alloc(dev, size, handle, gfp);
-	if (page)
-		ret = phys_to_uncached(page_to_phys(page));
+	if (!page)
+		return NULL;
+	phys = page_to_phys(page);
 
-	return ret;
+	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
+		/* Now, map the page into P3 with write-combining turned on */
+		*handle = phys;
+		return __ioremap(phys, size, _PAGE_BUFFER);
+	} else {
+		return phys_to_uncached(phys);
+	}
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
-void dma_free_coherent(struct device *dev, size_t size,
-		       void *cpu_addr, dma_addr_t handle)
+static void avr32_dma_free(struct device *dev, size_t size,
+		void *cpu_addr, dma_addr_t handle, struct dma_attrs *attrs)
 {
-	void *addr = phys_to_cached(uncached_to_phys(cpu_addr));
 	struct page *page;
 
-	pr_debug("dma_free_coherent addr %p (phys %08lx) size %u\n",
-		 cpu_addr, (unsigned long)handle, (unsigned)size);
-	BUG_ON(!virt_addr_valid(addr));
-	page = virt_to_page(addr);
+	if (dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs)) {
+		iounmap(cpu_addr);
+
+		page = phys_to_page(handle);
+	} else {
+		void *addr = phys_to_cached(uncached_to_phys(cpu_addr));
+
+		pr_debug("avr32_dma_free addr %p (phys %08lx) size %u\n",
+			 cpu_addr, (unsigned long)handle, (unsigned)size);
+
+		BUG_ON(!virt_addr_valid(addr));
+		page = virt_to_page(addr);
+	}
+
 	__dma_free(dev, size, page, handle);
 }
-EXPORT_SYMBOL(dma_free_coherent);
 
-void *dma_alloc_writecombine(struct device *dev, size_t size,
-			     dma_addr_t *handle, gfp_t gfp)
+static dma_addr_t avr32_dma_map_page(struct device *dev, struct page *page,
+		unsigned long offset, size_t size,
+		enum dma_data_direction direction, struct dma_attrs *attrs)
 {
-	struct page *page;
-	dma_addr_t phys;
+	void *cpu_addr = page_address(page) + offset;
 
-	page = __dma_alloc(dev, size, handle, gfp);
-	if (!page)
-		return NULL;
+	dma_cache_sync(dev, cpu_addr, size, direction);
+	return virt_to_bus(cpu_addr);
+}
 
-	phys = page_to_phys(page);
-	*handle = phys;
+static int avr32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
+		int nents, enum dma_data_direction direction,
+		struct dma_attrs *attrs)
+{
+	int i;
+	struct scatterlist *sg;
+
+	for_each_sg(sglist, sg, nents, i) {
+		char *virt;
 
-	/* Now, map the page into P3 with write-combining turned on */
-	return __ioremap(phys, size, _PAGE_BUFFER);
+		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
+		virt = sg_virt(sg);
+		dma_cache_sync(dev, virt, sg->length, direction);
+	}
+
+	return nents;
 }
-EXPORT_SYMBOL(dma_alloc_writecombine);
 
-void dma_free_writecombine(struct device *dev, size_t size,
-			   void *cpu_addr, dma_addr_t handle)
+static void avr32_dma_sync_single_for_device(struct device *dev,
+		dma_addr_t dma_handle, size_t size,
+		enum dma_data_direction direction)
 {
-	struct page *page;
+	dma_cache_sync(dev, bus_to_virt(dma_handle), size, direction);
+}
 
-	iounmap(cpu_addr);
+static void avr32_dma_sync_sg_for_device(struct device *dev,
+		struct scatterlist *sglist, int nents,
+		enum dma_data_direction direction)
+{
+	int i;
+	struct scatterlist *sg;
 
-	page = phys_to_page(handle);
-	__dma_free(dev, size, page, handle);
+	for_each_sg(sglist, sg, nents, i)
+		dma_cache_sync(dev, sg_virt(sg), sg->length, direction);
 }
-EXPORT_SYMBOL(dma_free_writecombine);
+
+struct dma_map_ops avr32_dma_ops = {
+	.alloc			= avr32_dma_alloc,
+	.free			= avr32_dma_free,
+	.map_page		= avr32_dma_map_page,
+	.map_sg			= avr32_dma_map_sg,
+	.sync_single_for_device	= avr32_dma_sync_single_for_device,
+	.sync_sg_for_device	= avr32_dma_sync_sg_for_device,
+};
+EXPORT_SYMBOL(avr32_dma_ops);
_

Patches currently in -mm which might be from hch@lst.de are


