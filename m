From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:13:02 -0700
Message-ID: <57a2342e.9o3yLm1dBzFgjboo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757759AbcHCSNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: embed a back pointer to super block instance in nilfs object
has been removed from the -mm tree.  Its filename was
     nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: embed a back pointer to super block instance in nilfs object

Insert a back pointer to super block instance in nilfs object so that
functions of nilfs2 easily refer to the super block instance.  This
simplifies replacement of printk() in the successive change.

Link: http://lkml.kernel.org/r/1464875891-5443-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c     |    2 +-
 fs/nilfs2/the_nilfs.c |    7 ++++---
 fs/nilfs2/the_nilfs.h |    4 +++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object
+++ a/fs/nilfs2/super.c
@@ -1076,7 +1076,7 @@ nilfs_fill_super(struct super_block *sb,
 	__u64 cno;
 	int err;
 
-	nilfs = alloc_nilfs(sb->s_bdev);
+	nilfs = alloc_nilfs(sb);
 	if (!nilfs)
 		return -ENOMEM;
 
diff -puN fs/nilfs2/the_nilfs.c~nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object fs/nilfs2/the_nilfs.c
--- a/fs/nilfs2/the_nilfs.c~nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object
+++ a/fs/nilfs2/the_nilfs.c
@@ -56,12 +56,12 @@ void nilfs_set_last_segment(struct the_n
 
 /**
  * alloc_nilfs - allocate a nilfs object
- * @bdev: block device to which the_nilfs is related
+ * @sb: super block instance
  *
  * Return Value: On success, pointer to the_nilfs is returned.
  * On error, NULL is returned.
  */
-struct the_nilfs *alloc_nilfs(struct block_device *bdev)
+struct the_nilfs *alloc_nilfs(struct super_block *sb)
 {
 	struct the_nilfs *nilfs;
 
@@ -69,7 +69,8 @@ struct the_nilfs *alloc_nilfs(struct blo
 	if (!nilfs)
 		return NULL;
 
-	nilfs->ns_bdev = bdev;
+	nilfs->ns_sb = sb;
+	nilfs->ns_bdev = sb->s_bdev;
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
 	mutex_init(&nilfs->ns_snapshot_mount_mutex);
diff -puN fs/nilfs2/the_nilfs.h~nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-embed-a-back-pointer-to-super-block-instance-in-nilfs-object
+++ a/fs/nilfs2/the_nilfs.h
@@ -43,6 +43,7 @@ enum {
  * struct the_nilfs - struct to supervise multiple nilfs mount points
  * @ns_flags: flags
  * @ns_flushed_device: flag indicating if all volatile data was flushed
+ * @ns_sb: back pointer to super block instance
  * @ns_bdev: block device
  * @ns_sem: semaphore for shared states
  * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
@@ -102,6 +103,7 @@ struct the_nilfs {
 	unsigned long		ns_flags;
 	int			ns_flushed_device;
 
+	struct super_block     *ns_sb;
 	struct block_device    *ns_bdev;
 	struct rw_semaphore	ns_sem;
 	struct mutex		ns_snapshot_mount_mutex;
@@ -281,7 +283,7 @@ static inline int nilfs_sb_will_flip(str
 }
 
 void nilfs_set_last_segment(struct the_nilfs *, sector_t, u64, __u64);
-struct the_nilfs *alloc_nilfs(struct block_device *bdev);
+struct the_nilfs *alloc_nilfs(struct super_block *sb);
 void destroy_nilfs(struct the_nilfs *nilfs);
 int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data);
 int load_nilfs(struct the_nilfs *nilfs, struct super_block *sb);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


