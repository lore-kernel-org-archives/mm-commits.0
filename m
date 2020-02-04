From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-document-and-update-memory-barriers.patch removed from -mm tree
Date: Tue, 04 Feb 2020 10:40:38 -0800
Message-ID: <20200204184038.gaKtaXKBt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727461AbgBDSkj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 1vier1@web.de, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mm-commits@vger.kernel.org, peterz@infradead.org, will.deacon@arm.com


The patch titled
     Subject: ipc/sem.c: document and update memory barriers
has been removed from the -mm tree.  Its filename was
     ipc-semc-document-and-update-memory-barriers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: document and update memory barriers

Document and update the memory barriers in ipc/sem.c:

- Add smp_store_release() to wake_up_sem_queue_prepare() and
  document why it is needed.

- Read q->status using READ_ONCE+smp_acquire__after_ctrl_dep().
  as the pair for the barrier inside wake_up_sem_queue_prepare().

- Add comments to all barriers, and mention the rules in the block
  regarding locking.

- Switch to using wake_q_add_safe().

Link: http://lkml.kernel.org/r/20191020123305.14715-6-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <1vier1@web.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   66 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 25 deletions(-)

--- a/ipc/sem.c~ipc-semc-document-and-update-memory-barriers
+++ a/ipc/sem.c
@@ -205,15 +205,38 @@ static int sysvipc_sem_proc_show(struct
  *
  * Memory ordering:
  * Most ordering is enforced by using spin_lock() and spin_unlock().
- * The special case is use_global_lock:
+ *
+ * Exceptions:
+ * 1) use_global_lock: (SEM_BARRIER_1)
  * Setting it from non-zero to 0 is a RELEASE, this is ensured by
- * using smp_store_release().
+ * using smp_store_release(): Immediately after setting it to 0,
+ * a simple op can start.
  * Testing if it is non-zero is an ACQUIRE, this is ensured by using
  * smp_load_acquire().
  * Setting it from 0 to non-zero must be ordered with regards to
  * this smp_load_acquire(), this is guaranteed because the smp_load_acquire()
  * is inside a spin_lock() and after a write from 0 to non-zero a
  * spin_lock()+spin_unlock() is done.
+ *
+ * 2) queue.status: (SEM_BARRIER_2)
+ * Initialization is done while holding sem_lock(), so no further barrier is
+ * required.
+ * Setting it to a result code is a RELEASE, this is ensured by both a
+ * smp_store_release() (for case a) and while holding sem_lock()
+ * (for case b).
+ * The AQUIRE when reading the result code without holding sem_lock() is
+ * achieved by using READ_ONCE() + smp_acquire__after_ctrl_dep().
+ * (case a above).
+ * Reading the result code while holding sem_lock() needs no further barriers,
+ * the locks inside sem_lock() enforce ordering (case b above)
+ *
+ * 3) current->state:
+ * current->state is set to TASK_INTERRUPTIBLE while holding sem_lock().
+ * The wakeup is handled using the wake_q infrastructure. wake_q wakeups may
+ * happen immediately after calling wake_q_add. As wake_q_add_safe() is called
+ * when holding sem_lock(), no further barriers are required.
+ *
+ * See also ipc/mqueue.c for more details on the covered races.
  */
 
 #define sc_semmsl	sem_ctls[0]
@@ -344,12 +367,8 @@ static void complexmode_tryleave(struct
 		return;
 	}
 	if (sma->use_global_lock == 1) {
-		/*
-		 * Immediately after setting use_global_lock to 0,
-		 * a simple op can start. Thus: all memory writes
-		 * performed by the current operation must be visible
-		 * before we set use_global_lock to 0.
-		 */
+
+		/* See SEM_BARRIER_1 for purpose/pairing */
 		smp_store_release(&sma->use_global_lock, 0);
 	} else {
 		sma->use_global_lock--;
@@ -400,7 +419,7 @@ static inline int sem_lock(struct sem_ar
 		 */
 		spin_lock(&sem->lock);
 
-		/* pairs with smp_store_release() */
+		/* see SEM_BARRIER_1 for purpose/pairing */
 		if (!smp_load_acquire(&sma->use_global_lock)) {
 			/* fast path successful! */
 			return sops->sem_num;
@@ -766,15 +785,12 @@ would_block:
 static inline void wake_up_sem_queue_prepare(struct sem_queue *q, int error,
 					     struct wake_q_head *wake_q)
 {
-	wake_q_add(wake_q, q->sleeper);
-	/*
-	 * Rely on the above implicit barrier, such that we can
-	 * ensure that we hold reference to the task before setting
-	 * q->status. Otherwise we could race with do_exit if the
-	 * task is awoken by an external event before calling
-	 * wake_up_process().
-	 */
-	WRITE_ONCE(q->status, error);
+	get_task_struct(q->sleeper);
+
+	/* see SEM_BARRIER_2 for purpuse/pairing */
+	smp_store_release(&q->status, error);
+
+	wake_q_add_safe(wake_q, q->sleeper);
 }
 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
@@ -2148,9 +2164,11 @@ static long do_semtimedop(int semid, str
 	}
 
 	do {
+		/* memory ordering ensured by the lock in sem_lock() */
 		WRITE_ONCE(queue.status, -EINTR);
 		queue.sleeper = current;
 
+		/* memory ordering is ensured by the lock in sem_lock() */
 		__set_current_state(TASK_INTERRUPTIBLE);
 		sem_unlock(sma, locknum);
 		rcu_read_unlock();
@@ -2173,13 +2191,8 @@ static long do_semtimedop(int semid, str
 		 */
 		error = READ_ONCE(queue.status);
 		if (error != -EINTR) {
-			/*
-			 * User space could assume that semop() is a memory
-			 * barrier: Without the mb(), the cpu could
-			 * speculatively read in userspace stale data that was
-			 * overwritten by the previous owner of the semaphore.
-			 */
-			smp_mb();
+			/* see SEM_BARRIER_2 for purpose/pairing */
+			smp_acquire__after_ctrl_dep();
 			goto out_free;
 		}
 
@@ -2189,6 +2202,9 @@ static long do_semtimedop(int semid, str
 		if (!ipc_valid_object(&sma->sem_perm))
 			goto out_unlock_free;
 
+		/*
+		 * No necessity for any barrier: We are protect by sem_lock()
+		 */
 		error = READ_ONCE(queue.status);
 
 		/*
_

Patches currently in -mm which might be from manfred@colorfullife.com are
