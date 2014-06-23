From: akpm@linux-foundation.org
Subject: + nilfs2-add-sys-fs-nilfs2-device-segments-group.patch added to
 -mm tree
Date: Mon, 23 Jun 2014 14:05:34 -0700
Message-ID: <53a8969e.0PMBnKky53E5j5HP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbaFWVFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 17:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add /sys/fs/nilfs2/<device>/segments group
has been added to the -mm tree.  Its filename is
     nilfs2-add-sys-fs-nilfs2-device-segments-group.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-sys-fs-nilfs2-device-segments-group.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-sys-fs-nilfs2-device-segments-group.patch

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
Subject: nilfs2: add /sys/fs/nilfs2/<device>/segments group

This patch adds creation of /sys/fs/nilfs2/<device>/segments
group.

The segments group contains attributes that describe
details about volume's segments:
(1) segments_number - show number of segments on volume.
(2) blocks_per_segment - show number of blocks in segment.
(3) clean_segments - show count of clean segments.
(4) dirty_segments - show count of dirty segments.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-fs-nilfs2 |   31 ++++++
 fs/nilfs2/sysfs.c                         |   99 +++++++++++++++++++-
 fs/nilfs2/sysfs.h                         |   14 ++
 3 files changed, 143 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-segments-group Documentation/ABI/testing/sysfs-fs-nilfs2
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-segments-group
+++ a/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -179,3 +179,34 @@ Contact:	"Vyacheslav Dubeyko" <slava@dub
 Description:
 		Describe attributes of /sys/fs/nilfs2/<device>/segctor
 		group.
