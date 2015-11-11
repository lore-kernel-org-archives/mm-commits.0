From: akpm@linux-foundation.org
Subject: [merged]
 saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:18 -0800
Message-ID: <56439b82.GtZZ9t4RHV4VONwq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbbKKTsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hverkuil@xs4all.nl, mchehab@osg.samsung.com, stoth@kernellabs.com, mm-commits@vger.kernel.org


The patch titled
     Subject: saa7164: use pci_set_dma_mask insted of pci_dma_supported
has been removed from the -mm tree.  Its filename was
     saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: saa7164: use pci_set_dma_mask insted of pci_dma_supported

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/saa7164/saa7164-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/pci/saa7164/saa7164-core.c~saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/saa7164/saa7164-core.c
--- a/drivers/media/pci/saa7164/saa7164-core.c~saa7164-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/saa7164/saa7164-core.c
@@ -1264,7 +1264,7 @@ static int saa7164_initdev(struct pci_de
 
 	pci_set_master(pci_dev);
 	/* TODO */
-	if (!pci_dma_supported(pci_dev, 0xffffffff)) {
+	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail_irq;
_

Patches currently in -mm which might be from hch@lst.de are


