From: akpm@linux-foundation.org
Subject: [merged] nommu-present-backing-device-capabilities-for-mtd-chardevs.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:44 -0700
Message-ID: <200903301906.n2UJ6ice019164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758554AbZC3TLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bernd.schmidt@analog.com, dwmw2@infradead.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     nommu: present backing device capabilities for MTD chardevs
has been removed from the -mm tree.  Its filename was
     nommu-present-backing-device-capabilities-for-mtd-chardevs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: present backing device capabilities for MTD chardevs
From: David Howells <dhowells@redhat.com>

Present backing device capabilities for MTD character device files to
allow NOMMU mmap to do direct mapping where possible.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Bernd Schmidt <bernd.schmidt@analog.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/Makefile         |    2 -
 drivers/mtd/chips/map_ram.c  |   17 ++++++++
 drivers/mtd/chips/map_rom.c  |   17 ++++++++
 drivers/mtd/devices/mtdram.c |   14 +++++++
 drivers/mtd/internal.h       |   17 ++++++++
 drivers/mtd/mtdbdi.c         |   43 ++++++++++++++++++++++
 drivers/mtd/mtdchar.c        |   63 ++++++++++++++++++++++++++++++++-
 drivers/mtd/mtdcore.c        |   15 +++++++
 drivers/mtd/mtdpart.c        |   15 +++++++
 include/linux/mtd/mtd.h      |   14 +++++++
 10 files changed, 215 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/Makefile~nommu-present-backing-device-capabilities-for-mtd-chardevs drivers/mtd/Makefile
--- a/drivers/mtd/Makefile~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/drivers/mtd/Makefile
@@ -4,7 +4,7 @@
 
 # Core functionality.
 obj-$(CONFIG_MTD)		+= mtd.o
-mtd-y				:= mtdcore.o mtdsuper.o
+mtd-y				:= mtdcore.o mtdsuper.o mtdbdi.o
 mtd-$(CONFIG_MTD_PARTITIONS)	+= mtdpart.o
 
 obj-$(CONFIG_MTD_CONCAT)	+= mtdconcat.o
