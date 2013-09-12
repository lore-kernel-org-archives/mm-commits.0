From: akpm@linux-foundation.org
Subject: [merged]
 block-support-embedded-device-command-line-partition.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:03 -0700
Message-ID: <5232190b.2THenUfJc1jIs5Ny%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTmE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yongjun_wei@trendmicro.com.cn, mag@sysgo.de, kzak@redhat.com, dwmw2@infradead.org, dedekind@infradead.org, computersforpeace@gmail.com, axboe@kernel.dk, albert.wanglin@huawei.com, caizhiyong@huawei.com

Subject: [merged] block-support-embedded-device-command-line-partition.patch removed from -mm tree
To: caizhiyong@huawei.com,albert.wanglin@huawei.com,axboe@kernel.dk,computersforpeace@gmail.com,dedekind@infradead.org,dwmw2@infradead.org,kzak@redhat.com,mag@sysgo.de,yongjun_wei@trendmicro.com.cn,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:03 -0700


The patch titled
     Subject: block: support embedded device command line partition
has been removed from the -mm tree.  Its filename was
     block-support-embedded-device-command-line-partition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cai Zhiyong <caizhiyong@huawei.com>
Subject: block: support embedded device command line partition

Read block device partition table from command line.  The partition used
for fixed block device (eMMC) embedded device.  It is no MBR, save storage
space.  Bootloader can be easily accessed by absolute address of data on
the block device.  Users can easily change the partition.

This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
About the partition verbose reference
"Documentation/block/cmdline-partition.txt"

[akpm@linux-foundation.org: fix printk text]
[yongjun_wei@trendmicro.com.cn: fix error return code in parse_parts()]
Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: "Wanglin (Albert)" <albert.wanglin@huawei.com>
Cc: Marius Groeger <mag@sysgo.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/cmdline-partition.txt |   40 +++
 block/Kconfig                             |    6 
 block/Makefile                            |    1 
 block/cmdline-parser.c                    |  250 ++++++++++++++++++++
 block/partitions/Kconfig                  |    7 
 block/partitions/Makefile                 |    1 
 block/partitions/check.c                  |    4 
 block/partitions/cmdline.c                |   99 +++++++
 block/partitions/cmdline.h                |    2 
 include/linux/cmdline-parser.h            |   43 +++
 10 files changed, 453 insertions(+)

diff -puN /dev/null Documentation/block/cmdline-partition.txt
--- /dev/null
+++ a/Documentation/block/cmdline-partition.txt
@@ -0,0 +1,40 @@
+Embedded device command line partition
+=====================================================================
+
+Read block device partition table from command line.
+The partition used for fixed block device (eMMC) embedded device.
+It is no MBR, save storage space. Bootloader can be easily accessed
+by absolute address of data on the block device.
+Users can easily change the partition.
+
+The format for the command line is just like mtdparts:
+
+blkdevparts=<blkdev-def>[;<blkdev-def>]
+  <blkdev-def> := <blkdev-id>:<partdef>[,<partdef>]
+    <partdef> := <size>[@<offset>](part-name)
+
+<blkdev-id>
+    block device disk name, embedded device used fixed block device,
+    it's disk name also fixed. such as: mmcblk0, mmcblk1, mmcblk0boot0.
+
+<size>
+    partition size, in bytes, such as: 512, 1m, 1G.
+
+<offset>
+    partition start address, in bytes.
+
+(part-name)
+    partition name, kernel send uevent with "PARTNAME". application can create
+    a link to block device partition with the name "PARTNAME".
+    user space application can access partition by partition name.
+
+Example:
+    eMMC disk name is "mmcblk0" and "mmcblk0boot0"
+
+  bootargs:
+    'blkdevparts=mmcblk0:1G(data0),1G(data1),-;mmcblk0boot0:1m(boot),-(kernel)'
+
+  dmesg:
+    mmcblk0: p1(data0) p2(data1) p3()
+    mmcblk0boot0: p1(boot) p2(kernel)
+
diff -puN block/Kconfig~block-support-embedded-device-command-line-partition block/Kconfig
--- a/block/Kconfig~block-support-embedded-device-command-line-partition
+++ a/block/Kconfig
@@ -99,6 +99,12 @@ config BLK_DEV_THROTTLING
 
 	See Documentation/cgroups/blkio-controller.txt for more information.
 
+config CMDLINE_PARSER
+	bool "Block device command line partition parser"
+	default n
+	---help---
+	Parsing command line, get the partitions information.
+
 menu "Partition Types"
 
 source "block/partitions/Kconfig"
