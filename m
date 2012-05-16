From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch removed from -mm tree
Date: Wed, 16 May 2012 11:47:05 -0700
Message-ID: <20120516184705.65353A028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58944 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760369Ab2EPSrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 14:47:06 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so142767qab.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 11:47:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svenkatr@ti.com, James.Bottomley@HansenPartnership.com, joe@perches.com, linkinjeon@gmail.com, santoshsy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ufs: fix evaluation of task_failed status
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Venkatraman S <svenkatr@ti.com>
Subject: drivers/scsi/ufs: fix evaluation of task_failed status

Else FAILED would be set even if task_result was originally equal to
UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-fix-evaluation-of-task_failed-status drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-fix-evaluation-of-task_failed-status
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct 
 		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
 		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
 
-		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
+		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
 		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
 			task_result = FAILED;
 	} else {
_

Patches currently in -mm which might be from svenkatr@ti.com are

linux-next.patch
drivers-scsi-ufs-use-module_pci_driver.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch

