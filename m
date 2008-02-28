From: akpm@linux-foundation.org
Subject: - cris-remove-dma_declare_coherent_memory-etc.patch removed from -mm tree
Date: Wed, 27 Feb 2008 16:34:03 -0800
Message-ID: <200802280034.m1S0Y3RZ007005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122AbYB1Aeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:34:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: remove dma_declare_coherent_memory etc.
has been removed from the -mm tree.  Its filename was
     cris-remove-dma_declare_coherent_memory-etc.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: remove dma_declare_coherent_memory etc.
From: Andi Kleen <ak@suse.de>

The DMA implementation seems to be only there for a single PCI driver and the
driver does not use these interfaces.  So remove it.

I don't have cris cross compilers so uncompiled/untested.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig                    |    5 -
 arch/cris/arch-v32/drivers/pci/dma.c |   97 -------------------------
 2 files changed, 1 insertion(+), 101 deletions(-)

diff -puN arch/cris/Kconfig~cris-remove-dma_declare_coherent_memory-etc arch/cris/Kconfig
--- a/arch/cris/Kconfig~cris-remove-dma_declare_coherent_memory-etc
+++ a/arch/cris/Kconfig
@@ -47,11 +47,6 @@ config GENERIC_CALIBRATE_DELAY
 config NO_IOPORT
 	def_bool y
 
-config HAS_DMA_DECLARE_COHERENT
-	# looks weird, but it really depends on that
-	depends on ETRAX_CARDBUS
-	def_bool y
-
 config FORCE_MAX_ZONEORDER
 	int
 	default 6
diff -puN arch/cris/arch-v32/drivers/pci/dma.c~cris-remove-dma_declare_coherent_memory-etc arch/cris/arch-v32/drivers/pci/dma.c
--- a/arch/cris/arch-v32/drivers/pci/dma.c~cris-remove-dma_declare_coherent_memory-etc
+++ a/arch/cris/arch-v32/drivers/pci/dma.c
@@ -27,24 +27,10 @@ void *dma_alloc_coherent(struct device *
 			   dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret;
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	if (mem) {
-		int page = bitmap_find_free_region(mem->bitmap, mem->size,
-						     order);
-		if (page >= 0) {
-			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(ret, 0, size);
-			return ret;
-		}
-		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
-			return NULL;
-	}
-
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
@@ -63,87 +49,6 @@ void dma_free_coherent(struct device *de
 	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
-	if (mem && vaddr >= mem->virt_base && vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-
-		bitmap_release_region(mem->bitmap, page, order);
-	} else
-		free_pages((unsigned long)vaddr, order);
-}
-
-int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-				dma_addr_t device_addr, size_t size, int flags)
-{
-	void __iomem *mem_base;
-	int pages = size >> PAGE_SHIFT;
-	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
-
-	if ((flags & (DMA_MEMORY_MAP | DMA_MEMORY_IO)) == 0)
-		goto out;
-	if (!size)
-		goto out;
-	if (dev->dma_mem)
-		goto out;
-
-	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
-
-	mem_base = ioremap(bus_addr, size);
-	if (!mem_base)
-		goto out;
-
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
-		goto iounmap_out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
-		goto free1_out;
-
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
-
-	if (flags & DMA_MEMORY_MAP)
-		return DMA_MEMORY_MAP;
-
-	return DMA_MEMORY_IO;
-
- free1_out:
-	kfree(dev->dma_mem);
- iounmap_out:
-	iounmap(mem_base);
- out:
-	return 0;
+	free_pages((unsigned long)vaddr, order);
 }
-EXPORT_SYMBOL(dma_declare_coherent_memory);
 
-void dma_release_declared_memory(struct device *dev)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-
-	if(!mem)
-		return;
-	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
-	kfree(mem->bitmap);
-	kfree(mem);
-}
-EXPORT_SYMBOL(dma_release_declared_memory);
-
-void *dma_mark_declared_memory_occupied(struct device *dev,
-					dma_addr_t device_addr, size_t size)
-{
-	struct dma_coherent_mem *mem = dev->dma_mem;
-	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	int pos, err;
-
-	if (!mem)
-		return ERR_PTR(-EINVAL);
-
-	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
-	err = bitmap_allocate_region(mem->bitmap, pos, get_order(pages));
-	if (err != 0)
-		return ERR_PTR(err);
-	return mem->virt_base + (pos << PAGE_SHIFT);
-}
-EXPORT_SYMBOL(dma_mark_declared_memory_occupied);
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
update-checkpatchpl-to-version-015.patch
git-x86.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-ocfs2.patch
git-xfs.patch
cris-remove-dma_declare_coherent_memory-etc.patch
remove-dmam_declarerelease_coherent_memory.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3-fix.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
profile-likely-unlikely-macros.patch
