From: akpm@linux-foundation.org
Subject: +
 block-support-embedded-device-command-line-partition-fix-fix-2.patch added
 to -mm tree
Date: Wed, 14 Aug 2013 15:54:24 -0700
Message-ID: <520c0aa0.2D3njN4oipq8EwVF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab3HNWyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Aug 2013 18:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mag@sysgo.de, kzak@redhat.com, dwmw2@infradead.org, axboe@kernel.dk, albert.wanglin@huawei.com, caizhiyong@huawei.com

Subject: + block-support-embedded-device-command-line-partition-fix-fix-2.patch added to -mm tree
To: caizhiyong@huawei.com,albert.wanglin@huawei.com,axboe@kernel.dk,dwmw2@infradead.org,kzak@redhat.com,mag@sysgo.de
From: akpm@linux-foundation.org
Date: Wed, 14 Aug 2013 15:54:24 -0700


The patch titled
     Subject: block: add command line partition parser
has been added to the -mm tree.  Its filename is
     block-support-embedded-device-command-line-partition-fix-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-support-embedded-device-command-line-partition-fix-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-support-embedded-device-command-line-partition-fix-fix-2.patch

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
Subject: block: add command line partition parser

move the command line parser to a separate module, and change it into
library-style code.

reference: https://lkml.org/lkml/2013/8/6/550

Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
Cc: "Wanglin (Albert)" <albert.wanglin@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Karel Zak <kzak@redhat.com>
Cc: Marius Groeger <mag@sysgo.de>");
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig                  |    6 
 block/Makefile                 |    1 
 block/cmdline-parser.c         |  249 ++++++++++++++++++++++++
 block/partitions/Kconfig       |    1 
 block/partitions/cmdline.c     |  311 ++++---------------------------
 include/linux/cmdline-parser.h |   43 ++++
 6 files changed, 342 insertions(+), 269 deletions(-)

diff -puN block/Kconfig~block-support-embedded-device-command-line-partition-fix-fix-2 block/Kconfig
--- a/block/Kconfig~block-support-embedded-device-command-line-partition-fix-fix-2
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
diff -puN block/Makefile~block-support-embedded-device-command-line-partition-fix-fix-2 block/Makefile
--- a/block/Makefile~block-support-embedded-device-command-line-partition-fix-fix-2
+++ a/block/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
+obj-$(CONFIG_CMDLINE_PARSER)	+= cmdline-parser.o
diff -puN /dev/null block/cmdline-parser.c
--- /dev/null
+++ a/block/cmdline-parser.c
@@ -0,0 +1,249 @@
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
diff -puN block/partitions/Kconfig~block-support-embedded-device-command-line-partition-fix-fix-2 block/partitions/Kconfig
--- a/block/partitions/Kconfig~block-support-embedded-device-command-line-partition-fix-fix-2
+++ a/block/partitions/Kconfig
@@ -263,6 +263,7 @@ config SYSV68_PARTITION
 
 config CMDLINE_PARTITION
 	bool "Command line partition support" if PARTITION_ADVANCED
+	select CMDLINE_PARSER
 	help
 	  Say Y here if you would read the partitions table from bootargs.
 	  The format for the command line is just like mtdparts.
diff -puN block/partitions/cmdline.c~block-support-embedded-device-command-line-partition-fix-fix-2 block/partitions/cmdline.c
--- a/block/partitions/cmdline.c~block-support-embedded-device-command-line-partition-fix-fix-2
+++ a/block/partitions/cmdline.c
@@ -8,219 +8,54 @@
  * by absolute address of data on the block device.
  * Users can easily change the partition.
  *
- * This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
  * The format for the command line is just like mtdparts.
  *
  * Verbose config please reference "Documentation/block/cmdline-partition.txt"
  *
  */
 
-#include <linux/buffer_head.h>
-#include <linux/module.h>
-#include <linux/ctype.h>
+#include <linux/cmdline-parser.h>
 
 #include "check.h"
 #include "cmdline.h"
 
-struct cmdline_subpart {
-	char name[BDEVNAME_SIZE]; /* partition name, such as 'rootfs' */
-	sector_t from;
-	sector_t size;
-	struct cmdline_subpart *next_subpart;
-};
-
-struct cmdline_parts {
-	char name[BDEVNAME_SIZE]; /* block device, such as 'mmcblk0' */
-	struct cmdline_subpart *subpart;
-	struct cmdline_parts *next_parts;
-};
+static char *cmdline;
+static struct cmdline_parts *bdev_parts;
 
