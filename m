From: akpm@linux-foundation.org
Subject: + ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch added to -mm tree
Date: Mon, 29 Oct 2012 14:46:35 -0700
Message-ID: <20121029214636.B222220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:57183 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab2J2Vqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 17:46:40 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so347973lah.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 14:46:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: ipc: remove redundant MSG_COPY check
has been added to the -mm tree.  Its filename is
     ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch

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
Subject: ipc: remove redundant MSG_COPY check

Small cleanup patch.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN ipc/msg.c~ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check ipc/msg.c
--- a/ipc/msg.c~ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check
+++ a/ipc/msg.c
@@ -786,11 +786,8 @@ long do_msgrcv(int msqid, void __user *b
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
 #ifdef CONFIG_CHECKPOINT_RESTORE
-
-		if (msgflg & MSG_COPY) {
-			copy_number = msgtyp;
-			msgtyp = 0;
-		}
+		copy_number = msgtyp;
+		msgtyp = 0;
 
 		/*
 		 * Create dummy message to copy real message to.
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

