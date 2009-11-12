From: akpm@linux-foundation.org
Subject: + hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch added to -mm tree
Date: Thu, 12 Nov 2009 14:53:52 -0800
Message-ID: <200911122253.nACMrqql006868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754642AbZKLW52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 17:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com


The patch titled
     hpsa: Remove sendcmd, in no case are we required to poll for completions.
has been added to the -mm tree.  Its filename is
     hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: Remove sendcmd, in no case are we required to poll for completions.
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

hpsa: Remove sendcmd, there are no instances in which we must poll for
command completion.  This means sendcmd_core() and pollcomplete()
can be removed as well.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |  156 ------------------------------------------
 1 file changed, 156 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions
+++ a/drivers/scsi/hpsa.c
@@ -117,8 +117,6 @@ static int number_of_controllers;
 static irqreturn_t do_hpsa_intr(int irq, void *dev_id);
 static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
 static void start_io(struct ctlr_info *h);
-static int sendcmd(__u8 cmd, struct ctlr_info *h, void *buff, size_t size,
-		   __u8 page_code, unsigned char *scsi3addr, int cmd_type);
 
 #ifdef CONFIG_COMPAT
 static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
@@ -131,7 +129,6 @@ static struct CommandList *cmd_special_a
 static int fill_cmd(struct CommandList *c, __u8 cmd, struct ctlr_info *h,
 	void *buff, size_t size, __u8 page_code, unsigned char *scsi3addr,
 	int cmd_type);
-static int sendcmd_core(struct ctlr_info *h, struct CommandList *c);
 
 static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *));
