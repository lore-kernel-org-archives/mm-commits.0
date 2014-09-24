From: akpm@linux-foundation.org
Subject: + drivers-dma-coherent-add-initialization-from-device-tree.patch
 added to -mm tree
Date: Wed, 24 Sep 2014 15:30:43 -0700
Message-ID: <54234613.6LCWf/A8QjqIybdw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIXWao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 18:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: dma-coherent: add initialization from device tree
has been added to the -mm tree.  Its filename is
     drivers-dma-coherent-add-initialization-from-device-tree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-coherent-add-initialization-from-device-tree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-coherent-add-initialization-from-device-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: drivers: dma-coherent: add initialization from device tree

Initialization procedure of dma coherent pool has been split into two
parts, so memory pool can now be initialized without assigning to
particular struct device.  Then initialized region can be assigned to more
than one struct device.  To protect from concurent allocations from
structure.  The last part of this patch adds support for handling
'shared-dma-pool' reserved-memory device tree nodes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dma-coherent.c |  145 +++++++++++++++++++++++++++++-----
 1 file changed, 126 insertions(+), 19 deletions(-)

diff -puN drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree drivers/base/dma-coherent.c
--- a/drivers/base/dma-coherent.c~drivers-dma-coherent-add-initialization-from-device-tree
+++ a/drivers/base/dma-coherent.c
@@ -14,11 +14,14 @@ struct dma_coherent_mem {
 	int		size;
 	int		flags;
 	unsigned long	*bitmap;
+	spinlock_t	spinlock;
 };
 
-int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
-				dma_addr_t device_addr, size_t size, int flags)
+static int dma_init_coherent_memory(phys_addr_t phys_addr, dma_addr_t device_addr,
+			     size_t size, int flags,
+			     struct dma_coherent_mem **mem)
 {
+	struct dma_coherent_mem *dma_mem = NULL;
 	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
 	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
@@ -27,27 +30,26 @@ int dma_declare_coherent_memory(struct d
 		goto out;
 	if (!size)
 		goto out;
-	if (dev->dma_mem)
-		goto out;
-
-	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
 
 	mem_base = ioremap(phys_addr, size);
 	if (!mem_base)
 		goto out;
 
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
+	dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
+	if (!dma_mem)
 		goto out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
+	dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!dma_mem->bitmap)
 		goto free1_out;
 
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->pfn_base = PFN_DOWN(phys_addr);
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
+	dma_mem->virt_base = mem_base;
+	dma_mem->device_base = device_addr;
+	dma_mem->pfn_base = PFN_DOWN(phys_addr);
+	dma_mem->size = pages;
+	dma_mem->flags = flags;
+	spin_lock_init(&dma_mem->spinlock);
+
+	*mem = dma_mem;
 
 	if (flags & DMA_MEMORY_MAP)
 		return DMA_MEMORY_MAP;
@@ -55,12 +57,51 @@ int dma_declare_coherent_memory(struct d
 	return DMA_MEMORY_IO;
 
  free1_out:
-	kfree(dev->dma_mem);
+	kfree(dma_mem);
  out:
 	if (mem_base)
 		iounmap(mem_base);
 	return 0;
 }
+
+static void dma_release_coherent_memory(struct dma_coherent_mem *mem)
+{
+	if (!mem)
+		return;
+	iounmap(mem->virt_base);
+	kfree(mem->bitmap);
+	kfree(mem);
+}
+
+static int dma_assign_coherent_memory(struct device *dev,
+				      struct dma_coherent_mem *mem)
+{
+	if (dev->dma_mem)
+		return -EBUSY;
+
+	dev->dma_mem = mem;
+	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
+
+	return 0;
+}
+
+int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
+				dma_addr_t device_addr, size_t size, int flags)
+{
+	struct dma_coherent_mem *mem;
+	int ret;
+
+	ret = dma_init_coherent_memory(phys_addr, device_addr, size, flags,
+				       &mem);
+	if (ret == 0)
+		return 0;
+
+	if (dma_assign_coherent_memory(dev, mem) == 0)
+		return ret;
+
+	dma_release_coherent_memory(mem);
+	return 0;
+}
 EXPORT_SYMBOL(dma_declare_coherent_memory);
 
 void dma_release_declared_memory(struct device *dev)
@@ -69,10 +110,8 @@ void dma_release_declared_memory(struct
 
 	if (!mem)
 		return;
+	dma_release_coherent_memory(mem);
 	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
-	kfree(mem->bitmap);
-	kfree(mem);
 }
 EXPORT_SYMBOL(dma_release_declared_memory);
 
