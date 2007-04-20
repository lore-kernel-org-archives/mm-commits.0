From: akpm@linux-foundation.org
Subject: - locks-factor-out-generic-filesystem-switch-from-test_lock.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:22 -0700
Message-ID: <200704200638.l3K6cMgI008752@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422997AbXDTGii (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, eshel@almaden.ibm.com, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: factor out generic/filesystem switch from test_lock
has been removed from the -mm tree.  Its filename was
     locks-factor-out-generic-filesystem-switch-from-test_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: factor out generic/filesystem switch from test_lock
From: J. Bruce Fields <bfields@citi.umich.edu> - unquoted

Factor out the code that switches between generic and filesystem-specific lock
methods; eventually we want to call this from lock managers (lockd and nfsd)
too; currently they only call the generic methods.

This patch does that for test_lock.

Note that this hasn't been necessary until recently, because the few
filesystems that define ->lock() (nfs, cifs...) aren't exportable via NFS. 
However GFS (and, in the future, other cluster filesystems) need to implement
their own locking to get cluster-coherent locking, and also want to be able to
export locking to NFS (lockd and NFSv4).

So we accomplish this by factoring out code such as this and exporting it for
the use of lockd and nfsd.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c         |   39 ++++++++++++++++++++++++++-------------
 include/linux/fs.h |    1 +
 2 files changed, 27 insertions(+), 13 deletions(-)

diff -puN fs/locks.c~locks-factor-out-generic-filesystem-switch-from-test_lock fs/locks.c
--- a/fs/locks.c~locks-factor-out-generic-filesystem-switch-from-test_lock
+++ a/fs/locks.c
@@ -1611,6 +1611,25 @@ asmlinkage long sys_flock(unsigned int f
 	return error;
 }
 
+/**
+ * vfs_test_lock - test file byte range lock
+ * @filp: The file to test lock for
+ * @fl: The lock to test
+ * @conf: Place to return a copy of the conflicting lock, if found
+ *
+ * Returns -ERRNO on failure.  Indicates presence of conflicting lock by
+ * setting conf->fl_type to something other than F_UNLCK.
+ */
+int vfs_test_lock(struct file *filp, struct file_lock *fl)
+{
+	fl->fl_type = F_UNLCK;
+	if (filp->f_op && filp->f_op->lock)
+		return filp->f_op->lock(filp, F_GETLK, fl);
+	posix_test_lock(filp, fl);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfs_test_lock);
+
 static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
 {
 	flock->l_pid = fl->fl_pid;
@@ -1663,12 +1682,9 @@ int fcntl_getlk(struct file *filp, struc
 	if (error)
 		goto out;
 
-	if (filp->f_op && filp->f_op->lock) {
-		error = filp->f_op->lock(filp, F_GETLK, &file_lock);
-		if (error < 0)
-			goto out;
-	} else
-		posix_test_lock(filp, &file_lock);
+	error = vfs_test_lock(filp, &file_lock);
+	if (error)
+		goto out;
  
 	flock.l_type = file_lock.fl_type;
 	if (file_lock.fl_type != F_UNLCK) {
@@ -1797,13 +1813,10 @@ int fcntl_getlk64(struct file *filp, str
 	if (error)
 		goto out;
 
-	if (filp->f_op && filp->f_op->lock) {
-		error = filp->f_op->lock(filp, F_GETLK, &file_lock);
-		if (error < 0)
-			goto out;
-	} else
-		posix_test_lock(filp, &file_lock);
- 
+	error = vfs_test_lock(filp, &file_lock);
+	if (error)
+		goto out;
+
 	flock.l_type = file_lock.fl_type;
 	if (file_lock.fl_type != F_UNLCK)
 		posix_lock_to_flock64(&flock, &file_lock);
diff -puN include/linux/fs.h~locks-factor-out-generic-filesystem-switch-from-test_lock include/linux/fs.h
--- a/include/linux/fs.h~locks-factor-out-generic-filesystem-switch-from-test_lock
+++ a/include/linux/fs.h
@@ -859,6 +859,7 @@ extern int posix_lock_file_conf(struct f
 extern int posix_lock_file(struct file *, struct file_lock *);
 extern int posix_lock_file_wait(struct file *, struct file_lock *);
 extern int posix_unblock_lock(struct file *, struct file_lock *);
+extern int vfs_test_lock(struct file *, struct file_lock *);
 extern int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags);
 extern void lease_get_mtime(struct inode *, struct timespec *time);
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

auth_gss-unregister-gss_domain-when-unloading-module.patch
git-nfs-server-cluster-locking-api.patch
remove-nfs4_acl_add_ace.patch
