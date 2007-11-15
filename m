From: akpm@linux-foundation.org
Subject: + iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:05:35 -0800
Message-ID: <200711152205.lAFM5ZZ6018109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765726AbXKOWdC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:33:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com


The patch titled
     iommu sg merging: call blk_queue_segment_boundary in __scsi_alloc_queue
has been added to the -mm tree.  Its filename is
     iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/scsi/scsi_lib.c~iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue
+++ a/drivers/scsi/scsi_lib.c
@@ -1711,6 +1711,7 @@ struct request_queue *__scsi_alloc_queue
 					 request_fn_proc *request_fn)
 {
 	struct request_queue *q;
+	struct device *dev = shost->shost_gendev.parent;
 
 	q = blk_init_queue(request_fn, NULL);
 	if (!q)
@@ -1739,6 +1740,8 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 
+	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
+
 	if (!shost->use_clustering)
 		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	return q;
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
