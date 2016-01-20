From: akpm@linux-foundation.org
Subject: [folded-merged] c6x-convert-to-dma_map_ops-fix-2.patch removed
 from -mm tree
Date: Wed, 20 Jan 2016 14:38:42 -0800
Message-ID: <56a00c72.XP+UCYeVDTZ+oJqS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522AbcATWin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, borntraeger@de.ibm.com, jroedel@suse.de, linux@roeck-us.net, msalter@redhat.com, sebott@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c6x: dma mapping fixes
has been removed from the -mm tree.  Its filename was
     c6x-convert-to-dma_map_ops-fix-2.patch

This patch was dropped because it was folded into c6x-convert-to-dma_map_ops.patch

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: c6x: dma mapping fixes

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/include/asm/dma-mapping.h |    6 ++++++
 arch/c6x/kernel/dma.c              |    2 ++
 arch/c6x/mm/dma-coherent.c         |   10 ++++------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff -puN arch/c6x/include/asm/dma-mapping.h~c6x-convert-to-dma_map_ops-fix-2 arch/c6x/include/asm/dma-mapping.h
--- a/arch/c6x/include/asm/dma-mapping.h~c6x-convert-to-dma_map_ops-fix-2
+++ a/arch/c6x/include/asm/dma-mapping.h
@@ -26,4 +26,10 @@ static inline struct dma_map_ops *get_dm
 
 #include <asm-generic/dma-mapping-common.h>
 
+extern void coherent_mem_init(u32 start, u32 size);
+void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
+		gfp_t gfp, struct dma_attrs *attrs);
+void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs);
+
 #endif	/* _ASM_C6X_DMA_MAPPING_H */
diff -puN arch/c6x/kernel/dma.c~c6x-convert-to-dma_map_ops-fix-2 arch/c6x/kernel/dma.c
--- a/arch/c6x/kernel/dma.c~c6x-convert-to-dma_map_ops-fix-2
+++ a/arch/c6x/kernel/dma.c
@@ -122,7 +122,9 @@ struct dma_map_ops c6x_dma_ops = {
 	.alloc			= c6x_dma_alloc,
 	.free			= c6x_dma_free,
 	.map_page		= c6x_dma_map_page,
+	.unmap_page		= c6x_dma_unmap_page,
 	.map_sg			= c6x_dma_map_sg,
+	.unmap_sg		= c6x_dma_unmap_sg,
 	.sync_single_for_device	= c6x_dma_sync_single_for_device,
 	.sync_single_for_cpu	= c6x_dma_sync_single_for_cpu,
 	.sync_sg_for_device	= c6x_dma_sync_sg_for_device,
diff -puN arch/c6x/mm/dma-coherent.c~c6x-convert-to-dma_map_ops-fix-2 arch/c6x/mm/dma-coherent.c
--- a/arch/c6x/mm/dma-coherent.c~c6x-convert-to-dma_map_ops-fix-2
+++ a/arch/c6x/mm/dma-coherent.c
@@ -73,8 +73,8 @@ static void __free_dma_pages(u32 addr, i
  * Allocate DMA coherent memory space and return both the kernel
  * virtual and DMA address for that space.
  */
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			 dma_addr_t *handle, gfp_t gfp)
+void *c6x_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
+		gfp_t gfp, struct dma_attrs *attrs)
 {
 	u32 paddr;
 	int order;
@@ -94,13 +94,12 @@ void *dma_alloc_coherent(struct device *
 
 	return phys_to_virt(paddr);
 }
-EXPORT_SYMBOL(dma_alloc_coherent);
 
 /*
  * Free DMA coherent memory as defined by the above mapping.
  */
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-		       dma_addr_t dma_handle)
+void c6x_dma_free(struct device *dev, size_t size, void *vaddr,
+		dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	int order;
 
@@ -111,7 +110,6 @@ void dma_free_coherent(struct device *de
 
 	__free_dma_pages(virt_to_phys(vaddr), order);
 }
-EXPORT_SYMBOL(dma_free_coherent);
 
 /*
  * Initialise the coherent DMA memory allocator using the given uncached region.
_

Patches currently in -mm which might be from hch@lst.de are

dma-mapping-make-the-generic-coherent-dma-mmap-implementation-optional.patch
arc-convert-to-dma_map_ops.patch
avr32-convert-to-dma_map_ops.patch
blackfin-convert-to-dma_map_ops.patch
c6x-convert-to-dma_map_ops.patch
cris-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops.patch
nios2-convert-to-dma_map_ops-fix.patch
frv-convert-to-dma_map_ops.patch
parisc-convert-to-dma_map_ops.patch
mn10300-convert-to-dma_map_ops.patch
m68k-convert-to-dma_map_ops.patch
metag-convert-to-dma_map_ops.patch
sparc-use-generic-dma_set_mask.patch
tile-uninline-dma_set_mask.patch
dma-mapping-always-provide-the-dma_map_ops-based-implementation.patch
dma-mapping-remove-asm-generic-dma-coherenth.patch

