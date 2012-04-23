From: akpm@linux-foundation.org
Subject: [to-be-updated] c-r-ipc-message-queue-stealing-feature-introduced.patch removed from -mm tree
Date: Mon, 23 Apr 2012 13:56:13 -0700
Message-ID: <20120423205613.7DAE9A0423@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:54704 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab2DWU4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 16:56:15 -0400
Received: by faaa19 with SMTP id a19so162911faa.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Apr 2012 13:56:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, arnd@arndb.de, cmetcalf@tilera.com, gorcunov@openvz.org, lucas.de.marchi@gmail.com, mtk.manpages@gmail.com, serue@us.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: c/r: ipc: message queue stealing feature introduced
has been removed from the -mm tree.  Its filename was
     c-r-ipc-message-queue-stealing-feature-introduced.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: c/r: ipc: message queue stealing feature introduced

This patch is required for checkpoint/restore in userspace.

c/r requires some way to get all pending IPC messages without deleting
them for the queue (checkpoint can fail and in this case tasks will be
resumed, so queue have to be valid).  To achive this, new operation flag
MSG_STEAL for sys_msgrcv() system call introduced.  If this flag is set,
then passed struct msgbuf pointer will be used for storing array of
structures:

struct msgbuf_a {
	long mtype;         /* type of message */
	int msize;          /* size of message */
	char mtext[0];      /* message text */
};

each of which will be followed by corresponding message data.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h |    8 +++++
 ipc/compat.c        |   42 +++++++++++++++++++++++++--
 ipc/msg.c           |   65 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 112 insertions(+), 3 deletions(-)

diff -puN include/linux/msg.h~c-r-ipc-message-queue-stealing-feature-introduced include/linux/msg.h
--- a/include/linux/msg.h~c-r-ipc-message-queue-stealing-feature-introduced
+++ a/include/linux/msg.h
@@ -10,6 +10,7 @@
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
 #define MSG_EXCEPT      020000  /* recv any msg except of specified type.*/
