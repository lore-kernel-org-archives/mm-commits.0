From: akpm@osdl.org
Subject: - fix-the-size-limit-of-compat-space-msgsize.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:06 -0800
Message-ID: <200612072305.kB7N5647030119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1164175AbWLHAJT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 19:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suzuki@linux.vnet.ibm.com, arnd@arndb.de, davem@davemloft.net, suzuki@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix the size limit of compat space msgsize
has been removed from the -mm tree.  Its filename was
     fix-the-size-limit-of-compat-space-msgsize.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix the size limit of compat space msgsize
From: suzuki <suzuki@linux.vnet.ibm.com>

Currently we allocate 64k space on the user stack and use it the msgbuf for
sys_{msgrcv,msgsnd} for compat and the results are later copied in user [
by copy_in_user].  This patch introduces helper routines for
sys_{msgrcv,msgsnd} as below:

do_msgsnd() : Accepts the mtype and user space ptr to the buffer along with
the msqid and msgflg.

do_msgrcv() : Accepts a kernel space ptr to mtype and a userspace ptr to
the buffer.  The mtype has to be copied back the user space msgbuf by the
caller.

These changes avoid the need to allocate the msgsize on the userspace (
thus removing the size limt ) and the overhead of an extra copy_in_user().

Signed-off-by: Suzuki K P <suzuki@in.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/msg.h |    6 +++++
 ipc/compat.c        |   23 ++++++---------------
 ipc/msg.c           |   44 +++++++++++++++++++++++++++++++-----------
 3 files changed, 46 insertions(+), 27 deletions(-)

diff -puN include/linux/msg.h~fix-the-size-limit-of-compat-space-msgsize include/linux/msg.h
--- a/include/linux/msg.h~fix-the-size-limit-of-compat-space-msgsize
+++ a/include/linux/msg.h
@@ -92,6 +92,12 @@ struct msg_queue {
 	struct list_head q_senders;
 };
 
