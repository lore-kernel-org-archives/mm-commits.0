From: akpm@linux-foundation.org
Subject: + uml-eliminate-sigalrm.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:35 -0700
Message-ID: <200709210445.l8L4jZlh019118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbXIUEqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: eliminate SIGALRM
has been added to the -mm tree.  Its filename is
     uml-eliminate-sigalrm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: eliminate SIGALRM
From: Jeff Dike <jdike@addtoit.com>

Now that ITIMER_REAL is no longer used, there is no need for any use of
SIGALRM whatsoever.  This patch removes all mention of it.

In addition, real_alarm_handler took a signal argument which is now always
SIGVTALRM.  So, that is gone.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/irq.c          |    2 +-
 arch/um/os-Linux/main.c         |    2 +-
 arch/um/os-Linux/process.c      |   10 +++++-----
 arch/um/os-Linux/signal.c       |   28 +++++++---------------------
 arch/um/os-Linux/skas/process.c |    4 +---
 arch/um/os-Linux/skas/trap.c    |    5 ++---
 arch/um/os-Linux/trap.c         |    1 -
 7 files changed, 17 insertions(+), 35 deletions(-)

diff -puN arch/um/os-Linux/irq.c~uml-eliminate-sigalrm arch/um/os-Linux/irq.c
--- a/arch/um/os-Linux/irq.c~uml-eliminate-sigalrm
+++ a/arch/um/os-Linux/irq.c
@@ -146,6 +146,6 @@ void init_irq_signals(int on_sigstack)
 	flags = on_sigstack ? SA_ONSTACK : 0;
 
 	set_handler(SIGIO, (__sighandler_t) sig_handler, flags | SA_RESTART,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
+		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	signal(SIGWINCH, SIG_IGN);
 }
diff -puN arch/um/os-Linux/main.c~uml-eliminate-sigalrm arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-eliminate-sigalrm
+++ a/arch/um/os-Linux/main.c
@@ -161,7 +161,7 @@ int __init main(int argc, char **argv, c
 	 * some time) and cause a segfault.
 	 */
 
-	/* stop timers and set SIG*ALRM to be ignored */
+	/* stop timers and set SIGVTALRM to be ignored */
 	disable_timer();
 
 	/* disable SIGIO for the fds and set SIGIO to be ignored */
