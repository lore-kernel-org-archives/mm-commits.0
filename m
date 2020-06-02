From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 052/128] mm/writeback: replace PF_LESS_THROTTLE
 with PF_LOCAL_THROTTLE
Date: Mon, 01 Jun 2020 21:48:18 -0700
Message-ID: <20200602044818.joMs-wr5s%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgFBEsU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:48:20 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chuck.lever@oracle.com, hch@lst.de, jack@suse.cz, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, neilb@suse.de, torvalds@linux-foundation.org, trond.myklebust@hammerspace.com

From: NeilBrown <neilb@suse.de>
Subject: mm/writeback: replace PF_LESS_THROTTLE with PF_LOCAL_THROTTLE

PF_LESS_THROTTLE exists for loop-back nfsd (and a similar need in the loop
block driver and callers of prctl(PR_SET_IO_FLUSHER)), where a daemon
needs to write to one bdi (the final bdi) in order to free up writes
queued to another bdi (the client bdi).

The daemon sets PF_LESS_THROTTLE and gets a larger allowance of dirty
pages, so that it can still dirty pages after other processses have been
throttled.  The purpose of this is to avoid deadlock that happen when the
PF_LESS_THROTTLE process must write for any dirty pages to be freed, but
it is being thottled and cannot write.

This approach was designed when all threads were blocked equally,
independently on which device they were writing to, or how fast it was. 
Since that time the writeback algorithm has changed substantially with
different threads getting different allowances based on non-trivial
heuristics.  This means the simple "add 25%" heuristic is no longer
reliable.

The important issue is not that the daemon needs a *larger* dirty page
allowance, but that it needs a *private* dirty page allowance, so that
dirty pages for the "client" bdi that it is helping to clear (the bdi for
an NFS filesystem or loop block device etc) do not affect the throttling
of the daemon writing to the "final" bdi.

This patch changes the heuristic so that the task is not throttled when
the bdi it is writing to has a dirty page count below below (or equal to)
the free-run threshold for that bdi.  This ensures it will always be able
to have some pages in flight, and so will not deadlock.

In a steady-state, it is expected that PF_LOCAL_THROTTLE tasks might still
be throttled by global threshold, but that is acceptable as it is only the
deadlock state that is interesting for this flag.

This approach of "only throttle when target bdi is busy" is consistent
with the other use of PF_LESS_THROTTLE in current_may_throttle(), were it
causes attention to be focussed only on the target bdi.

So this patch
 - renames PF_LESS_THROTTLE to PF_LOCAL_THROTTLE,
 - removes the 25% bonus that that flag gives, and
 - If PF_LOCAL_THROTTLE is set, don't delay at all unless the
   global and the local free-run thresholds are exceeded.

Note that previously realtime threads were treated the same as
PF_LESS_THROTTLE threads.  This patch does *not* change the behvaiour for
real-time threads, so it is now different from the behaviour of nfsd and
loop tasks.  I don't know what is wanted for realtime.

[akpm@linux-foundation.org: coding style fixes]
Link: http://lkml.kernel.org/r/87ftbf7gs3.fsf@notabene.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Chuck Lever <chuck.lever@oracle.com>	[nfsd]
Cc: Christoph Hellwig <hch@lst.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c  |    2 -
 fs/nfsd/vfs.c         |    9 ++++----
 include/linux/sched.h |    3 +-
 kernel/sys.c          |    2 -
 mm/page-writeback.c   |   41 ++++++++++++++++++++++++++++++++--------
 mm/vmscan.c           |    4 +--
 6 files changed, 44 insertions(+), 17 deletions(-)

--- a/drivers/block/loop.c~mm-replace-pf_less_throttle-with-pf_local_throttle
+++ a/drivers/block/loop.c
@@ -919,7 +919,7 @@ static void loop_unprepare_queue(struct
 
 static int loop_kthread_worker_fn(void *worker_ptr)
 {
-	current->flags |= PF_LESS_THROTTLE | PF_MEMALLOC_NOIO;
+	current->flags |= PF_LOCAL_THROTTLE | PF_MEMALLOC_NOIO;
 	return kthread_worker_fn(worker_ptr);
 }
 
--- a/fs/nfsd/vfs.c~mm-replace-pf_less_throttle-with-pf_local_throttle
+++ a/fs/nfsd/vfs.c
@@ -979,12 +979,13 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	if (test_bit(RQ_LOCAL, &rqstp->rq_flags))
 		/*
-		 * We want less throttling in balance_dirty_pages()
-		 * and shrink_inactive_list() so that nfs to
+		 * We want throttling in balance_dirty_pages()
+		 * and shrink_inactive_list() to only consider
+		 * the backingdev we are writing to, so that nfs to
 		 * localhost doesn't cause nfsd to lock up due to all
 		 * the client's dirty pages or its congested queue.
 		 */
-		current->flags |= PF_LESS_THROTTLE;
+		current->flags |= PF_LOCAL_THROTTLE;
 
 	exp = fhp->fh_export;
 	use_wgather = (rqstp->rq_vers == 2) && EX_WGATHER(exp);
@@ -1037,7 +1038,7 @@ out_nfserr:
 		nfserr = nfserrno(host_err);
 	}
 	if (test_bit(RQ_LOCAL, &rqstp->rq_flags))
-		current_restore_flags(pflags, PF_LESS_THROTTLE);
+		current_restore_flags(pflags, PF_LOCAL_THROTTLE);
 	return nfserr;
 }
 
