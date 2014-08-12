From: akpm@linux-foundation.org
Subject: [merged] nilfs2-add-sys-fs-nilfs2-device-superblock-group.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:08 -0700
Message-ID: <53ea6d5c.tOvnGIDRKqQMzIcF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:37433 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHLTjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:09 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1919582oah.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add /sys/fs/nilfs2/<device>/superblock group
has been removed from the -mm tree.  Its filename was
     nilfs2-add-sys-fs-nilfs2-device-superblock-group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Subject: nilfs2: add /sys/fs/nilfs2/<device>/superblock group

This patch adds creation of /sys/fs/nilfs2/<device>/superblock
group.

The superblock group contains attributes that describe
superblock's details:
(1) sb_write_time - show previous write time of super block in
human-readable format.
(2) sb_write_time_secs - show previous write time of super block
in seconds.
(3) sb_write_count - show write count of super block.
(4) sb_update_frequency - show/set interval of periodical update
of superblock (in seconds). You can set preferable frequency of
superblock update by command:

echo <value> > /sys/fs/nilfs2/<device>/superblock/sb_update_frequency

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-fs-nilfs2 |   33 +++
 fs/nilfs2/sysfs.c                         |  218 +++++++++++++++++++-
 fs/nilfs2/sysfs.h                         |   19 +
 fs/nilfs2/the_nilfs.c                     |    1 
 fs/nilfs2/the_nilfs.h                     |    8 
 5 files changed, 277 insertions(+), 2 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-superblock-group Documentation/ABI/testing/sysfs-fs-nilfs2
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-superblock-group
+++ a/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -56,3 +56,36 @@ Date:		April 2014
 Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
 Description:
 		Describe attributes of /sys/fs/nilfs2/<device> group.
+
+What:		/sys/fs/nilfs2/<device>/superblock/sb_write_time
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show last write time of super block in human-readable
+		format.
+
+What:		/sys/fs/nilfs2/<device>/superblock/sb_write_time_secs
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show last write time of super block in seconds.
+
+What:		/sys/fs/nilfs2/<device>/superblock/sb_write_count
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show current write count of super block.
+
+What:		/sys/fs/nilfs2/<device>/superblock/sb_update_frequency
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show/Set interval of periodical update of superblock
+		(in seconds).
+
+What:		/sys/fs/nilfs2/<device>/superblock/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Describe attributes of /sys/fs/nilfs2/<device>/superblock
+		group.
diff -puN fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-superblock-group fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-superblock-group
+++ a/fs/nilfs2/sysfs.c
@@ -41,6 +41,202 @@ static struct kset *nilfs_kset;
 		count; \
 })
 
