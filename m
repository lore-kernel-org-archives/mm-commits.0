From: akpm@linux-foundation.org
Subject: + arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch added to
 -mm tree
Date: Wed, 13 Jul 2016 14:50:52 -0700
Message-ID: <5786b7bc.bZRZemiTi2stcf3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: ARM: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-5-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/dmabounce.c              |    4 -
 arch/arm/include/asm/dma-mapping.h       |   13 +--
 arch/arm/include/asm/xen/page-coherent.h |   16 +---
 arch/arm/mm/dma-mapping.c                |   81 ++++++++++-----------
 arch/arm/xen/mm.c                        |    4 -
 5 files changed, 56 insertions(+), 62 deletions(-)

diff -puN arch/arm/common/dmabounce.c~arm-dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/common/dmabounce.c
--- a/arch/arm/common/dmabounce.c~arm-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/common/dmabounce.c
@@ -310,7 +310,7 @@ static inline void unmap_single(struct d
  */
 static dma_addr_t dmabounce_map_page(struct device *dev, struct page *page,
 		unsigned long offset, size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	dma_addr_t dma_addr;
 	int ret;
@@ -344,7 +344,7 @@ static dma_addr_t dmabounce_map_page(str
  * should be)
  */
 static void dmabounce_unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct safe_buffer *buf;
 
diff -puN arch/arm/include/asm/dma-mapping.h~arm-dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~arm-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -5,7 +5,6 @@
 
 #include <linux/mm_types.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 
 #include <asm/memory.h>
@@ -174,7 +173,7 @@ static inline void dma_mark_clean(void *
  * to be the device-viewed address.
  */
 extern void *arm_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-			   gfp_t gfp, struct dma_attrs *attrs);
+			   gfp_t gfp, unsigned long attrs);
 
 /**
  * arm_dma_free - free memory allocated by arm_dma_alloc
@@ -191,7 +190,7 @@ extern void *arm_dma_alloc(struct device
  * during and after this call executing are illegal.
  */
 extern void arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
-			 dma_addr_t handle, struct dma_attrs *attrs);
+			 dma_addr_t handle, unsigned long attrs);
 
 /**
  * arm_dma_mmap - map a coherent DMA allocation into user space
@@ -208,7 +207,7 @@ extern void arm_dma_free(struct device *
  */
 extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 			void *cpu_addr, dma_addr_t dma_addr, size_t size,
-			struct dma_attrs *attrs);
+			unsigned long attrs);
 
 /*
  * This can be called during early boot to increase the size of the atomic
@@ -262,16 +261,16 @@ extern void dmabounce_unregister_dev(str
  * The scatter list versions of the above methods.
  */
 extern int arm_dma_map_sg(struct device *, struct scatterlist *, int,
-		enum dma_data_direction, struct dma_attrs *attrs);
+		enum dma_data_direction, unsigned long attrs);
 extern void arm_dma_unmap_sg(struct device *, struct scatterlist *, int,
-		enum dma_data_direction, struct dma_attrs *attrs);
+		enum dma_data_direction, unsigned long attrs);
 extern void arm_dma_sync_sg_for_cpu(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
 extern void arm_dma_sync_sg_for_device(struct device *, struct scatterlist *, int,
 		enum dma_data_direction);
 extern int arm_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		struct dma_attrs *attrs);
+		unsigned long attrs);
 
 #endif /* __KERNEL__ */
 #endif
diff -puN arch/arm/include/asm/xen/page-coherent.h~arm-dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/include/asm/xen/page-coherent.h
--- a/arch/arm/include/asm/xen/page-coherent.h~arm-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/include/asm/xen/page-coherent.h
@@ -2,15 +2,14 @@
 #define _ASM_ARM_XEN_PAGE_COHERENT_H
 
 #include <asm/page.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
 void __xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs);
+	     enum dma_data_direction dir, unsigned long attrs);
 void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs);
+		unsigned long attrs);
 void __xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir);
 
@@ -18,22 +17,20 @@ void __xen_dma_sync_single_for_device(st
 		dma_addr_t handle, size_t size, enum dma_data_direction dir);
 
 static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flags,
-		struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t flags, unsigned long attrs)
 {
 	return __generic_dma_ops(hwdev)->alloc(hwdev, size, dma_handle, flags, attrs);
 }
 
 static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
-		void *cpu_addr, dma_addr_t dma_handle,
-		struct dma_attrs *attrs)
+		void *cpu_addr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	__generic_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
 }
 
 static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs)
