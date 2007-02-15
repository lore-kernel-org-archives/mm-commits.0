From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:33:39 -0800
Message-ID: <200702150833.l1F8Xdnh024655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39536 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965296AbXBOIeh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:34:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: sys_mknodat(): elevate write count for vfs_mknod/create()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: sys_mknodat(): elevate write count for vfs_mknod/create()
From: Dave Hansen <hansendc@us.ibm.com>

This takes care of all of the direct callers of vfs_mknod().  Since a few of
these cases also handle normal file creation as well, this also covers some
calls to vfs_create().

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c         |   12 ++++++++++++
 fs/nfsd/vfs.c      |    4 ++++
 net/unix/af_unix.c |    4 ++++
 3 files changed, 20 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/fs/namei.c
@@ -1897,14 +1897,26 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (!IS_ERR(dentry)) {
 		switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
+			error = mnt_want_write(nd.mnt);
+			if (error)
+				break;
 			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
+			mnt_drop_write(nd.mnt);
 			break;
 		case S_IFCHR: case S_IFBLK:
+			error = mnt_want_write(nd.mnt);
+			if (error)
+				break;
 			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,
 					new_decode_dev(dev));
+			mnt_drop_write(nd.mnt);
 			break;
 		case S_IFIFO: case S_IFSOCK:
+			error = mnt_want_write(nd.mnt);
+			if (error)
+				break;
 			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
+			mnt_drop_write(nd.mnt);
 			break;
 		case S_IFDIR:
 			error = -EPERM;
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/fs/nfsd/vfs.c
@@ -667,6 +667,9 @@ nfsd_open(struct svc_rqst *rqstp, struct
 	/* Disallow write access to files with the append-only bit set
 	 * or any access when mandatory locking enabled
 	 */
+	err = mnt_want_write(fhp->fh_export->ex_mnt);
+	if (err)
+		goto out_nfserr;
 	err = nfserr_perm;
 	if (IS_APPEND(inode) && (access & MAY_WRITE))
 		goto out;
@@ -1198,6 +1201,7 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	        printk("nfsd: bad file type %o in nfsd_create\n", type);
 		host_err = -EINVAL;
 	}
+	mnt_drop_write(fhp->fh_export->ex_mnt);
 	if (host_err < 0)
 		goto out_nfserr;
 
diff -puN net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create net/unix/af_unix.c
--- a/net/unix/af_unix.c~r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create
+++ a/net/unix/af_unix.c
@@ -816,7 +816,11 @@ static int unix_bind(struct socket *sock
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

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
