From: akpm@linux-foundation.org
Subject: [merged] ipc-implement-msg_copy-as-a-new-receive-mode.patch removed from -mm tree
Date: Tue, 07 May 2013 10:51:58 -0700
Message-ID: <20130507175158.78D0331C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:55378 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab3EGRv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:51:59 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so86649qcz.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:51:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@hurleysoftware.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: implement MSG_COPY as a new receive mode
has been removed from the -mm tree.  Its filename was
     ipc-implement-msg_copy-as-a-new-receive-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Hurley <peter@hurleysoftware.com>
Subject: ipc: implement MSG_COPY as a new receive mode

Teach the helper routines about MSG_COPY so that msgtyp is preserved as
the message number to copy.

The security functions affected by this change were audited and no
additional changes are necessary.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff -puN ipc/msg.c~ipc-implement-msg_copy-as-a-new-receive-mode ipc/msg.c
--- a/ipc/msg.c~ipc-implement-msg_copy-as-a-new-receive-mode
+++ a/ipc/msg.c
@@ -66,6 +66,7 @@ struct msg_sender {
 #define SEARCH_EQUAL		2
 #define SEARCH_NOTEQUAL		3
 #define SEARCH_LESSEQUAL	4
+#define SEARCH_NUMBER		5
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
@@ -583,6 +584,7 @@ static int testmsg(struct msg_msg *msg, 
 	switch(mode)
 	{
 		case SEARCH_ANY:
+		case SEARCH_NUMBER:
 			return 1;
 		case SEARCH_LESSEQUAL:
 			if (msg->m_type <=type)
@@ -738,6 +740,8 @@ SYSCALL_DEFINE4(msgsnd, int, msqid, stru
 
 static inline int convert_mode(long *msgtyp, int msgflg)
 {
+	if (msgflg & MSG_COPY)
+		return SEARCH_NUMBER;
 	/*
 	 *  find message of correct type.
 	 *  msgtyp = 0 => get first.
@@ -774,14 +778,10 @@ static long do_msg_fill(void __user *des
  * This function creates new kernel message structure, large enough to store
  * bufsz message bytes.
  */
-static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
-					   int msgflg, long *msgtyp,
-					   unsigned long *copy_number)
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz)
 {
 	struct msg_msg *copy;
 
-	*copy_number = *msgtyp;
-	*msgtyp = 0;
 	/*
 	 * Create dummy message to copy real message to.
 	 */
@@ -797,9 +797,7 @@ static inline void free_copy(struct msg_
 		free_msg(copy);
 }
 #else
-static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
-					   int msgflg, long *msgtyp,
-					   unsigned long *copy_number)
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz)
 {
 	return ERR_PTR(-ENOSYS);
 }
@@ -818,12 +816,11 @@ long do_msgrcv(int msqid, void __user *b
 	int mode;
 	struct ipc_namespace *ns;
 	struct msg_msg *copy = NULL;
-	unsigned long copy_number = 0;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
-		copy = prepare_copy(buf, bufsz, msgflg, &msgtyp, &copy_number);
+		copy = prepare_copy(buf, bufsz);
 		if (IS_ERR(copy))
 			return PTR_ERR(copy);
 	}
@@ -859,8 +856,8 @@ long do_msgrcv(int msqid, void __user *b
 				if (mode == SEARCH_LESSEQUAL &&
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
-				} else if (msgflg & MSG_COPY) {
-					if (copy_number == msg_counter)
+				} else if (mode == SEARCH_NUMBER) {
+					if (msgtyp == msg_counter)
 						break;
 					msg = ERR_PTR(-EAGAIN);
 				} else
_

Patches currently in -mm which might be from peter@hurleysoftware.com are

origin.patch
linux-next.patch

