From: akpm@linux-foundation.org
Subject: [merged] ipc-convert-prepare_copy-from-macro-to-function.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:26 -0800
Message-ID: <20130107192526.B2EDD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:50987 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:27 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so2115815qch.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: convert prepare_copy() from macro to function
has been removed from the -mm tree.  Its filename was
     ipc-convert-prepare_copy-from-macro-to-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: ipc: convert prepare_copy() from macro to function

This code works if CONFIG_CHECKPOINT_RESTORE is disabled.

[akpm@linux-foundation.org: remove __maybe_unused]
Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN ipc/msg.c~ipc-convert-prepare_copy-from-macro-to-function ipc/msg.c
--- a/ipc/msg.c~ipc-convert-prepare_copy-from-macro-to-function
+++ a/ipc/msg.c
@@ -803,8 +803,15 @@ static inline void free_copy(struct msg_
 		free_msg(copy);
 }
 #else
-#define prepare_copy(buf, sz, msgflg, msgtyp, copy_nr)	ERR_PTR(-ENOSYS)
 #define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
+
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
+					   int msgflg, long *msgtyp,
+					   unsigned long *copy_number)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void free_copy(struct msg_msg *copy)
 {
 }
@@ -819,7 +826,7 @@ long do_msgrcv(int msqid, void __user *b
 	int mode;
 	struct ipc_namespace *ns;
 	struct msg_msg *copy = NULL;
-	unsigned long __maybe_unused copy_number;
+	unsigned long copy_number = 0;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
_

Patches currently in -mm which might be from skinsbursky@parallels.com are

origin.patch

