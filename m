From: akpm@linux-foundation.org
Subject: + common-dma-mapping-introduce-common-remapping-functions.patch
 added to -mm tree
Date: Wed, 13 Aug 2014 15:19:58 -0700
Message-ID: <53ebe48e.sHAkInkH32cRn78y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:51351 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaHMWT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:19:59 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so107382oah.2
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:19:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lauraa@codeaurora.org, arnd@arndb.de, catalin.marinas@arm.com, davidriley@chromium.org, linux@arm.linux.org.uk, olof@lixom.net, ritesh.harjani@gmail.com, thierry.reding@gmail.com, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: common: dma-mapping: introduce common remapping functions
has been added to the -mm tree.  Its filename is
     common-dma-mapping-introduce-common-remapping-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/common-dma-mapping-introduce-common-remapping-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/common-dma-mapping-introduce-common-remapping-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: common: dma-mapping: introduce common remapping functions

For architectures without coherent DMA, memory for DMA may need to be
remapped with coherent attributes.  Factor out the the remapping code from
arm and put it in a common location to reduce code duplication.

As part of this, the arm APIs are now migrated away from
ioremap_page_range to the common APIs which use map_vm_area for remapping.
 This should be an equivalent change and using map_vm_area is more correct
as ioremap_page_range is intended to bring in io addresses into the cpu
space and not regular kernel managed memory.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Riley <davidriley@chromium.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Ritesh Harjain <ritesh.harjani@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c                |   57 ++---------------
 drivers/base/dma-mapping.c               |   68 +++++++++++++++++++++
 include/asm-generic/dma-mapping-common.h |    9 ++
 3 files changed, 86 insertions(+), 48 deletions(-)

diff -puN arch/arm/mm/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions
+++ a/arch/arm/mm/dma-mapping.c
@@ -298,37 +298,19 @@ static void *
 __dma_alloc_remap(struct page *page, size_t size, gfp_t gfp, pgprot_t prot,
 	const void *caller)
 {
-	struct vm_struct *area;
-	unsigned long addr;
-
 	/*
 	 * DMA allocation can be mapped to user space, so lets
 	 * set VM_USERMAP flags too.
 	 */
-	area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
-				  caller);
-	if (!area)
-		return NULL;
-	addr = (unsigned long)area->addr;
-	area->phys_addr = __pfn_to_phys(page_to_pfn(page));
-
-	if (ioremap_page_range(addr, addr + size, area->phys_addr, prot)) {
-		vunmap((void *)addr);
-		return NULL;
-	}
-	return (void *)addr;
+	return dma_common_contiguous_remap(page, size,
+			VM_ARM_DMA_CONSISTENT | VM_USERMAP,
+			prot, caller);
 }
 
 static void __dma_free_remap(void *cpu_addr, size_t size)
 {
-	unsigned int flags = VM_ARM_DMA_CONSISTENT | VM_USERMAP;
-	struct vm_struct *area = find_vm_area(cpu_addr);
-	if (!area || (area->flags & flags) != flags) {
-		WARN(1, "trying to free invalid coherent area: %p\n", cpu_addr);
-		return;
-	}
-	unmap_kernel_range((unsigned long)cpu_addr, size);
-	vunmap(cpu_addr);
+	dma_common_free_remap(cpu_addr, size,
+			VM_ARM_DMA_CONSISTENT | VM_USERMAP);
 }
 
 #define DEFAULT_DMA_COHERENT_POOL_SIZE	SZ_256K
@@ -1271,29 +1253,8 @@ static void *
 __iommu_alloc_remap(struct page **pages, size_t size, gfp_t gfp, pgprot_t prot,
 		    const void *caller)
 {
-	unsigned int i, nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
-	struct vm_struct *area;
-	unsigned long p;
-
-	area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
-				  caller);
-	if (!area)
-		return NULL;
-
-	area->pages = pages;
-	area->nr_pages = nr_pages;
-	p = (unsigned long)area->addr;
-
-	for (i = 0; i < nr_pages; i++) {
-		phys_addr_t phys = __pfn_to_phys(page_to_pfn(pages[i]));
-		if (ioremap_page_range(p, p + PAGE_SIZE, phys, prot))
-			goto err;
-		p += PAGE_SIZE;
-	}
-	return area->addr;
-err:
-	unmap_kernel_range((unsigned long)area->addr, size);
-	vunmap(area->addr);
+	return dma_common_pages_remap(pages, size,
+			VM_ARM_DMA_CONSISTENT | VM_USERMAP, prot, caller);
 	return NULL;
 }
 
