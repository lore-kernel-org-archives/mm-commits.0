From: akpm@linux-foundation.org
Subject: + ipc-msg-implement-lockless-pipelined-wakeups.patch added to -mm tree
Date: Wed, 10 Aug 2016 15:53:30 -0700
Message-ID: <57abb06a.kv0s6Y4gpHF7Ad8J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbcHJWxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:53:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, dbueso@suse.de, manfred@colorfullife.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: implement lockless pipelined wakeups
has been added to the -mm tree.  Its filename is
     ipc-msg-implement-lockless-pipelined-wakeups.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-msg-implement-lockless-pipelined-wakeups.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-msg-implement-lockless-pipelined-wakeups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: ipc/msg: implement lockless pipelined wakeups

This patch moves the wakeup_process() invocation so it is not done under
the ipc global lock by making use of a lockless wake_q.  With this change,
the waiter is woken up once the message has been assigned and it does not
need to loop on SMP if the message points to NULL.  In the signal case we
still need to check the pointer under the lock to verify the state.

This change should also avoid the introduction of preempt_disable() in -RT
which avoids a busy-loop which pools for the NULL -> !NULL change if the
waiter has a higher priority compared to the waker.

By making use of wake_qs, the logic of sysv msg queues is greatly
simplified (and very well suited as we can batch lockless wakeups),
particularly around the lockless receive algorithm.

This has been tested with Manred's pmsg-shared tool on a "AMD A10-7800
Radeon R7, 12 Compute Cores 4C+8G":

test             |   before   |   after    | diff
-----------------|------------|------------|----------
pmsg-shared 8 60 | 19,347,422 | 30,442,191 | + ~57.34 %
pmsg-shared 4 60 | 21,367,197 | 35,743,458 | + ~67.28 %
pmsg-shared 2 60 | 22,884,224 | 24,278,200 | +  ~6.09 %

Link: http://lkml.kernel.org/r/1469748819-19484-2-git-send-email-dave@stgolabs.net
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |  133 +++++++++++++++-------------------------------------
 1 file changed, 40 insertions(+), 93 deletions(-)

diff -puN ipc/msg.c~ipc-msg-implement-lockless-pipelined-wakeups ipc/msg.c
--- a/ipc/msg.c~ipc-msg-implement-lockless-pipelined-wakeups
+++ a/ipc/msg.c
@@ -51,13 +51,7 @@ struct msg_receiver {
 	long			r_msgtype;
 	long			r_maxsize;
 
-	/*
-	 * Mark r_msg volatile so that the compiler
-	 * does not try to get smart and optimize
-	 * it. We rely on this for the lockless
-	 * receive algorithm.
-	 */
-	struct msg_msg		*volatile r_msg;
+	struct msg_msg		*r_msg;
 };
 
 /* one msg_sender for each sleeping sender */
@@ -183,21 +177,14 @@ static void ss_wakeup(struct list_head *
 	}
 }
 
-static void expunge_all(struct msg_queue *msq, int res)
+static void expunge_all(struct msg_queue *msq, int res,
+			struct wake_q_head *wake_q)
 {
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		msr->r_msg = NULL; /* initialize expunge ordering */
-		wake_up_process(msr->r_tsk);
-		/*
-		 * Ensure that the wakeup is visible before setting r_msg as
-		 * the receiving end depends on it: either spinning on a nil,
-		 * or dealing with -EAGAIN cases. See lockless receive part 1
-		 * and 2 in do_msgrcv().
-		 */
-		smp_wmb(); /* barrier (B) */
-		msr->r_msg = ERR_PTR(res);
+		wake_q_add(wake_q, msr->r_tsk);
+		WRITE_ONCE(msr->r_msg, ERR_PTR(res));
 	}
 }
 
