From: akpm@linux-foundation.org
Subject: + vfs-protect-remounting-superblock-read-only.patch added to -mm tree
Date: Tue, 18 Jan 2011 15:10:07 -0800
Message-ID: <201101182310.p0INA721011260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751714Ab1ARXLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 18:11:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     vfs: protect remounting superblock read-only
has been added to the -mm tree.  Its filename is
     vfs-protect-remounting-superblock-read-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: protect remounting superblock read-only
From: Miklos Szeredi <mszeredi@suse.cz>

Currently remouting superblock read-only is racy in a major way.

With the per mount read-only infrastructure it is now possible to prevent
most races, which this patch attempts.

Before starting the remount read-only, iterate through all mounts
belonging to the superblock and if none of them have any pending writes,
set sb->s_readonly_remount.  This indicates that remount is in progress
and no further write requests are allowed.  If the remount succeeds set
MS_RDONLY and reset s_readonly_remount.

If the remounting is unsuccessful just reset s_readonly_remount.  This can
result in transient EROFS errors, despite the fact the remount failed. 
Unfortunately hodling off writes is difficult as remount itself may touch
the filesystem (e.g.  through load_nls()) which would deadlock.

Small races still remain because delayed writes due to nlink going to zero
but inode still having a reference are not dealt with by this patch.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/internal.h      |    1 +
 fs/namespace.c     |   40 +++++++++++++++++++++++++++++++++++++++-
 fs/super.c         |   22 ++++++++++++++++++----
 include/linux/fs.h |    3 +++
 4 files changed, 61 insertions(+), 5 deletions(-)

diff -puN fs/internal.h~vfs-protect-remounting-superblock-read-only fs/internal.h
--- a/fs/internal.h~vfs-protect-remounting-superblock-read-only
+++ a/fs/internal.h
@@ -74,6 +74,7 @@ extern int finish_automount(struct vfsmo
 
 extern void mnt_make_longterm(struct vfsmount *);
 extern void mnt_make_shortterm(struct vfsmount *);
+extern int sb_prepare_remount_readonly(struct super_block *);
 
 extern void __init mnt_init(void);
 
diff -puN fs/namespace.c~vfs-protect-remounting-superblock-read-only fs/namespace.c
--- a/fs/namespace.c~vfs-protect-remounting-superblock-read-only
+++ a/fs/namespace.c
@@ -311,6 +311,15 @@ static unsigned int mnt_get_writers(stru
 #endif
 }
 
+static int mnt_is_readonly(struct vfsmount *mnt)
+{
+	if (mnt->mnt_sb->s_readonly_remount)
+		return 1;
+	/* Order wrt setting s_flags/s_readonly_remount in do_remount() */
+	smp_rmb();
+	return __mnt_is_readonly(mnt);
+}
+
 /*
  * Most r/o checks on a fs are for operations that take
  * discrete amounts of time, like a write() or unlink().
@@ -349,7 +358,7 @@ int mnt_want_write(struct vfsmount *mnt)
 	 * MNT_WRITE_HOLD is cleared.
 	 */
 	smp_rmb();
-	if (__mnt_is_readonly(mnt)) {
+	if (mnt_is_readonly(mnt)) {
 		mnt_dec_writers(mnt);
 		ret = -EROFS;
 		goto out;
@@ -466,6 +475,35 @@ static void __mnt_unmake_readonly(struct
 	br_write_unlock(vfsmount_lock);
 }
 
+int sb_prepare_remount_readonly(struct super_block *sb)
+{
+	struct vfsmount *mnt;
+	int err = 0;
+
+	br_write_lock(vfsmount_lock);
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (!(mnt->mnt_flags & MNT_READONLY)) {
+			mnt->mnt_flags |= MNT_WRITE_HOLD;
+			smp_mb();
+			if (mnt_get_writers(mnt) > 0) {
+				err = -EBUSY;
+				break;
+			}
+		}
+	}
+	if (!err) {
+		sb->s_readonly_remount = 1;
+		smp_wmb();
+	}
+	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
+		if (mnt->mnt_flags & MNT_WRITE_HOLD)
+			mnt->mnt_flags &= ~MNT_WRITE_HOLD;
+	}
+	br_write_unlock(vfsmount_lock);
+
+	return err;
+}
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
diff -puN fs/super.c~vfs-protect-remounting-superblock-read-only fs/super.c
--- a/fs/super.c~vfs-protect-remounting-superblock-read-only
+++ a/fs/super.c
@@ -577,19 +577,29 @@ int do_remount_sb(struct super_block *sb
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if (remount_ro) {
-		if (force)
+		if (force) {
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
-			return -EBUSY;
+		} else {
+			retval = sb_prepare_remount_readonly(sb);
+			if (retval)
+				return retval;
+
+			retval = -EBUSY;
+			if (!fs_may_remount_ro(sb))
+				goto cancel_readonly;
+		}
 	}
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
 		/* If forced remount, go ahead despite any errors */
 		if (retval && !force)
-			return retval;
+			goto cancel_readonly;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
+	/* Needs to be ordered wrt mnt_is_readonly() */
+	smp_wmb();
+	sb->s_readonly_remount = 0;
 
 	/*
 	 * Some filesystems modify their metadata via some other path than the
@@ -602,6 +612,10 @@ int do_remount_sb(struct super_block *sb
 	if (remount_ro && sb->s_bdev)
 		invalidate_bdev(sb->s_bdev);
 	return 0;
+
+cancel_readonly:
+	sb->s_readonly_remount = 0;
+	return retval;
 }
 
 static void do_emergency_remount(struct work_struct *work)
diff -puN include/linux/fs.h~vfs-protect-remounting-superblock-read-only include/linux/fs.h
--- a/include/linux/fs.h~vfs-protect-remounting-superblock-read-only
+++ a/include/linux/fs.h
@@ -1432,6 +1432,9 @@ struct super_block {
 	 * Saved pool identifier for cleancache (-1 means none)
 	 */
 	int cleancache_poolid;
+
+	/* Being remounted read-only */
+	int s_readonly_remount;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
vfs-ignore-error-on-forced-remount.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch

