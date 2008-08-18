From: akpm@linux-foundation.org
Subject: - x86-signals-use-asm-syscallh.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:46 -0700
Message-ID: <200808181940.m7IJek3r008485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759182AbYHRTvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86 signals: use asm/syscall.h
has been removed from the -mm tree.  Its filename was
     x86-signals-use-asm-syscallh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86 signals: use asm/syscall.h
From: Roland McGrath <roland@redhat.com>

Replace local inlines with the asm/syscall.h interfaces that do the same
things.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/signal_64.c |   38 ++++------------------------------
 1 file changed, 5 insertions(+), 33 deletions(-)

diff -puN arch/x86/kernel/signal_64.c~x86-signals-use-asm-syscallh arch/x86/kernel/signal_64.c
--- a/arch/x86/kernel/signal_64.c~x86-signals-use-asm-syscallh
+++ a/arch/x86/kernel/signal_64.c
@@ -27,6 +27,7 @@
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
 #include <asm/mce.h>
+#include <asm/syscall.h>
 #include "sigframe.h"
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
@@ -347,35 +348,6 @@ give_sigsegv:
 }
 
 /*
- * Return -1L or the syscall number that @regs is executing.
- */
-static long current_syscall(struct pt_regs *regs)
-{
-	/*
-	 * We always sign-extend a -1 value being set here,
-	 * so this is always either -1L or a syscall number.
-	 */
-	return regs->orig_ax;
-}
-
-/*
- * Return a value that is -EFOO if the system call in @regs->orig_ax
- * returned an error.  This only works for @regs from @current.
- */
-static long current_syscall_ret(struct pt_regs *regs)
-{
-#ifdef CONFIG_IA32_EMULATION
-	if (test_thread_flag(TIF_IA32))
-		/*
-		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
-		 * and will match correctly in comparisons.
-		 */
-		return (int) regs->ax;
-#endif
-	return regs->ax;
-}
-
-/*
  * OK, we're invoking a handler
  */	
 
@@ -386,9 +358,9 @@ handle_signal(unsigned long sig, siginfo
 	int ret;
 
 	/* Are we from a system call? */
-	if (current_syscall(regs) >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch (current_syscall_ret(regs)) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTART_RESTARTBLOCK:
 		case -ERESTARTNOHAND:
 			regs->ax = -EINTR;
@@ -511,9 +483,9 @@ static void do_signal(struct pt_regs *re
 	}
 
 	/* Did we come from a system call? */
-	if (current_syscall(regs) >= 0) {
+	if (syscall_get_nr(current, regs) >= 0) {
 		/* Restart the system call - no handlers present */
-		switch (current_syscall_ret(regs)) {
+		switch (syscall_get_error(current, regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
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

