From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-pci-add-device_dma_parameters-support.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:00 -0800
Message-ID: <200802052227.m15MRfK4011821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762184AbYBEWoG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: PCI: add device_dma_parameters support
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-pci-add-device_dma_parameters-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: PCI: add device_dma_parameters support
From: FUJITA Tomonori <tomof@acm.org>

This adds struct device_dma_parameters in struct pci_dev and properly
sets up a pointer in struct device.

The default max_segment_size is set to 64K, same to the block layer's
default value.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mostly-acked-by: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |    8 ++++++++
 drivers/pci/probe.c |    3 +++
 include/linux/pci.h |    9 +++++++++
 3 files changed, 20 insertions(+)

diff -puN drivers/pci/pci.c~iommu-sg-merging-pci-add-device_dma_parameters-support drivers/pci/pci.c
--- a/drivers/pci/pci.c~iommu-sg-merging-pci-add-device_dma_parameters-support
+++ a/drivers/pci/pci.c
@@ -1451,6 +1451,14 @@ pci_set_consistent_dma_mask(struct pci_d
 }
 #endif
 
+#ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
+int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
+{
+	return dma_set_max_seg_size(&dev->dev, size);
+}
+EXPORT_SYMBOL(pci_set_dma_max_seg_size);
+#endif
+
 /**
  * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
  * @dev: PCI device to query
diff -puN drivers/pci/probe.c~iommu-sg-merging-pci-add-device_dma_parameters-support drivers/pci/probe.c
--- a/drivers/pci/probe.c~iommu-sg-merging-pci-add-device_dma_parameters-support
+++ a/drivers/pci/probe.c
@@ -933,8 +933,11 @@ void pci_device_add(struct pci_dev *dev,
 
 	set_dev_node(&dev->dev, pcibus_to_node(bus));
 	dev->dev.dma_mask = &dev->dma_mask;
+	dev->dev.dma_parms = &dev->dma_parms;
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
+	pci_set_dma_max_seg_size(dev, 65536);
+
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
 
diff -puN include/linux/pci.h~iommu-sg-merging-pci-add-device_dma_parameters-support include/linux/pci.h
--- a/include/linux/pci.h~iommu-sg-merging-pci-add-device_dma_parameters-support
+++ a/include/linux/pci.h
@@ -159,6 +159,8 @@ struct pci_dev {
 					   this if your device has broken DMA
 					   or supports 64-bit transfers.  */
 
+	struct device_dma_parameters dma_parms;
+
 	pci_power_t     current_state;  /* Current operating state. In ACPI-speak,
 					   this is D0-D3, D0 being fully functional,
 					   and D3 being off. */
@@ -580,6 +582,7 @@ void pci_intx(struct pci_dev *dev, int e
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
+int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
 int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
@@ -822,6 +825,12 @@ static inline int pci_set_dma_mask(struc
 	return -EIO;
 }
 
+static inline int pci_set_dma_max_seg_size(struct pci_dev *dev,
+					unsigned int size)
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
