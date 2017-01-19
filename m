From: akpm@linux-foundation.org
Subject: [merged] sched-remove-set_task_state.patch removed from -mm tree
Date: Thu, 19 Jan 2017 11:23:55 -0800
Message-ID: <5881124b.ZfMr71ofOd/z1QEL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52324 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754406AbdASTYG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 14:24:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mark.rutland@arm.com, mingo@elte.hu, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched: remove set_task_state()
has been removed from the -mm tree.  Its filename was
     sched-remove-set_task_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: sched: remove set_task_state()

This is a nasty interface and setting the state of a foreign task must not
be done.  As of be628be0956 (bcache: Make gc wakeup sane, remove
set_task_state()) everyone in the kernel calls set_task_state() with
current, allowing the helper to be removed.  However, as the comment
indicates, it is still around for those archs where computing current is
more expensive than using a pointer, at least in theory.  An important
arch that is affected is arm64[1], however this has been addressed now[2]
and performance is up to par making no difference with either calls.

Of all the callers, if any, it's the locking bits that would care most
about this -- ie: we end up passing a tsk pointer to a lot of the lock
slowpath, and setting ->state on that.  The following numbers are based on
two tests: a custom ad-hoc microbenchmark that just measures latencies
(for ~65 million calls) between get_task_state() vs get_current_state().

Secondly for a higher overview, an unlink microbenchmark was used, which
pounds on a single file with open, close,unlink combos with increasing
thread counts (up to 4x ncpus).  While the workload is quite unrealistic,
it does contend a lot on the inode mutex or now rwsem.

[1] https://lkml.org/lkml/2016/12/30/230
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-January/476461.html

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

x86-64 (known to be fast for get_current()/this_cpu_read_stable() caching)
and ppc64 (with paca) show similar improvements in the unlink
microbenches.  The small delta for ppc64 (2ms), does not represent the
gains on the unlink runs.  In the case of x86, there was a decent amount
of variation in the latency runs, but always within a 20 to 50ms
increase), ppc was more constant.

Link: http://lkml.kernel.org/r/1483479794-14013-5-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/random.c                               |    2 
 drivers/md/dm-bufio.c                                  |    2 
 drivers/md/dm-crypt.c                                  |    4 -
 drivers/md/persistent-data/dm-block-manager.c          |    4 -
 drivers/staging/lustre/lnet/libcfs/linux/linux-debug.c |    2 
 drivers/tty/tty_ldsem.c                                |   10 +--
 include/linux/sched.h                                  |   27 ----------
 kernel/exit.c                                          |    4 -
 kernel/locking/mutex.c                                 |    8 +-
 kernel/locking/rwsem-spinlock.c                        |    8 +-
 kernel/locking/rwsem-xadd.c                            |    4 -
 kernel/locking/semaphore.c                             |    2 
 12 files changed, 26 insertions(+), 51 deletions(-)

