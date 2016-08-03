From: akpm@linux-foundation.org
Subject: [folded-merged]
 swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:14:06 -0700
Message-ID: <57a2508e.WRHuB34pwWmnT1Ub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbcHCUOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swiotlb: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: swiotlb: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-21-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> [xen swiotlb]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swiotlb.h |   10 +++++-----
 lib/swiotlb.c           |   13 +++++++------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff -puN include/linux/swiotlb.h~swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs include/linux/swiotlb.h
--- a/include/linux/swiotlb.h~swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/include/linux/swiotlb.h
@@ -6,7 +6,6 @@
 #include <linux/types.h>
 
 struct device;
-struct dma_attrs;
 struct page;
 struct scatterlist;
 
@@ -68,10 +67,10 @@ swiotlb_free_coherent(struct device *hwd
 extern dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 				   unsigned long offset, size_t size,
 				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs);
+				   unsigned long attrs);
 extern void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs);
+			       unsigned long attrs);
 
 extern int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
@@ -83,12 +82,13 @@ swiotlb_unmap_sg(struct device *hwdev, s
 
 extern int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     enum dma_data_direction dir, struct dma_attrs *attrs);
+		     enum dma_data_direction dir,
+		     unsigned long attrs);
 
 extern void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 		       int nelems, enum dma_data_direction dir,
-		       struct dma_attrs *attrs);
+		       unsigned long attrs);
 
 extern void
 swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
diff -puN lib/swiotlb.c~swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/lib/swiotlb.c
@@ -738,7 +738,7 @@ swiotlb_full(struct device *dev, size_t
 dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    unsigned long offset, size_t size,
 			    enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	phys_addr_t map, phys = page_to_phys(page) + offset;
 	dma_addr_t dev_addr = phys_to_dma(dev, phys);
@@ -807,7 +807,7 @@ static void unmap_single(struct device *
 
 void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			size_t size, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+			unsigned long attrs)
 {
 	unmap_single(hwdev, dev_addr, size, dir);
 }
@@ -877,7 +877,7 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_de
  */
 int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		     enum dma_data_direction dir, struct dma_attrs *attrs)
+		     enum dma_data_direction dir, unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -914,7 +914,7 @@ int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	       enum dma_data_direction dir)
 {
-	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, 0);
 }
 EXPORT_SYMBOL(swiotlb_map_sg);
 
@@ -924,7 +924,8 @@ EXPORT_SYMBOL(swiotlb_map_sg);
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, enum dma_data_direction dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir,
+		       unsigned long attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -941,7 +942,7 @@ void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		 enum dma_data_direction dir)
 {
-	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, 0);
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg);
 
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
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

