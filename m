From: akpm@linux-foundation.org
Subject: + xfs-replace-dquot-flush-semaphore-with-a-completion.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:39:16 -0700
Message-ID: <200807111844.m6BIiv9T030916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647AbYGKSpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:45:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fromorbit.com, lachlan@sgi.com, tes@sgi.com


The patch titled
     xfs: replace dquot flush semaphore with a completion
has been added to the -mm tree.  Its filename is
     xfs-replace-dquot-flush-semaphore-with-a-completion.patch

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
Subject: xfs: replace dquot flush semaphore with a completion
From: Dave Chinner <david@fromorbit.com>

Use the new completion flush code to implement the dquot flush lock.  Removes
one of the final users of semaphores in the XFS code base.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/quota/xfs_dquot.c      |   34 +++++++++++---------------------
 fs/xfs/quota/xfs_dquot.h      |   29 ++++++++++++++++-----------
 fs/xfs/quota/xfs_dquot_item.c |    8 +++----
 fs/xfs/quota/xfs_qm.c         |    8 +++----
 4 files changed, 38 insertions(+), 41 deletions(-)

diff -puN fs/xfs/quota/xfs_dquot.c~xfs-replace-dquot-flush-semaphore-with-a-completion fs/xfs/quota/xfs_dquot.c
--- a/fs/xfs/quota/xfs_dquot.c~xfs-replace-dquot-flush-semaphore-with-a-completion
+++ a/fs/xfs/quota/xfs_dquot.c
@@ -101,9 +101,16 @@ xfs_qm_dqinit(
 	if (brandnewdquot) {
 		dqp->dq_flnext = dqp->dq_flprev = dqp;
 		mutex_init(&dqp->q_qlock);
-		initnsema(&dqp->q_flock, 1, "fdq");
 		sv_init(&dqp->q_pinwait, SV_DEFAULT, "pdq");
 
+		/*
+		 * Because we want to use a counting completion, complete
+		 * the flush completion once to allow a single access to
+		 * the flush completion without blocking.
+		 */
+		init_completion(&dqp->q_flush);
+		complete(&dqp->q_flush);
+
 #ifdef XFS_DQUOT_TRACE
 		dqp->q_trace = ktrace_alloc(DQUOT_TRACE_SIZE, KM_SLEEP);
 		xfs_dqtrace_entry(dqp, "DQINIT");
@@ -150,7 +157,6 @@ xfs_qm_dqdestroy(
 	ASSERT(! XFS_DQ_IS_ON_FREELIST(dqp));
 
 	mutex_destroy(&dqp->q_qlock);
-	freesema(&dqp->q_flock);
 	sv_destroy(&dqp->q_pinwait);
 
 #ifdef XFS_DQUOT_TRACE
@@ -1211,7 +1217,7 @@ xfs_qm_dqflush(
 	int			error;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	ASSERT(XFS_DQ_IS_FLUSH_LOCKED(dqp));
+	ASSERT(!completion_done(&dqp->q_flush));
 	xfs_dqtrace_entry(dqp, "DQFLUSH");
 
 	/*
@@ -1348,34 +1354,18 @@ xfs_qm_dqflush_done(
 	xfs_dqfunlock(dqp);
 }
 
-
-int
-xfs_qm_dqflock_nowait(
-	xfs_dquot_t *dqp)
-{
-	int locked;
-
-	locked = cpsema(&((dqp)->q_flock));
-
-	/* XXX ifdef these out */
-	if (locked)
-		(dqp)->dq_flags |= XFS_DQ_FLOCKED;
-	return (locked);
-}
-
-
 int
 xfs_qm_dqlock_nowait(
 	xfs_dquot_t *dqp)
 {
-	return (mutex_trylock(&((dqp)->q_qlock)));
+	return mutex_trylock(&dqp->q_qlock);
 }
 
 void
 xfs_dqlock(
 	xfs_dquot_t *dqp)
 {
-	mutex_lock(&(dqp->q_qlock));
+	mutex_lock(&dqp->q_qlock);
 }
 
 void
@@ -1468,7 +1458,7 @@ xfs_qm_dqpurge(
 	 * if we're turning off quotas. Basically, we need this flush
 	 * lock, and are willing to block on it.
 	 */
-	if (! xfs_qm_dqflock_nowait(dqp)) {
+	if (!xfs_dqflock_nowait(dqp)) {
 		/*
 		 * Block on the flush lock after nudging dquot buffer,
 		 * if it is incore.
diff -puN fs/xfs/quota/xfs_dquot.h~xfs-replace-dquot-flush-semaphore-with-a-completion fs/xfs/quota/xfs_dquot.h
--- a/fs/xfs/quota/xfs_dquot.h~xfs-replace-dquot-flush-semaphore-with-a-completion
+++ a/fs/xfs/quota/xfs_dquot.h
@@ -82,7 +82,7 @@ typedef struct xfs_dquot {
 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
 	mutex_t		 q_qlock;	/* quota lock */
-	sema_t		 q_flock;	/* flush lock */
+	struct completion q_flush;	/* flush completion queue */
 	uint		 q_pincount;	/* pin count for this dquot */
 	sv_t		 q_pinwait;	/* sync var for pinning */
 #ifdef XFS_DQUOT_TRACE
@@ -113,17 +113,25 @@ XFS_DQ_IS_LOCKED(xfs_dquot_t *dqp)
 
 
 /*
- * The following three routines simply manage the q_flock
- * semaphore embedded in the dquot.  This semaphore synchronizes
- * processes attempting to flush the in-core dquot back to disk.
+ * Manage the q_flush completion queue embedded in the dquot.  This completion
+ * queue synchronizes processes attempting to flush the in-core dquot back to
+ * disk.
  */
-#define xfs_dqflock(dqp)	 { psema(&((dqp)->q_flock), PINOD | PRECALC);\
-				   (dqp)->dq_flags |= XFS_DQ_FLOCKED; }
-#define xfs_dqfunlock(dqp)	 { ASSERT(issemalocked(&((dqp)->q_flock))); \
-				   vsema(&((dqp)->q_flock)); \
-				   (dqp)->dq_flags &= ~(XFS_DQ_FLOCKED); }
+static inline void xfs_dqflock(xfs_dquot_t *dqp)
+{
+	wait_for_completion(&dqp->q_flush);
+}
+
+static inline int xfs_dqflock_nowait(xfs_dquot_t *dqp)
+{
+	return try_wait_for_completion(&dqp->q_flush);
+}
+
+static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
+{
+	complete(&dqp->q_flush);
+}
 
-#define XFS_DQ_IS_FLUSH_LOCKED(dqp) (issemalocked(&((dqp)->q_flock)))
 #define XFS_DQ_IS_ON_FREELIST(dqp)  ((dqp)->dq_flnext != (dqp))
 #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->dq_flags & XFS_DQ_DIRTY)
 #define XFS_QM_ISUDQ(dqp)	((dqp)->dq_flags & XFS_DQ_USER)
@@ -167,7 +175,6 @@ extern int		xfs_qm_dqflush(xfs_dquot_t *
 extern int		xfs_qm_dqpurge(xfs_dquot_t *);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern int		xfs_qm_dqlock_nowait(xfs_dquot_t *);
-extern int		xfs_qm_dqflock_nowait(xfs_dquot_t *);
 extern void		xfs_qm_dqflock_pushbuf_wait(xfs_dquot_t *dqp);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
diff -puN fs/xfs/quota/xfs_dquot_item.c~xfs-replace-dquot-flush-semaphore-with-a-completion fs/xfs/quota/xfs_dquot_item.c
--- a/fs/xfs/quota/xfs_dquot_item.c~xfs-replace-dquot-flush-semaphore-with-a-completion
+++ a/fs/xfs/quota/xfs_dquot_item.c
@@ -151,7 +151,7 @@ xfs_qm_dquot_logitem_push(
 	dqp = logitem->qli_dquot;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	ASSERT(XFS_DQ_IS_FLUSH_LOCKED(dqp));
+	ASSERT(!completion_done(&dqp->q_flush));
 
 	/*
 	 * Since we were able to lock the dquot's flush lock and
@@ -245,7 +245,7 @@ xfs_qm_dquot_logitem_pushbuf(
 	 * inode flush completed and the inode was taken off the AIL.
 	 * So, just get out.
 	 */
-	if (!issemalocked(&(dqp->q_flock))  ||
+	if (completion_done(&dqp->q_flush)  ||
 	    ((qip->qli_item.li_flags & XFS_LI_IN_AIL) == 0)) {
 		qip->qli_pushbuf_flag = 0;
 		xfs_dqunlock(dqp);
@@ -258,7 +258,7 @@ xfs_qm_dquot_logitem_pushbuf(
 	if (bp != NULL) {
 		if (XFS_BUF_ISDELAYWRITE(bp)) {
 			dopush = ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
-				  issemalocked(&(dqp->q_flock)));
+				  !completion_done(&dqp->q_flush));
 			qip->qli_pushbuf_flag = 0;
 			xfs_dqunlock(dqp);
 
@@ -317,7 +317,7 @@ xfs_qm_dquot_logitem_trylock(
 		return (XFS_ITEM_LOCKED);
 
 	retval = XFS_ITEM_SUCCESS;
-	if (! xfs_qm_dqflock_nowait(dqp)) {
+	if (!xfs_dqflock_nowait(dqp)) {
 		/*
 		 * The dquot is already being flushed.	It may have been
 		 * flushed delayed write, however, and we don't want to
diff -puN fs/xfs/quota/xfs_qm.c~xfs-replace-dquot-flush-semaphore-with-a-completion fs/xfs/quota/xfs_qm.c
--- a/fs/xfs/quota/xfs_qm.c~xfs-replace-dquot-flush-semaphore-with-a-completion
+++ a/fs/xfs/quota/xfs_qm.c
@@ -484,7 +484,7 @@ again:
 		xfs_dqtrace_entry(dqp, "FLUSHALL: DQDIRTY");
 		/* XXX a sentinel would be better */
 		recl = XFS_QI_MPLRECLAIMS(mp);
-		if (! xfs_qm_dqflock_nowait(dqp)) {
+		if (!xfs_dqflock_nowait(dqp)) {
 			/*
 			 * If we can't grab the flush lock then check
 			 * to see if the dquot has been flushed delayed
@@ -1062,7 +1062,7 @@ xfs_qm_sync(
 
 		/* XXX a sentinel would be better */
 		recl = XFS_QI_MPLRECLAIMS(mp);
-		if (! xfs_qm_dqflock_nowait(dqp)) {
+		if (!xfs_dqflock_nowait(dqp)) {
 			if (nowait) {
 				xfs_dqunlock(dqp);
 				continue;
@@ -2079,7 +2079,7 @@ xfs_qm_shake_freelist(
 		 * Try to grab the flush lock. If this dquot is in the process of
 		 * getting flushed to disk, we don't want to reclaim it.
 		 */
-		if (! xfs_qm_dqflock_nowait(dqp)) {
+		if (!xfs_dqflock_nowait(dqp)) {
 			xfs_dqunlock(dqp);
 			dqp = dqp->dq_flnext;
 			continue;
@@ -2257,7 +2257,7 @@ xfs_qm_dqreclaim_one(void)
 		 * Try to grab the flush lock. If this dquot is in the process of
 		 * getting flushed to disk, we don't want to reclaim it.
 		 */
-		if (! xfs_qm_dqflock_nowait(dqp)) {
+		if (!xfs_dqflock_nowait(dqp)) {
 			xfs_dqunlock(dqp);
 			continue;
 		}
_

Patches currently in -mm which might be from david@fromorbit.com are

xfs-clean-up-stale-references-to-semaphores.patch
xfs-replace-the-xfs-buf-iodone-semaphore-with-a-completion.patch
xfs-extend-completions-to-provide-xfs-object-flush-requirements.patch
xfs-replace-inode-flush-semaphore-with-a-completion.patch
xfs-replace-dquot-flush-semaphore-with-a-completion.patch
xfs-remove-the-sema_t-from-xfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch

