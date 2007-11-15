From: akpm@linux-foundation.org
Subject: + iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:05:39 -0800
Message-ID: <200711152205.lAFM5d3n018116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760770AbXKOWGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:06:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mark_salyzyn@adaptec.com


The patch titled
     iommu sg merging: aacraid: use pci_set_dma_max_seg_size
has been added to the -mm tree.  Its filename is
     iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg merging: aacraid: use pci_set_dma_max_seg_size
From: FUJITA Tomonori <tomof@acm.org>

This sets the segment size limit properly via pci_set_dma_max_seg_size
and remove blk_queue_max_segment_size because scsi-ml calls it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/linit.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aacraid/linit.c~iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size
+++ a/drivers/scsi/aacraid/linit.c
@@ -441,9 +441,6 @@ static int aac_slave_configure(struct sc
 		else if (depth < 2)
 			depth = 2;
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
-		if (!(((struct aac_dev *)host->hostdata)->adapter_info.options &
-				AAC_OPT_NEW_COMM))
-			blk_queue_max_segment_size(sdev->request_queue, 65536);
 	} else
 		scsi_adjust_queue_depth(sdev, 0, 1);
 
@@ -1055,6 +1052,12 @@ static int __devinit aac_probe_one(struc
 	if (error < 0)
 		goto out_deinit;
 
+	if (!(aac->adapter_info.options & AAC_OPT_NEW_COMM)) {
+		error = pci_set_dma_max_seg_size(pdev, 65536);
+		if (error)
+			goto out_deinit;
+	}
+
 	/*
  	 * Lets override negotiations and drop the maximum SG limit to 34
  	 */
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
