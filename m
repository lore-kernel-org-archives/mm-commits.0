From: akpm@linux-foundation.org
Subject: [merged] nilfs2-add-sys-fs-nilfs2-features-group.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:39:04 -0700
Message-ID: <53ea6d58.C2rmcO+RTMBWZ76/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:35187 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbaHLTjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:05 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so2668804pdj.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add /sys/fs/nilfs2/features group
has been removed from the -mm tree.  Its filename was
     nilfs2-add-sys-fs-nilfs2-features-group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Subject: nilfs2: add /sys/fs/nilfs2/features group

This patchset implements creation of sysfs groups and attributes with the
purpose to show NILFS2 volume details, internal state of the driver and to
manage internal state of NILFS2 driver.

Sysfs is a virtual file system that exports information about devices and
drivers from the kernel device model to user space, and is also used for
configuration.  NILFS2 is a complex file system that has segctor thread,
GC thread, checkpoint/snapshot model and so on.  Sysfs namespace provides
native and easy way for: (1) getting info and statistics about volume
state; (2) getting info and configuration of internal subsystems (segctor
thread); (3) snapshots management.

Suggested patchset provides basis for managing segctor thread behaviour
and manipulation by snapshots.  Currently, it informs only about segctor
thread's internal parameters and about mounted snapshots.  But sysfs
interface can provide easy and simple way for deep management of segctor
thread and snapshots.

This patchset provides opportunity to manage interval of periodical update
of superblock (in seconds).  Default value is 10 seconds.  Now a user can
increase this value by means of
nilfs2/<device>/superblock/sb_update_frequency attribute in the case of
necessity.

Also the patchset provides opportunity to get information easily about key
volumes's parameters (free blocks, superblock write count, superblock
update frequency, latest segment info, dirty data blocks count, count of
clean segments, count of dirty segments and so on) in real time manner. 
Such information can be used in scripts for subtle management of
filesystem.

Implemented functionality creates such groups:
(1) /sys/fs/nilfs2 - root group
(2) /sys/fs/nilfs2/features - group contains attributes that describe NILFS
file system driver features
(3) /sys/fs/nilfs2/<device> - group contains attributes that describe file
system partition's details
(4) /sys/fs/nilfs2/<device>/superblock - group contains attributes that describe
superblock's details
(5) /sys/fs/nilfs2/<device>/segctor - group contains attributes that describe
segctor thread activity details
(6) /sys/fs/nilfs2/<device>/segments - group contains attributes that describe
details about volume's segments
(7) /sys/fs/nilfs2/<device>/checkpoints - group contains attributes that describe
details about volume's checkpoints
(8) /sys/fs/nilfs2/<device>/mounted_snapshots - group contains group for every
mounted snapshot
(9) /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot> - group contains
details about mounted snapshot



This patch (of 9):

This patch adds code of creation /sys/fs/nilfs2 group and
/sys/fs/nilfs2/features group.

The features group contains attributes that describe NILFS
file system driver features:
(1) revision - show current revision of NILFS file system driver.

There are two formats of timestamp output - seconds and human-readable
format.  Every showed timestamp has two sysfs files (time-<xxx> and
time-<xxx>-secs).  One sysfs file (time-<xxx>) shows time in
human-readable format.  Another sysfs file (time-<xxx>-secs) shows time in
seconds.

It was reported by Michael Semon that timestamp output in human-readable
format should be changed from "2014-4-12 14:5:38" to "2014-04-12
14:05:38".  Second version of the patch fixes this issue.

