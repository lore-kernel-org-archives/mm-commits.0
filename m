From: akpm@linux-foundation.org
Subject: - locks-give-posix_test_lock-same-interface-as-lock.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:20 -0700
Message-ID: <200704200638.l3K6cK2e008749@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423021AbXDTGih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: give posix_test_lock same interface as ->lock
has been removed from the -mm tree.  Its filename was
     locks-give-posix_test_lock-same-interface-as-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: give posix_test_lock same interface as ->lock
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

posix_test_lock() and ->lock() do the same job but have gratuitously
simplifying some code in the process.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c                |    3 --
 fs/gfs2/locking/nolock/main.c |    8 ------
 fs/gfs2/ops_file.c            |    7 ------
 fs/lockd/svclock.c            |   13 ++++++-----
 fs/locks.c                    |   37 +++++++++++++-------------------
 fs/nfs/file.c                 |    7 ------
 fs/nfsd/nfs4state.c           |    6 ++---
 include/linux/fs.h            |    2 -
 8 files changed, 32 insertions(+), 51 deletions(-)

diff -puN fs/fuse/file.c~locks-give-posix_test_lock-same-interface-as-lock fs/fuse/file.c
--- a/fs/fuse/file.c~locks-give-posix_test_lock-same-interface-as-lock
+++ a/fs/fuse/file.c
@@ -738,8 +738,7 @@ static int fuse_file_lock(struct file *f
 
 	if (cmd == F_GETLK) {
 		if (fc->no_lock) {
-			if (!posix_test_lock(file, fl, fl))
-				fl->fl_type = F_UNLCK;
+			posix_test_lock(file, fl);
 			err = 0;
 		} else
 			err = fuse_getlk(file, fl);
diff -puN fs/gfs2/locking/nolock/main.c~locks-give-posix_test_lock-same-interface-as-lock fs/gfs2/locking/nolock/main.c
--- a/fs/gfs2/locking/nolock/main.c~locks-give-posix_test_lock-same-interface-as-lock
+++ a/fs/gfs2/locking/nolock/main.c
@@ -163,13 +163,7 @@ static void nolock_unhold_lvb(void *lock
 static int nolock_plock_get(void *lockspace, struct lm_lockname *name,
 			    struct file *file, struct file_lock *fl)
 {
-	struct file_lock tmp;
-	int ret;
-
-	ret = posix_test_lock(file, fl, &tmp);
-	fl->fl_type = F_UNLCK;
-	if (ret)
-		memcpy(fl, &tmp, sizeof(struct file_lock));
+	posix_test_lock(file, fl);
 
 	return 0;
 }
diff -puN fs/gfs2/ops_file.c~locks-give-posix_test_lock-same-interface-as-lock fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~locks-give-posix_test_lock-same-interface-as-lock
+++ a/fs/gfs2/ops_file.c
@@ -514,12 +514,7 @@ static int gfs2_lock(struct file *file, 
 
 	if (sdp->sd_args.ar_localflocks) {
 		if (IS_GETLK(cmd)) {
-			struct file_lock tmp;
-			int ret;
-			ret = posix_test_lock(file, fl, &tmp);
-			fl->fl_type = F_UNLCK;
-			if (ret)
-				memcpy(fl, &tmp, sizeof(struct file_lock));
+			posix_test_lock(file, fl);
 			return 0;
 		} else {
 			return posix_lock_file_wait(file, fl);
diff -puN fs/lockd/svclock.c~locks-give-posix_test_lock-same-interface-as-lock fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~locks-give-posix_test_lock-same-interface-as-lock
+++ a/fs/lockd/svclock.c
@@ -426,15 +426,18 @@ nlmsvc_testlock(struct nlm_file *file, s
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
 
-	if (posix_test_lock(file->f_file, &lock->fl, &conflock->fl)) {
+	if (posix_test_lock(file->f_file, &lock->fl)) {
 		dprintk("lockd: conflicting lock(ty=%d, %Ld-%Ld)\n",
-				conflock->fl.fl_type,
-				(long long)conflock->fl.fl_start,
-				(long long)conflock->fl.fl_end);
+				lock->fl.fl_type,
+				(long long)lock->fl.fl_start,
+				(long long)lock->fl.fl_end);
 		conflock->caller = "somehost";	/* FIXME */
 		conflock->len = strlen(conflock->caller);
 		conflock->oh.len = 0;		/* don't return OH info */
-		conflock->svid = conflock->fl.fl_pid;
+		conflock->svid = lock->fl.fl_pid;
+		conflock->fl.fl_type = lock->fl.fl_type;
+		conflock->fl.fl_start = lock->fl.fl_start;
+		conflock->fl.fl_end = lock->fl.fl_end;
 		return nlm_lck_denied;
 	}
 
diff -puN fs/locks.c~locks-give-posix_test_lock-same-interface-as-lock fs/locks.c
--- a/fs/locks.c~locks-give-posix_test_lock-same-interface-as-lock
+++ a/fs/locks.c
@@ -666,11 +666,11 @@ static int locks_block_on_timeout(struct
 }
 
 int
-posix_test_lock(struct file *filp, struct file_lock *fl,
-		struct file_lock *conflock)
+posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	struct file_lock *cfl;
 
+	fl->fl_type = F_UNLCK;
 	lock_kernel();
 	for (cfl = filp->f_path.dentry->d_inode->i_flock; cfl; cfl = cfl->fl_next) {
 		if (!IS_POSIX(cfl))
@@ -679,7 +679,7 @@ posix_test_lock(struct file *filp, struc
 			break;
 	}
 	if (cfl) {
-		__locks_copy_lock(conflock, cfl);
+		__locks_copy_lock(fl, cfl);
 		unlock_kernel();
 		return 1;
 	}
@@ -1648,7 +1648,7 @@ static void posix_lock_to_flock64(struct
  */
 int fcntl_getlk(struct file *filp, struct flock __user *l)
 {
-	struct file_lock *fl, cfl, file_lock;
+	struct file_lock file_lock;
 	struct flock flock;
 	int error;
 
@@ -1667,15 +1667,12 @@ int fcntl_getlk(struct file *filp, struc
 		error = filp->f_op->lock(filp, F_GETLK, &file_lock);
 		if (error < 0)
 			goto out;
-		else
-		  fl = (file_lock.fl_type == F_UNLCK ? NULL : &file_lock);
-	} else {
-		fl = (posix_test_lock(filp, &file_lock, &cfl) ? &cfl : NULL);
-	}
+	} else
+		posix_test_lock(filp, &file_lock);
  
-	flock.l_type = F_UNLCK;
-	if (fl != NULL) {
-		error = posix_lock_to_flock(&flock, fl);
+	flock.l_type = file_lock.fl_type;
+	if (file_lock.fl_type != F_UNLCK) {
+		error = posix_lock_to_flock(&flock, &file_lock);
 		if (error)
 			goto out;
 	}
@@ -1785,7 +1782,7 @@ out:
  */
 int fcntl_getlk64(struct file *filp, struct flock64 __user *l)
 {
-	struct file_lock *fl, cfl, file_lock;
+	struct file_lock file_lock;
 	struct flock64 flock;
 	int error;
 
@@ -1804,15 +1801,13 @@ int fcntl_getlk64(struct file *filp, str
 		error = filp->f_op->lock(filp, F_GETLK, &file_lock);
 		if (error < 0)
 			goto out;
-		else
-		  fl = (file_lock.fl_type == F_UNLCK ? NULL : &file_lock);
-	} else {
-		fl = (posix_test_lock(filp, &file_lock, &cfl) ? &cfl : NULL);
-	}
+	} else
+		posix_test_lock(filp, &file_lock);
  
-	flock.l_type = F_UNLCK;
-	if (fl != NULL)
-		posix_lock_to_flock64(&flock, fl);
+	flock.l_type = file_lock.fl_type;
+	if (file_lock.fl_type != F_UNLCK)
+		posix_lock_to_flock64(&flock, &file_lock);
+
 	error = -EFAULT;
 	if (!copy_to_user(l, &flock, sizeof(flock)))
 		error = 0;
diff -puN fs/nfs/file.c~locks-give-posix_test_lock-same-interface-as-lock fs/nfs/file.c
--- a/fs/nfs/file.c~locks-give-posix_test_lock-same-interface-as-lock
+++ a/fs/nfs/file.c
@@ -391,17 +391,12 @@ out_swapfile:
 
 static int do_getlk(struct file *filp, int cmd, struct file_lock *fl)
 {
-	struct file_lock cfl;
 	struct inode *inode = filp->f_mapping->host;
 	int status = 0;
 
 	lock_kernel();
 	/* Try local locking first */
-	if (posix_test_lock(filp, fl, &cfl)) {
-		fl->fl_start = cfl.fl_start;
-		fl->fl_end = cfl.fl_end;
-		fl->fl_type = cfl.fl_type;
-		fl->fl_pid = cfl.fl_pid;
+	if (posix_test_lock(filp, fl)) {
 		goto out;
 	}
 
diff -puN fs/nfsd/nfs4state.c~locks-give-posix_test_lock-same-interface-as-lock fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~locks-give-posix_test_lock-same-interface-as-lock
+++ a/fs/nfsd/nfs4state.c
@@ -2813,7 +2813,6 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 	struct inode *inode;
 	struct file file;
 	struct file_lock file_lock;
-	struct file_lock conflock;
 	__be32 status;
 
 	if (nfs4_in_grace())
@@ -2878,9 +2877,10 @@ nfsd4_lockt(struct svc_rqst *rqstp, stru
 	file.f_path.dentry = cstate->current_fh.fh_dentry;
 
 	status = nfs_ok;
-	if (posix_test_lock(&file, &file_lock, &conflock)) {
+	posix_test_lock(&file, &file_lock);
+	if (file_lock.fl_type != F_UNLCK) {
 		status = nfserr_denied;
-		nfs4_set_lock_denied(&conflock, &lockt->lt_denied);
+		nfs4_set_lock_denied(&file_lock, &lockt->lt_denied);
 	}
 out:
 	nfs4_unlock_state();
diff -puN include/linux/fs.h~locks-give-posix_test_lock-same-interface-as-lock include/linux/fs.h
--- a/include/linux/fs.h~locks-give-posix_test_lock-same-interface-as-lock
+++ a/include/linux/fs.h
@@ -854,7 +854,7 @@ extern void locks_init_lock(struct file_
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
 extern void locks_remove_posix(struct file *, fl_owner_t);
 extern void locks_remove_flock(struct file *);
-extern int posix_test_lock(struct file *, struct file_lock *, struct file_lock *);
+extern int posix_test_lock(struct file *, struct file_lock *);
 extern int posix_lock_file_conf(struct file *, struct file_lock *, struct file_lock *);
 extern int posix_lock_file(struct file *, struct file_lock *);
 extern int posix_lock_file_wait(struct file *, struct file_lock *);
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

git-nfs-server-cluster-locking-api.patch
