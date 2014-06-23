From: akpm@linux-foundation.org
Subject: +
 nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group.patch
 added to -mm tree
Date: Mon, 23 Jun 2014 14:05:37 -0700
Message-ID: <53a896a1.RRV/LrSBokh5ILB9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaFWVFi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 17:05:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot> group
has been added to the -mm tree.  Its filename is
     nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Subject: nilfs2: add /sys/fs/nilfs2/<device>/mounted_snapshots/<snapshot> group

This patch adds creation of <snapshot> group for every mounted
snapshot in /sys/fs/nilfs2/<device>/mounted_snapshots group.

The group contains details about mounted snapshot:
(1) inodes_count - show number of inodes for snapshot.
(2) blocks_count - show number of blocks for snapshot.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-fs-nilfs2 |   19 +++
 fs/nilfs2/sysfs.c                         |  118 ++++++++++++++++++++
 fs/nilfs2/sysfs.h                         |   20 +++
 fs/nilfs2/the_nilfs.h                     |    6 +
 4 files changed, 163 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group Documentation/ABI/testing/sysfs-fs-nilfs2
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group
+++ a/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -248,3 +248,22 @@ Contact:	"Vyacheslav Dubeyko" <slava@dub
 Description:
 		Describe content of /sys/fs/nilfs2/<device>/mounted_snapshots
 		group.
+
+What:		/sys/fs/nilfs2/<device>/mounted_snapshots/<id>/inodes_count
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show number of inodes for snapshot.
+
+What:		/sys/fs/nilfs2/<device>/mounted_snapshots/<id>/blocks_count
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show number of blocks for snapshot.
+
+What:		/sys/fs/nilfs2/<device>/mounted_snapshots/<id>/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Describe attributes of /sys/fs/nilfs2/<device>/mounted_snapshots/<id>
+		group.
diff -puN fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group
+++ a/fs/nilfs2/sysfs.c
@@ -112,6 +112,124 @@ void nilfs_sysfs_delete_##name##_group(s
 }
 
 /************************************************************************
+ *                        NILFS snapshot attrs                          *
+ ************************************************************************/
+
+static ssize_t
+nilfs_snapshot_inodes_count_show(struct nilfs_snapshot_attr *attr,
+				 struct nilfs_root *root, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)atomic64_read(&root->inodes_count));
+}
+
+static ssize_t
+nilfs_snapshot_blocks_count_show(struct nilfs_snapshot_attr *attr,
+				 struct nilfs_root *root, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)atomic64_read(&root->blocks_count));
+}
+
+static const char snapshot_readme_str[] =
+	"The group contains details about mounted snapshot.\n\n"
+	"(1) inodes_count\n\tshow number of inodes for snapshot.\n\n"
+	"(2) blocks_count\n\tshow number of blocks for snapshot.\n\n";
+
+static ssize_t
+nilfs_snapshot_README_show(struct nilfs_snapshot_attr *attr,
+			    struct nilfs_root *root, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, snapshot_readme_str);
+}
+
+NILFS_SNAPSHOT_RO_ATTR(inodes_count);
+NILFS_SNAPSHOT_RO_ATTR(blocks_count);
+NILFS_SNAPSHOT_RO_ATTR(README);
+
+static struct attribute *nilfs_snapshot_attrs[] = {
+	NILFS_SNAPSHOT_ATTR_LIST(inodes_count),
+	NILFS_SNAPSHOT_ATTR_LIST(blocks_count),
+	NILFS_SNAPSHOT_ATTR_LIST(README),
+	NULL,
+};
+
+static ssize_t nilfs_snapshot_attr_show(struct kobject *kobj,
+					struct attribute *attr, char *buf)
+{
+	struct nilfs_root *root =
+			container_of(kobj, struct nilfs_root, snapshot_kobj);
+	struct nilfs_snapshot_attr *a =
+			container_of(attr, struct nilfs_snapshot_attr, attr);
+
+	return a->show ? a->show(a, root, buf) : 0;
+}
+
+static ssize_t nilfs_snapshot_attr_store(struct kobject *kobj,
+					 struct attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct nilfs_root *root =
+			container_of(kobj, struct nilfs_root, snapshot_kobj);
+	struct nilfs_snapshot_attr *a =
+			container_of(attr, struct nilfs_snapshot_attr, attr);
+
+	return a->store ? a->store(a, root, buf, len) : 0;
+}
+
+static void nilfs_snapshot_attr_release(struct kobject *kobj)
+{
+	struct nilfs_root *root = container_of(kobj, struct nilfs_root,
+						snapshot_kobj);
+	complete(&root->snapshot_kobj_unregister);
+}
+
+static const struct sysfs_ops nilfs_snapshot_attr_ops = {
+	.show	= nilfs_snapshot_attr_show,
+	.store	= nilfs_snapshot_attr_store,
+};
+
+static struct kobj_type nilfs_snapshot_ktype = {
+	.default_attrs	= nilfs_snapshot_attrs,
+	.sysfs_ops	= &nilfs_snapshot_attr_ops,
+	.release	= nilfs_snapshot_attr_release,
+};
+
+int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
+{
+	struct the_nilfs *nilfs;
+	struct kobject *parent;
+	int err;
+
+	nilfs = root->nilfs;
+	parent = &nilfs->ns_dev_subgroups->sg_mounted_snapshots_kobj;
+	root->snapshot_kobj.kset = nilfs_kset;
+	init_completion(&root->snapshot_kobj_unregister);
+
+	if (root->cno == NILFS_CPTREE_CURRENT_CNO) {
+		err = kobject_init_and_add(&root->snapshot_kobj,
+					    &nilfs_snapshot_ktype,
+					    &nilfs->ns_dev_kobj,
+					    "current_checkpoint");
+	} else {
+		err = kobject_init_and_add(&root->snapshot_kobj,
+					    &nilfs_snapshot_ktype,
+					    parent,
+					    "%llu", root->cno);
+	}
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
+{
+	kobject_del(&root->snapshot_kobj);
+}
+
+/************************************************************************
  *                    NILFS mounted snapshots attrs                     *
  ************************************************************************/
 
diff -puN fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group
+++ a/fs/nilfs2/sysfs.h
@@ -86,6 +86,17 @@ NILFS_DEV_ATTR_STRUCT(checkpoints);
 NILFS_DEV_ATTR_STRUCT(superblock);
 NILFS_DEV_ATTR_STRUCT(segctor);
 
+#define NILFS_CP_ATTR_STRUCT(name) \
+struct nilfs_##name##_attr { \
+	struct attribute attr; \
+	ssize_t (*show)(struct nilfs_##name##_attr *, struct nilfs_root *, \
+			char *); \
+	ssize_t (*store)(struct nilfs_##name##_attr *, struct nilfs_root *, \
+			 const char *, size_t); \
+};
+
+NILFS_CP_ATTR_STRUCT(snapshot);
+
 #define NILFS_ATTR(type, name, mode, show, store) \
 	static struct nilfs_##type##_attr nilfs_##type##_attr_##name = \
 		__ATTR(name, mode, show, store)
