From: akpm@linux-foundation.org
Subject: [merged] mempool-fix-and-document-synchronization-and-memory-barrier-usage.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:28:23 -0800
Message-ID: <20120111212829.0BA1310004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41779 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934037Ab2AKV2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:28:30 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7466yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:28:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, dhowells@redhat.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mempool: fix and document synchronization and memory barrier usage
has been removed from the -mm tree.  Its filename was
     mempool-fix-and-document-synchronization-and-memory-barrier-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: mempool: fix and document synchronization and memory barrier usage

mempool_alloc/free() use undocumented smp_mb()'s.  The code is slightly
broken and misleading.

The lockless part is in mempool_free().  It wants to determine whether the
item being freed needs to be returned to the pool or backing allocator
without grabbing pool->lock.  Two things need to be guaranteed for correct
operation.

1. pool->curr_nr + #allocated should never dip below pool->min_nr.
2. Waiters shouldn't be left dangling.

For #1, The only necessary condition is that curr_nr visible at free is
from after the allocation of the element being freed (details in the
comment).  For most cases, this is true without any barrier but there can
be fringe cases where the allocated pointer is passed to the freeing task
without going through memory barriers.  To cover this case, wmb is
necessary before returning from allocation and rmb is necessary before
reading curr_nr.  IOW,

	ALLOCATING TASK			FREEING TASK

	update pool state after alloc;
	wmb();
	pass pointer to freeing task;
					read pointer;
					rmb();
					read pool state to free;

The current code doesn't have wmb after pool update during allocation and
may theoretically, on machines where unlock doesn't behave as full wmb,
lead to pool depletion and deadlock.  smp_wmb() needs to be added after
successful allocation from reserved elements and smp_mb() in
mempool_free() can be replaced with smp_rmb().

For #2, the waiter needs to add itself to waitqueue and then check the
wait condition and the waker needs to update the wait condition and then
wake up.  Because waitqueue operations always go through full spinlock
synchronization, there is no need for extra memory barriers.

Furthermore, mempool_alloc() is already holding pool->lock when it decides
that it needs to wait.  There is no reason to do unlock - add waitqueue -
test condition again.  It can simply add itself to waitqueue while holding
pool->lock and then unlock and sleep.

This patch adds smp_wmb() after successful allocation from reserved pool,
replaces smp_mb() in mempool_free() with smp_rmb() and extend pool->lock
over waitqueue addition.  More importantly, it explains what memory
barriers do and how the lockless testing is correct.

-v2: Oleg pointed out that unlock doesn't imply wmb.  Added explicit
     smp_wmb() after successful allocation from reserved pool and
     updated comments accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   61 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff -puN mm/mempool.c~mempool-fix-and-document-synchronization-and-memory-barrier-usage mm/mempool.c
--- a/mm/mempool.c~mempool-fix-and-document-synchronization-and-memory-barrier-usage
+++ a/mm/mempool.c
@@ -224,28 +224,31 @@ repeat_alloc:
 	if (likely(pool->curr_nr)) {
 		element = remove_element(pool);
 		spin_unlock_irqrestore(&pool->lock, flags);
+		/* paired with rmb in mempool_free(), read comment there */
+		smp_wmb();
 		return element;
 	}
-	spin_unlock_irqrestore(&pool->lock, flags);
 
 	/* We must not sleep in the GFP_ATOMIC case */
-	if (!(gfp_mask & __GFP_WAIT))
+	if (!(gfp_mask & __GFP_WAIT)) {
+		spin_unlock_irqrestore(&pool->lock, flags);
 		return NULL;
+	}
 
-	/* Now start performing page reclaim */
+	/* Let's wait for someone else to return an element to @pool */
 	gfp_temp = gfp_mask;
 	init_wait(&wait);
 	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
-	smp_mb();
-	if (!pool->curr_nr) {
-		/*
-		 * FIXME: this should be io_schedule().  The timeout is there
-		 * as a workaround for some DM problems in 2.6.18.
-		 */
-		io_schedule_timeout(5*HZ);
-	}
-	finish_wait(&pool->wait, &wait);
 
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	/*
+	 * FIXME: this should be io_schedule().  The timeout is there as a
+	 * workaround for some DM problems in 2.6.18.
+	 */
+	io_schedule_timeout(5*HZ);
+
+	finish_wait(&pool->wait, &wait);
 	goto repeat_alloc;
 }
 EXPORT_SYMBOL(mempool_alloc);
@@ -265,7 +268,39 @@ void mempool_free(void *element, mempool
 	if (unlikely(element == NULL))
 		return;
 
-	smp_mb();
+	/*
+	 * Paired with the wmb in mempool_alloc().  The preceding read is
+	 * for @element and the following @pool->curr_nr.  This ensures
+	 * that the visible value of @pool->curr_nr is from after the
+	 * allocation of @element.  This is necessary for fringe cases
+	 * where @element was passed to this task without going through
+	 * barriers.
+	 *
+	 * For example, assume @p is %NULL at the beginning and one task
+	 * performs "p = mempool_alloc(...);" while another task is doing
+	 * "while (!p) cpu_relax(); mempool_free(p, ...);".  This function
+	 * may end up using curr_nr value which is from before allocation
+	 * of @p without the following rmb.
+	 */
+	smp_rmb();
+
+	/*
+	 * For correctness, we need a test which is guaranteed to trigger
+	 * if curr_nr + #allocated == min_nr.  Testing curr_nr < min_nr
+	 * without locking achieves that and refilling as soon as possible
+	 * is desirable.
+	 *
+	 * Because curr_nr visible here is always a value after the
+	 * allocation of @element, any task which decremented curr_nr below
+	 * min_nr is guaranteed to see curr_nr < min_nr unless curr_nr gets
+	 * incremented to min_nr afterwards.  If curr_nr gets incremented
+	 * to min_nr after the allocation of @element, the elements
+	 * allocated after that are subject to the same guarantee.
+	 *
+	 * Waiters happen iff curr_nr is 0 and the above guarantee also
+	 * ensures that there will be frees which return elements to the
+	 * pool waking up the waiters.
+	 */
 	if (pool->curr_nr < pool->min_nr) {
 		spin_lock_irqsave(&pool->lock, flags);
 		if (pool->curr_nr < pool->min_nr) {
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
sysctl-add-the-kernelns_last_pid-control.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

