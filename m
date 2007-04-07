From: akpm@linux-foundation.org
Subject: + lockd-add-code-to-handle-deferred-lock-requests.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:41:14 -0700
Message-ID: <200704070541.l375fEQh028429@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965417AbXDGFl3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     lockd: add code to handle deferred lock requests
has been added to the -mm tree.  Its filename is
     lockd-add-code-to-handle-deferred-lock-requests.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockd: add code to handle deferred lock requests
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Rewrite nlmsvc_lock() to use the asynchronous interface.

As with testlock, we answer nlm requests in nlmsvc_lock by first looking up
the block and then using the results we find in the block if B_QUEUED is set,
and calling vfs_lock_file() otherwise.

If this a new lock request and we get -EINPROGRESS return on a non-blocking
request then we defer the request.

Also modify nlmsvc_unlock() to call the filesystem method if appropriate.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc4proc.c |    2 ++
 fs/lockd/svclock.c  |   39 +++++++++++++++++++++++++++++++++------
 fs/lockd/svcproc.c  |    2 ++
 fs/lockd/svcsubs.c  |    2 +-
 4 files changed, 38 insertions(+), 7 deletions(-)

diff -puN fs/lockd/svc4proc.c~lockd-add-code-to-handle-deferred-lock-requests fs/lockd/svc4proc.c
--- a/fs/lockd/svc4proc.c~lockd-add-code-to-handle-deferred-lock-requests
+++ a/fs/lockd/svc4proc.c
@@ -145,6 +145,8 @@ nlm4svc_proc_lock(struct svc_rqst *rqstp
 	/* Now try to lock the file */
 	resp->status = nlmsvc_lock(rqstp, file, &argp->lock,
 					argp->block, &argp->cookie);
+	if (resp->status == nlm_drop_reply)
+		return rpc_drop_reply;
 
 	dprintk("lockd: LOCK          status %d\n", ntohl(resp->status));
 	nlm_release_host(host);
diff -puN fs/lockd/svclock.c~lockd-add-code-to-handle-deferred-lock-requests fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~lockd-add-code-to-handle-deferred-lock-requests
+++ a/fs/lockd/svclock.c
@@ -397,17 +397,43 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 	} else
 		lock->fl.fl_flags &= ~FL_SLEEP;
 
-	error = posix_lock_file(file->f_file, &lock->fl, NULL);
-	lock->fl.fl_flags &= ~FL_SLEEP;
+	if (block->b_flags & B_QUEUED) {
+		dprintk("lockd: nlmsvc_lock deferred block %p flags %d\n",
+							block, block->b_flags);
+		if (block->b_granted) {
+			nlmsvc_unlink_block(block);
+			ret = nlm_granted;
+			goto out;
+		}
+		if (block->b_flags & B_TOO_LATE) {
+			nlmsvc_unlink_block(block);
+			ret = nlm_lck_denied;
+			goto out;
+		}
+		ret = nlm_drop_reply;
+		goto out;
+	}
 
-	dprintk("lockd: posix_lock_file returned %d\n", error);
+	if (!wait)
+		lock->fl.fl_flags &= ~FL_SLEEP;
+	error = vfs_lock_file(file->f_file, F_SETLK, &lock->fl, NULL);
+	lock->fl.fl_flags &= ~FL_SLEEP;
 
+	dprintk("lockd: vfs_lock_file returned %d\n", error);
 	switch(error) {
 		case 0:
 			ret = nlm_granted;
 			goto out;
 		case -EAGAIN:
+			ret = nlm_lck_denied;
 			break;
+		case -EINPROGRESS:
+			if (wait)
+				break;
+			/* Filesystem lock operation is in progress
+			   Add it to the queue waiting for callback */
+			ret = nlmsvc_defer_lock_rqst(rqstp, block);
+			goto out;
 		case -EDEADLK:
 			ret = nlm_deadlock;
 			goto out;
@@ -532,7 +558,7 @@ nlmsvc_unlock(struct nlm_file *file, str
 	nlmsvc_cancel_blocked(file, lock);
 
 	lock->fl.fl_type = F_UNLCK;
-	error = posix_lock_file(file->f_file, &lock->fl, NULL);
+	error = vfs_lock_file(file->f_file, F_SETLK, &lock->fl, NULL);
 
 	return (error < 0)? nlm_lck_denied_nolocks : nlm_granted;
 }
@@ -679,14 +705,15 @@ nlmsvc_grant_blocked(struct nlm_block *b
 
 	/* Try the lock operation again */
 	lock->fl.fl_flags |= FL_SLEEP;
-	error = posix_lock_file(file->f_file, &lock->fl, NULL);
+	error = vfs_lock_file(file->f_file, F_SETLK, &lock->fl, NULL);
 	lock->fl.fl_flags &= ~FL_SLEEP;
 
 	switch (error) {
 	case 0:
 		break;
 	case -EAGAIN:
-		dprintk("lockd: lock still blocked\n");
+	case -EINPROGRESS:
+		dprintk("lockd: lock still blocked error %d\n", error);
 		nlmsvc_insert_block(block, NLM_NEVER);
 		nlmsvc_release_block(block);
 		return;
diff -puN fs/lockd/svcproc.c~lockd-add-code-to-handle-deferred-lock-requests fs/lockd/svcproc.c
--- a/fs/lockd/svcproc.c~lockd-add-code-to-handle-deferred-lock-requests
+++ a/fs/lockd/svcproc.c
@@ -175,6 +175,8 @@ nlmsvc_proc_lock(struct svc_rqst *rqstp,
 	/* Now try to lock the file */
 	resp->status = cast_status(nlmsvc_lock(rqstp, file, &argp->lock,
 					       argp->block, &argp->cookie));
+	if (resp->status == nlm_drop_reply)
+		return rpc_drop_reply;
 
 	dprintk("lockd: LOCK          status %d\n", ntohl(resp->status));
 	nlm_release_host(host);
diff -puN fs/lockd/svcsubs.c~lockd-add-code-to-handle-deferred-lock-requests fs/lockd/svcsubs.c
--- a/fs/lockd/svcsubs.c~lockd-add-code-to-handle-deferred-lock-requests
+++ a/fs/lockd/svcsubs.c
@@ -182,7 +182,7 @@ again:
 			lock.fl_type  = F_UNLCK;
 			lock.fl_start = 0;
 			lock.fl_end   = OFFSET_MAX;
-			if (posix_lock_file(file->f_file, &lock, NULL) < 0) {
+			if (vfs_lock_file(file->f_file, F_SETLK, &lock, NULL) < 0) {
 				printk("lockd: unlock failure in %s:%d\n",
 						__FILE__, __LINE__);
 				return 1;
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

locks-trivial-removal-of-unnecessary-parentheses.patch
locks-create-posix-to-flock-helper-functions.patch
locks-make-lock-release-private-data-before-returning-in-getlk-case.patch
locks-give-posix_test_lock-same-interface-as-lock.patch
locks-factor-out-generic-filesystem-switch-from-test_lock.patch
locks-factor-out-generic-filesystem-switch-from-setlock-code.patch
locks-allow-vfsposix_lock_file-to-return-conflicting-lock.patch
locks-add-fl_notify-arguments-for-asynchronous-lock-return.patch
locks-add-lock-cancel-command.patch
nfsd4-convert-nfsv4-to-new-lock-interface.patch
lockd-save-lock-state-on-deferral.patch
lockd-handle-fl_notify-callbacks.patch
lockd-pass-cookie-in-nlmsvc_testlock.patch
lockd-handle-test_lock-deferrals.patch
lockd-always-preallocate-block-in-nlmsvc_lock.patch
lockd-add-code-to-handle-deferred-lock-requests.patch
gfs2-nfs-lock-support-for-gfs2.patch
