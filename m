From: akpm@linux-foundation.org
Subject: + x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch added to
 -mm tree
Date: Wed, 13 Jul 2016 14:51:30 -0700
Message-ID: <5786b7e2.n1V+V4WZVYTtDHZq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbcGMVvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:51:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: dma-mapping: use unsigned long for dma_attrs
has been added to the -mm tree.  Its filename is
     x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-dma-mapping-use-unsigned-long-for-dma_attrs.patch

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
Subject: x86: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-24-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/dma-mapping.h       |    5 ++---
 arch/x86/include/asm/swiotlb.h           |    4 ++--
 arch/x86/include/asm/xen/page-coherent.h |    9 ++++-----
 arch/x86/kernel/amd_gart_64.c            |   20 ++++++++++----------
 arch/x86/kernel/pci-calgary_64.c         |   14 +++++++-------
 arch/x86/kernel/pci-dma.c                |    4 ++--
 arch/x86/kernel/pci-nommu.c              |    4 ++--
 arch/x86/kernel/pci-swiotlb.c            |    4 ++--
 arch/x86/pci/sta2x11-fixup.c             |    2 +-
 arch/x86/pci/vmd.c                       |   16 ++++++++--------
 10 files changed, 40 insertions(+), 42 deletions(-)

diff -puN arch/x86/include/asm/dma-mapping.h~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -9,7 +9,6 @@
 #include <linux/kmemcheck.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
-#include <linux/dma-attrs.h>
 #include <asm/io.h>
 #include <asm/swiotlb.h>
 #include <linux/dma-contiguous.h>
@@ -48,11 +47,11 @@ extern int dma_supported(struct device *
 
 extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 					dma_addr_t *dma_addr, gfp_t flag,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 
 extern void dma_generic_free_coherent(struct device *dev, size_t size,
 				      void *vaddr, dma_addr_t dma_addr,
-				      struct dma_attrs *attrs);
+				      unsigned long attrs);
 
 #ifdef CONFIG_X86_DMA_REMAP /* Platform code defines bridge-specific code */
 extern bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
diff -puN arch/x86/include/asm/swiotlb.h~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/include/asm/swiotlb.h
--- a/arch/x86/include/asm/swiotlb.h~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/include/asm/swiotlb.h
@@ -31,9 +31,9 @@ static inline void dma_mark_clean(void *
 
 extern void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 extern void x86_swiotlb_free_coherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t dma_addr,
-					struct dma_attrs *attrs);
+					unsigned long attrs);
 
 #endif /* _ASM_X86_SWIOTLB_H */
diff -puN arch/x86/include/asm/xen/page-coherent.h~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/include/asm/xen/page-coherent.h
--- a/arch/x86/include/asm/xen/page-coherent.h~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/include/asm/xen/page-coherent.h
@@ -2,12 +2,11 @@
 #define _ASM_X86_XEN_PAGE_COHERENT_H
 
 #include <asm/page.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
 static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flags,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	void *vstart = (void*)__get_free_pages(flags, get_order(size));
 	*dma_handle = virt_to_phys(vstart);
@@ -16,18 +15,18 @@ static inline void *xen_alloc_coherent_p
 
 static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 		void *cpu_addr, dma_addr_t dma_handle,
-		struct dma_attrs *attrs)
+		unsigned long attrs)
 {
 	free_pages((unsigned long) cpu_addr, get_order(size));
 }
 
 static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
 	     dma_addr_t dev_addr, unsigned long offset, size_t size,
-	     enum dma_data_direction dir, struct dma_attrs *attrs) { }
+	     enum dma_data_direction dir, unsigned long attrs) { }
 
 static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs) { }
+		unsigned long attrs) { }
 
 static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
 		dma_addr_t handle, size_t size, enum dma_data_direction dir) { }
