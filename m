From: akpm@linux-foundation.org
Subject: + lockd-pass-cookie-in-nlmsvc_testlock.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:41:08 -0700
Message-ID: <200704070541.l375f877028419@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965414AbXDGFl3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     lockd: pass cookie in nlmsvc_testlock
has been added to the -mm tree.  Its filename is
     lockd-pass-cookie-in-nlmsvc_testlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockd: pass cookie in nlmsvc_testlock
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Change NLM internal interface to pass more information for test lock; we need
this to make sure the cookie information is pushed down to the place where we
do request deferral, which is handled for testlock by the following patch.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc4proc.c         |    2 +-
 fs/lockd/svclock.c          |    5 +++--
 fs/lockd/svcproc.c          |    2 +-
 include/linux/lockd/lockd.h |    4 ++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/lockd/svc4proc.c~lockd-pass-cookie-in-nlmsvc_testlock fs/lockd/svc4proc.c
--- a/fs/lockd/svc4proc.c~lockd-pass-cookie-in-nlmsvc_testlock
+++ a/fs/lockd/svc4proc.c
@@ -99,7 +99,7 @@ nlm4svc_proc_test(struct svc_rqst *rqstp
 		return resp->status == nlm_drop_reply ? rpc_drop_reply :rpc_success;
 
 	/* Now check for conflicting locks */
-	resp->status = nlmsvc_testlock(file, &argp->lock, &resp->lock);
+	resp->status = nlmsvc_testlock(rqstp, file, &argp->lock, &resp->lock, &resp->cookie);
 
 	dprintk("lockd: TEST4          status %d\n", ntohl(resp->status));
 	nlm_release_host(host);
diff -puN fs/lockd/svclock.c~lockd-pass-cookie-in-nlmsvc_testlock fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~lockd-pass-cookie-in-nlmsvc_testlock
+++ a/fs/lockd/svclock.c
@@ -442,8 +442,9 @@ out:
  * Test for presence of a conflicting lock.
  */
 __be32
-nlmsvc_testlock(struct nlm_file *file, struct nlm_lock *lock,
-				       struct nlm_lock *conflock)
+nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
+		struct nlm_lock *lock, struct nlm_lock *conflock,
+		struct nlm_cookie *cookie)
 {
 	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
 				file->f_file->f_path.dentry->d_inode->i_sb->s_id,
diff -puN fs/lockd/svcproc.c~lockd-pass-cookie-in-nlmsvc_testlock fs/lockd/svcproc.c
--- a/fs/lockd/svcproc.c~lockd-pass-cookie-in-nlmsvc_testlock
+++ a/fs/lockd/svcproc.c
@@ -127,7 +127,7 @@ nlmsvc_proc_test(struct svc_rqst *rqstp,
 		return resp->status == nlm_drop_reply ? rpc_drop_reply :rpc_success;
 
 	/* Now check for conflicting locks */
-	resp->status = cast_status(nlmsvc_testlock(file, &argp->lock, &resp->lock));
+	resp->status = cast_status(nlmsvc_testlock(rqstp, file, &argp->lock, &resp->lock, &resp->cookie));
 
 	dprintk("lockd: TEST          status %d vers %d\n",
 		ntohl(resp->status), rqstp->rq_vers);
diff -puN include/linux/lockd/lockd.h~lockd-pass-cookie-in-nlmsvc_testlock include/linux/lockd/lockd.h
--- a/include/linux/lockd/lockd.h~lockd-pass-cookie-in-nlmsvc_testlock
+++ a/include/linux/lockd/lockd.h
@@ -195,8 +195,8 @@ typedef int	  (*nlm_host_match_fn_t)(str
 __be32		  nlmsvc_lock(struct svc_rqst *, struct nlm_file *,
 					struct nlm_lock *, int, struct nlm_cookie *);
 __be32		  nlmsvc_unlock(struct nlm_file *, struct nlm_lock *);
-__be32		  nlmsvc_testlock(struct nlm_file *, struct nlm_lock *,
-					struct nlm_lock *);
+__be32		  nlmsvc_testlock(struct svc_rqst *, struct nlm_file *,
+			struct nlm_lock *, struct nlm_lock *, struct nlm_cookie *);
 __be32		  nlmsvc_cancel_blocked(struct nlm_file *, struct nlm_lock *);
 unsigned long	  nlmsvc_retry_blocked(void);
 void		  nlmsvc_traverse_blocks(struct nlm_host *, struct nlm_file *,
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