+	     enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long page_pfn = page_to_xen_pfn(page);
 	unsigned long dev_pfn = XEN_PFN_DOWN(dev_addr);
@@ -58,8 +55,7 @@ static inline void xen_dma_map_page(stru
 }
 
 static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	unsigned long pfn = PFN_DOWN(handle);
 	/*
diff -puN arch/arm/mm/dma-mapping.c~arm-dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~arm-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/mm/dma-mapping.c
@@ -124,7 +124,7 @@ static void __dma_page_dev_to_cpu(struct
  */
 static dma_addr_t arm_dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
 	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		__dma_page_cpu_to_dev(page, offset, size, dir);
@@ -133,7 +133,7 @@ static dma_addr_t arm_dma_map_page(struc
 
 static dma_addr_t arm_coherent_dma_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
 	return pfn_to_dma(dev, page_to_pfn(page)) + offset;
 }
@@ -153,8 +153,7 @@ static dma_addr_t arm_coherent_dma_map_p
  * whatever the device wrote there.
  */
 static void arm_dma_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		__dma_page_dev_to_cpu(pfn_to_page(dma_to_pfn(dev, handle)),
@@ -194,12 +193,12 @@ struct dma_map_ops arm_dma_ops = {
 EXPORT_SYMBOL(arm_dma_ops);
 
 static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
-	dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs);
+	dma_addr_t *handle, gfp_t gfp, unsigned long attrs);
 static void arm_coherent_dma_free(struct device *dev, size_t size, void *cpu_addr,
-				  dma_addr_t handle, struct dma_attrs *attrs);
+				  dma_addr_t handle, unsigned long attrs);
 static int arm_coherent_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs);
+		 unsigned long attrs);
 
 struct dma_map_ops arm_coherent_dma_ops = {
 	.alloc			= arm_coherent_dma_alloc,
@@ -621,7 +620,7 @@ static void __free_from_contiguous(struc
 	dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT);
 }
 
-static inline pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot)
+static inline pgprot_t __get_dma_pgprot(unsigned long attrs, pgprot_t prot)
 {
 	prot = dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs) ?
 			    pgprot_writecombine(prot) :
@@ -732,7 +731,7 @@ static struct arm_dma_allocator remap_al
 
 static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 			 gfp_t gfp, pgprot_t prot, bool is_coherent,