--- a/include/linux/sched.h~mm-replace-pf_less_throttle-with-pf_local_throttle
+++ a/include/linux/sched.h
@@ -1481,7 +1481,8 @@ extern struct pid *cad_pid;
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocation requests will inherit GFP_NOFS */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
-#define PF_LESS_THROTTLE	0x00100000	/* Throttle me less: I clean memory */
+#define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
+						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
 #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
--- a/kernel/sys.c~mm-replace-pf_less_throttle-with-pf_local_throttle
+++ a/kernel/sys.c
@@ -2262,7 +2262,7 @@ int __weak arch_prctl_spec_ctrl_set(stru
 	return -EINVAL;
 }
 
-#define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LESS_THROTTLE)
+#define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
 
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
--- a/mm/page-writeback.c~mm-replace-pf_less_throttle-with-pf_local_throttle
+++ a/mm/page-writeback.c
@@ -387,8 +387,7 @@ static unsigned long global_dirtyable_me
  * Calculate @dtc->thresh and ->bg_thresh considering
  * vm_dirty_{bytes|ratio} and dirty_background_{bytes|ratio}.  The caller
  * must ensure that @dtc->avail is set before calling this function.  The
- * dirty limits will be lifted by 1/4 for PF_LESS_THROTTLE (ie. nfsd) and
- * real-time tasks.
+ * dirty limits will be lifted by 1/4 for real-time tasks.
  */
 static void domain_dirty_limits(struct dirty_throttle_control *dtc)
 {
@@ -436,7 +435,7 @@ static void domain_dirty_limits(struct d
 	if (bg_thresh >= thresh)
 		bg_thresh = thresh / 2;
 	tsk = current;
-	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
+	if (rt_task(tsk)) {
 		bg_thresh += bg_thresh / 4 + global_wb_domain.dirty_limit / 32;
 		thresh += thresh / 4 + global_wb_domain.dirty_limit / 32;
 	}
@@ -486,7 +485,7 @@ static unsigned long node_dirty_limit(st
 	else
 		dirty = vm_dirty_ratio * node_memory / 100;
 
-	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk))
+	if (rt_task(tsk))
 		dirty += dirty / 4;
 
 	return dirty;
@@ -1653,8 +1652,12 @@ static void balance_dirty_pages(struct b
 		if (dirty <= dirty_freerun_ceiling(thresh, bg_thresh) &&
 		    (!mdtc ||
 		     m_dirty <= dirty_freerun_ceiling(m_thresh, m_bg_thresh))) {
-			unsigned long intv = dirty_poll_interval(dirty, thresh);
-			unsigned long m_intv = ULONG_MAX;
+			unsigned long intv;
+			unsigned long m_intv;
+
+free_running:
+			intv = dirty_poll_interval(dirty, thresh);
+			m_intv = ULONG_MAX;
 
 			current->dirty_paused_when = now;
 			current->nr_dirtied = 0;
@@ -1673,9 +1676,20 @@ static void balance_dirty_pages(struct b
 		 * Calculate global domain's pos_ratio and select the
 		 * global dtc by default.
 		 */
-		if (!strictlimit)
+		if (!strictlimit) {
 			wb_dirty_limits(gdtc);
 
+			if ((current->flags & PF_LOCAL_THROTTLE) &&
+			    gdtc->wb_dirty <
+			    dirty_freerun_ceiling(gdtc->wb_thresh,
+						  gdtc->wb_bg_thresh))
+				/*
+				 * LOCAL_THROTTLE tasks must not be throttled
+				 * when below the per-wb freerun ceiling.
+				 */
+				goto free_running;
+		}
+
 		dirty_exceeded = (gdtc->wb_dirty > gdtc->wb_thresh) &&
 			((gdtc->dirty > gdtc->thresh) || strictlimit);
 
@@ -1689,9 +1703,20 @@ static void balance_dirty_pages(struct b
 			 * both global and memcg domains.  Choose the one
 			 * w/ lower pos_ratio.
 			 */
-			if (!strictlimit)
+			if (!strictlimit) {
 				wb_dirty_limits(mdtc);
 
+				if ((current->flags & PF_LOCAL_THROTTLE) &&
+				    mdtc->wb_dirty <
+				    dirty_freerun_ceiling(mdtc->wb_thresh,
+							  mdtc->wb_bg_thresh))
+					/*
+					 * LOCAL_THROTTLE tasks must not be
+					 * throttled when below the per-wb
+					 * freerun ceiling.
+					 */
+					goto free_running;
+			}
 			dirty_exceeded |= (mdtc->wb_dirty > mdtc->wb_thresh) &&
 				((mdtc->dirty > mdtc->thresh) || strictlimit);
 
--- a/mm/vmscan.c~mm-replace-pf_less_throttle-with-pf_local_throttle
+++ a/mm/vmscan.c
@@ -1878,13 +1878,13 @@ static unsigned noinline_for_stack move_
 
 /*
  * If a kernel thread (such as nfsd for loop-back mounts) services
- * a backing device by writing to the page cache it sets PF_LESS_THROTTLE.
+ * a backing device by writing to the page cache it sets PF_LOCAL_THROTTLE.
  * In that case we should only throttle if the backing device it is
  * writing to is congested.  In other cases it is safe to throttle.
  */
 static int current_may_throttle(void)
 {
-	return !(current->flags & PF_LESS_THROTTLE) ||
+	return !(current->flags & PF_LOCAL_THROTTLE) ||
 		current->backing_dev_info == NULL ||
 		bdi_write_congested(current->backing_dev_info);
 }
_
