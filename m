From: akpm@linux-foundation.org
Subject: + ub-fix-up-the-conversion-to-sg_init_table.patch added to -mm tree
Date: Sat, 09 Feb 2008 00:06:53 -0800
Message-ID: <200802090806.m1986Yds004504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35841 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbYBIIJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 9 Feb 2008 03:09:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, oliver.pntr@gmail.com


The patch titled
     ub: fix up the conversion to sg_init_table()
has been added to the -mm tree.  Its filename is
     ub-fix-up-the-conversion-to-sg_init_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
ub-fix-up-the-conversion-to-sg_init_table.patch
usb-libusual-locking-cleanup.patch
