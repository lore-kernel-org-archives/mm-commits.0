From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-shorten-critical-region-in-msgctl_down.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:21:37 -0700
Message-ID: <51dc9b01.yEXKO4jx8zNdyxpA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3GIXVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipcmsg-shorten-critical-region-in-msgctl_down.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:37 -0700


The patch titled
     Subject: ipc,msg: shorten critical region in msgctl_down
has been removed from the -mm tree.  Its filename was
     ipcmsg-shorten-critical-region-in-msgctl_down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -410,11 +410,10 @@ static int msgctl_down(struct ipc_namesp
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
 
@@ -422,10 +421,11 @@ static int msgctl_down(struct ipc_namesp
 
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
@@ -433,9 +433,10 @@ static int msgctl_down(struct ipc_namesp
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
@@ -454,6 +455,7 @@ static int msgctl_down(struct ipc_namesp
 		break;
 	default:
 		err = -EINVAL;
+		goto out_unlock1;
 	}
 
 out_unlock0:
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

