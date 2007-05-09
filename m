From: akpm@linux-foundation.org
Subject: - ____call_usermodehelper-dont-flush_signals.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:23 -0700
Message-ID: <200705092152.l49LqNow002993@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758815AbXEIVws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     ____call_usermodehelper: don't flush_signals()
has been removed from the -mm tree.  Its filename was
     ____call_usermodehelper-dont-flush_signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ____call_usermodehelper: don't flush_signals()
From: Oleg Nesterov <oleg@tv-sign.ru>

____call_usermodehelper() has no reason for flush_signals().  It is a fresh
forked process which is going to exec a user-space application or exit on
failure.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/kmod.c~____call_usermodehelper-dont-flush_signals kernel/kmod.c
--- a/kernel/kmod.c~____call_usermodehelper-dont-flush_signals
+++ a/kernel/kmod.c
@@ -135,7 +135,6 @@ static int ____call_usermodehelper(void 
 
 	/* Unblock all signals and set the session keyring. */
 	new_session = key_get(sub_info->ring);
-	flush_signals(current);
 	spin_lock_irq(&current->sighand->siglock);
 	old_session = __install_session_keyring(current, new_session);
 	flush_signal_handlers(current, 1);
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