diff -puN block/Makefile~block-support-embedded-device-command-line-partition block/Makefile
--- a/block/Makefile~block-support-embedded-device-command-line-partition
+++ a/block/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
+obj-$(CONFIG_CMDLINE_PARSER)	+= cmdline-parser.o
diff -puN /dev/null block/cmdline-parser.c
--- /dev/null
+++ a/block/cmdline-parser.c
@@ -0,0 +1,250 @@
+/*
+ * Parse command line, get partition information
+ *
+ * Written by Cai Zhiyong <caizhiyong@huawei.com>
+ *
+ */
+#include <linux/buffer_head.h>
+#include <linux/module.h>
+#include <linux/cmdline-parser.h>
+
+static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
+{
+	int ret = 0;
+	struct cmdline_subpart *new_subpart;
+
+	*subpart = NULL;
+
+	new_subpart = kzalloc(sizeof(struct cmdline_subpart), GFP_KERNEL);
+	if (!new_subpart)
+		return -ENOMEM;
+
+	if (*partdef == '-') {
+		new_subpart->size = (sector_t)(~0ULL);
+		partdef++;
+	} else {
+		new_subpart->size = (sector_t)memparse(partdef, &partdef);
+		if (new_subpart->size < (sector_t)PAGE_SIZE) {
+			pr_warn("cmdline partition size is invalid.");
+			ret = -EINVAL;
+			goto fail;
+		}
+	}
+
+	if (*partdef == '@') {
+		partdef++;
+		new_subpart->from = (sector_t)memparse(partdef, &partdef);
+	} else {
+		new_subpart->from = (sector_t)(~0ULL);
+	}
+
+	if (*partdef == '(') {
+		int length;
+		char *next = strchr(++partdef, ')');
+
+		if (!next) {
+			pr_warn("cmdline partition format is invalid.");
+			ret = -EINVAL;
+			goto fail;
+		}
+
+		length = min_t(int, next - partdef,
+			       sizeof(new_subpart->name) - 1);
+		strncpy(new_subpart->name, partdef, length);
+		new_subpart->name[length] = '\0';
+
+		partdef = ++next;
+	} else
+		new_subpart->name[0] = '\0';
+
+	new_subpart->flags = 0;
+
+	if (!strncmp(partdef, "ro", 2)) {
+		new_subpart->flags |= PF_RDONLY;
+		partdef += 2;
+	}
+
+	if (!strncmp(partdef, "lk", 2)) {
+		new_subpart->flags |= PF_POWERUP_LOCK;
+		partdef += 2;
+	}
+
+	*subpart = new_subpart;
+	return 0;
+fail:
+	kfree(new_subpart);
+	return ret;
+}
+
+static void free_subpart(struct cmdline_parts *parts)
+{
+	struct cmdline_subpart *subpart;
+
+	while (parts->subpart) {
+		subpart = parts->subpart;
+		parts->subpart = subpart->next_subpart;
+		kfree(subpart);
+	}
+}
+
+static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
+{
+	int ret = -EINVAL;
+	char *next;
+	int length;
+	struct cmdline_subpart **next_subpart;
+	struct cmdline_parts *newparts;
+	char buf[BDEVNAME_SIZE + 32 + 4];
+
+	*parts = NULL;
+
+	newparts = kzalloc(sizeof(struct cmdline_parts), GFP_KERNEL);
+	if (!newparts)
+		return -ENOMEM;
+
+	next = strchr(bdevdef, ':');
+	if (!next) {
+		pr_warn("cmdline partition has no block device.");
+		goto fail;
+	}
+
+	length = min_t(int, next - bdevdef, sizeof(newparts->name) - 1);
+	strncpy(newparts->name, bdevdef, length);
+	newparts->name[length] = '\0';
+	newparts->nr_subparts = 0;
+
+	next_subpart = &newparts->subpart;
+
+	while (next && *(++next)) {
+		bdevdef = next;
+		next = strchr(bdevdef, ',');
+
+		length = (!next) ? (sizeof(buf) - 1) :
+			min_t(int, next - bdevdef, sizeof(buf) - 1);
+
+		strncpy(buf, bdevdef, length);
+		buf[length] = '\0';
+
+		ret = parse_subpart(next_subpart, buf);
+		if (ret)
+			goto fail;
+
+		newparts->nr_subparts++;
+		next_subpart = &(*next_subpart)->next_subpart;
+	}
+
+	if (!newparts->subpart) {
+		pr_warn("cmdline partition has no valid partition.");
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	*parts = newparts;
+
+	return 0;
+fail:
+	free_subpart(newparts);
+	kfree(newparts);
+	return ret;
+}
+
+void cmdline_parts_free(struct cmdline_parts **parts)
+{
+	struct cmdline_parts *next_parts;
+
+	while (*parts) {
+		next_parts = (*parts)->next_parts;
+		free_subpart(*parts);
+		kfree(*parts);
+		*parts = next_parts;
+	}
+}
+
+int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline)
+{
+	int ret;
+	char *buf;
+	char *pbuf;
+	char *next;
+	struct cmdline_parts **next_parts;
+
+	*parts = NULL;
+
+	next = pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	next_parts = parts;
+
+	while (next && *pbuf) {
+		next = strchr(pbuf, ';');
+		if (next)
+			*next = '\0';
+
+		ret = parse_parts(next_parts, pbuf);
+		if (ret)
+			goto fail;
+
+		if (next)
+			pbuf = ++next;
+
+		next_parts = &(*next_parts)->next_parts;
+	}
+
+	if (!*parts) {
+		pr_warn("cmdline partition has no valid partition.");
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	ret = 0;
+done:
+	kfree(buf);
+	return ret;
+
+fail:
+	cmdline_parts_free(parts);
+	goto done;
+}
+
+struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
+					 const char *bdev)
+{
+	while (parts && strncmp(bdev, parts->name, sizeof(parts->name)))
+		parts = parts->next_parts;
+	return parts;
+}
+
+/*
+ *  add_part()
+ *    0 success.
+ *    1 can not add so many partitions.
+ */
+void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		       int slot,
+		       int (*add_part)(int, struct cmdline_subpart *, void *),
+		       void *param)
+
+{
+	sector_t from = 0;
+	struct cmdline_subpart *subpart;
+
+	for (subpart = parts->subpart; subpart;
+	     subpart = subpart->next_subpart, slot++) {
+		if (subpart->from == (sector_t)(~0ULL))
+			subpart->from = from;
+		else
+			from = subpart->from;
+
+		if (from >= disk_size)
+			break;
+
+		if (subpart->size > (disk_size - from))
+			subpart->size = disk_size - from;
+
+		from += subpart->size;
+
+		if (add_part(slot, subpart, param))
+			break;
+	}
+}
diff -puN block/partitions/Kconfig~block-support-embedded-device-command-line-partition block/partitions/Kconfig
--- a/block/partitions/Kconfig~block-support-embedded-device-command-line-partition
+++ a/block/partitions/Kconfig
@@ -260,3 +260,10 @@ config SYSV68_PARTITION
 	  partition table format used by Motorola Delta machines (using
 	  sysv68).
 	  Otherwise, say N.