+/* Helper routines for sys_msgsnd and sys_msgrcv */
+extern long do_msgsnd(int msqid, long mtype, void __user *mtext,
+			size_t msgsz, int msgflg);
+extern long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
+			size_t msgsz, long msgtyp, int msgflg);
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_MSG_H */
diff -puN ipc/compat.c~fix-the-size-limit-of-compat-space-msgsize ipc/compat.c
--- a/ipc/compat.c~fix-the-size-limit-of-compat-space-msgsize
+++ a/ipc/compat.c
@@ -115,7 +115,6 @@ struct compat_shm_info {
 
 extern int sem_ctls[];
 #define sc_semopm	(sem_ctls[2])
-#define MAXBUF (64*1024)
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
@@ -307,35 +306,30 @@ long compat_sys_semctl(int first, int se
 
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr)
 {
-	struct msgbuf __user *p;
 	struct compat_msgbuf __user *up = uptr;
 	long type;
 
 	if (first < 0)
 		return -EINVAL;
-	if (second < 0 || (second >= MAXBUF - sizeof(struct msgbuf)))
+	if (second < 0)
 		return -EINVAL;
 
-	p = compat_alloc_user_space(second + sizeof(struct msgbuf));
-	if (get_user(type, &up->mtype) ||
-	    put_user(type, &p->mtype) ||
-	    copy_in_user(p->mtext, up->mtext, second))
+	if (get_user(type, &up->mtype))
 		return -EFAULT;
 
-	return sys_msgsnd(first, p, second, third);
+	return do_msgsnd(first, type, up->mtext, second, third);
 }
 
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 			   int version, void __user *uptr)
 {
-	struct msgbuf __user *p;
 	struct compat_msgbuf __user *up;
 	long type;
 	int err;
 
 	if (first < 0)
 		return -EINVAL;
-	if (second < 0 || (second >= MAXBUF - sizeof(struct msgbuf)))
+	if (second < 0)
 		return -EINVAL;
 
 	if (!version) {
@@ -349,14 +343,11 @@ long compat_sys_msgrcv(int first, int se
 		uptr = compat_ptr(ipck.msgp);
 		msgtyp = ipck.msgtyp;
 	}
-	p = compat_alloc_user_space(second + sizeof(struct msgbuf));
-	err = sys_msgrcv(first, p, second, msgtyp, third);
+	up = uptr;
+	err = do_msgrcv(first, &type, up->mtext, second, msgtyp, third);
 	if (err < 0)
 		goto out;
-	up = uptr;
-	if (get_user(type, &p->mtype) ||
-	    put_user(type, &up->mtype) ||
-	    copy_in_user(up->mtext, p->mtext, err))
+	if (put_user(type, &up->mtype))
 		err = -EFAULT;
 out:
 	return err;
diff -puN ipc/msg.c~fix-the-size-limit-of-compat-space-msgsize ipc/msg.c
--- a/ipc/msg.c~fix-the-size-limit-of-compat-space-msgsize
+++ a/ipc/msg.c
@@ -626,12 +626,11 @@ static inline int pipelined_send(struct 
 	return 0;
 }
 
-asmlinkage long
-sys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz, int msgflg)
+long do_msgsnd(int msqid, long mtype, void __user *mtext,
+		size_t msgsz, int msgflg)
 {
 	struct msg_queue *msq;
 	struct msg_msg *msg;
-	long mtype;
 	int err;
 	struct ipc_namespace *ns;
 
@@ -639,12 +638,10 @@ sys_msgsnd(int msqid, struct msgbuf __us
 
 	if (msgsz > ns->msg_ctlmax || (long) msgsz < 0 || msqid < 0)
 		return -EINVAL;
-	if (get_user(mtype, &msgp->mtype))
-		return -EFAULT;
 	if (mtype < 1)
 		return -EINVAL;
 
-	msg = load_msg(msgp->mtext, msgsz);
+	msg = load_msg(mtext, msgsz);
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
@@ -723,6 +720,16 @@ out_free:
 	return err;
 }
 
+asmlinkage long
+sys_msgsnd(int msqid, struct msgbuf __user *msgp, size_t msgsz, int msgflg)
+{
+	long mtype;
+
+	if (get_user(mtype, &msgp->mtype))
+		return -EFAULT;
+	return do_msgsnd(msqid, mtype, msgp->mtext, msgsz, msgflg);
+}
+
 static inline int convert_mode(long *msgtyp, int msgflg)
 {
 	/*
@@ -742,8 +749,8 @@ static inline int convert_mode(long *msg
 	return SEARCH_EQUAL;
 }
 
-asmlinkage long sys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
-			   long msgtyp, int msgflg)
+long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
+		size_t msgsz, long msgtyp, int msgflg)
 {
 	struct msg_queue *msq;
 	struct msg_msg *msg;
@@ -889,15 +896,30 @@ out_unlock:
 		return PTR_ERR(msg);
 
 	msgsz = (msgsz > msg->m_ts) ? msg->m_ts : msgsz;
-	if (put_user (msg->m_type, &msgp->mtype) ||
-	    store_msg(msgp->mtext, msg, msgsz)) {
+	*pmtype = msg->m_type;
+	if (store_msg(mtext, msg, msgsz))
 		msgsz = -EFAULT;
-	}
+
 	free_msg(msg);
 
 	return msgsz;
 }
 
+asmlinkage long sys_msgrcv(int msqid, struct msgbuf __user *msgp, size_t msgsz,
+			   long msgtyp, int msgflg)
+{
+	long err, mtype;
+
+	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
+	if (err < 0)
+		goto out;
+
+	if (put_user(mtype, &msgp->mtype))
+		err = -EFAULT;
+out:
+	return err;
+}
+
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 {
_

Patches currently in -mm which might be from suzuki@linux.vnet.ibm.com are

origin.patch

