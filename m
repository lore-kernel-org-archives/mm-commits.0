From: akpm@linux-foundation.org
Subject: + drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch added to -mm tree
Date: Wed, 18 Apr 2012 15:57:26 -0700
Message-ID: <20120418225727.0EDF5A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54978 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2DRW53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 18:57:29 -0400
Received: by eaaq10 with SMTP id q10so379799eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 15:57:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: svenkatr@ti.com, James.Bottomley@HansenPartnership.com, joe@perches.com, linkinjeon@gmail.com, santoshsy@gmail.com


The patch titled
     Subject: drivers/scsi/ufs: fix evaluation of task_failed status
has been added to the -mm tree.  Its filename is
     drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/scsi/ufs: fix evaluation of task_failed status

Patches currently in -mm which might be from svenkatr@ti.com are

linux-next.patch
drivers-scsi-ufs-use-module_pci_driver.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch

