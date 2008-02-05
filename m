From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:22 -0800
Message-ID: <200802052228.m15MS3Or011853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761128AbYBEWnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: call blk_queue_segment_boundary in __scsi_alloc_queue
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: call blk_queue_segment_boundary in __scsi_alloc_queue
From: FUJITA Tomonori <tomof@acm.org>

request_queue and device struct must have the same value of a segment
size limit. This patch adds blk_queue_segment_boundary in
__scsi_alloc_queue so LLDs don't need to call both
blk_queue_segment_boundary and set_dma_max_seg_size. A LLD can change
the default value (64KB) can call device_dma_parameters accessors like
pci_set_dma_max_seg_size when allocating scsi_host.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/scsi_lib.c~iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue
+++ a/drivers/scsi/scsi_lib.c
@@ -1569,6 +1569,7 @@ struct request_queue *__scsi_alloc_queue
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
+	struct device *dev = shost->shost_gendev.parent;
 
 	q = blk_init_queue(request_fn, NULL);
 	if (!q)
@@ -1584,6 +1585,8 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 
+	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
+
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
