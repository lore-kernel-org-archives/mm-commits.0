From: akpm@linux-foundation.org
Subject: [folded] hpsa-use-msleep-instead-of-schedule_timeout.patch removed from -mm tree
Date: Tue, 08 Dec 2009 14:07:26 -0800
Message-ID: <200912082207.nB8M7Q3Q003217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966640AbZLHWHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:07:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: use msleep() instead of schedule_timeout
has been removed from the -mm tree.  Its filename was
     hpsa-use-msleep-instead-of-schedule_timeout.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: use msleep() instead of schedule_timeout
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Use msleep() instead of schedule_timeout

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   27 ++++++++++++++-------------
 drivers/scsi/hpsa.h |    4 ++--
 2 files changed, 16 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-use-msleep-instead-of-schedule_timeout drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-use-msleep-instead-of-schedule_timeout
+++ a/drivers/scsi/hpsa.c
@@ -1933,7 +1933,7 @@ static int wait_for_device_to_become_rea
 {
 	int rc = 0;
 	int count = 0;
-	int waittime = HZ;
+	int waittime = 1; /* seconds */
 	struct CommandList *c;
 
 	c = cmd_special_alloc(h);
@@ -1950,11 +1950,11 @@ static int wait_for_device_to_become_rea
 		 * the TUR right away, the reset will just abort it.
 		 */
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(waittime);
+		msleep(1000 * waittime);
 		count++;
 
 		/* Increase wait time with each try, up to a point. */
-		if (waittime < (HZ * HPSA_MAX_WAIT_INTERVAL_SECS))
+		if (waittime < HPSA_MAX_WAIT_INTERVAL_SECS)
 			waittime = waittime * 2;
 
 		/* Send the Test Unit Ready */
@@ -1972,7 +1972,7 @@ static int wait_for_device_to_become_rea
 			break;
 
 		dev_warn(&h->pdev->dev, "waiting %d secs "
-			"for device to become ready.\n", waittime / HZ);
+			"for device to become ready.\n", waittime);
 		rc = 1; /* device not ready. */
 	}
 
@@ -2838,8 +2838,8 @@ static __devinit int hpsa_message(struct
 		tag = readl(vaddr + SA5_REPLY_PORT_OFFSET);
 		if (HPSA_TAG_DISCARD_ERROR_BITS(tag) == paddr32)
 			break;
-		schedule_timeout_uninterruptible(
-			HPSA_MSG_SEND_RETRY_INTERVAL_SECS * HZ);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(HPSA_MSG_SEND_RETRY_INTERVAL_MSECS);
 	}
 
 	iounmap(vaddr);
@@ -2953,7 +2953,7 @@ static __devinit int hpsa_hard_reset_con
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	schedule_timeout(HZ >> 1);
+	msleep(500);
 
 	/* enter the D0 power management state */
 	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
@@ -2961,7 +2961,7 @@ static __devinit int hpsa_hard_reset_con
 	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
-	schedule_timeout(HZ >> 1);
+	msleep(500);
 
 	/* Restore the PCI configuration space.  The Open CISS
 	 * Specification says, "Restore the PCI Configuration
@@ -3187,8 +3187,8 @@ static int hpsa_pci_init(struct ctlr_inf
 		scratchpad = readl(h->vaddr + SA5_SCRATCHPAD_OFFSET);
 		if (scratchpad == HPSA_FIRMWARE_READY)
 			break;
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HPSA_BOARD_READY_POLL_INTERVAL);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(HPSA_BOARD_READY_POLL_INTERVAL_MSECS);
 	}
 	if (scratchpad != HPSA_FIRMWARE_READY) {
 		dev_warn(&pdev->dev, "board not ready, timed out.\n");
@@ -3262,8 +3262,8 @@ static int hpsa_pci_init(struct ctlr_inf
 		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
 			break;
 		/* delay and try again */
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(10);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(10);
 	}
 
 #ifdef HPSA_DEBUG
@@ -3302,7 +3302,8 @@ static int __devinit hpsa_init_one(struc
 
 		/* Some devices (notably the HP Smart Array 5i Controller)
 		   need a little pause here */
-		schedule_timeout_uninterruptible(HPSA_POST_RESET_PAUSE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		msleep(HPSA_POST_RESET_PAUSE_MSECS);
 
 		/* Now try to get the controller to respond to a no-op */
 		for (i = 0; i < HPSA_POST_RESET_NOOP_RETRIES; i++) {
diff -puN drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout drivers/scsi/hpsa.h
--- a/drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout
+++ a/drivers/scsi/hpsa.h
@@ -108,7 +108,7 @@ struct ctlr_info {
 #define HPSA_BUS_RESET_MSG 2
 #define HPSA_HOST_RESET_MSG 3
 #define HPSA_MSG_SEND_RETRY_LIMIT 10
-#define HPSA_MSG_SEND_RETRY_INTERVAL_SECS 1
+#define HPSA_MSG_SEND_RETRY_INTERVAL_MSECS 1000
 
 /* Maximum time in seconds driver will wait for command completions
  * when polling before giving up.
@@ -139,7 +139,7 @@ struct ctlr_info {
 #define HPSA_BOARD_READY_ITERATIONS \
 	((HPSA_BOARD_READY_WAIT_SECS * 1000) / \
 		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
-#define HPSA_POST_RESET_PAUSE (30 * HZ)
+#define HPSA_POST_RESET_PAUSE_MSECS (3000)
 #define HPSA_POST_RESET_NOOP_RETRIES (12)
 
 /*  Defining the diffent access_menthods */
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-use-msleep-instead-of-schedule_timeout.patch
hpsa-use-msleep-instead-of-schedule_timeout-fix.patch
hpsa-rename-too-generic-variable-names.patch
hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch
hpsa-fix-incorrect-scsi-status-reporting.patch
hpsa-suppress-messages-due-to-unsupport-scsi-report_luns.patch
cciss-fix-bad-scsi-status-reporting.patch

