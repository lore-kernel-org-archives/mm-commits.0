From: akpm@linux-foundation.org
Subject: [folded-merged]
 xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm
 tree
Date: Wed, 03 Aug 2016 13:14:50 -0700
Message-ID: <57a250ba./qqW/DfXEdDlvhnH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbcHCUOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: xtensa: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-43-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/pci-dma.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/xtensa/kernel/pci-dma.c~xtensa-dma-mapping-use-unsigned-long-for-dma_attrs arch/xtensa/kernel/pci-dma.c
--- a/arch/xtensa/kernel/pci-dma.c~xtensa-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/arch/xtensa/kernel/pci-dma.c
@@ -142,7 +142,7 @@ static void xtensa_sync_sg_for_device(st
 
 static void *xtensa_dma_alloc(struct device *dev, size_t size,
 			      dma_addr_t *handle, gfp_t flag,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	unsigned long ret;
 	unsigned long uncached = 0;
@@ -171,7 +171,7 @@ static void *xtensa_dma_alloc(struct dev
 }
 
 static void xtensa_dma_free(struct device *hwdev, size_t size, void *vaddr,
-			    dma_addr_t dma_handle, struct dma_attrs *attrs)
+			    dma_addr_t dma_handle, unsigned long attrs)
 {
 	unsigned long addr = (unsigned long)vaddr +
 		XCHAL_KSEG_CACHED_VADDR - XCHAL_KSEG_BYPASS_VADDR;
@@ -185,7 +185,7 @@ static void xtensa_dma_free(struct devic
 static dma_addr_t xtensa_map_page(struct device *dev, struct page *page,
 				  unsigned long offset, size_t size,
 				  enum dma_data_direction dir,
-				  struct dma_attrs *attrs)
+				  unsigned long attrs)
 {
 	dma_addr_t dma_handle = page_to_phys(page) + offset;
 
@@ -195,14 +195,14 @@ static dma_addr_t xtensa_map_page(struct
 
 static void xtensa_unmap_page(struct device *dev, dma_addr_t dma_handle,
 			      size_t size, enum dma_data_direction dir,
-			      struct dma_attrs *attrs)
+			      unsigned long attrs)
 {
 	xtensa_sync_single_for_cpu(dev, dma_handle, size, dir);
 }
 
 static int xtensa_map_sg(struct device *dev, struct scatterlist *sg,
 			 int nents, enum dma_data_direction dir,
-			 struct dma_attrs *attrs)
+			 unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -217,7 +217,7 @@ static int xtensa_map_sg(struct device *
 static void xtensa_unmap_sg(struct device *dev,
 			    struct scatterlist *sg, int nents,
 			    enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct scatterlist *s;
 	int i;
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

