From: akpm@linux-foundation.org
Subject: [merged] cciss-factor-out-core-of-sendcmd_withirq-for-use-by-scsi-error-handling-code.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:15 -0700
Message-ID: <200906101756.n5AHuFbA008337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbZFJR43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: factor out core of sendcmd_withirq() for use by SCSI error handling code
has been removed from the -mm tree.  Its filename was
     cciss-factor-out-core-of-sendcmd_withirq-for-use-by-scsi-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: factor out core of sendcmd_withirq() for use by SCSI error handling code
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Factor the core of sendcmd_withirq out to provide a simpler interface
which provides access to full error information.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |  183 ++++++++++++++++++++--------------------
 1 file changed, 96 insertions(+), 87 deletions(-)

diff -puN drivers/block/cciss.c~cciss-factor-out-core-of-sendcmd_withirq-for-use-by-scsi-error-handling-code drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-factor-out-core-of-sendcmd_withirq-for-use-by-scsi-error-handling-code
+++ a/drivers/block/cciss.c
@@ -2278,114 +2278,123 @@ static int fill_cmd(CommandList_struct *
 	return status;
 }
 
-static int sendcmd_withirq(__u8 cmd,
-			   int ctlr,
-			   void *buff,
-			   size_t size,
-			   unsigned int use_unit_num,
-			   unsigned int log_unit, __u8 page_code, int cmd_type)
+static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c)
 {
-	ctlr_info_t *h = hba[ctlr];
-	CommandList_struct *c;
+	DECLARE_COMPLETION_ONSTACK(wait);
 	u64bit buff_dma_handle;
 	unsigned long flags;
-	int return_status;
-	DECLARE_COMPLETION_ONSTACK(wait);
+	int return_status = IO_OK;
 
-	if ((c = cmd_alloc(h, 0)) == NULL)
-		return -ENOMEM;
-	return_status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
-				 log_unit, page_code, NULL, cmd_type);
-	if (return_status != IO_OK) {
-		cmd_free(h, c, 0);
-		return return_status;
-	}
-      resend_cmd2:
+resend_cmd2:
 	c->waiting = &wait;
-
 	/* Put the request on the tail of the queue and send it */
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
+	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
 	start_io(h);
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
+	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
 	wait_for_completion(&wait);
 
