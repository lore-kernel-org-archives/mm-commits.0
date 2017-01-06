From: akpm@linux-foundation.org
Subject: + kernel-locking-compute-current-directly.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:19:26 -0800
Message-ID: <586ee28e.I6B8TnGmbci/D3U3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754765AbdAFASK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:18:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mark.rutland@arm.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/locking: compute current directly
has been added to the -mm tree.  Its filename is
     kernel-locking-compute-current-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-locking-compute-current-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-locking-compute-current-directly.patch

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
Subject: kernel/locking: compute current directly

This patch effectively replaces the tsk pointer dereference (which is
obviously == current), to directly use get_current() macro.  This is to
make the removal of setting foreign task states smoother and painfully
obvious.  Performance win on some archs such as x86-64 and ppc64.  On a
microbenchmark that calls set_task_state() vs set_current_state() and an
inode rwsem pounding benchmark doing unlink:

== 1. x86-64 ==

Avg runtime set_task_state():    601 msecs
Avg runtime set_current_state(): 552 msecs

                                            vanilla                 dirty
Hmean    unlink1-processes-2      36089.26 (  0.00%)    38977.33 (  8.00%)
Hmean    unlink1-processes-5      28555.01 (  0.00%)    29832.55 (  4.28%)
Hmean    unlink1-processes-8      37323.75 (  0.00%)    44974.57 ( 20.50%)
Hmean    unlink1-processes-12     43571.88 (  0.00%)    44283.01 (  1.63%)
Hmean    unlink1-processes-21     34431.52 (  0.00%)    38284.45 ( 11.19%)
Hmean    unlink1-processes-30     34813.26 (  0.00%)    37975.17 (  9.08%)
Hmean    unlink1-processes-48     37048.90 (  0.00%)    39862.78 (  7.59%)
Hmean    unlink1-processes-79     35630.01 (  0.00%)    36855.30 (  3.44%)
Hmean    unlink1-processes-110    36115.85 (  0.00%)    39843.91 ( 10.32%)
Hmean    unlink1-processes-141    32546.96 (  0.00%)    35418.52 (  8.82%)
Hmean    unlink1-processes-172    34674.79 (  0.00%)    36899.21 (  6.42%)
Hmean    unlink1-processes-203    37303.11 (  0.00%)    36393.04 ( -2.44%)
Hmean    unlink1-processes-224    35712.13 (  0.00%)    36685.96 (  2.73%)

== 2. ppc64le ==

Avg runtime set_task_state():  938 msecs
Avg runtime set_current_state: 940 msecs

                                            vanilla                 dirty
Hmean    unlink1-processes-2      19269.19 (  0.00%)    30704.50 ( 59.35%)
Hmean    unlink1-processes-5      20106.15 (  0.00%)    21804.15 (  8.45%)
Hmean    unlink1-processes-8      17496.97 (  0.00%)    17243.28 ( -1.45%)
Hmean    unlink1-processes-12     14224.15 (  0.00%)    17240.21 ( 21.20%)
Hmean    unlink1-processes-21     14155.66 (  0.00%)    15681.23 ( 10.78%)
Hmean    unlink1-processes-30     14450.70 (  0.00%)    15995.83 ( 10.69%)
Hmean    unlink1-processes-48     16945.57 (  0.00%)    16370.42 ( -3.39%)
Hmean    unlink1-processes-79     15788.39 (  0.00%)    14639.27 ( -7.28%)
Hmean    unlink1-processes-110    14268.48 (  0.00%)    14377.40 (  0.76%)
Hmean    unlink1-processes-141    14023.65 (  0.00%)    16271.69 ( 16.03%)
Hmean    unlink1-processes-172    13417.62 (  0.00%)    16067.55 ( 19.75%)
Hmean    unlink1-processes-203    15293.08 (  0.00%)    15440.40 (  0.96%)
Hmean    unlink1-processes-234    13719.32 (  0.00%)    16190.74 ( 18.01%)
Hmean    unlink1-processes-265    16400.97 (  0.00%)    16115.22 ( -1.74%)
Hmean    unlink1-processes-296    14388.60 (  0.00%)    16216.13 ( 12.70%)
Hmean    unlink1-processes-320    15771.85 (  0.00%)    15905.96 (  0.85%)

