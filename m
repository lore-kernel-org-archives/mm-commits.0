From: akpm@linux-foundation.org
Subject: + ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore.patch added to -mm tree
Date: Mon, 29 Oct 2012 14:46:27 -0700
Message-ID: <20121029214628.A595E5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:58605 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab2J2Vqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 17:46:31 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so346878eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 14:46:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: skinsbursky@parallels.com, ebiederm@xmission.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, serge.hallyn@canonical.com, viro@zeniv.linux.org.uk, xemul@parallels.com


The patch titled
     Subject: ipc: wrap new sysctls for CRIU inside CONFIG_CHECKPOINT_RESTORE
has been added to the -mm tree.  Its filename is
     ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore.patch

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
Subject: ipc: wrap new sysctls for CRIU inside CONFIG_CHECKPOINT_RESTORE

Wrap "msg_next_id", "sem_next_id" and "shm_next_id" inside
CONFIG_CHECKPOINT_RESTORE macro.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN ipc/ipc_sysctl.c~ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~ipc-add-sysctl-to-specify-desired-next-object-id-wrap-new-sysctls-for-criu-inside-config_checkpoint_restore
+++ a/ipc/ipc_sysctl.c
@@ -158,7 +158,9 @@ static int proc_ipcauto_dointvec_minmax(
 
 static int zero;
 static int one = 1;
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int int_max = INT_MAX;
+#endif
 
 static struct ctl_table ipc_kern_table[] = {
 	{
@@ -228,6 +230,7 @@ static struct ctl_table ipc_kern_table[]
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	{
 		.procname	= "sem_next_id",
 		.data		= &init_ipc_ns.ids[IPC_SEM_IDS].next_id,
@@ -255,6 +258,7 @@ static struct ctl_table ipc_kern_table[]
 		.extra1		= &zero,
 		.extra2		= &int_max,
 	},
+#endif
 	{}
 };
 
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