-			 struct dma_attrs *attrs, const void *caller)
+			 unsigned long attrs, const void *caller)
 {
 	u64 mask = get_coherent_dma_mask(dev);
 	struct page *page = NULL;
@@ -814,7 +813,7 @@ static void *__dma_alloc(struct device *
  * virtual and bus address for that space.
  */
 void *arm_dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
-		    gfp_t gfp, struct dma_attrs *attrs)
+		    gfp_t gfp, unsigned long attrs)
 {
 	pgprot_t prot = __get_dma_pgprot(attrs, PAGE_KERNEL);
 
@@ -823,7 +822,7 @@ void *arm_dma_alloc(struct device *dev,
 }
 
 static void *arm_coherent_dma_alloc(struct device *dev, size_t size,
-	dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
 {
 	return __dma_alloc(dev, size, handle, gfp, PAGE_KERNEL, true,
 			   attrs, __builtin_return_address(0));
@@ -831,7 +830,7 @@ static void *arm_coherent_dma_alloc(stru
 
 static int __arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	int ret = -ENXIO;
 #ifdef CONFIG_MMU
@@ -859,14 +858,14 @@ static int __arm_dma_mmap(struct device
  */
 static int arm_coherent_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	return __arm_dma_mmap(dev, vma, cpu_addr, dma_addr, size, attrs);
 }
 
 int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 		 void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 #ifdef CONFIG_MMU
 	vma->vm_page_prot = __get_dma_pgprot(attrs, vma->vm_page_prot);
@@ -878,7 +877,7 @@ int arm_dma_mmap(struct device *dev, str
  * Free a buffer as defined by the above mapping.
  */
 static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
-			   dma_addr_t handle, struct dma_attrs *attrs,
+			   dma_addr_t handle, unsigned long attrs,
 			   bool is_coherent)
 {
 	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
@@ -900,20 +899,20 @@ static void __arm_dma_free(struct device
 }
 
 void arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
-		  dma_addr_t handle, struct dma_attrs *attrs)
+		  dma_addr_t handle, unsigned long attrs)
 {
 	__arm_dma_free(dev, size, cpu_addr, handle, attrs, false);
 }
 
 static void arm_coherent_dma_free(struct device *dev, size_t size, void *cpu_addr,
-				  dma_addr_t handle, struct dma_attrs *attrs)
+				  dma_addr_t handle, unsigned long attrs)
 {
 	__arm_dma_free(dev, size, cpu_addr, handle, attrs, true);
 }
 
 int arm_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
 		 void *cpu_addr, dma_addr_t handle, size_t size,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
 	int ret;
@@ -1046,7 +1045,7 @@ static void __dma_page_dev_to_cpu(struct
  * here.
  */
 int arm_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
@@ -1080,7 +1079,7 @@ int arm_dma_map_sg(struct device *dev, s
  * rules concerning calls here are the same as for dma_unmap_single().
  */
 void arm_dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-		enum dma_data_direction dir, struct dma_attrs *attrs)
+		enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_map_ops *ops = get_dma_ops(dev);
 	struct scatterlist *s;
@@ -1253,7 +1252,7 @@ static inline void __free_iova(struct dm
 static const int iommu_order_array[] = { 9, 8, 4, 0 };
 
 static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
-					  gfp_t gfp, struct dma_attrs *attrs)
+					  gfp_t gfp, unsigned long attrs)
 {
 	struct page **pages;
 	int count = size >> PAGE_SHIFT;
@@ -1342,7 +1341,7 @@ error:
 }
 
 static int __iommu_free_buffer(struct device *dev, struct page **pages,
-			       size_t size, struct dma_attrs *attrs)
+			       size_t size, unsigned long attrs)
 {
 	int count = size >> PAGE_SHIFT;
 	int i;
@@ -1439,7 +1438,7 @@ static struct page **__atomic_get_pages(
 	return (struct page **)page;
 }
 
-static struct page **__iommu_get_pages(void *cpu_addr, struct dma_attrs *attrs)
+static struct page **__iommu_get_pages(void *cpu_addr, unsigned long attrs)
 {
 	struct vm_struct *area;
 
@@ -1484,7 +1483,7 @@ static void __iommu_free_atomic(struct d
 }
 
 static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
-	    dma_addr_t *handle, gfp_t gfp, struct dma_attrs *attrs)
+	    dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
 {
 	pgprot_t prot = __get_dma_pgprot(attrs, PAGE_KERNEL);
 	struct page **pages;
@@ -1532,7 +1531,7 @@ err_buffer:
 
 static int arm_iommu_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
 		    void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		    struct dma_attrs *attrs)
+		    unsigned long attrs)
 {
 	unsigned long uaddr = vma->vm_start;
 	unsigned long usize = vma->vm_end - vma->vm_start;
@@ -1568,7 +1567,7 @@ static int arm_iommu_mmap_attrs(struct d
  * Must not be called with IRQs disabled.
  */
 void arm_iommu_free_attrs(struct device *dev, size_t size, void *cpu_addr,
-			  dma_addr_t handle, struct dma_attrs *attrs)
+			  dma_addr_t handle, unsigned long attrs)
 {
 	struct page **pages;
 	size = PAGE_ALIGN(size);
@@ -1595,7 +1594,7 @@ void arm_iommu_free_attrs(struct device
 
 static int arm_iommu_get_sgtable(struct device *dev, struct sg_table *sgt,
 				 void *cpu_addr, dma_addr_t dma_addr,
-				 size_t size, struct dma_attrs *attrs)
+				 size_t size, unsigned long attrs)
 {
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page **pages = __iommu_get_pages(cpu_addr, attrs);
@@ -1633,7 +1632,7 @@ static int __dma_direction_to_prot(enum
  */
 static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 			  size_t size, dma_addr_t *handle,
-			  enum dma_data_direction dir, struct dma_attrs *attrs,
+			  enum dma_data_direction dir, unsigned long attrs,
 			  bool is_coherent)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
@@ -1676,7 +1675,7 @@ fail:
 }
 
 static int __iommu_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		     enum dma_data_direction dir, struct dma_attrs *attrs,
+		     enum dma_data_direction dir, unsigned long attrs,
 		     bool is_coherent)
 {
 	struct scatterlist *s = sg, *dma = sg, *start = sg;
@@ -1734,7 +1733,7 @@ bad_mapping:
  * obtained via sg_dma_{address,length}.
  */
 int arm_coherent_iommu_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	return __iommu_map_sg(dev, sg, nents, dir, attrs, true);
 }
@@ -1752,14 +1751,14 @@ int arm_coherent_iommu_map_sg(struct dev
  * sg_dma_{address,length}.
  */
 int arm_iommu_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir, unsigned long attrs)
 {
 	return __iommu_map_sg(dev, sg, nents, dir, attrs, false);
 }
 
 static void __iommu_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs,
-		bool is_coherent)
+		int nents, enum dma_data_direction dir,
+		unsigned long attrs, bool is_coherent)
 {
 	struct scatterlist *s;
 	int i;
@@ -1786,7 +1785,8 @@ static void __iommu_unmap_sg(struct devi
  * rules concerning calls here are the same as for dma_unmap_single().
  */
 void arm_coherent_iommu_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs)
+		int nents, enum dma_data_direction dir,
+		unsigned long attrs)
 {
 	__iommu_unmap_sg(dev, sg, nents, dir, attrs, true);
 }
@@ -1802,7 +1802,8 @@ void arm_coherent_iommu_unmap_sg(struct
  * rules concerning calls here are the same as for dma_unmap_single().
  */
 void arm_iommu_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-			enum dma_data_direction dir, struct dma_attrs *attrs)
+			enum dma_data_direction dir,
+			unsigned long attrs)
 {
 	__iommu_unmap_sg(dev, sg, nents, dir, attrs, false);
 }
@@ -1855,7 +1856,7 @@ void arm_iommu_sync_sg_for_device(struct
  */
 static dma_addr_t arm_coherent_iommu_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
 	dma_addr_t dma_addr;
@@ -1889,7 +1890,7 @@ fail:
  */
 static dma_addr_t arm_iommu_map_page(struct device *dev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     unsigned long attrs)
 {
 	if (!dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
 		__dma_page_cpu_to_dev(page, offset, size, dir);
@@ -1907,8 +1908,7 @@ static dma_addr_t arm_iommu_map_page(str
  * Coherent IOMMU aware version of arm_dma_unmap_page()
  */
 static void arm_coherent_iommu_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
 	dma_addr_t iova = handle & PAGE_MASK;
@@ -1932,8 +1932,7 @@ static void arm_coherent_iommu_unmap_pag
  * IOMMU aware version of arm_dma_unmap_page()
  */
 static void arm_iommu_unmap_page(struct device *dev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
 	dma_addr_t iova = handle & PAGE_MASK;
diff -puN arch/arm/xen/mm.c~arm-dma-mapping-use-unsigned-long-for-dma_attrs arch/arm/xen/mm.c
--- a/arch/arm/xen/mm.c~arm-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/arm/xen/mm.c
@@ -98,7 +98,7 @@ static void __xen_dma_page_cpu_to_dev(st
 
 void __xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs)
+	     enum dma_data_direction dir, unsigned long attrs)
 {
 	if (is_device_dma_coherent(hwdev))
 		return;
@@ -110,7 +110,7 @@ void __xen_dma_map_page(struct device *h
 
 void __xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 
 {
 	if (is_device_dma_coherent(hwdev))
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
alpha-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
arm64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
avr32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
blackfin-dma-mapping-use-unsigned-long-for-dma_attrs.patch
c6x-dma-mapping-use-unsigned-long-for-dma_attrs.patch
cris-dma-mapping-use-unsigned-long-for-dma_attrs.patch
frv-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-exynos-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-mediatek-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-msm-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-nouveau-dma-mapping-use-unsigned-long-for-dma_attrs.patch
drm-rockship-dma-mapping-use-unsigned-long-for-dma_attrs.patch
infiniband-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-dma-mapping-use-unsigned-long-for-dma_attrs.patch
media-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xen-dma-mapping-use-unsigned-long-for-dma_attrs.patch
swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs.patch
powerpc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
video-dma-mapping-use-unsigned-long-for-dma_attrs.patch
x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch
iommu-intel-dma-mapping-use-unsigned-long-for-dma_attrs.patch
h8300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
hexagon-dma-mapping-use-unsigned-long-for-dma_attrs.patch
ia64-dma-mapping-use-unsigned-long-for-dma_attrs.patch
m68k-dma-mapping-use-unsigned-long-for-dma_attrs.patch
metag-dma-mapping-use-unsigned-long-for-dma_attrs.patch
microblaze-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mips-dma-mapping-use-unsigned-long-for-dma_attrs.patch
mn10300-dma-mapping-use-unsigned-long-for-dma_attrs.patch
nios2-dma-mapping-use-unsigned-long-for-dma_attrs.patch
openrisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
parisc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs.patch
s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
tile-dma-mapping-use-unsigned-long-for-dma_attrs.patch
unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

