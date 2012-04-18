From: akpm@linux-foundation.org
Subject: + drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch added to -mm tree
Date: Wed, 18 Apr 2012 15:57:23 -0700
Message-ID: <20120418225724.5D025A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61114 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2DRW5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Apr 2012 18:57:25 -0400
Received: by qabg24 with SMTP id g24so131081qab.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Apr 2012 15:57:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: svenkatr@ti.com, James.Bottomley@HansenPartnership.com, linkinjeon@gmail.com, santoshsy@gmail.com


The patch titled
     Subject: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
has been added to the -mm tree.  Its filename is
     drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch

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
Subject: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic

Otherwise it counter intuitively returns 0 if device is present.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -232,11 +232,11 @@ static inline u32 ufshcd_get_ufs_version
  *			      the host controller
  * @reg_hcs - host controller status register value
  *
- * Returns 0 if device present, non-zero if no device detected
+ * Returns 1 if device present, 0 if no device detected
  */
 static inline int ufshcd_is_device_present(u32 reg_hcs)
 {
-	return (DEVICE_PRESENT & reg_hcs) ? 0 : -1;
+	return (DEVICE_PRESENT & reg_hcs) ? 1 : 0;
 }
 
 /**
@@ -911,7 +911,7 @@ static int ufshcd_make_hba_operational(s
 
 	/* check if device present */
 	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
-	if (ufshcd_is_device_present(reg)) {
+	if (!ufshcd_is_device_present(reg)) {
 		dev_err(&hba->pdev->dev, "cc: Device not present\n");
 		err = -ENXIO;
 		goto out;
_
Subject: Subject: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic

Patches currently in -mm which might be from svenkatr@ti.com are

linux-next.patch
drivers-scsi-ufs-use-module_pci_driver.patch
drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch
drivers-scsi-ufs-fix-evaluation-of-task_failed-status.patch

