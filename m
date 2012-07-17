From: akpm@linux-foundation.org
Subject: [merged] hfs-get-rid-of-hfs_sync_super.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:35 -0700
Message-ID: <20120717200435.C0BFE1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:33881 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab2GQUEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:36 -0400
Received: by yhl10 with SMTP id 10so82002yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: get rid of hfs_sync_super
has been removed from the -mm tree.  Its filename was
     hfs-get-rid-of-hfs_sync_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfs: get rid of hfs_sync_super

Make hfs stop using the VFS '->write_super()' method along with the
's_dirt' superblock flag, because they are on their way out.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds
and writes out all dirty superblocks using the '->write_super()'
call-back.  But the problem with this thread is that it wastes power by
waking up the system every 5 seconds, even if there are no diry
superblocks, or there are no client file-systems which would need this
(e.g., btrfs does not use '->write_super()').  So we want to kill it
completely and thus, we need to make file-systems to stop using the
'->write_super()' VFS service, and then remove it together with the kernel
thread.

Tested using fsstress from the LTP project.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/extent.c |    2 -
 fs/hfs/hfs_fs.h |    9 +++++-
 fs/hfs/inode.c  |   11 ++-----
 fs/hfs/mdb.c    |    2 +
 fs/hfs/super.c  |   65 ++++++++++++++++++++++++----------------------
 5 files changed, 50 insertions(+), 39 deletions(-)

diff -puN fs/hfs/extent.c~hfs-get-rid-of-hfs_sync_super fs/hfs/extent.c
--- a/fs/hfs/extent.c~hfs-get-rid-of-hfs_sync_super
+++ a/fs/hfs/extent.c
@@ -432,7 +432,7 @@ out:
 		if (inode->i_ino < HFS_FIRSTUSER_CNID)
 			set_bit(HFS_FLG_ALT_MDB_DIRTY, &HFS_SB(sb)->flags);
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt = 1;
+		hfs_mark_mdb_dirty(sb);
 	}
 	return res;
 
diff -puN fs/hfs/hfs_fs.h~hfs-get-rid-of-hfs_sync_super fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~hfs-get-rid-of-hfs_sync_super
+++ a/fs/hfs/hfs_fs.h
@@ -14,6 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
+#include <linux/workqueue.h>
 
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
@@ -143,6 +144,9 @@ struct hfs_sb_info {
 	u16 blockoffset;
 	int fs_div;
 	struct super_block *sb;
+	int work_queued;		/* non-zero delayed work is queued */
+	struct delayed_work mdb_work;	/* MDB flush delayed work */
+	spinlock_t work_lock;		/* protects mdb_work and work_queued */
 };
 
 #define HFS_FLG_BITMAP_DIRTY	0
