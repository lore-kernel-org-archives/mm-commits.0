From: akpm@linux-foundation.org
Subject: [merged]
 drivers-dma-coherent-add-initialization-from-device-tree.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:01 -0700
Message-ID: <543d6915.GuceJNnmC0zZELoW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaJNSTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: dma-coherent: add initialization from device tree
has been removed from the -mm tree.  Its filename was
     drivers-dma-coherent-add-initialization-from-device-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: drivers: dma-coherent: add initialization from device tree

Initialization procedure of dma coherent pool has been split into two
parts, so memory pool can now be initialized without assigning to
particular struct device.  Then initialized region can be assigned to more
than one struct device.  To protect from concurent allocations from
structure.  The last part of this patch adds support for handling
'shared-dma-pool' reserved-memory device tree nodes.

[akpm@linux-foundation.org: use more appropriate printk facility levels]
[akpm@linux-foundation.org: coding-style fixes]
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

 drivers/base/dma-coherent.c |  153 ++++++++++++++++++++++++++++------
 1 file changed, 130 insertions(+), 23 deletions(-)

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
@@ -27,40 +30,77 @@ int dma_declare_coherent_memory(struct d
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
-		goto free1_out;
-
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->pfn_base = PFN_DOWN(phys_addr);
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
+	dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!dma_mem->bitmap)
+		goto out;
+
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
 
 	return DMA_MEMORY_IO;
 
- free1_out:
-	kfree(dev->dma_mem);
- out:
+out:
+	kfree(dma_mem);
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
@@ -69,10 +109,8 @@ void dma_release_declared_memory(struct
 
 	if (!mem)
 		return;
+	dma_release_coherent_memory(mem);
 	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
-	kfree(mem->bitmap);
-	kfree(mem);
 }
 EXPORT_SYMBOL(dma_release_declared_memory);
 
@@ -80,6 +118,7 @@ void *dma_mark_declared_memory_occupied(
 					dma_addr_t device_addr, size_t size)
 {
 	struct dma_coherent_mem *mem = dev->dma_mem;
+	unsigned long flags;
 	int pos, err;
 
 	size += device_addr & ~PAGE_MASK;
@@ -87,8 +126,11 @@ void *dma_mark_declared_memory_occupied(
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
@@ -115,6 +157,7 @@ int dma_alloc_from_coherent(struct devic
 {
 	struct dma_coherent_mem *mem;
 	int order = get_order(size);
+	unsigned long flags;
 	int pageno;
 
 	if (!dev)
@@ -124,6 +167,7 @@ int dma_alloc_from_coherent(struct devic
 		return 0;
 
 	*ret = NULL;
+	spin_lock_irqsave(&mem->spinlock, flags);
 
 	if (unlikely(size > (mem->size << PAGE_SHIFT)))
 		goto err;
@@ -138,10 +182,12 @@ int dma_alloc_from_coherent(struct devic
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
@@ -171,8 +217,11 @@ int dma_release_from_coherent(struct dev
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
@@ -218,3 +267,61 @@ int dma_mmap_from_coherent(struct device
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
+
+	if (!mem &&
+	    dma_init_coherent_memory(rmem->base, rmem->base, rmem->size,
+				     DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE,
+				     &mem) != DMA_MEMORY_MAP) {
+		pr_err("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
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
+		pr_err("Reserved memory: regions without no-map are not yet supported\n");
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
linux-next.patch

