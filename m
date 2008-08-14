From: akpm@linux-foundation.org
Subject: - xfs-clean-up-stale-references-to-semaphores.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:07 -0700
Message-ID: <200808142354.m7ENs7fg003887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864AbYHNXyM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fromorbit.com, lachlan@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: clean up stale references to semaphores
has been removed from the -mm tree.  Its filename was
     xfs-clean-up-stale-references-to-semaphores.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: clean up stale references to semaphores
From: Dave Chinner <david@fromorbit.com>

A lot of code has been converted away from semaphores, but there are still
comments that reference semaphore behaviour.  The log code is the worst
offender.  Update the comments to reflect what the code really does now.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_vnode.c |    2 
 fs/xfs/xfs_log.c             |   67 +++++++++++++++------------------
 fs/xfs/xfs_log_priv.h        |   12 ++---
 3 files changed, 39 insertions(+), 42 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_vnode.c~xfs-clean-up-stale-references-to-semaphores fs/xfs/linux-2.6/xfs_vnode.c
--- a/fs/xfs/linux-2.6/xfs_vnode.c~xfs-clean-up-stale-references-to-semaphores
+++ a/fs/xfs/linux-2.6/xfs_vnode.c
@@ -33,7 +33,7 @@
 
 
 /*
- * Dedicated vnode inactive/reclaim sync semaphores.
+ * Dedicated vnode inactive/reclaim sync wait queues.
  * Prime number of hash buckets since address is used as the key.
  */
 #define NVSYNC                  37
diff -puN fs/xfs/xfs_log.c~xfs-clean-up-stale-references-to-semaphores fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-clean-up-stale-references-to-semaphores
+++ a/fs/xfs/xfs_log.c
@@ -357,11 +357,11 @@ xfs_log_done(xfs_mount_t	*mp,
  * Asynchronous forces are implemented by setting the WANT_SYNC
  * bit in the appropriate in-core log and then returning.
  *
- * Synchronous forces are implemented with a semaphore.  All callers
- * to force a given lsn to disk will wait on a semaphore attached to the
+ * Synchronous forces are implemented with a signal variable. All callers
+ * to force a given lsn to disk will wait on a the sv attached to the
  * specific in-core log.  When given in-core log finally completes its
  * write to disk, that thread will wake up all threads waiting on the
- * semaphore.
+ * sv.
  */
 int
 _xfs_log_force(
@@ -707,7 +707,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
 		      iclog->ic_state == XLOG_STATE_DIRTY)) {
 			if (!XLOG_FORCED_SHUTDOWN(log)) {
-				sv_wait(&iclog->ic_forcesema, PMEM,
+				sv_wait(&iclog->ic_force_wait, PMEM,
 					&log->l_icloglock, s);
 			} else {
 				spin_unlock(&log->l_icloglock);
@@ -748,7 +748,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 			|| iclog->ic_state == XLOG_STATE_DIRTY
 			|| iclog->ic_state == XLOG_STATE_IOERROR) ) {
 
-				sv_wait(&iclog->ic_forcesema, PMEM,
+				sv_wait(&iclog->ic_force_wait, PMEM,
 					&log->l_icloglock, s);
 		} else {
 			spin_unlock(&log->l_icloglock);
@@ -838,7 +838,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= tic->t_unit_res;
-			sv_signal(&tic->t_sema);
+			sv_signal(&tic->t_wait);
 			tic = tic->t_next;
 		} while (tic != log->l_write_headq);
 	}
@@ -859,7 +859,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 				break;
 			tail_lsn = 0;
 			free_bytes -= need_bytes;
-			sv_signal(&tic->t_sema);
+			sv_signal(&tic->t_wait);
 			tic = tic->t_next;
 		} while (tic != log->l_reserve_headq);
 	}
@@ -1285,8 +1285,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 
 		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
 		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
