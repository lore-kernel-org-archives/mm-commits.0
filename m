From: akpm@linux-foundation.org
Subject: - locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:26 -0700
Message-ID: <200704200638.l3K6cQpD008758@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423023AbXDTGio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: allow {vfs,posix}_lock_file to return conflicting lock
has been removed from the -mm tree.  Its filename was
     locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: allow {vfs,posix}_lock_file to return conflicting lock
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

The nfsv4 protocol's lock operation, in the case of a conflict, returns
information about the conflicting lock.

It's unclear how clients can use this, so for now we're not going so far as to
add a filesystem method that can return a conflicting lock, but we may as well
return something in the local case when it's easy to.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svclock.c  |    6 +++---
 fs/lockd/svcsubs.c  |    2 +-
 fs/locks.c          |   38 +++++++++++++-------------------------
 fs/nfsd/nfs4state.c |   10 ++++++----
 include/linux/fs.h  |    5 ++---
 5 files changed, 25 insertions(+), 36 deletions(-)

diff -puN fs/lockd/svclock.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock
+++ a/fs/lockd/svclock.c
@@ -363,7 +363,7 @@ again:
 	} else
 		lock = &block->b_call->a_args.lock;
 
-	error = posix_lock_file(file->f_file, &lock->fl);
+	error = posix_lock_file(file->f_file, &lock->fl, NULL);
 	lock->fl.fl_flags &= ~FL_SLEEP;
 
 	dprintk("lockd: posix_lock_file returned %d\n", error);
@@ -467,7 +467,7 @@ nlmsvc_unlock(struct nlm_file *file, str
 	nlmsvc_cancel_blocked(file, lock);
 
 	lock->fl.fl_type = F_UNLCK;
-	error = posix_lock_file(file->f_file, &lock->fl);
+	error = posix_lock_file(file->f_file, &lock->fl, NULL);
 
 	return (error < 0)? nlm_lck_denied_nolocks : nlm_granted;
 }
