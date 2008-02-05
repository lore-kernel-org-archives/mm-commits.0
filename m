From: akpm@linux-foundation.org
Subject: - pci-add-dma-segment-boundary-support.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:49 -0800
Message-ID: <200802052228.m15MSUas011892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761473AbYBEWoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: PCI: add dma segment boundary support
has been removed from the -mm tree.  Its filename was
     pci-add-dma-segment-boundary-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: PCI: add dma segment boundary support
From: FUJITA Tomonori <tomof@acm.org>

This adds PCI's accessor for segment_boundary_mask in device_dma_parameters.

The default segment_boundary is set to 0xffffffff, same to the block layer's
default value (and the scsi mid layer uses the same value).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |    8 ++++++++
 drivers/pci/probe.c |    1 +
 include/linux/pci.h |    7 +++++++
 3 files changed, 16 insertions(+)

diff -puN drivers/pci/pci.c~pci-add-dma-segment-boundary-support drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-add-dma-segment-boundary-support
+++ a/drivers/pci/pci.c
@@ -1459,6 +1459,14 @@ int pci_set_dma_max_seg_size(struct pci_
 EXPORT_SYMBOL(pci_set_dma_max_seg_size);
 #endif
 
+#ifndef HAVE_ARCH_PCI_SET_DMA_SEGMENT_BOUNDARY
+int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask)
+{
+	return dma_set_seg_boundary(&dev->dev, mask);
+}
+EXPORT_SYMBOL(pci_set_dma_seg_boundary);
+#endif
+
 /**
  * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
  * @dev: PCI device to query
diff -puN drivers/pci/probe.c~pci-add-dma-segment-boundary-support drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-add-dma-segment-boundary-support
+++ a/drivers/pci/probe.c
@@ -937,6 +937,7 @@ void pci_device_add(struct pci_dev *dev,
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
 	pci_set_dma_max_seg_size(dev, 65536);
+	pci_set_dma_seg_boundary(dev, 0xffffffff);
 
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
diff -puN include/linux/pci.h~pci-add-dma-segment-boundary-support include/linux/pci.h
--- a/include/linux/pci.h~pci-add-dma-segment-boundary-support
+++ a/include/linux/pci.h
@@ -583,6 +583,7 @@ void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
+int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
 int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
@@ -831,6 +832,12 @@ static inline int pci_set_dma_max_seg_si
 	return -EIO;
 }
 
+static inline int pci_set_dma_seg_boundary(struct pci_dev *dev,
+					unsigned long mask)
+{
+	return -EIO;
+}
+
 static inline int pci_assign_resource(struct pci_dev *dev, int i)
 {
 	return -EBUSY;
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
