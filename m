From: akpm@linux-foundation.org
Subject: + ub-remove-bug-after-__blk_end_request-and-fix-the-condition-causing-it.patch added to -mm tree
Date: Fri, 04 Apr 2008 12:55:39 -0700
Message-ID: <200804041955.m34Jtdfi006321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbYDDT60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2008 15:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zaitcev@redhat.com, bharrosh@panasas.com, greg@kroah.com, k-ueda@ct.jp.nec.com, schwidefsky@de.ibm.com


The patch titled
     ub: remove BUG() after __blk_end_request and fix the condition causing it
has been added to the -mm tree.  Its filename is
     ub-remove-bug-after-__blk_end_request-and-fix-the-condition-causing-it.patch

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
Subject: ub: remove BUG() after __blk_end_request and fix the condition causing it
From: Pete Zaitcev <zaitcev@redhat.com>

When __blk_end_request returns nonzero, it means that the request was
not completely processed and some BIOs are still attached. Since we
have dequeued it by that time, it means leaking requests and hanging
processes, which is why BUG() was in there. In ub this happens if
a packet request ends normally, but with residue (e.g. when scsi_id
issues INQUIRY).

The fix is to make sure that arguments passed to __blk_end_request
are correct: the full request length and not just transferred length.
The transferred length is indicated to applications by adjusting
rq->data_len with old, unchanged code outside of this patch.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Greg KH <greg@kroah.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/ub.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff -puN drivers/block/ub.c~ub-remove-bug-after-__blk_end_request-and-fix-the-condition-causing-it drivers/block/ub.c
--- a/drivers/block/ub.c~ub-remove-bug-after-__blk_end_request-and-fix-the-condition-causing-it
+++ a/drivers/block/ub.c
@@ -8,6 +8,7 @@
  * and is not licensed separately. See file COPYING for details.
  *
  * TODO (sorted by decreasing priority)
+ *  -- Return sense now that rq allows it (we always auto-sense anyway).
  *  -- set readonly flag for CDs, set removable flag for CF readers
  *  -- do inquiry and verify we got a disk and not a tape (for LUN mismatch)
  *  -- verify the 13 conditions and do bulk resets
@@ -359,7 +360,8 @@ static void ub_cmd_build_block(struct ub
 static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_scsi_cmd *cmd, struct ub_request *urq);
 static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
-static void ub_end_rq(struct request *rq, unsigned int status);
+static void ub_end_rq(struct request *rq, unsigned int status,
+    unsigned int cmd_len);
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
     struct ub_request *urq, struct ub_scsi_cmd *cmd);
 static int ub_submit_scsi(struct ub_dev *sc, struct ub_scsi_cmd *cmd);
@@ -642,13 +644,13 @@ static int ub_request_fn_1(struct ub_lun
 
 	if (atomic_read(&sc->poison)) {
 		blkdev_dequeue_request(rq);
-		ub_end_rq(rq, DID_NO_CONNECT << 16);
+		ub_end_rq(rq, DID_NO_CONNECT << 16, blk_rq_bytes(rq));
 		return 0;
 	}
 
 	if (lun->changed && !blk_pc_request(rq)) {
 		blkdev_dequeue_request(rq);
-		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION);
+		ub_end_rq(rq, SAM_STAT_CHECK_CONDITION, blk_rq_bytes(rq));
 		return 0;
 	}
 
@@ -701,7 +703,7 @@ static int ub_request_fn_1(struct ub_lun
 
 drop:
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, DID_ERROR << 16);
+	ub_end_rq(rq, DID_ERROR << 16, blk_rq_bytes(rq));
 	return 0;
 }
 
@@ -770,6 +772,7 @@ static void ub_rw_cmd_done(struct ub_dev
 	struct ub_request *urq = cmd->back;
 	struct request *rq;
 	unsigned int scsi_status;
+	unsigned int cmd_len;
 
 	rq = urq->rq;
 
@@ -779,8 +782,18 @@ static void ub_rw_cmd_done(struct ub_dev
 				rq->data_len = 0;
 			else
 				rq->data_len -= cmd->act_len;
+			scsi_status = 0;
+		} else {
+			if (cmd->act_len != cmd->len) {
+				if ((cmd->key == MEDIUM_ERROR ||
+				     cmd->key == UNIT_ATTENTION) &&
+				    ub_rw_cmd_retry(sc, lun, urq, cmd) == 0)
+					return;
+				scsi_status = SAM_STAT_CHECK_CONDITION;
+			} else {
+				scsi_status = 0;
+			}
 		}
-		scsi_status = 0;
 	} else {
 		if (blk_pc_request(rq)) {
 			/* UB_SENSE_SIZE is smaller than SCSI_SENSE_BUFFERSIZE */
@@ -801,14 +814,17 @@ static void ub_rw_cmd_done(struct ub_dev
 
 	urq->rq = NULL;
 
+	cmd_len = cmd->len;
 	ub_put_cmd(lun, cmd);
-	ub_end_rq(rq, scsi_status);
+	ub_end_rq(rq, scsi_status, cmd_len);
 	blk_start_queue(lun->disk->queue);
 }
 
-static void ub_end_rq(struct request *rq, unsigned int scsi_status)
+static void ub_end_rq(struct request *rq, unsigned int scsi_status,
+    unsigned int cmd_len)
 {
 	int error;
+	long rqlen;
 
 	if (scsi_status == 0) {
 		error = 0;
@@ -816,8 +832,12 @@ static void ub_end_rq(struct request *rq
 		error = -EIO;
 		rq->errors = scsi_status;
 	}
-	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
-		BUG();
+	rqlen = blk_rq_bytes(rq);    /* Oddly enough, this is the residue. */
+	if (__blk_end_request(rq, error, cmd_len)) {
+		printk(KERN_WARNING DRV_NAME
+		    ": __blk_end_request blew, %s-cmd total %u rqlen %ld\n",
+		    blk_pc_request(rq)? "pc": "fs", cmd_len, rqlen);
+	}
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
_

Patches currently in -mm which might be from zaitcev@redhat.com are

ub-remove-bug-after-__blk_end_request-and-fix-the-condition-causing-it.patch
git-hid.patch

