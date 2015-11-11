From: akpm@linux-foundation.org
Subject: [merged] pci-remove-pci_dma_supported.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:39 -0800
Message-ID: <56439b97.bUEK4+Iurz7DIcY0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbbKKTsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pci: remove pci_dma_supported
has been removed from the -mm tree.  Its filename was
     pci-remove-pci_dma_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: pci: remove pci_dma_supported

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c            |    2 --
 include/asm-generic/pci-dma-compat.h |    6 ------
 2 files changed, 8 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~pci-remove-pci_dma_supported drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~pci-remove-pci_dma_supported
+++ a/drivers/parisc/ccio-dma.c
@@ -704,8 +704,6 @@ ccio_mark_invalid(struct ioc *ioc, dma_a
  * ccio_dma_supported - Verify the IOMMU supports the DMA address range.
  * @dev: The PCI device.
  * @mask: A bit mask describing the DMA address range of the device.
- *
- * This function implements the pci_dma_supported function.
  */
 static int 
 ccio_dma_supported(struct device *dev, u64 mask)
diff -puN include/asm-generic/pci-dma-compat.h~pci-remove-pci_dma_supported include/asm-generic/pci-dma-compat.h
--- a/include/asm-generic/pci-dma-compat.h~pci-remove-pci_dma_supported
+++ a/include/asm-generic/pci-dma-compat.h
@@ -6,12 +6,6 @@
 
 #include <linux/dma-mapping.h>
 
-static inline int
-pci_dma_supported(struct pci_dev *hwdev, u64 mask)
-{
-	return dma_supported(hwdev == NULL ? NULL : &hwdev->dev, mask);
-}
