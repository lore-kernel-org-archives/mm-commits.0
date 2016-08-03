From: akpm@linux-foundation.org
Subject: [folded-merged]
 mips-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:14:28 -0700
Message-ID: <57a250a4.aOOEFlSu9asAggRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644AbcHCUOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     mips-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: mips: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-32-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/dma-octeon.c      |    8 ++++----
 arch/mips/loongson64/common/dma-swiotlb.c |   10 +++++-----
 arch/mips/mm/dma-default.c                |   14 +++++++-------
 arch/mips/netlogic/common/nlm-dma.c       |    4 ++--
 4 files changed, 18 insertions(+), 18 deletions(-)

diff -puN arch/mips/cavium-octeon/dma-octeon.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/cavium-octeon/dma-octeon.c
--- a/arch/mips/cavium-octeon/dma-octeon.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/cavium-octeon/dma-octeon.c
@@ -125,7 +125,7 @@ static phys_addr_t octeon_small_dma_to_p
 
 static dma_addr_t octeon_dma_map_page(struct device *dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	dma_addr_t daddr = swiotlb_map_page(dev, page, offset, size,
 					    direction, attrs);
@@ -135,7 +135,7 @@ static dma_addr_t octeon_dma_map_page(st
 }
 
 static int octeon_dma_map_sg(struct device *dev, struct scatterlist *sg,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 	int r = swiotlb_map_sg_attrs(dev, sg, nents, direction, attrs);
 	mb();
@@ -157,7 +157,7 @@ static void octeon_dma_sync_sg_for_devic
 }
 
 static void *octeon_dma_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -189,7 +189,7 @@ static void *octeon_dma_alloc_coherent(s
 }
 
 static void octeon_dma_free_coherent(struct device *dev, size_t size,
-	void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
+	void *vaddr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
diff -puN arch/mips/loongson64/common/dma-swiotlb.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/loongson64/common/dma-swiotlb.c
--- a/arch/mips/loongson64/common/dma-swiotlb.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/loongson64/common/dma-swiotlb.c
@@ -10,7 +10,7 @@
 #include <dma-coherence.h>
 
 static void *loongson_dma_alloc_coherent(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 
@@ -41,7 +41,7 @@ static void *loongson_dma_alloc_coherent
 }
 
 static void loongson_dma_free_coherent(struct device *dev, size_t size,
-		void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
+		void *vaddr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
@@ -49,7 +49,7 @@ static void loongson_dma_free_coherent(s
 static dma_addr_t loongson_dma_map_page(struct device *dev, struct page *page,
 				unsigned long offset, size_t size,
 				enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	dma_addr_t daddr = swiotlb_map_page(dev, page, offset, size,
 					dir, attrs);
@@ -59,9 +59,9 @@ static dma_addr_t loongson_dma_map_page(
 
 static int loongson_dma_map_sg(struct device *dev, struct scatterlist *sg,
 				int nents, enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
-	int r = swiotlb_map_sg_attrs(dev, sg, nents, dir, NULL);
+	int r = swiotlb_map_sg_attrs(dev, sg, nents, dir, 0);
 	mb();
 
 	return r;
diff -puN arch/mips/mm/dma-default.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/mm/dma-default.c
@@ -131,7 +131,7 @@ static void *mips_dma_alloc_noncoherent(
 }
 
 static void *mips_dma_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t * dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	void *ret;
 	struct page *page = NULL;
@@ -176,7 +176,7 @@ static void mips_dma_free_noncoherent(st
 }
 
 static void mips_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-	dma_addr_t dma_handle, struct dma_attrs *attrs)
+	dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long addr = (unsigned long) vaddr;
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
@@ -200,7 +200,7 @@ static void mips_dma_free_coherent(struc
 
 static int mips_dma_mmap(struct device *dev, struct vm_area_struct *vma,
 	void *cpu_addr, dma_addr_t dma_addr, size_t size,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	unsigned long user_count = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
@@ -291,7 +291,7 @@ static inline void __dma_sync(struct pag
 }
 
 static void mips_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
-	size_t size, enum dma_data_direction direction, struct dma_attrs *attrs)
+	size_t size, enum dma_data_direction direction, unsigned long attrs)
 {
 	if (cpu_needs_post_dma_flush(dev))
 		__dma_sync(dma_addr_to_page(dev, dma_addr),
@@ -301,7 +301,7 @@ static void mips_dma_unmap_page(struct d
 }
 
 static int mips_dma_map_sg(struct device *dev, struct scatterlist *sglist,
-	int nents, enum dma_data_direction direction, struct dma_attrs *attrs)
+	int nents, enum dma_data_direction direction, unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
@@ -322,7 +322,7 @@ static int mips_dma_map_sg(struct device
 
 static dma_addr_t mips_dma_map_page(struct device *dev, struct page *page,
 	unsigned long offset, size_t size, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	if (!plat_device_is_coherent(dev))
 		__dma_sync(page, offset, size, direction);
@@ -332,7 +332,7 @@ static dma_addr_t mips_dma_map_page(stru
 
 static void mips_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	int nhwentries, enum dma_data_direction direction,
-	struct dma_attrs *attrs)
+	unsigned long attrs)
 {
 	int i;
 	struct scatterlist *sg;
diff -puN arch/mips/netlogic/common/nlm-dma.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs arch/mips/netlogic/common/nlm-dma.c
--- a/arch/mips/netlogic/common/nlm-dma.c~mips-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/mips/netlogic/common/nlm-dma.c
@@ -45,7 +45,7 @@
 static char *nlm_swiotlb;
 
 static void *nlm_dma_alloc_coherent(struct device *dev, size_t size,
-	dma_addr_t *dma_handle, gfp_t gfp, struct dma_attrs *attrs)
+	dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
 {
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
@@ -62,7 +62,7 @@ static void *nlm_dma_alloc_coherent(stru
 }
 
 static void nlm_dma_free_coherent(struct device *dev, size_t size,
-	void *vaddr, dma_addr_t dma_handle, struct dma_attrs *attrs)
+	void *vaddr, dma_addr_t dma_handle, unsigned long attrs)
 {
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

