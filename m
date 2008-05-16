From: akpm@linux-foundation.org
Subject: + locks-add-special-return-value-for-asynchronous-locks.patch added to -mm tree
Date: Thu, 15 May 2008 17:16:05 -0700
Message-ID: <200805160016.m4G0G5tI017758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYEPAQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, bfields@fieldses.org, hch@lst.de, matthew@wil.cx, teigland@redhat.com, trond.myklebust@fys.uio.no


The patch titled
     locks: add special return value for asynchronous locks
has been added to the -mm tree.  Its filename is
     locks-add-special-return-value-for-asynchronous-locks.patch

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
Subject: locks: add special return value for asynchronous locks
From: Miklos Szeredi <mszeredi@suse.cz>

Use a special error value FILE_LOCK_DEFERRED to mean that a locking
operation returned asynchronously.  This is returned by

  posix_lock_file() for sleeping locks to mean that the lock has been
  queued on the block list, and will be woken up when it might become
  available and needs to be retried (either fl_lmops->fl_notify() is
  called or fl_wait is woken up).

  f_op->lock() to mean either the above, or that the filesystem will
  call back with fl_lmops->fl_grant() when the result of the locking
  operation is known.  The filesystem can do this for sleeping as well
  as non-sleeping locks.

This is to make sure, that return values of -EAGAIN and -EINPROGRESS by
filesystems are not mistaken to mean an asynchronous locking.

This also makes error handling in fs/locks.c and lockd/svclock.c slightly
cleaner.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: David Teigland <teigland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/plock.c     |    2 +-
 fs/lockd/svclock.c |   13 ++++---------
 fs/locks.c         |   28 ++++++++++++++--------------
 include/linux/fs.h |    6 ++++++
 4 files changed, 25 insertions(+), 24 deletions(-)

diff -puN fs/dlm/plock.c~locks-add-special-return-value-for-asynchronous-locks fs/dlm/plock.c
--- a/fs/dlm/plock.c~locks-add-special-return-value-for-asynchronous-locks
+++ a/fs/dlm/plock.c
@@ -116,7 +116,7 @@ int dlm_posix_lock(dlm_lockspace_t *lock
 	if (xop->callback == NULL)
 		wait_event(recv_wq, (op->done != 0));
 	else {
-		rv = -EINPROGRESS;
+		rv = FILE_LOCK_DEFERRED;
 		goto out;
 	}
 
diff -puN fs/lockd/svclock.c~locks-add-special-return-value-for-asynchronous-locks fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~locks-add-special-return-value-for-asynchronous-locks
+++ a/fs/lockd/svclock.c
@@ -423,8 +423,8 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 			goto out;
 		case -EAGAIN:
 			ret = nlm_lck_denied;
-			break;
-		case -EINPROGRESS:
+			goto out;
+		case FILE_LOCK_DEFERRED:
 			if (wait)
 				break;
 			/* Filesystem lock operation is in progress
@@ -439,10 +439,6 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 			goto out;
 	}
 
-	ret = nlm_lck_denied;
-	if (!wait)
-		goto out;
-
 	ret = nlm_lck_blocked;
 
 	/* Append to list of blocked */
@@ -520,7 +516,7 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
 	}
 
 	error = vfs_test_lock(file->f_file, &lock->fl);
-	if (error == -EINPROGRESS) {
+	if (error == FILE_LOCK_DEFERRED) {
 		ret = nlmsvc_defer_lock_rqst(rqstp, block);
 		goto out;
 	}
@@ -744,8 +740,7 @@ nlmsvc_grant_blocked(struct nlm_block *b
 	switch (error) {
 	case 0:
 		break;
-	case -EAGAIN:
-	case -EINPROGRESS:
+	case FILE_LOCK_DEFERRED:
 		dprintk("lockd: lock still blocked error %d\n", error);
 		nlmsvc_insert_block(block, NLM_NEVER);
 		nlmsvc_release_block(block);
diff -puN fs/locks.c~locks-add-special-return-value-for-asynchronous-locks fs/locks.c
--- a/fs/locks.c~locks-add-special-return-value-for-asynchronous-locks
+++ a/fs/locks.c
@@ -785,8 +785,10 @@ find_conflict:
 		if (!flock_locks_conflict(request, fl))
 			continue;
 		error = -EAGAIN;
-		if (request->fl_flags & FL_SLEEP)
-			locks_insert_block(fl, request);
+		if (!(request->fl_flags & FL_SLEEP))
+			goto out;
+		error = FILE_LOCK_DEFERRED;
+		locks_insert_block(fl, request);
 		goto out;
 	}
 	if (request->fl_flags & FL_ACCESS)
@@ -842,7 +844,7 @@ static int __posix_lock_file(struct inod
 			error = -EDEADLK;
 			if (posix_locks_deadlock(request, fl))
 				goto out;
-			error = -EAGAIN;
+			error = FILE_LOCK_DEFERRED;
 			locks_insert_block(fl, request);
 			goto out;
   		}
@@ -1041,7 +1043,7 @@ int posix_lock_file_wait(struct file *fi
 	might_sleep ();
 	for (;;) {
 		error = posix_lock_file(filp, fl, NULL);
-		if ((error != -EAGAIN) || !(fl->fl_flags & FL_SLEEP))
+		if (error != FILE_LOCK_DEFERRED)
 			break;
 		error = wait_event_interruptible(fl->fl_wait, !fl->fl_next);
 		if (!error)
@@ -1113,9 +1115,7 @@ int locks_mandatory_area(int read_write,
 
 	for (;;) {
 		error = __posix_lock_file(inode, &fl, NULL);
-		if (error != -EAGAIN)
-			break;
-		if (!(fl.fl_flags & FL_SLEEP))
+		if (error != FILE_LOCK_DEFERRED)
 			break;
 		error = wait_event_interruptible(fl.fl_wait, !fl.fl_next);
 		if (!error) {
@@ -1537,7 +1537,7 @@ int flock_lock_file_wait(struct file *fi
 	might_sleep();
 	for (;;) {
 		error = flock_lock_file(filp, fl);
-		if ((error != -EAGAIN) || !(fl->fl_flags & FL_SLEEP))
+		if (error != FILE_LOCK_DEFERRED)
 			break;
 		error = wait_event_interruptible(fl->fl_wait, !fl->fl_next);
 		if (!error)
@@ -1722,17 +1722,17 @@ out:
  * fl_grant is set. Callers expecting ->lock() to return asynchronously
  * will only use F_SETLK, not F_SETLKW; they will set FL_SLEEP if (and only if)
  * the request is for a blocking lock. When ->lock() does return asynchronously,
- * it must return -EINPROGRESS, and call ->fl_grant() when the lock
+ * it must return FILE_LOCK_DEFERRED, and call ->fl_grant() when the lock
  * request completes.
  * If the request is for non-blocking lock the file system should return
- * -EINPROGRESS then try to get the lock and call the callback routine with
- * the result. If the request timed out the callback routine will return a
+ * FILE_LOCK_DEFERRED then try to get the lock and call the callback routine
+ * with the result. If the request timed out the callback routine will return a
  * nonzero return code and the file system should release the lock. The file
  * system is also responsible to keep a corresponding posix lock when it
  * grants a lock so the VFS can find out which locks are locally held and do
  * the correct lock cleanup when required.
  * The underlying filesystem must not drop the kernel lock or call
- * ->fl_grant() before returning to the caller with a -EINPROGRESS
+ * ->fl_grant() before returning to the caller with a FILE_LOCK_DEFERRED
  * return code.
  */
 int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl, struct file_lock *conf)
@@ -1810,7 +1810,7 @@ again:
 	else {
 		for (;;) {
 			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != -EAGAIN || cmd == F_SETLK)
+			if (error != FILE_LOCK_DEFERRED)
 				break;
 			error = wait_event_interruptible(file_lock->fl_wait,
 					!file_lock->fl_next);
@@ -1947,7 +1947,7 @@ again:
 	else {
 		for (;;) {
 			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != -EAGAIN || cmd == F_SETLK64)
+			if (error != FILE_LOCK_DEFERRED)
 				break;
 			error = wait_event_interruptible(file_lock->fl_wait,
 					!file_lock->fl_next);
diff -puN include/linux/fs.h~locks-add-special-return-value-for-asynchronous-locks include/linux/fs.h
--- a/include/linux/fs.h~locks-add-special-return-value-for-asynchronous-locks
+++ a/include/linux/fs.h
@@ -892,6 +892,12 @@ static inline int file_check_writeable(s
 #define FL_SLEEP	128	/* A blocking lock */
 
 /*
+ * Special return value from posix_lock_file() and vfs_lock_file() for
+ * asynchronous locking.
+ */
+#define FILE_LOCK_DEFERRED 1
+
+/*
  * The POSIX file lock owner is determined by
  * the "struct files_struct" in the thread group
  * (or NULL for no owner - BSD locks).
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
mm-fix-infinite-loop-in-filemap_fault.patch
git-vfs-cleanups.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

