From: akpm@linux-foundation.org
Subject: + ipc-simplify-message-copying.patch added to -mm tree
Date: Wed, 07 Nov 2012 11:21:56 -0800
Message-ID: <20121107192157.0F514100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:62158 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2KGTV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 14:21:58 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so224812vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 11:21:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org


The patch titled
     Subject: ipc: simplify message copying
has been added to the -mm tree.  Its filename is
     ipc-simplify-message-copying.patch

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
@@ -138,6 +138,11 @@ struct msg_msg *copy_msg(struct msg_msg 
 
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

