From: akpm@linux-foundation.org
Subject: + iommu-sg-merging-pci-add-device_dma_parameters-support.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:05:19 -0800
Message-ID: <200711152205.lAFM5JYV018085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757809AbXKOWFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:05:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com


The patch titled
     iommu sg merging: PCI: add device_dma_parameters support
has been added to the -mm tree.  Its filename is
     iommu-sg-merging-pci-add-device_dma_parameters-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pci.c   |    8 ++++++++
 drivers/pci/probe.c |    3 +++
 include/linux/pci.h |    4 ++++
 3 files changed, 15 insertions(+)

diff -puN drivers/pci/pci.c~iommu-sg-merging-pci-add-device_dma_parameters-support drivers/pci/pci.c
--- a/drivers/pci/pci.c~iommu-sg-merging-pci-add-device_dma_parameters-support
+++ a/drivers/pci/pci.c
@@ -1418,6 +1418,14 @@ pci_set_consistent_dma_mask(struct pci_d
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
@@ -974,8 +974,11 @@ void pci_device_add(struct pci_dev *dev,
 
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
@@ -564,6 +566,7 @@ void pci_intx(struct pci_dev *dev, int e
 void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
+int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
 int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
@@ -748,6 +751,7 @@ static inline void pci_set_master(struct
 static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask) { return -EIO; }
+static inline int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size) { return -EIO; }
 static inline int pci_assign_resource(struct pci_dev *dev, int i) { return -EBUSY;}
 static inline int __pci_register_driver(struct pci_driver *drv, struct module *owner) { return 0;}
 static inline int pci_register_driver(struct pci_driver *drv) { return 0;}
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
