From: akpm@linux-foundation.org
Subject: [merged]
 netup_unidvb-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:28 -0800
Message-ID: <56439b8c.DxOPX8sXp1RyG8/K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbKKTs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mchehab@osg.samsung.com, serjk@netup.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: netup_unidvb: use pci_set_dma_mask insted of pci_dma_supported
has been removed from the -mm tree.  Its filename was
     netup_unidvb-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: netup_unidvb: use pci_set_dma_mask insted of pci_dma_supported

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Sergey Kozlov <serjk@netup.ru>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/pci/netup_unidvb/netup_unidvb_core.c~netup_unidvb-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/netup_unidvb/netup_unidvb_core.c
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c~netup_unidvb-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -810,7 +810,7 @@ static int netup_unidvb_initdev(struct p
 		"%s(): board vendor 0x%x, revision 0x%x\n",
 		__func__, board_vendor, board_revision);
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev, 0xffffffff)) {
+	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
 		dev_err(&pci_dev->dev,
 			"%s(): 32bit PCI DMA is not supported\n", __func__);
 		goto pci_detect_err;
_

Patches currently in -mm which might be from hch@lst.de are


