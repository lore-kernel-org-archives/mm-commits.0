From: akpm@linux-foundation.org
Subject: + block-support-embedded-device-command-line-partition.patch
 added to -mm tree
Date: Mon, 05 Aug 2013 15:22:15 -0700
Message-ID: <52002597.toQ6EFo/IK0Diaac%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab3HEWWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 18:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mag@sysgo.de, kzak@redhat.com, dwmw2@infradead.org, axboe@kernel.dk, albert.wanglin@huawei.com, caizhiyong@huawei.com

Subject: + block-support-embedded-device-command-line-partition.patch added to -mm tree
To: caizhiyong@huawei.com,albert.wanglin@huawei.com,axboe@kernel.dk,dwmw2@infradead.org,kzak@redhat.com,mag@sysgo.de
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 15:22:15 -0700


The patch titled
     Subject: block: support embedded device command line partition
has been added to the -mm tree.  Its filename is
     block-support-embedded-device-command-line-partition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-support-embedded-device-command-line-partition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-support-embedded-device-command-line-partition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
Cc: Karel Zak <kzak@redhat.com>
Cc: "Wanglin (Albert)" <albert.wanglin@huawei.com>
Cc: Marius Groeger <mag@sysgo.de>");
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/cmdline-partition.txt |   40 ++
 block/partitions/Kconfig                  |    6 
 block/partitions/Makefile                 |    1 
 block/partitions/check.c                  |    4 
 block/partitions/cmdline.c                |  326 ++++++++++++++++++++
 block/partitions/cmdline.h                |    2 
 6 files changed, 379 insertions(+)

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
diff -puN block/partitions/Kconfig~block-support-embedded-device-command-line-partition block/partitions/Kconfig
--- a/block/partitions/Kconfig~block-support-embedded-device-command-line-partition
+++ a/block/partitions/Kconfig
@@ -260,3 +260,9 @@ config SYSV68_PARTITION
 	  partition table format used by Motorola Delta machines (using
 	  sysv68).
 	  Otherwise, say N.
+
+config CMDLINE_PARTITION
+	bool "Command line partition support" if PARTITION_ADVANCED
+	help
+	  Say Y here if you would read the partitions table from bootargs.
+	  The format for the command line is just like mtdparts.
diff -puN block/partitions/Makefile~block-support-embedded-device-command-line-partition block/partitions/Makefile
--- a/block/partitions/Makefile~block-support-embedded-device-command-line-partition
+++ a/block/partitions/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_EFI_PARTITION) += efi.o
 obj-$(CONFIG_KARMA_PARTITION) += karma.o
 obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