-static char *cmdline_string;
-static struct cmdline_parts *cmdline_parts;
-
-static int parse_subpart(struct cmdline_subpart **subpart, char *cmdline)
-{
-	int ret = 0;
-	struct cmdline_subpart *new_subpart;
-
-	*subpart = NULL;
-
-	new_subpart = kzalloc(sizeof(struct cmdline_subpart), GFP_KERNEL);
-	if (!new_subpart)
-		return -ENOMEM;
-
-	if (*cmdline == '-') {
-		new_subpart->size = (sector_t)(~0ULL);
-		cmdline++;
-	} else {
-		new_subpart->size = (sector_t)memparse(cmdline, &cmdline);
-		if (new_subpart->size < (sector_t)PAGE_SIZE) {
-			pr_warn("cmdline partition size is invalid.");
-			ret = -EINVAL;
-			goto fail;
-		}
-	}
-
-	if (*cmdline == '@') {
-		cmdline++;
-		new_subpart->from = (sector_t)memparse(cmdline, &cmdline);
-	} else {
-		new_subpart->from = (sector_t)(~0ULL);
-	}
-
-	if (*cmdline == '(') {
-		int length;
-		char *next = strchr(++cmdline, ')');
-
-		if (!next) {
-			pr_warn("cmdline partition format is invalid.");
-			ret = -EINVAL;
-			goto fail;
-		}
-
-		length = min_t(int, next - cmdline,
-			       sizeof(new_subpart->name) - 1);
-		strncpy(new_subpart->name, cmdline, length);
-		new_subpart->name[length] = '\0';
-
-		cmdline = ++next;
-	} else
-		new_subpart->name[0] = '\0';
-
-	*subpart = new_subpart;
-	return 0;
-fail:
-	kfree(new_subpart);
-	return ret;
-}
-
-static void free_subpart(struct cmdline_parts *parts)
-{
-	struct cmdline_subpart *subpart;
-
-	while (parts->subpart) {
-		subpart = parts->subpart;
-		parts->subpart = subpart->next_subpart;
-		kfree(subpart);
-	}
-}
-
-static void free_parts(struct cmdline_parts **parts)
-{
-	struct cmdline_parts *next_parts;
-
-	while (*parts) {
-		next_parts = (*parts)->next_parts;
-		free_subpart(*parts);
-		kfree(*parts);
-		*parts = next_parts;
-	}
-}
-
-static int parse_parts(struct cmdline_parts **parts, const char *cmdline)
+static int add_part(int slot, struct cmdline_subpart *subpart, void *param)
 {
-	int ret = -EINVAL;
-	char *next;
-	int length;
-	struct cmdline_subpart **next_subpart;
-	struct cmdline_parts *newparts;
-	char buf[BDEVNAME_SIZE + 32 + 4];
-
-	*parts = NULL;
-
-	newparts = kzalloc(sizeof(struct cmdline_parts), GFP_KERNEL);
-	if (!newparts)
-		return -ENOMEM;
-
-	next = strchr(cmdline, ':');
-	if (!next) {
-		pr_warn("cmdline partition has no block device.");
-		goto fail;
-	}
+	int label_min;
+	struct partition_meta_info *info;
+	char tmp[sizeof(info->volname) + 4];
+	struct parsed_partitions *state = (struct parsed_partitions *)param;
 
-	length = min_t(int, next - cmdline, sizeof(newparts->name) - 1);
-	strncpy(newparts->name, cmdline, length);
-	newparts->name[length] = '\0';
+	if (slot >= state->limit)
+		return 1;
 
-	next_subpart = &newparts->subpart;
+	put_partition(state, slot, subpart->from >> 9,
+		      subpart->size >> 9);
 
-	while (next && *(++next)) {
-		cmdline = next;
-		next = strchr(cmdline, ',');
+	info = &state->parts[slot].info;
 
-		length = (!next) ? (sizeof(buf) - 1) :
-			min_t(int, next - cmdline, sizeof(buf) - 1);
+	label_min = min_t(int, sizeof(info->volname) - 1,
+			  sizeof(subpart->name));
+	strncpy(info->volname, subpart->name, label_min);
+	info->volname[label_min] = '\0';
 
-		strncpy(buf, cmdline, length);
-		buf[length] = '\0';
+	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
+	strlcat(state->pp_buf, tmp, PAGE_SIZE);
 
-		ret = parse_subpart(next_subpart, buf);
-		if (ret)
-			goto fail;
-
-		next_subpart = &(*next_subpart)->next_subpart;
-	}
-
-	if (!newparts->subpart) {
-		pr_warn("cmdline partition has no valid partition.");
-		goto fail;
-	}
-
-	*parts = newparts;
+	state->parts[slot].has_info = true;
 
 	return 0;
-fail:
-	free_subpart(newparts);
-	kfree(newparts);
-	return ret;
 }
 
