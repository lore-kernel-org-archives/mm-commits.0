From: akpm@linux-foundation.org
Subject: + drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:47:59 -0800
Message-ID: <200702272048.l1RKm3Jv027997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51106 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbXB0UsM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:48:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, driver-support@fabric7.comsupport@fabric7.com


The patch titled
     drivers/net/vioc/vioc_driver.c: replace pci_module_init with pci_register_driver
has been added to the -mm tree.  Its filename is
     drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/net/vioc/vioc_driver.c: replace pci_module_init with pci_register_driver
From: Richard Knutsson <ricknu-0@student.ltu.se>

Replace pci_module_init with pci_register_driver

Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
Cc: <support@fabric7.com>
Cc: <driver-support@fabric7.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/vioc/vioc_driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/vioc/vioc_driver.c~drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver drivers/net/vioc/vioc_driver.c
--- a/drivers/net/vioc/vioc_driver.c~drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver
+++ a/drivers/net/vioc/vioc_driver.c
@@ -841,9 +841,9 @@ static int __init vioc_module_init(void)
 	vioc_irq_init();
 	spp_init();
 
-	ret = pci_module_init(&vioc_driver);
+	ret = pci_register_driver(&vioc_driver);
 	if (ret) {
-		printk(KERN_ERR "%s: pci_module_init() -> %d\n", __FUNCTION__,
+		printk(KERN_ERR "%s: pci_register_driver() -> %d\n", __FUNCTION__,
 		       ret);
 		vioc_irq_exit();
 		return ret;
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

git-dvb.patch
ide-pci-delkin_cbc-pci_module_init-to-pci_register_driver.patch
mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
drivers-mfd-sm501c-replace-pci_module_init-with-pci_register_driver.patch
