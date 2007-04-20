From: akpm@linux-foundation.org
Subject: - lockd-save-lock-state-on-deferral.patch removed from -mm tree
Date: Thu, 19 Apr 2007 23:38:35 -0700
Message-ID: <200704200638.l3K6cZ29008770@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423030AbXDTGiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 02:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eshel@almaden.ibm.com, bfields@citi.umich.edu, jack@ucw.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     lockd: save lock state on deferral
has been removed from the -mm tree.  Its filename was
     lockd-save-lock-state-on-deferral.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -331,6 +331,31 @@ static void nlmsvc_freegrantargs(struct 
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

git-nfs-server-cluster-locking-api.patch
