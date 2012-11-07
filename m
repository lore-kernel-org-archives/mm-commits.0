From: akpm@linux-foundation.org
Subject: + ipc-simplify-free_copy-call.patch added to -mm tree
Date: Wed, 07 Nov 2012 11:21:43 -0800
Message-ID: <20121107192145.D70E25C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55750 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2KGTVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 14:21:48 -0500
Received: by mail-ee0-f74.google.com with SMTP id b57so133136eek.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 11:21:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org


The patch titled
     Subject: ipc: simplify free_copy() call
has been added to the -mm tree.  Its filename is
     ipc-simplify-free_copy-call.patch

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

linux-next.patch
proc-check-vma-vm_file-before-dereferencing.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore.patch
ipc-add-sysctl-to-specify-desired-next-object-id-documentation-update-sysctl-kerneltxt.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-message-queue-copy-feature-introduced.patch
ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch
ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch
selftests-ipc-message-queue-copy-feature-test.patch
selftests-ipc-message-queue-copy-feature-test-update.patch
ipc-simplify-free_copy-call.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
ipc-simplify-message-copying.patch
ipc-add-more-comments-to-message-copying-related-code.patch