+
+What:		/sys/fs/nilfs2/<device>/segments/segments_number
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show number of segments on a volume.
+
+What:		/sys/fs/nilfs2/<device>/segments/blocks_per_segment
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show number of blocks in segment.
+
+What:		/sys/fs/nilfs2/<device>/segments/clean_segments
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show count of clean segments.
+
+What:		/sys/fs/nilfs2/<device>/segments/dirty_segments
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show count of dirty segments.
+
+What:		/sys/fs/nilfs2/<device>/segments/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Describe attributes of /sys/fs/nilfs2/<device>/segments
+		group.
diff -puN fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-segments-group fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-segments-group
+++ a/fs/nilfs2/sysfs.c
@@ -112,6 +112,95 @@ void nilfs_sysfs_delete_##name##_group(s
 }
 
 /************************************************************************
+ *                        NILFS segments attrs                          *
+ ************************************************************************/
+
+static ssize_t
+nilfs_segments_segments_number_show(struct nilfs_segments_attr *attr,
+				     struct the_nilfs *nilfs,
+				     char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%lu\n", nilfs->ns_nsegments);
+}
+
+static ssize_t
+nilfs_segments_blocks_per_segment_show(struct nilfs_segments_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%lu\n", nilfs->ns_blocks_per_segment);
+}
+
+static ssize_t
+nilfs_segments_clean_segments_show(struct nilfs_segments_attr *attr,
+				    struct the_nilfs *nilfs,
+				    char *buf)
+{
+	unsigned long ncleansegs;
+
+	down_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+	ncleansegs = nilfs_sufile_get_ncleansegs(nilfs->ns_sufile);
+	up_read(&NILFS_MDT(nilfs->ns_dat)->mi_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", ncleansegs);
+}
+
+static ssize_t
+nilfs_segments_dirty_segments_show(struct nilfs_segments_attr *attr,
+				    struct the_nilfs *nilfs,
+				    char *buf)
+{
+	struct nilfs_sustat sustat;
+	int err;
+
+	down_read(&nilfs->ns_segctor_sem);
+	err = nilfs_sufile_get_stat(nilfs->ns_sufile, &sustat);
+	up_read(&nilfs->ns_segctor_sem);
+	if (err < 0) {
+		printk(KERN_ERR "NILFS: unable to get segment stat: err=%d\n",
+			err);
+		return err;
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", sustat.ss_ndirtysegs);
+}
+
+static const char segments_readme_str[] =
+	"The segments group contains attributes that describe\n"
+	"details about volume's segments.\n\n"
+	"(1) segments_number\n\tshow number of segments on volume.\n\n"
+	"(2) blocks_per_segment\n\tshow number of blocks in segment.\n\n"
+	"(3) clean_segments\n\tshow count of clean segments.\n\n"
+	"(4) dirty_segments\n\tshow count of dirty segments.\n\n";
+
+static ssize_t
+nilfs_segments_README_show(struct nilfs_segments_attr *attr,
+			    struct the_nilfs *nilfs,
+			    char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, segments_readme_str);
+}
+
+NILFS_SEGMENTS_RO_ATTR(segments_number);
+NILFS_SEGMENTS_RO_ATTR(blocks_per_segment);
+NILFS_SEGMENTS_RO_ATTR(clean_segments);
+NILFS_SEGMENTS_RO_ATTR(dirty_segments);
+NILFS_SEGMENTS_RO_ATTR(README);
+
+static struct attribute *nilfs_segments_attrs[] = {
+	NILFS_SEGMENTS_ATTR_LIST(segments_number),
+	NILFS_SEGMENTS_ATTR_LIST(blocks_per_segment),
+	NILFS_SEGMENTS_ATTR_LIST(clean_segments),
+	NILFS_SEGMENTS_ATTR_LIST(dirty_segments),
+	NILFS_SEGMENTS_ATTR_LIST(README),
+	NULL,
+};
+
+NILFS_DEV_INT_GROUP_OPS(segments, dev);
+NILFS_DEV_INT_GROUP_TYPE(segments, dev);
+NILFS_DEV_INT_GROUP_FNS(segments, dev);
+
+/************************************************************************
  *                        NILFS segctor attrs                           *
  ************************************************************************/
 
@@ -664,10 +753,14 @@ int nilfs_sysfs_create_device_group(stru
 	if (err)
 		goto free_dev_subgroups;
 
-	err = nilfs_sysfs_create_superblock_group(nilfs);
+	err = nilfs_sysfs_create_segments_group(nilfs);
 	if (err)
 		goto cleanup_dev_kobject;
 
+	err = nilfs_sysfs_create_superblock_group(nilfs);
+	if (err)
+		goto delete_segments_group;
+
 	err = nilfs_sysfs_create_segctor_group(nilfs);
 	if (err)
 		goto delete_superblock_group;
@@ -677,6 +770,9 @@ int nilfs_sysfs_create_device_group(stru
 delete_superblock_group:
 	nilfs_sysfs_delete_superblock_group(nilfs);
 
+delete_segments_group:
+	nilfs_sysfs_delete_segments_group(nilfs);
+
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
 
@@ -689,6 +785,7 @@ failed_create_device_group:
 
 void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 {
+	nilfs_sysfs_delete_segments_group(nilfs);
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
 	kobject_del(&nilfs->ns_dev_kobj);
diff -puN fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-segments-group fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-segments-group
+++ a/fs/nilfs2/sysfs.h
@@ -30,6 +30,8 @@
  * @sg_superblock_kobj_unregister: completion state
  * @sg_segctor_kobj: /sys/fs/<nilfs>/<device>/segctor
  * @sg_segctor_kobj_unregister: completion state
+ * @sg_segments_kobj: /sys/fs/<nilfs>/<device>/segments
+ * @sg_segments_kobj_unregister: completion state
  */
 struct nilfs_sysfs_dev_subgroups {
 	/* /sys/fs/<nilfs>/<device>/superblock */
@@ -39,6 +41,10 @@ struct nilfs_sysfs_dev_subgroups {
 	/* /sys/fs/<nilfs>/<device>/segctor */
 	struct kobject sg_segctor_kobj;
 	struct completion sg_segctor_kobj_unregister;
+
+	/* /sys/fs/<nilfs>/<device>/segments */
+	struct kobject sg_segments_kobj;
+	struct completion sg_segments_kobj_unregister;
 };
 
 #define NILFS_COMMON_ATTR_STRUCT(name) \
@@ -62,6 +68,7 @@ struct nilfs_##name##_attr { \
 };
 
 NILFS_DEV_ATTR_STRUCT(dev);
+NILFS_DEV_ATTR_STRUCT(segments);
 NILFS_DEV_ATTR_STRUCT(superblock);
 NILFS_DEV_ATTR_STRUCT(segctor);
 
@@ -92,6 +99,11 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 #define NILFS_DEV_RW_ATTR(name) \
 	NILFS_RW_ATTR(dev, name)
 
+#define NILFS_SEGMENTS_RO_ATTR(name) \
+	NILFS_RO_ATTR(segments, name)
+#define NILFS_SEGMENTS_RW_ATTR(name) \
+	NILFS_RW_ATTR(segs_info, name)
+
 #define NILFS_SUPERBLOCK_RO_ATTR(name) \
 	NILFS_RO_ATTR(superblock, name)
 #define NILFS_SUPERBLOCK_RW_ATTR(name) \
@@ -108,6 +120,8 @@ NILFS_DEV_ATTR_STRUCT(segctor);
 	(&nilfs_feature_attr_##name.attr)
 #define NILFS_DEV_ATTR_LIST(name) \
 	(&nilfs_dev_attr_##name.attr)
+#define NILFS_SEGMENTS_ATTR_LIST(name) \
+	(&nilfs_segments_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
 	(&nilfs_superblock_attr_##name.attr)
 #define NILFS_SEGCTOR_ATTR_LIST(name) \
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

