From: akpm@linux-foundation.org
Subject: + nilfs2-add-sys-fs-nilfs2-device-group.patch added to -mm tree
Date: Mon, 23 Jun 2014 14:05:28 -0700
Message-ID: <53a89698.Buq5VignA6DdIjbQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaFWVF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 17:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add /sys/fs/nilfs2/<device> group
has been added to the -mm tree.  Its filename is
     nilfs2-add-sys-fs-nilfs2-device-group.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-sys-fs-nilfs2-device-group.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-sys-fs-nilfs2-device-group.patch

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
Subject: nilfs2: add /sys/fs/nilfs2/<device> group

This patch adds creation of /sys/fs/nilfs2/<device> group.

The <device> group contains attributes that describe file
system partition's details:
(1) revision - show NILFS file system revision.
(2) blocksize - show volume block size in bytes.
(3) device_size - show volume size in bytes.
(4) free_blocks - show count of free blocks on volume.
(5) uuid - show volume's UUID.
(6) volume_name - show volume's name.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-fs-nilfs2 |   44 +++++
 fs/nilfs2/sysfs.c                         |  168 ++++++++++++++++++++
 fs/nilfs2/sysfs.h                         |   20 ++
 fs/nilfs2/the_nilfs.h                     |    6 
 4 files changed, 238 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-group Documentation/ABI/testing/sysfs-fs-nilfs2
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-group
+++ a/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -12,3 +12,47 @@ Date:		April 2014
 Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
 Description:
 		Describe attributes of /sys/fs/nilfs2/features group.
+
+What:		/sys/fs/nilfs2/<device>/revision
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show NILFS file system revision on volume.
+		This value informs about metadata structures'
+		revision on mounted volume.
+
+What:		/sys/fs/nilfs2/<device>/blocksize
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show volume's block size in bytes.
+
+What:		/sys/fs/nilfs2/<device>/device_size
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show volume size in bytes.
+
+What:		/sys/fs/nilfs2/<device>/free_blocks
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show count of free blocks on volume.
+
+What:		/sys/fs/nilfs2/<device>/uuid
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show volume's UUID (Universally Unique Identifier).
+
+What:		/sys/fs/nilfs2/<device>/volume_name
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show volume's label.
+
+What:		/sys/fs/nilfs2/<device>/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Describe attributes of /sys/fs/nilfs2/<device> group.
diff -puN fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-group fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-group
+++ a/fs/nilfs2/sysfs.c
@@ -42,6 +42,174 @@ static struct kset *nilfs_kset;
 })
 
 /************************************************************************
+ *                        NILFS device attrs                            *
+ ************************************************************************/
+
+static
+ssize_t nilfs_dev_revision_show(struct nilfs_dev_attr *attr,
+				struct the_nilfs *nilfs,
+				char *buf)
+{
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	u32 major = le32_to_cpu(sbp[0]->s_rev_level);
+	u16 minor = le16_to_cpu(sbp[0]->s_minor_rev_level);
+
+	return snprintf(buf, PAGE_SIZE, "%d.%d\n", major, minor);
+}
+
+static
+ssize_t nilfs_dev_blocksize_show(struct nilfs_dev_attr *attr,
+				 struct the_nilfs *nilfs,
+				 char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", nilfs->ns_blocksize);
+}
+
+static
+ssize_t nilfs_dev_device_size_show(struct nilfs_dev_attr *attr,
+				    struct the_nilfs *nilfs,
+				    char *buf)
+{
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+	u64 dev_size = le64_to_cpu(sbp[0]->s_dev_size);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", dev_size);
+}
+
+static
+ssize_t nilfs_dev_free_blocks_show(struct nilfs_dev_attr *attr,
+				   struct the_nilfs *nilfs,
+				   char *buf)
+{
+	sector_t free_blocks = 0;
+
+	nilfs_count_free_blocks(nilfs, &free_blocks);
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)free_blocks);
+}
+
+static
+ssize_t nilfs_dev_uuid_show(struct nilfs_dev_attr *attr,
+			    struct the_nilfs *nilfs,
+			    char *buf)
+{
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+
+	return snprintf(buf, PAGE_SIZE, "%pUb\n", sbp[0]->s_uuid);
+}
+
+static
+ssize_t nilfs_dev_volume_name_show(struct nilfs_dev_attr *attr,
+				    struct the_nilfs *nilfs,
+				    char *buf)
+{
+	struct nilfs_super_block **sbp = nilfs->ns_sbp;
+
+	return scnprintf(buf, sizeof(sbp[0]->s_volume_name), "%s\n",
+			 sbp[0]->s_volume_name);
+}
+
+static const char dev_readme_str[] =
+	"The <device> group contains attributes that describe file system\n"
+	"partition's details.\n\n"
+	"(1) revision\n\tshow NILFS file system revision.\n\n"
+	"(2) blocksize\n\tshow volume block size in bytes.\n\n"
+	"(3) device_size\n\tshow volume size in bytes.\n\n"
+	"(4) free_blocks\n\tshow count of free blocks on volume.\n\n"
+	"(5) uuid\n\tshow volume's UUID.\n\n"
+	"(6) volume_name\n\tshow volume's name.\n\n";
+
+static ssize_t nilfs_dev_README_show(struct nilfs_dev_attr *attr,
+				     struct the_nilfs *nilfs,
+				     char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, dev_readme_str);
+}
+
+NILFS_DEV_RO_ATTR(revision);
+NILFS_DEV_RO_ATTR(blocksize);
+NILFS_DEV_RO_ATTR(device_size);
+NILFS_DEV_RO_ATTR(free_blocks);
+NILFS_DEV_RO_ATTR(uuid);
+NILFS_DEV_RO_ATTR(volume_name);
+NILFS_DEV_RO_ATTR(README);
+
+static struct attribute *nilfs_dev_attrs[] = {
+	NILFS_DEV_ATTR_LIST(revision),
+	NILFS_DEV_ATTR_LIST(blocksize),
+	NILFS_DEV_ATTR_LIST(device_size),
+	NILFS_DEV_ATTR_LIST(free_blocks),
+	NILFS_DEV_ATTR_LIST(uuid),
+	NILFS_DEV_ATTR_LIST(volume_name),
+	NILFS_DEV_ATTR_LIST(README),
+	NULL,
+};
+
+static ssize_t nilfs_dev_attr_show(struct kobject *kobj,
+				    struct attribute *attr, char *buf)
+{
+	struct the_nilfs *nilfs = container_of(kobj, struct the_nilfs,
+						ns_dev_kobj);
+	struct nilfs_dev_attr *a = container_of(attr, struct nilfs_dev_attr,
+						attr);
+
+	return a->show ? a->show(a, nilfs, buf) : 0;
+}
+
+static ssize_t nilfs_dev_attr_store(struct kobject *kobj,
+				    struct attribute *attr,
+				    const char *buf, size_t len)
+{
+	struct the_nilfs *nilfs = container_of(kobj, struct the_nilfs,
+						ns_dev_kobj);
+	struct nilfs_dev_attr *a = container_of(attr, struct nilfs_dev_attr,
+						attr);
+
+	return a->store ? a->store(a, nilfs, buf, len) : 0;
+}
+
+static void nilfs_dev_attr_release(struct kobject *kobj)
+{
+	struct the_nilfs *nilfs = container_of(kobj, struct the_nilfs,
+						ns_dev_kobj);
+	complete(&nilfs->ns_dev_kobj_unregister);
+}
+
+static const struct sysfs_ops nilfs_dev_attr_ops = {
+	.show	= nilfs_dev_attr_show,
+	.store	= nilfs_dev_attr_store,
+};
+
+static struct kobj_type nilfs_dev_ktype = {
+	.default_attrs	= nilfs_dev_attrs,
+	.sysfs_ops	= &nilfs_dev_attr_ops,
+	.release	= nilfs_dev_attr_release,
+};
+
+int nilfs_sysfs_create_device_group(struct super_block *sb)
+{
+	struct the_nilfs *nilfs = sb->s_fs_info;
+	int err;
+
+	nilfs->ns_dev_kobj.kset = nilfs_kset;
+	init_completion(&nilfs->ns_dev_kobj_unregister);
+	err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
+				    "%s", sb->s_id);
+	if (err)
+		goto failed_create_device_group;
+
+	return 0;
+
+failed_create_device_group:
+	return err;
+}
+
+void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
+{
+	kobject_del(&nilfs->ns_dev_kobj);
+}
+
+/************************************************************************
  *                        NILFS feature attrs                           *
  ************************************************************************/
 
diff -puN fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-group fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-group
+++ a/fs/nilfs2/sysfs.h
@@ -35,6 +35,17 @@ struct nilfs_##name##_attr { \
 
 NILFS_COMMON_ATTR_STRUCT(feature);
 
+#define NILFS_DEV_ATTR_STRUCT(name) \
+struct nilfs_##name##_attr { \
+	struct attribute attr; \
+	ssize_t (*show)(struct nilfs_##name##_attr *, struct the_nilfs *, \
+			char *); \
+	ssize_t (*store)(struct nilfs_##name##_attr *, struct the_nilfs *, \
+			 const char *, size_t); \
+};
+
+NILFS_DEV_ATTR_STRUCT(dev);
+
 #define NILFS_ATTR(type, name, mode, show, store) \
 	static struct nilfs_##type##_attr nilfs_##type##_attr_##name = \
 		__ATTR(name, mode, show, store)
@@ -55,7 +66,16 @@ NILFS_COMMON_ATTR_STRUCT(feature);
 #define NILFS_FEATURE_RW_ATTR(name) \
 	NILFS_RW_ATTR(feature, name)
 
+#define NILFS_DEV_INFO_ATTR(name) \
+	NILFS_INFO_ATTR(dev, name)
+#define NILFS_DEV_RO_ATTR(name) \
+	NILFS_RO_ATTR(dev, name)
+#define NILFS_DEV_RW_ATTR(name) \
+	NILFS_RW_ATTR(dev, name)
+
 #define NILFS_FEATURE_ATTR_LIST(name) \
 	(&nilfs_feature_attr_##name.attr)
+#define NILFS_DEV_ATTR_LIST(name) \
+	(&nilfs_dev_attr_##name.attr)
 
 #endif /* _NILFS_SYSFS_H */
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-add-sys-fs-nilfs2-device-group fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-add-sys-fs-nilfs2-device-group
+++ a/fs/nilfs2/the_nilfs.h
@@ -95,6 +95,8 @@ enum {
  * @ns_inode_size: size of on-disk inode
  * @ns_first_ino: first not-special inode number
  * @ns_crc_seed: seed value of CRC32 calculation
+ * @ns_dev_kobj: /sys/fs/<nilfs>/<device>
+ * @ns_dev_kobj_unregister: completion state
  */
 struct the_nilfs {
 	unsigned long		ns_flags;
@@ -188,6 +190,10 @@ struct the_nilfs {
 	int			ns_inode_size;
 	int			ns_first_ino;
 	u32			ns_crc_seed;
+
+	/* /sys/fs/<nilfs>/<device> */
+	struct kobject ns_dev_kobj;
+	struct completion ns_dev_kobj_unregister;
 };
 
 #define THE_NILFS_FNS(bit, name)					\
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

