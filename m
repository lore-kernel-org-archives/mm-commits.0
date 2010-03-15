From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:43 -0400
Message-ID: <201003150704.o2F74GYl017001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935969Ab0COHE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, benh@kernel.crashing.org, davem@davemloft.net, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, linux@arm.linux.


The patch titled
     dma-mapping: dma-mapping.h: add dma_set_coherent_mask
has been removed from the -mm tree.  Its filename was
     dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: dma-mapping.h: add dma_set_coherent_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

dma_set_coherent_mask corresponds to pci_set_consistent_dma_mask.  This is
necessary to move to the generic device model DMA API from the PCI bus
specific API in the long term.

dma_set_coherent_mask works in the exact same way that
pci_set_consistent_dma_mask does.  So this patch also changes
pci_set_consistent_dma_mask to call dma_set_coherent_mask.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt   |   10 ++++++++++
 drivers/pci/pci.c           |    7 +++----
 include/linux/dma-mapping.h |    8 ++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mapping-dma-mappingh-add-dma_set_coherent_mask Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mapping-dma-mappingh-add-dma_set_coherent_mask
+++ a/Documentation/DMA-API.txt
@@ -167,6 +167,16 @@ parameters if it is.
 
 Returns: 0 if successful and a negative error if not.
 
+int
+dma_set_coherent_mask(struct device *dev, u64 mask)
+int
+pci_set_consistent_dma_mask(struct pci_device *dev, u64 mask)
+
+Checks to see if the mask is possible and updates the device
+parameters if it is.
+
+Returns: 0 if successful and a negative error if not.
+
 u64
 dma_get_required_mask(struct device *dev)
 
diff -puN drivers/pci/pci.c~dma-mapping-dma-mappingh-add-dma_set_coherent_mask drivers/pci/pci.c
--- a/drivers/pci/pci.c~dma-mapping-dma-mappingh-add-dma_set_coherent_mask
+++ a/drivers/pci/pci.c
@@ -2315,12 +2315,11 @@ pci_set_dma_mask(struct pci_dev *dev, u6
 int
 pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 {
-	if (!pci_dma_supported(dev, mask))
-		return -EIO;
+	int ret = dma_set_coherent_mask(&dev->dev, mask);
+	if (ret)
+		return ret;
 
-	dev->dev.coherent_dma_mask = mask;
 	dev_dbg(&dev->dev, "using %dbit consistent DMA mask\n", fls64(mask));
-
 	return 0;
 }
 #endif
diff -puN include/linux/dma-mapping.h~dma-mapping-dma-mappingh-add-dma_set_coherent_mask include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-dma-mappingh-add-dma_set_coherent_mask
+++ a/include/linux/dma-mapping.h
@@ -127,6 +127,14 @@ static inline u64 dma_get_mask(struct de
 	return DMA_BIT_MASK(32);
 }
 
+static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if (!dma_supported(dev, mask))
+		return -EIO;
+	dev->coherent_dma_mask = mask;
+	return 0;
+}
+
 extern u64 dma_get_required_mask(struct device *dev);
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

