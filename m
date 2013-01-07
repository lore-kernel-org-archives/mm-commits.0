From: akpm@linux-foundation.org
Subject: [merged] ipc-simplify-message-copying.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:29 -0800
Message-ID: <20130107192530.32362200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:62581 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:32 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so1261208fav.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: simplify message copying
has been removed from the -mm tree.  Its filename was
     ipc-simplify-message-copying.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: ipc: simplify message copying

Remvoe the redundant and confusing fill_copy().  Also add copy_msg() check
for error.  In this case exit from the function have to be done instead of
break, because further code interprets any error as EAGAIN.

Also define copy_msg() for the case when CONFIG_CHECKPOINT_RESTORE is
disabled.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c     |   25 +++++++++----------------
 ipc/msgutil.c |    5 +++++
 2 files changed, 14 insertions(+), 16 deletions(-)

diff -puN ipc/msg.c~ipc-simplify-message-copying ipc/msg.c
--- a/ipc/msg.c~ipc-simplify-message-copying
+++ a/ipc/msg.c
@@ -770,16 +770,6 @@ static long do_msg_fill(void __user *des
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-static inline struct msg_msg *fill_copy(unsigned long copy_nr,
-					unsigned long msg_nr,
-					struct msg_msg *msg,
-					struct msg_msg *copy)
-{
-	if (copy_nr == msg_nr)
-		return copy_msg(msg, copy);
-	return NULL;
-}
-
 static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 					   int msgflg, long *msgtyp,
 					   unsigned long *copy_number)
@@ -803,8 +793,6 @@ static inline void free_copy(struct msg_
 		free_msg(copy);
 }
 #else
-#define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
-
 static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 					   int msgflg, long *msgtyp,
 					   unsigned long *copy_number)
@@ -868,11 +856,16 @@ long do_msgrcv(int msqid, void __user *b
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
 				} else if (msgflg & MSG_COPY) {
-					msg = fill_copy(copy_number,
-							msg_counter,
-							walk_msg, copy);
-					if (msg)
+					if (copy_number == msg_counter) {
+						/*
+						 * Found requested message.
+						 * Copy it.
+						 */
+						msg = copy_msg(msg, copy);
+						if (IS_ERR(msg))
+							goto out_unlock;
 						break;
+					}
 				} else
 					break;
 				msg_counter++;
diff -puN ipc/msgutil.c~ipc-simplify-message-copying ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-simplify-message-copying
+++ a/ipc/msgutil.c
@@ -140,6 +140,11 @@ struct msg_msg *copy_msg(struct msg_msg 
 
 	return dst;
 }
+#else
+struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
+{
+	return ERR_PTR(-ENOSYS);
+}
 #endif
 int store_msg(void __user *dest, struct msg_msg *msg, int len)
 {
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch

