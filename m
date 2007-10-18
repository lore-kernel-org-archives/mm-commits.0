From: akpm@linux-foundation.org
Subject: - cciss-fix-error-reporting-for-sg_io.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:26 -0700
Message-ID: <200710180659.l9I6vQrl030816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812AbXJRHAP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:00:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@quandary.americas.cpqcorp.net, mike.miller@hp.com, steve.cameron@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix error reporting for SG_IO
has been removed from the -mm tree.  Its filename was
     cciss-fix-error-reporting-for-sg_io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cciss: fix error reporting for SG_IO
From: Steve Cameron <scameron@quandary.americas.cpqcorp.net>

This fixes a problem with the way cciss was filling out the "errors" field
of the request structure upon completion of requests.  Previously, it just
put a 1 or a 0 in there and used the negation of this as the uptodate
parameter to one of the functions in the block layer, being a block device.
 For the SG_IO ioctl, this was not sufficient, and we noticed that, for
example, sg_turs from sg3_utils did not correctly detect problems due to
cciss having set rq->errors incorrectly.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   79 ++++++++++++++++++++++++++++++----------
 1 file changed, 61 insertions(+), 18 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-error-reporting-for-sg_io drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-error-reporting-for-sg_io
+++ a/drivers/block/cciss.c
@@ -2365,30 +2365,55 @@ static inline void resend_cciss_cmd(ctlr
 	start_io(h);
 }
 
+static inline unsigned int make_status_bytes(unsigned int scsi_status_byte,
+	unsigned int msg_byte, unsigned int host_byte,
+	unsigned int driver_byte)
+{
+	/* inverse of macros in scsi.h */
+	return (scsi_status_byte & 0xff) |
+		((msg_byte & 0xff) << 8) |
+		((host_byte & 0xff) << 16) |
+		((driver_byte & 0xff) << 24);
+}
+
 static inline int evaluate_target_status(CommandList_struct *cmd)
 {
 	unsigned char sense_key;
-	int error_count = 1;
+	unsigned char status_byte, msg_byte, host_byte, driver_byte;
+	int error_value;
+
+	/* If we get in here, it means we got "target status", that is, scsi status */
+	status_byte = cmd->err_info->ScsiStatus;
+	driver_byte = DRIVER_OK;
+	msg_byte = cmd->err_info->CommandStatus; /* correct?  seems too device specific */
+
+	if (blk_pc_request(cmd->rq))
+		host_byte = DID_PASSTHROUGH;
+	else
+		host_byte = DID_OK;
+
+	error_value = make_status_bytes(status_byte, msg_byte,
+		host_byte, driver_byte);
 
-	if (cmd->err_info->ScsiStatus != 0x02) { /* not check condition? */
+	if (cmd->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION) {
 		if (!blk_pc_request(cmd->rq))
 			printk(KERN_WARNING "cciss: cmd %p "
 			       "has SCSI Status 0x%x\n",
 			       cmd, cmd->err_info->ScsiStatus);
-		return error_count;
+		return error_value;
 	}
 
 	/* check the sense key */
 	sense_key = 0xf & cmd->err_info->SenseInfo[2];
 	/* no status or recovered error */
-	if ((sense_key == 0x0) || (sense_key == 0x1))
-		error_count = 0;
+	if (((sense_key == 0x0) || (sense_key == 0x1)) && !blk_pc_request(cmd->rq))
+		error_value = 0;
 
 	if (!blk_pc_request(cmd->rq)) { /* Not SG_IO or similar? */
-		if (error_count != 0)
+		if (error_value != 0)
 			printk(KERN_WARNING "cciss: cmd %p has CHECK CONDITION"
 			       " sense key = 0x%x\n", cmd, sense_key);
-		return error_count;
+		return error_value;
 	}
 
 	/* SG_IO or similar, copy sense data back */
@@ -2400,7 +2425,7 @@ static inline int evaluate_target_status
 	} else
 		cmd->rq->sense_len = 0;
 
-	return error_count;
+	return error_value;
 }
 
 /* checks the status of the job and calls complete buffers to mark all
@@ -2416,7 +2441,7 @@ static inline void complete_command(ctlr
 	rq->errors = 0;
 
 	if (timeout)
-		rq->errors = 1;
+		rq->errors = make_status_bytes(0, 0, 0, DRIVER_TIMEOUT);
 
 	if (cmd->err_info->CommandStatus == 0)	/* no error has occurred */
 		goto after_error_processing;
@@ -2442,32 +2467,44 @@ static inline void complete_command(ctlr
 	case CMD_INVALID:
 		printk(KERN_WARNING "cciss: cmd %p is "
 		       "reported invalid\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_PROTOCOL_ERR:
 		printk(KERN_WARNING "cciss: cmd %p has "
 		       "protocol error \n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_HARDWARE_ERR:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       " hardware error\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_CONNECTION_LOST:
 		printk(KERN_WARNING "cciss: cmd %p had "
 		       "connection lost\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_ABORTED:
 		printk(KERN_WARNING "cciss: cmd %p was "
 		       "aborted\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_ABORT_FAILED:
 		printk(KERN_WARNING "cciss: cmd %p reports "
 		       "abort failed\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	case CMD_UNSOLICITED_ABORT:
 		printk(KERN_WARNING "cciss%d: unsolicited "
@@ -2481,17 +2518,23 @@ static inline void complete_command(ctlr
 			printk(KERN_WARNING
 			       "cciss%d: %p retried too "
 			       "many times\n", h->ctlr, cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ABORT);
 		break;
 	case CMD_TIMEOUT:
 		printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 		break;
 	default:
 		printk(KERN_WARNING "cciss: cmd %p returned "
 		       "unknown status %x\n", cmd,
 		       cmd->err_info->CommandStatus);
-		rq->errors = 1;
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			blk_pc_request(cmd->rq) ? DID_PASSTHROUGH : DID_ERROR);
 	}
 
 after_error_processing:
_

Patches currently in -mm which might be from scameron@quandary.americas.cpqcorp.net are

origin.patch
