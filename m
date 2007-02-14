From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-add-vfsmount-writer-counts.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:52:15 -0800
Message-ID: <200702141852.l1EIqFTH005704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447AbXBNSwt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:52:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: add vfsmount writer counts
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-add-vfsmount-writer-counts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: r/o bind mounts: add vfsmount writer counts
From: Dave Hansen <hansendc@us.ibm.com>

This patch actually adds the mount and superblock writer counts, and the
mnt_want/drop_write() functions that use them.

Before these can become useful, we must first cover each place in the VFS
where writes are performed with a want/drop pair.  When that is complete, we
can actually introduce code that will safely check the counts before allowing
r/w<->r/o transitions to occur.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   53 ++++++++++++++++++++++++++++++++++++++++
 fs/super.c            |   18 ++++++++++---
 include/linux/fs.h    |    2 +
 include/linux/mount.h |   28 ++++++++++++++++++---
 4 files changed, 94 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-add-vfsmount-writer-counts fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-add-vfsmount-writer-counts
+++ a/fs/namespace.c
@@ -56,6 +56,7 @@ struct vfsmount *alloc_vfsmnt(const char
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
 	if (mnt) {
 		atomic_set(&mnt->mnt_count, 1);
+		mnt->mnt_writers = 0;
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
 		INIT_LIST_HEAD(&mnt->mnt_mounts);
@@ -76,6 +77,56 @@ struct vfsmount *alloc_vfsmnt(const char
 	return mnt;
 }
 
+int mnt_make_readonly(struct vfsmount *mnt)
+{
+	int ret = 0;
+
+	WARN_ON(__mnt_is_readonly(mnt));
+
+	/*
+	 * This flag set is actually redundant with what
+	 * happens in do_remount(), but since we do this
+	 * under the lock, anyone attempting to get a write
+	 * on it after this will fail.
+	 */
+	spin_lock(&mnt->mnt_sb->s_mnt_writers_lock);
+	if (!mnt->mnt_writers)
+		mnt->mnt_flags |= MNT_READONLY;
+	else
+		ret = -EBUSY;
+	spin_unlock(&mnt->mnt_sb->s_mnt_writers_lock);
+	return ret;
+}
+
+int mnt_want_write(struct vfsmount *mnt)
+{
+	int ret = 0;
+
+	spin_lock(&mnt->mnt_sb->s_mnt_writers_lock);
+	if (mnt->mnt_writers)
+		goto out;
+
+	if (__mnt_is_readonly(mnt)) {
+		ret = -EROFS;
+		goto out;
+	}
+	mnt->mnt_sb->s_writers++;
+	mnt->mnt_writers++;
+out:
+	spin_unlock(&mnt->mnt_sb->s_mnt_writers_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mnt_want_write);
+
+void mnt_drop_write(struct vfsmount *mnt)
+{
+	spin_lock(&mnt->mnt_sb->s_mnt_writers_lock);
+	mnt->mnt_sb->s_writers--;
+	mnt->mnt_writers--;
+	spin_unlock(&mnt->mnt_sb->s_mnt_writers_lock);
+}
+EXPORT_SYMBOL_GPL(mnt_drop_write);
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -1395,6 +1446,8 @@ long do_mount(char *dev_name, char *dir_
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
 	/* Separate the per-mountpoint flags */
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
 	if (flags & MS_NOSUID)
 		mnt_flags |= MNT_NOSUID;
 	if (flags & MS_NODEV)
diff -puN fs/super.c~r-o-bind-mounts-add-vfsmount-writer-counts fs/super.c
--- a/fs/super.c~r-o-bind-mounts-add-vfsmount-writer-counts
+++ a/fs/super.c
@@ -93,6 +93,8 @@ static struct super_block *alloc_super(s
 		s->s_qcop = sb_quotactl_ops;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
+		s->s_writers = 0;
+		spin_lock_init(&s->s_mnt_writers_lock);
 	}
 out:
 	return s;
@@ -576,6 +578,11 @@ static void mark_files_ro(struct super_b
 	file_list_unlock();
 }
 
+static int sb_remount_ro(struct super_block *sb)
+{
+	return fs_may_remount_ro(sb);
+}
+
 /**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
@@ -587,7 +594,8 @@ static void mark_files_ro(struct super_b
  */
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
-	int retval;
+	int retval = 0;
+	int sb_started_ro = (sb->s_flags & MS_RDONLY);
 	
 #ifdef CONFIG_BLOCK
 	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
@@ -600,11 +608,13 @@ int do_remount_sb(struct super_block *sb
 
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
-	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
+	if ((flags & MS_RDONLY) && !sb_started_ro) {
 		if (force)
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
-			return -EBUSY;
+		else
+			retval = sb_remount_ro(sb);
+		if (retval)
+			return retval;
 	}
 
 	if (sb->s_op->remount_fs) {
diff -puN include/linux/fs.h~r-o-bind-mounts-add-vfsmount-writer-counts include/linux/fs.h
--- a/include/linux/fs.h~r-o-bind-mounts-add-vfsmount-writer-counts
+++ a/include/linux/fs.h
@@ -970,6 +970,8 @@ struct super_block {
 	struct list_head	s_io;		/* parked for writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
+	int			s_writers;	/* number of files open for write */
+	spinlock_t		s_mnt_writers_lock; /* taken when mounts change rw state */
 
 	struct block_device	*s_bdev;
 	struct list_head	s_instances;
diff -puN include/linux/mount.h~r-o-bind-mounts-add-vfsmount-writer-counts include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-add-vfsmount-writer-counts
+++ a/include/linux/mount.h
@@ -28,6 +28,7 @@ struct mnt_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_READONLY	0x40 /* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
 
@@ -54,12 +55,14 @@ struct vfsmount {
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	/*
-	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
-	 * to let these frequently modified fields in a separate cache line
-	 * (so that reads of mnt_flags wont ping-pong on SMP machines)
+	 * We put mnt_count, mnt_expiry_mark, and mnt_writers at the end of
+	 * struct vfsmount to let these frequently modified fields in a
+	 * separate cache line (so that reads of mnt_flags wont ping-pong
+	 * on SMP machines)
 	 */
 	atomic_t mnt_count;
 	int mnt_expiry_mark;		/* true if marked for expiry */
+	int mnt_writers;		/* nr files open for write */
 	int mnt_pinned;
 };
 
@@ -69,7 +72,26 @@ static inline struct vfsmount *mntget(st
 		atomic_inc(&mnt->mnt_count);
 	return mnt;
 }
+/*
+ * This is temporary for now.  We also don't want to check
+ * the SB in because it is already checked in other
+ * code paths.  We'll have a better way to do this in
+ * the end of this series
+ */
+static inline int __mnt_is_readonly(struct vfsmount *mnt)
+{
+	return mnt->mnt_flags & MNT_READONLY;
+}
+
+static inline void __mnt_unmake_readonly(struct vfsmount *mnt)
+{
+	WARN_ON(!__mnt_is_readonly(mnt));
+	mnt->mnt_flags &= ~MNT_READONLY;
+}
 
+extern int mnt_make_readonly(struct vfsmount *mnt);
+extern int mnt_want_write(struct vfsmount *mnt);
+extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-add-vfsmount-writer-counts.patch
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
