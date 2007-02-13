From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch added to -mm tree
Date: Mon, 12 Feb 2007 21:12:52 -0800
Message-ID: <200702130512.l1D5Cqu5022281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161005AbXBMFW2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 00:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, linuxram@us.ibm.com, miklos@szeredi.hu, viro@zeniv.linux.org.uk


The patch titled
     r/o bind mounts: elevate writer count for chown and friends
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: r/o bind mounts: elevate writer count for chown and friends
From: Dave Hansen <hansendc@us.ibm.com>

chown/chmod,etc...  don't call permission in the same way that the normal
"open for write" calls do.  They still write to the filesystem, so bump the
write count during these operations.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-elevate-writer-count-for-chown-and-friends fs/open.c
--- a/fs/open.c~r-o-bind-mounts-elevate-writer-count-for-chown-and-friends
+++ a/fs/open.c
@@ -511,9 +511,12 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = -EROFS;
 	if (IS_RDONLY(inode))
 		goto out_putf;
+	err = mnt_want_write(file->f_vfsmnt);
+	if (err)
+		goto out_putf;
 	err = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_putf;
+		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -522,6 +525,8 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(file->f_vfsmnt);
 out_putf:
 	fput(file);
 out:
@@ -541,13 +546,16 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = nd.dentry->d_inode;
 
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto dput_and_out;
 	error = -EROFS;
 	if (IS_RDONLY(inode))
-		goto dput_and_out;
+		goto out_drop_write;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto out_drop_write;
 
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
@@ -557,6 +565,8 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = notify_change(nd.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(nd.mnt);
 dput_and_out:
 	path_release(&nd);
 out:
@@ -582,7 +592,7 @@ static int chown_common(struct dentry * 
 	error = -EROFS;
 	if (IS_RDONLY(inode))
 		goto out;
-	error = -EPERM;
+ 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out;
 	newattrs.ia_valid =  ATTR_CTIME;
@@ -611,7 +621,12 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.dentry, user, group);
+	mnt_drop_write(nd.mnt);
+out_release:
 	path_release(&nd);
 out:
 	return error;
@@ -631,7 +646,12 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.dentry, user, group);
+	mnt_drop_write(nd.mnt);
+out_release:
 	path_release(&nd);
 out:
 	return error;
@@ -645,7 +665,11 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.dentry, user, group);
+out_release:
 	path_release(&nd);
 out:
 	return error;
@@ -662,9 +686,14 @@ asmlinkage long sys_fchown(unsigned int 
 	if (!file)
 		goto out;
 
+	error = mnt_want_write(file->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry->d_inode);
 	error = chown_common(dentry, user, group);
+	mnt_drop_write(file->f_vfsmnt);
+out_fput:
 	fput(file);
 out:
 	return error;
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
