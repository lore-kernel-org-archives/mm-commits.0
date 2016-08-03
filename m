From: akpm@linux-foundation.org
Subject: [folded-merged]
 misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs.patch removed from -mm tree
Date: Wed, 03 Aug 2016 13:14:38 -0700
Message-ID: <57a250ae.7O88xzBIHODivmGs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbcHCUOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: misc: mic: dma-mapping: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: misc: mic: dma-mapping: use unsigned long for dma_attrs

Split out subsystem specific changes for easier reviews. This will be
squashed with main commit.

Link: http://lkml.kernel.org/r/1468399300-5399-37-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/mic/host/mic_boot.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/misc/mic/host/mic_boot.c~misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs drivers/misc/mic/host/mic_boot.c
--- a/drivers/misc/mic/host/mic_boot.c~misc-mic-dma-mapping-use-unsigned-long-for-dma_attrs
+++ a/drivers/misc/mic/host/mic_boot.c
@@ -38,7 +38,7 @@ static inline struct mic_device *vpdev_t
 static dma_addr_t
 _mic_dma_map_page(struct device *dev, struct page *page,
 		  unsigned long offset, size_t size,
-		  enum dma_data_direction dir, struct dma_attrs *attrs)
+		  enum dma_data_direction dir, unsigned long attrs)
 {
 	void *va = phys_to_virt(page_to_phys(page)) + offset;
 	struct mic_device *mdev = vpdev_to_mdev(dev);
@@ -48,7 +48,7 @@ _mic_dma_map_page(struct device *dev, st
 
 static void _mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 				size_t size, enum dma_data_direction dir,
-				struct dma_attrs *attrs)
+				unsigned long attrs)
 {
 	struct mic_device *mdev = vpdev_to_mdev(dev);
 
@@ -144,7 +144,7 @@ static inline struct mic_device *scdev_t
 
 static void *__mic_dma_alloc(struct device *dev, size_t size,
 			     dma_addr_t *dma_handle, gfp_t gfp,
-			     struct dma_attrs *attrs)
+			     unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -164,7 +164,7 @@ static void *__mic_dma_alloc(struct devi
 }
 
 static void __mic_dma_free(struct device *dev, size_t size, void *vaddr,
-			   dma_addr_t dma_handle, struct dma_attrs *attrs)
+			   dma_addr_t dma_handle, unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -176,7 +176,7 @@ static void __mic_dma_free(struct device
 static dma_addr_t
 __mic_dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 		   size_t size, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
+		   unsigned long attrs)
 {
 	void *va = phys_to_virt(page_to_phys(page)) + offset;
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
@@ -188,7 +188,7 @@ __mic_dma_map_page(struct device *dev, s
 static void
 __mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 		     size_t size, enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
+		     unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -198,7 +198,7 @@ __mic_dma_unmap_page(struct device *dev,
 
 static int __mic_dma_map_sg(struct device *dev, struct scatterlist *sg,
 			    int nents, enum dma_data_direction dir,
-			    struct dma_attrs *attrs)
+			    unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -229,7 +229,7 @@ err:
 static void __mic_dma_unmap_sg(struct device *dev,
 			       struct scatterlist *sg, int nents,
 			       enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
+			       unsigned long attrs)
 {
 	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
 	struct mic_device *mdev = scdev_to_mdev(scdev);
@@ -327,7 +327,7 @@ static inline struct mic_device *mbdev_t
 static dma_addr_t
 mic_dma_map_page(struct device *dev, struct page *page,
 		 unsigned long offset, size_t size, enum dma_data_direction dir,
-		 struct dma_attrs *attrs)
+		 unsigned long attrs)
 {
 	void *va = phys_to_virt(page_to_phys(page)) + offset;
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
@@ -338,7 +338,7 @@ mic_dma_map_page(struct device *dev, str
 static void
 mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
 		   size_t size, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
+		   unsigned long attrs)
 {
 	struct mic_device *mdev = dev_get_drvdata(dev->parent);
 	mic_unmap_single(mdev, dma_addr, size);
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
s390-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sh-dma-mapping-use-unsigned-long-for-dma_attrs.patch
sparc-dma-mapping-use-unsigned-long-for-dma_attrs.patch
tile-dma-mapping-use-unsigned-long-for-dma_attrs.patch
unicore32-dma-mapping-use-unsigned-long-for-dma_attrs.patch
xtensa-dma-mapping-use-unsigned-long-for-dma_attrs.patch
remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

