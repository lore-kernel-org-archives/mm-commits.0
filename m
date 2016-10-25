From: akpm@linux-foundation.org
Subject: + ipc-sem-optimize-perform_atomic_semop.patch added to -mm tree
Date: Tue, 25 Oct 2016 15:56:59 -0700
Message-ID: <580fe33b.sIHOTbPbfC9S9Rvo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752987AbcJYW5A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 18:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: optimize perform_atomic_semop()
has been added to the -mm tree.  Its filename is
     ipc-sem-optimize-perform_atomic_semop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-optimize-perform_atomic_semop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-optimize-perform_atomic_semop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: optimize perform_atomic_semop()

This is the main workhorse that deals with semop user calls such that the
waitforzero or semval update operations, on the set, can complete on not
as the sma currently stands.  Currently, the set is iterated twice
(setting semval, then backwards for the sempid value).  Slowpaths, and
particularly SEM_UNDO calls, must undo any altered sem when it is detected
that the caller must block or has errored-out.

With larger sets, there can occur situations where this involves a lot of
cycles and can obviously be a suboptimal use of cached resources in shared
memory.  Ie, discarding CPU caches that are also calling semop and have
the sembuf cached (and can complete), while the current lock holder doing
the semop will block, error, or does a waitforzero operation.

This patch proposes still iterating the set twice, but the first scan is
read-only, and we perform the actual updates afterward, once we know that
the call will succeed.  In order to not suffer from the overhead of
dealing with sops that act on the same sem_num, such (rare) cases use
perform_atomic_semop_slow(), which is exactly what we have now. 
Duplicates are detected before grabbing sem_lock, and uses simple a
32/64-bit hash array variable to based on the sem_num we are working on.

In addition add some comments to when we expect to the caller to block.

Link: http://lkml.kernel.org/r/20160921194603.GB21438@linux-80c1.suse
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  111 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 101 insertions(+), 10 deletions(-)

diff -puN ipc/sem.c~ipc-sem-optimize-perform_atomic_semop ipc/sem.c
--- a/ipc/sem.c~ipc-sem-optimize-perform_atomic_semop
+++ a/ipc/sem.c
@@ -115,7 +115,8 @@ struct sem_queue {
 	struct sembuf		*sops;	 /* array of pending operations */
 	struct sembuf		*blocking; /* the operation that blocked */
 	int			nsops;	 /* number of operations */
-	int			alter;	 /* does *sops alter the array? */
+	bool			alter;	 /* does *sops alter the array? */
+	bool                    dupsop;	 /* sops on more than one sem_num */
 };
 
 /* Each task has a list of undo requests. They are executed automatically
@@ -604,15 +605,23 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 }
 
 /**
- * perform_atomic_semop - Perform (if possible) a semaphore operation
+ * perform_atomic_semop[_slow] - Attempt to perform semaphore
+ *                               operations on a given array.
  * @sma: semaphore array
  * @q: struct sem_queue that describes the operation
  *
+ * Caller blocking are as follows, based the value
+ * indicated by the semaphore operation (sem_op):
+ *
+ *  (1) >0 never blocks.
+ *  (2)  0 (wait-for-zero operation): semval is non-zero.
+ *  (3) <0 attempting to decrement semval to a value smaller than zero.
+ *
  * Returns 0 if the operation was possible.
  * Returns 1 if the operation is impossible, the caller must sleep.
- * Negative values are error codes.
+ * Returns <0 for error codes.
  */
-static int perform_atomic_semop(struct sem_array *sma, struct sem_queue *q)
+static int perform_atomic_semop_slow(struct sem_array *sma, struct sem_queue *q)
 {
 	int result, sem_op, nsops, pid;
 	struct sembuf *sop;
@@ -683,6 +692,71 @@ undo:
 	return result;
 }
 
