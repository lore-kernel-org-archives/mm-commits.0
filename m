From: akpm@linux-foundation.org
Subject: [merged] cciss-separate-error-processing-and-command-retrying-code-in-sendcmd_withirq_core.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:21 -0700
Message-ID: <200906101756.n5AHuLS6008368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971AbZFJR4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: separate error processing and command retrying code in sendcmd_withirq_core()
has been removed from the -mm tree.  Its filename was
     cciss-separate-error-processing-and-command-retrying-code-in-sendcmd_withirq_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: separate error processing and command retrying code in sendcmd_withirq_core()
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Separate the error processing from sendcmd_withirq_core from the code
which retries commands.  The rationale for this is that the SCSI error
handling code can then be made to use sendcmd_withirq_core, but avoid
retrying commands.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   77 +++++++++++++++++++++++-----------------
 drivers/block/cciss.h |    1 
 2 files changed, 46 insertions(+), 32 deletions(-)

diff -puN drivers/block/cciss.c~cciss-separate-error-processing-and-command-retrying-code-in-sendcmd_withirq_core drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-separate-error-processing-and-command-retrying-code-in-sendcmd_withirq_core
+++ a/drivers/block/cciss.c
@@ -2292,26 +2292,12 @@ static int check_target_status(ctlr_info
 	return IO_ERROR;
 }
 
-static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c)
+static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
-	u64bit buff_dma_handle;
-	unsigned long flags;
 	int return_status = IO_OK;
 
-resend_cmd2:
-	c->waiting = &wait;
-	/* Put the request on the tail of the queue and send it */
-	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
-	addQ(&h->reqQ, c);
-	h->Qdepth++;
-	start_io(h);
-	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-
-	wait_for_completion(&wait);
-
-	if (c->err_info->CommandStatus == 0)
-		goto command_done;
+	if (c->err_info->CommandStatus == CMD_SUCCESS)
+		return IO_OK;
 
 	switch (c->err_info->CommandStatus) {
 	case CMD_TARGET_STATUS:
@@ -2322,7 +2308,7 @@ resend_cmd2:
 		/* expected for inquiry and report lun commands */
 		break;
 	case CMD_INVALID:
-		printk(KERN_WARNING "cciss: Cmd 0x%02x is "
+		printk(KERN_WARNING "cciss: cmd 0x%02x is "
 		       "reported invalid\n", c->Request.CDB[0]);
 		return_status = IO_ERROR;
 		break;
@@ -2355,19 +2341,7 @@ resend_cmd2:
 		printk(KERN_WARNING
 		       "cciss%d: unsolicited abort 0x%02x\n", h->ctlr,
 			c->Request.CDB[0]);
-		if (c->retry_count < MAX_CMD_RETRIES) {
-			printk(KERN_WARNING
-			       "cciss%d: retrying 0x%02x\n", h->ctlr,
-				c->Request.CDB[0]);
-			c->retry_count++;
-			/* erase the old error information */
-			memset(c->err_info, 0,
-			       sizeof(ErrorInfo_struct));
-			return_status = IO_OK;
-			INIT_COMPLETION(wait);
-			goto resend_cmd2;
-		}
-		return_status = IO_ERROR;
+		return_status = IO_NEEDS_RETRY;
 		break;
 	default:
 		printk(KERN_WARNING "cciss: cmd 0x%02x returned "
@@ -2375,6 +2349,44 @@ resend_cmd2:
 		       c->err_info->CommandStatus);
 		return_status = IO_ERROR;
 	}
+	return return_status;
+}
+
+static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
+	int attempt_retry)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	u64bit buff_dma_handle;
+	unsigned long flags;
+	int return_status = IO_OK;
+
+resend_cmd2:
+	c->waiting = &wait;
+	/* Put the request on the tail of the queue and send it */
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
+	addQ(&h->reqQ, c);
+	h->Qdepth++;
+	start_io(h);
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
+
+	wait_for_completion(&wait);
+
+	if (c->err_info->CommandStatus == 0 || !attempt_retry)
+		goto command_done;
+
+	return_status = process_sendcmd_error(h, c);
+
+	if (return_status == IO_NEEDS_RETRY &&
+		c->retry_count < MAX_CMD_RETRIES) {
+		printk(KERN_WARNING "cciss%d: retrying 0x%02x\n", h->ctlr,
+			c->Request.CDB[0]);
+		c->retry_count++;
+		/* erase the old error information */
+		memset(c->err_info, 0, sizeof(ErrorInfo_struct));
+		return_status = IO_OK;
+		INIT_COMPLETION(wait);
+		goto resend_cmd2;
+	}
 
 command_done:
 	/* unlock the buffers from DMA */
@@ -2399,7 +2411,8 @@ static int sendcmd_withirq(__u8 cmd, int
 	return_status = fill_cmd(c, cmd, ctlr, buff, size, page_code,
 		scsi3addr, cmd_type);
 	if (return_status == IO_OK)
-		return_status = sendcmd_withirq_core(h, c);
+		return_status = sendcmd_withirq_core(h, c, 1);
+
 	cmd_free(h, c, 0);
 	return return_status;
 }
diff -puN drivers/block/cciss.h~cciss-separate-error-processing-and-command-retrying-code-in-sendcmd_withirq_core drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-separate-error-processing-and-command-retrying-code-in-sendcmd_withirq_core
+++ a/drivers/block/cciss.h
@@ -11,6 +11,7 @@
 
 #define IO_OK		0
 #define IO_ERROR	1
+#define IO_NEEDS_RETRY  3
 
 #define VENDOR_LEN	8
 #define MODEL_LEN	16
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

linux-next.patch

