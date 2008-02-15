From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch removed from -mm tree
Date: Thu, 14 Feb 2008 21:31:33 -0800
Message-ID: <200802150531.m1F5VX63021801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055AbYBOFii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 00:38:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     r-o-bind-mounts: sys_mknodat(): elevate write count for vfs_mknod() create
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r-o-bind-mounts: sys_mknodat(): elevate write count for vfs_mknod() create
From: Dave Hansen <haveblue@us.ibm.com>

This takes care of all of the direct callers of vfs_mknod().
Since a few of these cases also handle normal file creation
as well, this also covers some calls to vfs_create().

So that we don't have to make three mnt_want/drop_write()
calls inside of the switch statement, we move some of its
logic outside of the switch and into a helper function
suggested by Christoph.

This also encapsulates a fix for mknod(S_IFREG) that Miklos
found.

Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |   43 ++++++++++++++++++++++++++++++++-----------
 fs/nfsd/vfs.c      |    4 ++++
 net/unix/af_unix.c |    4 ++++
 3 files changed, 40 insertions(+), 11 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/fs/namei.c
@@ -2026,6 +2026,23 @@ int vfs_mknod(struct inode *dir, struct 
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
@@ -2044,12 +2061,19 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (error)
 		goto out;
 	dentry = lookup_create(&nd, 0);
-	error = PTR_ERR(dentry);
-
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
 	if (!IS_POSIXACL(nd.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	if (!IS_ERR(dentry)) {
-		switch (mode & S_IFMT) {
+	error = may_mknod(mode);
+	if (error)
+		goto out_dput;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_dput;
+	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
 			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
 			break;
@@ -2060,14 +2084,11 @@ asmlinkage long sys_mknodat(int dfd, con
 		case S_IFIFO: case S_IFSOCK:
 			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
 			break;
-		case S_IFDIR:
-			error = -EPERM;
-			break;
-		default:
-			error = -EINVAL;
-		}
-		dput(dentry);
 	}
+	mnt_drop_write(nd.mnt);
+out_dput:
+	dput(dentry);
+out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/fs/nfsd/vfs.c
@@ -1263,7 +1263,11 @@ nfsd_create(struct svc_rqst *rqstp, stru
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
diff -puN net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create net/unix/af_unix.c
--- a/net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/net/unix/af_unix.c
@@ -819,7 +819,11 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
+		err = mnt_want_write(nd.mnt);
+		if (err)
+			goto out_mknod_dput;
 		err = vfs_mknod(nd.dentry->d_inode, dentry, mode, 0);
+		mnt_drop_write(nd.mnt);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.dentry->d_inode->i_mutex);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
