From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:13:26 -0800
Message-ID: <200702130513.l1D5DQEP022337@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161042AbXBMFRY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, herbert@13thfloor.at, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: honor r/w changes at do_remount() time
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: honor r/w changes at do_remount() time
From: Dave Hansen <hansendc@us.ibm.com>

Originally from: Herbert Poetzl <herbert@13thfloor.at>

This is the core of the read-only bind mount patch set.

Note that this does _not_ add a "ro" option directly to the bind mount
operation.  If you require such a mount, you must first do the bind, then
follow it up with a 'mount -o remount,ro' operation.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   24 ++++++++++++++++++++++--
 fs/open.c      |    2 +-
 2 files changed, 23 insertions(+), 3 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time
+++ a/fs/namespace.c
@@ -428,7 +428,7 @@ static int show_vfsmnt(struct seq_file *
 	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
 	seq_putc(m, ' ');
 	mangle(m, mnt->mnt_sb->s_type->name);
-	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
+	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
@@ -997,6 +997,23 @@ out:
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
@@ -1018,7 +1035,10 @@ static int do_remount(struct nameidata *
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
diff -puN fs/open.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time fs/open.c
--- a/fs/open.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time
+++ a/fs/open.c
@@ -401,7 +401,7 @@ asmlinkage long sys_faccessat(int dfd, c
 	   special_file(nd.dentry->d_inode->i_mode))
 		goto out_path_release;
 
-	if(IS_RDONLY(nd.dentry->d_inode))
+	if(__mnt_is_readonly(nd.mnt) || IS_RDONLY(nd.dentry->d_inode))
 		res = -EROFS;
 
 out_path_release:
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-filesystem-helpers-for-custom-struct-files.patch
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
