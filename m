From: akpm@linux-foundation.org
Subject: + mn10300-add-mtd-flash-support-for-the-asb2303-board.patch added to -mm tree
Date: Thu, 15 Nov 2007 15:53:53 -0800
Message-ID: <200711152353.lAFNrr66022389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190AbXKOXyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dwmw2@infradead.org


The patch titled
     MN10300: Add MTD flash support for the ASB2303 board 
has been added to the -mm tree.  Its filename is
     mn10300-add-mtd-flash-support-for-the-asb2303-board.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MN10300: Add MTD flash support for the ASB2303 board 
From: David Howells <dhowells@redhat.com>

Add MTD flash support for the ASB2303 board.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/configs/asb2303_defconfig |    1 
 drivers/mtd/chips/jedec_probe.c        |    2 
 drivers/mtd/maps/Kconfig               |    8 +
 drivers/mtd/maps/Makefile              |    1 
 drivers/mtd/maps/asb2303-flash.c       |  177 +++++++++++++++++++++++
 5 files changed, 189 insertions(+)

diff -puN arch/mn10300/configs/asb2303_defconfig~mn10300-add-mtd-flash-support-for-the-asb2303-board arch/mn10300/configs/asb2303_defconfig
--- a/arch/mn10300/configs/asb2303_defconfig~mn10300-add-mtd-flash-support-for-the-asb2303-board
+++ a/arch/mn10300/configs/asb2303_defconfig
@@ -282,6 +282,7 @@ CONFIG_MTD_CFI_UTIL=y
 # CONFIG_MTD_COMPLEX_MAPPINGS is not set
 # CONFIG_MTD_PHYSMAP is not set
 # CONFIG_MTD_PLATRAM is not set
+CONFIG_MTD_ASB2303=y
 
 #
 # Self-contained MTD device drivers
