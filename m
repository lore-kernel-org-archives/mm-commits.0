From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-make-msgctl_nolock-lockless.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:21:41 -0700
Message-ID: <51dc9b05.4x83Q91LKfrP3Z08%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3GIXVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipcmsg-make-msgctl_nolock-lockless.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:41 -0700


The patch titled
     Subject: ipc,msg: make msgctl_nolock lockless
has been removed from the -mm tree.  Its filename was
     ipcmsg-make-msgctl_nolock-lockless.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,msg: make msgctl_nolock lockless

While the INFO cmd doesn't take the ipc lock, the STAT commands do acquire
it unnecessarily.  We can do the permissions and security checks only
holding the rcu lock.

This function now mimics semctl_nolock().

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff -puN ipc/msg.c~ipcmsg-make-msgctl_nolock-lockless ipc/msg.c
--- a/ipc/msg.c~ipcmsg-make-msgctl_nolock-lockless
+++ a/ipc/msg.c
@@ -545,17 +545,25 @@ static int msgctl_nolock(struct ipc_name
 		if (!buf)
 			return -EFAULT;
 
+		memset(&tbuf, 0, sizeof(tbuf));
+
+		rcu_read_lock();
 		if (cmd == MSG_STAT) {
-			msq = msg_lock(ns, msqid);
-			if (IS_ERR(msq))
-				return PTR_ERR(msq);
+			msq = msq_obtain_object(ns, msqid);
+			if (IS_ERR(msq)) {
+				err = PTR_ERR(msq);
+				goto out_unlock;
+			}
 			success_return = msq->q_perm.id;
 		} else {
-			msq = msg_lock_check(ns, msqid);
-			if (IS_ERR(msq))
-				return PTR_ERR(msq);
+			msq = msq_obtain_object_check(ns, msqid);
+			if (IS_ERR(msq)) {
+				err = PTR_ERR(msq);
+				goto out_unlock;
+			}
 			success_return = 0;
 		}
+
 		err = -EACCES;
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock;
@@ -564,8 +572,6 @@ static int msgctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		memset(&tbuf, 0, sizeof(tbuf));
-
 		kernel_to_ipc64_perm(&msq->q_perm, &tbuf.msg_perm);
 		tbuf.msg_stime  = msq->q_stime;
 		tbuf.msg_rtime  = msq->q_rtime;
@@ -575,7 +581,8 @@ static int msgctl_nolock(struct ipc_name
 		tbuf.msg_qbytes = msq->q_qbytes;
 		tbuf.msg_lspid  = msq->q_lspid;
 		tbuf.msg_lrpid  = msq->q_lrpid;
-		msg_unlock(msq);
+		rcu_read_unlock();
+
 		if (copy_msqid_to_user(buf, &tbuf, version))
 			return -EFAULT;
 		return success_return;
@@ -587,7 +594,7 @@ static int msgctl_nolock(struct ipc_name
 
 	return err;
 out_unlock:
-	msg_unlock(msq);
+	rcu_read_unlock();
 	return err;
 }
 
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

