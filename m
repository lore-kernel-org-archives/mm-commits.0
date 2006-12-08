From: akpm@osdl.org
Subject: - nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:54 -0800
Message-ID: <200612082001.kB8K1sHf001919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56917 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426219AbWLHUB4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     nfsd: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the nfs
server code.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs4state.c |   10 +++++-----
 fs/nfsd/nfsctl.c    |    2 +-
 fs/nfsd/vfs.c       |   16 ++++++++--------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/nfsd/nfs4state.c
@@ -1310,7 +1310,7 @@ static inline void
 nfs4_file_downgrade(struct file *filp, unsigned int share_access)
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
-		put_write_access(filp->f_dentry->d_inode);
+		put_write_access(filp->f_path.dentry->d_inode);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
 	}
 }
@@ -1623,7 +1623,7 @@ static __be32
 nfs4_upgrade_open(struct svc_rqst *rqstp, struct svc_fh *cur_fh, struct nfs4_stateid *stp, struct nfsd4_open *open)
 {
 	struct file *filp = stp->st_vfs_file;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int share_access, new_writer;
 	__be32 status;
 
@@ -1965,7 +1965,7 @@ search_close_lru(u32 st_id, int flags)
 static inline int
 nfs4_check_fh(struct svc_fh *fhp, struct nfs4_stateid *stp)
 {
-	return fhp->fh_dentry->d_inode != stp->st_vfs_file->f_dentry->d_inode;
+	return fhp->fh_dentry->d_inode != stp->st_vfs_file->f_path.dentry->d_inode;
 }
 
 static int
@@ -2862,7 +2862,7 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 	 * only the dentry:inode set.
 	 */
 	memset(&file, 0, sizeof (struct file));
-	file.f_dentry = current_fh->fh_dentry;
+	file.f_path.dentry = current_fh->fh_dentry;
 
 	status = nfs_ok;
 	if (posix_test_lock(&file, &file_lock, &conflock)) {
@@ -2952,7 +2952,7 @@ static int
 check_for_locks(struct file *filp, struct nfs4_stateowner *lowner)
 {
 	struct file_lock **flpp;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int status = 0;
 
 	lock_kernel();
diff -puN fs/nfsd/nfsctl.c~nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/nfsd/nfsctl.c
--- a/fs/nfsd/nfsctl.c~nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/nfsd/nfsctl.c
@@ -111,7 +111,7 @@ static ssize_t (*write_op[])(struct file
 
 static ssize_t nfsctl_transaction_write(struct file *file, const char __user *buf, size_t size, loff_t *pos)
 {
-	ino_t ino =  file->f_dentry->d_inode->i_ino;
+	ino_t ino =  file->f_path.dentry->d_inode->i_ino;
 	char *data;
 	ssize_t rv;
 
diff -puN fs/nfsd/vfs.c~nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/nfsd/vfs.c
@@ -736,10 +736,10 @@ static int
 nfsd_sync(struct file *filp)
 {
         int err;
-	struct inode *inode = filp->f_dentry->d_inode;
-	dprintk("nfsd: sync file %s\n", filp->f_dentry->d_name.name);
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	dprintk("nfsd: sync file %s\n", filp->f_path.dentry->d_name.name);
 	mutex_lock(&inode->i_mutex);
-	err=nfsd_dosync(filp, filp->f_dentry, filp->f_op);
+	err=nfsd_dosync(filp, filp->f_path.dentry, filp->f_op);
 	mutex_unlock(&inode->i_mutex);
 
 	return err;
@@ -845,7 +845,7 @@ nfsd_vfs_read(struct svc_rqst *rqstp, st
 	int		host_err;
 
 	err = nfserr_perm;
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 #ifdef MSNFS
 	if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
 		(!lock_may_read(inode, offset, *count)))
@@ -883,7 +883,7 @@ nfsd_vfs_read(struct svc_rqst *rqstp, st
 		nfsdstats.io_read += host_err;
 		*count = host_err;
 		err = 0;
-		fsnotify_access(file->f_dentry);
+		fsnotify_access(file->f_path.dentry);
 	} else 
 		err = nfserrno(host_err);
 out:
@@ -917,11 +917,11 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	err = nfserr_perm;
 
 	if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
-		(!lock_may_write(file->f_dentry->d_inode, offset, cnt)))
+		(!lock_may_write(file->f_path.dentry->d_inode, offset, cnt)))
 		goto out;
 #endif
 
-	dentry = file->f_dentry;
+	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
 	exp   = fhp->fh_export;
 
@@ -950,7 +950,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	set_fs(oldfs);
 	if (host_err >= 0) {
 		nfsdstats.io_write += cnt;
-		fsnotify_modify(file->f_dentry);
+		fsnotify_modify(file->f_path.dentry);
 	}
 
 	/* clear setuid/setgid flag after write */
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

