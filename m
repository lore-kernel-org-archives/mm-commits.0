From: akpm@linux-foundation.org
Subject: + ipcmsg-shorten-critical-region-in-msgctl_down.patch added to
 -mm tree
Date: Fri, 24 May 2013 13:17:38 -0700
Message-ID: <519fcae2.VsCdh6qwwEHHudp1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab3EXURj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipcmsg-shorten-critical-region-in-msgctl_down.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:38 -0700


The patch titled
     Subject: ipc,msg: shorten critical region in msgctl_down
has been added to the -mm tree.  Its filename is
     ipcmsg-shorten-critical-region-in-msgctl_down.patch

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
Subject: ipc,msg: shorten critical region in msgctl_down

Instead of holding the ipc lock for the entire function, use the
ipcctl_pre_down_nolock and only acquire the lock for specific commands:
RMID and SET.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN ipc/msg.c~ipcmsg-shorten-critical-region-in-msgctl_down ipc/msg.c
--- a/ipc/msg.c~ipcmsg-shorten-critical-region-in-msgctl_down
+++ a/ipc/msg.c
@@ -412,11 +412,10 @@ static int msgctl_down(struct ipc_namesp
 	down_write(&msg_ids(ns).rw_mutex);
 	rcu_read_lock();
 
-	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
-			       &msqid64.msg_perm, msqid64.msg_qbytes);
+	ipcp = ipcctl_pre_down_nolock(ns, &msg_ids(ns), msqid, cmd,
+				      &msqid64.msg_perm, msqid64.msg_qbytes);
 	if (IS_ERR(ipcp)) {
 		err = PTR_ERR(ipcp);
-		/* the ipc lock is not held upon failure */
 		goto out_unlock1;
 	}
 
@@ -424,10 +423,11 @@ static int msgctl_down(struct ipc_namesp
 
 	err = security_msg_queue_msgctl(msq, cmd);
 	if (err)
-		goto out_unlock0;
+		goto out_unlock1;
 
 	switch (cmd) {
 	case IPC_RMID:
+		ipc_lock_object(&msq->q_perm);
 		/* freeque unlocks the ipc object and rcu */
 		freeque(ns, ipcp);
 		goto out_up;
@@ -435,9 +435,10 @@ static int msgctl_down(struct ipc_namesp
 		if (msqid64.msg_qbytes > ns->msg_ctlmnb &&
 		    !capable(CAP_SYS_RESOURCE)) {
 			err = -EPERM;
-			goto out_unlock0;
+			goto out_unlock1;
 		}
 
+		ipc_lock_object(&msq->q_perm);
 		err = ipc_update_perm(&msqid64.msg_perm, ipcp);
 		if (err)
 			goto out_unlock0;
@@ -456,6 +457,7 @@ static int msgctl_down(struct ipc_namesp
 		break;
 	default:
 		err = -EINVAL;
+		goto out_unlock1;
 	}
 
 out_unlock0:
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

