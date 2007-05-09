From: akpm@linux-foundation.org
Subject: - zap_other_threads-remove-unneeded-exit_signal-change.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:15 -0700
Message-ID: <200705092152.l49LqFJv002981@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759000AbXEIVwh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     zap_other_threads: remove unneeded ->exit_signal change
has been removed from the -mm tree.  Its filename was
     zap_other_threads-remove-unneeded-exit_signal-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: zap_other_threads: remove unneeded ->exit_signal change
From: Oleg Nesterov <oleg@tv-sign.ru>

We already depend on fact that all sub-threads have ->exit_signal == -1, no
need to set it in zap_other_threads().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN kernel/signal.c~zap_other_threads-remove-unneeded-exit_signal-change kernel/signal.c
--- a/kernel/signal.c~zap_other_threads-remove-unneeded-exit_signal-change
+++ a/kernel/signal.c
@@ -913,17 +913,6 @@ void zap_other_threads(struct task_struc
 		if (t->exit_state)
 			continue;
 
-		/*
-		 * We don't want to notify the parent, since we are
-		 * killed as part of a thread group due to another
-		 * thread doing an execve() or similar. So set the
-		 * exit signal to -1 to allow immediate reaping of
-		 * the process.  But don't detach the thread group
-		 * leader.
-		 */
-		if (t != p->group_leader)
-			t->exit_signal = -1;
-
 		/* SIGKILL will be handled before any pending SIGSTOP */
 		sigaddset(&t->pending.signal, SIGKILL);
 		signal_wake_up(t, 1);
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
