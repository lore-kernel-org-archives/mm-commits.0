From: akpm@linux-foundation.org
Subject: - mtd-nand-fix-platform-driver-hotplug-coldplug.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:41:28 -0700
Message-ID: <200804261641.m3QGfSKv031127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211AbYDZQmN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtd nand: fix platform driver hotplug/coldplug
has been removed from the -mm tree.  Its filename was
     mtd-nand-fix-platform-driver-hotplug-coldplug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd nand: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable MTD NAND
platform drivers, to re-enable auto loading.

NOTE: at91_nand for some reason disallows modular builds.  I'm assuming that's
just an oversight that will be fixed.

[dbrownell@users.sourceforge.net: minor fix]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/at91_nand.c  |    1 +
 drivers/mtd/nand/bf5xx_nand.c |    1 +
 drivers/mtd/nand/ndfc.c       |    2 ++
 drivers/mtd/nand/orion_nand.c |    1 +
 drivers/mtd/nand/plat_nand.c  |    1 +
 drivers/mtd/nand/s3c2410.c    |    3 +++
 6 files changed, 9 insertions(+)

diff -puN drivers/mtd/nand/at91_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug drivers/mtd/nand/at91_nand.c
--- a/drivers/mtd/nand/at91_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/nand/at91_nand.c
@@ -234,3 +234,4 @@ module_exit(at91_nand_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rick Bronson");
 MODULE_DESCRIPTION("NAND/SmartMedia driver for AT91RM9200");
+MODULE_ALIAS("platform:at91_nand");
diff -puN drivers/mtd/nand/bf5xx_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug drivers/mtd/nand/bf5xx_nand.c
--- a/drivers/mtd/nand/bf5xx_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/nand/bf5xx_nand.c
@@ -803,3 +803,4 @@ module_exit(bf5xx_nand_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRV_AUTHOR);
 MODULE_DESCRIPTION(DRV_DESC);
+MODULE_ALIAS("platform:" DRV_NAME);
diff -puN drivers/mtd/nand/ndfc.c~mtd-nand-fix-platform-driver-hotplug-coldplug drivers/mtd/nand/ndfc.c
--- a/drivers/mtd/nand/ndfc.c~mtd-nand-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/nand/ndfc.c
@@ -317,3 +317,5 @@ module_exit(ndfc_nand_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Thomas Gleixner <tglx@linutronix.de>");
 MODULE_DESCRIPTION("Platform driver for NDFC");
+MODULE_ALIAS("platform:ndfc-chip");
+MODULE_ALIAS("platform:ndfc-nand");
diff -puN drivers/mtd/nand/orion_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug drivers/mtd/nand/orion_nand.c
--- a/drivers/mtd/nand/orion_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/nand/orion_nand.c
@@ -169,3 +169,4 @@ module_exit(orion_nand_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tzachi Perelstein");
 MODULE_DESCRIPTION("NAND glue for Orion platforms");
+MODULE_ALIAS("platform:orion_nand");
diff -puN drivers/mtd/nand/plat_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug drivers/mtd/nand/plat_nand.c
--- a/drivers/mtd/nand/plat_nand.c~mtd-nand-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/nand/plat_nand.c
@@ -150,3 +150,4 @@ module_exit(plat_nand_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vitaly Wool");
 MODULE_DESCRIPTION("Simple generic NAND driver");
+MODULE_ALIAS("platform:gen_nand");
diff -puN drivers/mtd/nand/s3c2410.c~mtd-nand-fix-platform-driver-hotplug-coldplug drivers/mtd/nand/s3c2410.c
--- a/drivers/mtd/nand/s3c2410.c~mtd-nand-fix-platform-driver-hotplug-coldplug
+++ a/drivers/mtd/nand/s3c2410.c
@@ -927,3 +927,6 @@ module_exit(s3c2410_nand_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("S3C24XX MTD NAND driver");
+MODULE_ALIAS("platform:s3c2410-nand");
+MODULE_ALIAS("platform:s3c2412-nand");
+MODULE_ALIAS("platform:s3c2440-nand");
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

