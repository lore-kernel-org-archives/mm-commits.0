From: akpm@linux-foundation.org
Subject: - ata-ide-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:40:50 -0700
Message-ID: <200804261640.m3QGeoOd031066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758269AbYDZQtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, bzolnier@gmail.com, dbrownell@users.sourceforge.net, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     ATA/IDE: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     ata-ide-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ATA/IDE: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable ATA and IDE
platform drivers, to re-enable auto loading.

NOTE: both ata/pata_platform.c and ide/legacy/ide_platform.c claim to provide
"the" platform_pata driver, and there's no build-time mutual exclusion
mechanism.  This means that configs which enable both drivers will make some
trouble when hotplugging...

[dbrownell@users.sourceforge.net: more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_at32.c           |    3 +++
 drivers/ata/pata_bf54x.c          |    1 +
 drivers/ata/pata_ixp4xx_cf.c      |    1 +
 drivers/ata/pata_platform.c       |    1 +
 drivers/ata/pata_rb500_cf.c       |    3 +++
 drivers/ata/sata_mv.c             |    2 +-
 drivers/ide/arm/palm_bk3710.c     |    4 ++++
 drivers/ide/legacy/ide_platform.c |    2 ++
 8 files changed, 16 insertions(+), 1 deletion(-)

diff -puN drivers/ata/pata_at32.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ata/pata_at32.c
--- a/drivers/ata/pata_at32.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ata/pata_at32.c
@@ -381,6 +381,9 @@ static int __exit pata_at32_remove(struc
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:at32_ide");
+
 static struct platform_driver pata_at32_driver = {
 	.remove	       = __exit_p(pata_at32_remove),
 	.driver	       = {
diff -puN drivers/ata/pata_bf54x.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ata/pata_bf54x.c
--- a/drivers/ata/pata_bf54x.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ata/pata_bf54x.c
@@ -1601,3 +1601,4 @@ MODULE_AUTHOR("Sonic Zhang <sonic.zhang@
 MODULE_DESCRIPTION("PATA driver for blackfin 54x ATAPI controller");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
diff -puN drivers/ata/pata_ixp4xx_cf.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ata/pata_ixp4xx_cf.c
--- a/drivers/ata/pata_ixp4xx_cf.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ata/pata_ixp4xx_cf.c
@@ -221,6 +221,7 @@ MODULE_AUTHOR("Alessandro Zummo <a.zummo
 MODULE_DESCRIPTION("low-level driver for ixp4xx Compact Flash PATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
 
 module_init(ixp4xx_pata_init);
 module_exit(ixp4xx_pata_exit);
diff -puN drivers/ata/pata_platform.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ata/pata_platform.c
--- a/drivers/ata/pata_platform.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ata/pata_platform.c
@@ -277,3 +277,4 @@ MODULE_AUTHOR("Paul Mundt");
 MODULE_DESCRIPTION("low-level driver for platform device ATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
diff -puN drivers/ata/pata_rb500_cf.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ata/pata_rb500_cf.c
--- a/drivers/ata/pata_rb500_cf.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ata/pata_rb500_cf.c
@@ -239,6 +239,9 @@ static __devexit int rb500_pata_driver_r
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" DRV_NAME);
+
 static struct platform_driver rb500_pata_platform_driver = {
 	.probe		= rb500_pata_driver_probe,
 	.remove		= __devexit_p(rb500_pata_driver_remove),
diff -puN drivers/ata/sata_mv.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ata/sata_mv.c
@@ -3122,7 +3122,7 @@ MODULE_DESCRIPTION("SCSI low-level drive
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
-MODULE_ALIAS("platform:sata_mv");
+MODULE_ALIAS("platform:" DRV_NAME);
 
 #ifdef CONFIG_PCI
 module_param(msi, int, 0444);
diff -puN drivers/ide/arm/palm_bk3710.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ide/arm/palm_bk3710.c
--- a/drivers/ide/arm/palm_bk3710.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ide/arm/palm_bk3710.c
@@ -409,9 +409,13 @@ out:
 	return -ENODEV;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:palm_bk3710");
+
 static struct platform_driver platform_bk_driver = {
 	.driver = {
 		.name = "palm_bk3710",
+		.owner = THIS_MODULE,
 	},
 	.probe = palm_bk3710_probe,
 	.remove = NULL,
diff -puN drivers/ide/legacy/ide_platform.c~ata-ide-fix-platform-driver-hotplug-coldplug drivers/ide/legacy/ide_platform.c
--- a/drivers/ide/legacy/ide_platform.c~ata-ide-fix-platform-driver-hotplug-coldplug
+++ a/drivers/ide/legacy/ide_platform.c
@@ -130,6 +130,7 @@ static int __devexit plat_ide_remove(str
 static struct platform_driver platform_ide_driver = {
 	.driver = {
 		.name = "pata_platform",
+		.owner = THIS_MODULE,
 	},
 	.probe = plat_ide_probe,
 	.remove = __devexit_p(plat_ide_remove),
@@ -147,6 +148,7 @@ static void __exit platform_ide_exit(voi
 
 MODULE_DESCRIPTION("Platform IDE driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pata_platform");
 
 module_init(platform_ide_init);
 module_exit(platform_ide_exit);
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
git-scsi-misc.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