+obj-$(CONFIG_CMDLINE_PARTITION) += cmdline.o
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
@@ -0,0 +1,326 @@
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
+ * This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
+ * The format for the command line is just like mtdparts.
+ *
+ * Verbose config please reference "Documentation/block/cmdline-partition.txt"
+ *
+ */
+
+#include <linux/buffer_head.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+
+#include "check.h"
+#include "cmdline.h"
+
+struct cmdline_subpart {
+	char name[BDEVNAME_SIZE]; /* partition name, such as 'rootfs' */
+	sector_t from;
+	sector_t size;
+	struct cmdline_subpart *next_subpart;
+};
+
+struct cmdline_parts {
+	char name[BDEVNAME_SIZE]; /* block device, such as 'mmcblk0' */
+	struct cmdline_subpart *subpart;
+	struct cmdline_parts *next_parts;
+};
+
+static char *cmdline_string;
+static struct cmdline_parts *cmdline_parts;
+
+static int parse_subpart(struct cmdline_subpart **subpart, char *cmdline)
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
+	if (*cmdline == '-') {
+		new_subpart->size = (sector_t)(~0ULL);
+		cmdline++;
+	} else {
+		new_subpart->size = (sector_t)memparse(cmdline, &cmdline);
+		if (new_subpart->size < (sector_t)PAGE_SIZE) {
+			pr_warn("cmdline partition size is invalid.");
+			ret = -EINVAL;
+			goto fail;
+		}
+	}
+
+	if (*cmdline == '@') {
+		cmdline++;
+		new_subpart->from = (sector_t)memparse(cmdline, &cmdline);
+	} else {
+		new_subpart->from = (sector_t)(~0ULL);
+	}
+
+	if (*cmdline == '(') {
+		int length;
+		char *next = strchr(++cmdline, ')');
+
+		if (!next) {
+			pr_warn("cmdline partition format is invalid.");
+			ret = -EINVAL;
+			goto fail;
+		}
+
+		length = min_t(int, next - cmdline,
+			       sizeof(new_subpart->name) - 1);
+		strncpy(new_subpart->name, cmdline, length);
+		new_subpart->name[length] = '\0';
+
+		cmdline = ++next;
+	} else
+		new_subpart->name[0] = '\0';
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
+static void free_parts(struct cmdline_parts **parts)
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
+static int parse_parts(struct cmdline_parts **parts, const char *cmdline)
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
+	next = strchr(cmdline, ':');
+	if (!next) {
+		pr_warn("cmdline partition has not block device.");
+		goto fail;
+	}
+
+	length = min_t(int, next - cmdline, sizeof(newparts->name) - 1);
+	strncpy(newparts->name, cmdline, length);
+	newparts->name[length] = '\0';
+
+	next_subpart = &newparts->subpart;
+
+	while (next && *(++next)) {
+		cmdline = next;
+		next = strchr(cmdline, ',');
+
+		length = (!next) ? (sizeof(buf) - 1) :
+			min_t(int, next - cmdline, sizeof(buf) - 1);
+
+		strncpy(buf, cmdline, length);
+		buf[length] = '\0';
+
+		ret = parse_subpart(next_subpart, buf);
+		if (ret)
+			goto fail;
+
+		next_subpart = &(*next_subpart)->next_subpart;
+	}
+
+	if (!newparts->subpart) {
+		pr_warn("cmdline partition has not valid partition.");
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
+static int parse_cmdline(struct cmdline_parts **parts, const char *cmdline)
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
+		pr_warn("cmdline partition has not valid partition.");
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
+	free_parts(parts);
+	goto done;
+}
+
+/*
+ * Purpose: allocate cmdline partitions.
+ * Returns:
+ * -1 if unable to read the partition table
+ *  0 if this isn't our partition table
+ *  1 if successful
+ */
+static int parse_partitions(struct parsed_partitions *state,
+			    struct cmdline_parts *parts)
+{
+	int slot;
+	sector_t from = 0;
+	sector_t disk_size;
+	char buf[BDEVNAME_SIZE];
+	struct cmdline_subpart *subpart;
+
+	bdevname(state->bdev, buf);
+
+	while (parts && strncmp(buf, parts->name, BDEVNAME_SIZE))
+		parts = parts->next_parts;
+
+	if (!parts)
+		return 0;
+
+	disk_size = get_capacity(state->bdev->bd_disk) << 9;
+
+	for (slot = 1, subpart = parts->subpart;
+	     subpart && slot < state->limit;
+	     subpart = subpart->next_subpart, slot++) {
+		int label_min;
+		struct partition_meta_info *info;
+		char tmp[sizeof(info->volname) + 4];
+
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
+		put_partition(state, slot, subpart->from >> 9,
+			      subpart->size >> 9);
+
+		info = &state->parts[slot].info;
+
+		label_min = min_t(int, sizeof(info->volname) - 1,
+				  sizeof(subpart->name));
+		strncpy(info->volname, subpart->name, label_min);
+		info->volname[label_min] = '\0';
+
+		snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
+		strlcat(state->pp_buf, tmp, PAGE_SIZE);
+
+		state->parts[slot].has_info = true;
+	}
+
+	strlcat(state->pp_buf, "\n", PAGE_SIZE);
+
+	return 1;
+}
+
+static int __init cmdline_parts_setup(char *s)
+{
+	cmdline_string = s;
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
+	if (cmdline_string) {
+		if (cmdline_parts)
+			free_parts(&cmdline_parts);
+
+		if (parse_cmdline(&cmdline_parts, cmdline_string))
+			goto fail;
+
+		cmdline_string = NULL;
+	}
+
+	if (!cmdline_parts)
+		return 0;
+
+	return parse_partitions(state, cmdline_parts);
+
+fail:
+	cmdline_string = NULL;
+	return -1;
+}
diff -puN /dev/null block/partitions/cmdline.h
--- /dev/null
+++ a/block/partitions/cmdline.h
@@ -0,0 +1,2 @@
+
+int cmdline_partition(struct parsed_partitions *state);
_

Patches currently in -mm which might be from caizhiyong@huawei.com are

block-support-embedded-device-command-line-partition.patch
block-support-embedded-device-command-line-partition-fix.patch
linux-next.patch

