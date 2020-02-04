From: akpm@linux-foundation.org
Subject: [merged]
 ipc-mqueuec-update-document-memory-barriers.patch removed from -mm tree
Date: Tue, 04 Feb 2020 10:40:33 -0800
Message-ID: <20200204184033.DMf5i-sHv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbgBDSkf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 1vier1@web.de, dbueso@suse.de, longman@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, peterz@infradead.org, will.deacon@arm.com


The patch titled
     Subject: ipc/mqueue.c: update/document memory barriers
has been removed from the -mm tree.  Its filename was
     ipc-mqueuec-update-document-memory-barriers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/mqueue.c: update/document memory barriers

Update and document memory barriers for mqueue.c:

- ewp->state is read without any locks, thus READ_ONCE is required.

- add smp_aquire__after_ctrl_dep() after the READ_ONCE, we need
  acquire semantics if the value is STATE_READY.

- use wake_q_add_safe()

- document why __set_current_state() may be used:
  Reading task->state cannot happen before the wake_q_add() call,
  which happens while holding info->lock. Thus the spin_unlock()
  is the RELEASE, and the spin_lock() is the ACQUIRE.

For completeness: there is also a 3 CPU scenario, if the to be woken
up task is already on another wake_q.
Then:
- CPU1: spin_unlock() of the task that goes to sleep is the RELEASE
- CPU2: the spin_lock() of the waker is the ACQUIRE
- CPU2: smp_mb__before_atomic inside wake_q_add() is the RELEASE
- CPU3: smp_mb__after_spinlock() inside try_to_wake_up() is the ACQUIRE

Link: http://lkml.kernel.org/r/20191020123305.14715-4-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Waiman Long <longman@redhat.com>
Cc: <1vier1@web.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   92 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 14 deletions(-)

--- a/ipc/mqueue.c~ipc-mqueuec-update-document-memory-barriers
+++ a/ipc/mqueue.c
@@ -63,6 +63,66 @@ struct posix_msg_tree_node {
 	int			priority;
 };
 
+/*
+ * Locking:
+ *
+ * Accesses to a message queue are synchronized by acquiring info->lock.
+ *
+ * There are two notable exceptions:
+ * - The actual wakeup of a sleeping task is performed using the wake_q
+ *   framework. info->lock is already released when wake_up_q is called.
+ * - The exit codepaths after sleeping check ext_wait_queue->state without
+ *   any locks. If it is STATE_READY, then the syscall is completed without
+ *   acquiring info->lock.
+ *
+ * MQ_BARRIER:
+ * To achieve proper release/acquire memory barrier pairing, the state is set to
+ * STATE_READY with smp_store_release(), and it is read with READ_ONCE followed
+ * by smp_acquire__after_ctrl_dep(). In addition, wake_q_add_safe() is used.
+ *
+ * This prevents the following races:
+ *
+ * 1) With the simple wake_q_add(), the task could be gone already before
+ *    the increase of the reference happens
+ * Thread A
+ *				Thread B
+ * WRITE_ONCE(wait.state, STATE_NONE);
+ * schedule_hrtimeout()
+ *				wake_q_add(A)
+ *				if (cmpxchg()) // success
+ *				   ->state = STATE_READY (reordered)
+ * <timeout returns>
+ * if (wait.state == STATE_READY) return;
+ * sysret to user space
+ * sys_exit()
+ *				get_task_struct() // UaF
+ *
+ * Solution: Use wake_q_add_safe() and perform the get_task_struct() before
+ * the smp_store_release() that does ->state = STATE_READY.
+ *
+ * 2) Without proper _release/_acquire barriers, the woken up task
+ *    could read stale data
+ *
+ * Thread A
+ *				Thread B
+ * do_mq_timedreceive
+ * WRITE_ONCE(wait.state, STATE_NONE);
+ * schedule_hrtimeout()
+ *				state = STATE_READY;
+ * <timeout returns>
+ * if (wait.state == STATE_READY) return;
+ * msg_ptr = wait.msg;		// Access to stale data!
+ *				receiver->msg = message; (reordered)
+ *
+ * Solution: use _release and _acquire barriers.
+ *
+ * 3) There is intentionally no barrier when setting current->state
+ *    to TASK_INTERRUPTIBLE: spin_unlock(&info->lock) provides the
+ *    release memory barrier, and the wakeup is triggered when holding
+ *    info->lock, i.e. spin_lock(&info->lock) provided a pairing
+ *    acquire memory barrier.
+ */
+
 struct ext_wait_queue {		/* queue of sleeping tasks */
 	struct task_struct *task;
 	struct list_head list;
@@ -646,18 +706,23 @@ static int wq_sleep(struct mqueue_inode_
 	wq_add(info, sr, ewp);
 
 	for (;;) {
+		/* memory barrier not required, we hold info->lock */
 		__set_current_state(TASK_INTERRUPTIBLE);
 
 		spin_unlock(&info->lock);
 		time = schedule_hrtimeout_range_clock(timeout, 0,
 			HRTIMER_MODE_ABS, CLOCK_REALTIME);
 
-		if (ewp->state == STATE_READY) {
+		if (READ_ONCE(ewp->state) == STATE_READY) {
+			/* see MQ_BARRIER for purpose/pairing */
+			smp_acquire__after_ctrl_dep();
 			retval = 0;
 			goto out;
 		}
 		spin_lock(&info->lock);
-		if (ewp->state == STATE_READY) {
+
+		/* we hold info->lock, so no memory barrier required */
+		if (READ_ONCE(ewp->state) == STATE_READY) {
 			retval = 0;
 			goto out_unlock;
 		}
@@ -923,16 +988,11 @@ static inline void __pipelined_op(struct
 				  struct ext_wait_queue *this)
 {
 	list_del(&this->list);
-	wake_q_add(wake_q, this->task);
-	/*
-	 * Rely on the implicit cmpxchg barrier from wake_q_add such
-	 * that we can ensure that updating receiver->state is the last
-	 * write operation: As once set, the receiver can continue,
-	 * and if we don't have the reference count from the wake_q,
-	 * yet, at that point we can later have a use-after-free
-	 * condition and bogus wakeup.
-	 */
-	this->state = STATE_READY;
+	get_task_struct(this->task);
+
+	/* see MQ_BARRIER for purpose/pairing */
+	smp_store_release(&this->state, STATE_READY);
+	wake_q_add_safe(wake_q, this->task);
 }
 
 /* pipelined_send() - send a message directly to the task waiting in
@@ -1049,7 +1109,9 @@ static int do_mq_timedsend(mqd_t mqdes,
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
-			wait.state = STATE_NONE;
+
+			/* memory barrier not required, we hold info->lock */
+			WRITE_ONCE(wait.state, STATE_NONE);
 			ret = wq_sleep(info, SEND, timeout, &wait);
 			/*
 			 * wq_sleep must be called with info->lock held, and
@@ -1152,7 +1214,9 @@ static int do_mq_timedreceive(mqd_t mqde
 			ret = -EAGAIN;
 		} else {
 			wait.task = current;
-			wait.state = STATE_NONE;
+
+			/* memory barrier not required, we hold info->lock */
+			WRITE_ONCE(wait.state, STATE_NONE);
 			ret = wq_sleep(info, RECV, timeout, &wait);
 			msg_ptr = wait.msg;
 		}
_

Patches currently in -mm which might be from manfred@colorfullife.com are