-	if (c->err_info->CommandStatus != 0) {	/* an error has occurred */
-		switch (c->err_info->CommandStatus) {
-		case CMD_TARGET_STATUS:
-			printk(KERN_WARNING "cciss: cmd %p has "
-			       " completed with errors\n", c);
-			if (c->err_info->ScsiStatus) {
-				printk(KERN_WARNING "cciss: cmd %p "
-				       "has SCSI Status = %x\n",
-				       c, c->err_info->ScsiStatus);
-			}
+	if (c->err_info->CommandStatus == 0)
+		goto command_done;
 
-			break;
-		case CMD_DATA_UNDERRUN:
-		case CMD_DATA_OVERRUN:
-			/* expected for inquire and report lun commands */
-			break;
-		case CMD_INVALID:
-			printk(KERN_WARNING "cciss: Cmd %p is "
-			       "reported invalid\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_PROTOCOL_ERR:
-			printk(KERN_WARNING "cciss: cmd %p has "
-			       "protocol error \n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_HARDWARE_ERR:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       " hardware error\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_CONNECTION_LOST:
-			printk(KERN_WARNING "cciss: cmd %p had "
-			       "connection lost\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_ABORTED:
-			printk(KERN_WARNING "cciss: cmd %p was "
-			       "aborted\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_ABORT_FAILED:
-			printk(KERN_WARNING "cciss: cmd %p reports "
-			       "abort failed\n", c);
-			return_status = IO_ERROR;
-			break;
-		case CMD_UNSOLICITED_ABORT:
+	switch (c->err_info->CommandStatus) {
+	case CMD_TARGET_STATUS:
+		printk(KERN_WARNING "cciss: cmd 0x%02x "
+		"has completed with errors\n", c->Request.CDB[0]);
+		if (c->err_info->ScsiStatus) {
+			printk(KERN_WARNING "cciss: cmd 0x%02x "
+			       "has SCSI Status = %x\n",
+			       c->Request.CDB[0], c->err_info->ScsiStatus);
+		}
+		break;
+	case CMD_DATA_UNDERRUN:
+	case CMD_DATA_OVERRUN:
+		/* expected for inquiry and report lun commands */
+		break;
+	case CMD_INVALID:
+		printk(KERN_WARNING "cciss: Cmd 0x%02x is "
+		       "reported invalid\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_PROTOCOL_ERR:
+		printk(KERN_WARNING "cciss: cmd 0x%02x has "
+		       "protocol error \n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_HARDWARE_ERR:
+		printk(KERN_WARNING "cciss: cmd 0x%02x had "
+		       " hardware error\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_CONNECTION_LOST:
+		printk(KERN_WARNING "cciss: cmd 0x%02x had "
+		       "connection lost\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_ABORTED:
+		printk(KERN_WARNING "cciss: cmd 0x%02x was "
+		       "aborted\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_ABORT_FAILED:
+		printk(KERN_WARNING "cciss: cmd 0x%02x reports "
+		       "abort failed\n", c->Request.CDB[0]);
+		return_status = IO_ERROR;
+		break;
+	case CMD_UNSOLICITED_ABORT:
+		printk(KERN_WARNING
+		       "cciss%d: unsolicited abort 0x%02x\n", h->ctlr,
+			c->Request.CDB[0]);
+		if (c->retry_count < MAX_CMD_RETRIES) {
 			printk(KERN_WARNING
-			       "cciss%d: unsolicited abort %p\n", ctlr, c);
-			if (c->retry_count < MAX_CMD_RETRIES) {
-				printk(KERN_WARNING
-				       "cciss%d: retrying %p\n", ctlr, c);
-				c->retry_count++;
-				/* erase the old error information */
-				memset(c->err_info, 0,
-				       sizeof(ErrorInfo_struct));
-				return_status = IO_OK;
-				INIT_COMPLETION(wait);
-				goto resend_cmd2;
-			}
-			return_status = IO_ERROR;
-			break;
-		default:
-			printk(KERN_WARNING "cciss: cmd %p returned "
-			       "unknown status %x\n", c,
-			       c->err_info->CommandStatus);
-			return_status = IO_ERROR;
+			       "cciss%d: retrying 0x%02x\n", h->ctlr,
+				c->Request.CDB[0]);
+			c->retry_count++;
+			/* erase the old error information */
+			memset(c->err_info, 0,
+			       sizeof(ErrorInfo_struct));
+			return_status = IO_OK;
+			INIT_COMPLETION(wait);
+			goto resend_cmd2;
 		}
+		return_status = IO_ERROR;
+		break;
+	default:
+		printk(KERN_WARNING "cciss: cmd 0x%02x returned "
+		       "unknown status %x\n", c->Request.CDB[0],
+		       c->err_info->CommandStatus);
+		return_status = IO_ERROR;
 	}
+
+command_done:
 	/* unlock the buffers from DMA */
 	buff_dma_handle.val32.lower = c->SG[0].Addr.lower;
 	buff_dma_handle.val32.upper = c->SG[0].Addr.upper;
 	pci_unmap_single(h->pdev, (dma_addr_t) buff_dma_handle.val,
 			 c->SG[0].Len, PCI_DMA_BIDIRECTIONAL);
+	return return_status;
+}
+
+static int sendcmd_withirq(__u8 cmd,
+			   int ctlr,
+			   void *buff,
+			   size_t size,
+			   unsigned int use_unit_num,
+			   unsigned int log_unit, __u8 page_code, int cmd_type)
+{
+	ctlr_info_t *h = hba[ctlr];
+	CommandList_struct *c;
+	int return_status;
+
+	c = cmd_alloc(h, 0);
+	if (!c)
+		return -ENOMEM;
+	return_status = fill_cmd(c, cmd, ctlr, buff, size, use_unit_num,
+				 log_unit, page_code, NULL, cmd_type);
+	if (return_status == IO_OK)
+		return_status = sendcmd_withirq_core(h, c);
 	cmd_free(h, c, 0);
 	return return_status;
 }
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

linux-next.patch