+#define MSG_PEEK_ALL    040000  /* copy (not remove) all queue messages */
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct msqid_ds {
@@ -37,6 +38,13 @@ struct msgbuf {
 	char mtext[1];      /* message text */
 };
 
+/* message buffer for msgrcv in case of array calls */
+struct msgbuf_a {
+	long mtype;         /* type of message */
+	int msize;          /* size of message */
+	char mtext[0];      /* message text */
+};
+
 /* buffer for msgctl calls IPC_INFO, MSG_INFO */
 struct msginfo {
 	int msgpool;
diff -puN ipc/compat.c~c-r-ipc-message-queue-stealing-feature-introduced ipc/compat.c
--- a/ipc/compat.c~c-r-ipc-message-queue-stealing-feature-introduced
+++ a/ipc/compat.c
@@ -39,6 +39,12 @@ struct compat_msgbuf {
 	char mtext[1];
 };
 
+struct compat_msgbuf_a {
+	compat_long_t mtype;
+	int msize;
+	char mtext[0];
+};
+
 struct compat_ipc_perm {
 	key_t key;
 	__compat_uid_t uid;
@@ -334,6 +340,33 @@ long compat_sys_msgsnd(int first, int se
 	return do_msgsnd(first, type, up->mtext, second, third);
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	struct compat_msgbuf_a __user *msgp = dest;
+	size_t msgsz;
+
+	msgsz = roundup(sizeof(struct msgbuf_a) + msg->m_ts,
+			__alignof__(struct msgbuf_a));
+
+	if (bufsz < msgsz)
+		return -E2BIG;
+
+	if (put_user(msg->m_type, &msgp->mtype))
+		return -EFAULT;
+	if (put_user(msg->m_ts, &msgp->msize))
+		return -EFAULT;
+	if (store_msg(msgp->mtext, msg, msg->m_ts))
+		return -EFAULT;
+	return msgsz;
+}
+#else
+static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	return -EINVAL;
+}
+#endif
+
 long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct compat_msgbuf __user *msgp = dest;
@@ -355,7 +388,10 @@ long compat_sys_msgrcv(int first, int se
 		return -EINVAL;
 	if (second < 0)
 		return -EINVAL;
-
+#ifndef CONFIG_CHECKPOINT_RESTORE
+	if (third & MSG_PEEK_ALL)
+		return -ENOSYS;
+#endif
 	if (!version) {
 		struct compat_ipc_kludge ipck;
 		if (!uptr)
@@ -365,7 +401,9 @@ long compat_sys_msgrcv(int first, int se
 		uptr = compat_ptr(ipck.msgp);
 		msgtyp = ipck.msgtyp;
 	}
-	return do_msgrcv(first, uptr, second, msgtyp, third, compat_do_msg_fill);
+	return do_msgrcv(first, uptr, second, msgtyp, third,
+			 (third & MSG_PEEK_ALL) ? compat_do_msg_peek_all
+						: compat_do_msg_fill);
 }
 #else
 long compat_sys_semctl(int semid, int semnum, int cmd, int arg)
diff -puN ipc/msg.c~c-r-ipc-message-queue-stealing-feature-introduced ipc/msg.c
--- a/ipc/msg.c~c-r-ipc-message-queue-stealing-feature-introduced
+++ a/ipc/msg.c
@@ -752,6 +752,40 @@ static inline int convert_mode(long *msg
 	return SEARCH_EQUAL;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	struct msgbuf_a __user *msgp = dest;
+	size_t msgsz;
+
+	/*
+	 * Message size have to be aligned.
+	 */
+	msgsz = roundup(sizeof(struct msgbuf_a) + msg->m_ts,
+			__alignof__(struct msgbuf_a));
+
+	/*
+	 * No need to support MSG_NOERROR flag because truncated message array
+	 * is useless.
+	 */
+	if (bufsz < msgsz)
+		return -E2BIG;
+
+	if (put_user(msg->m_type, &msgp->mtype))
+		return -EFAULT;
+	if (put_user(msg->m_ts, &msgp->msize))
+		return -EFAULT;
+	if (store_msg(msgp->mtext, msg, msg->m_ts))
+		return -EFAULT;
+	return msgsz;
+}
+#else
+static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	return -EINVAL;
+}
+#endif
+
 static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct msgbuf __user *msgp = dest;
@@ -774,9 +808,16 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	size_t arrsz = bufsz;
+#endif
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
+#ifndef CONFIG_CHECKPOINT_RESTORE
+	if (msgflg & MSG_PEEK_ALL)
+		return -ENOSYS;
+#endif
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
 
@@ -807,6 +848,18 @@ long do_msgrcv(int msqid, void __user *b
 						walk_msg->m_type != 1) {
 					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+				} else if (msgflg & MSG_PEEK_ALL) {
+					long ret;
+
+					ret = msg_fill(buf, msg, arrsz);
+					if (ret < 0) {
+						msg = ERR_PTR(ret);
+						goto out_unlock;
+					}
+					buf += ret;
+					arrsz -= ret;
+#endif
 				} else {
 					msg = walk_msg;
 					break;
@@ -815,6 +868,10 @@ long do_msgrcv(int msqid, void __user *b
 			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
+#ifdef CONFIG_CHECKPOINT_RESTORE
+			if (msgflg & MSG_PEEK_ALL)
+				goto out_unlock;
+#endif
 			/*
 			 * Found a suitable message.
 			 * Unlink it from the queue.
@@ -909,6 +966,11 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	if (msgflg & MSG_PEEK_ALL)
+		return bufsz - arrsz;
+#endif
+
 	bufsz = msg_fill(buf, msg, bufsz);
 	free_msg(msg);
 
@@ -918,7 +980,8 @@ out_unlock:
 SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 		long, msgtyp, int, msgflg)
 {
-	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg, do_msg_fill);
+	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg,
+			 (msgflg & MSG_PEEK_ALL) ? do_msg_peek_all : do_msg_fill);
 }
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

linux-next.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch

