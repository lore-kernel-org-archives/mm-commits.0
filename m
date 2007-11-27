From: akpm@linux-foundation.org
Subject: + add-accessors-for-segment_boundary_mask-in.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:39:48 -0800
Message-ID: <200711270439.lAR4dmBt027201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923AbXK0Ek1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:40:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com


The patch titled
     iommu sg merging: add accessors for segment_boundary_mask in device_dma_parameters()
has been added to the -mm tree.  Its filename is
     add-accessors-for-segment_boundary_mask-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg merging: add accessors for segment_boundary_mask in device_dma_parameters()
From: FUJITA Tomonori <tomof@acm.org>

This adds new accessors for segment_boundary_mask in device_dma_parameters
structure in the same way I did for max_segment_size.  So we can easily change
where to place struct device_dma_parameters in the future.

dma_get_segment boundary returns 0xffffffff if dma_parms in struct device
isn't set up properly.  0xffffffff is the default value used in the block
layer and the scsi mid layer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/dma-mapping.h~add-accessors-for-segment_boundary_mask-in include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~add-accessors-for-segment_boundary_mask-in
+++ a/include/linux/dma-mapping.h
@@ -75,6 +75,21 @@ static inline unsigned int dma_set_max_s
 		return -EIO;
 }
 
+static inline unsigned long dma_get_seg_boundary(struct device *dev)
+{
+	return dev->dma_parms ?
+		dev->dma_parms->segment_boundary_mask : 0xffffffff;
+}
+
+static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
+{
+	if (dev->dma_parms) {
+		dev->dma_parms->segment_boundary_mask = mask;
+		return 0;
+	} else
+		return -EIO;
+}
+
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
 #define DMA_MEMORY_IO			0x02
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