diff -puN drivers/mtd/chips/jedec_probe.c~mn10300-add-mtd-flash-support-for-the-asb2303-board drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~mn10300-add-mtd-flash-support-for-the-asb2303-board
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -1897,11 +1897,13 @@ static inline __u8 finfo_uaddr(const str
 
 	uaddr = finfo->uaddr[uaddr_idx];
 
+#ifndef CONFIG_MN10300_UNIT_ASB2303
 	if (uaddr != MTD_UADDR_NOT_SUPPORTED ) {
 		/* ASSERT("The unlock addresses for non-8-bit mode
 		   are bollocks. We don't really need an array."); */
 		uaddr = finfo->uaddr[0];
 	}
+#endif
 
  uaddr_done:
 	return uaddr;
diff -puN drivers/mtd/maps/Kconfig~mn10300-add-mtd-flash-support-for-the-asb2303-board drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mn10300-add-mtd-flash-support-for-the-asb2303-board
+++ a/drivers/mtd/maps/Kconfig
@@ -597,5 +597,13 @@ config MTD_PLATRAM
 
 	  This selection automatically selects the map_ram driver.
 
+config MTD_ASB2303
+	tristate "CFI Flash device mapped on MEI ASB2303"
+	depends on MTD_CFI && MN10300_UNIT_ASB2303 && MTD_PARTITIONS
+	help
+	  This enables access to the flash chips on the ASB2303 board with
+	  the MN10300 processor.
+	  Say 'Y' if you have this board.
+
 endmenu
 
diff -puN drivers/mtd/maps/Makefile~mn10300-add-mtd-flash-support-for-the-asb2303-board drivers/mtd/maps/Makefile
--- a/drivers/mtd/maps/Makefile~mn10300-add-mtd-flash-support-for-the-asb2303-board
+++ a/drivers/mtd/maps/Makefile
@@ -69,3 +69,4 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_MTX1)		+= mtx-1_flash.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
+obj-$(CONFIG_MTD_ASB2303)	+= asb2303-flash.o
diff -puN /dev/null drivers/mtd/maps/asb2303-flash.c
--- /dev/null
+++ a/drivers/mtd/maps/asb2303-flash.c
@@ -0,0 +1,177 @@
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
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/dma-mapping.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+#include <asm/io.h>
+
+#define PROM_ADDR	0xA0000000
+#define FLASH_ADDR	0xA4000000
+#define CONFIG_ADDR	0xA6000000
+
+static struct map_info asb2303_maps[2] = {
+	{
+		.name		= "BootPROM",
+		.size		= 2 * 1024 * 1024,
+		.bankwidth	= 2,
+		.phys		= PROM_ADDR,
+	}, {
+		.name		= "SysFlash",
+		.size		= 32 * 1024 * 1024,
+		.bankwidth	= 4,
+		.phys		= FLASH_ADDR,
+	}
+};
+
+static struct mtd_partition asb2303_partitions[] = {
+	{
+		.name		= "Bootloader",
+		.size		= 0x00040000,
+		.offset		= 0,
+		.mask_flags	= MTD_WRITEABLE  /* force read-only */
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
+static struct mtd_info *mymtds[3];
+static struct mtd_partition *parsed_parts[3];
+static int nr_parsed_parts[3];
+
+static const char *probes[] = { "RedBoot", "cmdlinepart", NULL };
+
+static int __init init_asb2303(void)
+{
+	int ret = 0, nr, i;
+
+	for (i = 0; i < ARRAY_SIZE(asb2303_maps); i++) {
+		printk(KERN_NOTICE
+		       "Probing ASB2303 %s device: %08lx at %08lx\n",
+		       asb2303_maps[i].name,
+		       asb2303_maps[i].size,
+		       (unsigned long) asb2303_maps[i].phys);
+
+		asb2303_maps[i].map_priv_1 = 0;
+		asb2303_maps[i].virt = ioremap(asb2303_maps[i].phys,
+					       asb2303_maps[i].size);
+		if (!asb2303_maps[i].virt) {
+			printk(KERN_WARNING
+			       "Failed to ioremap %s\n",
+			       asb2303_maps[i].name);
+
+			if (!ret)
+				ret = -ENOMEM;
+			continue;
+		}
+
+		simple_map_init(&asb2303_maps[i]);
+
+		printk(KERN_NOTICE
+		       "Probing %s at physical address 0x%08lx"
+		       " (%d-bit bankwidth)\n",
+		       asb2303_maps[i].name,
+		       (unsigned long) asb2303_maps[i].phys,
+		       asb2303_maps[i].bankwidth * 8);
+
+		mymtds[i] = do_map_probe("cfi_probe", &asb2303_maps[i]);
+		if (!mymtds[i])
+			mymtds[i] = do_map_probe("jedec_probe",
+						 &asb2303_maps[i]);
+
+		if (!mymtds[i]) {
+			iounmap((void *) asb2303_maps[i].virt);
+			if (asb2303_maps[i].cached)
+				iounmap(asb2303_maps[i].cached);
+			if (!ret)
+				ret = -EIO;
+			continue;
+		}
+
+		mymtds[i]->owner = THIS_MODULE;
+
+		nr = parse_mtd_partitions(mymtds[i], probes,
+					  &parsed_parts[i], 0);
+
+		if (nr > 0)
+			nr_parsed_parts[i] = nr;
+		else if (nr < 0)
+			ret = nr;
+	}
+
+	if (!mymtds[0] && !mymtds[1] && !mymtds[2])
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(asb2303_maps); i++) {
+		if (!mymtds[i]) {
+			printk(KERN_WARNING
+			       "%s is absent. Skipping\n",
+			       asb2303_maps[i].name);
+		} else if (nr_parsed_parts[i]) {
+			add_mtd_partitions(mymtds[i],
+					   parsed_parts[i],
+					   nr_parsed_parts[i]);
+		} else if (!i) {
+			printk(KERN_INFO
+			       "Using static partitions on %s\n",
+			       asb2303_maps[i].name);
+			add_mtd_partitions(mymtds[i], asb2303_partitions,
+					   ARRAY_SIZE(asb2303_partitions));
+		} else {
+			printk(KERN_INFO
+			       "Registering %s as whole device\n",
+			       asb2303_maps[i].name);
+			add_mtd_device(mymtds[i]);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit cleanup_asb2303(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mymtds); i++) {
+		if (!mymtds[i])
+			continue;
+
+		if (nr_parsed_parts[i] || !i)
+			del_mtd_partitions(mymtds[i]);
+		else
+			del_mtd_device(mymtds[i]);
+
+		map_destroy(mymtds[i]);
+
+		iounmap((void *) asb2303_maps[i].virt);
+		if (asb2303_maps[i].cached)
+			iounmap(asb2303_maps[i].cached);
+
+		kfree(parsed_parts[i]);
+	}
+}
+
+module_init(init_asb2303);
+module_exit(cleanup_asb2303);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Howells <dhowells@redhat.com>");
+MODULE_DESCRIPTION("MTD map driver for MEI ASB2303");
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
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
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
mtd-add-support-for-the-sst-39vf1601-flash-chip.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-mtd-flash-support-for-the-asb2303-board.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mutex-subsystem-synchro-test-module.patch
