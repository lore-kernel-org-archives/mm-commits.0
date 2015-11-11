From: akpm@linux-foundation.org
Subject: [merged]
 tw68-core-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch removed
 from -mm tree
Date: Wed, 11 Nov 2015 11:48:16 -0800
Message-ID: <56439b80.tydfJ7dQP1/J7ui/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbbKKTsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hverkuil@xs4all.nl, mchehab@osg.samsung.com, pawel@osciak.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tw68-core: use pci_set_dma_mask insted of pci_dma_supported
has been removed from the -mm tree.  Its filename was
     tw68-core-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: tw68-core: use pci_set_dma_mask insted of pci_dma_supported

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Pawel Osciak <pawel@osciak.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/tw68/tw68-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/pci/tw68/tw68-core.c~tw68-core-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/tw68/tw68-core.c
--- a/drivers/media/pci/tw68/tw68-core.c~tw68-core-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/tw68/tw68-core.c
@@ -257,7 +257,7 @@ static int tw68_initdev(struct pci_dev *
 		dev->name, pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 		dev->pci_lat, (u64)pci_resource_start(pci_dev, 0));
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev, DMA_BIT_MASK(32))) {
+	if (!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32))) {
 		pr_info("%s: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail1;
_

Patches currently in -mm which might be from hch@lst.de are


