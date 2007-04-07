From: akpm@linux-foundation.org
Subject: + lockd-save-lock-state-on-deferral.patch added to -mm tree
Date: Fri, 06 Apr 2007 22:41:04 -0700
Message-ID: <200704070541.l375f4sd028413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45357 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965365AbXDGFlT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 01:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no


The patch titled
     lockd: save lock state on deferral
has been added to the -mm tree.  Its filename is
     lockd-save-lock-state-on-deferral.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lockd: save lock state on deferral
From: Marc Eshel <eshel@almaden.ibm.com> - unquoted

We need to keep some state for a pending asynchronous lock request, so this
patch adds that state to struct nlm_block.

This also adds a function which defers the request, by calling
rqstp->rq_chandle.defer and storing the resulting deferred request in a
nlm_block structure which we insert into lockd's global block list.  That new
function isn't called yet, so it's dead code until a later patch.

Signed-off-by: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jan Kara <jack@ucw.cz>
Cc: Marc Eshel <eshel@almaden.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/lockd/svclock.c          |   25 +++++++++++++++++++++++++
 include/linux/lockd/lockd.h |   10 ++++++++++
 2 files changed, 35 insertions(+)

diff -puN fs/lockd/svclock.c~lockd-save-lock-state-on-deferral fs/lockd/svclock.c
--- a/fs/lockd/svclock.c~lockd-save-lock-state-on-deferral
+++ a/fs/lockd/svclock.c
@@ -330,6 +330,31 @@ static void nlmsvc_freegrantargs(struct 
 }
 
 /*
+ * Deferred lock request handling for non-blocking lock
+ */
+static u32
+nlmsvc_defer_lock_rqst(struct svc_rqst *rqstp, struct nlm_block *block)
+{
+	u32 status = nlm_lck_denied_nolocks;
+
+	block->b_flags |= B_QUEUED;
+
+	nlmsvc_insert_block(block, NLM_TIMEOUT);
+
+	block->b_cache_req = &rqstp->rq_chandle;
+	if (rqstp->rq_chandle.defer) {
+		block->b_deferred_req =
+			rqstp->rq_chandle.defer(block->b_cache_req);
+		if (block->b_deferred_req != NULL)
+			status = nlm_drop_reply;
+	}
+	dprintk("lockd: nlmsvc_defer_lock_rqst block %p flags %d status %d\n",
+		block, block->b_flags, status);
+
+	return status;
+}
+
+/*
  * Attempt to establish a lock, and if it can't be granted, block it
  * if required.
  */
diff -puN include/linux/lockd/lockd.h~lockd-save-lock-state-on-deferral include/linux/lockd/lockd.h
--- a/include/linux/lockd/lockd.h~lockd-save-lock-state-on-deferral
+++ a/include/linux/lockd/lockd.h
@@ -119,6 +119,9 @@ struct nlm_file {
  * couldn't be granted because of a conflicting lock).
  */
 #define NLM_NEVER		(~(unsigned long) 0)
+/* timeout on non-blocking call: */
+#define NLM_TIMEOUT		(7 * HZ)
+
 struct nlm_block {
 	struct kref		b_count;	/* Reference count */
 	struct list_head	b_list;		/* linked list of all blocks */
@@ -130,6 +133,13 @@ struct nlm_block {
 	unsigned int		b_id;		/* block id */
 	unsigned char		b_granted;	/* VFS granted lock */
 	struct nlm_file *	b_file;		/* file in question */
+	struct cache_req *	b_cache_req;	/* deferred request handling */
+	struct file_lock *	b_fl;		/* set for GETLK */
+	struct cache_deferred_req * b_deferred_req;
+	unsigned int		b_flags;	/* block flags */
+#define B_QUEUED		1	/* lock queued */
+#define B_GOT_CALLBACK		2	/* got lock or conflicting lock */
+#define B_TOO_LATE		4	/* too late for non-blocking lock */
 };
 
 /*
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
