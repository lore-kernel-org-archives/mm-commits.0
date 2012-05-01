From: akpm@linux-foundation.org
Subject: [nacked] ufs-add-scsi-host-lock-push-down-for-ufs.patch removed from -mm tree
Date: Tue, 01 May 2012 14:04:33 -0700
Message-ID: <20120501210433.C240EA020E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:46419 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2EAVEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 17:04:34 -0400
Received: by ghbz15 with SMTP id z15so513396ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 14:04:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, James.Bottomley@HansenPartnership.com, santoshsy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ufs/ufshcd.c: add SCSI host lock push-down for ufs
has been removed from the -mm tree.  Its filename was
     ufs-add-scsi-host-lock-push-down-for-ufs.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: drivers/scsi/ufs/ufshcd.c: add SCSI host lock push-down for ufs

The SCSI host lock push-down change has not yet been made the n ufs host
driver.  After adding it, I removed an unneeded spinlock in queuecommand()
also.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~ufs-add-scsi-host-lock-push-down-for-ufs drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~ufs-add-scsi-host-lock-push-down-for-ufs
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -658,23 +658,23 @@ static void ufshcd_compose_upiu(struct u
 }
 
 /**
- * ufshcd_queuecommand - main entry point for SCSI requests
+ * ufshcd_queuecommand_lck - main entry point for SCSI requests
  * @cmd: command from SCSI Midlayer
  * @done: call back function
  *
  * Returns 0 for success, non-zero in case of failure
  */
-static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+static int
+ufshcd_queuecommand_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
 	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
-	unsigned long flags;
 	int tag;
 	int err = 0;
 
-	hba = shost_priv(host);
+	hba = shost_priv(scp->device->host);
 
-	tag = cmd->request->tag;
+	tag = scp->request->tag;
 
 	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
 		err = SCSI_MLQUEUE_HOST_BUSY;
@@ -683,11 +683,11 @@ static int ufshcd_queuecommand(struct Sc
 
 	lrbp = &hba->lrb[tag];
 
-	lrbp->cmd = cmd;
+	lrbp->cmd = scp;
 	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
-	lrbp->sense_buffer = cmd->sense_buffer;
+	lrbp->sense_buffer = scp->sense_buffer;
 	lrbp->task_tag = tag;
-	lrbp->lun = cmd->device->lun;
+	lrbp->lun = scp->device->lun;
 
 	lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
@@ -698,13 +698,13 @@ static int ufshcd_queuecommand(struct Sc
 		goto out;
 
 	/* issue command to the controller */
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_send_command(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 out:
 	return err;
 }
 
+static DEF_SCSI_QCMD(ufshcd_queuecommand);
+
 /**
  * ufshcd_memory_alloc - allocate memory for host memory space data structures
  * @hba: per adapter instance
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch

