From: akpm@linux-foundation.org
Subject: [folded-merged]
 s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:14:40 -0700
Message-ID: <57a250b0.Mlr433b0JPL8a3bN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbcHCUOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, gerald.schaefer@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: s390: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-38-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com> [s390]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/dma-mapping.h |    1 -
 arch/s390/pci/pci_dma.c             |   23 ++++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/s390/include/asm/dma-mapping.h~s390-dma-mapping-use-unsigned-long-for-dma_attrs arch/s390/include/asm/dma-mapping.h
--- a/arch/s390/include/asm/dma-mapping.h~s390-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/s390/include/asm/dma-mapping.h
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
-#include <linux/dma-attrs.h>
 #include <linux/dma-debug.h>
 #include <linux/io.h>
 
diff -puN arch/s390/pci/pci_dma.c~s390-dma-mapping-use-unsigned-long-for-dma_attrs arch/s390/pci/pci_dma.c
--- a/arch/s390/pci/pci_dma.c~s390-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/s390/pci/pci_dma.c
@@ -286,7 +286,7 @@ static inline void zpci_err_dma(unsigned
 static dma_addr_t s390_dma_map_pages(struct device *dev, struct page *page,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction direction,
-				     struct dma_attrs *attrs)
+				     unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 	unsigned long nr_pages, iommu_page_index;
@@ -332,7 +332,7 @@ out_err:
 
 static void s390_dma_unmap_pages(struct device *dev, dma_addr_t dma_addr,
 				 size_t size, enum dma_data_direction direction,
-				 struct dma_attrs *attrs)
+				 unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 	unsigned long iommu_page_index;
@@ -355,7 +355,7 @@ static void s390_dma_unmap_pages(struct
 
 static void *s390_dma_alloc(struct device *dev, size_t size,
 			    dma_addr_t *dma_handle, gfp_t flag,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 	struct page *page;
@@ -370,7 +370,7 @@ static void *s390_dma_alloc(struct devic
 	pa = page_to_phys(page);
 	memset((void *) pa, 0, size);
 
-	map = s390_dma_map_pages(dev, page, 0, size, DMA_BIDIRECTIONAL, NULL);
+	map = s390_dma_map_pages(dev, page, 0, size, DMA_BIDIRECTIONAL, 0);
 	if (dma_mapping_error(dev, map)) {
 		free_pages(pa, get_order(size));
 		return NULL;
@@ -384,19 +384,19 @@ static void *s390_dma_alloc(struct devic
 
 static void s390_dma_free(struct device *dev, size_t size,
 			  void *pa, dma_addr_t dma_handle,
-			  struct dma_attrs *attrs)
+			  unsigned long attrs)
 {
 	struct zpci_dev *zdev = to_zpci(to_pci_dev(dev));
 
 	size = PAGE_ALIGN(size);
 	atomic64_sub(size / PAGE_SIZE, &zdev->allocated_pages);
-	s390_dma_unmap_pages(dev, dma_handle, size, DMA_BIDIRECTIONAL, NULL);
+	s390_dma_unmap_pages(dev, dma_handle, size, DMA_BIDIRECTIONAL, 0);
 	free_pages((unsigned long) pa, get_order(size));
 }
 
 static int s390_dma_map_sg(struct device *dev, struct scatterlist *sg,
 			   int nr_elements, enum dma_data_direction dir,
-			   struct dma_attrs *attrs)
+			   unsigned long attrs)
 {
 	int mapped_elements = 0;
 	struct scatterlist *s;
@@ -405,7 +405,7 @@ static int s390_dma_map_sg(struct device
 	for_each_sg(sg, s, nr_elements, i) {
 		struct page *page = sg_page(s);
 		s->dma_address = s390_dma_map_pages(dev, page, s->offset,
-						    s->length, dir, NULL);
+						    s->length, dir, 0);
 		if (!dma_mapping_error(dev, s->dma_address)) {
 			s->dma_length = s->length;
 			mapped_elements++;
@@ -419,7 +419,7 @@ unmap:
 	for_each_sg(sg, s, mapped_elements, i) {
 		if (s->dma_address)
 			s390_dma_unmap_pages(dev, s->dma_address, s->dma_length,
-					     dir, NULL);
+					     dir, 0);
 		s->dma_address = 0;
 		s->dma_length = 0;
 	}
@@ -429,13 +429,14 @@ unmap:
 
 static void s390_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 			      int nr_elements, enum dma_data_direction dir,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
 
 	for_each_sg(sg, s, nr_elements, i) {
-		s390_dma_unmap_pages(dev, s->dma_address, s->dma_length, dir, NULL);
+		s390_dma_unmap_pages(dev, s->dma_address, s->dma_length, dir,
+				     0);
 		s->dma_address = 0;
 		s->dma_length = 0;
 	}
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
tile-dma-mapping-use-unsigned-long-for-dma_attrs.patch
unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