+#define NILFS_DEV_INT_GROUP_OPS(name, parent_name) \
+static ssize_t nilfs_##name##_attr_show(struct kobject *kobj, \
+					struct attribute *attr, char *buf) \
+{ \
+	struct the_nilfs *nilfs = container_of(kobj->parent, \
+						struct the_nilfs, \
+						ns_##parent_name##_kobj); \
+	struct nilfs_##name##_attr *a = container_of(attr, \
+						struct nilfs_##name##_attr, \
+						attr); \
+	return a->show ? a->show(a, nilfs, buf) : 0; \
+} \
+static ssize_t nilfs_##name##_attr_store(struct kobject *kobj, \
+					 struct attribute *attr, \
+					 const char *buf, size_t len) \
+{ \
+	struct the_nilfs *nilfs = container_of(kobj->parent, \
+						struct the_nilfs, \
+						ns_##parent_name##_kobj); \
+	struct nilfs_##name##_attr *a = container_of(attr, \
+						struct nilfs_##name##_attr, \
+						attr); \
+	return a->store ? a->store(a, nilfs, buf, len) : 0; \
+} \
+static const struct sysfs_ops nilfs_##name##_attr_ops = { \
+	.show	= nilfs_##name##_attr_show, \
+	.store	= nilfs_##name##_attr_store, \
+};
+
+#define NILFS_DEV_INT_GROUP_TYPE(name, parent_name) \
+static void nilfs_##name##_attr_release(struct kobject *kobj) \
+{ \
+	struct nilfs_sysfs_##parent_name##_subgroups *subgroups; \
+	struct the_nilfs *nilfs = container_of(kobj->parent, \
+						struct the_nilfs, \
+						ns_##parent_name##_kobj); \
+	subgroups = nilfs->ns_##parent_name##_subgroups; \
+	complete(&subgroups->sg_##name##_kobj_unregister); \
+} \
+static struct kobj_type nilfs_##name##_ktype = { \
+	.default_attrs	= nilfs_##name##_attrs, \
+	.sysfs_ops	= &nilfs_##name##_attr_ops, \
+	.release	= nilfs_##name##_attr_release, \
+};
+
+#define NILFS_DEV_INT_GROUP_FNS(name, parent_name) \
+int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
+{ \
+	struct kobject *parent; \
+	struct kobject *kobj; \
+	struct completion *kobj_unregister; \
+	struct nilfs_sysfs_##parent_name##_subgroups *subgroups; \
+	int err; \
+	subgroups = nilfs->ns_##parent_name##_subgroups; \
+	kobj = &subgroups->sg_##name##_kobj; \
+	kobj_unregister = &subgroups->sg_##name##_kobj_unregister; \
+	parent = &nilfs->ns_##parent_name##_kobj; \
+	kobj->kset = nilfs_kset; \
+	init_completion(kobj_unregister); \
+	err = kobject_init_and_add(kobj, &nilfs_##name##_ktype, parent, \
+				    #name); \
+	if (err) \
+		return err; \
+	return 0; \
+} \
+void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
+{ \
+	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+}
+
+/************************************************************************
+ *                        NILFS superblock attrs                        *
+ ************************************************************************/
+
+static ssize_t
+nilfs_superblock_sb_write_time_show(struct nilfs_superblock_attr *attr,
+				     struct the_nilfs *nilfs,
+				     char *buf)
+{
+	time_t sbwtime;
+
+	down_read(&nilfs->ns_sem);
+	sbwtime = nilfs->ns_sbwtime;
+	up_read(&nilfs->ns_sem);
+
+	return NILFS_SHOW_TIME(sbwtime, buf);
+}
+
+static ssize_t
+nilfs_superblock_sb_write_time_secs_show(struct nilfs_superblock_attr *attr,
+					 struct the_nilfs *nilfs,
+					 char *buf)
+{
+	time_t sbwtime;
+
+	down_read(&nilfs->ns_sem);
+	sbwtime = nilfs->ns_sbwtime;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)sbwtime);
+}
+
+static ssize_t
+nilfs_superblock_sb_write_count_show(struct nilfs_superblock_attr *attr,
+				      struct the_nilfs *nilfs,
+				      char *buf)
+{
+	unsigned sbwcount;
+
+	down_read(&nilfs->ns_sem);
+	sbwcount = nilfs->ns_sbwcount;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", sbwcount);
+}
+
+static ssize_t
+nilfs_superblock_sb_update_frequency_show(struct nilfs_superblock_attr *attr,
+					    struct the_nilfs *nilfs,
+					    char *buf)
+{
+	unsigned sb_update_freq;
+
+	down_read(&nilfs->ns_sem);
+	sb_update_freq = nilfs->ns_sb_update_freq;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", sb_update_freq);
+}
+
+static ssize_t
+nilfs_superblock_sb_update_frequency_store(struct nilfs_superblock_attr *attr,
+					    struct the_nilfs *nilfs,
+					    const char *buf, size_t count)
+{
+	unsigned val;
+	int err;
+
+	err = kstrtouint(skip_spaces(buf), 0, &val);
+	if (err) {
+		printk(KERN_ERR "NILFS: unable to convert string: err=%d\n",
+			err);
+		return err;
+	}
+
+	if (val < NILFS_SB_FREQ) {
+		val = NILFS_SB_FREQ;
+		printk(KERN_WARNING "NILFS: superblock update frequency cannot be lesser than 10 seconds\n");
+	}
+
+	down_write(&nilfs->ns_sem);
+	nilfs->ns_sb_update_freq = val;
+	up_write(&nilfs->ns_sem);
+
+	return count;
+}
+
+static const char sb_readme_str[] =
+	"The superblock group contains attributes that describe\n"
+	"superblock's details.\n\n"
+	"(1) sb_write_time\n\tshow previous write time of super block "
+	"in human-readable format.\n\n"
+	"(2) sb_write_time_secs\n\tshow previous write time of super block "
+	"in seconds.\n\n"
+	"(3) sb_write_count\n\tshow write count of super block.\n\n"
+	"(4) sb_update_frequency\n"
+	"\tshow/set interval of periodical update of superblock (in seconds).\n\n"
+	"\tYou can set preferable frequency of superblock update by command:\n\n"
+	"\t'echo <val> > /sys/fs/<nilfs>/<dev>/superblock/sb_update_frequency'\n";
+
+static ssize_t
+nilfs_superblock_README_show(struct nilfs_superblock_attr *attr,
+				struct the_nilfs *nilfs, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, sb_readme_str);
+}
+
+NILFS_SUPERBLOCK_RO_ATTR(sb_write_time);
+NILFS_SUPERBLOCK_RO_ATTR(sb_write_time_secs);
+NILFS_SUPERBLOCK_RO_ATTR(sb_write_count);
+NILFS_SUPERBLOCK_RW_ATTR(sb_update_frequency);
+NILFS_SUPERBLOCK_RO_ATTR(README);
+
+static struct attribute *nilfs_superblock_attrs[] = {
+	NILFS_SUPERBLOCK_ATTR_LIST(sb_write_time),
+	NILFS_SUPERBLOCK_ATTR_LIST(sb_write_time_secs),
+	NILFS_SUPERBLOCK_ATTR_LIST(sb_write_count),
+	NILFS_SUPERBLOCK_ATTR_LIST(sb_update_frequency),
+	NILFS_SUPERBLOCK_ATTR_LIST(README),
+	NULL,
+};
+
+NILFS_DEV_INT_GROUP_OPS(superblock, dev);
+NILFS_DEV_INT_GROUP_TYPE(superblock, dev);
+NILFS_DEV_INT_GROUP_FNS(superblock, dev);
+
 /************************************************************************
  *                        NILFS device attrs                            *
  ************************************************************************/
