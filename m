From: akpm@linux-foundation.org
Subject: [to-be-updated] signal-retarget_shared_pending-optimize-while_each_thread-loop.patch removed from -mm tree
Date: Mon, 09 May 2011 12:17:06 -0700
Message-ID: <201105091910.p49JA62Z011858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974Ab1EITLJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 15:11:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     signal: retarget_shared_pending: optimize while_each_thread() loop
has been removed from the -mm tree.  Its filename was
     signal-retarget_shared_pending-optimize-while_each_thread-loop.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signal: retarget_shared_pending: optimize while_each_thread() loop
From: Oleg Nesterov <oleg@redhat.com>

retarget_shared_pending() blindly does recalc_sigpending_and_wake() for
every sub-thread, this is suboptimal.  We can check t->blocked and stop
looping once every bit in shared_pending has the new target.

Note: we do not take task_is_stopped_or_traced(t) into account, we are not
trying to speed up the signal delivery or to avoid the unnecessary (but
harmless) signal_wake_up(0) in this unlikely case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Reviewed-by: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signal-retarget_shared_pending-optimize-while_each_thread-loop kernel/signal.c
--- a/kernel/signal.c~signal-retarget_shared_pending-optimize-while_each_thread-loop
+++ a/kernel/signal.c
@@ -2214,8 +2214,18 @@ static void retarget_shared_pending(stru
 
 	t = tsk;
 	while_each_thread(tsk, t) {
-		if (!signal_pending(t) && !(t->flags & PF_EXITING))
-			recalc_sigpending_and_wake(t);
+		if ((t->flags & PF_EXITING))
+			continue;
+		if (!has_pending_signals(&shared_pending, &t->blocked))
+			continue;
+
+		sigandsets(&shared_pending, &shared_pending, &t->blocked);
+
+		if (!signal_pending(t))
+			signal_wake_up(t, 0);
+
+		if (sigisemptyset(&shared_pending))
+			break;
 	}
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
ptrace-fix-signal-wait_chldexit-usage-in-task_clear_group_stop_trapping.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
signal-sigprocmask-narrow-the-scope-of-siglock.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-set_current_blocked.patch
x86-signal-sys_rt_sigreturn-should-use-set_current_blocked.patch
signal-cleanup-sys_rt_sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

