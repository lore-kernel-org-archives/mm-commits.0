From: akpm@linux-foundation.org
Subject: - lockd-handle-test_lock-deferrals.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:41 -0700
Message-ID: <200704200638.l3K6cfpj008779@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423032AbXDTGi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     lockd: handle test_lock deferrals
has been removed from the -mm tree.  Its filename was
     lockd-handle-test_lock-deferrals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockd: handle test_lock deferrals
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

Rewrite nlmsvc_testlock() to use the new asynchronous interface: instead of
immediately doing a posix_test_lock(), we first look for a matching block.  If
the subsequent test_lock returns anything other than -EINPROGRESS, we then
remove the block we've found and return the results.

If it returns -EINPROGRESS, then we defer the lock request.

In the case where the block we find in the first step has B_QUEUED set,
we bypass the vfs_test_lock entirely, instead using the block to decide how
to respond:
	with nlm_lck_denied if B_TOO_LATE is set.
	with nlm_granted if B_GOT_CALLBACK is set.
	by dropping if neither B_TOO_LATE nor B_GOT_CALLBACK is set

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svc4proc.c |    2 +
 fs/lockd/svclock.c  |   83 +++++++++++++++++++++++++++++++++---------
 fs/lockd/svcproc.c  |    3 +
 3 files changed, 71 insertions(+), 17 deletions(-)

