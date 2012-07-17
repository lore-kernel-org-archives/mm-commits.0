From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:12 -0700
Message-ID: <20120717200412.AC7601E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37106 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2GQUEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:13 -0400
Received: by ggeh3 with SMTP id h3so82259gge.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svenkatr@ti.com, James.Bottomley@HansenPartnership.com, linkinjeon@gmail.com, santoshsy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ufs: reverse the ufshcd_is_device_present logic
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ufs-reverse-the-ufshcd_is_device_present-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from svenkatr@ti.com are

linux-next.patch

