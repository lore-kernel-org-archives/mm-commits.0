From: akpm@linux-foundation.org
Subject: [merged] media-mtk-vcodec-remove-unused-dma_attrs.patch removed
 from -mm tree
Date: Thu, 04 Aug 2016 13:03:24 -0700
Message-ID: <57a39f8c.U7LquG/EpyxkO0jp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140AbcHDUDZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 16:03:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: media: mtk-vcodec: remove unused dma_attrs
has been removed from the -mm tree.  Its filename was
     media-mtk-vcodec-remove-unused-dma_attrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: media: mtk-vcodec: remove unused dma_attrs

The local variable dma_attrs is set but never read.

Link: http://lkml.kernel.org/r/1468399300-5399-1-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c~media-mtk-vcodec-remove-unused-dma_attrs drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c~media-mtk-vcodec-remove-unused-dma_attrs
+++ a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -246,7 +246,6 @@ static int mtk_vcodec_probe(struct platf
 	struct video_device *vfd_enc;
 	struct resource *res;
 	int i, j, ret;
-	DEFINE_DMA_ATTRS(attrs);
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -378,9 +377,6 @@ static int mtk_vcodec_probe(struct platf
 		goto err_enc_reg;
 	}
 
-	/* Avoid the iommu eat big hunks */
-	dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs);