Reported-by: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-fs-nilfs2 |   14 ++
 fs/nilfs2/sysfs.c                         |  113 ++++++++++++++++++++
 fs/nilfs2/sysfs.h                         |   61 ++++++++++
 3 files changed, 188 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-fs-nilfs2
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -0,0 +1,14 @@
+
+What:		/sys/fs/nilfs2/features/revision
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show current revision of NILFS file system driver.
+		This value informs about file system revision that
+		driver is ready to support.
+
+What:		/sys/fs/nilfs2/features/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Describe attributes of /sys/fs/nilfs2/features group.
diff -puN /dev/null fs/nilfs2/sysfs.c
--- /dev/null
+++ a/fs/nilfs2/sysfs.c
@@ -0,0 +1,113 @@
+/*
+ * sysfs.c - sysfs support implementation.
+ *
+ * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Written by Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
+ */
+
+#include <linux/kobject.h>
+
+#include "nilfs.h"
+#include "mdt.h"
+#include "sufile.h"
+#include "cpfile.h"
+#include "sysfs.h"
+
+/* /sys/fs/<nilfs>/ */
+static struct kset *nilfs_kset;
+
+#define NILFS_SHOW_TIME(time_t_val, buf) ({ \
+		struct tm res; \
+		int count = 0; \
+		time_to_tm(time_t_val, 0, &res); \
+		res.tm_year += 1900; \
+		res.tm_mon += 1; \
+		count = scnprintf(buf, PAGE_SIZE, \
+				    "%ld-%.2d-%.2d %.2d:%.2d:%.2d\n", \
+				    res.tm_year, res.tm_mon, res.tm_mday, \
+				    res.tm_hour, res.tm_min, res.tm_sec);\
+		count; \
+})
+
+/************************************************************************
+ *                        NILFS feature attrs                           *
+ ************************************************************************/
+
+static ssize_t nilfs_feature_revision_show(struct kobject *kobj,
+					    struct attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d.%d\n",
+			NILFS_CURRENT_REV, NILFS_MINOR_REV);
+}
+
+static const char features_readme_str[] =
+	"The features group contains attributes that describe NILFS file\n"
+	"system driver features.\n\n"
+	"(1) revision\n\tshow current revision of NILFS file system driver.\n";
+
+static ssize_t nilfs_feature_README_show(struct kobject *kobj,
+					 struct attribute *attr,
+					 char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, features_readme_str);
+}
+
+NILFS_FEATURE_RO_ATTR(revision);
+NILFS_FEATURE_RO_ATTR(README);
+
+static struct attribute *nilfs_feature_attrs[] = {
+	NILFS_FEATURE_ATTR_LIST(revision),
+	NILFS_FEATURE_ATTR_LIST(README),
+	NULL,
+};
+
+static const struct attribute_group nilfs_feature_attr_group = {
+	.name = "features",
+	.attrs = nilfs_feature_attrs,
+};
+
+int __init nilfs_sysfs_init(void)
+{
+	int err;
+
+	nilfs_kset = kset_create_and_add(NILFS_ROOT_GROUP_NAME, NULL, fs_kobj);
+	if (!nilfs_kset) {
+		err = -ENOMEM;
+		printk(KERN_ERR "NILFS: unable to create sysfs entry: err %d\n",
+			err);
+		goto failed_sysfs_init;
+	}
+
+	err = sysfs_create_group(&nilfs_kset->kobj, &nilfs_feature_attr_group);
+	if (unlikely(err)) {
+		printk(KERN_ERR "NILFS: unable to create feature group: err %d\n",
+			err);
+		goto cleanup_sysfs_init;
+	}
+
+	return 0;
+
+cleanup_sysfs_init:
+	kset_unregister(nilfs_kset);
+
+failed_sysfs_init:
+	return err;
+}
+
+void nilfs_sysfs_exit(void)
+{
+	sysfs_remove_group(&nilfs_kset->kobj, &nilfs_feature_attr_group);
+	kset_unregister(nilfs_kset);
+}
diff -puN /dev/null fs/nilfs2/sysfs.h
--- /dev/null
+++ a/fs/nilfs2/sysfs.h
@@ -0,0 +1,61 @@
+/*
+ * sysfs.h - sysfs support declarations.
+ *
+ * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
+ * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Written by Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
+ */
+
+#ifndef _NILFS_SYSFS_H
+#define _NILFS_SYSFS_H
+
+#include <linux/sysfs.h>
+
+#define NILFS_ROOT_GROUP_NAME	"nilfs2"
+
+#define NILFS_COMMON_ATTR_STRUCT(name) \
+struct nilfs_##name##_attr { \
+	struct attribute attr; \
+	ssize_t (*show)(struct kobject *, struct attribute *, \
+			char *); \
+	ssize_t (*store)(struct kobject *, struct attribute *, \
+			 const char *, size_t); \
+};
+
+NILFS_COMMON_ATTR_STRUCT(feature);
+
+#define NILFS_ATTR(type, name, mode, show, store) \
+	static struct nilfs_##type##_attr nilfs_##type##_attr_##name = \
+		__ATTR(name, mode, show, store)
+
+#define NILFS_INFO_ATTR(type, name) \
+	NILFS_ATTR(type, name, 0444, NULL, NULL)
+#define NILFS_RO_ATTR(type, name) \
+	NILFS_ATTR(type, name, 0444, nilfs_##type##_##name##_show, NULL)
+#define NILFS_RW_ATTR(type, name) \
+	NILFS_ATTR(type, name, 0644, \
+		    nilfs_##type##_##name##_show, \
+		    nilfs_##type##_##name##_store)
+
+#define NILFS_FEATURE_INFO_ATTR(name) \
+	NILFS_INFO_ATTR(feature, name)
+#define NILFS_FEATURE_RO_ATTR(name) \
+	NILFS_RO_ATTR(feature, name)
+#define NILFS_FEATURE_RW_ATTR(name) \
+	NILFS_RW_ATTR(feature, name)
+
+#define NILFS_FEATURE_ATTR_LIST(name) \
+	(&nilfs_feature_attr_##name.attr)
+
+#endif /* _NILFS_SYSFS_H */
_

Patches currently in -mm which might be from Vyacheslav.Dubeyko@hgst.com are

origin.patch

