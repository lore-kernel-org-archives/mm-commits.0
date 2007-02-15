From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:33:26 -0800
Message-ID: <200702150833.l1F8XQfi024628@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39657 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965265AbXBOIiU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:38:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count over calls to vfs_rename()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: elevate write count over calls to vfs_rename()
From: Dave Hansen <hansendc@us.ibm.com>

This does create a little helper in the NFS code to make an if() a little bit
less ugly.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c    |    4 ++++
 fs/nfsd/vfs.c |   23 +++++++++++++++++++----
 2 files changed, 23 insertions(+), 4 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
+++ a/fs/namei.c
@@ -2563,8 +2563,12 @@ static int do_rename(int olddfd, const c
 	if (new_dentry == trap)
 		goto exit5;
 
+	error = mnt_want_write(oldnd.mnt);
+	if (error)
+		goto exit5;
 	error = vfs_rename(old_dir->d_inode, old_dentry,
 				   new_dir->d_inode, new_dentry);
+	mnt_drop_write(oldnd.mnt);
 exit5:
 	dput(new_dentry);
 exit4:
diff -puN fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
+++ a/fs/nfsd/vfs.c
@@ -1554,6 +1554,14 @@ out_nfserr:
 	goto out_unlock;
 }
 
+static inline int svc_msnfs(struct svc_fh *ffhp)
+{
+#ifdef MSNFS
+	return (ffhp->fh_export->ex_flags & NFSEXP_MSNFS);
+#else
+	return 0;
+#endif
+}
 /*
  * Rename a file
  * N.B. After this call _both_ ffhp and tfhp need an fh_put
@@ -1615,13 +1623,20 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	if (ndentry == trap)
 		goto out_dput_new;
 
-#ifdef MSNFS
-	if ((ffhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
+	if (svc_msnfs(ffhp) &&
 		((atomic_read(&odentry->d_count) > 1)
 		 || (atomic_read(&ndentry->d_count) > 1))) {
 			host_err = -EPERM;
-	} else
-#endif
+			goto out_dput_new;
+	}
+
+	host_err = -EXDEV;
+	if (ffhp->fh_export->ex_mnt != tfhp->fh_export->ex_mnt)
+		goto out_dput_new;
+	host_err = mnt_want_write(ffhp->fh_export->ex_mnt);
+	if (host_err)
+		goto out_dput_new;
+
 	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
 	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
 		host_err = nfsd_sync_dir(tdentry);
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
