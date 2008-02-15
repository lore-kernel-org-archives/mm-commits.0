From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:31:36 -0800
Message-ID: <200802150531.m1F5Va6t021807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbYBOFnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:43:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     r-o-bind-mounts: honor r/w changes at do_remount() time
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r-o-bind-mounts: honor r/w changes at do_remount() time
From: Dave Hansen <haveblue@us.ibm.com>

Originally from: Herbert Poetzl <herbert@13thfloor.at>

This is the core of the read-only bind mount patch set.

Note that this does _not_ add a "ro" option directly to the bind mount
operation.  If you require such a mount, you must first do the bind, then
follow it up with a 'mount -o remount,ro' operation.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   46 +++++++++++++++++++++++++++++++++-------
 include/linux/mount.h |    1 
 2 files changed, 40 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time
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
 
@@ -294,7 +298,7 @@ void mnt_drop_write(struct vfsmount *mnt
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
-int mnt_make_readonly(struct vfsmount *mnt)
+static int mnt_make_readonly(struct vfsmount *mnt)
 {
 	int ret = 0;
 
@@ -307,15 +311,21 @@ int mnt_make_readonly(struct vfsmount *m
 		goto out;
 	}
 	/*
-	 * actually set mount's r/o flag here to make
-	 * __mnt_is_readonly() true, which keeps anyone
-	 * from doing a successful mnt_want_write().
+	 * nobody can do a successful mnt_want_write() with all
+	 * of the counts in MNT_DENIED_WRITE and the locks held.
 	 */
+	if (!ret)
+		mnt->mnt_flags |= MNT_READONLY;
 out:
 	mnt_unlock_cpus();
 	return ret;
 }
 
+static void __mnt_unmake_readonly(struct vfsmount *mnt)
+{
+	mnt->mnt_flags &= ~MNT_READONLY;
+}
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -663,7 +673,7 @@ static int show_vfsmnt(struct seq_file *
 		seq_putc(m, '.');
 		mangle(m, mnt->mnt_sb->s_subtype);
 	}
-	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
+	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
@@ -1254,6 +1264,23 @@ out:
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
@@ -1276,7 +1303,10 @@ static noinline int do_remount(struct na
 		return -EINVAL;
 
 	down_write(&sb->s_umount);
-	err = do_remount_sb(sb, flags, data, 0);
+	if (flags & MS_BIND)
+		err = change_mount_flags(nd->mnt, flags);
+	else
+		err = do_remount_sb(sb, flags, data, 0);
 	if (!err)
 		nd->mnt->mnt_flags = mnt_flags;
 	up_write(&sb->s_umount);
@@ -1724,6 +1754,8 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
diff -puN include/linux/mount.h~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time include/linux/mount.h
--- a/include/linux/mount.h~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time
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
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
