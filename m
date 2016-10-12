From: akpm@linux-foundation.org
Subject: [merged] nvme-use-the-dma_attr_no_warn-attribute.patch removed
 from -mm tree
Date: Wed, 12 Oct 2016 12:25:13 -0700
Message-ID: <57fe8e19.PRK5gG4TWX2Cg09D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33379 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbcJLTZO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mauricfo@linux.vnet.ibm.com, axboe@fb.com, benh@kernel.crashing.org, k.kozlowski@samsung.com, keith.busch@intel.com, krisman@linux.vnet.ibm.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: nvme: use the DMA_ATTR_NO_WARN attribute
has been removed from the -mm tree.  Its filename was
     nvme-use-the-dma_attr_no_warn-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mauricfo@linux.vnet.ibm.com are