@@ -213,11 +200,13 @@ static void freeque(struct ipc_namespace
 {
 	struct msg_msg *msg, *t;
 	struct msg_queue *msq = container_of(ipcp, struct msg_queue, q_perm);
+	WAKE_Q(wake_q);
 
-	expunge_all(msq, -EIDRM);
+	expunge_all(msq, -EIDRM, &wake_q);
 	ss_wakeup(&msq->q_senders, 1);
 	msg_rmid(ns, msq);
 	ipc_unlock_object(&msq->q_perm);
+	wake_up_q(&wake_q);
 	rcu_read_unlock();
 
 	list_for_each_entry_safe(msg, t, &msq->q_messages, m_list) {
@@ -342,6 +331,7 @@ static int msgctl_down(struct ipc_namesp
 	struct kern_ipc_perm *ipcp;
 	struct msqid64_ds uninitialized_var(msqid64);
 	struct msg_queue *msq;
+	WAKE_Q(wake_q);
 	int err;
 
 	if (cmd == IPC_SET) {
@@ -389,7 +379,7 @@ static int msgctl_down(struct ipc_namesp
 		/* sleeping receivers might be excluded by
 		 * stricter permissions.
 		 */
-		expunge_all(msq, -EAGAIN);
+		expunge_all(msq, -EAGAIN, &wake_q);
 		/* sleeping senders might be able to send
 		 * due to a larger queue size.
 		 */
@@ -402,6 +392,7 @@ static int msgctl_down(struct ipc_namesp
 
 out_unlock0:
 	ipc_unlock_object(&msq->q_perm);
+	wake_up_q(&wake_q);
 out_unlock1:
 	rcu_read_unlock();
 out_up:
@@ -566,7 +557,8 @@ static int testmsg(struct msg_msg *msg,
 	return 0;
 }
 
-static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
+static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg,
+				 struct wake_q_head *wake_q)
 {
 	struct msg_receiver *msr, *t;
 
@@ -577,27 +569,14 @@ static inline int pipelined_send(struct
 
 			list_del(&msr->r_list);
 			if (msr->r_maxsize < msg->m_ts) {
-				/* initialize pipelined send ordering */
-				msr->r_msg = NULL;
-				wake_up_process(msr->r_tsk);
-				/* barrier (B) see barrier comment below */
-				smp_wmb();
-				msr->r_msg = ERR_PTR(-E2BIG);
+				wake_q_add(wake_q, msr->r_tsk);
+				WRITE_ONCE(msr->r_msg, ERR_PTR(-E2BIG));
 			} else {
-				msr->r_msg = NULL;
 				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
 				msq->q_rtime = get_seconds();
-				wake_up_process(msr->r_tsk);
-				/*
-				 * Ensure that the wakeup is visible before
-				 * setting r_msg, as the receiving can otherwise
-				 * exit - once r_msg is set, the receiver can
-				 * continue. See lockless receive part 1 and 2
-				 * in do_msgrcv(). Barrier (B).
-				 */
-				smp_wmb();
-				msr->r_msg = msg;
 
+				wake_q_add(wake_q, msr->r_tsk);
+				WRITE_ONCE(msr->r_msg, msg);
 				return 1;
 			}
 		}
@@ -613,6 +592,7 @@ long do_msgsnd(int msqid, long mtype, vo
 	struct msg_msg *msg;
 	int err;
 	struct ipc_namespace *ns;
+	WAKE_Q(wake_q);
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -686,7 +666,6 @@ long do_msgsnd(int msqid, long mtype, vo
 			err = -EIDRM;
 			goto out_unlock0;
 		}
-
 		ss_del(&s);
 
 		if (signal_pending(current)) {
@@ -698,7 +677,7 @@ long do_msgsnd(int msqid, long mtype, vo
 	msq->q_lspid = task_tgid_vnr(current);
 	msq->q_stime = get_seconds();
 
-	if (!pipelined_send(msq, msg)) {
+	if (!pipelined_send(msq, msg, &wake_q)) {
 		/* no one is waiting for this message, enqueue it */
 		list_add_tail(&msg->m_list, &msq->q_messages);
 		msq->q_cbytes += msgsz;
@@ -712,6 +691,7 @@ long do_msgsnd(int msqid, long mtype, vo
 
 out_unlock0:
 	ipc_unlock_object(&msq->q_perm);
+	wake_up_q(&wake_q);
 out_unlock1:
 	rcu_read_unlock();
 	if (msg != NULL)
@@ -919,71 +899,38 @@ long do_msgrcv(int msqid, void __user *b
 		rcu_read_unlock();
 		schedule();
 
-		/* Lockless receive, part 1:
-		 * Disable preemption.  We don't hold a reference to the queue
-		 * and getting a reference would defeat the idea of a lockless
-		 * operation, thus the code relies on rcu to guarantee the
-		 * existence of msq:
+		/*
+		 * Lockless receive, part 1:
+		 * We don't hold a reference to the queue and getting a
+		 * reference would defeat the idea of a lockless operation,
+		 * thus the code relies on rcu to guarantee the existence of
+		 * msq:
 		 * Prior to destruction, expunge_all(-EIRDM) changes r_msg.
 		 * Thus if r_msg is -EAGAIN, then the queue not yet destroyed.
-		 * rcu_read_lock() prevents preemption between reading r_msg
-		 * and acquiring the q_perm.lock in ipc_lock_object().
 		 */
 		rcu_read_lock();
 
-		/* Lockless receive, part 2:
-		 * Wait until pipelined_send or expunge_all are outside of
-		 * wake_up_process(). There is a race with exit(), see
-		 * ipc/mqueue.c for the details. The correct serialization
-		 * ensures that a receiver cannot continue without the wakeup
-		 * being visibible _before_ setting r_msg:
-		 *
-		 * CPU 0                             CPU 1
-		 * <loop receiver>
-		 *   smp_rmb(); (A) <-- pair -.      <waker thread>
-		 *   <load ->r_msg>           |        msr->r_msg = NULL;
-		 *                            |        wake_up_process();
-		 * <continue>                 `------> smp_wmb(); (B)
-		 *                                     msr->r_msg = msg;
+		/*
+		 * Lockless receive, part 2:
+		 * The work in pipelined_send() and expunge_all():
+		 * - Set pointer to message
+		 * - Queue the receiver task for later wakeup
+		 * - Wake up the process after the lock is dropped.
 		 *
-		 * Where (A) orders the message value read and where (B) orders
-		 * the write to the r_msg -- done in both pipelined_send and
-		 * expunge_all.
-		 */
-		for (;;) {
-			/*
-			 * Pairs with writer barrier in pipelined_send
-			 * or expunge_all.
-			 */
-			smp_rmb(); /* barrier (A) */
-			msg = (struct msg_msg *)msr_d.r_msg;
-			if (msg)
-				break;
-
-			/*
-			 * The cpu_relax() call is a compiler barrier
-			 * which forces everything in this loop to be
-			 * re-loaded.
-			 */
-			cpu_relax();
-		}
-
-		/* Lockless receive, part 3:
-		 * If there is a message or an error then accept it without
-		 * locking.
+		 * Should the process wake up before this wakeup (due to a
+		 * signal) it will either see the message and continue ...
 		 */
+		msg = READ_ONCE(msr_d.r_msg);
 		if (msg != ERR_PTR(-EAGAIN))
 			goto out_unlock1;
 
-		/* Lockless receive, part 3:
-		 * Acquire the queue spinlock.
-		 */
+		 /*
+		  * ... or see -EAGAIN, acquire the lock to check the message
+		  * again.
+		  */
 		ipc_lock_object(&msq->q_perm);
 
-		/* Lockless receive, part 4:
-		 * Repeat test after acquiring the spinlock.
-		 */
-		msg = (struct msg_msg *)msr_d.r_msg;
+		msg = msr_d.r_msg;
 		if (msg != ERR_PTR(-EAGAIN))
 			goto out_unlock0;
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

ipc-msg-implement-lockless-pipelined-wakeups.patch

