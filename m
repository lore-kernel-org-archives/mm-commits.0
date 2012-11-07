From: akpm@linux-foundation.org
Subject: + ipc-add-more-comments-to-message-copying-related-code.patch added to -mm tree
Date: Wed, 07 Nov 2012 11:21:59 -0800
Message-ID: <20121107192200.7808A5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:34381 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2KGTWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2012 14:22:03 -0500
Received: by mail-la0-f74.google.com with SMTP id j13so131871lah.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Nov 2012 11:22:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org


The patch titled
     Subject: ipc: add more comments to message copying related code
has been added to the -mm tree.  Its filename is
     ipc-add-more-comments-to-message-copying-related-code.patch

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
Subject: ipc: add more comments to message copying related code

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN ipc/msg.c~ipc-add-more-comments-to-message-copying-related-code ipc/msg.c
--- a/ipc/msg.c~ipc-add-more-comments-to-message-copying-related-code
+++ a/ipc/msg.c
@@ -770,6 +770,10 @@ static long do_msg_fill(void __user *des
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
+/*
+ * This function creates new kernel message structure, large enough to store
+ * bufsz message bytes.
+ */
 static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 					   int msgflg, long *msgtyp,
 					   unsigned long *copy_number)
@@ -881,6 +885,10 @@ long do_msgrcv(int msqid, void __user *b
 				msg = ERR_PTR(-E2BIG);
 				goto out_unlock;
 			}
+			/*
+			 * If we are copying, then do not unlink message and do
+			 * not update queue parameters.
+			 */
 			if (msgflg & MSG_COPY)
 				goto out_unlock;
 			list_del(&msg->m_list);
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

