From: akpm@linux-foundation.org
Subject: - x86-tracehook_signal_handler.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:40 -0700
Message-ID: <200808181940.m7IJeeFb008476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932727AbYHRTml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: tracehook_signal_handler
has been removed from the -mm tree.  Its filename was
     x86-tracehook_signal_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: tracehook_signal_handler
From: Roland McGrath <roland@redhat.com>

This makes the x86 signal handling code use tracehook_signal_handler() in
place of calling into ptrace guts.  The call is moved after the sa_mask
processing, but there is no other change.  This cleanup doesn't matter to
existing debuggers, but is the sensible thing: have all facets of the
handler setup complete before the debugger inspects the task again.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal_32.c |    6 ++++--
 arch/x86/kernel/signal_64.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/signal_32.c~x86-tracehook_signal_handler arch/x86/kernel/signal_32.c
--- a/arch/x86/kernel/signal_32.c~x86-tracehook_signal_handler
+++ a/arch/x86/kernel/signal_32.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/tracehook.h>
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
@@ -558,8 +559,6 @@ handle_signal(unsigned long sig, siginfo
 	 * handler too.
 	 */
 	regs->flags &= ~X86_EFLAGS_TF;
-	if (test_thread_flag(TIF_SINGLESTEP))
-		ptrace_notify(SIGTRAP);
 
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
@@ -568,6 +567,9 @@ handle_signal(unsigned long sig, siginfo
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
+	tracehook_signal_handler(sig, info, ka, regs,
+				 test_thread_flag(TIF_SINGLESTEP));
+
 	return 0;
 }
 
diff -puN arch/x86/kernel/signal_64.c~x86-tracehook_signal_handler arch/x86/kernel/signal_64.c
--- a/arch/x86/kernel/signal_64.c~x86-tracehook_signal_handler
+++ a/arch/x86/kernel/signal_64.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/personality.h>
@@ -444,8 +445,6 @@ handle_signal(unsigned long sig, siginfo
 		 * handler too.
 		 */
 		regs->flags &= ~X86_EFLAGS_TF;
-		if (test_thread_flag(TIF_SINGLESTEP))
-			ptrace_notify(SIGTRAP);
 
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
@@ -453,6 +452,9 @@ handle_signal(unsigned long sig, siginfo
 			sigaddset(&current->blocked,sig);
 		recalc_sigpending();
 		spin_unlock_irq(&current->sighand->siglock);
+
+		tracehook_signal_handler(sig, info, ka, regs,
+					 test_thread_flag(TIF_SINGLESTEP));
 	}
 
 	return ret;
_

Patches currently in -mm which might be from roland@redhat.com are

linux-next.patch
x86-tracehook-config_have_arch_tracehook.patch
sched-do_wait_for_common-use-signal_pending_state.patch
wait_task_inactive-dont-consider-task-nivcsw.patch
wait_task_inactive-improve-the-returned-value-for-nvcsw-==-0.patch
wait_task_inactive-fix-the-config_smp-version.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

