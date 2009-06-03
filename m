From: akpm@linux-foundation.org
Subject: [merged] cciss-fix-scsi-device-reset-handler.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:07 -0700
Message-ID: <200906032002.n53K270a001453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640AbZFCUCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mikem@beardog.cca.cpqcorp.net, mm-commits@vger.kernel.org


The patch titled
     cciss: fix SCSI device reset handler
has been removed from the -mm tree.  Its filename was
     cciss-fix-scsi-device-reset-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix SCSI device reset handler
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Fix the SCSI reset error handler to send a working, properly addressed
reset message to the target device and add code to wait for the target
device to become ready by polling it with Test Unit Ready.

The existing reset code was broken in that it didn't bother to set the
8-byte LUN address to anything besides zero, so the command was addressed
to the controller, which pretended to the driver that the command
succeeded, while doing nothing.  Ages ago I tested this code, but
unbeknownst to me, my test was flawed, and what I thought was a tape drive
getting reset was actually nothing of the sort.  Unfortunately, there is
still lots of Smartarray firmware that doesn't handle doing target resets
right, and this code won't help in those cases, but it also shouldn't make
things worse in those cases than they already are.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Mike Miller <mikem@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c      |   14 ++++-
 drivers/block/cciss_scsi.c |   85 ++++++++++++++++++++++++++++++++---
 2 files changed, 90 insertions(+), 9 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-scsi-device-reset-handler drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-scsi-device-reset-handler
