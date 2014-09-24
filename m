From: akpm@linux-foundation.org
Subject: +
 drivers-dma-contiguous-add-initialization-from-device-tree.patch added to
 -mm tree
Date: Wed, 24 Sep 2014 15:30:47 -0700
Message-ID: <54234617.1HuGTTyPk/4e32EJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaIXWas (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 18:30:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.szyprowski@samsung.com, arnd@arndb.de, grant.likely@linaro.org, iamjoonsoo.kim@lge.com, joshc@codeaurora.org, kyungmin.park@samsung.com, lauraa@codeaurora.org, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers: dma-contiguous: add initialization from device tree
has been added to the -mm tree.  Its filename is
     drivers-dma-contiguous-add-initialization-from-device-tree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-contiguous-add-initialization-from-device-tree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-dma-contiguous-add-initialization-from-device-tree.patch

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
Subject: drivers: dma-contiguous: add initialization from device tree

Add a function to create CMA region from previously reserved memory and
add support for handling 'shared-dma-pool' reserved-memory device tree
nodes.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

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

 drivers/base/dma-contiguous.c |   71 ++++++++++++++++++++++++++++++++
 include/linux/cma.h           |    3 +
 mm/cma.c                      |   62 ++++++++++++++++++++++-----
 3 files changed, 125 insertions(+), 11 deletions(-)

diff -puN drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree drivers/base/dma-contiguous.c
--- a/drivers/base/dma-contiguous.c~drivers-dma-contiguous-add-initialization-from-device-tree
+++ a/drivers/base/dma-contiguous.c
@@ -211,3 +211,74 @@ bool dma_release_from_contiguous(struct
 {
 	return cma_release(dev_get_cma_area(dev), pages, count);
 }
+
+/*
+ * Support for reserved memory regions defined in device tree
+ */
+#ifdef CONFIG_OF_RESERVED_MEM
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt) fmt
+
+static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+{
+	struct cma *cma = rmem->priv;
+	if (!cma)
+		return -ENODEV;
+
+	dev_set_cma_area(dev, cma);
+	return 0;
+}
+
+static void rmem_cma_device_release(struct reserved_mem *rmem,
+				    struct device *dev)
+{
+	dev_set_cma_area(dev, NULL);
+}
+
+static const struct reserved_mem_ops rmem_cma_ops = {
+	.device_init	= rmem_cma_device_init,
+	.device_release = rmem_cma_device_release,
+};
+
+static int __init rmem_cma_setup(struct reserved_mem *rmem)
+{
+	phys_addr_t align = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	phys_addr_t mask = align - 1;
+	unsigned long node = rmem->fdt_node;
+	struct cma *cma;
+	int err;
+
+	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
+	    of_get_flat_dt_prop(node, "no-map", NULL))
+		return -EINVAL;
+
+	if ((rmem->base & mask) || (rmem->size & mask)) {
+		pr_err("Reserved memory: incorrect alignment of CMA region\n");
+		return -EINVAL;
+	}
+
+	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, &cma);
+	if (err) {
+		pr_err("Reserved memory: unable to setup CMA region\n");
+		return err;
+	}
+	/* Architecture specific contiguous memory fixup. */
+	dma_contiguous_early_fixup(rmem->base, rmem->size);
+
+	if (of_get_flat_dt_prop(node, "linux,cma-default", NULL))
+		dma_contiguous_set_default(cma);
+
+	rmem->ops = &rmem_cma_ops;
+	rmem->priv = cma;
+
+	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
+		&rmem->base, (unsigned long)rmem->size / SZ_1M);
+
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
+#endif
diff -puN include/linux/cma.h~drivers-dma-contiguous-add-initialization-from-device-tree include/linux/cma.h
--- a/include/linux/cma.h~drivers-dma-contiguous-add-initialization-from-device-tree
+++ a/include/linux/cma.h
@@ -22,6 +22,9 @@ extern int __init cma_declare_contiguous
 			phys_addr_t base, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, struct cma **res_cma);
+extern int cma_init_reserved_mem(phys_addr_t size,
+					phys_addr_t base, int order_per_bit,
+					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
 extern bool cma_release(struct cma *cma, struct page *pages, int count);
 #endif
diff -puN mm/cma.c~drivers-dma-contiguous-add-initialization-from-device-tree mm/cma.c
--- a/mm/cma.c~drivers-dma-contiguous-add-initialization-from-device-tree
+++ a/mm/cma.c
@@ -141,6 +141,54 @@ static int __init cma_init_reserved_area
 core_initcall(cma_init_reserved_areas);
 
 /**
+ * cma_init_reserved_mem() - create custom contiguous area from reserved memory
+ * @base: Base address of the reserved area
+ * @size: Size of the reserved area (in bytes),
+ * @order_per_bit: Order of pages represented by one bit on bitmap.
+ * @res_cma: Pointer to store the created cma region.
+ *
+ * This function creates custom contiguous area from already reserved memory.
+ */
+int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+				 int order_per_bit, struct cma **res_cma)
+{
+	struct cma *cma;
+	phys_addr_t alignment;
+
+	/* Sanity checks */
+	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
+		pr_err("Not enough slots for CMA reserved regions!\n");
+		return -ENOSPC;
+	}
+
+	if (!size || !memblock_is_region_reserved(base, size))
+		return -EINVAL;
+
+	/* ensure minimal alignment requied by mm core */
+	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+
+	/* alignment should be aligned with order_per_bit */
+	if (!IS_ALIGNED(alignment >> PAGE_SHIFT, 1 << order_per_bit))
+		return -EINVAL;
+
+	if (ALIGN(base, alignment) != base || ALIGN(size, alignment) != size)
+		return -EINVAL;
+
+	/*
+	 * Each reserved area must be initialised later, when more kernel
+	 * subsystems (like slab allocator) are available.
+	 */
+	cma = &cma_areas[cma_area_count];
+	cma->base_pfn = PFN_DOWN(base);
+	cma->count = size >> PAGE_SHIFT;
+	cma->order_per_bit = order_per_bit;
+	*res_cma = cma;
+	cma_area_count++;
+
+	return 0;
+}
+
+/**
  * cma_declare_contiguous() - reserve custom contiguous area
  * @base: Base address of the reserved area optional, use 0 for any
  * @size: Size of the reserved area (in bytes),
@@ -163,7 +211,6 @@ int __init cma_declare_contiguous(phys_a
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, struct cma **res_cma)
 {
-	struct cma *cma;
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
 	phys_addr_t highmem_start = __pa(high_memory);
 	int ret = 0;
@@ -235,16 +282,9 @@ int __init cma_declare_contiguous(phys_a
 		}
 	}
 
-	/*
-	 * Each reserved area must be initialised later, when more kernel
-	 * subsystems (like slab allocator) are available.
-	 */
-	cma = &cma_areas[cma_area_count];
-	cma->base_pfn = PFN_DOWN(base);
-	cma->count = size >> PAGE_SHIFT;
-	cma->order_per_bit = order_per_bit;
-	*res_cma = cma;
-	cma_area_count++;
+	ret = cma_init_reserved_mem(base, size, order_per_bit, res_cma);
+	if (ret)
+		goto err;
 
 	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
 		(unsigned long)base);
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

