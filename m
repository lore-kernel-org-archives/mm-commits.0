From: akpm@linux-foundation.org
Subject: [merged] ipc-msg-avoid-waking-sender-upon-full-queue.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:25:48 -0700
Message-ID: <57fe8e3c.iTlf8gRE8CaweZJU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934014AbcJLTZt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, bigeasy@linutronix.de, dbueso@suse.de, manfred@colorfullife.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: avoid waking sender upon full queue
has been removed from the -mm tree.  Its filename was
     ipc-msg-avoid-waking-sender-upon-full-queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/msg: avoid waking sender upon full queue

Blocked tasks queued in q_senders waiting for their message to fit in the
queue are blindly awoken every time we think there's a remote chance this
might happen.  This could cause numerous (and expensive -- thundering
herd-ish) bogus wakeups if the queue is still really full.  Adding to the
scheduling cost/overhead, there's also the fact that we need to take the
ipc object lock and requeue ourselves in the q_senders list.

By keeping track of the blocked sender's message size, we can know
previously if the wakeup ought to occur or not.  Otherwise, to maintain
the current wakeup order we just move it to the tail.  This is exactly
what occurs right now if the sender needs to go back to sleep.

The case of EIDRM is left completely untouched, as we need to wakeup all
the tasks, and shouldn't be playing games in the first place.

This patch was seen to save on the 'msgctl10' ltp testcase ~15% in context
switches (avg out of ten runs).  Although these tests are really about
functionality (as opposed to performance), is does show the direct
benefits of the optimization.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/1469748819-19484-6-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   53 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff -puN ipc/msg.c~ipc-msg-avoid-waking-sender-upon-full-queue ipc/msg.c
--- a/ipc/msg.c~ipc-msg-avoid-waking-sender-upon-full-queue
+++ a/ipc/msg.c
@@ -58,6 +58,7 @@ struct msg_receiver {
 struct msg_sender {
 	struct list_head	list;
 	struct task_struct	*tsk;
+	size_t                  msgsz;
 };
 
 #define SEARCH_ANY		1
@@ -153,27 +154,60 @@ static int newque(struct ipc_namespace *
 	return msq->q_perm.id;
 }
 
-static inline void ss_add(struct msg_queue *msq, struct msg_sender *mss)
+static inline bool msg_fits_inqueue(struct msg_queue *msq, size_t msgsz)
+{
+	return msgsz + msq->q_cbytes <= msq->q_qbytes &&
+		1 + msq->q_qnum <= msq->q_qbytes;
+}
+
+static inline void ss_add(struct msg_queue *msq,
+			  struct msg_sender *mss, size_t msgsz)
 {
 	mss->tsk = current;
+	mss->msgsz = msgsz;
 	__set_current_state(TASK_INTERRUPTIBLE);
 	list_add_tail(&mss->list, &msq->q_senders);
 }
 
 static inline void ss_del(struct msg_sender *mss)
 {
-	if (mss->list.next != NULL)
+	if (mss->list.next)
 		list_del(&mss->list);
 }
 
-static void ss_wakeup(struct list_head *h,
+static void ss_wakeup(struct msg_queue *msq,
 		      struct wake_q_head *wake_q, bool kill)
 {
 	struct msg_sender *mss, *t;
+	struct task_struct *stop_tsk = NULL;
+	struct list_head *h = &msq->q_senders;
 
 	list_for_each_entry_safe(mss, t, h, list) {
 		if (kill)
 			mss->list.next = NULL;
+
+		/*
+		 * Stop at the first task we don't wakeup,
+		 * we've already iterated the original
+		 * sender queue.
+		 */
+		else if (stop_tsk == mss->tsk)
+			break;
+		/*
+		 * We are not in an EIDRM scenario here, therefore
+		 * verify that we really need to wakeup the task.
+		 * To maintain current semantics and wakeup order,
+		 * move the sender to the tail on behalf of the
+		 * blocked task.
+		 */
+		else if (!msg_fits_inqueue(msq, mss->msgsz)) {
+			if (!stop_tsk)
+				stop_tsk = mss->tsk;
+
+			list_move_tail(&mss->list, &msq->q_senders);
+			continue;
+		}
+
 		wake_q_add(wake_q, mss->tsk);
 	}
 }
@@ -204,7 +238,7 @@ static void freeque(struct ipc_namespace
 	WAKE_Q(wake_q);
 
 	expunge_all(msq, -EIDRM, &wake_q);
-	ss_wakeup(&msq->q_senders, &wake_q, true);
+	ss_wakeup(msq, &wake_q, true);
 	msg_rmid(ns, msq);
 	ipc_unlock_object(&msq->q_perm);
 	wake_up_q(&wake_q);
@@ -388,7 +422,7 @@ static int msgctl_down(struct ipc_namesp
 		 * Sleeping senders might be able to send
 		 * due to a larger queue size.
 		 */
-		ss_wakeup(&msq->q_senders, &wake_q, false);
+		ss_wakeup(msq, &wake_q, false);
 		ipc_unlock_object(&msq->q_perm);
 		wake_up_q(&wake_q);
 
@@ -642,10 +676,8 @@ long do_msgsnd(int msqid, long mtype, vo
 		if (err)
 			goto out_unlock0;
 
-		if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
-				1 + msq->q_qnum <= msq->q_qbytes) {
+		if (msg_fits_inqueue(msq, msgsz))
 			break;
-		}
 
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
@@ -654,7 +686,7 @@ long do_msgsnd(int msqid, long mtype, vo
 		}
 
 		/* enqueue the sender and prepare to block */
-		ss_add(msq, &s);
+		ss_add(msq, &s, msgsz);
 
 		if (!ipc_rcu_getref(msq)) {
 			err = -EIDRM;
@@ -682,6 +714,7 @@ long do_msgsnd(int msqid, long mtype, vo
 		}
 
 	}
+
 	msq->q_lspid = task_tgid_vnr(current);
 	msq->q_stime = get_seconds();
 
@@ -882,7 +915,7 @@ long do_msgrcv(int msqid, void __user *b
 			msq->q_cbytes -= msg->m_ts;
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
 			atomic_dec(&ns->msg_hdrs);
-			ss_wakeup(&msq->q_senders, &wake_q, false);
+			ss_wakeup(msq, &wake_q, false);
 
 			goto out_unlock0;
 		}
_

Patches currently in -mm which might be from dave@stgolabs.net are