@@ -1501,8 +1462,8 @@ void arm_iommu_free_attrs(struct device
 	}
 
 	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
-		unmap_kernel_range((unsigned long)cpu_addr, size);
-		vunmap(cpu_addr);
+		dma_common_free_remap(cpu_addr, size,
+			VM_ARM_DMA_CONSISTENT | VM_USERMAP);
 	}
 
 	__iommu_remove_mapping(dev, handle, size);
diff -puN drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c~common-dma-mapping-introduce-common-remapping-functions
+++ a/drivers/base/dma-mapping.c
@@ -10,6 +10,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <asm-generic/dma-coherent.h>
 
 /*
@@ -267,3 +269,69 @@ int dma_common_mmap(struct device *dev,
 	return ret;
 }
 EXPORT_SYMBOL(dma_common_mmap);
+
+/*
+ * remaps an allocated contiguous region into another vm_area.
+ * Cannot be used in non-sleeping contexts
+ */
+
+void *dma_common_contiguous_remap(struct page *page, size_t size,
+			unsigned long vm_flags,
+			pgprot_t prot, const void *caller)
+{
+	int i;
+	struct page **pages;
+	void *ptr;
+	unsigned long pfn;
+
+	pages = kmalloc(sizeof(struct page *) << get_order(size), GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	for (i = 0, pfn = page_to_pfn(page); i < (size >> PAGE_SHIFT); i++)
+		pages[i] = pfn_to_page(pfn + i);
+
+	ptr = dma_common_pages_remap(pages, size, vm_flags, prot, caller);
+
+	kfree(pages);
+
+	return ptr;
+}
+
+/*
+ * remaps an array of PAGE_SIZE pages into another vm_area
+ * Cannot be used in non-sleeping contexts
+ */
+void *dma_common_pages_remap(struct page **pages, size_t size,
+			unsigned long vm_flags, pgprot_t prot,
+			const void *caller)
+{
+	struct vm_struct *area;
+
+	area = get_vm_area_caller(size, vm_flags, caller);
+	if (!area)
+		return NULL;
+
+	if (map_vm_area(area, prot, pages)) {
+		vunmap(area->addr);
+		return NULL;
+	}
+
+	return area->addr;
+}
+
+/*
+ * unmaps a range previously mapped by dma_common_*_remap
+ */
+void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags)
+{
+	struct vm_struct *area = find_vm_area(cpu_addr);
+
+	if (!area || (area->flags & vm_flags) != vm_flags) {
+		WARN(1, "trying to free invalid coherent area: %p\n", cpu_addr);
+		return;
+	}
+
+	unmap_kernel_range((unsigned long)cpu_addr, size);
+	vunmap(cpu_addr);
+}
diff -puN include/asm-generic/dma-mapping-common.h~common-dma-mapping-introduce-common-remapping-functions include/asm-generic/dma-mapping-common.h
--- a/include/asm-generic/dma-mapping-common.h~common-dma-mapping-introduce-common-remapping-functions
+++ a/include/asm-generic/dma-mapping-common.h
@@ -179,6 +179,15 @@ dma_sync_sg_for_device(struct device *de
 extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
 			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
 
+void *dma_common_contiguous_remap(struct page *page, size_t size,
+			unsigned long vm_flags,
+			pgprot_t prot, const void *caller);
+
+void *dma_common_pages_remap(struct page **pages, size_t size,
+			unsigned long vm_flags, pgprot_t prot,
+			const void *caller);
+void dma_common_free_remap(void *cpu_addr, size_t size, unsigned long vm_flags);
+
 /**
  * dma_mmap_attrs - map a coherent DMA allocation into user space
  * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
lib-genallocc-add-power-aligned-algorithm.patch
lib-genallocc-add-genpool-range-check-function.patch
common-dma-mapping-introduce-common-remapping-functions.patch
arm-use-genalloc-for-the-atomic-pool.patch
arm64-add-atomic-pool-for-non-coherent-and-cma-allocations.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

