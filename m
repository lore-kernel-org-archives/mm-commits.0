From: akpm@linux-foundation.org
Subject: [wrecked]
 arm-dma-mapping-constify-attrs-passed-to-internal-functions.patch removed
 from -mm tree
Date: Mon, 11 Jul 2016 15:17:53 -0700
Message-ID: <57841b11.3ZXGD620a+Wk+LDy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbcGKWRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jul 2016 18:17:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, catalin.marinas@arm.com, joro@8bytes.org, konrad.wilk@oracle.com, m.szyprowski@samsung.com, rmk+kernel@armlinux.org.uk, sstabellini@kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: dma-mapping: constify attrs passed to internal functions
has been removed from the -mm tree.  Its filename was
     arm-dma-mapping-constify-attrs-passed-to-internal-functions.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: ARM: dma-mapping: constify attrs passed to internal functions

Some of the non-exported functions do not modify passed dma_attrs so the
pointer can point to const data.

Link: http://lkml.kernel.org/r/1464071290-15948-3-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN arch/arm/mm/dma-mapping.c~arm-dma-mapping-constify-attrs-passed-to-internal-functions arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~arm-dma-mapping-constify-attrs-passed-to-internal-functions
+++ a/arch/arm/mm/dma-mapping.c
@@ -621,7 +621,7 @@ static void __free_from_contiguous(struc
 	dma_release_from_contiguous(dev, page, size >> PAGE_SHIFT);
 }
 
-static inline pgprot_t __get_dma_pgprot(struct dma_attrs *attrs, pgprot_t prot)
+static inline pgprot_t __get_dma_pgprot(const struct dma_attrs *attrs, pgprot_t prot)
 {
 	prot = dma_get_attr(DMA_ATTR_WRITE_COMBINE, attrs) ?
 			    pgprot_writecombine(prot) :
@@ -732,7 +732,7 @@ static struct arm_dma_allocator remap_al
 
 static void *__dma_alloc(struct device *dev, size_t size, dma_addr_t *handle,
 			 gfp_t gfp, pgprot_t prot, bool is_coherent,
-			 struct dma_attrs *attrs, const void *caller)
+			 const struct dma_attrs *attrs, const void *caller)
 {
 	u64 mask = get_coherent_dma_mask(dev);
 	struct page *page = NULL;
@@ -878,7 +878,7 @@ int arm_dma_mmap(struct device *dev, str
  * Free a buffer as defined by the above mapping.
  */
 static void __arm_dma_free(struct device *dev, size_t size, void *cpu_addr,
-			   dma_addr_t handle, struct dma_attrs *attrs,
+			   dma_addr_t handle, const struct dma_attrs *attrs,
 			   bool is_coherent)
 {
 	struct page *page = pfn_to_page(dma_to_pfn(dev, handle));
@@ -1253,7 +1253,8 @@ static inline void __free_iova(struct dm
 static const int iommu_order_array[] = { 9, 8, 4, 0 };
 
 static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
-					  gfp_t gfp, struct dma_attrs *attrs)
+					  gfp_t gfp,
+					  const struct dma_attrs *attrs)
 {
 	struct page **pages;
 	int count = size >> PAGE_SHIFT;
@@ -1342,7 +1343,7 @@ error:
 }
 
 static int __iommu_free_buffer(struct device *dev, struct page **pages,
-			       size_t size, struct dma_attrs *attrs)
+			       size_t size, const struct dma_attrs *attrs)
 {
 	int count = size >> PAGE_SHIFT;
 	int i;
@@ -1439,7 +1440,8 @@ static struct page **__atomic_get_pages(
 	return (struct page **)page;
 }
 
-static struct page **__iommu_get_pages(void *cpu_addr, struct dma_attrs *attrs)
+static struct page **__iommu_get_pages(void *cpu_addr,
+				       const struct dma_attrs *attrs)
 {
 	struct vm_struct *area;
 
@@ -1633,8 +1635,8 @@ static int __dma_direction_to_prot(enum
  */
 static int __map_sg_chunk(struct device *dev, struct scatterlist *sg,
 			  size_t size, dma_addr_t *handle,
-			  enum dma_data_direction dir, struct dma_attrs *attrs,
-			  bool is_coherent)
+			  enum dma_data_direction dir,
+			  const struct dma_attrs *attrs, bool is_coherent)
 {
 	struct dma_iommu_mapping *mapping = to_dma_iommu_mapping(dev);
 	dma_addr_t iova, iova_base;
@@ -1676,8 +1678,8 @@ fail:
 }
 
 static int __iommu_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		     enum dma_data_direction dir, struct dma_attrs *attrs,
-		     bool is_coherent)
+		     enum dma_data_direction dir,
+		     const struct dma_attrs *attrs, bool is_coherent)
 {
 	struct scatterlist *s = sg, *dma = sg, *start = sg;
 	int i, count = 0;
@@ -1758,8 +1760,8 @@ int arm_iommu_map_sg(struct device *dev,
 }
 
 static void __iommu_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir, struct dma_attrs *attrs,
-		bool is_coherent)
+		int nents, enum dma_data_direction dir,
+		const struct dma_attrs *attrs, bool is_coherent)
 {
 	struct scatterlist *s;
 	int i;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

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
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch
arm64-dma-mapping-constify-attrs-passed-to-internal-functions.patch

