From: akpm@linux-foundation.org
Subject: + cciss-reformat-error-handling.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:36:18 -0700
Message-ID: <200704110036.l3B0aIwc024285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359AbXDKAjm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikem@beardog.cca.cpqcorp.net, James.Bottomley@steeleye.com, jens.axboe@oracle.com, mike.miller@hp.com, steve.cameron@hp.com


The patch titled
     cciss: reformat error handling
has been added to the -mm tree.  Its filename is
     cciss-reformat-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cciss: reformat error handling
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>

Reformat some error handling code to reduce line lengths a bit.

Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |  176 ++++++++++++++++++++--------------------
 1 files changed, 90 insertions(+), 86 deletions(-)

diff -puN drivers/block/cciss.c~cciss-reformat-error-handling drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-reformat-error-handling
+++ a/drivers/block/cciss.c
@@ -2349,95 +2349,99 @@ static inline void complete_command(ctlr
 	if (timeout)
 		status = 0;
 
-	if (cmd->err_info->CommandStatus != 0) {	/* an error has occurred */
-		switch (cmd->err_info->CommandStatus) {
-			unsigned char sense_key;
-		case CMD_TARGET_STATUS:
-			status = 0;
-
-			if (cmd->err_info->ScsiStatus == 0x02) {
-				printk(KERN_WARNING "cciss: cmd %p "
-				       "has CHECK CONDITION "
-				       " byte 2 = 0x%x\n", cmd,
-				       cmd->err_info->SenseInfo[2]
-				    );
-				/* check the sense key */
-				sense_key = 0xf & cmd->err_info->SenseInfo[2];
-				/* no status or recovered error */
-				if ((sense_key == 0x0) || (sense_key == 0x1)) {
-					status = 1;
-				}
-			} else {
-				printk(KERN_WARNING "cciss: cmd %p "
-				       "has SCSI Status 0x%x\n",
-				       cmd, cmd->err_info->ScsiStatus);
+	if (cmd->err_info->CommandStatus == 0)	/* no error has occurred */
+		goto after_error_processing;
+
+	switch (cmd->err_info->CommandStatus) {
+		unsigned char sense_key;
+	case CMD_TARGET_STATUS:
+		status = 0;
+
+		if (cmd->err_info->ScsiStatus == 0x02) {
+			printk(KERN_WARNING "cciss: cmd %p "
+			       "has CHECK CONDITION "
+			       " byte 2 = 0x%x\n", cmd,
+			       cmd->err_info->SenseInfo[2]
+			    );
+			/* check the sense key */
+			sense_key = 0xf & cmd->err_info->SenseInfo[2];
+			/* no status or recovered error */
+			if ((sense_key == 0x0) || (sense_key == 0x1)) {
+				status = 1;
 			}
-			break;
-		case CMD_DATA_UNDERRUN:
-			printk(KERN_WARNING "cciss: cmd %p has"
-			       " completed with data underrun "
-			       "reported\n", cmd);
-			break;
-		case CMD_DATA_OVERRUN:
-			printk(KERN_WARNING "cciss: cmd %p has"
-			       " completed with data overrun "
-			       "reported\n", cmd);
-			break;
-		case CMD_INVALID:
-			printk(KERN_WARNING "cciss: cmd %p is "
-			       "reported invalid\n", cmd);
-			status = 0;
-			break;
-		case CMD_PROTOCOL_ERR:
-			printk(KERN_WARNING "cciss: cmd %p has "
-			       "protocol error \n", cmd);
-			status = 0;
-			break;
-		case CMD_HARDWARE_ERR:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       " hardware error\n", cmd);
-			status = 0;
-			break;
-		case CMD_CONNECTION_LOST:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       "connection lost\n", cmd);
-			status = 0;
-			break;
-		case CMD_ABORTED:
-			printk(KERN_WARNING "cciss: cmd %p was "
-			       "aborted\n", cmd);
-			status = 0;
-			break;
-		case CMD_ABORT_FAILED:
-			printk(KERN_WARNING "cciss: cmd %p reports "
-			       "abort failed\n", cmd);
-			status = 0;
-			break;
-		case CMD_UNSOLICITED_ABORT:
-			printk(KERN_WARNING "cciss%d: unsolicited "
-			       "abort %p\n", h->ctlr, cmd);
-			if (cmd->retry_count < MAX_CMD_RETRIES) {
-				retry_cmd = 1;
-				printk(KERN_WARNING
-				       "cciss%d: retrying %p\n", h->ctlr, cmd);
-				cmd->retry_count++;
-			} else
-				printk(KERN_WARNING
-				       "cciss%d: %p retried too "
-				       "many times\n", h->ctlr, cmd);
-			status = 0;
-			break;
-		case CMD_TIMEOUT:
-			printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
-			status = 0;
-			break;
-		default:
-			printk(KERN_WARNING "cciss: cmd %p returned "
-			       "unknown status %x\n", cmd,
-			       cmd->err_info->CommandStatus);
-			status = 0;
+		} else {
+			printk(KERN_WARNING "cciss: cmd %p "
+			       "has SCSI Status 0x%x\n",
+			       cmd, cmd->err_info->ScsiStatus);
 		}
+		break;
+	case CMD_DATA_UNDERRUN:
+		printk(KERN_WARNING "cciss: cmd %p has"
+		       " completed with data underrun "
+		       "reported\n", cmd);
+		break;
+	case CMD_DATA_OVERRUN:
+		printk(KERN_WARNING "cciss: cmd %p has"
+		       " completed with data overrun "
+		       "reported\n", cmd);
+		break;
+	case CMD_INVALID:
+		printk(KERN_WARNING "cciss: cmd %p is "
+		       "reported invalid\n", cmd);
+		status = 0;
+		break;
+	case CMD_PROTOCOL_ERR:
+		printk(KERN_WARNING "cciss: cmd %p has "
+		       "protocol error \n", cmd);
+		status = 0;
+		break;
+	case CMD_HARDWARE_ERR:
+		printk(KERN_WARNING "cciss: cmd %p had "
+		       " hardware error\n", cmd);
+		status = 0;
+		break;
+	case CMD_CONNECTION_LOST:
+		printk(KERN_WARNING "cciss: cmd %p had "
+		       "connection lost\n", cmd);
+		status = 0;
+		break;
+	case CMD_ABORTED:
+		printk(KERN_WARNING "cciss: cmd %p was "
+		       "aborted\n", cmd);
+		status = 0;
+		break;
+	case CMD_ABORT_FAILED:
+		printk(KERN_WARNING "cciss: cmd %p reports "
+		       "abort failed\n", cmd);
+		status = 0;
+		break;
+	case CMD_UNSOLICITED_ABORT:
+		printk(KERN_WARNING "cciss%d: unsolicited "
+		       "abort %p\n", h->ctlr, cmd);
+		if (cmd->retry_count < MAX_CMD_RETRIES) {
+			retry_cmd = 1;
+			printk(KERN_WARNING
+			       "cciss%d: retrying %p\n", h->ctlr, cmd);
+			cmd->retry_count++;
+		} else
+			printk(KERN_WARNING
+			       "cciss%d: %p retried too "
+			       "many times\n", h->ctlr, cmd);
+		status = 0;
+		break;
+	case CMD_TIMEOUT:
+		printk(KERN_WARNING "cciss: cmd %p timedout\n", cmd);
+		status = 0;
+		break;
+	default:
+		printk(KERN_WARNING "cciss: cmd %p returned "
+		       "unknown status %x\n", cmd,
+		       cmd->err_info->CommandStatus);
+		status = 0;
 	}
+
+after_error_processing:
+
 	/* We need to return this command */
 	if (retry_cmd) {
 		resend_cciss_cmd(h, cmd);
_

Patches currently in -mm which might be from mikem@beardog.cca.cpqcorp.net are

cciss-reformat-error-handling.patch
cciss-add-sg_io-ioctl-to-cciss.patch
cciss-set-rq-errors-more-correctly-in-driver.patch
