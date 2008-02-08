From: akpm@linux-foundation.org
Subject: - mn10300-add-platform-mtd-support-for-the-asb2303-board.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:23 -0800
Message-ID: <200802082015.m18KF4ua010501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbYBHUwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:52:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mn10300: add platform MTD support for the ASB2303 board
has been removed from the -mm tree.  Its filename was
     mn10300-add-platform-mtd-support-for-the-asb2303-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: add platform MTD support for the ASB2303 board
From: David Howells <dhowells@redhat.com>

Add platform MTD support for the ASB2303 board.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/configs/asb2303_defconfig |    5 -
 arch/mn10300/unit-asb2303/Makefile     |    2 
 arch/mn10300/unit-asb2303/flash.c      |  100 +++++++++++++++++++++++
 3 files changed, 105 insertions(+), 2 deletions(-)

diff -puN arch/mn10300/configs/asb2303_defconfig~mn10300-add-platform-mtd-support-for-the-asb2303-board arch/mn10300/configs/asb2303_defconfig
--- a/arch/mn10300/configs/asb2303_defconfig~mn10300-add-platform-mtd-support-for-the-asb2303-board
+++ a/arch/mn10300/configs/asb2303_defconfig
@@ -282,7 +282,10 @@ CONFIG_MTD_CFI_UTIL=y
 # Mapping drivers for chip access
 #
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
-# CONFIG_MTD_PHYSMAP is not set
+CONFIG_MTD_PHYSMAP=y
+CONFIG_MTD_PHYSMAP_START=0x8000000
+CONFIG_MTD_PHYSMAP_LEN=0x0
+CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 # CONFIG_MTD_PLATRAM is not set
 
 #
diff -puN arch/mn10300/unit-asb2303/Makefile~mn10300-add-platform-mtd-support-for-the-asb2303-board arch/mn10300/unit-asb2303/Makefile
--- a/arch/mn10300/unit-asb2303/Makefile~mn10300-add-platform-mtd-support-for-the-asb2303-board
+++ a/arch/mn10300/unit-asb2303/Makefile
@@ -3,4 +3,4 @@
 # Makefile for the ASB2303 board
 #
 ###############################################################################
-obj-y   := unit-init.o smc91111.o leds.o
+obj-y   := unit-init.o smc91111.o flash.o leds.o
diff -puN /dev/null arch/mn10300/unit-asb2303/flash.c
--- /dev/null
+++ a/arch/mn10300/unit-asb2303/flash.c
@@ -0,0 +1,100 @@
+/* Handle mapping of the flash on the ASB2303 board
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+
+#define ASB2303_PROM_ADDR	0xA0000000	/* Boot PROM */
+#define ASB2303_PROM_SIZE	(2 * 1024 * 1024)
+#define ASB2303_FLASH_ADDR	0xA4000000	/* System Flash */
+#define ASB2303_FLASH_SIZE	(32 * 1024 * 1024)
+#define ASB2303_CONFIG_ADDR	0xA6000000	/* System Config EEPROM */
+#define ASB2303_CONFIG_SIZE	(8 * 1024)
+
+/*
+ * default MTD partition table for both main flash devices, expected to be
+ * overridden by RedBoot
+ */
+static struct mtd_partition asb2303_partitions[] = {
+	{
+		.name		= "Bootloader",
+		.size		= 0x00040000,
+		.offset		= 0,
+		.mask_flags	= MTD_CAP_ROM /* force read-only */
+	}, {
+		.name		= "Kernel",
+		.size		= 0x00400000,
+		.offset		= 0x00040000,
+	}, {
+		.name		= "Filesystem",
+		.size		= MTDPART_SIZ_FULL,
+		.offset		= 0x00440000
+	}
+};
+
+/*
+ * the ASB2303 Boot PROM definition
+ */
+static struct physmap_flash_data asb2303_bootprom_data = {
+	.width		= 2,
+	.nr_parts	= 1,
+	.parts		= asb2303_partitions,
+};
+
+static struct resource asb2303_bootprom_resource = {
+	.start		= ASB2303_PROM_ADDR,
+	.end		= ASB2303_PROM_ADDR + ASB2303_PROM_SIZE,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device asb2303_bootprom = {
+	.name		= "physmap-flash",
+	.id		= 0,
+	.dev.platform_data = &asb2303_bootprom_data,
+	.num_resources	= 1,
+	.resource	= &asb2303_bootprom_resource,
+};
+
+/*
+ * the ASB2303 System Flash definition
+ */
+static struct physmap_flash_data asb2303_sysflash_data = {
+	.width		= 4,
+	.nr_parts	= 1,
+	.parts		= asb2303_partitions,
+};
+
+static struct resource asb2303_sysflash_resource = {
+	.start		= ASB2303_FLASH_ADDR,
+	.end		= ASB2303_FLASH_ADDR + ASB2303_FLASH_SIZE,
+	.flags		= IORESOURCE_MEM,
+};
+
+static struct platform_device asb2303_sysflash = {
+	.name		= "physmap-flash",
+	.id		= 1,
+	.dev.platform_data = &asb2303_sysflash_data,
+	.num_resources	= 1,
+	.resource	= &asb2303_sysflash_resource,
+};
+
+/*
+ * register the ASB2303 flashes
+ */
+static int __init asb2303_mtd_init(void)
+{
+	platform_device_register(&asb2303_bootprom);
+	platform_device_register(&asb2303_sysflash);
+	return 0;
+}
+
+module_init(asb2303_mtd_init);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
