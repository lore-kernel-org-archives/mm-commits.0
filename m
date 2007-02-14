From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:52:18 -0800
Message-ID: <200702141852.l1EIqIJN005708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39644 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451AbXBNTEG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 14:04:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: record when sb_writer_count elevated for inode
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: record when sb_writer_count elevated for inode
From: Dave Hansen <hansendc@us.ibm.com>

There are a number of filesystems that do iput()s without first having messed
with i_nlink.  In order to keep from accidentally decrementing the superblock
writer count for these, we record when the count is bumped up, so that we can
properly balance it.

I first tried to do this by assuming that, for each dec_nlink() to zero, there
was exactly one call to iput_final().  But, there are a number of cases where
this isn't true, especially in error handling code.  Even if all of the
filesystems were fixed up, it would be simple to reintroduce new bugs
imbalancing the mnt writer count.  This patch trades that possibility for the
chance that we will miss a i_nlink--, and not bump the sb writer count.

I like the idea screwing up writing out a single inode better than screwing up
a global superblock count imbalance that will affect all inodes on the
superblock.

Also, since this is the first non-trivial use of the inc/drop_nlink()
functions, add some kernel docs for them.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |    7 +++++
 fs/libfs.c         |    1 
 include/linux/fs.h |   58 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff -puN fs/inode.c~r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode fs/inode.c
--- a/fs/inode.c~r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode
+++ a/fs/inode.c
@@ -1097,10 +1097,17 @@ static inline void iput_final(struct ino
 {
 	const struct super_operations *op = inode->i_sb->s_op;
 	void (*drop)(struct inode *) = generic_drop_inode;
+	int must_drop_sb_write = (inode->i_state & I_AWAITING_FINAL_IPUT);
+	struct super_block *sb = inode->i_sb;
 
 	if (op && op->drop_inode)
 		drop = op->drop_inode;
 	drop(inode);
+	if (must_drop_sb_write) {
+		spin_lock(&sb->s_mnt_writers_lock);
+		sb->s_writers--;
+		spin_unlock(&sb->s_mnt_writers_lock);
+	}
 }
 
 /**
diff -puN fs/libfs.c~r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode fs/libfs.c
--- a/fs/libfs.c~r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode
+++ a/fs/libfs.c
@@ -388,6 +388,7 @@ int simple_fill_super(struct super_block
 	 * because the root inode is 1, the files array must not contain an
 	 * entry at index 1
 	 */
+	inode->i_state |= I_AWAITING_FINAL_IPUT;
 	inode->i_ino = 1;
 	inode->i_mode = S_IFDIR | 0755;
 	inode->i_uid = inode->i_gid = 0;
diff -puN include/linux/fs.h~r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode include/linux/fs.h
--- a/include/linux/fs.h~r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode
+++ a/include/linux/fs.h
@@ -1228,6 +1228,7 @@ struct super_operations {
 #define I_CLEAR			32
 #define I_NEW			64
 #define I_WILL_FREE		128
+#define I_AWAITING_FINAL_IPUT		256
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 
@@ -1242,6 +1243,14 @@ static inline void mark_inode_dirty_sync
 	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 }
 
+/**
+ * inc_nlink - directly increment an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  Currently,
+ * it is only here for parity with dec_nlink().
+ */
 static inline void inc_nlink(struct inode *inode)
 {
 	inode->i_nlink++;
@@ -1253,14 +1262,63 @@ static inline void inode_inc_link_count(
 	mark_inode_dirty(inode);
 }
 
+/**
+ * check_nlink - check an inode's status after direct
+ * 		 i_nlink modification.
+ * @inode: inode
+ *
+ * Some filesystems can not make simple incremental changes
+ * to i_nlink, most notably clustered ones.  They must do
+ * direct manipulation of i_nlink.  This function must be
+ * called after such modifications are complete to make
+ * sure that the VFS knows that the inode is going to go
+ * away.
+ */
+static inline void check_nlink(struct inode *inode)
+{
+	if (inode->i_nlink)
+		return;
+
+	inode->i_state |= I_AWAITING_FINAL_IPUT;
+	spin_lock(&inode->i_sb->s_mnt_writers_lock);
+	inode->i_sb->s_writers++;
+	spin_unlock(&inode->i_sb->s_mnt_writers_lock);
+}
+
+/**
+ * drop_nlink - directly drop an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  In cases
+ * where we are attempting to track writes to the
+ * filesystem, a decrement to zero means an imminent
+ * write when the file is truncated and actually unlinked
+ * on the filesystem.
+ */
 static inline void drop_nlink(struct inode *inode)
 {
 	inode->i_nlink--;
+	check_nlink(inode);
 }
 
+/**
+ * clear_nlink - directly zero an inode's link count
+ * @inode: inode
+ *
+ * This is a low-level filesystem helper to replace any
+ * direct filesystem manipulation of i_nlink.  See
+ * drop_nlink() for why we care about i_nlink hitting zero.
+ *
+ * Note that we could do the i_state flag directly in here,
+ * but we call check_nlink() to keep the number of places
+ * where the flag is set to exactly one.  The compiler
+ * should get rid of the superfluous i_nlink check.
+ */
 static inline void clear_nlink(struct inode *inode)
 {
 	inode->i_nlink = 0;
+	check_nlink(inode);
 }
 
 static inline void inode_dec_link_count(struct inode *inode)
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-record-when-sb_writer_count-elevated-for-inode.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-gfs-check-nlink-count.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
