From: akpm@linux-foundation.org
Subject: + pci-add-dma-segment-boundary-support.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:39:50 -0800
Message-ID: <200711270439.lAR4doRK027204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbXK0Ek1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:40:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com


The patch titled
     iommu sg merging: PCI: add dma segment boundary support
has been added to the -mm tree.  Its filename is
     pci-add-dma-segment-boundary-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 include/linux/pci.h |    2 ++
 3 files changed, 11 insertions(+)

diff -puN drivers/pci/pci.c~pci-add-dma-segment-boundary-support drivers/pci/pci.c
--- a/drivers/pci/pci.c~pci-add-dma-segment-boundary-support
+++ a/drivers/pci/pci.c
@@ -1426,6 +1426,14 @@ int pci_set_dma_max_seg_size(struct pci_
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
@@ -978,6 +978,7 @@ void pci_device_add(struct pci_dev *dev,
 	dev->dev.coherent_dma_mask = 0xffffffffull;
 
 	pci_set_dma_max_seg_size(dev, 65536);
+	pci_set_dma_seg_boundary(dev, 0xffffffff);
 
 	/* Fix up broken headers */
 	pci_fixup_device(pci_fixup_header, dev);
diff -puN include/linux/pci.h~pci-add-dma-segment-boundary-support include/linux/pci.h
--- a/include/linux/pci.h~pci-add-dma-segment-boundary-support
+++ a/include/linux/pci.h
@@ -567,6 +567,7 @@ void pci_msi_off(struct pci_dev *dev);
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
+int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
 int pcix_get_mmrbc(struct pci_dev *dev);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc);
@@ -752,6 +753,7 @@ static inline int pci_enable_device(stru
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pci_set_dma_mask(struct pci_dev *dev, u64 mask) { return -EIO; }
 static inline int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size) { return -EIO; }
+static inline int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask) { return -EIO; }
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
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
alpha-kill-deprecated-virt_to_bus.patch
