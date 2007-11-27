From: akpm@linux-foundation.org
Subject: + call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:39:54 -0800
Message-ID: <200711270439.lAR4dsHs027210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbXK0Ek1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:40:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com


The patch titled
     iommu sg merging: call dma_set_seg_boundary in __scsi_alloc_queue()
has been added to the -mm tree.  Its filename is
     call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg merging: call dma_set_seg_boundary in __scsi_alloc_queue()
From: FUJITA Tomonori <tomof@acm.org>

This is a one-line patch to add the following to __scsi_alloc_queue():

dma_set_seg_boundary(dev, shost->dma_boundary);

This is the simplest approach but the result looks odd,
__scsi_alloc_queue() does:

blk_queue_segment_boundary(q, shost->dma_boundary);
dma_set_seg_boundary(dev, shost->dma_boundary);
blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));

I think that it would be better to set up segment boundary in the same
way as we did for the maximum segment size. That is, removing
shost->dma_boundary and LLDs call pci_set_dma_seg_boundary (or its
friends).

Then __scsi_alloc_queue() can set up both limits in the same way:

blk_queue_segment_boundary(q, dma_get_seg_boundary(dev));
blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));

killing dma_boundary in scsi_host_template needs a large patch for
libata (dma_boundary is used by only libata and sym53c8xx). I'll send
a patch to do that if it is acceptable. James and Jeff?

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/scsi_lib.c~call-dma_set_seg_boundary-in-__scsi_alloc_queue drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~call-dma_set_seg_boundary-in-__scsi_alloc_queue
+++ a/drivers/scsi/scsi_lib.c
@@ -1773,6 +1773,7 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
+	dma_set_seg_boundary(dev, shost->dma_boundary);
 
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
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
