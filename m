From: akpm@linux-foundation.org
Subject: [merged]
 cx23885-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:26 -0800
Message-ID: <56439b8a.4cGH8b87beipMAti%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbKKTs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, hans.verkuil@cisco.com, mchehab@osg.samsung.com, pawel@osciak.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cx23885: use pci_set_dma_mask insted of pci_dma_supported
has been removed from the -mm tree.  Its filename was
     cx23885-use-pci_set_dma_mask-insted-of-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: cx23885: use pci_set_dma_mask insted of pci_dma_supported

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Pawel Osciak <pawel@osciak.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/cx23885/cx23885-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/pci/cx23885/cx23885-core.c~cx23885-use-pci_set_dma_mask-insted-of-pci_dma_supported drivers/media/pci/cx23885/cx23885-core.c
--- a/drivers/media/pci/cx23885/cx23885-core.c~cx23885-use-pci_set_dma_mask-insted-of-pci_dma_supported
+++ a/drivers/media/pci/cx23885/cx23885-core.c
@@ -1992,7 +1992,7 @@ static int cx23885_initdev(struct pci_de
 		(unsigned long long)pci_resource_start(pci_dev, 0));
 
 	pci_set_master(pci_dev);
-	if (!pci_dma_supported(pci_dev, 0xffffffff)) {
+	if (!pci_set_dma_mask(pci_dev, 0xffffffff)) {
 		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail_context;
_

Patches currently in -mm which might be from hch@lst.de are