+
+config CMDLINE_PARTITION
+	bool "Command line partition support" if PARTITION_ADVANCED
+	select CMDLINE_PARSER
+	help
+	  Say Y here if you would read the partitions table from bootargs.
+	  The format for the command line is just like mtdparts.
diff -puN block/partitions/Makefile~block-support-embedded-device-command-line-partition block/partitions/Makefile
--- a/block/partitions/Makefile~block-support-embedded-device-command-line-partition
+++ a/block/partitions/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_ACORN_PARTITION) += acorn.o
 obj-$(CONFIG_AMIGA_PARTITION) += amiga.o
 obj-$(CONFIG_ATARI_PARTITION) += atari.o
 obj-$(CONFIG_AIX_PARTITION) += aix.o
+obj-$(CONFIG_CMDLINE_PARTITION) += cmdline.o
 obj-$(CONFIG_MAC_PARTITION) += mac.o
 obj-$(CONFIG_LDM_PARTITION) += ldm.o
 obj-$(CONFIG_MSDOS_PARTITION) += msdos.o
diff -puN block/partitions/check.c~block-support-embedded-device-command-line-partition block/partitions/check.c
--- a/block/partitions/check.c~block-support-embedded-device-command-line-partition
+++ a/block/partitions/check.c
@@ -34,6 +34,7 @@
 #include "efi.h"
 #include "karma.h"
 #include "sysv68.h"