diff -puN drivers/mtd/chips/map_ram.c~nommu-present-backing-device-capabilities-for-mtd-chardevs drivers/mtd/chips/map_ram.c
--- a/drivers/mtd/chips/map_ram.c~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/drivers/mtd/chips/map_ram.c
@@ -21,6 +21,8 @@ static int mapram_write (struct mtd_info
 static int mapram_erase (struct mtd_info *, struct erase_info *);
 static void mapram_nop (struct mtd_info *);
 static struct mtd_info *map_ram_probe(struct map_info *map);
+static unsigned long mapram_unmapped_area(struct mtd_info *, unsigned long,
+					  unsigned long, unsigned long);
 
 
 static struct mtd_chip_driver mapram_chipdrv = {
@@ -64,6 +66,7 @@ static struct mtd_info *map_ram_probe(st
 	mtd->type = MTD_RAM;
 	mtd->size = map->size;
 	mtd->erase = mapram_erase;
+	mtd->get_unmapped_area = mapram_unmapped_area;
 	mtd->read = mapram_read;
 	mtd->write = mapram_write;
 	mtd->sync = mapram_nop;
@@ -79,6 +82,20 @@ static struct mtd_info *map_ram_probe(st
 }
 
 
+/*
+ * Allow NOMMU mmap() to directly map the device (if not NULL)
+ * - return the address to which the offset maps
+ * - return -ENOSYS to indicate refusal to do the mapping
+ */
+static unsigned long mapram_unmapped_area(struct mtd_info *mtd,
+					  unsigned long len,
+					  unsigned long offset,
+					  unsigned long flags)
+{
+	struct map_info *map = mtd->priv;
+	return (unsigned long) map->virt + offset;
+}
+
 static int mapram_read (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf)
 {
 	struct map_info *map = mtd->priv;
diff -puN drivers/mtd/chips/map_rom.c~nommu-present-backing-device-capabilities-for-mtd-chardevs drivers/mtd/chips/map_rom.c
--- a/drivers/mtd/chips/map_rom.c~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/drivers/mtd/chips/map_rom.c
@@ -20,6 +20,8 @@ static int maprom_write (struct mtd_info
 static void maprom_nop (struct mtd_info *);
 static struct mtd_info *map_rom_probe(struct map_info *map);
 static int maprom_erase (struct mtd_info *mtd, struct erase_info *info);
+static unsigned long maprom_unmapped_area(struct mtd_info *, unsigned long,
+					  unsigned long, unsigned long);
 
 static struct mtd_chip_driver maprom_chipdrv = {
 	.probe	= map_rom_probe,
@@ -40,6 +42,7 @@ static struct mtd_info *map_rom_probe(st
 	mtd->name = map->name;
 	mtd->type = MTD_ROM;
 	mtd->size = map->size;
+	mtd->get_unmapped_area = maprom_unmapped_area;
 	mtd->read = maprom_read;
 	mtd->write = maprom_write;
 	mtd->sync = maprom_nop;
@@ -53,6 +56,20 @@ static struct mtd_info *map_rom_probe(st
 }
 
 
+/*
+ * Allow NOMMU mmap() to directly map the device (if not NULL)
+ * - return the address to which the offset maps
+ * - return -ENOSYS to indicate refusal to do the mapping
+ */
+static unsigned long maprom_unmapped_area(struct mtd_info *mtd,
+					  unsigned long len,
+					  unsigned long offset,
+					  unsigned long flags)
+{
+	struct map_info *map = mtd->priv;
+	return (unsigned long) map->virt + offset;
+}
+
 static int maprom_read (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf)
 {
 	struct map_info *map = mtd->priv;
diff -puN drivers/mtd/devices/mtdram.c~nommu-present-backing-device-capabilities-for-mtd-chardevs drivers/mtd/devices/mtdram.c
--- a/drivers/mtd/devices/mtdram.c~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/drivers/mtd/devices/mtdram.c
@@ -65,6 +65,19 @@ static void ram_unpoint(struct mtd_info 
 {
 }
 
+/*
+ * Allow NOMMU mmap() to directly map the device (if not NULL)
+ * - return the address to which the offset maps
+ * - return -ENOSYS to indicate refusal to do the mapping
+ */
+static unsigned long ram_get_unmapped_area(struct mtd_info *mtd,
+					   unsigned long len,
+					   unsigned long offset,
+					   unsigned long flags)
+{
+	return (unsigned long) mtd->priv + offset;
+}
+
 static int ram_read(struct mtd_info *mtd, loff_t from, size_t len,
 		size_t *retlen, u_char *buf)
 {
@@ -116,6 +129,7 @@ int mtdram_init_device(struct mtd_info *
 	mtd->erase = ram_erase;
 	mtd->point = ram_point;
 	mtd->unpoint = ram_unpoint;
+	mtd->get_unmapped_area = ram_get_unmapped_area;
 	mtd->read = ram_read;
 	mtd->write = ram_write;
 
diff -puN /dev/null drivers/mtd/internal.h
--- /dev/null
+++ a/drivers/mtd/internal.h
@@ -0,0 +1,17 @@
+/* Internal MTD definitions
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * mtdbdi.c
+ */
+extern struct backing_dev_info mtd_bdi_unmappable;
+extern struct backing_dev_info mtd_bdi_ro_mappable;
+extern struct backing_dev_info mtd_bdi_rw_mappable;
diff -puN /dev/null drivers/mtd/mtdbdi.c
--- /dev/null
+++ a/drivers/mtd/mtdbdi.c
@@ -0,0 +1,43 @@
+/* MTD backing device capabilities
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/backing-dev.h>
+#include <linux/mtd/mtd.h>
+#include "internal.h"
+
+/*
+ * backing device capabilities for non-mappable devices (such as NAND flash)
+ * - permits private mappings, copies are taken of the data
+ */
+struct backing_dev_info mtd_bdi_unmappable = {
+	.capabilities	= BDI_CAP_MAP_COPY,
+};
+
+/*
+ * backing device capabilities for R/O mappable devices (such as ROM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_ro_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
+};
+
+/*
+ * backing device capabilities for writable mappable devices (such as RAM)
+ * - permits private mappings, copies are taken of the data
+ * - permits non-writable shared mappings
+ */
+struct backing_dev_info mtd_bdi_rw_mappable = {
+	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
+			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
+			   BDI_CAP_WRITE_MAP),
+};
diff -puN drivers/mtd/mtdchar.c~nommu-present-backing-device-capabilities-for-mtd-chardevs drivers/mtd/mtdchar.c
--- a/drivers/mtd/mtdchar.c~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/drivers/mtd/mtdchar.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/compatmac.h>
@@ -107,12 +108,15 @@ static int mtd_open(struct inode *inode,
 		goto out;
 	}
 
-	if (MTD_ABSENT == mtd->type) {
+	if (mtd->type == MTD_ABSENT) {
 		put_mtd_device(mtd);
 		ret = -ENODEV;
 		goto out;
 	}
 
+	if (mtd->backing_dev_info)
+		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
+
 	/* You can't open it RW if it's not a writeable device */
 	if ((file->f_mode & FMODE_WRITE) && !(mtd->flags & MTD_WRITEABLE)) {
 		put_mtd_device(mtd);
@@ -781,6 +785,59 @@ static int mtd_ioctl(struct inode *inode
 	return ret;
 } /* memory_ioctl */
 
+/*
+ * try to determine where a shared mapping can be made
+ * - only supported for NOMMU at the moment (MMU can't doesn't copy private
+ *   mappings)
+ */
+#ifndef CONFIG_MMU
+static unsigned long mtd_get_unmapped_area(struct file *file,
+					   unsigned long addr,
+					   unsigned long len,
+					   unsigned long pgoff,
+					   unsigned long flags)
+{
+	struct mtd_file_info *mfi = file->private_data;
+	struct mtd_info *mtd = mfi->mtd;
+
+	if (mtd->get_unmapped_area) {
+		unsigned long offset;
+
+		if (addr != 0)
+			return (unsigned long) -EINVAL;
+
+		if (len > mtd->size || pgoff >= (mtd->size >> PAGE_SHIFT))
+			return (unsigned long) -EINVAL;
+
+		offset = pgoff << PAGE_SHIFT;
+		if (offset > mtd->size - len)
+			return (unsigned long) -EINVAL;
+
+		return mtd->get_unmapped_area(mtd, len, offset, flags);
+	}
+
+	/* can't map directly */
+	return (unsigned long) -ENOSYS;
+}
+#endif
+
+/*
+ * set up a mapping for shared memory segments
+ */
+static int mtd_mmap(struct file *file, struct vm_area_struct *vma)
+{
+#ifdef CONFIG_MMU
+	struct mtd_file_info *mfi = file->private_data;
+	struct mtd_info *mtd = mfi->mtd;
+
+	if (mtd->type == MTD_RAM || mtd->type == MTD_ROM)
+		return 0;
+	return -ENOSYS;
+#else
+	return vma->vm_flags & VM_SHARED ? 0 : -ENOSYS;
+#endif
+}
+
 static const struct file_operations mtd_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= mtd_lseek,
@@ -789,6 +846,10 @@ static const struct file_operations mtd_
 	.ioctl		= mtd_ioctl,
 	.open		= mtd_open,
 	.release	= mtd_close,
+	.mmap		= mtd_mmap,
+#ifndef CONFIG_MMU
+	.get_unmapped_area = mtd_get_unmapped_area,
+#endif
 };
 
 static int __init init_mtdchar(void)
diff -puN drivers/mtd/mtdcore.c~nommu-present-backing-device-capabilities-for-mtd-chardevs drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/drivers/mtd/mtdcore.c
@@ -19,6 +19,7 @@
 #include <linux/proc_fs.h>
 
 #include <linux/mtd/mtd.h>
+#include "internal.h"
 
 #include "mtdcore.h"
 
@@ -46,6 +47,20 @@ int add_mtd_device(struct mtd_info *mtd)
 {
 	int i;
 
+	if (!mtd->backing_dev_info) {
+		switch (mtd->type) {
+		case MTD_RAM:
+			mtd->backing_dev_info = &mtd_bdi_rw_mappable;
+			break;
+		case MTD_ROM:
+			mtd->backing_dev_info = &mtd_bdi_ro_mappable;
+			break;
+		default:
+			mtd->backing_dev_info = &mtd_bdi_unmappable;
+			break;
+		}
+	}
+
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
 
diff -puN drivers/mtd/mtdpart.c~nommu-present-backing-device-capabilities-for-mtd-chardevs drivers/mtd/mtdpart.c
--- a/drivers/mtd/mtdpart.c~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/drivers/mtd/mtdpart.c
@@ -84,6 +84,18 @@ static void part_unpoint(struct mtd_info
 	part->master->unpoint(part->master, from + part->offset, len);
 }
 
+static unsigned long part_get_unmapped_area(struct mtd_info *mtd,
+					    unsigned long len,
+					    unsigned long offset,
+					    unsigned long flags)
+{
+	struct mtd_part *part = PART(mtd);
+
+	offset += part->offset;
+	return part->master->get_unmapped_area(part->master, len, offset,
+					       flags);
+}
+
 static int part_read_oob(struct mtd_info *mtd, loff_t from,
 		struct mtd_oob_ops *ops)
 {
@@ -342,6 +354,7 @@ static struct mtd_part *add_one_partitio
 
 	slave->mtd.name = part->name;
 	slave->mtd.owner = master->owner;
+	slave->mtd.backing_dev_info = master->backing_dev_info;
 
 	slave->mtd.read = part_read;
 	slave->mtd.write = part_write;
@@ -354,6 +367,8 @@ static struct mtd_part *add_one_partitio
 		slave->mtd.unpoint = part_unpoint;
 	}
 
+	if (master->get_unmapped_area)
+		slave->mtd.get_unmapped_area = part_get_unmapped_area;
 	if (master->read_oob)
 		slave->mtd.read_oob = part_read_oob;
 	if (master->write_oob)
diff -puN include/linux/mtd/mtd.h~nommu-present-backing-device-capabilities-for-mtd-chardevs include/linux/mtd/mtd.h
--- a/include/linux/mtd/mtd.h~nommu-present-backing-device-capabilities-for-mtd-chardevs
+++ a/include/linux/mtd/mtd.h
@@ -162,6 +162,20 @@ struct mtd_info {
 	/* We probably shouldn't allow XIP if the unpoint isn't a NULL */
 	void (*unpoint) (struct mtd_info *mtd, loff_t from, size_t len);
 
+	/* Allow NOMMU mmap() to directly map the device (if not NULL)
+	 * - return the address to which the offset maps
+	 * - return -ENOSYS to indicate refusal to do the mapping
+	 */
+	unsigned long (*get_unmapped_area) (struct mtd_info *mtd,
+					    unsigned long len,
+					    unsigned long offset,
+					    unsigned long flags);
+
+	/* Backing device capabilities for this device
+	 * - provides mmap capabilities
+	 */
+	struct backing_dev_info *backing_dev_info;
+
 
 	int (*read) (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf);
 	int (*write) (struct mtd_info *mtd, loff_t to, size_t len, size_t *retlen, const u_char *buf);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
kbuild-make-it-possible-for-the-linker-to-discard-local-symbols-from-vmlinux.patch
nommu-there-is-no-mlock-for-nommu-so-dont-provide-the-bits.patch
nommu-make-config_unevictable_lru-available-when-config_mmu=n.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch
bin_elf_fdpic-check-the-return-value-of-clear_user.patch
mutex-subsystem-synchro-test-module.patch

