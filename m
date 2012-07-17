From: akpm@linux-foundation.org
Subject: [merged] drivers-scsi-ufs-use-module_pci_driver.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:08 -0700
Message-ID: <20120717200409.36D105C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48048 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2GQUEL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:11 -0400
Received: by fat25 with SMTP id 25so47388fat.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: svenkatr@ti.com, JBottomley@parallels.com, santoshsy@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/ufs: use module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-scsi-ufs-use-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Venkatraman S <svenkatr@ti.com>
Subject: drivers/scsi/ufs: use module_pci_driver

Use macro module_pci_driver and get rid of boilerplate code.  No
functional changes.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-use-module_pci_driver drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-use-module_pci_driver
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1953,24 +1953,7 @@ static struct pci_driver ufshcd_pci_driv
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
