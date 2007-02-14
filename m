From: akpm@linux-foundation.org
Subject: + mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:53:27 -0800
Message-ID: <200702142253.l1EMrTe9011899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49968 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671AbXBNWxj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:53:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, dwmw2@infradead.org


The patch titled
     mtd/maps/ck804xrom.c: pci_module_init to pci_register_driver
has been added to the -mm tree.  Its filename is
     mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtd/maps/ck804xrom.c: pci_module_init to pci_register_driver
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/ck804xrom.c |   12 ------------
 1 files changed, 12 deletions(-)

diff -puN drivers/mtd/maps/ck804xrom.c~mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver drivers/mtd/maps/ck804xrom.c
--- a/drivers/mtd/maps/ck804xrom.c~mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver
+++ a/drivers/mtd/maps/ck804xrom.c
@@ -310,15 +310,6 @@ static struct pci_device_id ck804xrom_pc
 
 MODULE_DEVICE_TABLE(pci, ck804xrom_pci_tbl);
 
-#if 0
-static struct pci_driver ck804xrom_driver = {
-	.name =		MOD_NAME,
-	.id_table =	ck804xrom_pci_tbl,
-	.probe =	ck804xrom_init_one,
-	.remove =	ck804xrom_remove_one,
-};
-#endif
-
 static int __init init_ck804xrom(void)
 {
 	struct pci_dev *pdev;
@@ -337,9 +328,6 @@ static int __init init_ck804xrom(void)
 		return retVal;
 	}
 	return -ENXIO;
-#if 0
-	return pci_module_init(&ck804xrom_driver);
-#endif
 }
 
 static void __exit cleanup_ck804xrom(void)
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
git-dvb.patch
drivers-scsi-aic7xxx-convert-to-generic-boolean-values.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch
mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
net-wan-pc300tooc-pci_module_init-to-pci_register_driver.patch
