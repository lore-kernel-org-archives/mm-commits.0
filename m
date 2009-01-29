From: akpm@linux-foundation.org
Subject: + wait-prevent-exclusive-waiter-starvation.patch added to -mm tree
Date: Wed, 28 Jan 2009 23:41:25 -0800
Message-ID: <200901290741.n0T7fPNN024006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbZA2Hma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 02:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, a.p.zijlstra@chello.nl, cel@citi.umich.edu, chris.mason@oracle.com, matthew@wil.cx, mingo@elte.hu, nickpiggin@yahoo.com.au, oleg@redhat.com


The patch titled
     wait: prevent exclusive waiter starvation
has been added to the -mm tree.  Its filename is
     wait-prevent-exclusive-waiter-starvation.patch

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
Subject: wait: prevent exclusive waiter starvation
From: Johannes Weiner <hannes@cmpxchg.org>

With exclusive waiters, every process woken up through the wait queue must
ensure that the next waiter down the line is woken when it has finished.

Interruptible waiters don't do that when aborting due to a signal.  And if
an aborting waiter is concurrently woken up through the waitqueue, noone
will ever wake up the next waiter.

This has been observed with __wait_on_bit_lock() used by
lock_page_killable(): the first contender on the queue was aborting when
the actual lock holder woke it up concurrently.  The aborted contender
didn't acquire the lock and therefor never did an unlock followed by
waking up the next waiter.

Add abort_exclusive_wait() which removes the process' wait descriptor from
the waitqueue, iff still queued, or wakes up the next waiter otherwise. 
It does so under the waitqueue lock.  Racing with a wake up means the
aborting process is either already woken (removed from the queue) and will
wake up the next waiter, or it will remove itself from the queue and the
concurrent wake up will apply to the next waiter after it.

Use abort_exclusive_wait() in __wait_event_interruptible_exclusive() and
__wait_on_bit_lock() when they were interrupted by other means than a wake
up through the queue.

Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Mentored-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chuck Lever <cel@citi.umich.edu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   11 ++++++-
 kernel/sched.c       |    4 +-
 kernel/wait.c        |   58 ++++++++++++++++++++++++++++++++++++-----
 3 files changed, 62 insertions(+), 11 deletions(-)

diff -puN include/linux/wait.h~wait-prevent-exclusive-waiter-starvation include/linux/wait.h
--- a/include/linux/wait.h~wait-prevent-exclusive-waiter-starvation
+++ a/include/linux/wait.h
@@ -132,6 +132,8 @@ static inline void __remove_wait_queue(w
 	list_del(&old->task_list);
 }
 
+void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, int sync, void *key);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
 extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
@@ -333,16 +335,19 @@ do {									\
 	for (;;) {							\
 		prepare_to_wait_exclusive(&wq, &__wait,			\
 					TASK_INTERRUPTIBLE);		\
-		if (condition)						\
+		if (condition) {					\
+			finish_wait(&wq, &__wait);			\
 			break;						\
+		}							\
 		if (!signal_pending(current)) {				\
 			schedule();					\
 			continue;					\
 		}							\
 		ret = -ERESTARTSYS;					\
+		abort_exclusive_wait(&wq, &__wait, 			\
+				TASK_INTERRUPTIBLE, NULL);		\
 		break;							\
 	}								\
-	finish_wait(&wq, &__wait);					\
 } while (0)
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
@@ -431,6 +436,8 @@ extern long interruptible_sleep_on_timeo
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
+void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
+			unsigned int mode, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
diff -puN kernel/sched.c~wait-prevent-exclusive-waiter-starvation kernel/sched.c
--- a/kernel/sched.c~wait-prevent-exclusive-waiter-starvation
+++ a/kernel/sched.c
@@ -4843,8 +4843,8 @@ EXPORT_SYMBOL(default_wake_function);
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
-static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			     int nr_exclusive, int sync, void *key)
+void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, int sync, void *key)
 {
 	wait_queue_t *curr, *next;
 
diff -puN kernel/wait.c~wait-prevent-exclusive-waiter-starvation kernel/wait.c
--- a/kernel/wait.c~wait-prevent-exclusive-waiter-starvation
+++ a/kernel/wait.c
@@ -91,6 +91,15 @@ prepare_to_wait_exclusive(wait_queue_hea
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
+/*
+ * finish_wait - clean up after waiting in a queue
+ * @q: waitqueue waited on
+ * @wait: wait descriptor
+ *
+ * Sets current thread back to running state and removes
+ * the wait descriptor from the given waitqueue if still
+ * queued.
+ */
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
@@ -117,6 +126,39 @@ void finish_wait(wait_queue_head_t *q, w
 }
 EXPORT_SYMBOL(finish_wait);
 
+/*
+ * abort_exclusive_wait - abort exclusive waiting in a queue
+ * @q: waitqueue waited on
+ * @wait: wait descriptor
+ * @state: runstate of the waiter to be woken
+ * @key: key to identify a wait bit queue or %NULL
+ *
+ * Sets current thread back to running state and removes
+ * the wait descriptor from the given waitqueue if still
+ * queued.
+ *
+ * Wakes up the next waiter if the caller is concurrently
+ * woken up through the queue.
+ *
+ * This prevents waiter starvation where an exclusive waiter
+ * aborts and is woken up concurrently and noone wakes up
+ * the next waiter.
+ */
+void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
+			unsigned int mode, void *key)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	spin_lock_irqsave(&q->lock, flags);
+	if (!list_empty(&wait->task_list))
+		list_del_init(&wait->task_list);
+	else if (waitqueue_active(q))
+		__wake_up_common(q, mode, 1, 0, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(abort_exclusive_wait);
+
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
 	int ret = default_wake_function(wait, mode, sync, key);
@@ -177,17 +219,19 @@ int __sched
 __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 			int (*action)(void *), unsigned mode)
 {
-	int ret = 0;
-
 	do {
+		int ret;
+
 		prepare_to_wait_exclusive(wq, &q->wait, mode);
-		if (test_bit(q->key.bit_nr, q->key.flags)) {
-			if ((ret = (*action)(q->key.flags)))
-				break;
-		}
+		if (!test_bit(q->key.bit_nr, q->key.flags))
+			continue;
+		if (!(ret = action(q->key.flags)))
+			continue;
+		abort_exclusive_wait(wq, &q->wait, mode, &q->key);
+		return ret;
 	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
 	finish_wait(wq, &q->wait);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(__wait_on_bit_lock);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
wait-prevent-exclusive-waiter-starvation.patch
powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch

