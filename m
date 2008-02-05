From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:28 -0800
Message-ID: <200802052228.m15MS9NT011861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762829AbYBEWoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mark_salyzyn@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: aacraid: use pci_set_dma_max_seg_size
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: aacraid: use pci_set_dma_max_seg_size
From: FUJITA Tomonori <tomof@acm.org>

This sets the segment size limit properly via pci_set_dma_max_seg_size
and remove blk_queue_max_segment_size because scsi-ml calls it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/linit.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aacraid/linit.c~iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size
+++ a/drivers/scsi/aacraid/linit.c
@@ -449,9 +449,6 @@ static int aac_slave_configure(struct sc
 		else if (depth < 2)
 			depth = 2;
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
-		if (!(((struct aac_dev *)host->hostdata)->adapter_info.options &
-				AAC_OPT_NEW_COMM))
-			blk_queue_max_segment_size(sdev->request_queue, 65536);
 	} else
 		scsi_adjust_queue_depth(sdev, 0, 1);
 
@@ -1133,6 +1130,12 @@ static int __devinit aac_probe_one(struc
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

origin.patch
