From: akpm@linux-foundation.org
Subject: + pci-remove-pci_dma_supported.patch added to -mm tree
Date: Mon, 05 Oct 2015 14:29:32 -0700
Message-ID: <5612ebbc.ThnMtPKmm9d/Ih8/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbbJEV3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: pci: remove pci_dma_supported
has been added to the -mm tree.  Its filename is
     pci-remove-pci_dma_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pci-remove-pci_dma_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pci-remove-pci_dma_supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
