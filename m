From: akpm@linux-foundation.org
Subject: - call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:55 -0800
Message-ID: <200802052228.m15MSaHr011901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762692AbYBEWoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: call dma_set_seg_boundary in __scsi_alloc_queue()
has been removed from the -mm tree.  Its filename was
     call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1584,6 +1584,7 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
+	dma_set_seg_boundary(dev, shost->dma_boundary);
 
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
