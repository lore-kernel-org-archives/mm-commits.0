From: akpm@linux-foundation.org
Subject: + c-r-ipc-message-queue-stealing-feature-introduced.patch added to -mm tree
Date: Wed, 04 Apr 2012 16:12:42 -0700
Message-ID: <20120404231242.2CEC4A04F2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:52194 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab2DDXMn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 19:12:43 -0400
Received: by ghbz15 with SMTP id z15so106850ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 16:12:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, arnd@arndb.de, cmetcalf@tilera.com, gorcunov@openvz.org, lucas.de.marchi@gmail.com, mtk.manpages@gmail.com, xemul@parallels.com


The patch titled
     Subject: c/r: ipc: message queue stealing feature introduced
has been added to the -mm tree.  Its filename is
     c-r-ipc-message-queue-stealing-feature-introduced.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: c/r: ipc: message queue stealing feature introduced

This patch is required for checkpoint/restore in userspace.

IOW, c/r requires some way to get all pending IPC messages without
deleting them for the queue (checkpoint can fail and in this case tasks
will be resumed, so queue have to be valid).

To achieve this, the new operation flag MSG_STEAL for sys_msgrcv() system
call introduced.  If this flag is set, then passed struct msgbuf pointer
will be used for storing array of structures:

struct msgbuf_a {
	long mtype;         /* type of message */
	int msize;          /* size of message */
	char mtext[0];      /* message text */
};

each of which will be followed by corresponding message data.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h |    8 +++++++
 ipc/compat.c        |   31 +++++++++++++++++++++++++++-
 ipc/msg.c           |   46 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 83 insertions(+), 2 deletions(-)

diff -puN include/linux/msg.h~c-r-ipc-message-queue-stealing-feature-introduced include/linux/msg.h
--- a/include/linux/msg.h~c-r-ipc-message-queue-stealing-feature-introduced
+++ a/include/linux/msg.h
@@ -10,6 +10,7 @@
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
 #define MSG_EXCEPT      020000  /* recv any msg except of specified type.*/
+#define MSG_STEAL       040000  /* copy (not remove) all queue messages */
 
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
@@ -334,6 +340,27 @@ long compat_sys_msgsnd(int first, int se
 	return do_msgsnd(first, type, up->mtext, second, third);
 }
 
+
+static long compat_do_msg_steal(void __user *dest, struct msg_msg *msg, size_t bufsz)
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
+
 long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct compat_msgbuf __user *msgp;
@@ -365,7 +392,9 @@ long compat_sys_msgrcv(int first, int se
 		uptr = compat_ptr(ipck.msgp);
 		msgtyp = ipck.msgtyp;
 	}
-	return do_msgrcv(first, uptr, second, msgtyp, third, compat_do_msg_fill);
+	return do_msgrcv(first, uptr, second, msgtyp, third,
+			 (third & MSG_STEAL) ? compat_do_msg_steal
+					      : compat_do_msg_fill);
 }
 #else
 long compat_sys_semctl(int semid, int semnum, int cmd, int arg)
diff -puN ipc/msg.c~c-r-ipc-message-queue-stealing-feature-introduced ipc/msg.c
--- a/ipc/msg.c~c-r-ipc-message-queue-stealing-feature-introduced
+++ a/ipc/msg.c
@@ -752,6 +752,33 @@ static inline int convert_mode(long *msg
 	return SEARCH_EQUAL;
 }
 
+static long do_msg_steal(void __user *dest, struct msg_msg *msg, size_t bufsz)
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
+
 static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct msgbuf __user *msgp = dest;
@@ -774,6 +801,7 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+	size_t arrsz = bufsz;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
@@ -807,6 +835,16 @@ long do_msgrcv(int msqid, void __user *b
 						walk_msg->m_type != 1) {
 					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
+				} else if (msgflg & MSG_STEAL) {
+					long ret;
+
+					ret = msg_fill(buf, msg, arrsz);
+					if (ret < 0) {
+						msg = ERR_PTR(ret);
+						goto out_unlock;
+					}
+					buf += ret;
+					arrsz -= ret;
 				} else {
 					msg = walk_msg;
 					break;
@@ -815,6 +853,8 @@ long do_msgrcv(int msqid, void __user *b
 			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
+			if (msgflg & MSG_STEAL)
+				goto out_unlock;
 			/*
 			 * Found a suitable message.
 			 * Unlink it from the queue.
@@ -909,6 +949,9 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
+	if (msgflg & MSG_STEAL)
+		return bufsz - arrsz;
+
 	bufsz = msg_fill(buf, msg, bufsz);
 	free_msg(msg);
 
@@ -918,7 +961,8 @@ out_unlock:
 SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 		long, msgtyp, int, msgflg)
 {
-	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg, do_msg_fill);
+	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg,
+			 (msgflg & MSG_STEAL) ? do_msg_steal : do_msg_fill);
 }
 
 #ifdef CONFIG_PROC_FS
_
Subject: Subject: c/r: ipc: message queue stealing feature introduced

Patches currently in -mm which might be from skinsbursky@parallels.com are

c-r-ipc-message-queue-receive-cleanup.patch
c-r-ipc-message-queue-stealing-feature-introduced.patch

