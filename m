From: akpm@linux-foundation.org
Subject: + ufs-fix-incorrect-return-value-about-success-and-failed.patch added to -mm tree
Date: Tue, 01 May 2012 12:16:27 -0700
Message-ID: <20120501191627.91C5AA0413@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51986 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab2EATQ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 15:16:29 -0400
Received: by faaa25 with SMTP id a25so214819faa.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 12:16:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, James.Bottomley@HansenPartnership.com, santoshsy@gmail.com


The patch titled
     Subject: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FAILED
has been added to the -mm tree.  Its filename is
     ufs-fix-incorrect-return-value-about-success-and-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/scsi/ufs: fix incorrect return value about SUCCESS and FAILED

Patches currently in -mm which might be from linkinjeon@gmail.com are

drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch
ufs-fix-incorrect-return-value-about-success-and-failed.patch
ufs-add-scsi-host-lock-push-down-for-ufs.patch