@@ -126,6 +137,13 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 #define NILFS_CHECKPOINTS_RW_ATTR(name) \
 	NILFS_RW_ATTR(checkpoints, name)
 
+#define NILFS_SNAPSHOT_INFO_ATTR(name) \
+	NILFS_INFO_ATTR(snapshot, name)
+#define NILFS_SNAPSHOT_RO_ATTR(name) \
+	NILFS_RO_ATTR(snapshot, name)
+#define NILFS_SNAPSHOT_RW_ATTR(name) \
+	NILFS_RW_ATTR(snapshot, name)
+
 #define NILFS_SUPERBLOCK_RO_ATTR(name) \
 	NILFS_RO_ATTR(superblock, name)
 #define NILFS_SUPERBLOCK_RW_ATTR(name) \
@@ -148,6 +166,8 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 	(&nilfs_mounted_snapshots_attr_##name.attr)
 #define NILFS_CHECKPOINTS_ATTR_LIST(name) \
 	(&nilfs_checkpoints_attr_##name.attr)
+#define NILFS_SNAPSHOT_ATTR_LIST(name) \
+	(&nilfs_snapshot_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
 	(&nilfs_superblock_attr_##name.attr)
 #define NILFS_SEGCTOR_ATTR_LIST(name) \
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group
+++ a/fs/nilfs2/the_nilfs.h
@@ -243,6 +243,8 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * @ifile: inode file
  * @inodes_count: number of inodes
  * @blocks_count: number of blocks
+ * @snapshot_kobj: /sys/fs/<nilfs>/<device>/mounted_snapshots/<snapshot>
+ * @snapshot_kobj_unregister: completion state for kernel object
  */
 struct nilfs_root {
 	__u64 cno;
@@ -254,6 +256,10 @@ struct nilfs_root {
 
 	atomic64_t inodes_count;
 	atomic64_t blocks_count;
+
+	/* /sys/fs/<nilfs>/<device>/mounted_snapshots/<snapshot> */
+	struct kobject snapshot_kobj;
+	struct completion snapshot_kobj_unregister;
 };
 
 /* Special checkpoint number */
_

Patches currently in -mm which might be from Vyacheslav.Dubeyko@hgst.com are

nilfs2-add-sys-fs-nilfs2-features-group.patch
nilfs2-add-sys-fs-nilfs2-device-group.patch
nilfs2-add-sys-fs-nilfs2-device-superblock-group.patch
nilfs2-add-sys-fs-nilfs2-device-segctor-group.patch
nilfs2-add-sys-fs-nilfs2-device-segments-group.patch
nilfs2-add-sys-fs-nilfs2-device-checkpoints-group.patch
nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-group.patch
nilfs2-add-sys-fs-nilfs2-device-mounted_snapshots-snapshot-group.patch
nilfs2-integrate-sysfs-support-into-driver.patch

