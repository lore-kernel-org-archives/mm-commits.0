From: akpm@linux-foundation.org
Subject: [merged] nilfs2-add-sys-fs-nilfs2-device-segctor-group.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:10 -0700
Message-ID: <53ea6d5e.+AbBXoRKr2l2W9Al%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34284 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbaHLTjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:11 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so1919769obc.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vyacheslav.Dubeyko@hgst.com, konishi.ryusuke@lab.ntt.co.jp, mlsemon35@gmail.com, slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add /sys/fs/nilfs2/<device>/segctor group
has been removed from the -mm tree.  Its filename was
     nilfs2-add-sys-fs-nilfs2-device-segctor-group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Subject: nilfs2: add /sys/fs/nilfs2/<device>/segctor group

This patch adds creation of /sys/fs/nilfs2/<device>/segctor
group.

The segctor group contains attributes that describe
segctor thread activity details:
(1) last_pseg_block - show start block number of the latest segment.
(2) last_seg_sequence - show sequence value of the latest segment.
(3) last_seg_checkpoint - show checkpoint number of the latest segment.
(4) current_seg_sequence - show segment sequence counter.
(5) current_last_full_seg - show index number of the latest full segment.
(6) next_full_seg - show index number of the full segment index
to be used next.
(7) next_pseg_offset - show offset of next partial segment in
the current full segment.
(8) next_checkpoint - show next checkpoint number.
(9) last_seg_write_time - show write time of the last segment
in human-readable format.
(10) last_seg_write_time_secs - show write time of the last segment
in seconds.
(11) last_nongc_write_time - show write time of the last segment
not for cleaner operation in human-readable format.
(12) last_nongc_write_time_secs - show write time of the last segment
not for cleaner operation in seconds.
(13) dirty_data_blocks_count - show number of dirty data blocks.

Signed-off-by: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-fs-nilfs2 |   90 ++++++
 fs/nilfs2/sysfs.c                         |  270 ++++++++++++++++++++
 fs/nilfs2/sysfs.h                         |   16 +
 3 files changed, 376 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-segctor-group Documentation/ABI/testing/sysfs-fs-nilfs2
--- a/Documentation/ABI/testing/sysfs-fs-nilfs2~nilfs2-add-sys-fs-nilfs2-device-segctor-group
+++ a/Documentation/ABI/testing/sysfs-fs-nilfs2
@@ -89,3 +89,93 @@ Contact:	"Vyacheslav Dubeyko" <slava@dub
 Description:
 		Describe attributes of /sys/fs/nilfs2/<device>/superblock
 		group.
