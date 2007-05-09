From: akpm@linux-foundation.org
Subject: - cciss-set-rq-errors-more-correctly-in-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:42 -0700
Message-ID: <200705090249.l492nghf009254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969816AbXEICt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikem@beardog.cca.cpqcorp.net, James.Bottomley@steeleye.com, jens.axboe@oracle.com, mike.miller@hp.com, steve.cameron@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: set rq->errors more correctly in driver
has been removed from the -mm tree.  Its filename was
     cciss-set-rq-errors-more-correctly-in-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: set rq->errors more correctly in driver
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

Set rq->errors more correctly in cciss driver.  Previously we had set it
synonymously with the meaning of the last parameter of end_that_last_request
and complete_buffers (the "uptodate" parameter) and had gotten away with it
for all this time because nobody ever looked at rq->errors. 
SCSI_IOCTL_SEND_COMMAND looks at rq->errors, so now it matters that it be
right.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   43 ++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN drivers/block/cciss.c~cciss-set-rq-errors-more-correctly-in-driver drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-set-rq-errors-more-correctly-in-driver
+++ a/drivers/block/cciss.c
@@ -1261,7 +1261,7 @@ static void cciss_softirq_done(struct re
 		pci_unmap_page(h->pdev, temp64.val, cmd->SG[i].Len, ddir);
 	}
 
-	complete_buffers(rq->bio, rq->errors);
+	complete_buffers(rq->bio, (rq->errors == 0));
 
 	if (blk_fs_request(rq)) {
 		const int rw = rq_data_dir(rq);
@@ -1275,7 +1275,7 @@ static void cciss_softirq_done(struct re
 
 	add_disk_randomness(rq->rq_disk);
 	spin_lock_irqsave(&h->lock, flags);
-	end_that_request_last(rq, rq->errors);
+	end_that_request_last(rq, (rq->errors == 0));
 	cmd_free(h, cmd, 1);
 	cciss_check_queues(h);
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -2366,27 +2366,27 @@ static inline void resend_cciss_cmd(ctlr
 static inline int evaluate_target_status(CommandList_struct *cmd)
 {
 	unsigned char sense_key;
-	int status = 0; /* 0 means bad, 1 means good. */
+	int error_count = 1;
 
 	if (cmd->err_info->ScsiStatus != 0x02) { /* not check condition? */
 		if (!blk_pc_request(cmd->rq))
 			printk(KERN_WARNING "cciss: cmd %p "
 			       "has SCSI Status 0x%x\n",
 			       cmd, cmd->err_info->ScsiStatus);
-		return status;
+		return error_count;
 	}
 
 	/* check the sense key */
 	sense_key = 0xf & cmd->err_info->SenseInfo[2];
 	/* no status or recovered error */
 	if ((sense_key == 0x0) || (sense_key == 0x1))
-		status = 1;
+		error_count = 0;
 
 	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
-		if (status == 0)
+		if (error_count != 0)
 			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
 			       " sense key = 0x%x\n", cmd, sense_key);
-		return status;
+		return error_count;
 	}
 
 	/* SG_IO or similar, copy sense data back */
@@ -2398,7 +2398,7 @@ static inline int evaluate_target_status
 	} else
 		cmd->rq->sense_len = 0;
 
-	return status;
+	return error_count;
 }
 
 /* checks the status of the job and calls complete buffers to mark all
@@ -2408,18 +2408,20 @@ static inline int evaluate_target_status
 static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 				    int timeout)
 {
-	int status = 1;
 	int retry_cmd = 0;
+	struct request *rq = cmd->rq;
+
+	rq->errors = 0;
 
 	if (timeout)
-		status = 0;
+		rq->errors = 1;
 
 	if (cmd->err_info->CommandStatus == 0)	/* no error has occurred */
 		goto after_error_processing;
 
 	switch (cmd->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		status = evaluate_target_status(cmd);
+		rq->errors = evaluate_target_status(cmd);
 		break;
 	case CMD_DATA_UNDERRUN:
 		if (blk_fs_request(cmd->rq)) {
@@ -2438,32 +2440,32 @@ static inline void complete_command(ctlr
 	case CMD_INVALID:
 		printk(KERN_WARNING "cciss: cmd %p is "
 		       "reported invalid\n", cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	case CMD_PROTOCOL_ERR:
 		printk(KERN_WARNING "cciss: cmd %p has "
 		       "protocol error \n", cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	case CMD_HARDWARE_ERR:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       " hardware error\n", cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	case CMD_CONNECTION_LOST:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       "connection lost\n", cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	case CMD_ABORTED:
 		printk(KERN_WARNING "cciss: cmd %p was "
 		       "aborted\n", cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	case CMD_ABORT_FAILED:
 		printk(KERN_WARNING "cciss: cmd %p reports "
 		       "abort failed\n", cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	case CMD_UNSOLICITED_ABORT:
 		printk(KERN_WARNING "cciss%d: unsolicited "
@@ -2477,17 +2479,17 @@ static inline void complete_command(ctlr
 			printk(KERN_WARNING
 			       "cciss%d: %p retried too "
 			       "many times\n", h->ctlr, cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	case CMD_TIMEOUT:
 		printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
-		status = 0;
+		rq->errors = 1;
 		break;
 	default:
 		printk(KERN_WARNING "cciss: cmd %p returned "
 		       "unknown status %x\n", cmd,
 		       cmd->err_info->CommandStatus);
-		status = 0;
+		rq->errors = 1;
 	}
 
 after_error_processing:
@@ -2498,7 +2500,6 @@ after_error_processing:
 		return;
 	}
 	cmd->rq->data_len = 0;
-	cmd->rq->errors = status;
 	cmd->rq->completion_data = cmd;
 	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
 	blk_complete_request(cmd->rq);
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

origin.patch
