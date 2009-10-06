From: akpm@linux-foundation.org
Subject: + ipc-semc-sem-preempt-improve.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:17:37 -0700
Message-ID: <200910062117.n96LHc7u000615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933406AbZJFVST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, manfred@colorfullife.com, peifferp@gmail.com


The patch titled
     ipc/sem.c: sem preempt improve
has been added to the -mm tree.  Its filename is
     ipc-semc-sem-preempt-improve.patch

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
Subject: ipc/sem.c: sem preempt improve
From: Nick Piggin <npiggin@suse.de>

The strange sysv semaphore wakeup scheme has a kind of busy-wait lock
involved, which could deadlock if preemption is enabled during the "lock".

It is an implementation detail (due to a spinlock being held) that this is
actually the case.  However if "spinlocks" are made preemptible, or if the
sem lock is changed to a sleeping lock for example, then the wakeup would
become buggy.  So this might be a bugfix for -rt kernels.

Imagine waker being preempted by wakee and never clearing IN_WAKEUP -- if
wakee has higher RT priority then there is a priority inversion deadlock. 
Even if there is not a priority inversion to cause a deadlock, then there
is still time wasted spinning.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff -puN ipc/sem.c~ipc-semc-sem-preempt-improve ipc/sem.c
--- a/ipc/sem.c~ipc-semc-sem-preempt-improve
+++ a/ipc/sem.c
@@ -397,6 +397,27 @@ undo:
 	return result;
 }
 
+/*
+ * Wake up a process waiting on the sem queue with a given error.
+ * The queue is invalid (may not be accessed) after the function returns.
+ */
+static void wake_up_sem_queue(struct sem_queue *q, int error)
+{
+	/*
+	 * Hold preempt off so that we don't get preempted and have the
+	 * wakee busy-wait until we're scheduled back on. We're holding
+	 * locks here so it may not strictly be needed, however if the
+	 * locks become preemptible then this prevents such a problem.
+	 */
+	preempt_disable();
+	q->status = IN_WAKEUP;
+	wake_up_process(q->sleeper);
+	/* hands-off: q can disappear immediately after writing q->status. */
+	smp_wmb();
+	q->status = error;
+	preempt_enable();
+}
+
 /* Go through the pending queue for the indicated semaphore
  * looking for tasks that can be completed.
  */
@@ -428,17 +449,7 @@ again:
 		 *   continue.
 		 */
 		alter = q->alter;
-
-		/* wake up the waiting thread */
-		q->status = IN_WAKEUP;
-
-		wake_up_process(q->sleeper);
-		/* hands-off: q will disappear immediately after
-		 * writing q->status.
-		 */
-		smp_wmb();
-		q->status = error;
-
+		wake_up_sem_queue(q, error);
 		if (alter)
 			goto again;
 	}
@@ -522,10 +533,7 @@ static void freeary(struct ipc_namespace
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
 		list_del(&q->list);
 
-		q->status = IN_WAKEUP;
-		wake_up_process(q->sleeper); /* doesn't sleep */
-		smp_wmb();
-		q->status = -EIDRM;	/* hands-off q */
+		wake_up_sem_queue(q, -EIDRM);
 	}
 
 	/* Remove the semaphore set from the IDR */
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
fs-remove-unneeded-dcache_unhashed-tricks.patch
fs-improve-remountro-vs-buffercache-coherency.patch
ipc-semc-sem-optimise-undo-list-search.patch
ipc-semc-sem-use-list-operations.patch
ipc-semc-sem-preempt-improve.patch
ipc-semc-optimize-if-semops-fail.patch
ipc-semc-add-a-per-semaphore-pending-list.patch
ipc-semc-optimize-single-semop-operations.patch
ipc-semc-optimize-single-sops-when-semval-is-zero.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