@@ -80,6 +119,7 @@ void *dma_mark_declared_memory_occupied(
 					dma_addr_t device_addr, size_t size)
 {
 	struct dma_coherent_mem *mem = dev->dma_mem;
+	unsigned long flags;
 	int pos, err;
 
 	size += device_addr & ~PAGE_MASK;
@@ -87,8 +127,11 @@ void *dma_mark_declared_memory_occupied(
 	if (!mem)
 		return ERR_PTR(-EINVAL);
 
+	spin_lock_irqsave(&mem->spinlock, flags);
 	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
 	err = bitmap_allocate_region(mem->bitmap, pos, get_order(size));
+	spin_unlock_irqrestore(&mem->spinlock, flags);
+
 	if (err != 0)
 		return ERR_PTR(err);
 	return mem->virt_base + (pos << PAGE_SHIFT);
@@ -115,6 +158,7 @@ int dma_alloc_from_coherent(struct devic
 {
 	struct dma_coherent_mem *mem;
 	int order = get_order(size);
+	unsigned long flags;
 	int pageno;
 
 	if (!dev)
@@ -124,6 +168,7 @@ int dma_alloc_from_coherent(struct devic
 		return 0;
 
 	*ret = NULL;
+	spin_lock_irqsave(&mem->spinlock, flags);
 
 	if (unlikely(size > (mem->size << PAGE_SHIFT)))
 		goto err;
@@ -138,10 +183,12 @@ int dma_alloc_from_coherent(struct devic
 	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
 	*ret = mem->virt_base + (pageno << PAGE_SHIFT);
 	memset(*ret, 0, size);
+	spin_unlock_irqrestore(&mem->spinlock, flags);
 
 	return 1;
 
 err:
+	spin_unlock_irqrestore(&mem->spinlock, flags);
 	/*
 	 * In the case where the allocation can not be satisfied from the
 	 * per-device area, try to fall back to generic memory if the
@@ -171,8 +218,11 @@ int dma_release_from_coherent(struct dev
 	if (mem && vaddr >= mem->virt_base && vaddr <
 		   (mem->virt_base + (mem->size << PAGE_SHIFT))) {
 		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
+		unsigned long flags;
 
+		spin_lock_irqsave(&mem->spinlock, flags);
 		bitmap_release_region(mem->bitmap, page, order);
+		spin_unlock_irqrestore(&mem->spinlock, flags);
 		return 1;
 	}
 	return 0;
@@ -218,3 +268,60 @@ int dma_mmap_from_coherent(struct device
 	return 0;
 }
 EXPORT_SYMBOL(dma_mmap_from_coherent);
+
+/*
+ * Support for reserved memory regions defined in device tree
+ */
+#ifdef CONFIG_OF_RESERVED_MEM
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+
+static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
+{
+	struct dma_coherent_mem *mem = rmem->priv;
+	if (!mem &&
+	    dma_init_coherent_memory(rmem->base, rmem->base, rmem->size,
+				     DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE,
+				     &mem) != DMA_MEMORY_MAP) {
+		pr_info("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
+			&rmem->base, (unsigned long)rmem->size / SZ_1M);
+		return -ENODEV;
+	}
+	rmem->priv = mem;
+	dma_assign_coherent_memory(dev, mem);
+	return 0;
+}
+
+static void rmem_dma_device_release(struct reserved_mem *rmem,
+				    struct device *dev)
+{
+	dev->dma_mem = NULL;
+}
+
+static const struct reserved_mem_ops rmem_dma_ops = {
+	.device_init	= rmem_dma_device_init,
+	.device_release	= rmem_dma_device_release,
+};
+
+static int __init rmem_dma_setup(struct reserved_mem *rmem)
+{
+	unsigned long node = rmem->fdt_node;
+
+	if (of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+#ifdef CONFIG_ARM
+	if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
+		pr_info("Reserved memory: regions without no-map are not yet supported\n");
+		return -EINVAL;
+	}
+#endif
+
+	rmem->ops = &rmem_dma_ops;
+	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
+		&rmem->base, (unsigned long)rmem->size / SZ_1M);
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
+#endif
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

origin.patch
mm-cma-adjust-address-limit-to-avoid-hitting-low-high-memory-boundary.patch
arm-mm-dont-limit-default-cma-region-only-to-low-memory.patch
drivers-of-add-return-value-to-of_reserved_mem_device_init.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree.patch
drivers-dma-contiguous-add-initialization-from-device-tree-checkpatch-fixes.patch
linux-next.patch

