From: akpm@linux-foundation.org
Subject: + signal-retarget_shared_pending-optimize-while_each_thread-loop.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:18:57 -0700
Message-ID: <201104202118.p3KLIwaG027664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863Ab1DTVTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     signal: retarget_shared_pending: optimize while_each_thread() loop
has been added to the -mm tree.  Its filename is
     signal-retarget_shared_pending-optimize-while_each_thread-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
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
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
signal-introduce-retarget_shared_pending.patch
signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
signal-retarget_shared_pending-optimize-while_each_thread-loop.patch
signal-sigprocmask-narrow-the-scope-of-siglock.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-set_current_blocked.patch
x86-signal-sys_rt_sigreturn-should-use-set_current_blocked.patch
signal-cleanup-sys_rt_sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

