From: akpm@linux-foundation.org
Subject: [merged] cciss-factor-out-fix-target-status-processing-code-from-sendcmd-functions.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:19 -0700
Message-ID: <200906101756.n5AHuJ4s008365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754770AbZFJR43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: factor out fix target status processing code from sendcmd functions
has been removed from the -mm tree.  Its filename was
     cciss-factor-out-fix-target-status-processing-code-from-sendcmd-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: factor out fix target status processing code from sendcmd functions
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Factor out code to process target status of completed commands in
sendcmd() and sendcmd_withirq_core(), and fix problem that bad target
status was ignored in sendcmd_withirq_core.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   56 ++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff -puN drivers/block/cciss.c~cciss-factor-out-fix-target-status-processing-code-from-sendcmd-functions drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-factor-out-fix-target-status-processing-code-from-sendcmd-functions
+++ a/drivers/block/cciss.c
@@ -2267,6 +2267,31 @@ static int fill_cmd(CommandList_struct *
 	return status;
 }
 
+static int check_target_status(ctlr_info_t *h, CommandList_struct *c)
+{
+	switch (c->err_info->ScsiStatus) {
+	case SAM_STAT_GOOD:
+		return IO_OK;
+	case SAM_STAT_CHECK_CONDITION:
+		switch (0xf & c->err_info->SenseInfo[2]) {
+		case 0: return IO_OK; /* no sense */
+		case 1: return IO_OK; /* recovered error */
+		default:
+			printk(KERN_WARNING "cciss%d: cmd 0x%02x "
+				"check condition, sense key = 0x%02x\n",
+				h->ctlr, c->Request.CDB[0],
+				c->err_info->SenseInfo[2]);
+		}
+		break;
+	default:
+		printk(KERN_WARNING "cciss%d: cmd 0x%02x"
+			"scsi status = 0x%02x\n", h->ctlr,
+			c->Request.CDB[0], c->err_info->ScsiStatus);
+		break;
+	}
+	return IO_ERROR;
+}
+
 static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
@@ -2290,16 +2315,7 @@ resend_cmd2:
 
 	switch (c->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
-		printk(KERN_WARNING "cciss: cmd 0x%02x "
-		"has completed with errors\n", c->Request.CDB[0]);
-		if (c->err_info->ScsiStatus) {
-			printk(KERN_WARNING "cciss: cmd 0x%02x "
-			       "has SCSI Status = %x\n",
-			       c->Request.CDB[0], c->err_info->ScsiStatus);
-			if (c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION)
-				printk(KERN_WARNING "sense key = 0x%02x\n",
-					0xf & c->err_info->SenseInfo[2]);
-		}
+		return_status = check_target_status(h, c);
 		break;
 	case CMD_DATA_UNDERRUN:
 	case CMD_DATA_OVERRUN:
@@ -2710,33 +2726,29 @@ resend_cmd1:
 			printk(KERN_WARNING "cciss%d: retried %p too many "
 				"times\n", h->ctlr, c);
 			status = IO_ERROR;
-			goto cleanup1;
+			break;
 		}
 
 		if (c->err_info->CommandStatus == CMD_UNABORTABLE) {
 			printk(KERN_WARNING "cciss%d: command could not be "
 				"aborted.\n", h->ctlr);
 			status = IO_ERROR;
-			goto cleanup1;
+			break;
 		}
 
-		printk(KERN_WARNING "cciss%d: sendcmd error\n", h->ctlr);
-		printk(KERN_WARNING "cmd = 0x%02x, CommandStatus = 0x%02x\n",
-			c->Request.CDB[0], c->err_info->CommandStatus);
 		if (c->err_info->CommandStatus == CMD_TARGET_STATUS) {
-			printk(KERN_WARNING "Target status = 0x%02x\n",
-			c->err_info->ScsiStatus);
-			if (c->err_info->ScsiStatus == 2) /* chk cond */
-				printk(KERN_WARNING "Sense key = 0x%02x\n",
-					0xf & c->err_info->SenseInfo[2]);
+			status = check_target_status(h, c);
+			break;
 		}
 
+		printk(KERN_WARNING "cciss%d: sendcmd error\n", h->ctlr);
+		printk(KERN_WARNING "cmd = 0x%02x, CommandStatus = 0x%02x\n",
+			c->Request.CDB[0], c->err_info->CommandStatus);
 		status = IO_ERROR;
-		goto cleanup1;
+		break;
 
 	} while (1);
 
-cleanup1:
 	/* unlock the data buffer from DMA */
 	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
 	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

linux-next.patch

