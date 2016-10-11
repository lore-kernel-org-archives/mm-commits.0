From: akpm@linux-foundation.org
Subject: [patch 068/102] nvme: use the DMA_ATTR_NO_WARN attribute
Date: Tue, 11 Oct 2016 13:54:20 -0700
Message-ID: <57fd517c.+U0eXWP4OStYKxog%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbcJKUyV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mauricfo@linux.vnet.ibm.com, axboe@fb.com, benh@kernel.crashing.org, k.kozlowski@samsung.com, keith.busch@intel.com, krisman@linux.vnet.ibm.com, mpe@ellerman.id.au

From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: nvme: use the DMA_ATTR_NO_WARN attribute

Use the DMA_ATTR_NO_WARN attribute for the dma_map_sg() call of the nvme
driver that returns BLK_MQ_RQ_QUEUE_BUSY (not for BLK_MQ_RQ_QUEUE_ERROR).

Link: http://lkml.kernel.org/r/1470092390-25451-4-git-send-email-mauricfo@linux.vnet.ibm.com
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/nvme/host/pci.c~nvme-use-the-dma_attr_no_warn-attribute drivers/nvme/host/pci.c
--- a/drivers/nvme/host/pci.c~nvme-use-the-dma_attr_no_warn-attribute
+++ a/drivers/nvme/host/pci.c
@@ -515,7 +515,8 @@ static int nvme_map_data(struct nvme_dev
 		goto out;
 
 	ret = BLK_MQ_RQ_QUEUE_BUSY;
-	if (!dma_map_sg(dev->dev, iod->sg, iod->nents, dma_dir))
+	if (!dma_map_sg_attrs(dev->dev, iod->sg, iod->nents, dma_dir,
+				DMA_ATTR_NO_WARN))
 		goto out;
 
 	if (!nvme_setup_prps(dev, req, size))
_