+
+What:		/sys/fs/nilfs2/<device>/segctor/last_pseg_block
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show start block number of the latest segment.
+
+What:		/sys/fs/nilfs2/<device>/segctor/last_seg_sequence
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show sequence value of the latest segment.
+
+What:		/sys/fs/nilfs2/<device>/segctor/last_seg_checkpoint
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show checkpoint number of the latest segment.
+
+What:		/sys/fs/nilfs2/<device>/segctor/current_seg_sequence
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show segment sequence counter.
+
+What:		/sys/fs/nilfs2/<device>/segctor/current_last_full_seg
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show index number of the latest full segment.
+
+What:		/sys/fs/nilfs2/<device>/segctor/next_full_seg
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show index number of the full segment index
+		to be used next.
+
+What:		/sys/fs/nilfs2/<device>/segctor/next_pseg_offset
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show offset of next partial segment in the current
+		full segment.
+
+What:		/sys/fs/nilfs2/<device>/segctor/next_checkpoint
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show next checkpoint number.
+
+What:		/sys/fs/nilfs2/<device>/segctor/last_seg_write_time
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show write time of the last segment in
+		human-readable format.
+
+What:		/sys/fs/nilfs2/<device>/segctor/last_seg_write_time_secs
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show write time of the last segment in seconds.
+
+What:		/sys/fs/nilfs2/<device>/segctor/last_nongc_write_time
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show write time of the last segment not for cleaner
+		operation in human-readable format.
+
+What:		/sys/fs/nilfs2/<device>/segctor/last_nongc_write_time_secs
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show write time of the last segment not for cleaner
+		operation in seconds.
+
+What:		/sys/fs/nilfs2/<device>/segctor/dirty_data_blocks_count
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Show number of dirty data blocks.
+
+What:		/sys/fs/nilfs2/<device>/segctor/README
+Date:		April 2014
+Contact:	"Vyacheslav Dubeyko" <slava@dubeyko.com>
+Description:
+		Describe attributes of /sys/fs/nilfs2/<device>/segctor
+		group.
diff -puN fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-segctor-group fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-add-sys-fs-nilfs2-device-segctor-group
+++ a/fs/nilfs2/sysfs.c
@@ -112,6 +112,268 @@ void nilfs_sysfs_delete_##name##_group(s
 }
 
 /************************************************************************
+ *                        NILFS segctor attrs                           *
+ ************************************************************************/
+
+static ssize_t
+nilfs_segctor_last_pseg_block_show(struct nilfs_segctor_attr *attr,
+				    struct the_nilfs *nilfs,
+				    char *buf)
+{
+	sector_t last_pseg;
+
+	spin_lock(&nilfs->ns_last_segment_lock);
+	last_pseg = nilfs->ns_last_pseg;
+	spin_unlock(&nilfs->ns_last_segment_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)last_pseg);
+}
+
+static ssize_t
+nilfs_segctor_last_seg_sequence_show(struct nilfs_segctor_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	u64 last_seq;
+
+	spin_lock(&nilfs->ns_last_segment_lock);
+	last_seq = nilfs->ns_last_seq;
+	spin_unlock(&nilfs->ns_last_segment_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", last_seq);
+}
+
+static ssize_t
+nilfs_segctor_last_seg_checkpoint_show(struct nilfs_segctor_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	__u64 last_cno;
+
+	spin_lock(&nilfs->ns_last_segment_lock);
+	last_cno = nilfs->ns_last_cno;
+	spin_unlock(&nilfs->ns_last_segment_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", last_cno);
+}
+
+static ssize_t
+nilfs_segctor_current_seg_sequence_show(struct nilfs_segctor_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	u64 seg_seq;
+
+	down_read(&nilfs->ns_sem);
+	seg_seq = nilfs->ns_seg_seq;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", seg_seq);
+}
+
+static ssize_t
+nilfs_segctor_current_last_full_seg_show(struct nilfs_segctor_attr *attr,
+					 struct the_nilfs *nilfs,
+					 char *buf)
+{
+	__u64 segnum;
+
+	down_read(&nilfs->ns_sem);
+	segnum = nilfs->ns_segnum;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", segnum);
+}
+
+static ssize_t
+nilfs_segctor_next_full_seg_show(struct nilfs_segctor_attr *attr,
+				 struct the_nilfs *nilfs,
+				 char *buf)
+{
+	__u64 nextnum;
+
+	down_read(&nilfs->ns_sem);
+	nextnum = nilfs->ns_nextnum;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", nextnum);
+}
+
+static ssize_t
+nilfs_segctor_next_pseg_offset_show(struct nilfs_segctor_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	unsigned long pseg_offset;
+
+	down_read(&nilfs->ns_sem);
+	pseg_offset = nilfs->ns_pseg_offset;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", pseg_offset);
+}
+
+static ssize_t
+nilfs_segctor_next_checkpoint_show(struct nilfs_segctor_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	__u64 cno;
+
+	down_read(&nilfs->ns_sem);
+	cno = nilfs->ns_cno;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", cno);
+}
+
+static ssize_t
+nilfs_segctor_last_seg_write_time_show(struct nilfs_segctor_attr *attr,
+					struct the_nilfs *nilfs,
+					char *buf)
+{
+	time_t ctime;
+
+	down_read(&nilfs->ns_sem);
+	ctime = nilfs->ns_ctime;
+	up_read(&nilfs->ns_sem);
+
+	return NILFS_SHOW_TIME(ctime, buf);
+}
+
+static ssize_t
+nilfs_segctor_last_seg_write_time_secs_show(struct nilfs_segctor_attr *attr,
+					    struct the_nilfs *nilfs,
+					    char *buf)
+{
+	time_t ctime;
+
+	down_read(&nilfs->ns_sem);
+	ctime = nilfs->ns_ctime;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n", (unsigned long long)ctime);
+}
+
+static ssize_t
+nilfs_segctor_last_nongc_write_time_show(struct nilfs_segctor_attr *attr,
+					 struct the_nilfs *nilfs,
+					 char *buf)
+{
+	time_t nongc_ctime;
+
+	down_read(&nilfs->ns_sem);
+	nongc_ctime = nilfs->ns_nongc_ctime;
+	up_read(&nilfs->ns_sem);
+
+	return NILFS_SHOW_TIME(nongc_ctime, buf);
+}
+
+static ssize_t
+nilfs_segctor_last_nongc_write_time_secs_show(struct nilfs_segctor_attr *attr,
+						struct the_nilfs *nilfs,
+						char *buf)
+{
+	time_t nongc_ctime;
+
+	down_read(&nilfs->ns_sem);
+	nongc_ctime = nilfs->ns_nongc_ctime;
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)nongc_ctime);
+}
+
+static ssize_t
+nilfs_segctor_dirty_data_blocks_count_show(struct nilfs_segctor_attr *attr,
+					    struct the_nilfs *nilfs,
+					    char *buf)
+{
+	u32 ndirtyblks;
+
+	down_read(&nilfs->ns_sem);
+	ndirtyblks = atomic_read(&nilfs->ns_ndirtyblks);
+	up_read(&nilfs->ns_sem);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", ndirtyblks);
+}
+
+static const char segctor_readme_str[] =
+	"The segctor group contains attributes that describe\n"
+	"segctor thread activity details.\n\n"
+	"(1) last_pseg_block\n"
+	"\tshow start block number of the latest segment.\n\n"
+	"(2) last_seg_sequence\n"
+	"\tshow sequence value of the latest segment.\n\n"
+	"(3) last_seg_checkpoint\n"
+	"\tshow checkpoint number of the latest segment.\n\n"
+	"(4) current_seg_sequence\n\tshow segment sequence counter.\n\n"
+	"(5) current_last_full_seg\n"
+	"\tshow index number of the latest full segment.\n\n"
+	"(6) next_full_seg\n"
+	"\tshow index number of the full segment index to be used next.\n\n"
+	"(7) next_pseg_offset\n"
+	"\tshow offset of next partial segment in the current full segment.\n\n"
+	"(8) next_checkpoint\n\tshow next checkpoint number.\n\n"
+	"(9) last_seg_write_time\n"
+	"\tshow write time of the last segment in human-readable format.\n\n"
+	"(10) last_seg_write_time_secs\n"
+	"\tshow write time of the last segment in seconds.\n\n"
+	"(11) last_nongc_write_time\n"
+	"\tshow write time of the last segment not for cleaner operation "
+	"in human-readable format.\n\n"
+	"(12) last_nongc_write_time_secs\n"
+	"\tshow write time of the last segment not for cleaner operation "
+	"in seconds.\n\n"
+	"(13) dirty_data_blocks_count\n"
+	"\tshow number of dirty data blocks.\n\n";
+
+static ssize_t
+nilfs_segctor_README_show(struct nilfs_segctor_attr *attr,
+			  struct the_nilfs *nilfs, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, segctor_readme_str);
+}
+
+NILFS_SEGCTOR_RO_ATTR(last_pseg_block);
+NILFS_SEGCTOR_RO_ATTR(last_seg_sequence);
+NILFS_SEGCTOR_RO_ATTR(last_seg_checkpoint);
+NILFS_SEGCTOR_RO_ATTR(current_seg_sequence);
+NILFS_SEGCTOR_RO_ATTR(current_last_full_seg);
+NILFS_SEGCTOR_RO_ATTR(next_full_seg);
+NILFS_SEGCTOR_RO_ATTR(next_pseg_offset);
+NILFS_SEGCTOR_RO_ATTR(next_checkpoint);
+NILFS_SEGCTOR_RO_ATTR(last_seg_write_time);
+NILFS_SEGCTOR_RO_ATTR(last_seg_write_time_secs);
+NILFS_SEGCTOR_RO_ATTR(last_nongc_write_time);
+NILFS_SEGCTOR_RO_ATTR(last_nongc_write_time_secs);
+NILFS_SEGCTOR_RO_ATTR(dirty_data_blocks_count);
+NILFS_SEGCTOR_RO_ATTR(README);
+
+static struct attribute *nilfs_segctor_attrs[] = {
+	NILFS_SEGCTOR_ATTR_LIST(last_pseg_block),
+	NILFS_SEGCTOR_ATTR_LIST(last_seg_sequence),
+	NILFS_SEGCTOR_ATTR_LIST(last_seg_checkpoint),
+	NILFS_SEGCTOR_ATTR_LIST(current_seg_sequence),
+	NILFS_SEGCTOR_ATTR_LIST(current_last_full_seg),
+	NILFS_SEGCTOR_ATTR_LIST(next_full_seg),
+	NILFS_SEGCTOR_ATTR_LIST(next_pseg_offset),
+	NILFS_SEGCTOR_ATTR_LIST(next_checkpoint),
+	NILFS_SEGCTOR_ATTR_LIST(last_seg_write_time),
+	NILFS_SEGCTOR_ATTR_LIST(last_seg_write_time_secs),
+	NILFS_SEGCTOR_ATTR_LIST(last_nongc_write_time),
+	NILFS_SEGCTOR_ATTR_LIST(last_nongc_write_time_secs),
+	NILFS_SEGCTOR_ATTR_LIST(dirty_data_blocks_count),
+	NILFS_SEGCTOR_ATTR_LIST(README),
+	NULL,
+};
+
+NILFS_DEV_INT_GROUP_OPS(segctor, dev);
+NILFS_DEV_INT_GROUP_TYPE(segctor, dev);
+NILFS_DEV_INT_GROUP_FNS(segctor, dev);
+
+/************************************************************************
  *                        NILFS superblock attrs                        *
  ************************************************************************/
 
