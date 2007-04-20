From: akpm@linux-foundation.org
Subject: - locks-factor-out-generic-filesystem-switch-from-setlock-code.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:24 -0700
Message-ID: <200704200638.l3K6cOJU008755@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423023AbXDTGil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     locks: factor out generic/filesystem switch from setlock code
has been removed from the -mm tree.  Its filename was
     locks-factor-out-generic-filesystem-switch-from-setlock-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: locks: factor out generic/filesystem switch from setlock code
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Factor out the code that switches between generic and filesystem-specific lock
methods; eventually we want to call this from lock managers (lockd and nfsd)
too; currently they only call the generic methods.

This patch does that for all the setlk code.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c         |   68 ++++++++++++++++++++++---------------------
 include/linux/fs.h |    1 
 2 files changed, 37 insertions(+), 32 deletions(-)

diff -puN fs/locks.c~locks-factor-out-generic-filesystem-switch-from-setlock-code fs/locks.c
--- a/fs/locks.c~locks-factor-out-generic-filesystem-switch-from-setlock-code
+++ a/fs/locks.c
@@ -1699,6 +1699,21 @@ out:
 	return error;
 }
 
+/**
+ * vfs_lock_file - file byte range lock
+ * @filp: The file to apply the lock to
+ * @cmd: type of locking operation (F_SETLK, F_GETLK, etc.)
+ * @fl: The lock to be applied
+ */
+int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl)
+{
+	if (filp->f_op && filp->f_op->lock)
+		return filp->f_op->lock(filp, cmd, fl);
+	else
+		return posix_lock_file(filp, fl);
+}
+EXPORT_SYMBOL_GPL(vfs_lock_file);
+
 /* Apply the lock described by l to an open file descriptor.
  * This implements both the F_SETLK and F_SETLKW commands of fcntl().
  */
@@ -1761,21 +1776,17 @@ again:
 	if (error)
 		goto out;
 
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, file_lock);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, file_lock);
-			if (error != -EAGAIN || cmd == F_SETLK)
-				break;
-			error = wait_event_interruptible(file_lock->fl_wait,
-					!file_lock->fl_next);
-			if (!error)
-				continue;
-
-			locks_delete_block(file_lock);
+	for (;;) {
+		error = vfs_lock_file(filp, cmd, file_lock);
+		if (error != -EAGAIN || cmd == F_SETLK)
 			break;
-		}
+		error = wait_event_interruptible(file_lock->fl_wait,
+				!file_lock->fl_next);
+		if (!error)
+			continue;
+
+		locks_delete_block(file_lock);
+		break;
 	}
 
 	/*
@@ -1891,21 +1902,17 @@ again:
 	if (error)
 		goto out;
 
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, file_lock);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, file_lock);
-			if (error != -EAGAIN || cmd == F_SETLK64)
-				break;
-			error = wait_event_interruptible(file_lock->fl_wait,
-					!file_lock->fl_next);
-			if (!error)
-				continue;
-
-			locks_delete_block(file_lock);
+	for (;;) {
+		error = vfs_lock_file(filp, cmd, file_lock);
+		if (error != -EAGAIN || cmd == F_SETLK64)
 			break;
-		}
+		error = wait_event_interruptible(file_lock->fl_wait,
+				!file_lock->fl_next);
+		if (!error)
+			continue;
+
+		locks_delete_block(file_lock);
+		break;
 	}
 
 	/*
@@ -1950,10 +1957,7 @@ void locks_remove_posix(struct file *fil
 	lock.fl_ops = NULL;
 	lock.fl_lmops = NULL;
 
-	if (filp->f_op && filp->f_op->lock != NULL)
-		filp->f_op->lock(filp, F_SETLK, &lock);
-	else
-		posix_lock_file(filp, &lock);
+	vfs_lock_file(filp, F_SETLK, &lock);
 
 	if (lock.fl_ops && lock.fl_ops->fl_release_private)
 		lock.fl_ops->fl_release_private(&lock);
diff -puN include/linux/fs.h~locks-factor-out-generic-filesystem-switch-from-setlock-code include/linux/fs.h
--- a/include/linux/fs.h~locks-factor-out-generic-filesystem-switch-from-setlock-code
+++ a/include/linux/fs.h
@@ -860,6 +860,7 @@ extern int posix_lock_file(struct file *
 extern int posix_lock_file_wait(struct file *, struct file_lock *);
 extern int posix_unblock_lock(struct file *, struct file_lock *);
 extern int vfs_test_lock(struct file *, struct file_lock *);
+extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *);
 extern int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags);
 extern void lease_get_mtime(struct inode *, struct timespec *time);
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

git-nfs-server-cluster-locking-api.patch