diff -puN arch/um/os-Linux/process.c~uml-eliminate-sigalrm arch/um/os-Linux/process.c
--- a/arch/um/os-Linux/process.c~uml-eliminate-sigalrm
+++ a/arch/um/os-Linux/process.c
@@ -238,15 +238,15 @@ out:
 void init_new_thread_signals(void)
 {
 	set_handler(SIGSEGV, (__sighandler_t) sig_handler, SA_ONSTACK,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
+		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	set_handler(SIGTRAP, (__sighandler_t) sig_handler, SA_ONSTACK,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
+		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	set_handler(SIGFPE, (__sighandler_t) sig_handler, SA_ONSTACK,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
+		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	set_handler(SIGILL, (__sighandler_t) sig_handler, SA_ONSTACK,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
+		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	set_handler(SIGBUS, (__sighandler_t) sig_handler, SA_ONSTACK,
-		    SIGUSR1, SIGIO, SIGWINCH, SIGALRM, SIGVTALRM, -1);
+		    SIGUSR1, SIGIO, SIGWINCH, SIGVTALRM, -1);
 	signal(SIGHUP, SIG_IGN);
 
 	init_irq_signals(1);
diff -puN arch/um/os-Linux/signal.c~uml-eliminate-sigalrm arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-eliminate-sigalrm
+++ a/arch/um/os-Linux/signal.c
@@ -15,8 +15,7 @@
 #include "user.h"
 
 /*
- * These are the asynchronous signals.  SIGVTALRM and SIGARLM are handled
- * together under SIGVTALRM_BIT.  SIGPROF is excluded because we want to
+ * These are the asynchronous signals.  SIGPROF is excluded because we want to
  * be able to profile all of UML, not just the non-critical sections.  If
  * profiling is not thread-safe, then that is not my problem.  We can disable
  * profiling when SMP is enabled in that case.
@@ -27,9 +26,6 @@
 #define SIGVTALRM_BIT 1
 #define SIGVTALRM_MASK (1 << SIGVTALRM_BIT)
 
-#define SIGALRM_BIT 2
-#define SIGALRM_MASK (1 << SIGALRM_BIT)
-
 /*
  * These are used by both the signal handlers and
  * block/unblock_signals.  I don't want modifications cached in a
@@ -55,7 +51,7 @@ void sig_handler(int sig, struct sigcont
 	set_signals(enabled);
 }
 
-static void real_alarm_handler(int sig, struct sigcontext *sc)
+static void real_alarm_handler(struct sigcontext *sc)
 {
 	struct uml_pt_regs regs;
 
@@ -63,7 +59,7 @@ static void real_alarm_handler(int sig, 
 		copy_sc(&regs, sc);
 	regs.is_user = 0;
 	unblock_signals();
-	timer_handler(sig, &regs);
+	timer_handler(SIGVTALRM, &regs);
 }
 
 void alarm_handler(int sig, struct sigcontext *sc)
@@ -72,27 +68,20 @@ void alarm_handler(int sig, struct sigco
 
 	enabled = signals_enabled;
 	if (!signals_enabled) {
-		if (sig == SIGVTALRM)
-			pending |= SIGVTALRM_MASK;
-		else pending |= SIGALRM_MASK;
-
+		pending |= SIGVTALRM_MASK;
 		return;
 	}
 
 	block_signals();
 
-	real_alarm_handler(sig, sc);
+	real_alarm_handler(sc);
 	set_signals(enabled);
 }
 
 void timer_init(void)
 {
 	set_handler(SIGVTALRM, (__sighandler_t) alarm_handler,
-		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH,
-		    SIGALRM, -1);
-	set_handler(SIGALRM, (__sighandler_t) alarm_handler,
-		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH,
-		    SIGALRM, -1);
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, -1);
 }
 
 void set_sigstack(void *sig_stack, int size)
@@ -267,11 +256,8 @@ void unblock_signals(void)
 		if (save_pending & SIGIO_MASK)
 			sig_handler_common_skas(SIGIO, NULL);
 
-		if (save_pending & SIGALRM_MASK)
-			real_alarm_handler(SIGALRM, NULL);
-
 		if (save_pending & SIGVTALRM_MASK)
-			real_alarm_handler(SIGVTALRM, NULL);
+			real_alarm_handler(NULL);
 	}
 }
 
diff -puN arch/um/os-Linux/skas/process.c~uml-eliminate-sigalrm arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-eliminate-sigalrm
+++ a/arch/um/os-Linux/skas/process.c
@@ -222,7 +222,6 @@ static int userspace_tramp(void *stack)
 		sigemptyset(&sa.sa_mask);
 		sigaddset(&sa.sa_mask, SIGIO);
 		sigaddset(&sa.sa_mask, SIGWINCH);
-		sigaddset(&sa.sa_mask, SIGALRM);
 		sigaddset(&sa.sa_mask, SIGVTALRM);
 		sigaddset(&sa.sa_mask, SIGUSR1);
 		sa.sa_flags = SA_ONSTACK;
@@ -539,8 +538,7 @@ int start_idle_thread(void *stack, jmp_b
 	int n;
 
 	set_handler(SIGWINCH, (__sighandler_t) sig_handler,
-		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGALRM,
-		    SIGVTALRM, -1);
+		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGVTALRM, -1);
 
 	/*
 	 * Can't use UML_SETJMP or UML_LONGJMP here because they save
diff -puN arch/um/os-Linux/skas/trap.c~uml-eliminate-sigalrm arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-eliminate-sigalrm
+++ a/arch/um/os-Linux/skas/trap.c
@@ -58,9 +58,8 @@ void sig_handler_common_skas(int sig, vo
 
 	handler = sig_info[sig];
 
-	/* unblock SIGALRM, SIGVTALRM, SIGIO if sig isn't IRQ signal */
-	if (sig != SIGIO && sig != SIGWINCH &&
-	    sig != SIGVTALRM && sig != SIGALRM)
+	/* unblock SIGVTALRM, SIGIO if sig isn't IRQ signal */
+	if ((sig != SIGIO) && (sig != SIGWINCH) && (sig != SIGVTALRM))
 		unblock_signals();
 
 	handler(sig, r);
diff -puN arch/um/os-Linux/trap.c~uml-eliminate-sigalrm arch/um/os-Linux/trap.c
--- a/arch/um/os-Linux/trap.c~uml-eliminate-sigalrm
+++ a/arch/um/os-Linux/trap.c
@@ -20,5 +20,4 @@ void os_fill_handlinfo(struct kern_handl
 	sig_info[SIGSEGV] = h.page_fault;
 	sig_info[SIGIO] = h.sigio_handler;
 	sig_info[SIGVTALRM] = h.timer_handler;
-	sig_info[SIGALRM] = h.timer_handler;
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-stop-saving-process-fp-state-fix.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-rename-pt_regs-general-purpose-register-file-fix.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-tickless-support.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
bitops-introduce-lock-ops.patch
