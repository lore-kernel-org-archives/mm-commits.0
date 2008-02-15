From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:30 -0800
Message-ID: <200802152249.m1FMnV3O028211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760305AbYBOW6s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:58:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org, herbert@13thfloor.at, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: honor mount writer counts at remount
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: honor mount writer counts at remount
From: Dave Hansen <haveblue@us.ibm.com>

Originally from: Herbert Poetzl <herbert@13thfloor.at>

This is the core of the read-only bind mount patch set.

Note that this does _not_ add a "ro" option directly to the bind mount
operation.  If you require such a mount, you must first do the bind, then
follow it up with a 'mount -o remount,ro' operation:

If you wish to have a r/o bind mount of /foo on bar:

	mount --bind /foo /bar
	mount -o remount,ro /bar

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   50 ++++++++++++++++++++++++++++++++++------
 include/linux/mount.h |    1 
 2 files changed, 44 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-honor-mount-writer-counts-at-remount fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-honor-mount-writer-counts-at-remount
+++ a/fs/namespace.c
@@ -105,7 +105,11 @@ struct vfsmount *alloc_vfsmnt(const char
  */
 int __mnt_is_readonly(struct vfsmount *mnt)
 {
-	return (mnt->mnt_sb->s_flags & MS_RDONLY);
+	if (mnt->mnt_flags & MNT_READONLY)
+		return 1;
+	if (mnt->mnt_sb->s_flags & MS_RDONLY)
+		return 1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
@@ -299,7 +303,7 @@ void mnt_drop_write(struct vfsmount *mnt
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
-int mnt_make_readonly(struct vfsmount *mnt)
+static int mnt_make_readonly(struct vfsmount *mnt)
 {
 	int ret = 0;
 
@@ -312,15 +316,25 @@ int mnt_make_readonly(struct vfsmount *m
 		goto out;
 	}
 	/*
-	 * actually set mount's r/o flag here to make
-	 * __mnt_is_readonly() true, which keeps anyone
-	 * from doing a successful mnt_want_write().
+	 * nobody can do a successful mnt_want_write() with all
+	 * of the counts in MNT_DENIED_WRITE and the locks held.
 	 */
+	spin_lock(&vfsmount_lock);
+	if (!ret)
+		mnt->mnt_flags |= MNT_READONLY;
+	spin_unlock(&vfsmount_lock);
 out:
 	unlock_mnt_writers();
 	return ret;
 }
 
+static void __mnt_unmake_readonly(struct vfsmount *mnt)
+{
+	spin_lock(&vfsmount_lock);
+	mnt->mnt_flags &= ~MNT_READONLY;
+	spin_unlock(&vfsmount_lock);
+}
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -683,7 +697,7 @@ static int show_vfsmnt(struct seq_file *
 		seq_putc(m, '.');
 		mangle(m, mnt->mnt_sb->s_subtype);
 	}
-	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
+	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
@@ -1277,6 +1291,23 @@ out:
 	return err;
 }
 
+static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
+{
+	int error = 0;
+	int readonly_request = 0;
+
+	if (ms_flags & MS_RDONLY)
+		readonly_request = 1;
+	if (readonly_request == __mnt_is_readonly(mnt))
+		return 0;
+
+	if (readonly_request)
+		error = mnt_make_readonly(mnt);
+	else
+		__mnt_unmake_readonly(mnt);
+	return error;
+}
+
 /*
  * change filesystem flags. dir should be a physical root of filesystem.
  * If you've mounted a non-root directory somewhere and want to do remount
@@ -1299,7 +1330,10 @@ static noinline int do_remount(struct na
 		return -EINVAL;
 
 	down_write(&sb->s_umount);
-	err = do_remount_sb(sb, flags, data, 0);
+	if (flags & MS_BIND)
+		err = change_mount_flags(nd->path.mnt, flags);
+	else
+		err = do_remount_sb(sb, flags, data, 0);
 	if (!err)
 		nd->path.mnt->mnt_flags = mnt_flags;
 	up_write(&sb->s_umount);
@@ -1752,6 +1786,8 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
diff -puN include/linux/mount.h~r-o-bind-mounts-honor-mount-writer-counts-at-remount include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-honor-mount-writer-counts-at-remount
+++ a/include/linux/mount.h
@@ -29,6 +29,7 @@ struct mnt_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_READONLY	0x40	/* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
