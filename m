From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-prevent-race-with-rmid-in-msgsndmsgrcv.patch
 removed from -mm tree
Date: Thu, 17 Oct 2013 11:12:49 -0700
Message-ID: <526028a1.i4eAKNSIaPsY3+em%akpm__7081.64223838157$1382033590$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3JQSMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, efault@gmx.de, davidlohr@hp.com

Subject: [merged] ipcmsg-prevent-race-with-rmid-in-msgsndmsgrcv.patch removed from -mm tree
To: davidlohr@hp.com,efault@gmx.de,manfred@colorfullife.com,riel@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:49 -0700


The patch titled
     Subject: ipc,msg: prevent race with rmid in msgsnd,msgrcv
has been removed from the -mm tree.  Its filename was
     ipcmsg-prevent-race-with-rmid-in-msgsndmsgrcv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: prevent race with rmid in msgsnd,msgrcv

This fixes a race in both msgrcv() and msgsnd() between finding the msg
and actually dealing with the queue, as another thread can delete shmid
underneath us if we are preempted before acquiring the kern_ipc_perm.lock.

Manfred illustrates this nicely:

Assume a preemptible kernel that is preempted just after
> msq = msq_obtain_object_check(ns, msqid)
in do_msgrcv().
The only lock that is held is rcu_read_lock().

Now the other thread processes IPC_RMID.  When the first task is resumed,
then it will happily wait for messages on a deleted queue.

Fix this by checking for if the queue has been deleted after taking the
lock.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Reported-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: <stable@vger.kernel.org> 	[3.11]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN ipc/msg.c~ipcmsg-prevent-race-with-rmid-in-msgsndmsgrcv ipc/msg.c
--- a/ipc/msg.c~ipcmsg-prevent-race-with-rmid-in-msgsndmsgrcv
+++ a/ipc/msg.c
@@ -695,6 +695,12 @@ long do_msgsnd(int msqid, long mtype, vo
 		if (ipcperms(ns, &msq->q_perm, S_IWUGO))
 			goto out_unlock0;
 
+		/* raced with RMID? */
+		if (msq->q_perm.deleted) {
+			err = -EIDRM;
+			goto out_unlock0;
+		}
+
 		err = security_msg_queue_msgsnd(msq, msg, msgflg);
 		if (err)
 			goto out_unlock0;
@@ -901,6 +907,13 @@ long do_msgrcv(int msqid, void __user *b
 			goto out_unlock1;
 
 		ipc_lock_object(&msq->q_perm);
+
+		/* raced with RMID? */
+		if (msq->q_perm.deleted) {
+			msg = ERR_PTR(-EIDRM);
+			goto out_unlock0;
+		}
+
 		msg = find_msg(msq, &msgtyp, mode);
 		if (!IS_ERR(msg)) {
 			/*
_

Patches currently in -mm which might be from davidlohr@hp.com are

origin.patch