@@ -189,24 +385,44 @@ static struct kobj_type nilfs_dev_ktype
 int nilfs_sysfs_create_device_group(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
+	size_t devgrp_size = sizeof(struct nilfs_sysfs_dev_subgroups);
 	int err;
 
+	nilfs->ns_dev_subgroups = kzalloc(devgrp_size, GFP_KERNEL);
+	if (unlikely(!nilfs->ns_dev_subgroups)) {
+		err = -ENOMEM;
+		printk(KERN_ERR "NILFS: unable to allocate memory for device group\n");
+		goto failed_create_device_group;
+	}
+
 	nilfs->ns_dev_kobj.kset = nilfs_kset;
 	init_completion(&nilfs->ns_dev_kobj_unregister);
 	err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
 				    "%s", sb->s_id);
 	if (err)
-		goto failed_create_device_group;
+		goto free_dev_subgroups;
+
+	err = nilfs_sysfs_create_superblock_group(nilfs);
+	if (err)
+		goto cleanup_dev_kobject;
 
 	return 0;
 
+cleanup_dev_kobject:
+	kobject_del(&nilfs->ns_dev_kobj);
+
+free_dev_subgroups:
+	kfree(nilfs->ns_dev_subgroups);
+
 failed_create_device_group:
 	return err;
 }
 
 void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 {
+	nilfs_sysfs_delete_superblock_group(nilfs);
 	kobject_del(&nilfs->ns_dev_kobj);
+	kfree(nilfs->ns_dev_subgroups);
 }
 
 /************************************************************************
diff -puN fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-superblock-group fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-superblock-group
+++ a/fs/nilfs2/sysfs.h
@@ -24,6 +24,17 @@
 
 #define NILFS_ROOT_GROUP_NAME	"nilfs2"
 
+/*
+ * struct nilfs_sysfs_dev_subgroups - device subgroup kernel objects
+ * @sg_superblock_kobj: /sys/fs/<nilfs>/<device>/superblock
+ * @sg_superblock_kobj_unregister: completion state
+ */
+struct nilfs_sysfs_dev_subgroups {
+	/* /sys/fs/<nilfs>/<device>/superblock */
+	struct kobject sg_superblock_kobj;
+	struct completion sg_superblock_kobj_unregister;
+};
+
 #define NILFS_COMMON_ATTR_STRUCT(name) \
 struct nilfs_##name##_attr { \
 	struct attribute attr; \
@@ -45,6 +56,7 @@ struct nilfs_##name##_attr { \
 };
 
 NILFS_DEV_ATTR_STRUCT(dev);
