From: akpm@linux-foundation.org
Subject: [folded-merged] ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:49:43 -0800
Message-ID: <20121218224943.9B641100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:40981 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRWtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:49:45 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so149271vba.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:49:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: remove redundant MSG_COPY check
has been removed from the -mm tree.  Its filename was
     ipc-message-queue-copy-feature-introduced-remove-redundant-msg_copy-check.patch

This patch was dropped because it was folded into ipc-message-queue-copy-feature-introduced.patch

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

origin.patch
linux-next.patch
ipc-remove-forced-assignment-of-selected-message.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-message-queue-copy-feature-introduced.patch
ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch
selftests-ipc-message-queue-copy-feature-test.patch
selftests-ipc-message-queue-copy-feature-test-update.patch
ipc-simplify-free_copy-call.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
ipc-simplify-message-copying.patch
ipc-add-more-comments-to-message-copying-related-code.patch

