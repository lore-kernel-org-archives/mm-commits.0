From: akpm@linux-foundation.org
Subject: [merged] ipc-message-queue-copy-feature-introduced.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:13 -0800
Message-ID: <20130107192513.BA320100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:53651 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3AGTZP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:15 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so2112869yhr.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: introduce message queue copy feature
has been removed from the -mm tree.  Its filename was
     ipc-message-queue-copy-feature-introduced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: ipc: introduce message queue copy feature

This patch is required for checkpoint/restore in userspace.

c/r requires some way to get all pending IPC messages without deleting
them from the queue (checkpoint can fail and in this case tasks will be
resumed, so queue have to be valid).

To achive this, new operation flag MSG_COPY for sys_msgrcv() system call
was introduced.  If this flag was specified, then mtype is interpreted as
number of the message to copy.

If MSG_COPY is set, then kernel will allocate dummy message with passed
size, and then use new copy_msg() helper function to copy desired message
(instead of unlinking it from the queue).

Notes:

1) Return -ENOSYS if MSG_COPY is specified, but
   CONFIG_CHECKPOINT_RESTORE is not set.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/msg.h |    1 
 ipc/msg.c                |   64 +++++++++++++++++++++++++++++++++++--
 ipc/msgutil.c            |   38 +++++++++++++++++++++
 ipc/util.h               |    1 
 4 files changed, 102 insertions(+), 2 deletions(-)

diff -puN include/uapi/linux/msg.h~ipc-message-queue-copy-feature-introduced include/uapi/linux/msg.h
--- a/include/uapi/linux/msg.h~ipc-message-queue-copy-feature-introduced
+++ a/include/uapi/linux/msg.h
@@ -10,6 +10,7 @@
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
 #define MSG_EXCEPT      020000  /* recv any msg except of specified type.*/
+#define MSG_COPY        040000  /* copy (not remove) all queue messages */
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct msqid_ds {
diff -puN ipc/msg.c~ipc-message-queue-copy-feature-introduced ipc/msg.c
--- a/ipc/msg.c~ipc-message-queue-copy-feature-introduced
+++ a/ipc/msg.c
@@ -769,6 +769,45 @@ static long do_msg_fill(void __user *des
 	return msgsz;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static inline struct msg_msg *fill_copy(unsigned long copy_nr,
+					unsigned long msg_nr,
+					struct msg_msg *msg,
+					struct msg_msg *copy)
+{
+	if (copy_nr == msg_nr)
+		return copy_msg(msg, copy);
+	return NULL;
+}
+
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
+					   int msgflg, long *msgtyp,
+					   unsigned long *copy_number)
+{
+	struct msg_msg *copy;
+
+	*copy_number = *msgtyp;
+	*msgtyp = 0;
+	/*
+	 * Create dummy message to copy real message to.
+	 */
+	copy = load_msg(buf, bufsz);
+	if (!IS_ERR(copy))
+		copy->m_ts = bufsz;
+	return copy;
+}
+
+static inline void free_copy(int msgflg, struct msg_msg *copy)
+{
+	if (msgflg & MSG_COPY)
+		free_msg(copy);
+}
+#else
+#define free_copy(msgflg, copy)				do {} while (0)
+#define prepare_copy(buf, sz, msgflg, msgtyp, copy_nr)	ERR_PTR(-ENOSYS)
+#define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
+#endif
+
 long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	       int msgflg,
 	       long (*msg_handler)(void __user *, struct msg_msg *, size_t))
@@ -777,19 +816,29 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+	struct msg_msg *copy;
+	unsigned long __maybe_unused copy_number;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
+	if (msgflg & MSG_COPY) {
+		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
+		if (IS_ERR(copy))
+			return PTR_ERR(copy);
+	}
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
 
 	msq = msg_lock_check(ns, msqid);
-	if (IS_ERR(msq))
+	if (IS_ERR(msq)) {
+		free_copy(msgflg, copy);
 		return PTR_ERR(msq);
+	}
 
 	for (;;) {
 		struct msg_receiver msr_d;
 		struct list_head *tmp;
+		long msg_counter = 0;
 
 		msg = ERR_PTR(-EACCES);
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
@@ -809,8 +858,15 @@ long do_msgrcv(int msqid, void __user *b
 				if (mode == SEARCH_LESSEQUAL &&
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
+				} else if (msgflg & MSG_COPY) {
+					msg = fill_copy(copy_number,
+							msg_counter,
+							walk_msg, copy);
+					if (msg)
+						break;
 				} else
 					break;
+				msg_counter++;
 			}
 			tmp = tmp->next;
 		}
@@ -823,6 +879,8 @@ long do_msgrcv(int msqid, void __user *b
 				msg = ERR_PTR(-E2BIG);
 				goto out_unlock;
 			}
+			if (msgflg & MSG_COPY)
+				goto out_unlock;
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
@@ -906,8 +964,10 @@ out_unlock:
 			break;
 		}
 	}
-	if (IS_ERR(msg))
+	if (IS_ERR(msg)) {
+		free_copy(msgflg, copy);
 		return PTR_ERR(msg);
+	}
 
 	bufsz = msg_handler(buf, msg, bufsz);
 	free_msg(msg);
diff -puN ipc/msgutil.c~ipc-message-queue-copy-feature-introduced ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-message-queue-copy-feature-introduced
+++ a/ipc/msgutil.c
@@ -102,7 +102,45 @@ out_err:
 	free_msg(msg);
 	return ERR_PTR(err);
 }
+#ifdef CONFIG_CHECKPOINT_RESTORE
+struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
+{
+	struct msg_msgseg *dst_pseg, *src_pseg;
+	int len = src->m_ts;
+	int alen;
+
+	BUG_ON(dst == NULL);
+	if (src->m_ts > dst->m_ts)
+		return ERR_PTR(-EINVAL);
+
+	alen = len;
+	if (alen > DATALEN_MSG)
+		alen = DATALEN_MSG;
+
+	dst->next = NULL;
+	dst->security = NULL;
 
+	memcpy(dst + 1, src + 1, alen);
+
+	len -= alen;
+	dst_pseg = dst->next;
+	src_pseg = src->next;
+	while (len > 0) {
+		alen = len;
+		if (alen > DATALEN_SEG)
+			alen = DATALEN_SEG;
+		memcpy(dst_pseg + 1, src_pseg + 1, alen);
+		dst_pseg = dst_pseg->next;
+		len -= alen;
+		src_pseg = src_pseg->next;
+	}
+
+	dst->m_type = src->m_type;
+	dst->m_ts = src->m_ts;
+
+	return dst;
+}
+#endif
 int store_msg(void __user *dest, struct msg_msg *msg, int len)
 {
 	int alen;
diff -puN ipc/util.h~ipc-message-queue-copy-feature-introduced ipc/util.h
--- a/ipc/util.h~ipc-message-queue-copy-feature-introduced
+++ a/ipc/util.h
@@ -140,6 +140,7 @@ int ipc_parse_version (int *cmd);
 
 extern void free_msg(struct msg_msg *msg);
 extern struct msg_msg *load_msg(const void __user *src, int len);
+extern struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst);
 extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
 
 extern void recompute_msgmni(struct ipc_namespace *);
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch

