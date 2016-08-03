From: akpm@linux-foundation.org
Subject: [folded-merged]
 remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch removed from -mm tree
Date: Wed, 03 Aug 2016 13:14:52 -0700
Message-ID: <57a250bc.OnmxsupsISWx5EXe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757AbcHCUOx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, bjorn.andersson@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: remoteproc: qcom: use unsigned long for dma_attrs
has been removed from the -mm tree.  Its filename was
     remoteproc-qcom-use-unsigned-long-for-dma_attrs.patch

This patch was dropped because it was folded into dma-mapping-use-unsigned-long-for-dma_attrs.patch

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: remoteproc: qcom: use unsigned long for dma_attrs

Link: http://lkml.kernel.org/r/1468399300-5399-44-git-send-email-k.kozlowski@samsung.com
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/remoteproc/qcom_q6v5_pil.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/remoteproc/qcom_q6v5_pil.c~remoteproc-qcom-use-unsigned-long-for-dma_attrs drivers/remoteproc/qcom_q6v5_pil.c
--- a/drivers/remoteproc/qcom_q6v5_pil.c~remoteproc-qcom-use-unsigned-long-for-dma_attrs
+++ a/drivers/remoteproc/qcom_q6v5_pil.c
@@ -349,13 +349,12 @@ static void q6v5proc_halt_axi_port(struc
 
 static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
 {
-	DEFINE_DMA_ATTRS(attrs);
+	unsigned long dma_attrs = DMA_ATTR_FORCE_CONTIGUOUS;
 	dma_addr_t phys;
 	void *ptr;
 	int ret;
 
-	dma_set_attr(DMA_ATTR_FORCE_CONTIGUOUS, &attrs);
-	ptr = dma_alloc_attrs(qproc->dev, fw->size, &phys, GFP_KERNEL, &attrs);
+	ptr = dma_alloc_attrs(qproc->dev, fw->size, &phys, GFP_KERNEL, dma_attrs);
 	if (!ptr) {
 		dev_err(qproc->dev, "failed to allocate mdt buffer\n");
 		return -ENOMEM;
@@ -372,7 +371,7 @@ static int q6v5_mpss_init_image(struct q
 	else if (ret < 0)
 		dev_err(qproc->dev, "MPSS header authentication failed: %d\n", ret);
 
-	dma_free_attrs(qproc->dev, fw->size, ptr, phys, &attrs);
+	dma_free_attrs(qproc->dev, fw->size, ptr, phys, dma_attrs);
 
 	return ret < 0 ? ret : 0;
 }
_

Patches currently in -mm which might be from k.kozlowski@samsung.com are

media-mtk-vcodec-remove-unused-dma_attrs.patch
dma-mapping-use-unsigned-long-for-dma_attrs.patch
dma-mapping-remove-dma_get_attr.patch
dma-mapping-document-the-dma-attributes-next-to-the-declaration.patch

