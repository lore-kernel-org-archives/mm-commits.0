From: akpm@linux-foundation.org
Subject: - ub-fix-up-the-conversion-to-sg_init_table.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:14 -0800
Message-ID: <200802132015.m1DKFEKe011352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761319AbYBMUPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, oliver.pntr@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ub: fix up the conversion to sg_init_table()
has been removed from the -mm tree.  Its filename was
     ub-fix-up-the-conversion-to-sg_init_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ub: fix up the conversion to sg_init_table()
From: Pete Zaitcev <zaitcev@redhat.com>

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/ub.c~ub-fix-up-the-conversion-to-sg_init_table drivers/block/ub.c
--- a/drivers/block/ub.c~ub-fix-up-the-conversion-to-sg_init_table
+++ a/drivers/block/ub.c
@@ -657,7 +657,6 @@ static int ub_request_fn_1(struct ub_lun
 	if ((cmd = ub_get_cmd(lun)) == NULL)
 		return -1;
 	memset(cmd, 0, sizeof(struct ub_scsi_cmd));
-	sg_init_table(cmd->sgv, UB_MAX_REQ_SG);
 
 	blkdev_dequeue_request(rq);
 
@@ -668,6 +667,7 @@ static int ub_request_fn_1(struct ub_lun
 	/*
 	 * get scatterlist from block layer
 	 */
+	sg_init_table(&urq->sgv[0], UB_MAX_REQ_SG);
 	n_elem = blk_rq_map_sg(lun->disk->queue, rq, &urq->sgv[0]);
 	if (n_elem < 0) {
 		/* Impossible, because blk_rq_map_sg should not hit ENOMEM. */
_

Patches currently in -mm which might be from zaitcev@redhat.com are

usb-libusual-locking-cleanup.patch