+static int perform_atomic_semop(struct sem_array *sma, struct sem_queue *q)
+{
+	int result, sem_op, nsops;
+	struct sembuf *sop;
+	struct sem *curr;
+	struct sembuf *sops;
+	struct sem_undo *un;
+
+	sops = q->sops;
+	nsops = q->nsops;
+	un = q->undo;
+
+	if (unlikely(q->dupsop))
+		return perform_atomic_semop_slow(sma, q);
+
+	/*
+	 * We scan the semaphore set twice, first to ensure that the entire
+	 * operation can succeed, therefore avoiding any pointless writes
+	 * to shared memory and having to undo such changes in order to block
+	 * until the operations can go through.
+	 */
+	for (sop = sops; sop < sops + nsops; sop++) {
+		curr = sma->sem_base + sop->sem_num;
+		sem_op = sop->sem_op;
+		result = curr->semval;
+
+		if (!sem_op && result)
+			goto would_block; /* wait-for-zero */
+
+		result += sem_op;
+		if (result < 0)
+			goto would_block;
+
+		if (result > SEMVMX)
+			return -ERANGE;
+
+		if (sop->sem_flg & SEM_UNDO) {
+			int undo = un->semadj[sop->sem_num] - sem_op;
+
+			/* Exceeding the undo range is an error. */
+			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
+				return -ERANGE;
+		}
+	}
+
+	for (sop = sops; sop < sops + nsops; sop++) {
+		curr = sma->sem_base + sop->sem_num;
+		sem_op = sop->sem_op;
+		result = curr->semval;
+
+		if (sop->sem_flg & SEM_UNDO) {
+			int undo = un->semadj[sop->sem_num] - sem_op;
+			un->semadj[sop->sem_num] = undo;
+		}
+		curr->semval += sem_op;
+		curr->sempid = q->pid;
+	}
+
+	return 0;
+
+would_block:
+	q->blocking = sop;
+	return sop->sem_flg & IPC_NOWAIT? -EAGAIN : 1;
+}
+
 static inline void wake_up_sem_queue_prepare(struct sem_queue *q, int error,
 					     struct wake_q_head *wake_q)
 {
@@ -1737,9 +1811,10 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	struct sembuf fast_sops[SEMOPM_FAST];
 	struct sembuf *sops = fast_sops, *sop;
 	struct sem_undo *un;
-	int undos = 0, alter = 0, max, locknum;
+	int max, locknum;
+	bool undos = false, alter = false, dupsop = false;
 	struct sem_queue queue;
-	unsigned long jiffies_left = 0;
+	unsigned long dup = 0, jiffies_left = 0;
 	struct ipc_namespace *ns;
 
 	ns = current->nsproxy->ipc_ns;
@@ -1753,10 +1828,12 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		if (sops == NULL)
 			return -ENOMEM;
 	}
+
 	if (copy_from_user(sops, tsops, nsops * sizeof(*tsops))) {
 		error =  -EFAULT;
 		goto out_free;
 	}
+
 	if (timeout) {
 		struct timespec _timeout;
 		if (copy_from_user(&_timeout, timeout, sizeof(*timeout))) {
@@ -1770,17 +1847,30 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		}
 		jiffies_left = timespec_to_jiffies(&_timeout);
 	}
+
 	max = 0;
 	for (sop = sops; sop < sops + nsops; sop++) {
+		unsigned long mask = 1 << ((sop->sem_num) % BITS_PER_LONG);
+
 		if (sop->sem_num >= max)
 			max = sop->sem_num;
 		if (sop->sem_flg & SEM_UNDO)
-			undos = 1;
-		if (sop->sem_op != 0)
-			alter = 1;
+			undos = true;
+		if (dup & mask) {
+			/*
+			 * There was a previous alter access that appears
+			 * to have accessed the same semaphore, thus use
+			 * the dupsop logic. "appears", because the detection
+			 * can only check % BITS_PER_LONG.
+			 */
+			dupsop = true;
+		}
+		if (sop->sem_op != 0) {
+			alter = true;
+			dup |= mask;
+		}
 	}
 
