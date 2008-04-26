From: akpm@linux-foundation.org
Subject: - mtd-maps-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:26 -0700
Message-ID: <200804261641.m3QGfQeS031124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757234AbYDZQmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd maps: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     mtd-maps-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd maps: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable MTD mapping
platform drivers, to re-enable auto loading.

NOTE oddness with physmap ...  it's a legacy driver in some configs, which
means it can't always support hotplugging.  (Not that most of these mapping
drivers would often be used as modules...)

[dbrownell@users.sourceforge.net: bugfix, more drivers, registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/bast-flash.c       |    1 +
 drivers/mtd/maps/integrator-flash.c |    2 ++
 drivers/mtd/maps/ixp2000.c          |    3 ++-
 drivers/mtd/maps/ixp4xx.c           |    2 ++
 drivers/mtd/maps/omap_nor.c         |    3 ++-
 drivers/mtd/maps/physmap.c          |    8 ++++++++
 drivers/mtd/maps/plat-ram.c         |    3 +++
 drivers/mtd/maps/sa1100-flash.c     |    2 ++
 8 files changed, 22 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/maps/bast-flash.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/bast-flash.c
--- a/drivers/mtd/maps/bast-flash.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/bast-flash.c
@@ -223,3 +223,4 @@ module_exit(bast_flash_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("BAST MTD Map driver");
+MODULE_ALIAS("platform:bast-nor");
diff -puN drivers/mtd/maps/integrator-flash.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/integrator-flash.c
--- a/drivers/mtd/maps/integrator-flash.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/integrator-flash.c
@@ -190,6 +190,7 @@ static struct platform_driver armflash_d
 	.remove		= armflash_remove,
 	.driver		= {
 		.name	= "armflash",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -209,3 +210,4 @@ module_exit(armflash_exit);
 MODULE_AUTHOR("ARM Ltd");
 MODULE_DESCRIPTION("ARM Integrator CFI map driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:armflash");
diff -puN drivers/mtd/maps/ixp2000.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/ixp2000.c
--- a/drivers/mtd/maps/ixp2000.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/ixp2000.c
@@ -253,6 +253,7 @@ static struct platform_driver ixp2000_fl
 	.remove		= ixp2000_flash_remove,
 	.driver		= {
 		.name	= "IXP2000-Flash",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -270,4 +271,4 @@ module_init(ixp2000_flash_init);
 module_exit(ixp2000_flash_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
-
+MODULE_ALIAS("platform:IXP2000-Flash");
diff -puN drivers/mtd/maps/ixp4xx.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/ixp4xx.c
--- a/drivers/mtd/maps/ixp4xx.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/ixp4xx.c
@@ -275,6 +275,7 @@ static struct platform_driver ixp4xx_fla
 	.remove		= ixp4xx_flash_remove,
 	.driver		= {
 		.name	= "IXP4XX-Flash",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -295,3 +296,4 @@ module_exit(ixp4xx_flash_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MTD map driver for Intel IXP4xx systems");
 MODULE_AUTHOR("Deepak Saxena");
+MODULE_ALIAS("platform:IXP4XX-Flash");
diff -puN drivers/mtd/maps/omap_nor.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/omap_nor.c
--- a/drivers/mtd/maps/omap_nor.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/omap_nor.c
@@ -156,6 +156,7 @@ static struct platform_driver omapflash_
 	.remove	= __devexit_p(omapflash_remove),
 	.driver = {
 		.name	= "omapflash",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -174,4 +175,4 @@ module_exit(omapflash_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MTD NOR map driver for TI OMAP boards");
-
+MODULE_ALIAS("platform:omapflash");
diff -puN drivers/mtd/maps/physmap.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/physmap.c
@@ -242,6 +242,7 @@ static struct platform_driver physmap_fl
 	.shutdown	= physmap_flash_shutdown,
 	.driver		= {
 		.name	= "physmap-flash",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -319,3 +320,10 @@ module_exit(physmap_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("Generic configurable MTD map driver");
+
+/* legacy platform drivers can't hotplug or coldplg */
+#ifndef PHYSMAP_COMPAT
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:physmap-flash");
+#endif
+
diff -puN drivers/mtd/maps/plat-ram.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/plat-ram.c
--- a/drivers/mtd/maps/plat-ram.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/plat-ram.c
@@ -251,6 +251,9 @@ static int platram_probe(struct platform
 
 /* device driver info */
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:mtd-ram");
+
 static struct platform_driver platram_driver = {
 	.probe		= platram_probe,
 	.remove		= platram_remove,
diff -puN drivers/mtd/maps/sa1100-flash.c~mtd-maps-fix-platform-driver-hotplug-coldplug drivers/mtd/maps/sa1100-flash.c
--- a/drivers/mtd/maps/sa1100-flash.c~mtd-maps-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/maps/sa1100-flash.c
@@ -456,6 +456,7 @@ static struct platform_driver sa1100_mtd
 	.shutdown	= sa1100_mtd_shutdown,
 	.driver		= {
 		.name	= "flash",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -475,3 +476,4 @@ module_exit(sa1100_mtd_exit);
 MODULE_AUTHOR("Nicolas Pitre");
 MODULE_DESCRIPTION("SA1100 CFI map driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:flash");
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

