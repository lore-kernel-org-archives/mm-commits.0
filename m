From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:39:16 -0700
Message-ID: <53ea6d64.vDHpt03YZJu6FHtJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:59665 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbaHLTjR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:17 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1919608oah.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots group
has been removed from the -mm tree.  Its filename was
     nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Subject: nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots group

This patch adds creation of /sys/fs/nilfs2/<device>/mounted_snapshots
group.

The mounted_snapshots group contains group for every
mounted snapshot.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-fs-nilfs2 |    7 +++
 fs/nilfs2/sysfs.c                         |   36 +++++++++++++++++++-
 fs/nilfs2/sysfs.h                         |   12 ++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group Documentation/ABI/testing/sysfs-fs-nilfs2
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group
+++ a/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -241,3 +241,10 @@ Contact:	"Vyacheslav Dubeyko" <slava@dub
 Description:
 		Describe attributes of /sys/fs/nilfs2/<device>/checkpoints
 		group.
+
+What:		/sys/fs/nilfs2/<device>/mounted_snapshots/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Describe content of /sys/fs/nilfs2/<device>/mounted_snapshots
+		group.
diff -puN fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group
+++ a/fs/nilfs2/sysfs.c
@@ -112,6 +112,32 @@ void nilfs_sysfs_delete_##name##_group(s
 }
 
 /************************************************************************
+ *                    NILFS mounted snapshots attrs                     *
+ ************************************************************************/
+
+static const char mounted_snapshots_readme_str[] =
+	"The mounted_snapshots group contains group for\n"
+	"every mounted snapshot.\n";
+
+static ssize_t
+nilfs_mounted_snapshots_README_show(struct nilfs_mounted_snapshots_attr *attr,
+				    struct the_nilfs *nilfs, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, mounted_snapshots_readme_str);
+}
+
+NILFS_MOUNTED_SNAPSHOTS_RO_ATTR(README);
+
+static struct attribute *nilfs_mounted_snapshots_attrs[] = {
+	NILFS_MOUNTED_SNAPSHOTS_ATTR_LIST(README),
+	NULL,
+};
+
+NILFS_DEV_INT_GROUP_OPS(mounted_snapshots, dev);
+NILFS_DEV_INT_GROUP_TYPE(mounted_snapshots, dev);
+NILFS_DEV_INT_GROUP_FNS(mounted_snapshots, dev);
+
+/************************************************************************
  *                      NILFS checkpoints attrs                         *
  ************************************************************************/
 
@@ -866,10 +892,14 @@ int nilfs_sysfs_create_device_group(stru
 	if (err)
 		goto free_dev_subgroups;
 
-	err = nilfs_sysfs_create_checkpoints_group(nilfs);
+	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
 	if (err)
 		goto cleanup_dev_kobject;
 
+	err = nilfs_sysfs_create_checkpoints_group(nilfs);
+	if (err)
+		goto delete_mounted_snapshots_group;
+
 	err = nilfs_sysfs_create_segments_group(nilfs);
 	if (err)
 		goto delete_checkpoints_group;
@@ -893,6 +923,9 @@ delete_segments_group:
 delete_checkpoints_group:
 	nilfs_sysfs_delete_checkpoints_group(nilfs);
 
+delete_mounted_snapshots_group:
+	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
+
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
 
@@ -905,6 +938,7 @@ failed_create_device_group:
 
 void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 {
+	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
 	nilfs_sysfs_delete_checkpoints_group(nilfs);
 	nilfs_sysfs_delete_segments_group(nilfs);
 	nilfs_sysfs_delete_superblock_group(nilfs);
diff -puN fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group
+++ a/fs/nilfs2/sysfs.h
@@ -30,6 +30,8 @@
  * @sg_superblock_kobj_unregister: completion state
  * @sg_segctor_kobj: /sys/fs/<nilfs>/<device>/segctor
  * @sg_segctor_kobj_unregister: completion state
+ * @sg_mounted_snapshots_kobj: /sys/fs/<nilfs>/<device>/mounted_snapshots
+ * @sg_mounted_snapshots_kobj_unregister: completion state
  * @sg_checkpoints_kobj: /sys/fs/<nilfs>/<device>/checkpoints
  * @sg_checkpoints_kobj_unregister: completion state
  * @sg_segments_kobj: /sys/fs/<nilfs>/<device>/segments
@@ -44,6 +46,10 @@ struct nilfs_sysfs_dev_subgroups {
 	struct kobject sg_segctor_kobj;
 	struct completion sg_segctor_kobj_unregister;
 
+	/* /sys/fs/<nilfs>/<device>/mounted_snapshots */
+	struct kobject sg_mounted_snapshots_kobj;
+	struct completion sg_mounted_snapshots_kobj_unregister;
+
 	/* /sys/fs/<nilfs>/<device>/checkpoints */
 	struct kobject sg_checkpoints_kobj;
 	struct completion sg_checkpoints_kobj_unregister;
@@ -75,6 +81,7 @@ struct nilfs_##name##_attr { \
 
 NILFS_DEV_ATTR_STRUCT(dev);
 NILFS_DEV_ATTR_STRUCT(segments);
+NILFS_DEV_ATTR_STRUCT(mounted_snapshots);
 NILFS_DEV_ATTR_STRUCT(checkpoints);
 NILFS_DEV_ATTR_STRUCT(superblock);
 NILFS_DEV_ATTR_STRUCT(segctor);
@@ -111,6 +118,9 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 #define NILFS_SEGMENTS_RW_ATTR(name) \
 	NILFS_RW_ATTR(segs_info, name)
 
+#define NILFS_MOUNTED_SNAPSHOTS_RO_ATTR(name) \
+	NILFS_RO_ATTR(mounted_snapshots, name)
+
 #define NILFS_CHECKPOINTS_RO_ATTR(name) \
 	NILFS_RO_ATTR(checkpoints, name)
 #define NILFS_CHECKPOINTS_RW_ATTR(name) \
@@ -134,6 +144,8 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 	(&nilfs_dev_attr_##name.attr)
 #define NILFS_SEGMENTS_ATTR_LIST(name) \
 	(&nilfs_segments_attr_##name.attr)
+#define NILFS_MOUNTED_SNAPSHOTS_ATTR_LIST(name) \
+	(&nilfs_mounted_snapshots_attr_##name.attr)
 #define NILFS_CHECKPOINTS_ATTR_LIST(name) \
 	(&nilfs_checkpoints_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
_

Patches currently in -mm which might be from Vyacheslav.Dubeyko@hgst.com are

origin.patch

