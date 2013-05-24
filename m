From: akpm@linux-foundation.org
Subject: + ipcmsg-shorten-critical-region-in-msgsnd.patch added to -mm
 tree
Date: Fri, 24 May 2013 13:17:42 -0700
Message-ID: <519fcae6.p1cMaaNwY4nsq25V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3EXURn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipcmsg-shorten-critical-region-in-msgsnd.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:42 -0700


The patch titled
     Subject: ipc,msg: shorten critical region in msgsnd
has been added to the -mm tree.  Its filename is
     ipcmsg-shorten-critical-region-in-msgsnd.patch

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
Subject: ipc,msg: shorten critical region in msgsnd

do_msgsnd() is another function that does too many things with the ipc
object lock acquired.  Take it only when needed when actually updating
msq.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff -puN ipc/msg.c~ipcmsg-shorten-critical-region-in-msgsnd ipc/msg.c
--- a/ipc/msg.c~ipcmsg-shorten-critical-region-in-msgsnd
+++ a/ipc/msg.c
@@ -700,10 +700,11 @@ long do_msgsnd(int msqid, long mtype, vo
 	msg->m_type = mtype;
 	msg->m_ts = msgsz;
 
-	msq = msg_lock_check(ns, msqid);
+	rcu_read_lock();
+	msq = msq_obtain_object_check(ns, msqid);
 	if (IS_ERR(msq)) {
 		err = PTR_ERR(msq);
-		goto out_free;
+		goto out_unlock1;
 	}
 
 	for (;;) {
@@ -711,11 +712,11 @@ long do_msgsnd(int msqid, long mtype, vo
 
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
-			goto out_unlock_free;
+			goto out_unlock1;
 
 		err = security_msg_queue_msgsnd(msq, msg, msgflg);
 		if (err)
-			goto out_unlock_free;
+			goto out_unlock1;
 
 		if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
 				1 + msq->q_qnum <= msq->q_qbytes) {
@@ -725,32 +726,41 @@ long do_msgsnd(int msqid, long mtype, vo
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
 			err = -EAGAIN;
-			goto out_unlock_free;
+			goto out_unlock1;
 		}
+
+		ipc_lock_object(&msq->q_perm);
 		ss_add(msq, &s);
 
 		if (!ipc_rcu_getref(msq)) {
 			err = -EIDRM;
-			goto out_unlock_free;
+			goto out_unlock0;
 		}
 
-		msg_unlock(msq);
+		ipc_unlock_object(&msq->q_perm);
+		rcu_read_unlock();
 		schedule();
 
-		ipc_lock_by_ptr(&msq->q_perm);
+		rcu_read_lock();
+		ipc_lock_object(&msq->q_perm);
+
 		ipc_rcu_putref(msq);
 		if (msq->q_perm.deleted) {
 			err = -EIDRM;
-			goto out_unlock_free;
+			goto out_unlock0;
 		}
+
 		ss_del(&s);
 
 		if (signal_pending(current)) {
 			err = -ERESTARTNOHAND;
-			goto out_unlock_free;
+			goto out_unlock0;
 		}
+
+		ipc_unlock_object(&msq->q_perm);
 	}
 
+	ipc_lock_object(&msq->q_perm);
 	msq->q_lspid = task_tgid_vnr(current);
 	msq->q_stime = get_seconds();
 
@@ -766,9 +776,10 @@ long do_msgsnd(int msqid, long mtype, vo
 	err = 0;
 	msg = NULL;
 
-out_unlock_free:
-	msg_unlock(msq);
-out_free:
+out_unlock0:
+	ipc_unlock_object(&msq->q_perm);
+out_unlock1:
+	rcu_read_unlock();
 	if (msg != NULL)
 		free_msg(msg);
 	return err;
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

