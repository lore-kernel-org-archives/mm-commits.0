From: akpm@linux-foundation.org
Subject: - drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:23:14 -0800
Message-ID: <200703070423.l274NExG019045@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbXCGEXW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:23:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, driver-support@fabric7.comsupport@fabric7.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/vioc/vioc_driver.c: replace pci_module_init with pci_register_driver
has been removed from the -mm tree.  Its filename was
     drivers-net-vioc-vioc_driverc-replace-pci_module_init-with-pci_register_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mtd-maps-ck804xromc-pci_module_init-to-pci_register_driver.patch
git-netdev-all.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