@@ -222,6 +226,9 @@ extern int hfs_compare_dentry(const stru
 extern void hfs_asc2mac(struct super_block *, struct hfs_name *, struct qstr *);
 extern int hfs_mac2asc(struct super_block *, char *, const struct hfs_name *);
 
+/* super.c */
+extern void hfs_mark_mdb_dirty(struct super_block *sb);
+
 extern struct timezone sys_tz;
 
 /*
@@ -249,7 +256,7 @@ static inline const char *hfs_mdb_name(s
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	hfs_mark_mdb_dirty(sb);
 }
 
 #define sb_bread512(sb, sec, data) ({			\
diff -puN fs/hfs/inode.c~hfs-get-rid-of-hfs_sync_super fs/hfs/inode.c
--- a/fs/hfs/inode.c~hfs-get-rid-of-hfs_sync_super
+++ a/fs/hfs/inode.c
@@ -220,7 +220,7 @@ struct inode *hfs_new_inode(struct inode
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	hfs_mark_mdb_dirty(sb);
 
 	return inode;
 }
@@ -235,7 +235,7 @@ void hfs_delete_inode(struct inode *inod
 		if (HFS_I(inode)->cat_key.ParID == cpu_to_be32(HFS_ROOT_CNID))
 			HFS_SB(sb)->root_dirs--;
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt = 1;
+		hfs_mark_mdb_dirty(sb);
 		return;
 	}
 	HFS_SB(sb)->file_count--;
@@ -248,7 +248,7 @@ void hfs_delete_inode(struct inode *inod
 		}
 	}
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt = 1;
+	hfs_mark_mdb_dirty(sb);
 }
 
 void hfs_inode_read_fork(struct inode *inode, struct hfs_extent *ext,
@@ -644,10 +644,7 @@ static int hfs_file_fsync(struct file *f
 
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
-	if (sb->s_dirt) {
-		sb->s_dirt = 0;
-		hfs_mdb_commit(sb);
-	}
+	flush_delayed_work_sync(&HFS_SB(sb)->mdb_work);
 	/* .. finally sync the buffers to disk */
 	err = sync_blockdev(sb->s_bdev);
 	if (!ret)
diff -puN fs/hfs/mdb.c~hfs-get-rid-of-hfs_sync_super fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-get-rid-of-hfs_sync_super
+++ a/fs/hfs/mdb.c
@@ -263,6 +263,8 @@ void hfs_mdb_commit(struct super_block *
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
+	cancel_delayed_work(&HFS_SB(sb)->mdb_work);
+
 	lock_buffer(HFS_SB(sb)->mdb_bh);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
diff -puN fs/hfs/super.c~hfs-get-rid-of-hfs_sync_super fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-get-rid-of-hfs_sync_super
+++ a/fs/hfs/super.c
@@ -29,38 +29,9 @@ static struct kmem_cache *hfs_inode_cach
 
 MODULE_LICENSE("GPL");
 
-/*
- * hfs_write_super()
- *
- * Description:
- *   This function is called by the VFS only. When the filesystem
- *   is mounted r/w it updates the MDB on disk.
- * Input Variable(s):
- *   struct super_block *sb: Pointer to the hfs superblock
- * Output Variable(s):
- *   NONE
- * Returns:
- *   void
- * Preconditions:
- *   'sb' points to a "valid" (struct super_block).
- * Postconditions:
- *   The MDB is marked 'unsuccessfully unmounted' by clearing bit 8 of drAtrb
- *   (hfs_put_super() must set this flag!). Some MDB fields are updated
- *   and the MDB buffer is written to disk by calling hfs_mdb_commit().
- */
-static void hfs_write_super(struct super_block *sb)
-{
-	sb->s_dirt = 0;
-
-	/* sync everything to the buffers */
-	hfs_mdb_commit(sb);
-}
-
 static int hfs_sync_fs(struct super_block *sb, int wait)
 {
 	hfs_mdb_commit(sb);
-	sb->s_dirt = 0;
-
 	return 0;
 }
 
@@ -73,11 +44,44 @@ static int hfs_sync_fs(struct super_bloc
  */
 static void hfs_put_super(struct super_block *sb)
 {
+	cancel_delayed_work_sync(&HFS_SB(sb)->mdb_work);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
 	hfs_mdb_put(sb);
 }
 
+static void flush_mdb(struct work_struct *work)
+{
+	struct hfs_sb_info *sbi;
+	struct super_block *sb;
+
+	sbi = container_of(work, struct hfs_sb_info, mdb_work.work);
+	sb = sbi->sb;
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->work_lock);
+
+	hfs_mdb_commit(sb);
+}
+
+void hfs_mark_mdb_dirty(struct super_block *sb)
+{
+	struct hfs_sb_info *sbi = HFS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+	       return;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+	       queue_delayed_work(system_long_wq, &sbi->mdb_work, delay);
+	       sbi->work_queued = 1;
+	}
+	spin_unlock(&sbi->work_lock);
+}
+
 /*
  * hfs_statfs()
  *
@@ -177,7 +181,6 @@ static const struct super_operations hfs
 	.write_inode	= hfs_write_inode,
 	.evict_inode	= hfs_evict_inode,
 	.put_super	= hfs_put_super,
-	.write_super	= hfs_write_super,
 	.sync_fs	= hfs_sync_fs,
 	.statfs		= hfs_statfs,
 	.remount_fs     = hfs_remount,
@@ -382,6 +385,8 @@ static int hfs_fill_super(struct super_b
 
 	sbi->sb = sb;
 	sb->s_fs_info = sbi;
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->mdb_work, flush_mdb);
 
 	res = -EINVAL;
 	if (!parse_options((char *)data, sbi)) {
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

