From: akpm@linux-foundation.org
Subject: + drivers-scsi-ufs-use-module_pci_driver.patch added to -mm tree
Date: Tue, 10 Apr 2012 11:30:36 -0700
Message-ID: <20120410183038.E3FA0A035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33281 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab2DJSal (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 14:30:41 -0400
Received: by eekc41 with SMTP id c41so3723eek.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Apr 2012 11:30:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: svenkatr@ti.com, JBottomley@parallels.com, santoshsy@gmail.com


The patch titled
     Subject: drivers/scsi/ufs: use module_pci_driver
has been added to the -mm tree.  Its filename is
     drivers-scsi-ufs-use-module_pci_driver.patch

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
Subject: drivers/scsi/ufs: use module_pci_driver

Use macro module_pci_driver and get rid of boilerplate code.  No
functional changes.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Cc: Santosh Yaraganavi <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-use-module_pci_driver drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-use-module_pci_driver
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1952,24 +1952,7 @@ static struct pci_driver ufshcd_pci_driv
 #endif
 };
 
-/**
- * ufshcd_init - Driver registration routine
- */
-static int __init ufshcd_init(void)
-{
-	return pci_register_driver(&ufshcd_pci_driver);
-}
-module_init(ufshcd_init);
-
-/**
- * ufshcd_exit - Driver exit clean-up routine
- */
-static void __exit ufshcd_exit(void)
-{
-	pci_unregister_driver(&ufshcd_pci_driver);
-}
-module_exit(ufshcd_exit);
