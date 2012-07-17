From: akpm@linux-foundation.org
Subject: [merged] ufs-fix-incorrect-return-value-about-success-and-failed.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:15 -0700
Message-ID: <20120717200416.2F1435C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57501 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2GQUES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:18 -0400
Received: by eekb47 with SMTP id b47so48473eek.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, James.Bottomley@HansenPartnership.com, santoshsy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FAILED
has been removed from the -mm tree.  Its filename was
     ufs-fix-incorrect-return-value-about-success-and-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FAILED

Currently the UFS host driver has returned incorrect values for SUCCESS
and FAILED.  Fix it to return the correct value to the upper layer.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~ufs-fix-incorrect-return-value-about-success-and-failed drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~ufs-fix-incorrect-return-value-about-success-and-failed
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1163,6 +1163,8 @@ static int ufshcd_task_req_compl(struct 
 		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
 		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
 			task_result = FAILED;
+		else
+			task_result = SUCCESS;
 	} else {
 		task_result = FAILED;
 		dev_err(&hba->pdev->dev,
@@ -1556,7 +1558,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 	clear_bit(free_slot, &hba->tm_condition);
-	return ufshcd_task_req_compl(hba, free_slot);
+	err = ufshcd_task_req_compl(hba, free_slot);
 out:
 	return err;
 }
@@ -1580,7 +1582,7 @@ static int ufshcd_device_reset(struct sc
 	tag = cmd->request->tag;
 
 	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LOGICAL_RESET);
-	if (err)
+	if (err == FAILED)
 		goto out;
 
 	for (pos = 0; pos < hba->nutrs; pos++) {
@@ -1620,7 +1622,7 @@ static int ufshcd_host_reset(struct scsi
 	if (hba->ufshcd_state == UFSHCD_STATE_RESET)
 		return SUCCESS;
 
-	return (ufshcd_do_reset(hba) == SUCCESS) ? SUCCESS : FAILED;
+	return ufshcd_do_reset(hba);
 }
 
 /**
@@ -1652,7 +1654,7 @@ static int ufshcd_abort(struct scsi_cmnd
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 	err = ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TASK);
-	if (err)
+	if (err == FAILED)
 		goto out;
 
 	scsi_dma_unmap(cmd);
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

linux-next.patch
hfsplus-use-enomem-when-kzalloc-fails.patch

