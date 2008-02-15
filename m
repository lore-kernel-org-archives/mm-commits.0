From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:15 -0800
Message-ID: <200802152249.m1FMnFQN028186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55380 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935089AbYBOW6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:58:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: elevate write count for chmod/chown callers
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch

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
Subject: r/o bind mounts: elevate write count for chmod/chown callers
From: Dave Hansen <haveblue@us.ibm.com>

chown/chmod,etc...  don't call permission in the same way that the normal
"open for write" calls do.  They still write to the filesystem, so bump the
write count during these operations.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN fs/open.c~r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers fs/open.c
--- a/fs/open.c~r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers
+++ a/fs/open.c
@@ -567,12 +567,12 @@ asmlinkage long sys_fchmod(unsigned int 
 
 	audit_inode(NULL, dentry);
 
-	err = -EROFS;
-	if (IS_RDONLY(inode))
+	err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		goto out_putf;
 	err = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto out_putf;
+		goto out_drop_write;
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
@@ -581,6 +581,8 @@ asmlinkage long sys_fchmod(unsigned int 
 	err = notify_change(dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(file->f_vfsmnt);
 out_putf:
 	fput(file);
 out:
@@ -600,13 +602,13 @@ asmlinkage long sys_fchmodat(int dfd, co
 		goto out;
 	inode = nd.path.dentry->d_inode;
 
-	error = -EROFS;
-	if (IS_RDONLY(inode))
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
 		goto dput_and_out;
 
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		goto dput_and_out;
+		goto out_drop_write;
 
 	mutex_lock(&inode->i_mutex);
 	if (mode == (mode_t) -1)
@@ -616,6 +618,8 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = notify_change(nd.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
+out_drop_write:
+	mnt_drop_write(nd.path.mnt);
 dput_and_out:
 	path_put(&nd.path);
 out:
@@ -638,9 +642,6 @@ static int chown_common(struct dentry * 
 		printk(KERN_ERR "chown_common: NULL inode\n");
 		goto out;
 	}
-	error = -EROFS;
-	if (IS_RDONLY(inode))
-		goto out;
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out;
@@ -671,7 +672,12 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -691,7 +697,12 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -705,7 +716,12 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_release;
 	error = chown_common(nd.path.dentry, user, group);
+	mnt_drop_write(nd.path.mnt);
+out_release:
 	path_put(&nd.path);
 out:
 	return error;
@@ -722,9 +738,14 @@ asmlinkage long sys_fchown(unsigned int 
 	if (!file)
 		goto out;
 
+	error = mnt_want_write(file->f_vfsmnt);
+	if (error)
+		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
 	error = chown_common(dentry, user, group);
+	mnt_drop_write(file->f_vfsmnt);
+out_fput:
 	fput(file);
 out:
 	return error;
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