diff -puN fs/lockd/svc4proc.c~lockd-handle-test_lock-deferrals fs/lockd/svc4proc.c
--- a/fs/lockd/svc4proc.c~lockd-handle-test_lock-deferrals
+++ a/fs/lockd/svc4proc.c
@@ -100,6 +100,8 @@ nlm4svc_proc_test(struct svc_rqst *rqstp
 
 	/* Now check for conflicting locks */
 	resp->status = nlmsvc_testlock(rqstp, file, &argp->lock, &resp->lock, &resp->cookie);
+	if (resp->status == nlm_drop_reply)
+		return rpc_drop_reply;
 
 	dprintk("lockd: TEST4          status %d\n", ntohl(resp->status));
 	nlm_release_host(host);
diff -puN fs/lockd/svclock.c~lockd-handle-test_lock-deferrals fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~lockd-handle-test_lock-deferrals
+++ a/fs/lockd/svclock.c
@@ -173,7 +173,7 @@ found:
  */
 static inline struct nlm_block *
 nlmsvc_create_block(struct svc_rqst *rqstp, struct nlm_file *file,
-				struct nlm_lock *lock, struct nlm_cookie *cookie)
+		struct nlm_lock *lock, struct nlm_cookie *cookie, int conf)
 {
 	struct nlm_block	*block;
 	struct nlm_host		*host;
@@ -206,6 +206,11 @@ nlmsvc_create_block(struct svc_rqst *rqs
 
 	dprintk("lockd: created block %p...\n", block);
 
+	if (conf) {
+		block->b_fl = kzalloc(sizeof(struct file_lock), GFP_KERNEL);
+		if (!block->b_fl)
+			goto failed_free;
+	}
 	/* Create and initialize the block */
 	block->b_daemon = rqstp->rq_server;
 	block->b_host   = host;
@@ -424,7 +429,7 @@ again:
 	if (newblock == NULL) {
 		mutex_unlock(&file->f_mutex);
 		dprintk("lockd: blocking on this lock (allocating).\n");
-		if (!(newblock = nlmsvc_create_block(rqstp, file, lock, cookie)))
+		if (!(newblock = nlmsvc_create_block(rqstp, file, lock, cookie, 0)))
 			return nlm_lck_denied_nolocks;
 		goto again;
 	}
@@ -447,6 +452,10 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
 		struct nlm_lock *lock, struct nlm_lock *conflock,
 		struct nlm_cookie *cookie)
 {
+	struct nlm_block 	*block = NULL;
+	int			error;
+	__be32			ret;
+
 	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
 				file->f_file->f_path.dentry->d_inode->i_sb->s_id,
 				file->f_file->f_path.dentry->d_inode->i_ino,
@@ -454,22 +463,63 @@ nlmsvc_testlock(struct svc_rqst *rqstp, 
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
 
-	if (posix_test_lock(file->f_file, &lock->fl)) {
-		dprintk("lockd: conflicting lock(ty=%d, %Ld-%Ld)\n",
-				lock->fl.fl_type,
-				(long long)lock->fl.fl_start,
-				(long long)lock->fl.fl_end);
-		conflock->caller = "somehost";	/* FIXME */
-		conflock->len = strlen(conflock->caller);
-		conflock->oh.len = 0;		/* don't return OH info */
-		conflock->svid = lock->fl.fl_pid;
-		conflock->fl.fl_type = lock->fl.fl_type;
-		conflock->fl.fl_start = lock->fl.fl_start;
-		conflock->fl.fl_end = lock->fl.fl_end;
-		return nlm_lck_denied;
+	/* Get existing block (in case client is busy-waiting) */
+	block = nlmsvc_lookup_block(file, lock);
+
+	if (block == NULL) {
+		block = nlmsvc_create_block(rqstp, file, lock, cookie, 1);
+		if (block == NULL)
+			return nlm_granted;
+	}
+	if (block->b_flags & B_QUEUED) {
+		dprintk("lockd: nlmsvc_testlock deferred block %p flags %d fl %p\n",
+			block, block->b_flags, block->b_fl);
+		if (block->b_flags & B_TOO_LATE) {
+			nlmsvc_unlink_block(block);
+			return nlm_lck_denied;
+		}
+		if (block->b_flags & B_GOT_CALLBACK) {
+			if (block->b_fl != NULL
+					&& block->b_fl->fl_type != F_UNLCK) {
+				lock->fl = *block->b_fl;
+				goto conf_lock;
+			}
+			else {
+				nlmsvc_unlink_block(block);
+				return nlm_granted;
+			}
+		}
+		return nlm_drop_reply;
 	}
 
-	return nlm_granted;
+	error = vfs_test_lock(file->f_file, &lock->fl);
+	if (error == -EINPROGRESS)
+		return nlmsvc_defer_lock_rqst(rqstp, block);
+	if (error) {
+		ret = nlm_lck_denied_nolocks;
+		goto out;
+	}
+	if (lock->fl.fl_type == F_UNLCK) {
+		ret = nlm_granted;
+		goto out;
+	}
+
+conf_lock:
+	dprintk("lockd: conflicting lock(ty=%d, %Ld-%Ld)\n",
+		lock->fl.fl_type, (long long)lock->fl.fl_start,
+		(long long)lock->fl.fl_end);
+	conflock->caller = "somehost";	/* FIXME */
+	conflock->len = strlen(conflock->caller);
+	conflock->oh.len = 0;		/* don't return OH info */
+	conflock->svid = lock->fl.fl_pid;
+	conflock->fl.fl_type = lock->fl.fl_type;
+	conflock->fl.fl_start = lock->fl.fl_start;
+	conflock->fl.fl_end = lock->fl.fl_end;
+	ret = nlm_lck_denied;
+out:
+	if (block)
+		nlmsvc_release_block(block);
+	return ret;
 }
 
 /*
@@ -550,7 +600,6 @@ nlmsvc_update_deferred_block(struct nlm_
 	else
 		block->b_flags |= B_TOO_LATE;
 	if (conf) {
-		block->b_fl = kzalloc(sizeof(struct file_lock), GFP_KERNEL);
 		if (block->b_fl)
 			locks_copy_lock(block->b_fl, conf);
 	}
diff -puN fs/lockd/svcproc.c~lockd-handle-test_lock-deferrals fs/lockd/svcproc.c
--- a/fs/lockd/svcproc.c~lockd-handle-test_lock-deferrals
+++ a/fs/lockd/svcproc.c
@@ -33,6 +33,7 @@ cast_to_nlm(__be32 status, u32 vers)
 		case nlm_lck_denied_nolocks:
 		case nlm_lck_blocked:
 		case nlm_lck_denied_grace_period:
+		case nlm_drop_reply:
 			break;
 		case nlm4_deadlock:
 			status = nlm_lck_denied;
@@ -128,6 +129,8 @@ nlmsvc_proc_test(struct svc_rqst *rqstp,
 
 	/* Now check for conflicting locks */
 	resp->status = cast_status(nlmsvc_testlock(rqstp, file, &argp->lock, &resp->lock, &resp->cookie));
+	if (resp->status == nlm_drop_reply)
+		return rpc_drop_reply;
 
 	dprintk("lockd: TEST          status %d vers %d\n",
 		ntohl(resp->status), rqstp->rq_vers);
_

Patches currently in -mm which might be from eshel@almaden.ibm.com are

git-nfs-server-cluster-locking-api.patch
