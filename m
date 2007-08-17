From: akpm@linux-foundation.org
Subject: + fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:19:28 -0700
Message-ID: <200708172119.l7HLJSus029904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764634AbXHQVTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.korty@ccur.com, James.Bottomley@steeleye.com, aacraid@adaptec.com


The patch titled
     Fix section mismatch in the Adaptec DPT SCSI Raid driver
has been added to the -mm tree.  Its filename is
     fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix section mismatch in the Adaptec DPT SCSI Raid driver
From: Joe Korty <joe.korty@ccur.com>

Fix section mismatch in the Adaptec DPT SCSI Raid driver.

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: <aacraid@adaptec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/dpt_i2o.c~fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver
+++ a/drivers/scsi/dpt_i2o.c
@@ -3346,7 +3346,7 @@ static int __init adpt_init(void)
 	return count > 0 ? 0 : -ENODEV;
 }
 
-static void __exit adpt_exit(void)
+static void adpt_exit(void)
 {
 	while (hba_chain)
 		adpt_release(hba_chain);
_

Patches currently in -mm which might be from joe.korty@ccur.com are

fix-section-mismatch-in-the-adaptec-dpt-scsi-raid-driver.patch
