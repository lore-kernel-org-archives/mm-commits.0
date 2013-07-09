From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-shorten-critical-region-in-msgrcv.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:21:47 -0700
Message-ID: <51dc9b0b.BYfSmf7wcPE7Zr2j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GIXVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipcmsg-shorten-critical-region-in-msgrcv.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:47 -0700


The patch titled
     Subject: ipc,msg: shorten critical region in msgrcv
has been removed from the -mm tree.  Its filename was
     ipcmsg-shorten-critical-region-in-msgrcv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,msg: shorten critical region in msgrcv

do_msgrcv() is the last msg queue function that abuses the ipc lock Take
it only when needed when actually updating msq.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   58 ++++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff -puN ipc/msg.c~ipcmsg-shorten-critical-region-in-msgrcv ipc/msg.c
--- a/ipc/msg.c~ipcmsg-shorten-critical-region-in-msgrcv
+++ a/ipc/msg.c
@@ -885,21 +885,19 @@ static struct msg_msg *find_msg(struct m
 	return ERR_PTR(-EAGAIN);
 }
 
-
-long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
-	       int msgflg,
+long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgflg,
 	       long (*msg_handler)(void __user *, struct msg_msg *, size_t))
 {
-	struct msg_queue *msq;
-	struct msg_msg *msg;
 	int mode;
+	struct msg_queue *msq;
 	struct ipc_namespace *ns;
-	struct msg_msg *copy = NULL;
+	struct msg_msg *msg, *copy = NULL;
 
 	ns = current->nsproxy->ipc_ns;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
+
 	if (msgflg & MSG_COPY) {
 		copy = prepare_copy(buf, min_t(size_t, bufsz, ns->msg_ctlmax));
 		if (IS_ERR(copy))
@@ -907,8 +905,10 @@ long do_msgrcv(int msqid, void __user *b
 	}
 	mode = convert_mode(&msgtyp, msgflg);
 
-	msq = msg_lock_check(ns, msqid);
+	rcu_read_lock();
+	msq = msq_obtain_object_check(ns, msqid);
 	if (IS_ERR(msq)) {
+		rcu_read_unlock();
 		free_copy(copy);
 		return PTR_ERR(msq);
 	}
@@ -918,10 +918,10 @@ long do_msgrcv(int msqid, void __user *b
 
 		msg = ERR_PTR(-EACCES);
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
-			goto out_unlock;
+			goto out_unlock1;
 
+		ipc_lock_object(&msq->q_perm);
 		msg = find_msg(msq, &msgtyp, mode);
-
 		if (!IS_ERR(msg)) {
 			/*
 			 * Found a suitable message.
@@ -929,7 +929,7 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if ((bufsz < msg->m_ts) && !(msgflg & MSG_NOERROR)) {
 				msg = ERR_PTR(-E2BIG);
-				goto out_unlock;
+				goto out_unlock0;
 			}
 			/*
 			 * If we are copying, then do not unlink message and do
@@ -937,8 +937,9 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if (msgflg & MSG_COPY) {
 				msg = copy_msg(msg, copy);
-				goto out_unlock;
+				goto out_unlock0;
 			}
+
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
@@ -947,14 +948,16 @@ long do_msgrcv(int msqid, void __user *b
 			atomic_sub(msg->m_ts, &ns->msg_bytes);
 			atomic_dec(&ns->msg_hdrs);
 			ss_wakeup(&msq->q_senders, 0);
-			msg_unlock(msq);
-			break;
+
+			goto out_unlock0;
 		}
+
 		/* No message waiting. Wait for a message */
 		if (msgflg & IPC_NOWAIT) {
 			msg = ERR_PTR(-ENOMSG);
-			goto out_unlock;
+			goto out_unlock0;
 		}
+
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
 		msr_d.r_tsk = current;
 		msr_d.r_msgtype = msgtyp;
@@ -965,8 +968,9 @@ long do_msgrcv(int msqid, void __user *b
 			msr_d.r_maxsize = bufsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
 		current->state = TASK_INTERRUPTIBLE;
-		msg_unlock(msq);
 
+		ipc_unlock_object(&msq->q_perm);
+		rcu_read_unlock();
 		schedule();
 
 		/* Lockless receive, part 1:
@@ -977,7 +981,7 @@ long do_msgrcv(int msqid, void __user *b
 		 * Prior to destruction, expunge_all(-EIRDM) changes r_msg.
 		 * Thus if r_msg is -EAGAIN, then the queue not yet destroyed.
 		 * rcu_read_lock() prevents preemption between reading r_msg
-		 * and the spin_lock() inside ipc_lock_by_ptr().
+		 * and acquiring the q_perm.lock in ipc_lock_object().
 		 */
 		rcu_read_lock();
 
@@ -996,32 +1000,34 @@ long do_msgrcv(int msqid, void __user *b
 		 * If there is a message or an error then accept it without
 		 * locking.
 		 */
-		if (msg != ERR_PTR(-EAGAIN)) {
-			rcu_read_unlock();
-			break;
-		}
+		if (msg != ERR_PTR(-EAGAIN))
+			goto out_unlock1;
 
 		/* Lockless receive, part 3:
 		 * Acquire the queue spinlock.
 		 */
-		ipc_lock_by_ptr(&msq->q_perm);
-		rcu_read_unlock();
+		ipc_lock_object(&msq->q_perm);
 
 		/* Lockless receive, part 4:
 		 * Repeat test after acquiring the spinlock.
 		 */
 		msg = (struct msg_msg*)msr_d.r_msg;
 		if (msg != ERR_PTR(-EAGAIN))
-			goto out_unlock;
+			goto out_unlock0;
 
 		list_del(&msr_d.r_list);
 		if (signal_pending(current)) {
 			msg = ERR_PTR(-ERESTARTNOHAND);
-out_unlock:
-			msg_unlock(msq);
-			break;
+			goto out_unlock0;
 		}
+
+		ipc_unlock_object(&msq->q_perm);
 	}
+
+out_unlock0:
+	ipc_unlock_object(&msq->q_perm);
+out_unlock1:
+	rcu_read_unlock();
 	if (IS_ERR(msg)) {
 		free_copy(copy);
 		return PTR_ERR(msg);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

