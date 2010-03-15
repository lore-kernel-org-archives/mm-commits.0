From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:40 -0400
Message-ID: <201003150704.o2F74DGW016997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935969Ab0COHE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, benh@kernel.crashing.org, davem@davemloft.net, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, linux@arm.linux.


The patch titled
     dma-mapping: pci: convert pci_set_dma_mask to call dma_set_mask
has been removed from the -mm tree.  Its filename was
     dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: pci: convert pci_set_dma_mask to call dma_set_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This changes pci_set_dma_mask to call the generic DMA API, dma_set_mask.

pci_set_dma_mask (in drivers/pci/pci.c) does the same things that
dma_set_mask does on all the architectures that use pci_set_dma_mask;
calls dma_supprted and sets dev->dma_mask.  So we safely change
pci_set_dma_mask to simply call dma_set_mask.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/pci/pci.c~dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask drivers/pci/pci.c
--- a/drivers/pci/pci.c~dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask
+++ a/drivers/pci/pci.c
@@ -2305,15 +2305,13 @@ void pci_msi_off(struct pci_dev *dev)
 int
 pci_set_dma_mask(struct pci_dev *dev, u64 mask)
 {
-	if (!pci_dma_supported(dev, mask))
-		return -EIO;
-
-	dev->dma_mask = mask;
+	int ret = dma_set_mask(&dev->dev, mask);
+	if (ret)
+		return ret;
 	dev_dbg(&dev->dev, "using %dbit DMA mask\n", fls64(mask));
