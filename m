From: akpm@linux-foundation.org
Subject: [to-be-updated] c-r-ipc-message-queue-receive-cleanup.patch removed from -mm tree
Date: Mon, 23 Apr 2012 13:56:08 -0700
Message-ID: <20120423205608.D8527A0423@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:57739 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2DWU4L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 16:56:11 -0400
Received: by wgbdt11 with SMTP id dt11so656231wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 13:56:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, arnd@arndb.de, cmetcalf@tilera.com, gorcunov@openvz.org, lucas.de.marchi@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: ipc: message queue receive cleanup
has been removed from the -mm tree.  Its filename was
     c-r-ipc-message-queue-receive-cleanup.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: c/r: ipc: message queue receive cleanup

Move all message related manipulation into one function msg_fill(). 
Actually, two functions because of the compat one.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compat.h |    2 +
 include/linux/msg.h    |    5 ++--
 ipc/compat.c           |   33 +++++++++++++++--------------
 ipc/msg.c              |   44 ++++++++++++++++++++-------------------
 4 files changed, 45 insertions(+), 39 deletions(-)

diff -puN include/linux/compat.h~c-r-ipc-message-queue-receive-cleanup include/linux/compat.h
--- a/include/linux/compat.h~c-r-ipc-message-queue-receive-cleanup
+++ a/include/linux/compat.h
@@ -245,6 +245,7 @@ struct compat_sysctl_args;
 struct compat_kexec_segment;
 struct compat_mq_attr;
 struct compat_msgbuf;
+struct msg_msg;
 
 extern void compat_exit_robust_list(struct task_struct *curr);
 
@@ -258,6 +259,7 @@ compat_sys_get_robust_list(int pid, comp
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
+long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		int version, void __user *uptr);
 long compat_sys_shmat(int first, int second, compat_uptr_t third, int version,
diff -puN include/linux/msg.h~c-r-ipc-message-queue-receive-cleanup include/linux/msg.h
--- a/include/linux/msg.h~c-r-ipc-message-queue-receive-cleanup
+++ a/include/linux/msg.h
@@ -104,8 +104,9 @@ struct msg_queue {
 /* Helper routines for sys_msgsnd and sys_msgrcv */
 extern long do_msgsnd(int msqid, long mtype, void __user *mtext,
 			size_t msgsz, int msgflg);
-extern long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
-			size_t msgsz, long msgtyp, int msgflg);
+extern long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
+		      int msgflg,
+		      long (*msg_fill)(void __user *, struct msg_msg *, size_t ));
 
 #endif /* __KERNEL__ */
 
diff -puN ipc/compat.c~c-r-ipc-message-queue-receive-cleanup ipc/compat.c
--- a/ipc/compat.c~c-r-ipc-message-queue-receive-cleanup
+++ a/ipc/compat.c
@@ -334,13 +334,23 @@ long compat_sys_msgsnd(int first, int se
 	return do_msgsnd(first, type, up->mtext, second, third);
 }
 
+long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	struct compat_msgbuf __user *msgp;
+	size_t msgsz;
+
+	if (put_user(msg->m_type, &msgp->mtype))
+		return -EFAULT;
+
+	msgsz = (bufsz > msg->m_ts) ? msg->m_ts : bufsz;
+	if (store_msg(msgp->mtext, msg, msgsz))
+		return -EFAULT;
+	return msgsz;
+}
+
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 			   int version, void __user *uptr)
 {
-	struct compat_msgbuf __user *up;
-	long type;
-	int err;
-
 	if (first < 0)
 		return -EINVAL;
 	if (second < 0)
@@ -348,23 +358,14 @@ long compat_sys_msgrcv(int first, int se
 
 	if (!version) {
 		struct compat_ipc_kludge ipck;
-		err = -EINVAL;
 		if (!uptr)
-			goto out;
-		err = -EFAULT;
+			return -EINVAL;
 		if (copy_from_user (&ipck, uptr, sizeof(ipck)))
-			goto out;
+			return -EFAULT;
 		uptr = compat_ptr(ipck.msgp);
 		msgtyp = ipck.msgtyp;
 	}
-	up = uptr;
-	err = do_msgrcv(first, &type, up->mtext, second, msgtyp, third);
-	if (err < 0)
-		goto out;
-	if (put_user(type, &up->mtype))
-		err = -EFAULT;
-out:
-	return err;
+	return do_msgrcv(first, uptr, second, msgtyp, third, compat_do_msg_fill);
 }
 #else
 long compat_sys_semctl(int semid, int semnum, int cmd, int arg)
diff -puN ipc/msg.c~c-r-ipc-message-queue-receive-cleanup ipc/msg.c
--- a/ipc/msg.c~c-r-ipc-message-queue-receive-cleanup
+++ a/ipc/msg.c
@@ -752,15 +752,30 @@ static inline int convert_mode(long *msg
 	return SEARCH_EQUAL;
 }
 
-long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
-		size_t msgsz, long msgtyp, int msgflg)
+static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	struct msgbuf __user *msgp = dest;
+	size_t msgsz;
+
+	if (put_user(msg->m_type, &msgp->mtype))
+		return -EFAULT;
+
+	msgsz = (bufsz > msg->m_ts) ? msg->m_ts : bufsz;
+	if (store_msg(msgp->mtext, msg, msgsz))
+		return -EFAULT;
+	return msgsz;
+}
+
+long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
+	       int msgflg,
+	       long (*msg_fill)(void __user *, struct msg_msg *, size_t ))
 {
 	struct msg_queue *msq;
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
 
-	if (msqid < 0 || (long) msgsz < 0)
+	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
@@ -804,7 +819,7 @@ long do_msgrcv(int msqid, long *pmtype, 
 			 * Found a suitable message.
 			 * Unlink it from the queue.
 			 */
-			if ((msgsz < msg->m_ts) && !(msgflg & MSG_NOERROR)) {
+			if ((bufsz < msg->m_ts) && !(msgflg & MSG_NOERROR)) {
 				msg = ERR_PTR(-E2BIG);
 				goto out_unlock;
 			}
@@ -831,7 +846,7 @@ long do_msgrcv(int msqid, long *pmtype, 
 		if (msgflg & MSG_NOERROR)
 			msr_d.r_maxsize = INT_MAX;
 		else
-			msr_d.r_maxsize = msgsz;
+			msr_d.r_maxsize = bufsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
 		current->state = TASK_INTERRUPTIBLE;
 		msg_unlock(msq);
@@ -894,29 +909,16 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	msgsz = (msgsz > msg->m_ts) ? msg->m_ts : msgsz;
-	*pmtype = msg->m_type;
-	if (store_msg(mtext, msg, msgsz))
-		msgsz = -EFAULT;
-
+	bufsz = msg_fill(buf, msg, bufsz);
 	free_msg(msg);
 
-	return msgsz;
+	return bufsz;
 }
 
 SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 		long, msgtyp, int, msgflg)
 {
-	long err, mtype;
-
-	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
-	if (err < 0)
-		goto out;
