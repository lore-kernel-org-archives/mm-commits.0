From: akpm@linux-foundation.org
Subject: + ipcmsg-make-msgctl_nolock-lockless.patch added to -mm tree
Date: Fri, 24 May 2013 13:17:41 -0700
Message-ID: <519fcae5.snFm7LRqsgno9+8X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab3EXURm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipcmsg-make-msgctl_nolock-lockless.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:41 -0700


The patch titled
     Subject: ipc,msg: make msgctl_nolock lockless
has been added to the -mm tree.  Its filename is
     ipcmsg-make-msgctl_nolock-lockless.patch

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
@@ -547,17 +547,25 @@ static int msgctl_nolock(struct ipc_name
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
@@ -566,8 +574,6 @@ static int msgctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		memset(&tbuf, 0, sizeof(tbuf));
-
 		kernel_to_ipc64_perm(&msq->q_perm, &tbuf.msg_perm);
 		tbuf.msg_stime  = msq->q_stime;
 		tbuf.msg_rtime  = msq->q_rtime;
@@ -577,7 +583,8 @@ static int msgctl_nolock(struct ipc_name
 		tbuf.msg_qbytes = msq->q_qbytes;
 		tbuf.msg_lspid  = msq->q_lspid;
 		tbuf.msg_lrpid  = msq->q_lrpid;
-		msg_unlock(msq);
+		rcu_read_unlock();
+
 		if (copy_msqid_to_user(buf, &tbuf, version))
 			return -EFAULT;
 		return success_return;
@@ -589,7 +596,7 @@ static int msgctl_nolock(struct ipc_name
 
 	return err;
 out_unlock:
-	msg_unlock(msq);
+	rcu_read_unlock();
 	return err;
 }
 
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