@@ -2685,159 +2682,6 @@ static int fill_cmd(struct CommandList *
 }
 
 /*
- *   Wait polling for a command to complete.
- *   The memory mapped FIFO is polled for the completion.
- *   Used only at init time, interrupts from the HBA are disabled.
- */
-static unsigned long pollcomplete(struct ctlr_info *h)
-{
-	unsigned long done;
-	int i;
-
-	/* Wait (up to HPSA_MAX_POLL_TIME_SECS) for a command to complete */
-	for (i = HPSA_MAX_POLL_TIME_SECS * HZ; i > 0; i--) {
-		done = h->access.command_completed(h);
-		if (done == FIFO_EMPTY)
-			schedule_timeout_uninterruptible(1);
-		else
-			return done;
-	}
-	/* Invalid address to tell caller we ran out of time */
-	dev_warn(&h->pdev->dev, "pollcomplete(): returning 1\n");
-	return 1;
-}
-
-/* Send command c to controller h and poll for it to complete.
- * Turns interrupts off on the board.  Used at driver init time
- * and during SCSI error recovery.
- */
-static int sendcmd_core(struct ctlr_info *h, struct CommandList *c)
-{
-	int i;
-	unsigned long complete;
-	int status = IO_ERROR;
-
-resend_cmd1:
-	/*
-	 * Disable interrupt
-	 */
-	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-
-	/* Make sure there is room in the command FIFO
-	 * Actually it should be completely empty at this time
-	 * unless we are in here doing error handling for the scsi
-	 * side of the driver.
-	 */
-	for (i = 200000; i > 0; i--) {
-		/* if fifo isn't full go */
-		if (!(h->access.fifo_full(h)))
-			break;
-		udelay(10);
-		dev_warn(&h->pdev->dev, "sendcmd FIFO full, waiting!\n");
-	}
-	h->access.submit_command(h, c); /* Send the cmd */
-	do {
-		complete = pollcomplete(h);
-
-		if (complete == 1) {
-			dev_warn(&h->pdev->dev,
-			       "sendcmd timeout, no command list address "
-				"returned!\n");
-			status = IO_ERROR;
-			break;
-		}
-
-		/* If it's not the cmd we're looking for, save it for later */
-		if ((complete & ~HPSA_ERROR_BIT) != c->busaddr) {
-			dev_warn(&h->pdev->dev, "unexpected command "
-				"completion.\n");
-			continue;
-		}
-
-		/* It is our command.  If no error, we're done. */
-		if (!(complete & HPSA_ERROR_BIT)) {
-			status = IO_OK;
-			break;
-		}
-
-		/* There is an error... */
-
-		/* if data overrun or underun on Report command ignore it */
-		if (((c->Request.CDB[0] == HPSA_REPORT_LOG) ||
-			(c->Request.CDB[0] == HPSA_REPORT_PHYS) ||
-			(c->Request.CDB[0] == HPSA_INQUIRY)) &&
-			((c->err_info->CommandStatus == CMD_DATA_OVERRUN) ||
-			(c->err_info->CommandStatus == CMD_DATA_UNDERRUN))) {
-			complete = c->busaddr;
-			status = IO_OK;
-			break;
-		}
-		if (c->err_info->CommandStatus == CMD_UNSOLICITED_ABORT) {
-			dev_warn(&h->pdev->dev, "unsolicited abort %p\n", c);
-			if (c->retry_count < MAX_CMD_RETRIES) {
-				dev_warn(&h->pdev->dev, "retrying %p\n", c);
-				c->retry_count++;
-				/* erase the old error information */
-				memset(c->err_info, 0, sizeof(c->err_info));
-				goto resend_cmd1;
-			}
-			dev_warn(&h->pdev->dev,
-				"retried %p too many times\n", c);
-			status = IO_ERROR;
-			goto cleanup1;
-		}
-		if (c->err_info->CommandStatus == CMD_UNABORTABLE) {
-			dev_warn(&h->pdev->dev,
-				"command could not be aborted.\n");
-			status = IO_ERROR;
-			goto cleanup1;
-		}
-		dev_warn(&h->pdev->dev, "sendcmd error\n");
-		dev_warn(&h->pdev->dev,
-			"cmd = 0x%02x, CommandStatus = 0x%02x\n",
-			c->Request.CDB[0], c->err_info->CommandStatus);
-		if (c->err_info->CommandStatus == CMD_TARGET_STATUS) {
-			dev_warn(&h->pdev->dev, "target status = 0x%02x\n",
-				c->err_info->ScsiStatus);
-			if (c->err_info->ScsiStatus == 2) /* chk cond */
-				dev_warn(&h->pdev->dev, "sense key = 0x%02x\n",
-					0xf & c->err_info->SenseInfo[2]);
-		}
-
-		status = IO_ERROR;
-		goto cleanup1;
-
-	} while (1);
-
-cleanup1:
-	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
-	return status;
-}
-
-/*
- * Send a command to the controller, and wait for it to complete.
- * Used at init time, and during SCSI error recovery.
- */
-static int sendcmd(__u8 cmd, struct ctlr_info *h, void *buff, size_t size,
-		   __u8 page_code, unsigned char *scsi3addr, int cmd_type)
-{
-	struct CommandList *c;
-	int status;
-
-	c = cmd_alloc(h);
-	if (c == NULL) {
-		dev_warn(&h->pdev->dev, "unable to get memory");
-		return IO_ERROR;
-	}
-	status = fill_cmd(c, cmd, h, buff, size, page_code,
-		scsi3addr, cmd_type);
-	if (status == IO_OK)
-		status = sendcmd_core(h, c);
-	cmd_free(h, c);
-	return status;
-}
-
-/*
  * Map (physical) PCI mem into (virtual) kernel space
  */
 static void __iomem *remap_pci_mem(ulong base, ulong size)
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix-hpsa_allow_any-test-for-vendor-id.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers-fix.patch
hpsa-fix-use-of-unallocated-memory-for-msa2xxx-enclosure-device-data.patch
hpsa-allocate-the-correct-amount-of-extra-space-for-the-scsi-host.patch
hpsa-use-shost_priv-instead-of-accessing-host-hostdata-directly.patch
hpsa-factor-out-command-submission-sequence.patch
hpsa-factor-out-some-pci_unmap-code.patch
add-thread-to-allow-controllers-to-register-for-rescan-for-new-devices.patch
hpsa-allow-device-rescan-to-be-triggered-via-sysfs.patch
hpsa-make-hpsa_sdev_attrs-static.patch
hpsa-decode-unit-attention-condition-and-retry-commands.patch
hpsa-retry-driver-initiated-commands-on-unit-attention.patch
hpsa-flush-cache-with-interrupts-still-enabled.patch
hpsa-remove-sendcmd-in-no-case-are-we-required-to-poll-for-completions.patch
hpsa-make-fill_cmd-return-void.patch
hpsa-fix-typo-that-causes-scsi-status-to-be-lost.patch

