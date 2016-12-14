From: akpm@linux-foundation.org
Subject: [patch 052/114] ipc/sem: rework task wakeups
Date: Wed, 14 Dec 2016 15:06:34 -0800
Message-ID: <5851d07a.cY00FBbux/nEeAqx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756928AbcLNXGf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:06:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, sfr@canb.auug.org.au

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: rework task wakeups

Our sysv sems have been using the notion of lockless wakeups for a while,
ever since 0a2b9d4c796 ("ipc/sem.c: move wake_up_process out of the
spinlock section"), in order to reduce the sem_lock hold times.  This
in-house pending queue can be replaced by wake_q (just like all the rest
of ipc now), in that it provides the following advantages:

o Simplifies and gets rid of unnecessary code.

o We get rid of the IN_WAKEUP complexities.  Given that wake_q_add()
  grabs reference to the task, if awoken due to an unrelated event,
  between the wake_q_add() and wake_up_q() window, we cannot race with
  sys_exit and the imminent call to wake_up_process().

o By not spinning IN_WAKEUP, we no longer need to disable preemption.

In consequence, the wakeup paths (after schedule(), that is) must
acknowledge an external signal/event, as well spurious wakeup occurring
during the pending wakeup window.  Obviously no changes in semantics that
could be visible to the user.  The fastpath is _only_ for when we know for
sure that we were awoken due to a the waker's successful semop call
(queue.status is not -EINTR).

On a 48-core Haswell, running the ipcscale 'waitforzero' test, the
following is seen with increasing thread counts:

                               v4.8-rc5                v4.8-rc5
                                                        semopv2
Hmean    sembench-sem-2      574733.00 (  0.00%)   578322.00 (  0.62%)
Hmean    sembench-sem-8      811708.00 (  0.00%)   824689.00 (  1.59%)
Hmean    sembench-sem-12     842448.00 (  0.00%)   845409.00 (  0.35%)
Hmean    sembench-sem-21     933003.00 (  0.00%)   977748.00 (  4.80%)
Hmean    sembench-sem-48     935910.00 (  0.00%)  1004759.00 (  7.36%)
Hmean    sembench-sem-79     937186.00 (  0.00%)   983976.00 (  4.99%)
Hmean    sembench-sem-234    974256.00 (  0.00%)  1060294.00 (  8.83%)
Hmean    sembench-sem-265    975468.00 (  0.00%)  1016243.00 (  4.18%)
Hmean    sembench-sem-296    991280.00 (  0.00%)  1042659.00 (  5.18%)
Hmean    sembench-sem-327    975415.00 (  0.00%)  1029977.00 (  5.59%)
Hmean    sembench-sem-358   1014286.00 (  0.00%)  1049624.00 (  3.48%)
Hmean    sembench-sem-389    972939.00 (  0.00%)  1043127.00 (  7.21%)
Hmean    sembench-sem-420    981909.00 (  0.00%)  1056747.00 (  7.62%)
Hmean    sembench-sem-451    990139.00 (  0.00%)  1051609.00 (  6.21%)
Hmean    sembench-sem-482    965735.00 (  0.00%)  1040313.00 (  7.72%)

[akpm@linux-foundation.org: coding-style fixes]
[sfr@canb.auug.org.au: merge fix for WAKE_Q to DEFINE_WAKE_Q rename]
  Link: http://lkml.kernel.org/r/20161122210410.5eca9fc2@canb.auug.org.au
Link: http://lkml.kernel.org/r/1474225896-10066-3-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  266 ++++++++++++++++------------------------------------
 1 file changed, 86 insertions(+), 180 deletions(-)

diff -puN ipc/sem.c~ipc-sem-rework-task-wakeups ipc/sem.c
--- a/ipc/sem.c~ipc-sem-rework-task-wakeups
+++ a/ipc/sem.c
@@ -11,6 +11,7 @@
  * (c) 2001 Red Hat Inc
  * Lockless wakeup
  * (c) 2003 Manfred Spraul <manfred@colorfullife.com>
+ * (c) 2016 Davidlohr Bueso <dave@stgolabs.net>
  * Further wakeup optimizations, documentation
  * (c) 2010 Manfred Spraul <manfred@colorfullife.com>
  *
@@ -53,15 +54,11 @@
  *   Semaphores are actively given to waiting tasks (necessary for FIFO).
  *   (see update_queue())
  * - To improve the scalability, the actual wake-up calls are performed after
- *   dropping all locks. (see wake_up_sem_queue_prepare(),
- *   wake_up_sem_queue_do())
+ *   dropping all locks. (see wake_up_sem_queue_prepare())
  * - All work is done by the waker, the woken up task does not have to do
  *   anything - not even acquiring a lock or dropping a refcount.
  * - A woken up task may not even touch the semaphore array anymore, it may
  *   have been destroyed already by a semctl(RMID).
- * - The synchronizations between wake-ups due to a timeout/signal and a
- *   wake-up due to a completed semaphore operation is achieved by using an
- *   intermediate state (IN_WAKEUP).
  * - UNDO values are stored in an array (one per process and per
  *   semaphore array, lazily allocated). For backwards compatibility, multiple
  *   modes for the UNDO variables are supported (per process, per thread)
@@ -471,40 +468,6 @@ static inline void sem_rmid(struct ipc_n
 	ipc_rmid(&sem_ids(ns), &s->sem_perm);
 }
 
-/*
- * Lockless wakeup algorithm:
- * Without the check/retry algorithm a lockless wakeup is possible:
- * - queue.status is initialized to -EINTR before blocking.
- * - wakeup is performed by
- *	* unlinking the queue entry from the pending list
- *	* setting queue.status to IN_WAKEUP
- *	  This is the notification for the blocked thread that a
- *	  result value is imminent.
- *	* call wake_up_process
- *	* set queue.status to the final value.
- * - the previously blocked thread checks queue.status:
- *	* if it's IN_WAKEUP, then it must wait until the value changes
- *	* if it's not -EINTR, then the operation was completed by
- *	  update_queue. semtimedop can return queue.status without
- *	  performing any operation on the sem array.
- *	* otherwise it must acquire the spinlock and check what's up.
- *
- * The two-stage algorithm is necessary to protect against the following
- * races:
- * - if queue.status is set after wake_up_process, then the woken up idle
- *   thread could race forward and try (and fail) to acquire sma->lock
- *   before update_queue had a chance to set queue.status
- * - if queue.status is written before wake_up_process and if the
- *   blocked process is woken up by a signal between writing
- *   queue.status and the wake_up_process, then the woken up
- *   process could return from semtimedop and die by calling
- *   sys_exit before wake_up_process is called. Then wake_up_process
- *   will oops, because the task structure is already invalid.
- *   (yes, this happened on s390 with sysv msg).
- *
- */
-#define IN_WAKEUP	1
-
 /**
  * newary - Create a new semaphore set
  * @ns: namespace
@@ -703,51 +666,18 @@ undo:
 	return result;
 }
 
-/** wake_up_sem_queue_prepare(q, error): Prepare wake-up
- * @q: queue entry that must be signaled
- * @error: Error value for the signal
- *
- * Prepare the wake-up of the queue entry q.
- */
-static void wake_up_sem_queue_prepare(struct list_head *pt,
-				struct sem_queue *q, int error)
+static inline void wake_up_sem_queue_prepare(struct sem_queue *q, int error,
+					     struct wake_q_head *wake_q)
 {
-	if (list_empty(pt)) {
-		/*
-		 * Hold preempt off so that we don't get preempted and have the
-		 * wakee busy-wait until we're scheduled back on.
-		 */
-		preempt_disable();
-	}
-	q->status = IN_WAKEUP;
-	q->pid = error;
-
-	list_add_tail(&q->list, pt);
-}
-
-/**
- * wake_up_sem_queue_do - do the actual wake-up
- * @pt: list of tasks to be woken up
- *
- * Do the actual wake-up.
- * The function is called without any locks held, thus the semaphore array
- * could be destroyed already and the tasks can disappear as soon as the
- * status is set to the actual return code.
- */
-static void wake_up_sem_queue_do(struct list_head *pt)
-{
-	struct sem_queue *q, *t;
-	int did_something;
-
-	did_something = !list_empty(pt);
-	list_for_each_entry_safe(q, t, pt, list) {
-		wake_up_process(q->sleeper);
-		/* q can disappear immediately after writing q->status. */
-		smp_wmb();
-		q->status = q->pid;
-	}
-	if (did_something)
-		preempt_enable();
+	wake_q_add(wake_q, q->sleeper);
+	/*
+	 * Rely on the above implicit barrier, such that we can
+	 * ensure that we hold reference to the task before setting
+	 * q->status. Otherwise we could race with do_exit if the
+	 * task is awoken by an external event before calling
+	 * wake_up_process().
+	 */
+	WRITE_ONCE(q->status, error);
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -795,18 +725,18 @@ static int check_restart(struct sem_arra
  * wake_const_ops - wake up non-alter tasks
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
- * @pt: list head for the tasks that must be woken up.
+ * @wake_q: lockless wake-queue head.
  *
  * wake_const_ops must be called after a semaphore in a semaphore array
  * was set to 0. If complex const operations are pending, wake_const_ops must
  * be called with semnum = -1, as well as with the number of each modified
  * semaphore.
- * The tasks that must be woken up are added to @pt. The return code
+ * The tasks that must be woken up are added to @wake_q. The return code
  * is stored in q->pid.
  * The function returns 1 if at least one operation was completed successfully.
  */
 static int wake_const_ops(struct sem_array *sma, int semnum,
-				struct list_head *pt)
+			  struct wake_q_head *wake_q)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
@@ -832,7 +762,7 @@ static int wake_const_ops(struct sem_arr
 
 			unlink_queue(sma, q);
 
-			wake_up_sem_queue_prepare(pt, q, error);
+			wake_up_sem_queue_prepare(q, error, wake_q);
 			if (error == 0)
 				semop_completed = 1;
 		}
@@ -845,14 +775,14 @@ static int wake_const_ops(struct sem_arr
  * @sma: semaphore array
  * @sops: operations that were performed
  * @nsops: number of operations
- * @pt: list head of the tasks that must be woken up.
+ * @wake_q: lockless wake-queue head
  *
  * Checks all required queue for wait-for-zero operations, based
  * on the actual changes that were performed on the semaphore array.
  * The function returns 1 if at least one operation was completed successfully.
  */
 static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
-					int nsops, struct list_head *pt)
+				int nsops, struct wake_q_head *wake_q)
 {
 	int i;
 	int semop_completed = 0;
@@ -865,7 +795,7 @@ static int do_smart_wakeup_zero(struct s
 
 			if (sma->sem_base[num].semval == 0) {
 				got_zero = 1;
-				semop_completed |= wake_const_ops(sma, num, pt);
+				semop_completed |= wake_const_ops(sma, num, wake_q);
 			}
 		}
 	} else {
@@ -876,7 +806,7 @@ static int do_smart_wakeup_zero(struct s
 		for (i = 0; i < sma->sem_nsems; i++) {
 			if (sma->sem_base[i].semval == 0) {
 				got_zero = 1;
-				semop_completed |= wake_const_ops(sma, i, pt);
+				semop_completed |= wake_const_ops(sma, i, wake_q);
 			}
 		}
 	}
@@ -885,7 +815,7 @@ static int do_smart_wakeup_zero(struct s
 	 * then check the global queue, too.
 	 */
 	if (got_zero)
-		semop_completed |= wake_const_ops(sma, -1, pt);
+		semop_completed |= wake_const_ops(sma, -1, wake_q);
 
 	return semop_completed;
 }
@@ -895,19 +825,19 @@ static int do_smart_wakeup_zero(struct s
  * update_queue - look for tasks that can be completed.
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
- * @pt: list head for the tasks that must be woken up.
+ * @wake_q: lockless wake-queue head.
  *
  * update_queue must be called after a semaphore in a semaphore array
  * was modified. If multiple semaphores were modified, update_queue must
  * be called with semnum = -1, as well as with the number of each modified
  * semaphore.
- * The tasks that must be woken up are added to @pt. The return code
+ * The tasks that must be woken up are added to @wake_q. The return code
  * is stored in q->pid.
  * The function internally checks if const operations can now succeed.
  *
  * The function return 1 if at least one semop was completed successfully.
  */
-static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
+static int update_queue(struct sem_array *sma, int semnum, struct wake_q_head *wake_q)
 {
 	struct sem_queue *q;
 	struct list_head *walk;
@@ -949,11 +879,11 @@ again:
 			restart = 0;
 		} else {
 			semop_completed = 1;
-			do_smart_wakeup_zero(sma, q->sops, q->nsops, pt);
+			do_smart_wakeup_zero(sma, q->sops, q->nsops, wake_q);
 			restart = check_restart(sma, q);
 		}
 
-		wake_up_sem_queue_prepare(pt, q, error);
+		wake_up_sem_queue_prepare(q, error, wake_q);
 		if (restart)
 			goto again;
 	}
@@ -984,24 +914,24 @@ static void set_semotime(struct sem_arra
  * @sops: operations that were performed
  * @nsops: number of operations
  * @otime: force setting otime
- * @pt: list head of the tasks that must be woken up.
+ * @wake_q: lockless wake-queue head
  *
  * do_smart_update() does the required calls to update_queue and wakeup_zero,
  * based on the actual changes that were performed on the semaphore array.
  * Note that the function does not do the actual wake-up: the caller is
- * responsible for calling wake_up_sem_queue_do(@pt).
+ * responsible for calling wake_up_q().
  * It is safe to perform this call after dropping all locks.
  */
 static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsops,
-			int otime, struct list_head *pt)
+			    int otime, struct wake_q_head *wake_q)
 {
 	int i;
 
-	otime |= do_smart_wakeup_zero(sma, sops, nsops, pt);
+	otime |= do_smart_wakeup_zero(sma, sops, nsops, wake_q);
 
 	if (!list_empty(&sma->pending_alter)) {
 		/* semaphore array uses the global queue - just process it. */
-		otime |= update_queue(sma, -1, pt);
+		otime |= update_queue(sma, -1, wake_q);
 	} else {
 		if (!sops) {
 			/*
@@ -1009,7 +939,7 @@ static void do_smart_update(struct sem_a
 			 * known. Check all.
 			 */
 			for (i = 0; i < sma->sem_nsems; i++)
-				otime |= update_queue(sma, i, pt);
+				otime |= update_queue(sma, i, wake_q);
 		} else {
 			/*
 			 * Check the semaphores that were increased:
@@ -1023,7 +953,7 @@ static void do_smart_update(struct sem_a
 			for (i = 0; i < nsops; i++) {
 				if (sops[i].sem_op > 0) {
 					otime |= update_queue(sma,
-							sops[i].sem_num, pt);
+							      sops[i].sem_num, wake_q);
 				}
 			}
 		}
@@ -1111,8 +1041,8 @@ static void freeary(struct ipc_namespace
 	struct sem_undo *un, *tu;
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
-	struct list_head tasks;
 	int i;
+	DEFINE_WAKE_Q(wake_q);
 
 	/* Free the existing undo structures for this semaphore set.  */
 	ipc_assert_locked_object(&sma->sem_perm);
@@ -1126,25 +1056,24 @@ static void freeary(struct ipc_namespace
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
-	INIT_LIST_HEAD(&tasks);
 	list_for_each_entry_safe(q, tq, &sma->pending_const, list) {
 		unlink_queue(sma, q);
-		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+		wake_up_sem_queue_prepare(q, -EIDRM, &wake_q);
 	}
 
 	list_for_each_entry_safe(q, tq, &sma->pending_alter, list) {
 		unlink_queue(sma, q);
-		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+		wake_up_sem_queue_prepare(q, -EIDRM, &wake_q);
 	}
 	for (i = 0; i < sma->sem_nsems; i++) {
 		struct sem *sem = sma->sem_base + i;
 		list_for_each_entry_safe(q, tq, &sem->pending_const, list) {
 			unlink_queue(sma, q);
-			wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+			wake_up_sem_queue_prepare(q, -EIDRM, &wake_q);
 		}
 		list_for_each_entry_safe(q, tq, &sem->pending_alter, list) {
 			unlink_queue(sma, q);
-			wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+			wake_up_sem_queue_prepare(q, -EIDRM, &wake_q);
 		}
 	}
 
@@ -1153,7 +1082,7 @@ static void freeary(struct ipc_namespace
 	sem_unlock(sma, -1);
 	rcu_read_unlock();
 
-	wake_up_sem_queue_do(&tasks);
+	wake_up_q(&wake_q);
 	ns->used_sems -= sma->sem_nsems;
 	ipc_rcu_putref(sma, sem_rcu_free);
 }
@@ -1292,9 +1221,9 @@ static int semctl_setval(struct ipc_name
 	struct sem_undo *un;
 	struct sem_array *sma;
 	struct sem *curr;
-	int err;
-	struct list_head tasks;
-	int val;
+	int err, val;
+	DEFINE_WAKE_Q(wake_q);
+
 #if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
 	/* big-endian 64bit */
 	val = arg >> 32;
@@ -1306,8 +1235,6 @@ static int semctl_setval(struct ipc_name
 	if (val > SEMVMX || val < 0)
 		return -ERANGE;
 
-	INIT_LIST_HEAD(&tasks);
-
 	rcu_read_lock();
 	sma = sem_obtain_object_check(ns, semid);
 	if (IS_ERR(sma)) {
@@ -1350,10 +1277,10 @@ static int semctl_setval(struct ipc_name
 	curr->sempid = task_tgid_vnr(current);
 	sma->sem_ctime = get_seconds();
 	/* maybe some queued-up processes were waiting for this */
-	do_smart_update(sma, NULL, 0, 0, &tasks);
+	do_smart_update(sma, NULL, 0, 0, &wake_q);
 	sem_unlock(sma, -1);
 	rcu_read_unlock();
-	wake_up_sem_queue_do(&tasks);
+	wake_up_q(&wake_q);
 	return 0;
 }
 
@@ -1365,9 +1292,7 @@ static int semctl_main(struct ipc_namesp
 	int err, nsems;
 	ushort fast_sem_io[SEMMSL_FAST];
 	ushort *sem_io = fast_sem_io;
-	struct list_head tasks;
-
-	INIT_LIST_HEAD(&tasks);
+	DEFINE_WAKE_Q(wake_q);
 
 	rcu_read_lock();
 	sma = sem_obtain_object_check(ns, semid);
@@ -1478,7 +1403,7 @@ static int semctl_main(struct ipc_namesp
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		do_smart_update(sma, NULL, 0, 0, &tasks);
+		do_smart_update(sma, NULL, 0, 0, &wake_q);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1514,7 +1439,7 @@ out_unlock:
 	sem_unlock(sma, -1);
 out_rcu_wakeup:
 	rcu_read_unlock();
-	wake_up_sem_queue_do(&tasks);
+	wake_up_q(&wake_q);
 out_free:
 	if (sem_io != fast_sem_io)
 		ipc_free(sem_io);
@@ -1787,32 +1712,6 @@ out:
 	return un;
 }
 
-
-/**
- * get_queue_result - retrieve the result code from sem_queue
- * @q: Pointer to queue structure
- *
- * Retrieve the return code from the pending queue. If IN_WAKEUP is found in
- * q->status, then we must loop until the value is replaced with the final
- * value: This may happen if a task is woken up by an unrelated event (e.g.
- * signal) and in parallel the task is woken up by another task because it got
- * the requested semaphores.
- *
- * The function can be called with or without holding the semaphore spinlock.
- */
-static int get_queue_result(struct sem_queue *q)
-{
-	int error;
-
-	error = q->status;
-	while (unlikely(error == IN_WAKEUP)) {
-		cpu_relax();
-		error = q->status;
-	}
-
-	return error;
-}
-
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1825,7 +1724,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
-	struct list_head tasks;
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -1865,7 +1763,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 			alter = 1;
 	}
 
-	INIT_LIST_HEAD(&tasks);
 
 	if (undos) {
 		/* On success, find_alloc_undo takes the rcu_read_lock */
@@ -1933,22 +1830,31 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	queue.alter = alter;
 
 	error = perform_atomic_semop(sma, &queue);
-	if (error == 0) {
-		/* If the operation was successful, then do
+	if (error == 0) { /* non-blocking succesfull path */
+		DEFINE_WAKE_Q(wake_q);
+
+		/*
+		 * If the operation was successful, then do
 		 * the required updates.
 		 */
 		if (alter)
-			do_smart_update(sma, sops, nsops, 1, &tasks);
+			do_smart_update(sma, sops, nsops, 1, &wake_q);
 		else
 			set_semotime(sma, sops);
+
+		sem_unlock(sma, locknum);
+		rcu_read_unlock();
+		wake_up_q(&wake_q);
+
+		goto out_free;
 	}
-	if (error <= 0)
+	if (error < 0) /* non-blocking error path */
 		goto out_unlock_free;
 
-	/* We need to sleep on this operation, so we put the current
+	/*
+	 * We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.
 	 */
-
 	if (nsops == 1) {
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
@@ -1977,10 +1883,10 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		sma->complex_count++;
 	}
 
+sleep_again:
 	queue.status = -EINTR;
 	queue.sleeper = current;
 
-sleep_again:
 	__set_current_state(TASK_INTERRUPTIBLE);
 	sem_unlock(sma, locknum);
 	rcu_read_unlock();
@@ -1990,28 +1896,31 @@ sleep_again:
 	else
 		schedule();
 
-	error = get_queue_result(&queue);
-
+	/*
+	 * fastpath: the semop has completed, either successfully or not, from
+	 * the syscall pov, is quite irrelevant to us at this point; we're done.
+	 *
+	 * We _do_ care, nonetheless, about being awoken by a signal or
+	 * spuriously.  The queue.status is checked again in the slowpath (aka
+	 * after taking sem_lock), such that we can detect scenarios where we
+	 * were awakened externally, during the window between wake_q_add() and
+	 * wake_up_q().
+	 */
+	error = READ_ONCE(queue.status);
 	if (error != -EINTR) {
-		/* fast path: update_queue already obtained all requested
-		 * resources.
-		 * Perform a smp_mb(): User space could assume that semop()
-		 * is a memory barrier: Without the mb(), the cpu could
-		 * speculatively read in user space stale data that was
-		 * overwritten by the previous owner of the semaphore.
+		/*
+		 * User space could assume that semop() is a memory barrier:
+		 * Without the mb(), the cpu could speculatively read in user
+		 * space stale data that was overwritten by the previous owner
+		 * of the semaphore.
 		 */
 		smp_mb();
-
 		goto out_free;
 	}
 
 	rcu_read_lock();
 	sma = sem_obtain_lock(ns, semid, sops, nsops, &locknum);
-
-	/*
-	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
-	 */
-	error = get_queue_result(&queue);
+	error = READ_ONCE(queue.status);
 
 	/*
 	 * Array removed? If yes, leave without sem_unlock().
@@ -2021,7 +1930,6 @@ sleep_again:
 		goto out_free;
 	}
 
-
 	/*
 	 * If queue.status != -EINTR we are woken up by another process.
 	 * Leave without unlink_queue(), but with sem_unlock().
@@ -2030,13 +1938,13 @@ sleep_again:
 		goto out_unlock_free;
 
 	/*
-	 * If an interrupt occurred we have to clean up the queue
+	 * If an interrupt occurred we have to clean up the queue.
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
 
 	/*
-	 * If the wakeup was spurious, just retry
+	 * If the wakeup was spurious, just retry.
 	 */
 	if (error == -EINTR && !signal_pending(current))
 		goto sleep_again;
@@ -2046,7 +1954,6 @@ sleep_again:
 out_unlock_free:
 	sem_unlock(sma, locknum);
 	rcu_read_unlock();
-	wake_up_sem_queue_do(&tasks);
 out_free:
 	if (sops != fast_sops)
 		kfree(sops);
@@ -2107,8 +2014,8 @@ void exit_sem(struct task_struct *tsk)
 	for (;;) {
 		struct sem_array *sma;
 		struct sem_undo *un;
-		struct list_head tasks;
 		int semid, i;
+		DEFINE_WAKE_Q(wake_q);
 
 		cond_resched();
 
@@ -2196,11 +2103,10 @@ void exit_sem(struct task_struct *tsk)
 			}
 		}
 		/* maybe some queued-up processes were waiting for this */
-		INIT_LIST_HEAD(&tasks);
-		do_smart_update(sma, NULL, 0, 1, &tasks);
+		do_smart_update(sma, NULL, 0, 1, &wake_q);
 		sem_unlock(sma, -1);
 		rcu_read_unlock();
-		wake_up_sem_queue_do(&tasks);
+		wake_up_q(&wake_q);
 
 		kfree_rcu(un, rcu);
 	}
_
