From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch removed from -mm tree
Date: Wed, 14 Feb 2007 10:53:06 -0800
Message-ID: <200702141853.l1EIr74o005773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449AbXBNSxs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 13:53:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, herbert@13thfloor.at, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: honor r/w changes at do_remount() time
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch

This patch was dropped because an updated version will be merged

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

r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
r-o-bind-mounts-kill-open-files-traverse-on-remount-ro.patch
