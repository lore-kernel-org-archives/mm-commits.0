From: akpm@linux-foundation.org
Subject: + mn10300-add-platform-mtd-support-for-the-asb2303-board.patch added to -mm tree
Date: Thu, 29 Nov 2007 17:46:05 -0800
Message-ID: <200711300146.lAU1k5LP017745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757618AbXK3BrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 20:47:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dwmw2@infradead.org


The patch titled
     mn10300: add platform MTD support for the ASB2303 board
has been added to the -mm tree.  Its filename is
     mn10300-add-platform-mtd-support-for-the-asb2303-board.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mn10300: add platform MTD support for the ASB2303 board
From: David Howells <dhowells@redhat.com>

Add platform MTD support for the ASB2303 board.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
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

git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
af_rxrpc-configure-crypto-correctly-for-af_rxrpc.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
nommu-add-new-vmalloc_user-and-remap_vmalloc_range-interfaces.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
mn10300-fix-mtd-jedec-probe-so-that-the-asb2303-bootprom-can-be-detected.patch
mutex-subsystem-synchro-test-module.patch