+++ a/drivers/block/cciss.c
@@ -1974,6 +1974,13 @@ static int fill_cmd(CommandList_struct *
 			c->Request.CDB[0] = BMIC_WRITE;
 			c->Request.CDB[6] = BMIC_CACHE_FLUSH;
 			break;
+		case TEST_UNIT_READY:
+			memcpy(c->Header. LUN.LunAddrBytes, scsi3addr, 8);
+			c->Request.CDBLen = 6;
+			c->Request.Type.Attribute = ATTR_SIMPLE;
+			c->Request.Type.Direction = XFER_NONE;
+			c->Request.Timeout = 0;
+			break;
 		default:
 			printk(KERN_WARNING
 			       "cciss%d:  Unknown Command 0x%c\n", ctlr, cmd);
@@ -1992,13 +1999,14 @@ static int fill_cmd(CommandList_struct *
 			memcpy(&c->Request.CDB[4], buff, 8);
 			break;
 		case 1:	/* RESET message */
-			c->Request.CDBLen = 12;
+			memcpy(c->Header.LUN.LunAddrBytes, scsi3addr, 8);
+			c->Request.CDBLen = 16;
 			c->Request.Type.Attribute = ATTR_SIMPLE;
-			c->Request.Type.Direction = XFER_WRITE;
+			c->Request.Type.Direction = XFER_NONE;
 			c->Request.Timeout = 0;
 			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
 			c->Request.CDB[0] = cmd;	/* reset */
-			c->Request.CDB[1] = 0x04;	/* reset a LUN */
+			c->Request.CDB[1] = 0x03;	/* reset a target */
 			break;
 		case 3:	/* No-Op message */
 			c->Request.CDBLen = 1;
diff -puN drivers/block/cciss_scsi.c~cciss-fix-scsi-device-reset-handler drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-fix-scsi-device-reset-handler
+++ a/drivers/block/cciss_scsi.c
@@ -58,6 +58,18 @@ static int sendcmd(
 	unsigned char *scsi3addr,
 	int cmd_type);
 
+static int fill_cmd(CommandList_struct *c, __u8 cmd, int ctlr, void *buff,
+	size_t size,
+	unsigned int use_unit_num, /* 0: address the controller,
+				      1: address logical volume log_unit,
+				      2: periph device address is scsi3addr */
+	unsigned int log_unit, __u8 page_code, unsigned char *scsi3addr,
+	int cmd_type);
+
+static int sendcmd_core(ctlr_info_t *h, CommandList_struct *c);
+
+static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool);
+static void cmd_free(ctlr_info_t *h, CommandList_struct *c, int got_from_pool);
 
 static int cciss_scsi_proc_info(
 		struct Scsi_Host *sh,
@@ -1575,6 +1587,68 @@ cciss_seq_tape_report(struct seq_file *s
 	CPQ_TAPE_UNLOCK(ctlr, flags);
 }
 
+static int wait_for_device_to_become_ready(ctlr_info_t *h,
+	unsigned char lunaddr[])
+{
+	int rc;
+	int count = 0;
+	int waittime = HZ;
+	CommandList_struct *c;
+
+	c = cmd_alloc(h, 1);
+	if (!c) {
+		printk(KERN_WARNING "cciss%d: out of memory in "
+			"wait_for_device_to_become_ready.\n", h->ctlr);
+		return IO_ERROR;
+	}
+
+	/* Send test unit ready until device ready, or give up. */
+	while (count < 20) {
+
+		/* Wait for a bit.  do this first, because if we send
+		 * the TUR right away, the reset will just abort it.
+		 */
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(waittime);
+		count++;
+
+		/* Increase wait time with each try, up to a point. */
+		if (waittime < (HZ * 30))
+			waittime = waittime * 2;
+
+		/* Send the Test Unit Ready */
+		rc = fill_cmd(c, TEST_UNIT_READY, h->ctlr, NULL, 0, 0, 0, 0,
+			lunaddr, TYPE_CMD);
+		if (rc == 0) {
+			rc = sendcmd_core(h, c);
+			/* sendcmd turned off interrupts, turn 'em back on. */
+			h->access.set_intr_mask(h, CCISS_INTR_ON);
+		}
+
+		if (rc == 0 && c->err_info->CommandStatus == CMD_SUCCESS)
+			break;
+
+		if (rc == 0 &&
+			c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
+			(c->err_info->SenseInfo[2] == NO_SENSE ||
+			c->err_info->SenseInfo[2] == UNIT_ATTENTION))
+			break;
+
+		printk(KERN_WARNING "cciss%d: Waiting %d secs "
+			"for device to become ready.\n",
+			h->ctlr, waittime / HZ);
+		rc = 1; /* device not ready. */
+	}
+
+	if (rc)
+		printk("cciss%d: giving up on device.\n", h->ctlr);
+	else
+		printk(KERN_WARNING "cciss%d: device is ready.\n", h->ctlr);
+
+	cmd_free(h, c, 1);
+	return rc;
+}
 
 /* Need at least one of these error handlers to keep ../scsi/hosts.c from 
  * complaining.  Doing a host- or bus-reset can't do anything good here. 
@@ -1591,6 +1665,7 @@ static int cciss_eh_device_reset_handler
 {
 	int rc;
 	CommandList_struct *cmd_in_trouble;
+	unsigned char lunaddr[8];
 	ctlr_info_t **c;
 	int ctlr;
 
@@ -1600,19 +1675,17 @@ static int cciss_eh_device_reset_handler
 		return FAILED;
 	ctlr = (*c)->ctlr;
 	printk(KERN_WARNING "cciss%d: resetting tape drive or medium changer.\n", ctlr);
-
 	/* find the command that's giving us trouble */
 	cmd_in_trouble = (CommandList_struct *) scsicmd->host_scribble;
-	if (cmd_in_trouble == NULL) { /* paranoia */
+	if (cmd_in_trouble == NULL) /* paranoia */
 		return FAILED;
-	}
+	memcpy(lunaddr, &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 8);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 2, 0, 0, 
-		(unsigned char *) &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 
+	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 2, 0, 0, lunaddr,
 		TYPE_MSG);
 	/* sendcmd turned off interrupts on the board, turn 'em back on. */
 	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
-	if (rc == 0)
+	if (rc == 0 && wait_for_device_to_become_ready(*c, lunaddr) == 0)
 		return SUCCESS;
 	printk(KERN_WARNING "cciss%d: resetting device failed.\n", ctlr);
 	return FAILED;
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

linux-next.patch