@@ -406,8 +668,15 @@ int nilfs_sysfs_create_device_group(stru
 	if (err)
 		goto cleanup_dev_kobject;
 
+	err = nilfs_sysfs_create_segctor_group(nilfs);
+	if (err)
+		goto delete_superblock_group;
+
 	return 0;
 
+delete_superblock_group:
+	nilfs_sysfs_delete_superblock_group(nilfs);
+
 cleanup_dev_kobject:
 	kobject_del(&nilfs->ns_dev_kobj);
 
@@ -421,6 +690,7 @@ failed_create_device_group:
 void nilfs_sysfs_delete_device_group(struct the_nilfs *nilfs)
 {
 	nilfs_sysfs_delete_superblock_group(nilfs);
+	nilfs_sysfs_delete_segctor_group(nilfs);
 	kobject_del(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 }
diff -puN fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-segctor-group fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-add-sys-fs-nilfs2-device-segctor-group
+++ a/fs/nilfs2/sysfs.h
@@ -28,11 +28,17 @@
  * struct nilfs_sysfs_dev_subgroups - device subgroup kernel objects
  * @sg_superblock_kobj: /sys/fs/<nilfs>/<device>/superblock
  * @sg_superblock_kobj_unregister: completion state
+ * @sg_segctor_kobj: /sys/fs/<nilfs>/<device>/segctor
+ * @sg_segctor_kobj_unregister: completion state
  */
 struct nilfs_sysfs_dev_subgroups {
 	/* /sys/fs/<nilfs>/<device>/superblock */
 	struct kobject sg_superblock_kobj;
 	struct completion sg_superblock_kobj_unregister;
+
+	/* /sys/fs/<nilfs>/<device>/segctor */
+	struct kobject sg_segctor_kobj;
+	struct completion sg_segctor_kobj_unregister;
 };
 
 #define NILFS_COMMON_ATTR_STRUCT(name) \
@@ -57,6 +63,7 @@ struct nilfs_##name##_attr { \
 
 NILFS_DEV_ATTR_STRUCT(dev);
 NILFS_DEV_ATTR_STRUCT(superblock);
+NILFS_DEV_ATTR_STRUCT(segctor);
 
 #define NILFS_ATTR(type, name, mode, show, store) \
 	static struct nilfs_##type##_attr nilfs_##type##_attr_##name = \
@@ -90,11 +97,20 @@ NILFS_DEV_ATTR_STRUCT(superblock);
 #define NILFS_SUPERBLOCK_RW_ATTR(name) \
 	NILFS_RW_ATTR(superblock, name)
 
+#define NILFS_SEGCTOR_INFO_ATTR(name) \
+	NILFS_INFO_ATTR(segctor, name)
+#define NILFS_SEGCTOR_RO_ATTR(name) \
+	NILFS_RO_ATTR(segctor, name)
+#define NILFS_SEGCTOR_RW_ATTR(name) \
+	NILFS_RW_ATTR(segctor, name)
+
 #define NILFS_FEATURE_ATTR_LIST(name) \
 	(&nilfs_feature_attr_##name.attr)
 #define NILFS_DEV_ATTR_LIST(name) \
 	(&nilfs_dev_attr_##name.attr)
 #define NILFS_SUPERBLOCK_ATTR_LIST(name) \
 	(&nilfs_superblock_attr_##name.attr)
+#define NILFS_SEGCTOR_ATTR_LIST(name) \
+	(&nilfs_segctor_attr_##name.attr)
 
 #endif /* _NILFS_SYSFS_H */
_

Patches currently in -mm which might be from Vyacheslav.Dubeyko@hgst.com are

origin.patch