-static int parse_cmdline(struct cmdline_parts **parts, const char *cmdline)
+static int __init cmdline_parts_setup(char *s)
 {
-	int ret;
-	char *buf;
-	char *pbuf;
-	char *next;
-	struct cmdline_parts **next_parts;
-
-	*parts = NULL;
-
-	next = pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	next_parts = parts;
-
-	while (next && *pbuf) {
-		next = strchr(pbuf, ';');
-		if (next)
-			*next = '\0';
-
-		ret = parse_parts(next_parts, pbuf);
-		if (ret)
-			goto fail;
-
-		if (next)
-			pbuf = ++next;
-
-		next_parts = &(*next_parts)->next_parts;
-	}
-
-	if (!*parts) {
-		pr_warn("cmdline partition has no valid partition.");
-		ret = -EINVAL;
-		goto fail;
-	}
-
-	ret = 0;
-done:
-	kfree(buf);
-	return ret;
-
-fail:
-	free_parts(parts);
-	goto done;
+	cmdline = s;
+	return 1;
 }
+__setup("blkdevparts=", cmdline_parts_setup);
 
 /*
  * Purpose: allocate cmdline partitions.
@@ -229,98 +64,36 @@ fail:
  *  0 if this isn't our partition table
  *  1 if successful
  */
-static int parse_partitions(struct parsed_partitions *state,
-			    struct cmdline_parts *parts)
+int cmdline_partition(struct parsed_partitions *state)
 {
-	int slot;
-	sector_t from = 0;
 	sector_t disk_size;
-	char buf[BDEVNAME_SIZE];
-	struct cmdline_subpart *subpart;
+	char bdev[BDEVNAME_SIZE];
+	struct cmdline_parts *parts;
 
-	bdevname(state->bdev, buf);
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
 
-	while (parts && strncmp(buf, parts->name, BDEVNAME_SIZE))
-		parts = parts->next_parts;
+	if (!bdev_parts)
+		return 0;
 
+	bdevname(state->bdev, bdev);
+	parts = cmdline_parts_find(bdev_parts, bdev);
 	if (!parts)
 		return 0;
 
 	disk_size = get_capacity(state->bdev->bd_disk) << 9;
 
-	for (slot = 1, subpart = parts->subpart;
-	     subpart && slot < state->limit;
-	     subpart = subpart->next_subpart, slot++) {
-		int label_min;
-		struct partition_meta_info *info;
-		char tmp[sizeof(info->volname) + 4];
-
-		if (subpart->from == (sector_t)(~0ULL))
-			subpart->from = from;
-		else
-			from = subpart->from;
-
-		if (from >= disk_size)
-			break;
-
-		if (subpart->size > (disk_size - from))
-			subpart->size = disk_size - from;
-
-		from += subpart->size;
-
-		put_partition(state, slot, subpart->from >> 9,
-			      subpart->size >> 9);
-
-		info = &state->parts[slot].info;
-
-		label_min = min_t(int, sizeof(info->volname) - 1,
-				  sizeof(subpart->name));
-		strncpy(info->volname, subpart->name, label_min);
-		info->volname[label_min] = '\0';
-
-		snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
-		strlcat(state->pp_buf, tmp, PAGE_SIZE);
-
-		state->parts[slot].has_info = true;
-	}
+	cmdline_parts_set(parts, disk_size, 1, add_part, (void *)state);
 
 	strlcat(state->pp_buf, "\n", PAGE_SIZE);
 
 	return 1;
 }
-
-static int __init cmdline_parts_setup(char *s)
-{
-	cmdline_string = s;
-	return 1;
-}
-__setup("blkdevparts=", cmdline_parts_setup);
-
-/*
- * Purpose: allocate cmdline partitions.
- * Returns:
- * -1 if unable to read the partition table
- *  0 if this isn't our partition table
- *  1 if successful
- */
-int cmdline_partition(struct parsed_partitions *state)
-{
-	if (cmdline_string) {
-		if (cmdline_parts)
-			free_parts(&cmdline_parts);
-
-		if (parse_cmdline(&cmdline_parts, cmdline_string))
-			goto fail;
-
-		cmdline_string = NULL;
-	}
-
-	if (!cmdline_parts)
-		return 0;
-
-	return parse_partitions(state, cmdline_parts);
-
-fail:
-	cmdline_string = NULL;
-	return -1;
-}
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

block-support-embedded-device-command-line-partition.patch
block-support-embedded-device-command-line-partition-fix.patch
block-support-embedded-device-command-line-partition-fix-fix-2.patch
linux-next.patch

