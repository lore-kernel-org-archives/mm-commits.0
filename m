From: akpm@linux-foundation.org
Subject: + ipc-semc-optimize-update_queue-for-bulk-wakeup-calls.patch added to -mm tree
Date: Fri, 30 Apr 2010 14:22:04 -0700
Message-ID: <201004302122.o3ULM4gw014184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759612Ab0D3VWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 17:22:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, chris.mason@oracle.com, jens.axboe@oracle.com, npiggin@suse.de, zach.brown@oracle.com


The patch titled
     ipc/sem.c: optimize update_queue() for bulk wakeup calls
has been added to the -mm tree.  Its filename is
     ipc-semc-optimize-update_queue-for-bulk-wakeup-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: optimize update_queue() for bulk wakeup calls
From: Manfred Spraul <manfred@colorfullife.com>

The following series of patches tries to fix the spinlock contention
reported by Chris Mason - his benchmark exposes problems of the current
code:

- In the worst case, the algorithm used by update_queue() is O(N^2). 
  Bulk wake-up calls can enter this worst case.  The patch series fix
  that.

  Note that the benchmark app doesn't expose the problem, it just should
  be fixed: Real world apps might do the wake-ups in another order than
  perfect FIFO.

- The part of the code that runs within the semaphore array spinlock is
  significantly larger than necessary.

  The patch series fixes that.  This change is responsible for the main
  improvement.

- The cacheline with the spinlock is also used for a variable that is
  read in the hot path (sem_base) and for a variable that is unnecessarily
  written to multiple times (sem_otime).  The last step of the series
  cacheline-aligns the spinlock.



This patch:

The SysV semaphore code allows to perform multiple operations on all
semaphores in the array as atomic operations.  After a modification,
update_queue() checks which of the waiting tasks can complete.

The algorithm that is used to identify the tasks is O(N^2) in the worst
case.  For some cases, it is simple to avoid the O(N^2).

The patch adds a detection logic for some cases, especially for the case
of an array where all sleeping tasks are single sembuf operations and a
multi-sembuf operation is used to wake up multiple tasks.

A big database application uses that approach.

The patch fixes wakeup due to semctl(,,SETALL,) - the initial version of
the patch breaks that.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  110 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 97 insertions(+), 13 deletions(-)

diff -puN ipc/sem.c~ipc-semc-optimize-update_queue-for-bulk-wakeup-calls ipc/sem.c
--- a/ipc/sem.c~ipc-semc-optimize-update_queue-for-bulk-wakeup-calls
+++ a/ipc/sem.c
@@ -434,6 +434,69 @@ static void unlink_queue(struct sem_arra
 		sma->complex_count--;
 }
 
+/** check_restart(sma, q)
+ * @sma: semaphore array
+ * @q: the operation that just completed
+ *
+ * update_queue is O(N^2) when it restarts scanning the whole queue of
+ * waiting operations. Therefore this function checks if the restart is
+ * really necessary. It is called after a previously waiting operation
+ * was completed.
+ */
+static int check_restart(struct sem_array *sma, struct sem_queue *q)
+{
+	struct sem *curr;
+	struct sem_queue *h;
+
+	/* if the operation didn't modify the array, then no restart */
+	if (q->alter == 0)
+		return 0;
+
+	/* pending complex operations are too difficult to analyse */
+	if (sma->complex_count)
+		return 1;
+
+	/* we were a sleeping complex operation. Too difficult */
+	if (q->nsops > 1)
+		return 1;
+
+	curr = sma->sem_base + q->sops[0].sem_num;
+
+	/* No-one waits on this queue */
+	if (list_empty(&curr->sem_pending))
+		return 0;
+
+	/* the new semaphore value */
+	if (curr->semval) {
+		/* It is impossible that someone waits for the new value:
+		 * - q is a previously sleeping simple operation that
+		 *   altered the array. It must be a decrement, because
+		 *   simple increments never sleep.
+		 * - The value is not 0, thus wait-for-zero won't proceed.
+		 * - If there are older (higher priority) decrements
+		 *   in the queue, then they have observed the original
+		 *   semval value and couldn't proceed. The operation
+		 *   decremented to value - thus they won't proceed either.
+		 */
+		BUG_ON(q->sops[0].sem_op >= 0);
+		return 0;
+	}
+	/*
+	 * semval is 0. Check if there are wait-for-zero semops.
+	 * They must be the first entries in the per-semaphore simple queue
+	 */
+	h = list_first_entry(&curr->sem_pending, struct sem_queue, simple_list);
+	BUG_ON(h->nsops != 1);
+	BUG_ON(h->sops[0].sem_num != q->sops[0].sem_num);
+
+	/* Yes, there is a wait-for-zero semop. Restart */
+	if (h->sops[0].sem_op == 0)
+		return 1;
+
+	/* Again - no-one is waiting for the new value. */
+	return 0;
+}
+
 
 /**
  * update_queue(sma, semnum): Look for tasks that can be completed.
@@ -469,7 +532,7 @@ static void update_queue(struct sem_arra
 again:
 	walk = pending_list->next;
 	while (walk != pending_list) {
-		int error, alter;
+		int error, restart;
 
 		q = (struct sem_queue *)((char *)walk - offset);
 		walk = walk->next;
@@ -494,22 +557,43 @@ again:
 
 		unlink_queue(sma, q);
 
-		/*
-		 * The next operation that must be checked depends on the type
-		 * of the completed operation:
-		 * - if the operation modified the array, then restart from the
-		 *   head of the queue and check for threads that might be
-		 *   waiting for the new semaphore values.
-		 * - if the operation didn't modify the array, then just
-		 *   continue.
-		 */
-		alter = q->alter;
+		if (error)
+			restart = 0;
+		else
+			restart = check_restart(sma, q);
+
 		wake_up_sem_queue(q, error);
-		if (alter && !error)
+		if (restart)
 			goto again;
 	}
 }
 
+/** do_smart_update(sma, sops, nsops): Optimized update_queue
+ * @sma: semaphore array
+ * @sops: operations that were performed
+ * @nsops: number of operations
+ *
+ * do_smart_update() does the required called to update_queue, based on the
+ * actual changes that were performed on the semaphore array.
+ */
+void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops)
+{
+	int i;
+
+	if (sma->complex_count || sops == NULL) {
+		update_queue(sma, -1);
+		return;
+	}
+
+	for (i = 0; i < nsops; i++) {
+		if (sops[i].sem_op > 0 ||
+			(sops[i].sem_op < 0 &&
+				sma->sem_base[sops[i].sem_num].semval == 0))
+			update_queue(sma, sops[i].sem_num);
+	}
+}
+
+
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -1225,7 +1309,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
+			do_smart_update(sma, sops, nsops);
 
 		goto out_unlock_free;
 	}
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-optimize-update_queue-for-bulk-wakeup-calls.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-cacheline-align-the-ipc-spinlock-for-semaphores.patch
slab-leaks3-default-y.patch

