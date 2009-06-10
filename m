From: akpm@linux-foundation.org
Subject: [merged] cciss-change-scsi-error-handling-routines-to-work-with-interrupts-enabled.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:56:23 -0700
Message-ID: <200906101756.n5AHuN7j008434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbZFJR4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: change SCSI error handling routines to work with interrupts enabled.
has been removed from the -mm tree.  Its filename was
     cciss-change-scsi-error-handling-routines-to-work-with-interrupts-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: change SCSI error handling routines to work with interrupts enabled.
From: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

Change cciss scsi error handling routines to work with interrupts enabled.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c      |    3 +++
 drivers/block/cciss_scsi.c |   24 +++++++++---------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff -puN drivers/block/cciss.c~cciss-change-scsi-error-handling-routines-to-work-with-interrupts-enabled drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-change-scsi-error-handling-routines-to-work-with-interrupts-enabled
+++ a/drivers/block/cciss.c
@@ -184,6 +184,9 @@ static int sendcmd(__u8 cmd, int ctlr, v
 static int sendcmd_withirq(__u8 cmd, int ctlr, void *buff, size_t size,
 			__u8 page_code, unsigned char scsi3addr[],
 			int cmd_type);
+static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
+	int attempt_retry);
+static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c);
 
 static void fail_all_cmds(unsigned long ctlr);
 static int scan_thread(void *data);
diff -puN drivers/block/cciss_scsi.c~cciss-change-scsi-error-handling-routines-to-work-with-interrupts-enabled drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-change-scsi-error-handling-routines-to-work-with-interrupts-enabled
+++ a/drivers/block/cciss_scsi.c
@@ -49,8 +49,6 @@ static int fill_cmd(CommandList_struct *
 	__u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
 
-static int sendcmd_core(ctlr_info_t *h, CommandList_struct *c);
-
 static CommandList_struct *cmd_alloc(ctlr_info_t *h, int get_from_pool);
 static void cmd_free(ctlr_info_t *h, CommandList_struct *c, int got_from_pool);
 
@@ -1601,11 +1599,10 @@ static int wait_for_device_to_become_rea
 		/* Send the Test Unit Ready */
 		rc = fill_cmd(c, TEST_UNIT_READY, h->ctlr, NULL, 0, 0,
 			lunaddr, TYPE_CMD);
-		if (rc == 0) {
-			rc = sendcmd_core(h, c);
-			/* sendcmd turned off interrupts, turn 'em back on. */
-			h->access.set_intr_mask(h, CCISS_INTR_ON);
-		}
+		if (rc == 0)
+			rc = sendcmd_withirq_core(h, c, 0);
+
+		(void) process_sendcmd_error(h, c);
 
 		if (rc == 0 && c->err_info->CommandStatus == CMD_SUCCESS)
 			break;
@@ -1663,10 +1660,8 @@ static int cciss_eh_device_reset_handler
 		return FAILED;
 	memcpy(lunaddr, &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 8);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = sendcmd(CCISS_RESET_MSG, ctlr, NULL, 0, 0, lunaddr,
+	rc = sendcmd_withirq(CCISS_RESET_MSG, ctlr, NULL, 0, 0, lunaddr,
 		TYPE_MSG);
-	/* sendcmd turned off interrupts on the board, turn 'em back on. */
-	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
 	if (rc == 0 && wait_for_device_to_become_ready(*c, lunaddr) == 0)
 		return SUCCESS;
 	printk(KERN_WARNING "cciss%d: resetting device failed.\n", ctlr);
@@ -1677,6 +1672,7 @@ static int  cciss_eh_abort_handler(struc
 {
 	int rc;
 	CommandList_struct *cmd_to_abort;
+	unsigned char lunaddr[8];
 	ctlr_info_t **c;
 	int ctlr;
 
@@ -1691,11 +1687,9 @@ static int  cciss_eh_abort_handler(struc
 	cmd_to_abort = (CommandList_struct *) scsicmd->host_scribble;
 	if (cmd_to_abort == NULL) /* paranoia */
 		return FAILED;
-	rc = sendcmd(CCISS_ABORT_MSG, ctlr, &cmd_to_abort->Header.Tag, 0, 0,
-		(unsigned char *) &cmd_to_abort->Header.LUN.LunAddrBytes[0], 
-		TYPE_MSG);
-	/* sendcmd turned off interrupts on the board, turn 'em back on. */
-	(*c)->access.set_intr_mask(*c, CCISS_INTR_ON);
+	memcpy(lunaddr, &cmd_to_abort->Header.LUN.LunAddrBytes[0], 8);
+	rc = sendcmd_withirq(CCISS_ABORT_MSG, ctlr, &cmd_to_abort->Header.Tag,
+		0, 0, lunaddr, TYPE_MSG);
 	if (rc == 0)
 		return SUCCESS;
 	return FAILED;
_

Patches currently in -mm which might be from scameron@beardog.cca.cpqcorp.net are

linux-next.patch