+#include "cmdline.h"
 
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
@@ -65,6 +66,9 @@ static int (*check_part[])(struct parsed
 	adfspart_check_ADFS,
 #endif
 
+#ifdef CONFIG_CMDLINE_PARTITION
+	cmdline_partition,
+#endif
 #ifdef CONFIG_EFI_PARTITION
 	efi_partition,		/* this must come before msdos */
 #endif
diff -puN /dev/null block/partitions/cmdline.c
--- /dev/null
+++ a/block/partitions/cmdline.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2013 HUAWEI
+ * Author: Cai Zhiyong <caizhiyong@huawei.com>
+ *
+ * Read block device partition table from command line.
+ * The partition used for fixed block device (eMMC) embedded device.
+ * It is no MBR, save storage space. Bootloader can be easily accessed
+ * by absolute address of data on the block device.
+ * Users can easily change the partition.
+ *
+ * The format for the command line is just like mtdparts.
+ *
+ * Verbose config please reference "Documentation/block/cmdline-partition.txt"
+ *
+ */
+
+#include <linux/cmdline-parser.h>
+
+#include "check.h"
+#include "cmdline.h"
+
+static char *cmdline;
+static struct cmdline_parts *bdev_parts;
+
+static int add_part(int slot, struct cmdline_subpart *subpart, void *param)
+{
+	int label_min;
+	struct partition_meta_info *info;
+	char tmp[sizeof(info->volname) + 4];
+	struct parsed_partitions *state = (struct parsed_partitions *)param;
+
+	if (slot >= state->limit)
+		return 1;
+
+	put_partition(state, slot, subpart->from >> 9,
+		      subpart->size >> 9);
+
+	info = &state->parts[slot].info;
+
+	label_min = min_t(int, sizeof(info->volname) - 1,
+			  sizeof(subpart->name));
+	strncpy(info->volname, subpart->name, label_min);
+	info->volname[label_min] = '\0';
+
+	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
+	strlcat(state->pp_buf, tmp, PAGE_SIZE);
+
+	state->parts[slot].has_info = true;
+
+	return 0;
+}
+
+static int __init cmdline_parts_setup(char *s)
+{
+	cmdline = s;
+	return 1;
+}
+__setup("blkdevparts=", cmdline_parts_setup);
+
+/*
+ * Purpose: allocate cmdline partitions.
+ * Returns:
+ * -1 if unable to read the partition table
+ *  0 if this isn't our partition table
+ *  1 if successful
+ */
+int cmdline_partition(struct parsed_partitions *state)
+{
+	sector_t disk_size;
+	char bdev[BDEVNAME_SIZE];
+	struct cmdline_parts *parts;
+
+	if (cmdline) {
+		if (bdev_parts)
+			cmdline_parts_free(&bdev_parts);
+
+		if (cmdline_parts_parse(&bdev_parts, cmdline)) {
+			cmdline = NULL;
+			return -1;
+		}
+		cmdline = NULL;
+	}
+
+	if (!bdev_parts)
+		return 0;
+
+	bdevname(state->bdev, bdev);
+	parts = cmdline_parts_find(bdev_parts, bdev);
+	if (!parts)
+		return 0;
+
+	disk_size = get_capacity(state->bdev->bd_disk) << 9;
+
+	cmdline_parts_set(parts, disk_size, 1, add_part, (void *)state);
+
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
+
+	return 1;
+}
diff -puN /dev/null block/partitions/cmdline.h
--- /dev/null
+++ a/block/partitions/cmdline.h
@@ -0,0 +1,2 @@
+
+int cmdline_partition(struct parsed_partitions *state);
diff -puN /dev/null include/linux/cmdline-parser.h
--- /dev/null
+++ a/include/linux/cmdline-parser.h
@@ -0,0 +1,43 @@
+/*
+ * Parsing command line, get the partitions information.
+ *
+ * Written by Cai Zhiyong <caizhiyong@huawei.com>
+ *
+ */
+#ifndef CMDLINEPARSEH
+#define CMDLINEPARSEH
+
+#include <linux/blkdev.h>
+
+/* partition flags */
+#define PF_RDONLY                   0x01 /* Device is read only */
+#define PF_POWERUP_LOCK             0x02 /* Always locked after reset */
+
+struct cmdline_subpart {
+	char name[BDEVNAME_SIZE]; /* partition name, such as 'rootfs' */
+	sector_t from;
+	sector_t size;
+	int flags;
+	struct cmdline_subpart *next_subpart;
+};
+
+struct cmdline_parts {
+	char name[BDEVNAME_SIZE]; /* block device, such as 'mmcblk0' */
+	unsigned int nr_subparts;
+	struct cmdline_subpart *subpart;
+	struct cmdline_parts *next_parts;
+};
+
+void cmdline_parts_free(struct cmdline_parts **parts);
+
+int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline);
+
+struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
+					 const char *bdev);
+
+void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		       int slot,
+		       int (*add_part)(int, struct cmdline_subpart *, void *),
+		       void *param);
+
+#endif /* CMDLINEPARSEH */
_

Patches currently in -mm which might be from caizhiyong@huawei.com are

origin.patch