+NILFS_DEV_ATTR_STRUCT(superblock);
 
 #define NILFS_ATTR(type, name, mode, show, store) \
 	static struct nilfs_##type##_attr nilfs_##type##_attr_##name = \
@@ -73,9 +85,16 @@ NILFS_DEV_ATTR_STRUCT(dev);
 #define NILFS_DEV_RW_ATTR(name) \
 	NILFS_RW_ATTR(dev, name)
 
+#define NILFS_SUPERBLOCK_RO_ATTR(name) \
+	NILFS_RO_ATTR(superblock, name)
+#define NILFS_SUPERBLOCK_RW_ATTR(name) \
+	NILFS_RW_ATTR(superblock, name)
+
 #define NILFS_FEATURE_ATTR_LIST(name) \
 	(&nilfs_feature_attr_##name.attr)
 #define NILFS_DEV_ATTR_LIST(name) \
 	(&nilfs_dev_attr_##name.attr)
+#define NILFS_SUPERBLOCK_ATTR_LIST(name) \
+	(&nilfs_superblock_attr_##name.attr)
 
 #endif /* _NILFS_SYSFS_H */
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-add-sys-fs-nilfs2-device-superblock-group fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-add-sys-fs-nilfs2-device-superblock-group
+++ a/fs/nilfs2/the_nilfs.c
@@ -85,6 +85,7 @@ struct the_nilfs *alloc_nilfs(struct blo
 	nilfs->ns_cptree = RB_ROOT;
 	spin_lock_init(&nilfs->ns_cptree_lock);
 	init_rwsem(&nilfs->ns_segctor_sem);
+	nilfs->ns_sb_update_freq = NILFS_SB_FREQ;
 
 	return nilfs;
 }
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-add-sys-fs-nilfs2-device-superblock-group fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-add-sys-fs-nilfs2-device-superblock-group
+++ a/fs/nilfs2/the_nilfs.h
@@ -33,6 +33,7 @@
 #include <linux/slab.h>
 
 struct nilfs_sc_info;
+struct nilfs_sysfs_dev_subgroups;
 
 /* the_nilfs struct */
 enum {
@@ -54,6 +55,7 @@ enum {
  * @ns_sbwcount: write count of super block
  * @ns_sbsize: size of valid data in super block
  * @ns_mount_state: file system state
+ * @ns_sb_update_freq: interval of periodical update of superblocks (in seconds)
  * @ns_seg_seq: segment sequence counter
  * @ns_segnum: index number of the latest full segment.
  * @ns_nextnum: index number of the full segment index to be used next
@@ -97,6 +99,7 @@ enum {
  * @ns_crc_seed: seed value of CRC32 calculation
  * @ns_dev_kobj: /sys/fs/<nilfs>/<device>
  * @ns_dev_kobj_unregister: completion state
+ * @ns_dev_subgroups: <device> subgroups pointer
  */
 struct the_nilfs {
 	unsigned long		ns_flags;
@@ -116,6 +119,7 @@ struct the_nilfs {
 	unsigned		ns_sbwcount;
 	unsigned		ns_sbsize;
 	unsigned		ns_mount_state;
+	unsigned		ns_sb_update_freq;
 
 	/*
 	 * Following fields are dedicated to a writable FS-instance.
@@ -194,6 +198,7 @@ struct the_nilfs {
 	/* /sys/fs/<nilfs>/<device> */
 	struct kobject ns_dev_kobj;
 	struct completion ns_dev_kobj_unregister;
+	struct nilfs_sysfs_dev_subgroups *ns_dev_subgroups;
 };
 
 #define THE_NILFS_FNS(bit, name)					\
@@ -260,7 +265,8 @@ struct nilfs_root {
 static inline int nilfs_sb_need_update(struct the_nilfs *nilfs)
 {
 	u64 t = get_seconds();
-	return t < nilfs->ns_sbwtime || t > nilfs->ns_sbwtime + NILFS_SB_FREQ;
+	return t < nilfs->ns_sbwtime ||
+		t > nilfs->ns_sbwtime + nilfs->ns_sb_update_freq;
 }
 
 static inline int nilfs_sb_will_flip(struct the_nilfs *nilfs)
_

Patches currently in -mm which might be from Vyacheslav.Dubeyko@hgst.com are

origin.patch

