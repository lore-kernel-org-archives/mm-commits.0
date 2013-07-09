From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-introduce-msgctl_nolock.patch removed from -mm
 tree
Date: Tue, 09 Jul 2013 16:21:39 -0700
Message-ID: <51dc9b03.AM0RGHEN/t7FkipM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3GIXVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipcmsg-introduce-msgctl_nolock.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:39 -0700


The patch titled
     Subject: ipc,msg: introduce msgctl_nolock
has been removed from the -mm tree.  Its filename was
     ipcmsg-introduce-msgctl_nolock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -467,17 +467,11 @@ out_up:
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
@@ -488,6 +482,7 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 
 		if (!buf)
 			return -EFAULT;
+
 		/*
 		 * We must not return kernel stack data.
 		 * due to padding, it's not enough
@@ -519,7 +514,8 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
 			return -EFAULT;
 		return (max_id < 0) ? 0 : max_id;
 	}
-	case MSG_STAT:	/* msqid is an index rather than a msg queue id */
+
+	case MSG_STAT:
 	case IPC_STAT:
 	{
 		struct msqid64_ds tbuf;
@@ -563,19 +559,42 @@ SYSCALL_DEFINE3(msgctl, int, msqid, int,
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

origin.patch