diff -puN arch/x86/kernel/amd_gart_64.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/amd_gart_64.c
--- a/arch/x86/kernel/amd_gart_64.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/amd_gart_64.c
@@ -242,7 +242,7 @@ static dma_addr_t dma_map_area(struct de
 static dma_addr_t gart_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t size,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	unsigned long bus;
 	phys_addr_t paddr = page_to_phys(page) + offset;
@@ -264,7 +264,7 @@ static dma_addr_t gart_map_page(struct d
  */
 static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
 			    size_t size, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	unsigned long iommu_page;
 	int npages;
@@ -286,7 +286,7 @@ static void gart_unmap_page(struct devic
  * Wrapper for pci_unmap_single working with scatterlists.
  */
 static void gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-			  enum dma_data_direction dir, struct dma_attrs *attrs)
+			  enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -294,7 +294,7 @@ static void gart_unmap_sg(struct device
 	for_each_sg(sg, s, nents, i) {
 		if (!s->dma_length || !s->length)
 			break;
-		gart_unmap_page(dev, s->dma_address, s->dma_length, dir, NULL);
+		gart_unmap_page(dev, s->dma_address, s->dma_length, dir, 0);
 	}
 }
 
@@ -316,7 +316,7 @@ static int dma_map_sg_nonforce(struct de
 			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_addr) {
 				if (i > 0)
-					gart_unmap_sg(dev, sg, i, dir, NULL);
+					gart_unmap_sg(dev, sg, i, dir, 0);
 				nents = 0;
 				sg[0].dma_length = 0;
 				break;
@@ -387,7 +387,7 @@ dma_map_cont(struct device *dev, struct
  * Merge chunks that have page aligned sizes into a continuous mapping.
  */
 static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		       enum dma_data_direction dir, struct dma_attrs *attrs)
+		       enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 	int need = 0, nextneed, i, out, start;
@@ -457,7 +457,7 @@ static int gart_map_sg(struct device *de
 
 error:
 	flush_gart();
-	gart_unmap_sg(dev, sg, out, dir, NULL);
+	gart_unmap_sg(dev, sg, out, dir, 0);
 
 	/* When it was forced or merged try again in a dumb way */
 	if (force_iommu || iommu_merge) {
@@ -477,7 +477,7 @@ error:
 /* allocate and map a coherent mapping */
 static void *
 gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
-		    gfp_t flag, struct dma_attrs *attrs)
+		    gfp_t flag, unsigned long attrs)
 {
 	dma_addr_t paddr;
 	unsigned long align_mask;
@@ -509,9 +509,9 @@ gart_alloc_coherent(struct device *dev,
 /* free a coherent mapping */
 static void
 gart_free_coherent(struct device *dev, size_t size, void *vaddr,
-		   dma_addr_t dma_addr, struct dma_attrs *attrs)
+		   dma_addr_t dma_addr, unsigned long attrs)
 {
-	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, NULL);
+	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, 0);
 	dma_generic_free_coherent(dev, size, vaddr, dma_addr, attrs);
 }
 
diff -puN arch/x86/kernel/pci-calgary_64.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -340,7 +340,7 @@ static inline struct iommu_table *find_i
 
 static void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			     int nelems,enum dma_data_direction dir,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -364,7 +364,7 @@ static void calgary_unmap_sg(struct devi
 
 static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 			  int nelems, enum dma_data_direction dir,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	struct scatterlist *s;
@@ -396,7 +396,7 @@ static int calgary_map_sg(struct device
 
 	return nelems;
 error:
-	calgary_unmap_sg(dev, sg, nelems, dir, NULL);
+	calgary_unmap_sg(dev, sg, nelems, dir, 0);
 	for_each_sg(sg, s, nelems, i) {
 		sg->dma_address = DMA_ERROR_CODE;
 		sg->dma_length = 0;
@@ -407,7 +407,7 @@ error:
 static dma_addr_t calgary_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
+				   unsigned long attrs)
 {
 	void *vaddr = page_address(page) + offset;
 	unsigned long uaddr;
@@ -422,7 +422,7 @@ static dma_addr_t calgary_map_page(struc
 
 static void calgary_unmap_page(struct device *dev, dma_addr_t dma_addr,
 			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
@@ -432,7 +432,7 @@ static void calgary_unmap_page(struct de
 }
 
 static void* calgary_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t *dma_handle, gfp_t flag, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
 {
 	void *ret = NULL;
 	dma_addr_t mapping;
@@ -466,7 +466,7 @@ error:
 
 static void calgary_free_coherent(struct device *dev, size_t size,
 				  void *vaddr, dma_addr_t dma_handle,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	unsigned int npages;
 	struct iommu_table *tbl = find_iommu_table(dev);
diff -puN arch/x86/kernel/pci-dma.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-dma.c
@@ -77,7 +77,7 @@ void __init pci_iommu_alloc(void)
 }
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	unsigned long dma_mask;
 	struct page *page;
@@ -120,7 +120,7 @@ again:
 }
 
 void dma_generic_free_coherent(struct device *dev, size_t size, void *vaddr,
-			       dma_addr_t dma_addr, struct dma_attrs *attrs)
+			       dma_addr_t dma_addr, unsigned long attrs)
 {
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	struct page *page = virt_to_page(vaddr);
diff -puN arch/x86/kernel/pci-nommu.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-nommu.c
--- a/arch/x86/kernel/pci-nommu.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-nommu.c
@@ -28,7 +28,7 @@ check_addr(char *name, struct device *hw
 static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction dir,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	dma_addr_t bus = page_to_phys(page) + offset;
 	WARN_ON(size == 0);
@@ -55,7 +55,7 @@ static dma_addr_t nommu_map_page(struct
  */
 static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 			int nents, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
diff -puN arch/x86/kernel/pci-swiotlb.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/kernel/pci-swiotlb.c
--- a/arch/x86/kernel/pci-swiotlb.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/kernel/pci-swiotlb.c
@@ -16,7 +16,7 @@ int swiotlb __read_mostly;
 
 void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags,
-					struct dma_attrs *attrs)
+					unsigned long attrs)
 {
 	void *vaddr;
 
@@ -37,7 +37,7 @@ void *x86_swiotlb_alloc_coherent(struct
 
 void x86_swiotlb_free_coherent(struct device *dev, size_t size,
 				      void *vaddr, dma_addr_t dma_addr,
-				      struct dma_attrs *attrs)
+				      unsigned long attrs)
 {
 	if (is_swiotlb_buffer(dma_to_phys(dev, dma_addr)))
 		swiotlb_free_coherent(dev, size, vaddr, dma_addr);
diff -puN arch/x86/pci/sta2x11-fixup.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/pci/sta2x11-fixup.c
--- a/arch/x86/pci/sta2x11-fixup.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/pci/sta2x11-fixup.c
@@ -169,7 +169,7 @@ static void *sta2x11_swiotlb_alloc_coher
 					    size_t size,
 					    dma_addr_t *dma_handle,
 					    gfp_t flags,
-					    struct dma_attrs *attrs)
+					    unsigned long attrs)
 {
 	void *vaddr;
 
diff -puN arch/x86/pci/vmd.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs arch/x86/pci/vmd.c
--- a/arch/x86/pci/vmd.c~x86-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/x86/pci/vmd.c
@@ -274,14 +274,14 @@ static struct dma_map_ops *vmd_dma_ops(s
 }
 
 static void *vmd_alloc(struct device *dev, size_t size, dma_addr_t *addr,
-		       gfp_t flag, struct dma_attrs *attrs)
+		       gfp_t flag, unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->alloc(to_vmd_dev(dev), size, addr, flag,
 				       attrs);
 }
 
 static void vmd_free(struct device *dev, size_t size, void *vaddr,
-		     dma_addr_t addr, struct dma_attrs *attrs)
+		     dma_addr_t addr, unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->free(to_vmd_dev(dev), size, vaddr, addr,
 				      attrs);
@@ -289,7 +289,7 @@ static void vmd_free(struct device *dev,
 
 static int vmd_mmap(struct device *dev, struct vm_area_struct *vma,
 		    void *cpu_addr, dma_addr_t addr, size_t size,
-		    struct dma_attrs *attrs)
+		    unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->mmap(to_vmd_dev(dev), vma, cpu_addr, addr,
 				      size, attrs);
@@ -297,7 +297,7 @@ static int vmd_mmap(struct device *dev,
 
 static int vmd_get_sgtable(struct device *dev, struct sg_table *sgt,
 			   void *cpu_addr, dma_addr_t addr, size_t size,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->get_sgtable(to_vmd_dev(dev), sgt, cpu_addr,
 					     addr, size, attrs);
@@ -306,26 +306,26 @@ static int vmd_get_sgtable(struct device
 static dma_addr_t vmd_map_page(struct device *dev, struct page *page,
 			       unsigned long offset, size_t size,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->map_page(to_vmd_dev(dev), page, offset, size,
 					  dir, attrs);
 }
 
 static void vmd_unmap_page(struct device *dev, dma_addr_t addr, size_t size,
-			   enum dma_data_direction dir, struct dma_attrs *attrs)
+			   enum dma_data_direction dir, unsigned long attrs)
 {
 	vmd_dma_ops(dev)->unmap_page(to_vmd_dev(dev), addr, size, dir, attrs);
 }
 
 static int vmd_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction dir, struct dma_attrs *attrs)
+		      enum dma_data_direction dir, unsigned long attrs)
 {
 	return vmd_dma_ops(dev)->map_sg(to_vmd_dev(dev), sg, nents, dir, attrs);
 }
 
 static void vmd_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
-			 enum dma_data_direction dir, struct dma_attrs *attrs)
+			 enum dma_data_direction dir, unsigned long attrs)
 {
 	vmd_dma_ops(dev)->unmap_sg(to_vmd_dev(dev), sg, nents, dir, attrs);
 }
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