@@ -569,7 +569,7 @@ nlmsvc_grant_blocked(struct nlm_block *b
 
 	/* Try the lock operation again */
 	lock->fl.fl_flags |= FL_SLEEP;
-	error = posix_lock_file(file->f_file, &lock->fl);
+	error = posix_lock_file(file->f_file, &lock->fl, NULL);
 	lock->fl.fl_flags &= ~FL_SLEEP;
 
 	switch (error) {
diff -puN fs/lockd/svcsubs.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock fs/lockd/svcsubs.c
--- a/fs/lockd/svcsubs.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock
+++ a/fs/lockd/svcsubs.c
@@ -182,7 +182,7 @@ again:
 			lock.fl_type  = F_UNLCK;
 			lock.fl_start = 0;
 			lock.fl_end   = OFFSET_MAX;
-			if (posix_lock_file(file->f_file, &lock) < 0) {
+			if (posix_lock_file(file->f_file, &lock, NULL) < 0) {
 				printk("lockd: unlock failure in %s:%d\n",
 						__FILE__, __LINE__);
 				return 1;
diff -puN fs/locks.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock fs/locks.c
--- a/fs/locks.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock
+++ a/fs/locks.c
@@ -801,7 +801,7 @@ out:
 	return error;
 }
 
-static int __posix_lock_file_conf(struct inode *inode, struct file_lock *request, struct file_lock *conflock)
+static int __posix_lock_file(struct inode *inode, struct file_lock *request, struct file_lock *conflock)
 {
 	struct file_lock *fl;
 	struct file_lock *new_fl = NULL;
@@ -1007,6 +1007,7 @@ static int __posix_lock_file_conf(struct
  * posix_lock_file - Apply a POSIX-style lock to a file
  * @filp: The file to apply the lock to
  * @fl: The lock to be applied
+ * @conflock: Place to return a copy of the conflicting lock, if found.
  *
  * Add a POSIX style lock to a file.
  * We merge adjacent & overlapping locks whenever possible.
@@ -1016,26 +1017,12 @@ static int __posix_lock_file_conf(struct
  * whether or not a lock was successfully freed by testing the return
  * value for -ENOENT.
  */
-int posix_lock_file(struct file *filp, struct file_lock *fl)
-{
-	return __posix_lock_file_conf(filp->f_path.dentry->d_inode, fl, NULL);
-}
-EXPORT_SYMBOL(posix_lock_file);
-
-/**
- * posix_lock_file_conf - Apply a POSIX-style lock to a file
- * @filp: The file to apply the lock to
- * @fl: The lock to be applied
- * @conflock: Place to return a copy of the conflicting lock, if found.
- *
- * Except for the conflock parameter, acts just like posix_lock_file.
- */
-int posix_lock_file_conf(struct file *filp, struct file_lock *fl,
+int posix_lock_file(struct file *filp, struct file_lock *fl,
 			struct file_lock *conflock)
 {
-	return __posix_lock_file_conf(filp->f_path.dentry->d_inode, fl, conflock);
+	return __posix_lock_file(filp->f_path.dentry->d_inode, fl, conflock);
 }
-EXPORT_SYMBOL(posix_lock_file_conf);
+EXPORT_SYMBOL(posix_lock_file);
 
 /**
  * posix_lock_file_wait - Apply a POSIX-style lock to a file
@@ -1051,7 +1038,7 @@ int posix_lock_file_wait(struct file *fi
 	int error;
 	might_sleep ();
 	for (;;) {
-		error = posix_lock_file(filp, fl);
+		error = posix_lock_file(filp, fl, NULL);
 		if ((error != -EAGAIN) || !(fl->fl_flags & FL_SLEEP))
 			break;
 		error = wait_event_interruptible(fl->fl_wait, !fl->fl_next);
@@ -1123,7 +1110,7 @@ int locks_mandatory_area(int read_write,
 	fl.fl_end = offset + count - 1;
 
 	for (;;) {
-		error = __posix_lock_file_conf(inode, &fl, NULL);
+		error = __posix_lock_file(inode, &fl, NULL);
 		if (error != -EAGAIN)
 			break;
 		if (!(fl.fl_flags & FL_SLEEP))
@@ -1704,13 +1691,14 @@ out:
  * @filp: The file to apply the lock to
  * @cmd: type of locking operation (F_SETLK, F_GETLK, etc.)
  * @fl: The lock to be applied
+ * @conf: Place to return a copy of the conflicting lock, if found.
  */
-int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl)
+int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl, struct file_lock *conf)
 {
 	if (filp->f_op && filp->f_op->lock)
 		return filp->f_op->lock(filp, cmd, fl);
 	else
-		return posix_lock_file(filp, fl);
+		return posix_lock_file(filp, fl, conf);
 }
 EXPORT_SYMBOL_GPL(vfs_lock_file);
 
@@ -1777,7 +1765,7 @@ again:
 		goto out;
 
 	for (;;) {
-		error = vfs_lock_file(filp, cmd, file_lock);
+		error = vfs_lock_file(filp, cmd, file_lock, NULL);
 		if (error != -EAGAIN || cmd == F_SETLK)
 			break;
 		error = wait_event_interruptible(file_lock->fl_wait,
@@ -1903,7 +1891,7 @@ again:
 		goto out;
 
 	for (;;) {
-		error = vfs_lock_file(filp, cmd, file_lock);
+		error = vfs_lock_file(filp, cmd, file_lock, NULL);
 		if (error != -EAGAIN || cmd == F_SETLK64)
 			break;
 		error = wait_event_interruptible(file_lock->fl_wait,
@@ -1957,7 +1945,7 @@ void locks_remove_posix(struct file *fil
 	lock.fl_ops = NULL;
 	lock.fl_lmops = NULL;
 
-	vfs_lock_file(filp, F_SETLK, &lock);
+	vfs_lock_file(filp, F_SETLK, &lock, NULL);
 
 	if (lock.fl_ops && lock.fl_ops->fl_release_private)
 		lock.fl_ops->fl_release_private(&lock);
diff -puN fs/nfsd/nfs4state.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~locks-allow-vfsposix_lock_file-to-return-conflicting-lock
+++ a/fs/nfsd/nfs4state.c
@@ -2657,6 +2657,7 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	struct file_lock conflock;
 	__be32 status = 0;
 	unsigned int strhashval;
+	unsigned int cmd;
 	int err;
 
 	dprintk("NFSD: nfsd4_lock: start=%Ld length=%Ld\n",
@@ -2739,10 +2740,12 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 		case NFS4_READ_LT:
 		case NFS4_READW_LT:
 			file_lock.fl_type = F_RDLCK;
+			cmd = F_SETLK;
 		break;
 		case NFS4_WRITE_LT:
 		case NFS4_WRITEW_LT:
 			file_lock.fl_type = F_WRLCK;
+			cmd = F_SETLK;
 		break;
 		default:
 			status = nfserr_inval;
@@ -2769,9 +2772,8 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 
 	/* XXX?: Just to divert the locks_release_private at the start of
 	 * locks_copy_lock: */
-	conflock.fl_ops = NULL;
-	conflock.fl_lmops = NULL;
-	err = posix_lock_file_conf(filp, &file_lock, &conflock);
+	locks_init_lock(&conflock);
+	err = posix_lock_file(filp, &file_lock, &conflock);
 	switch (-err) {
 	case 0: /* success! */
 		update_stateid(&lock_stp->st_stateid);
@@ -2933,7 +2935,7 @@ nfsd4_locku(struct svc_rqst *rqstp, stru
 	/*
 	*  Try to unlock the file in the VFS.
 	*/
-	err = posix_lock_file(filp, &file_lock);
+	err = posix_lock_file(filp, &file_lock, NULL);
 	if (err) {
 		dprintk("NFSD: nfs4_locku: posix_lock_file failed!\n");
 		goto out_nfserr;
diff -puN include/linux/fs.h~locks-allow-vfsposix_lock_file-to-return-conflicting-lock include/linux/fs.h
--- a/include/linux/fs.h~locks-allow-vfsposix_lock_file-to-return-conflicting-lock
+++ a/include/linux/fs.h
@@ -855,12 +855,11 @@ extern void locks_copy_lock(struct file_
 extern void locks_remove_posix(struct file *, fl_owner_t);
 extern void locks_remove_flock(struct file *);
 extern int posix_test_lock(struct file *, struct file_lock *);
-extern int posix_lock_file_conf(struct file *, struct file_lock *, struct file_lock *);
-extern int posix_lock_file(struct file *, struct file_lock *);
+extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
 extern int posix_lock_file_wait(struct file *, struct file_lock *);
 extern int posix_unblock_lock(struct file *, struct file_lock *);
 extern int vfs_test_lock(struct file *, struct file_lock *);
-extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *);
+extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
 extern int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags);
 extern void lease_get_mtime(struct inode *, struct timespec *time);
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

git-nfs-server-cluster-locking-api.patch
