From: akpm@linux-foundation.org
Subject: + ipcmsg-introduce-msgctl_nolock.patch added to -mm tree
Date: Fri, 24 May 2013 13:17:39 -0700
Message-ID: <519fcae3.M4WneKdjyx3It5/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3EXURk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipcmsg-introduce-msgctl_nolock.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:39 -0700


The patch titled
     Subject: ipc,msg: introduce msgctl_nolock
has been added to the -mm tree.  Its filename is
     ipcmsg-introduce-msgctl_nolock.patch

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
Subject: ipc,msg: introduce msgctl_nolock

Similar to semctl, when calling msgctl, the *_INFO and *_STAT commands can
be performed without acquiring the ipc object.

Add a msgctl_nolock() function and move the logic of *_INFO and *_STAT out
of msgctl().  This change still takes the lock and it will be properly
lockless in the next patch

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   49 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff -puN ipc/msg.c~ipcmsg-introduce-msgctl_nolock ipc/msg.c
--- a/ipc/msg.c~ipcmsg-introduce-msgctl_nolock
+++ a/ipc/msg.c
@@ -469,17 +469,11 @@ out_up:
 	return err;
 }
 
-SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
+static int msgctl_nolock(struct ipc_namespace *ns, int msqid,
+			 int cmd, int version, void __user *buf)
 {
+	int err;
 	struct msg_queue *msq;
-	int err, version;
-	struct ipc_namespace *ns;
-
-	if (msqid < 0 || cmd < 0)
-		return -EINVAL;
-
-	version = ipc_parse_version(&cmd);
-	ns = current->nsproxy->ipc_ns;
 
 	switch (cmd) {
 	case IPC_INFO:
@@ -490,6 +484,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 
 		if (!buf)
 			return -EFAULT;
+
 		/*
 		 * We must not return kernel stack data.
 		 * due to padding, it's not enough
@@ -521,7 +516,8 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
-	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+
+	case MSG_STAT:
 	case IPC_STAT:
 	{
 		struct msqid64_ds tbuf;
@@ -565,19 +561,42 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 			return -EFAULT;
 		return success_return;
 	}
-	case IPC_SET:
-	case IPC_RMID:
-		err = msgctl_down(ns, msqid, cmd, buf, version);
-		return err;
+
 	default:
-		return  -EINVAL;
+		return -EINVAL;
 	}
 
+	return err;
 out_unlock:
 	msg_unlock(msq);
 	return err;
 }
 
+SYSCALL_DEFINE3(msgctl, int, msqid, int, cmd, struct msqid_ds __user *, buf)
+{
+	int version;
+	struct ipc_namespace *ns;
+
+	if (msqid < 0 || cmd < 0)
+		return -EINVAL;
+
+	version = ipc_parse_version(&cmd);
+	ns = current->nsproxy->ipc_ns;
+
+	switch (cmd) {
+	case IPC_INFO:
+	case MSG_INFO:
+	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+	case IPC_STAT:
+		return msgctl_nolock(ns, msqid, cmd, version, buf);
+	case IPC_SET:
+	case IPC_RMID:
+		return msgctl_down(ns, msqid, cmd, buf, version);
+	default:
+		return  -EINVAL;
+	}
+}
+
 static int testmsg(struct msg_msg *msg, long type, int mode)
 {
 	switch(mode)
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

