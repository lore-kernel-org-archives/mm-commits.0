From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-shorten-critical-region-in-msgsnd.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:21:45 -0700
Message-ID: <51dc9b09.qp3aH3pJUQnJjv4B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3GIXVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipcmsg-shorten-critical-region-in-msgsnd.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:45 -0700


The patch titled
     Subject: ipc,msg: shorten critical region in msgsnd
has been removed from the -mm tree.  Its filename was
     ipcmsg-shorten-critical-region-in-msgsnd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -698,10 +698,11 @@ long do_msgsnd(int msqid, long mtype, vo
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
@@ -709,11 +710,11 @@ long do_msgsnd(int msqid, long mtype, vo
 
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
@@ -723,32 +724,41 @@ long do_msgsnd(int msqid, long mtype, vo
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
 
@@ -764,9 +774,10 @@ long do_msgsnd(int msqid, long mtype, vo
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

origin.patch

