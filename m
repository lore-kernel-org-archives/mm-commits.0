From: akpm@linux-foundation.org
Subject: + ipcmsg-shorten-critical-region-in-msgrcv.patch added to -mm
 tree
Date: Fri, 24 May 2013 13:17:43 -0700
Message-ID: <519fcae7.o+2WgjHxFm8MgZ1a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3EXURo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipcmsg-shorten-critical-region-in-msgrcv.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:43 -0700


The patch titled
     Subject: ipc,msg: shorten critical region in msgrcv
has been added to the -mm tree.  Its filename is
     ipcmsg-shorten-critical-region-in-msgrcv.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,msg: shorten critical region in msgrcv

do_msgrcv() is the last msg queue function that abuses the ipc lock Take
it only when needed when actually updating msq.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   57 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff -puN ipc/msg.c~ipcmsg-shorten-critical-region-in-msgrcv ipc/msg.c
--- a/ipc/msg.c~ipcmsg-shorten-critical-region-in-msgrcv
+++ a/ipc/msg.c
@@ -887,21 +887,19 @@ static struct msg_msg *find_msg(struct m
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
@@ -909,8 +907,10 @@ long do_msgrcv(int msqid, void __user *b
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
@@ -920,10 +920,9 @@ long do_msgrcv(int msqid, void __user *b
 
 		msg = ERR_PTR(-EACCES);
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
-			goto out_unlock;
+			goto out_unlock1;
 
 		msg = find_msg(msq, &msgtyp, mode);
-
 		if (!IS_ERR(msg)) {
 			/*
 			 * Found a suitable message.
@@ -931,7 +930,7 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if ((bufsz < msg->m_ts) && !(msgflg & MSG_NOERROR)) {
 				msg = ERR_PTR(-E2BIG);
-				goto out_unlock;
+				goto out_unlock1;
 			}
 			/*
 			 * If we are copying, then do not unlink message and do
@@ -939,8 +938,10 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if (msgflg & MSG_COPY) {
 				msg = copy_msg(msg, copy);
-				goto out_unlock;
+				goto out_unlock1;
 			}
+
+			ipc_lock_object(&msq->q_perm);
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
@@ -949,14 +950,17 @@ long do_msgrcv(int msqid, void __user *b
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
+			goto out_unlock1;
 		}
+
+		ipc_lock_object(&msq->q_perm);
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
 		msr_d.r_tsk = current;
 		msr_d.r_msgtype = msgtyp;
@@ -967,8 +971,9 @@ long do_msgrcv(int msqid, void __user *b
 			msr_d.r_maxsize = bufsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
 		current->state = TASK_INTERRUPTIBLE;
-		msg_unlock(msq);
 
+		ipc_unlock_object(&msq->q_perm);
+		rcu_read_unlock();
 		schedule();
 
 		/* Lockless receive, part 1:
@@ -998,32 +1003,34 @@ long do_msgrcv(int msqid, void __user *b
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

linux-next.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
softirq-use-_ret_ip_.patch
ipc-move-rcu-lock-out-of-ipc_addid.patch
ipc-introduce-ipc-object-locking-helpers.patch
ipc-close-open-coded-spin-lock-calls.patch
ipc-move-locking-out-of-ipcctl_pre_down_nolock.patch
ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-introduce-msgctl_nolock.patch
ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcmsg-make-msgctl_nolock-lockless.patch
ipcmsg-shorten-critical-region-in-msgsnd.patch
ipcmsg-shorten-critical-region-in-msgrcv.patch
ipc-remove-unused-functions.patch

