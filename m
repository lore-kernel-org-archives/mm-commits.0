From: akpm@linux-foundation.org
Subject: + uml-fix-timer-switching.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:22 -0700
Message-ID: <200709210445.l8L4jM3C019094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbXIUEqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: fix timer switching
has been added to the -mm tree.  Its filename is
     uml-fix-timer-switching.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix timer switching
From: Jeff Dike <jdike@addtoit.com>

Fix up the switching between virtual and real timers.  The idle loop sleeps,
so the timer at that point must be real time.  At all other times, the timer
must be virtual.  Even when userspace is running, and the kernel is asleep,
the virtual timer is correct because the process timer will be running and the
process timer will be firing.

The timer switch used to be in the context switch and timer handler code. 
This is moved to the idle loop and the signal handler, making it much more
clear why it is happening.

switch_timers now returns the old timer type so that it may be restored.  The
signal handler uses this in order to restore the previous timer type when it
returns.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/os.h      |    2 +-
 arch/um/kernel/process.c  |    9 ++-------
 arch/um/os-Linux/signal.c |    9 +++------
 arch/um/os-Linux/time.c   |   27 ++++++++++++++++++++-------
 4 files changed, 26 insertions(+), 21 deletions(-)

diff -puN arch/um/include/os.h~uml-fix-timer-switching arch/um/include/os.h
--- a/arch/um/include/os.h~uml-fix-timer-switching
+++ a/arch/um/include/os.h
@@ -250,7 +250,7 @@ extern void os_dump_core(void);
 /* time.c */
 #define BILLION (1000 * 1000 * 1000)
 
-extern void switch_timers(int to_real);
+extern int switch_timers(int to_real);
 extern void idle_sleep(int secs);
 extern int set_interval(int is_virtual);
 extern void disable_timer(void);
diff -puN arch/um/kernel/process.c~uml-fix-timer-switching arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-fix-timer-switching
+++ a/arch/um/kernel/process.c
@@ -95,18 +95,11 @@ void *_switch_to(void *prev, void *next,
 	do {
 		current->thread.saved_task = NULL;
 
-		/* XXX need to check runqueues[cpu].idle */
-		if (current->pid == 0)
-			switch_timers(0);
-
 		switch_threads(&from->thread.switch_buf,
 			       &to->thread.switch_buf);
 
 		arch_switch_to(current->thread.prev_sched, current);
 
-		if (current->pid == 0)
-			switch_timers(1);
-
 		if (current->thread.saved_task)
 			show_regs(&(current->thread.regs));
 		next= current->thread.saved_task;
@@ -251,7 +244,9 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
+		switch_timers(1);
 		idle_sleep(10);
+		switch_timers(0);
 	}
 }
 
diff -puN arch/um/os-Linux/signal.c~uml-fix-timer-switching arch/um/os-Linux/signal.c
--- a/arch/um/os-Linux/signal.c~uml-fix-timer-switching
+++ a/arch/um/os-Linux/signal.c
@@ -59,17 +59,11 @@ static void real_alarm_handler(int sig, 
 {
 	struct uml_pt_regs regs;
 
-	if (sig == SIGALRM)
-		switch_timers(0);
-
 	if (sc != NULL)
 		copy_sc(&regs, sc);
 	regs.is_user = 0;
 	unblock_signals();
 	timer_handler(sig, &regs);
-
-	if (sig == SIGALRM)
-		switch_timers(1);
 }
 
 void alarm_handler(int sig, struct sigcontext *sc)
@@ -116,6 +110,7 @@ void (*handlers[_NSIG])(int sig, struct 
 void handle_signal(int sig, struct sigcontext *sc)
 {
 	unsigned long pending = 1UL << sig;
+	int timer = switch_timers(0);
 
 	do {
 		int nested, bail;
@@ -152,6 +147,8 @@ void handle_signal(int sig, struct sigco
 		if (!nested)
 			pending = from_irq_stack(nested);
 	} while (pending);
+
+	switch_timers(timer);
 }
 
 extern void hard_handler(int sig);
diff -puN arch/um/os-Linux/time.c~uml-fix-timer-switching arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-fix-timer-switching
+++ a/arch/um/os-Linux/time.c
@@ -12,6 +12,8 @@
 #include "os.h"
 #include "user.h"
 
+static int is_real_timer = 0;
+
 int set_interval(int is_virtual)
 {
 	int usec = 1000000/UM_HZ;
@@ -39,12 +41,14 @@ void disable_timer(void)
 	signal(SIGVTALRM, SIG_IGN);
 }
 
-void switch_timers(int to_real)
+int switch_timers(int to_real)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
-	struct itimerval enable = ((struct itimerval) { { 0, 1000000/UM_HZ },
-							{ 0, 1000000/UM_HZ }});
-	int old, new;
+	struct itimerval enable;
+	int old, new, old_type = is_real_timer;
+
+	if(to_real == old_type)
+		return to_real;
 
 	if (to_real) {
 		old = ITIMER_VIRTUAL;
@@ -55,10 +59,19 @@ void switch_timers(int to_real)
 		new = ITIMER_VIRTUAL;
 	}
 
-	if ((setitimer(old, &disable, NULL) < 0) ||
-	    (setitimer(new, &enable, NULL)))
-		printk(UM_KERN_ERR "switch_timers - setitimer failed, "
+	if (setitimer(old, &disable, &enable) < 0)
+		printk(UM_KERN_ERR "switch_timers - setitimer disable failed, "
+		       "errno = %d\n", errno);
+
+	if((enable.it_value.tv_sec == 0) && (enable.it_value.tv_usec == 0))
+		enable.it_value = enable.it_interval;
+
+	if (setitimer(new, &enable, NULL))
+		printk(UM_KERN_ERR "switch_timers - setitimer enable failed, "
 		       "errno = %d\n", errno);
+
+	is_real_timer = to_real;
+	return old_type;
 }
 
 unsigned long long os_nsecs(void)
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
