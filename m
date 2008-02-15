From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:25 -0800
Message-ID: <200802152249.m1FMnQar028201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934191AbYBOW6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: get callers of vfs_mknod/create()
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch

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
Subject: r/o bind mounts: get callers of vfs_mknod/create()
From: Dave Hansen <haveblue@us.ibm.com>

This takes care of all of the direct callers of vfs_mknod().  Since a few of
these cases also handle normal file creation as well, this also covers some
calls to vfs_create().

So that we don't have to make three mnt_want/drop_write() calls inside of the
switch statement, we move some of its logic outside of the switch and into a
helper function suggested by Christoph.

This also encapsulates a fix for mknod(S_IFREG) that Miklos found.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |   43 ++++++++++++++++++++++++++++++++-----------
 fs/nfsd/vfs.c      |    4 ++++
 net/unix/af_unix.c |    4 ++++
 3 files changed, 40 insertions(+), 11 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-get-callers-of-vfs_mknod-create fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-get-callers-of-vfs_mknod-create
+++ a/fs/namei.c
@@ -2039,6 +2039,23 @@ int vfs_mknod(struct inode *dir, struct 
 	return error;
 }
 
+static int may_mknod(mode_t mode)
+{
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+	case 0: /* zero mode translates to S_IFREG */
+		return 0;
+	case S_IFDIR:
+		return -EPERM;
+	default:
+		return -EINVAL;
+	}
+}
+
 asmlinkage long sys_mknodat(int dfd, const char __user *filename, int mode,
 				unsigned dev)
 {
@@ -2057,12 +2074,19 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (error)
 		goto out;
 	dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(dentry);
-
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
 	if (!IS_POSIXACL(nd.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	if (!IS_ERR(dentry)) {
-		switch (mode & S_IFMT) {
+	error = may_mknod(mode);
+	if (error)
+		goto out_dput;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
+	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(nd.path.dentry->d_inode,dentry,mode,&nd);
 			break;
@@ -2073,14 +2097,11 @@ asmlinkage long sys_mknodat(int dfd, con
 		case S_IFIFO: case S_IFSOCK:
 			error = vfs_mknod(nd.path.dentry->d_inode,dentry,mode,0);
 			break;
-		case S_IFDIR:
-			error = -EPERM;
-			break;
-		default:
-			error = -EINVAL;
-		}
-		dput(dentry);
 	}
+	mnt_drop_write(nd.path.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_put(&nd.path);
 out:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-get-callers-of-vfs_mknod-create fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-get-callers-of-vfs_mknod-create
+++ a/fs/nfsd/vfs.c
@@ -1264,7 +1264,11 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
+		host_err = mnt_want_write(fhp->fh_export->ex_mnt);
+		if (host_err)
+			break;
 		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
+		mnt_drop_write(fhp->fh_export->ex_mnt);
 		break;
 	default:
 	        printk("nfsd: bad file type %o in nfsd_create\n", type);
diff -puN net/unix/af_unix.c~r-o-bind-mounts-get-callers-of-vfs_mknod-create net/unix/af_unix.c
--- a/net/unix/af_unix.c~r-o-bind-mounts-get-callers-of-vfs_mknod-create
+++ a/net/unix/af_unix.c
@@ -819,7 +819,11 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
+		err = mnt_want_write(nd.path.mnt);
+		if (err)
+			goto out_mknod_dput;
 		err = vfs_mknod(nd.path.dentry->d_inode, dentry, mode, 0);
+		mnt_drop_write(nd.path.mnt);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
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
