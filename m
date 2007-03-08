From: akpm@linux-foundation.org
Subject: - mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch removed from -mm tree
Date: Thu, 08 Mar 2007 01:36:34 -0800
Message-ID: <200703080936.l289aYrh024337@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030419AbXCHJgs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 04:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd/maps/ck804xrom.c: pci_module_init to pci_register_driver
has been removed from the -mm tree.  Its filename was
     mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: mtd/maps/ck804xrom.c: pci_module_init to pci_register_driver
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/ck804xrom.c |   12 ------------
 1 file changed, 12 deletions(-)

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

mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
git-netdev-all.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
