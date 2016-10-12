From: akpm@linux-foundation.org
Subject: [merged] ipc-msg-batch-queue-sender-wakeups.patch removed from
 -mm tree
Date: Wed, 12 Oct 2016 12:25:43 -0700
Message-ID: <57fe8e37.RgeBVEm33qi3SKLk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33455 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbcJLTZo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, bigeasy@linutronix.de, dbueso@suse.de, manfred@colorfullife.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: batch queue sender wakeups
has been removed from the -mm tree.  Its filename was
     ipc-msg-batch-queue-sender-wakeups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/msg: batch queue sender wakeups

Currently the use of wake_qs in sysv msg queues are only for the receiver
tasks that are blocked on the queue.  But blocked sender tasks (due to
queue size constraints) still are awoken with the ipc object lock held,
which can be a problem particularly for small sized queues and far from
gracious for -rt (just like it was for the receiver side).

The paths that actually wakeup a sender are obviously related to when we
are either getting rid of the queue or after (some) space is freed-up
after a receiver takes the msg (msgrcv).  Furthermore, with the exception
of msgrcv, we can always piggy-back on expunge_all that has its own tasks
lined-up for waking.  Finally, upon unlinking the message, it should be no
problem delaying the wakeups a bit until after we've released the lock.

Link: http://lkml.kernel.org/r/1469748819-19484-3-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff -puN ipc/msg.c~ipc-msg-batch-queue-sender-wakeups ipc/msg.c
--- a/ipc/msg.c~ipc-msg-batch-queue-sender-wakeups
+++ a/ipc/msg.c
@@ -166,14 +166,15 @@ static inline void ss_del(struct msg_sen
 		list_del(&mss->list);
 }
 
-static void ss_wakeup(struct list_head *h, int kill)
+static void ss_wakeup(struct list_head *h,
+		      struct wake_q_head *wake_q, int kill)
 {
 	struct msg_sender *mss, *t;
 
 	list_for_each_entry_safe(mss, t, h, list) {
 		if (kill)
 			mss->list.next = NULL;
-		wake_up_process(mss->tsk);
+		wake_q_add(wake_q, mss->tsk);
 	}
 }
 
@@ -203,7 +204,7 @@ static void freeque(struct ipc_namespace
 	WAKE_Q(wake_q);
 
 	expunge_all(msq, -EIDRM, &wake_q);
-	ss_wakeup(&msq->q_senders, 1);
+	ss_wakeup(&msq->q_senders, &wake_q, 1);
 	msg_rmid(ns, msq);
 	ipc_unlock_object(&msq->q_perm);
 	wake_up_q(&wake_q);
@@ -331,7 +332,6 @@ static int msgctl_down(struct ipc_namesp
 	struct kern_ipc_perm *ipcp;
 	struct msqid64_ds uninitialized_var(msqid64);
 	struct msg_queue *msq;
-	WAKE_Q(wake_q);
 	int err;
 
 	if (cmd == IPC_SET) {
@@ -362,6 +362,9 @@ static int msgctl_down(struct ipc_namesp
 		freeque(ns, ipcp);
 		goto out_up;
 	case IPC_SET:
+	{
+		WAKE_Q(wake_q);
+
 		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EPERM;
@@ -376,15 +379,21 @@ static int msgctl_down(struct ipc_namesp
 		msq->q_qbytes = msqid64.msg_qbytes;
 
 		msq->q_ctime = get_seconds();
-		/* sleeping receivers might be excluded by
+		/*
+		 * Sleeping receivers might be excluded by
 		 * stricter permissions.
 		 */
 		expunge_all(msq, -EAGAIN, &wake_q);
-		/* sleeping senders might be able to send
+		/*
+		 * Sleeping senders might be able to send
 		 * due to a larger queue size.
 		 */
-		ss_wakeup(&msq->q_senders, 0);
-		break;
+		ss_wakeup(&msq->q_senders, &wake_q, 0);
+		ipc_unlock_object(&msq->q_perm);
+		wake_up_q(&wake_q);
+
+		goto out_unlock1;
+	}
 	default:
 		err = -EINVAL;
 		goto out_unlock1;
@@ -392,7 +401,6 @@ static int msgctl_down(struct ipc_namesp
 
 out_unlock0:
 	ipc_unlock_object(&msq->q_perm);
-	wake_up_q(&wake_q);
 out_unlock1:
 	rcu_read_unlock();
 out_up:
@@ -809,6 +817,7 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_queue *msq;
 	struct ipc_namespace *ns;
 	struct msg_msg *msg, *copy = NULL;
+	WAKE_Q(wake_q);
 
 	ns = current->nsproxy->ipc_ns;
 
@@ -873,7 +882,7 @@ long do_msgrcv(int msqid, void __user *b
 			msq->q_cbytes -= msg->m_ts;
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
 			atomic_dec(&ns->msg_hdrs);
-			ss_wakeup(&msq->q_senders, 0);
+			ss_wakeup(&msq->q_senders, &wake_q, 0);
 
 			goto out_unlock0;
 		}
@@ -945,6 +954,7 @@ long do_msgrcv(int msqid, void __user *b
 
 out_unlock0:
 	ipc_unlock_object(&msq->q_perm);
+	wake_up_q(&wake_q);
 out_unlock1:
 	rcu_read_unlock();
 	if (IS_ERR(msg)) {
_

Patches currently in -mm which might be from dave@stgolabs.net are


