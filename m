From: akpm@linux-foundation.org
Subject: - wait_for_helper-remove-unneeded-do_sigaction.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:33 -0700
Message-ID: <200705092152.l49LqXH1003009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758992AbXEIVw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     wait_for_helper: remove unneeded do_sigaction()
has been removed from the -mm tree.  Its filename was
     wait_for_helper-remove-unneeded-do_sigaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: wait_for_helper: remove unneeded do_sigaction()
From: Oleg Nesterov <oleg@tv-sign.ru>

allow_signal(SIGCHLD) does all necessary job, no need to call do_sigaction()
prior to.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN kernel/kmod.c~wait_for_helper-remove-unneeded-do_sigaction kernel/kmod.c
--- a/kernel/kmod.c~wait_for_helper-remove-unneeded-do_sigaction
+++ a/kernel/kmod.c
@@ -185,14 +185,9 @@ static int wait_for_helper(void *data)
 {
 	struct subprocess_info *sub_info = data;
 	pid_t pid;
-	struct k_sigaction sa;
 
 	/* Install a handler: if SIGCLD isn't handled sys_wait4 won't
 	 * populate the status, but will return -ECHILD. */
-	sa.sa.sa_handler = SIG_IGN;
-	sa.sa.sa_flags = 0;
-	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
-	do_sigaction(SIGCHLD, &sa, NULL);
 	allow_signal(SIGCHLD);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
fix-pf_nofreeze-and-freezeable-race-2.patch
freezer-document-task_lock-in-thaw_process.patch
move-frozen_process-to-kernel-power-processc.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
libata-core-convert-to-use-cancel_rearming_delayed_work.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
dont-init-pgrp-and-__session-in-init_signals.patch