-		sv_init(&iclog->ic_forcesema, SV_DEFAULT, "iclog-force");
-		sv_init(&iclog->ic_writesema, SV_DEFAULT, "iclog-write");
+		sv_init(&iclog->ic_force_wait, SV_DEFAULT, "iclog-force");
+		sv_init(&iclog->ic_write_wait, SV_DEFAULT, "iclog-write");
 
 		iclogp = &iclog->ic_next;
 	}
@@ -1565,8 +1565,8 @@ xlog_dealloc_log(xlog_t *log)
 
 	iclog = log->l_iclog;
 	for (i=0; i<log->l_iclog_bufs; i++) {
-		sv_destroy(&iclog->ic_forcesema);
-		sv_destroy(&iclog->ic_writesema);
+		sv_destroy(&iclog->ic_force_wait);
+		sv_destroy(&iclog->ic_write_wait);
 		xfs_buf_free(iclog->ic_bp);
 #ifdef XFS_LOG_TRACE
 		if (iclog->ic_trace != NULL) {
@@ -1976,7 +1976,7 @@ xlog_write(xfs_mount_t *	mp,
 /* Clean iclogs starting from the head.  This ordering must be
  * maintained, so an iclog doesn't become ACTIVE beyond one that
  * is SYNCING.  This is also required to maintain the notion that we use
- * a counting semaphore to hold off would be writers to the log when every
+ * a ordered wait queue to hold off would be writers to the log when every
  * iclog is trying to sync to disk.
  *
  * State Change: DIRTY -> ACTIVE
@@ -2240,7 +2240,7 @@ xlog_state_do_callback(
 			xlog_state_clean_log(log);
 
 			/* wake up threads waiting in xfs_log_force() */
-			sv_broadcast(&iclog->ic_forcesema);
+			sv_broadcast(&iclog->ic_force_wait);
 
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
@@ -2302,8 +2302,7 @@ xlog_state_do_callback(
  * the second completion goes through.
  *
  * Callbacks could take time, so they are done outside the scope of the
- * global state machine log lock.  Assume that the calls to cvsema won't
- * take a long time.  At least we know it won't sleep.
+ * global state machine log lock.
  */
 STATIC void
 xlog_state_done_syncing(
@@ -2339,7 +2338,7 @@ xlog_state_done_syncing(
 	 * iclog buffer, we wake them all, one will get to do the
 	 * I/O, the others get to wait for the result.
 	 */
-	sv_broadcast(&iclog->ic_writesema);
+	sv_broadcast(&iclog->ic_write_wait);
 	spin_unlock(&log->l_icloglock);
 	xlog_state_do_callback(log, aborted, iclog);	/* also cleans log */
 }	/* xlog_state_done_syncing */
@@ -2347,11 +2346,9 @@ xlog_state_done_syncing(
 
 /*
  * If the head of the in-core log ring is not (ACTIVE or DIRTY), then we must
- * sleep.  The flush semaphore is set to the number of in-core buffers and
- * decremented around disk syncing.  Therefore, if all buffers are syncing,
- * this semaphore will cause new writes to sleep until a sync completes.
- * Otherwise, this code just does p() followed by v().  This approximates
- * a sleep/wakeup except we can't race.
+ * sleep.  We wait on the flush queue on the head iclog as that should be
+ * the first iclog to complete flushing. Hence if all iclogs are syncing,
+ * we will wait here and all new writes will sleep until a sync completes.
  *
  * The in-core logs are used in a circular fashion. They are not used
  * out-of-order even when an iclog past the head is free.
@@ -2508,7 +2505,7 @@ xlog_grant_log_space(xlog_t	   *log,
 			goto error_return;
 
 		XFS_STATS_INC(xs_sleep_logspace);
-		sv_wait(&tic->t_sema, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 		/*
 		 * If we got an error, and the filesystem is shutting down,
 		 * we'll catch it down below. So just continue...
@@ -2534,7 +2531,7 @@ redo:
 		xlog_trace_loggrant(log, tic,
 				    "xlog_grant_log_space: sleep 2");
 		XFS_STATS_INC(xs_sleep_logspace);
-		sv_wait(&tic->t_sema, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
 		if (XLOG_FORCED_SHUTDOWN(log)) {
 			spin_lock(&log->l_grant_lock);
@@ -2633,7 +2630,7 @@ xlog_regrant_write_log_space(xlog_t	   *
 			if (free_bytes < ntic->t_unit_res)
 				break;
 			free_bytes -= ntic->t_unit_res;
-			sv_signal(&ntic->t_sema);
+			sv_signal(&ntic->t_wait);
 			ntic = ntic->t_next;
 		} while (ntic != log->l_write_headq);
 
@@ -2644,7 +2641,7 @@ xlog_regrant_write_log_space(xlog_t	   *
 			xlog_trace_loggrant(log, tic,
 				    "xlog_regrant_write_log_space: sleep 1");
 			XFS_STATS_INC(xs_sleep_logspace);
-			sv_wait(&tic->t_sema, PINOD|PLTWAIT,
+			sv_wait(&tic->t_wait, PINOD|PLTWAIT,
 				&log->l_grant_lock, s);
 
 			/* If we're shutting down, this tic is already
@@ -2673,7 +2670,7 @@ redo:
 		if ((tic->t_flags & XLOG_TIC_IN_Q) == 0)
 			xlog_ins_ticketq(&log->l_write_headq, tic);
 		XFS_STATS_INC(xs_sleep_logspace);
-		sv_wait(&tic->t_sema, PINOD|PLTWAIT, &log->l_grant_lock, s);
+		sv_wait(&tic->t_wait, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
 		/* If we're shutting down, this tic is already off the queue */
 		if (XLOG_FORCED_SHUTDOWN(log)) {
@@ -2916,7 +2913,7 @@ xlog_state_switch_iclogs(xlog_t		*log,
  *	2. the current iclog is drity, and the previous iclog is in the
  *		active or dirty state.
  *
- * We may sleep (call psema) if:
+ * We may sleep if:
  *
  *	1. the current iclog is not in the active nor dirty state.
  *	2. the current iclog dirty, and the previous iclog is not in the
@@ -3013,7 +3010,7 @@ maybe_sleep:
 			return XFS_ERROR(EIO);
 		}
 		XFS_STATS_INC(xs_log_force_sleep);
-		sv_wait(&iclog->ic_forcesema, PINOD, &log->l_icloglock, s);
+		sv_wait(&iclog->ic_force_wait, PINOD, &log->l_icloglock, s);
 		/*
 		 * No need to grab the log lock here since we're
 		 * only deciding whether or not to return EIO
@@ -3096,7 +3093,7 @@ try_again:
 						 XLOG_STATE_SYNCING))) {
 			ASSERT(!(iclog->ic_state & XLOG_STATE_IOERROR));
 			XFS_STATS_INC(xs_log_force_sleep);
-			sv_wait(&iclog->ic_prev->ic_writesema, PSWP,
+			sv_wait(&iclog->ic_prev->ic_write_wait, PSWP,
 				&log->l_icloglock, s);
 			*log_flushed = 1;
 			already_slept = 1;
@@ -3116,7 +3113,7 @@ try_again:
 	    !(iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))) {
 
 		/*
-		 * Don't wait on the forcesema if we know that we've
+		 * Don't wait on completion if we know that we've
 		 * gotten a log write error.
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR) {
@@ -3124,7 +3121,7 @@ try_again:
 			return XFS_ERROR(EIO);
 		}
 		XFS_STATS_INC(xs_log_force_sleep);
-		sv_wait(&iclog->ic_forcesema, PSWP, &log->l_icloglock, s);
+		sv_wait(&iclog->ic_force_wait, PSWP, &log->l_icloglock, s);
 		/*
 		 * No need to grab the log lock here since we're
 		 * only deciding whether or not to return EIO
@@ -3180,7 +3177,7 @@ STATIC void
 xlog_ticket_put(xlog_t		*log,
 		xlog_ticket_t	*ticket)
 {
-	sv_destroy(&ticket->t_sema);
+	sv_destroy(&ticket->t_wait);
 	kmem_zone_free(xfs_log_ticket_zone, ticket);
 }	/* xlog_ticket_put */
 
@@ -3270,7 +3267,7 @@ xlog_ticket_get(xlog_t		*log,
 	tic->t_trans_type	= 0;
 	if (xflags & XFS_LOG_PERM_RESERV)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
-	sv_init(&(tic->t_sema), SV_DEFAULT, "logtick");
+	sv_init(&(tic->t_wait), SV_DEFAULT, "logtick");
 
 	xlog_tic_reset_res(tic);
 
@@ -3557,14 +3554,14 @@ xfs_log_force_umount(
 	 */
 	if ((tic = log->l_reserve_headq)) {
 		do {
-			sv_signal(&tic->t_sema);
+			sv_signal(&tic->t_wait);
 			tic = tic->t_next;
 		} while (tic != log->l_reserve_headq);
 	}
 
 	if ((tic = log->l_write_headq)) {
 		do {
-			sv_signal(&tic->t_sema);
+			sv_signal(&tic->t_wait);
 			tic = tic->t_next;
 		} while (tic != log->l_write_headq);
 	}
diff -puN fs/xfs/xfs_log_priv.h~xfs-clean-up-stale-references-to-semaphores fs/xfs/xfs_log_priv.h
--- a/fs/xfs/xfs_log_priv.h~xfs-clean-up-stale-references-to-semaphores
+++ a/fs/xfs/xfs_log_priv.h
@@ -241,7 +241,7 @@ typedef struct xlog_res {
 } xlog_res_t;
 
 typedef struct xlog_ticket {
-	sv_t		   t_sema;	 /* sleep on this semaphore      : 20 */
+	sv_t		   t_wait;	 /* ticket wait queue            : 20 */
 	struct xlog_ticket *t_next;	 /*			         :4|8 */
 	struct xlog_ticket *t_prev;	 /*				 :4|8 */
 	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
@@ -314,7 +314,7 @@ typedef struct xlog_rec_ext_header {
  *	xlog_rec_header_t into the reserved space.
  * - ic_data follows, so a write to disk can start at the beginning of
  *	the iclog.
- * - ic_forcesema is used to implement synchronous forcing of the iclog to disk.
+ * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
  * - ic_next is the pointer to the next iclog in the ring.
  * - ic_bp is a pointer to the buffer used to write this incore log to disk.
  * - ic_log is a pointer back to the global log structure.
@@ -339,8 +339,8 @@ typedef struct xlog_rec_ext_header {
  * and move everything else out to subsequent cachelines.
  */
 typedef struct xlog_iclog_fields {
-	sv_t			ic_forcesema;
-	sv_t			ic_writesema;
+	sv_t			ic_force_wait;
+	sv_t			ic_write_wait;
 	struct xlog_in_core	*ic_next;
 	struct xlog_in_core	*ic_prev;
 	struct xfs_buf		*ic_bp;
@@ -377,8 +377,8 @@ typedef struct xlog_in_core {
 /*
  * Defines to save our code from this glop.
  */
-#define	ic_forcesema	hic_fields.ic_forcesema
-#define ic_writesema	hic_fields.ic_writesema
+#define	ic_force_wait	hic_fields.ic_force_wait
+#define ic_write_wait	hic_fields.ic_write_wait
 #define	ic_next		hic_fields.ic_next
 #define	ic_prev		hic_fields.ic_prev
 #define	ic_bp		hic_fields.ic_bp
_

Patches currently in -mm which might be from david@fromorbit.com are

origin.patch
completions-un-inline-try_wait_for_completion-and-completion_done.patch
linux-next.patch

