From: akpm@linux-foundation.org
Subject: + lockd-handle-fl_notify-callbacks.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:41:06 -0700
Message-ID: <200704070541.l375f6gP028416@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965365AbXDGFlV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     lockd: handle fl_notify callbacks
has been added to the -mm tree.  Its filename is
     lockd-handle-fl_notify-callbacks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockd: handle fl_notify callbacks
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Add code to handle file system callback when the lock is finally granted.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svclock.c |   80 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 6 deletions(-)

diff -puN fs/lockd/svclock.c~lockd-handle-fl_notify-callbacks fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~lockd-handle-fl_notify-callbacks
+++ a/fs/lockd/svclock.c
@@ -260,6 +260,8 @@ static void nlmsvc_free_block(struct kre
 	nlmsvc_freegrantargs(block->b_call);
 	nlm_release_call(block->b_call);
 	nlm_release_file(block->b_file);
+	if (block->b_fl)
+		kfree(block->b_fl);
 	kfree(block);
 }
 
@@ -527,6 +529,32 @@ nlmsvc_cancel_blocked(struct nlm_file *f
 }
 
 /*
+ * This is a callback from the filesystem for VFS file lock requests.
+ * It will be used if fl_notify is defined and the filesystem can not
+ * respond to the request immediately.
+ * For GETLK request it will copy the reply to the nlm_block.
+ * For SETLK or SETLKW request it will get the local posix lock.
+ * In all cases it will move the block to the head of nlm_blocked q where
+ * nlmsvc_retry_blocked() can send back a reply for SETLKW or revisit the
+ * deferred rpc for GETLK and SETLK.
+ */
+static void
+nlmsvc_update_deferred_block(struct nlm_block *block, struct file_lock *conf,
+			     int result)
+{
+	block->b_flags |= B_GOT_CALLBACK;
+	if (result == 0)
+		block->b_granted = 1;
+	else
+		block->b_flags |= B_TOO_LATE;
+	if (conf) {
+		block->b_fl = kzalloc(sizeof(struct file_lock), GFP_KERNEL);
+		if (block->b_fl)
+			locks_copy_lock(block->b_fl, conf);
+	}
+}
+
+/*
  * Unblock a blocked lock request. This is a callback invoked from the
  * VFS layer when a lock on which we blocked is removed.
  *
@@ -537,18 +565,35 @@ static int
 nlmsvc_notify_blocked(struct file_lock *fl, struct file_lock *conf, int result)
 {
 	struct nlm_block	*block;
+	int rc = -ENOENT;
 
 	dprintk("lockd: nlmsvc_notify_blocked lock %p conf %p result %d\n",
 							fl, conf, result);
+	lock_kernel();
 	list_for_each_entry(block, &nlm_blocked, b_list) {
 		if (nlm_compare_locks(&block->b_call->a_args.lock.fl, fl)) {
+			dprintk("lockd: nlmsvc_notify_blocked block %p flags %d\n",
+							block, block->b_flags);
+			if (block->b_flags & B_QUEUED) {
+				if (block->b_flags & B_TOO_LATE) {
+					rc = -ENOLCK;
+					break;
+				}
+				nlmsvc_update_deferred_block(block, conf, result);
+			} else if (result == 0)
+				block->b_granted = 1;
+
 			nlmsvc_insert_block(block, 0);
 			svc_wake_up(block->b_daemon);
-			return;
+			rc = 0;
+			break;
 		}
 	}
+	unlock_kernel();
 
-	printk(KERN_WARNING "lockd: notification for unknown block!\n");
+	if (rc == -ENOENT)
+		printk(KERN_WARNING "lockd: notification for unknown block!\n");
+	return rc;
 }
 
 static int nlmsvc_same_owner(struct file_lock *fl1, struct file_lock *fl2)
@@ -581,6 +626,8 @@ nlmsvc_grant_blocked(struct nlm_block *b
 
 	dprintk("lockd: grant blocked lock %p\n", block);
 
+	kref_get(&block->b_count);
+
 	/* Unlink block request from list */
 	nlmsvc_unlink_block(block);
 
@@ -603,11 +650,13 @@ nlmsvc_grant_blocked(struct nlm_block *b
 	case -EAGAIN:
 		dprintk("lockd: lock still blocked\n");
 		nlmsvc_insert_block(block, NLM_NEVER);
+		nlmsvc_release_block(block);
 		return;
 	default:
 		printk(KERN_WARNING "lockd: unexpected error %d in %s!\n",
 				-error, __FUNCTION__);
 		nlmsvc_insert_block(block, 10 * HZ);
+		nlmsvc_release_block(block);
 		return;
 	}
 
@@ -620,7 +669,6 @@ callback:
 	nlmsvc_insert_block(block, 30 * HZ);
 
 	/* Call the client */
-	kref_get(&block->b_count);
 	nlm_async_call(block->b_call, NLMPROC_GRANTED_MSG, &nlmsvc_grant_ops);
 }
 
@@ -693,6 +741,23 @@ nlmsvc_grant_reply(struct nlm_cookie *co
 	nlmsvc_release_block(block);
 }
 
+/* Helper function to handle retry of a deferred block.
+ * If it is a blocking lock, call grant_blocked.
+ * For a non-blocking lock or test lock, revisit the request.
+ */
+static void
+retry_deferred_block(struct nlm_block *block)
+{
+	if (!(block->b_flags & B_GOT_CALLBACK))
+		block->b_flags |= B_TOO_LATE;
+	nlmsvc_insert_block(block, NLM_TIMEOUT);
+	dprintk("revisit block %p flags %d\n",	block, block->b_flags);
+	if (block->b_deferred_req) {
+		block->b_deferred_req->revisit(block->b_deferred_req, 0);
+		block->b_deferred_req = NULL;
+	}
+}
+
 /*
  * Retry all blocked locks that have been notified. This is where lockd
  * picks up locks that can be granted, or grant notifications that must
@@ -716,9 +781,12 @@ nlmsvc_retry_blocked(void)
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
 			block, block->b_when);
-		kref_get(&block->b_count);
-		nlmsvc_grant_blocked(block);
-		nlmsvc_release_block(block);
+		if (block->b_flags & B_QUEUED) {
+			dprintk("nlmsvc_retry_blocked delete block (%p, granted=%d, flags=%d)\n",
+				block, block->b_granted, block->b_flags);
+			retry_deferred_block(block);
+		} else
+			nlmsvc_grant_blocked(block);
 	}
 
 	return timeout;
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
