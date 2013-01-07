From: akpm@linux-foundation.org
Subject: [merged] ipc-simplify-free_copy-call.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:23 -0800
Message-ID: <20130107192523.BA59D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:38198 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:24 -0500
Received: by mail-ye0-f202.google.com with SMTP id r9so1265832yen.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: simplify free_copy() call
has been removed from the -mm tree.  Its filename was
     ipc-simplify-free_copy-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: ipc: simplify free_copy() call

Passing and checking of msgflg to free_copy() is redundant.  This patch
sets copy to NULL on declaration instead and checks for non-NULL in
free_copy().

Note: in case of copy allocation failure, error is returned immediately. 
So no need to check for IS_ERR() in free_copy().

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN ipc/msg.c~ipc-simplify-free_copy-call ipc/msg.c
--- a/ipc/msg.c~ipc-simplify-free_copy-call
+++ a/ipc/msg.c
@@ -797,15 +797,17 @@ static inline struct msg_msg *prepare_co
 	return copy;
 }
 
-static inline void free_copy(int msgflg, struct msg_msg *copy)
+static inline void free_copy(struct msg_msg *copy)
 {
-	if (msgflg & MSG_COPY)
+	if (copy)
 		free_msg(copy);
 }
 #else
-#define free_copy(msgflg, copy)				do {} while (0)
 #define prepare_copy(buf, sz, msgflg, msgtyp, copy_nr)	ERR_PTR(-ENOSYS)
 #define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
+static inline void free_copy(struct msg_msg *copy)
+{
+}
 #endif
 
 long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
@@ -816,7 +818,7 @@ long do_msgrcv(int msqid, void __user *b
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
-	struct msg_msg *copy;
+	struct msg_msg *copy = NULL;
 	unsigned long __maybe_unused copy_number;
 
 	if (msqid < 0 || (long) bufsz < 0)
@@ -831,7 +833,7 @@ long do_msgrcv(int msqid, void __user *b
 
 	msq = msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {
-		free_copy(msgflg, copy);
+		free_copy(copy);
 		return PTR_ERR(msq);
 	}
 
@@ -965,7 +967,7 @@ out_unlock:
 		}
 	}
 	if (IS_ERR(msg)) {
-		free_copy(msgflg, copy);
+		free_copy(copy);
 		return PTR_ERR(msg);
 	}
 
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch

