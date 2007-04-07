From: akpm@linux-foundation.org
Subject: + lockd-always-preallocate-block-in-nlmsvc_lock.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:41:12 -0700
Message-ID: <200704070541.l375fCTg028426@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45369 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965397AbXDGFl1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     lockd: always preallocate block in nlmsvc_lock()
has been added to the -mm tree.  Its filename is
     lockd-always-preallocate-block-in-nlmsvc_lock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockd: always preallocate block in nlmsvc_lock()
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Normally we could skip ever having to allocate a block in the case where the
client asks for a non-blocking lock, or asks for a blocking lock that succeeds
immediately.

However we're going to want to always look up a block first in order to check
whether we're revisiting a deferred lock call, and to be prepared to handle
the case where the filesystem returns -EINPROGRESS--in that case we want to
make sure the lock we've given the filesystem is the one embedded in the block
that we'll use to track the deferred request.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svclock.c |   34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff -puN fs/lockd/svclock.c~lockd-always-preallocate-block-in-nlmsvc_lock fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~lockd-always-preallocate-block-in-nlmsvc_lock
+++ a/fs/lockd/svclock.c
@@ -369,7 +369,7 @@ __be32
 nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 			struct nlm_lock *lock, int wait, struct nlm_cookie *cookie)
 {
-	struct nlm_block	*block, *newblock = NULL;
+	struct nlm_block	*block = NULL;
 	int			error;
 	__be32			ret;
 
@@ -382,17 +382,20 @@ nlmsvc_lock(struct svc_rqst *rqstp, stru
 				wait);
 
 
-	lock->fl.fl_flags &= ~FL_SLEEP;
-again:
 	/* Lock file against concurrent access */
 	mutex_lock(&file->f_mutex);
-	/* Get existing block (in case client is busy-waiting) */
+	/* Get existing block (in case client is busy-waiting)
+	 * or create new block
+	 */
 	block = nlmsvc_lookup_block(file, lock);
 	if (block == NULL) {
-		if (newblock != NULL)
-			lock = &newblock->b_call->a_args.lock;
-	} else
+		block = nlmsvc_create_block(rqstp, file, lock, cookie, 0);
+		ret = nlm_lck_denied_nolocks;
+		if (block == NULL)
+			goto out;
 		lock = &block->b_call->a_args.lock;
+	} else
+		lock->fl.fl_flags &= ~FL_SLEEP;
 
 	error = posix_lock_file(file->f_file, &lock->fl, NULL);
 	lock->fl.fl_flags &= ~FL_SLEEP;
@@ -418,26 +421,11 @@ again:
 		goto out;
 
 	ret = nlm_lck_blocked;
-	if (block != NULL)
-		goto out;
-
-	/* If we don't have a block, create and initialize it. Then
-	 * retry because we may have slept in kmalloc. */
-	/* We have to release f_mutex as nlmsvc_create_block may try to
-	 * to claim it while doing host garbage collection */
-	if (newblock == NULL) {
-		mutex_unlock(&file->f_mutex);
-		dprintk("lockd: blocking on this lock (allocating).\n");
-		if (!(newblock = nlmsvc_create_block(rqstp, file, lock, cookie, 0)))
-			return nlm_lck_denied_nolocks;
-		goto again;
-	}
 
 	/* Append to list of blocked */
-	nlmsvc_insert_block(newblock, NLM_NEVER);
+	nlmsvc_insert_block(block, NLM_NEVER);
 out:
 	mutex_unlock(&file->f_mutex);
-	nlmsvc_release_block(newblock);
 	nlmsvc_release_block(block);
 	dprintk("lockd: nlmsvc_lock returned %u\n", ret);
 	return ret;
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