Link: http://lkml.kernel.org/r/1483479794-14013-4-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/mutex.c          |   19 +++++++++----------
 kernel/locking/rwsem-spinlock.c |   18 +++++++-----------
 kernel/locking/rwsem-xadd.c     |    7 +++----
 kernel/locking/semaphore.c      |    7 +++----
 4 files changed, 22 insertions(+), 29 deletions(-)

diff -puN kernel/locking/mutex.c~kernel-locking-compute-current-directly kernel/locking/mutex.c
--- a/kernel/locking/mutex.c~kernel-locking-compute-current-directly
+++ a/kernel/locking/mutex.c
@@ -622,7 +622,6 @@ __mutex_lock_common(struct mutex *lock,
 		    struct lockdep_map *nest_lock, unsigned long ip,
 		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
-	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
 	bool first = false;
@@ -656,18 +655,18 @@ __mutex_lock_common(struct mutex *lock,
 		goto skip_wait;
 
 	debug_mutex_lock_common(lock, &waiter);
-	debug_mutex_add_waiter(lock, &waiter, task);
+	debug_mutex_add_waiter(lock, &waiter, current);
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
-	waiter.task = task;
+	waiter.task = current;
 
 	if (__mutex_waiter_is_first(lock, &waiter))
 		__mutex_set_flag(lock, MUTEX_FLAG_WAITERS);
 
 	lock_contended(&lock->dep_map, ip);
 
-	set_task_state(task, state);
+	set_task_state(current, state);
 	for (;;) {
 		/*
 		 * Once we hold wait_lock, we're serialized against
@@ -683,7 +682,7 @@ __mutex_lock_common(struct mutex *lock,
 		 * wait_lock. This ensures the lock cancellation is ordered
 		 * against mutex_unlock() and wake-ups do not go missing.
 		 */
-		if (unlikely(signal_pending_state(state, task))) {
+		if (unlikely(signal_pending_state(state, current))) {
 			ret = -EINTR;
 			goto err;
 		}
@@ -702,7 +701,7 @@ __mutex_lock_common(struct mutex *lock,
 			__mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);
 		}
 
-		set_task_state(task, state);
+		set_task_state(current, state);
 		/*
 		 * Here we order against unlock; we must either see it change
 		 * state back to RUNNING and fall through the next schedule(),
@@ -716,9 +715,9 @@ __mutex_lock_common(struct mutex *lock,
 	}
 	spin_lock_mutex(&lock->wait_lock, flags);
 acquired:
-	__set_task_state(task, TASK_RUNNING);
+	__set_task_state(current, TASK_RUNNING);
 
-	mutex_remove_waiter(lock, &waiter, task);
+	mutex_remove_waiter(lock, &waiter, current);
 	if (likely(list_empty(&lock->wait_list)))
 		__mutex_clear_flag(lock, MUTEX_FLAGS);
 
@@ -736,8 +735,8 @@ skip_wait:
 	return 0;
 
 err:
-	__set_task_state(task, TASK_RUNNING);
-	mutex_remove_waiter(lock, &waiter, task);
+	__set_task_state(current, TASK_RUNNING);
+	mutex_remove_waiter(lock, &waiter, current);
 	spin_unlock_mutex(&lock->wait_lock, flags);
 	debug_mutex_free_waiter(&waiter);
 	mutex_release(&lock->dep_map, 1, ip);
diff -puN kernel/locking/rwsem-spinlock.c~kernel-locking-compute-current-directly kernel/locking/rwsem-spinlock.c
--- a/kernel/locking/rwsem-spinlock.c~kernel-locking-compute-current-directly
+++ a/kernel/locking/rwsem-spinlock.c
@@ -128,7 +128,6 @@ __rwsem_wake_one_writer(struct rw_semaph
 void __sched __down_read(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
-	struct task_struct *tsk;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
@@ -140,13 +139,12 @@ void __sched __down_read(struct rw_semap
 		goto out;
 	}
 
-	tsk = current;
-	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+	set_task_state(current, TASK_UNINTERRUPTIBLE);
 
 	/* set up my own style of waitqueue */
-	waiter.task = tsk;
+	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_READ;
-	get_task_struct(tsk);
+	get_task_struct(current);
 
 	list_add_tail(&waiter.list, &sem->wait_list);
 
@@ -158,10 +156,10 @@ void __sched __down_read(struct rw_semap
 		if (!waiter.task)
 			break;
 		schedule();
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		set_task_state(current, TASK_UNINTERRUPTIBLE);
 	}
 
-	__set_task_state(tsk, TASK_RUNNING);
+	__set_task_state(current, TASK_RUNNING);
  out:
 	;
 }
@@ -194,15 +192,13 @@ int __down_read_trylock(struct rw_semaph
 int __sched __down_write_common(struct rw_semaphore *sem, int state)
 {
 	struct rwsem_waiter waiter;
-	struct task_struct *tsk;
 	unsigned long flags;
 	int ret = 0;
 
 	raw_spin_lock_irqsave(&sem->wait_lock, flags);
 
 	/* set up my own style of waitqueue */
-	tsk = current;
-	waiter.task = tsk;
+	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_WRITE;
 	list_add_tail(&waiter.list, &sem->wait_list);
 
@@ -220,7 +216,7 @@ int __sched __down_write_common(struct r
 			ret = -EINTR;
 			goto out;
 		}
-		set_task_state(tsk, state);
+		set_task_state(current, state);
 		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 		schedule();
 		raw_spin_lock_irqsave(&sem->wait_lock, flags);
diff -puN kernel/locking/rwsem-xadd.c~kernel-locking-compute-current-directly kernel/locking/rwsem-xadd.c
--- a/kernel/locking/rwsem-xadd.c~kernel-locking-compute-current-directly
+++ a/kernel/locking/rwsem-xadd.c
@@ -224,10 +224,9 @@ struct rw_semaphore __sched *rwsem_down_
 {
 	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
 	struct rwsem_waiter waiter;
-	struct task_struct *tsk = current;
 	DEFINE_WAKE_Q(wake_q);
 
-	waiter.task = tsk;
+	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_READ;
 
 	raw_spin_lock_irq(&sem->wait_lock);
@@ -254,13 +253,13 @@ struct rw_semaphore __sched *rwsem_down_
 
 	/* wait to be given the lock */
 	while (true) {
-		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+		set_task_state(current, TASK_UNINTERRUPTIBLE);
 		if (!waiter.task)
 			break;
 		schedule();
 	}
 
-	__set_task_state(tsk, TASK_RUNNING);
+	__set_task_state(current, TASK_RUNNING);
 	return sem;
 }
 EXPORT_SYMBOL(rwsem_down_read_failed);
diff -puN kernel/locking/semaphore.c~kernel-locking-compute-current-directly kernel/locking/semaphore.c
--- a/kernel/locking/semaphore.c~kernel-locking-compute-current-directly
+++ a/kernel/locking/semaphore.c
@@ -204,19 +204,18 @@ struct semaphore_waiter {
 static inline int __sched __down_common(struct semaphore *sem, long state,
 								long timeout)
 {
-	struct task_struct *task = current;
 	struct semaphore_waiter waiter;
 
 	list_add_tail(&waiter.list, &sem->wait_list);
-	waiter.task = task;
+	waiter.task = current;
 	waiter.up = false;
 
 	for (;;) {
-		if (signal_pending_state(state, task))
+		if (signal_pending_state(state, current))
 			goto interrupted;
 		if (unlikely(timeout <= 0))
 			goto timed_out;
-		__set_task_state(task, state);
+		__set_task_state(current, state);
 		raw_spin_unlock_irq(&sem->lock);
 		timeout = schedule_timeout(timeout);
 		raw_spin_lock_irq(&sem->lock);
_

Patches currently in -mm which might be from dave@stgolabs.net are

kernel-exit-compute-current-directly.patch
drivers-tty-compute-current-directly.patch
kernel-locking-compute-current-directly.patch
sched-remove-set_task_state.patch