diff -puN arch/um/drivers/random.c~sched-remove-set_task_state arch/um/drivers/random.c
--- a/arch/um/drivers/random.c~sched-remove-set_task_state
+++ a/arch/um/drivers/random.c
@@ -76,7 +76,7 @@ static ssize_t rng_dev_read (struct file
 			add_sigio_fd(random_fd);
 
 			add_wait_queue(&host_read_wait, &wait);
-			set_task_state(current, TASK_INTERRUPTIBLE);
+			set_current_state(TASK_INTERRUPTIBLE);
 
 			schedule();
 			remove_wait_queue(&host_read_wait, &wait);
diff -puN drivers/md/dm-bufio.c~sched-remove-set_task_state drivers/md/dm-bufio.c
--- a/drivers/md/dm-bufio.c~sched-remove-set_task_state
+++ a/drivers/md/dm-bufio.c
@@ -794,7 +794,7 @@ static void __wait_for_free_buffer(struc
 	DECLARE_WAITQUEUE(wait, current);
 
 	add_wait_queue(&c->free_buffer_wait, &wait);
-	set_task_state(current, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	dm_bufio_unlock(c);
 
 	io_schedule();
diff -puN drivers/md/dm-crypt.c~sched-remove-set_task_state drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~sched-remove-set_task_state
+++ a/drivers/md/dm-crypt.c
@@ -1210,14 +1210,14 @@ continue_locked:
 		spin_unlock_irq(&cc->write_thread_wait.lock);
 
 		if (unlikely(kthread_should_stop())) {
-			set_task_state(current, TASK_RUNNING);
+			set_current_state(TASK_RUNNING);
 			remove_wait_queue(&cc->write_thread_wait, &wait);
 			break;
 		}
 
 		schedule();
 
-		set_task_state(current, TASK_RUNNING);
+		set_current_state(TASK_RUNNING);
 		spin_lock_irq(&cc->write_thread_wait.lock);
 		__remove_wait_queue(&cc->write_thread_wait, &wait);
 		goto continue_locked;
diff -puN drivers/md/persistent-data/dm-block-manager.c~sched-remove-set_task_state drivers/md/persistent-data/dm-block-manager.c
--- a/drivers/md/persistent-data/dm-block-manager.c~sched-remove-set_task_state
+++ a/drivers/md/persistent-data/dm-block-manager.c
@@ -120,7 +120,7 @@ static int __check_holder(struct block_l
 static void __wait(struct waiter *w)
 {
 	for (;;) {
-		set_task_state(current, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 
 		if (!w->task)
 			break;
@@ -128,7 +128,7 @@ static void __wait(struct waiter *w)
 		schedule();
 	}
 
-	set_task_state(current, TASK_RUNNING);
+	set_current_state(TASK_RUNNING);
 }
 
 static void __wake_waiter(struct waiter *w)
diff -puN drivers/staging/lustre/lnet/libcfs/linux/linux-debug.c~sched-remove-set_task_state drivers/staging/lustre/lnet/libcfs/linux/linux-debug.c
--- a/drivers/staging/lustre/lnet/libcfs/linux/linux-debug.c~sched-remove-set_task_state
+++ a/drivers/staging/lustre/lnet/libcfs/linux/linux-debug.c
@@ -107,7 +107,7 @@ void __noreturn lbug_with_loc(struct lib
 		libcfs_debug_dumplog();
 	if (libcfs_panic_on_lbug)
 		panic("LBUG");
-	set_task_state(current, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	while (1)
 		schedule();
 }
diff -puN drivers/tty/tty_ldsem.c~sched-remove-set_task_state drivers/tty/tty_ldsem.c
--- a/drivers/tty/tty_ldsem.c~sched-remove-set_task_state
+++ a/drivers/tty/tty_ldsem.c
@@ -231,7 +231,7 @@ down_read_failed(struct ld_semaphore *se
 
 	/* wait to be given the lock */
 	for (;;) {
-		set_task_state(current, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 
 		if (!waiter.task)
 			break;
@@ -240,7 +240,7 @@ down_read_failed(struct ld_semaphore *se
 		timeout = schedule_timeout(timeout);
 	}
 
-	__set_task_state(current, TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 
 	if (!timeout) {
 		/* lock timed out but check if this task was just
@@ -289,14 +289,14 @@ down_write_failed(struct ld_semaphore *s
 
 	waiter.task = current;
 
-	set_task_state(current, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 	for (;;) {
 		if (!timeout)
 			break;
 		raw_spin_unlock_irq(&sem->wait_lock);
 		timeout = schedule_timeout(timeout);
 		raw_spin_lock_irq(&sem->wait_lock);
-		set_task_state(current, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		locked = writer_trylock(sem);
 		if (locked)
 			break;
@@ -307,7 +307,7 @@ down_write_failed(struct ld_semaphore *s
 	list_del(&waiter.list);
 	raw_spin_unlock_irq(&sem->wait_lock);
 
-	__set_task_state(current, TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 
 	/* lock wait may have timed out */
 	if (!locked)
diff -puN include/linux/sched.h~sched-remove-set_task_state include/linux/sched.h
--- a/include/linux/sched.h~sched-remove-set_task_state
+++ a/include/linux/sched.h
@@ -227,7 +227,7 @@ extern void proc_sched_set_task(struct t
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
 
-/* Convenience macros for the sake of set_task_state */
+/* Convenience macros for the sake of set_current_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
 #define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
 #define TASK_TRACED		(TASK_WAKEKILL | __TASK_TRACED)
@@ -254,17 +254,6 @@ extern char ___assert_task_state[1 - 2*!
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 
-#define __set_task_state(tsk, state_value)			\
-	do {							\
-		(tsk)->task_state_change = _THIS_IP_;		\
-		(tsk)->state = (state_value);			\
-	} while (0)
-#define set_task_state(tsk, state_value)			\
-	do {							\
-		(tsk)->task_state_change = _THIS_IP_;		\
-		smp_store_mb((tsk)->state, (state_value));	\
-	} while (0)
-
 #define __set_current_state(state_value)			\
 	do {							\
 		current->task_state_change = _THIS_IP_;		\
@@ -277,20 +266,6 @@ extern char ___assert_task_state[1 - 2*!
 	} while (0)
 
 #else
-
-/*
- * @tsk had better be current, or you get to keep the pieces.
- *
- * The only reason is that computing current can be more expensive than
- * using a pointer that's already available.
- *
- * Therefore, see set_current_state().
- */
-#define __set_task_state(tsk, state_value)		\
-	do { (tsk)->state = (state_value); } while (0)
-#define set_task_state(tsk, state_value)		\
-	smp_store_mb((tsk)->state, (state_value))
-
 /*
  * set_current_state() includes a barrier so that the write of current->state
  * is correctly serialised wrt the caller's subsequent test of whether to
diff -puN kernel/exit.c~sched-remove-set_task_state kernel/exit.c
--- a/kernel/exit.c~sched-remove-set_task_state
+++ a/kernel/exit.c
@@ -500,12 +500,12 @@ static void exit_mm(void)
 			complete(&core_state->startup);
 
 		for (;;) {
-			set_task_state(current, TASK_UNINTERRUPTIBLE);
+			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (!self.task) /* see coredump_finish() */
 				break;
 			freezable_schedule();
 		}
-		__set_task_state(current, TASK_RUNNING);
+		__set_current_state(TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
 	atomic_inc(&mm->mm_count);
diff -puN kernel/locking/mutex.c~sched-remove-set_task_state kernel/locking/mutex.c
--- a/kernel/locking/mutex.c~sched-remove-set_task_state
+++ a/kernel/locking/mutex.c
@@ -666,7 +666,7 @@ __mutex_lock_common(struct mutex *lock,
 
 	lock_contended(&lock->dep_map, ip);
 
-	set_task_state(current, state);
+	set_current_state(state);
 	for (;;) {
 		/*
 		 * Once we hold wait_lock, we're serialized against
@@ -701,7 +701,7 @@ __mutex_lock_common(struct mutex *lock,
 			__mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);
 		}
 
-		set_task_state(current, state);
+		set_current_state(state);
 		/*
 		 * Here we order against unlock; we must either see it change
 		 * state back to RUNNING and fall through the next schedule(),
@@ -715,7 +715,7 @@ __mutex_lock_common(struct mutex *lock,
 	}
 	spin_lock_mutex(&lock->wait_lock, flags);
 acquired:
-	__set_task_state(current, TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 
 	mutex_remove_waiter(lock, &waiter, current);
 	if (likely(list_empty(&lock->wait_list)))
@@ -735,7 +735,7 @@ skip_wait:
 	return 0;
 
 err:
-	__set_task_state(current, TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 	mutex_remove_waiter(lock, &waiter, current);
 	spin_unlock_mutex(&lock->wait_lock, flags);
 	debug_mutex_free_waiter(&waiter);
diff -puN kernel/locking/rwsem-spinlock.c~sched-remove-set_task_state kernel/locking/rwsem-spinlock.c
--- a/kernel/locking/rwsem-spinlock.c~sched-remove-set_task_state
+++ a/kernel/locking/rwsem-spinlock.c
@@ -139,7 +139,7 @@ void __sched __down_read(struct rw_semap
 		goto out;
 	}
 
-	set_task_state(current, TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_UNINTERRUPTIBLE);
 
 	/* set up my own style of waitqueue */
 	waiter.task = current;
@@ -156,10 +156,10 @@ void __sched __down_read(struct rw_semap
 		if (!waiter.task)
 			break;
 		schedule();
-		set_task_state(current, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 	}
 
-	__set_task_state(current, TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
  out:
 	;
 }
@@ -216,7 +216,7 @@ int __sched __down_write_common(struct r
 			ret = -EINTR;
 			goto out;
 		}
-		set_task_state(current, state);
+		set_current_state(state);
 		raw_spin_unlock_irqrestore(&sem->wait_lock, flags);
 		schedule();
 		raw_spin_lock_irqsave(&sem->wait_lock, flags);
diff -puN kernel/locking/rwsem-xadd.c~sched-remove-set_task_state kernel/locking/rwsem-xadd.c
--- a/kernel/locking/rwsem-xadd.c~sched-remove-set_task_state
+++ a/kernel/locking/rwsem-xadd.c
@@ -253,13 +253,13 @@ struct rw_semaphore __sched *rwsem_down_
 
 	/* wait to be given the lock */
 	while (true) {
-		set_task_state(current, TASK_UNINTERRUPTIBLE);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!waiter.task)
 			break;
 		schedule();
 	}
 
-	__set_task_state(current, TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 	return sem;
 }
 EXPORT_SYMBOL(rwsem_down_read_failed);
diff -puN kernel/locking/semaphore.c~sched-remove-set_task_state kernel/locking/semaphore.c
--- a/kernel/locking/semaphore.c~sched-remove-set_task_state
+++ a/kernel/locking/semaphore.c
@@ -215,7 +215,7 @@ static inline int __sched __down_common(
 			goto interrupted;
 		if (unlikely(timeout <= 0))
 			goto timed_out;
-		__set_task_state(current, state);
+		__set_current_state(state);
 		raw_spin_unlock_irq(&sem->lock);
 		timeout = schedule_timeout(timeout);
 		raw_spin_lock_irq(&sem->lock);
_

Patches currently in -mm which might be from dave@stgolabs.net are

m32r-use-generic-currenth.patch
mmcompaction-serialize-waitqueue_active-checks.patch

