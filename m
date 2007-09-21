From: akpm@linux-foundation.org
Subject: + uml-tickless-support.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:31 -0700
Message-ID: <200709210445.l8L4jVNm019112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087AbXIUEqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: tickless support
has been added to the -mm tree.  Its filename is
     uml-tickless-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: tickless support
From: Jeff Dike <jdike@addtoit.com>

Enable tickless support.

CONFIG_TICK_ONESHOT and CONFIG_NO_HZ are enabled.

itimer_clockevent gets CLOCK_EVT_FEAT_ONESHOT and an implementation of
.set_next_event.

CONFIG_UML_REAL_TIME_CLOCK goes away because it only makes sense when there is
a clock ticking away all the time.  timer_handler now just calls do_IRQ once
without trying to figure out how many ticks to emulate.

The idle loop now needs to turn ticking on and off.

Userspace ticks keep happening as usual.  However, the userspace loop keep
track of when the next wakeup should happen and suppresses process ticks until
that happens.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig                 |   12 --------
 arch/um/defconfig               |    5 +--
 arch/um/include/os.h            |    1 
 arch/um/kernel/process.c        |    3 ++
 arch/um/kernel/time.c           |   45 ++++++------------------------
 arch/um/os-Linux/skas/process.c |   27 +++++++++++++++---
 arch/um/os-Linux/time.c         |   29 ++++++++++++++++++-
 7 files changed, 67 insertions(+), 55 deletions(-)

diff -puN arch/um/Kconfig~uml-tickless-support arch/um/Kconfig
--- a/arch/um/Kconfig~uml-tickless-support
+++ a/arch/um/Kconfig
@@ -250,18 +250,6 @@ config KERNEL_STACK_ORDER
 	  be 1 << order pages.  The default is OK unless you're running Valgrind
 	  on UML, in which case, set this to 3.
 
-config UML_REAL_TIME_CLOCK
-	bool "Real-time Clock"
-	default y
-	help
-	  This option makes UML time deltas match wall clock deltas.  This
-	  should normally be enabled.  The exception would be if you are
-	  debugging with UML and spend long times with UML stopped at a
-	  breakpoint.  In this case, when UML is restarted, it will call the
-	  timer enough times to make up for the time spent at the breakpoint.
-	  This could result in a noticeable lag.  If this is a problem, then
-	  disable this option.
-
 endmenu
 
 source "init/Kconfig"
diff -puN arch/um/defconfig~uml-tickless-support arch/um/defconfig
--- a/arch/um/defconfig~uml-tickless-support
+++ a/arch/um/defconfig
@@ -73,8 +73,8 @@ CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
-# CONFIG_TICK_ONESHOT is not set
-# CONFIG_NO_HZ is not set
+CONFIG_TICK_ONESHOT=y
+CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LD_SCRIPT_DYN=y
 CONFIG_NET=y
@@ -87,7 +87,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_NEST_LEVEL=0
 # CONFIG_HIGHMEM is not set
 CONFIG_KERNEL_STACK_ORDER=0
-CONFIG_UML_REAL_TIME_CLOCK=y
 
 #
 # Code maturity level options
diff -puN arch/um/include/os.h~uml-tickless-support arch/um/include/os.h
--- a/arch/um/include/os.h~uml-tickless-support
+++ a/arch/um/include/os.h
@@ -254,6 +254,7 @@ extern void os_dump_core(void);
 extern int switch_timers(int to_real);
 extern void idle_sleep(int secs);
 extern int set_interval(void);
+extern int timer_one_shot(int ticks);
 extern void disable_timer(void);
 extern void uml_idle_timer(void);
 extern unsigned long long os_nsecs(void);
diff -puN arch/um/kernel/process.c~uml-tickless-support arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-tickless-support
+++ a/arch/um/kernel/process.c
@@ -13,6 +13,7 @@
 #include "linux/ptrace.h"
 #include "linux/random.h"
 #include "linux/sched.h"
+#include "linux/tick.h"
 #include "linux/threads.h"
 #include "asm/pgtable.h"
 #include "asm/uaccess.h"
@@ -244,9 +245,11 @@ void default_idle(void)
 		if (need_resched())
 			schedule();
 
+		tick_nohz_stop_sched_tick();
 		switch_timers(1);
 		idle_sleep(10);
 		switch_timers(0);
+		tick_nohz_restart_sched_tick();
 	}
 }
 
diff -puN arch/um/kernel/time.c~uml-tickless-support arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-tickless-support
+++ a/arch/um/kernel/time.c
@@ -20,41 +20,12 @@ unsigned long long sched_clock(void)
 	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
 }
 
-#ifdef CONFIG_UML_REAL_TIME_CLOCK
-static unsigned long long prev_nsecs[NR_CPUS];
-static long long delta[NR_CPUS];		/* Deviation per interval */
-#endif
-
 void timer_handler(int sig, struct uml_pt_regs *regs)
 {
-	unsigned long long ticks = 0;
 	unsigned long flags;
-#ifdef CONFIG_UML_REAL_TIME_CLOCK
-	int c = cpu();
-	if (prev_nsecs[c]) {
-		/* We've had 1 tick */
-		unsigned long long nsecs = os_nsecs();
-
-		delta[c] += nsecs - prev_nsecs[c];
-		prev_nsecs[c] = nsecs;
-
-		/* Protect against the host clock being set backwards */
-		if (delta[c] < 0)
-			delta[c] = 0;
-
-		ticks += (delta[c] * HZ) / BILLION;
-		delta[c] -= (ticks * BILLION) / HZ;
-	}
-	else prev_nsecs[c] = os_nsecs();
-#else
-	ticks = 1;
-#endif
 
 	local_irq_save(flags);
-	while (ticks > 0) {
-		do_IRQ(TIMER_IRQ, regs);
-		ticks--;
-	}
+	do_IRQ(TIMER_IRQ, regs);
 	local_irq_restore(flags);
 }
 
@@ -68,10 +39,8 @@ static void itimer_set_mode(enum clock_e
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-		disable_timer();
-		break;
 	case CLOCK_EVT_MODE_ONESHOT:
-		BUG();
+		disable_timer();
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
@@ -79,13 +48,19 @@ static void itimer_set_mode(enum clock_e
 	}
 }
 
+static int itimer_next_event(unsigned long delta,
+			     struct clock_event_device *evt)
+{
+	return timer_one_shot(delta + 1);
+}
+
 static struct clock_event_device itimer_clockevent = {
 	.name		= "itimer",
 	.rating		= 250,
 	.cpumask	= CPU_MASK_ALL,
-	.features	= CLOCK_EVT_FEAT_PERIODIC,
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= itimer_set_mode,
-	.set_next_event = NULL,
+	.set_next_event = itimer_next_event,
 	.shift		= 32,
 	.irq		= 0,
 };
diff -puN arch/um/os-Linux/skas/process.c~uml-tickless-support arch/um/os-Linux/skas/process.c
--- a/arch/um/os-Linux/skas/process.c~uml-tickless-support
+++ a/arch/um/os-Linux/skas/process.c
@@ -287,10 +287,18 @@ int start_userspace(unsigned long stub_s
 
 void userspace(struct uml_pt_regs *regs)
 {
+	struct itimerval timer;
+	unsigned long long nsecs, now;
 	int err, status, op, pid = userspace_pid[0];
 	/* To prevent races if using_sysemu changes under us.*/
 	int local_using_sysemu;
 
+	if (getitimer(ITIMER_VIRTUAL, &timer))
+		printk("Failed to get itimer, errno = %d\n", errno);
+	nsecs = timer.it_value.tv_sec * BILLION +
+		timer.it_value.tv_usec * 1000;
+	nsecs += os_nsecs();
+
 	while (1) {
 		restore_registers(pid, regs);
 
@@ -333,8 +341,18 @@ void userspace(struct uml_pt_regs *regs)
 			case SIGTRAP:
 				relay_signal(SIGTRAP, regs);
 				break;
-			case SIGIO:
 			case SIGVTALRM:
+				now = os_nsecs();
+				if(now < nsecs)
+					break;
+				block_signals();
+				(*sig_info[sig])(sig, regs);
+				unblock_signals();
+				nsecs = timer.it_value.tv_sec * BILLION +
+					timer.it_value.tv_usec * 1000;
+				nsecs += os_nsecs();
+				break;
+			case SIGIO:
 			case SIGILL:
 			case SIGBUS:
 			case SIGFPE:
@@ -378,6 +396,7 @@ __initcall(init_thread_regs);
 
 int copy_context_skas0(unsigned long new_stack, int pid)
 {
+	struct timeval tv = { .tv_sec = 0, .tv_usec = 1000000 / UM_HZ };
 	int err;
 	unsigned long current_stack = current_stub_stack();
 	struct stub_data *data = (struct stub_data *) current_stack;
@@ -392,9 +411,9 @@ int copy_context_skas0(unsigned long new
 	*data = ((struct stub_data) { .offset	= MMAP_OFFSET(new_offset),
 				      .fd	= new_fd,
 				      .timer    = ((struct itimerval)
-					            { { 0, 1000000 / UM_HZ },
-						      { 0, 1000000 / UM_HZ }})
-				 });
+					           { .it_value = tv,
+						     .it_interval = tv }) });
+
 	err = ptrace_setregs(pid, thread_regs);
 	if (err < 0)
 		panic("copy_context_skas0 : PTRACE_SETREGS failed, "
diff -puN arch/um/os-Linux/time.c~uml-tickless-support arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-tickless-support
+++ a/arch/um/os-Linux/time.c
@@ -26,6 +26,33 @@ int set_interval(void)
 	return 0;
 }
 
+int timer_one_shot(int ticks)
+{
+	unsigned long usec = ticks * 1000000 / UM_HZ;
+	unsigned long sec = usec / 1000000;
+	struct itimerval interval;
+
+	usec %= 1000000;
+	interval = ((struct itimerval) { { 0, 0 }, { sec, usec } });
+
+	if (setitimer(ITIMER_VIRTUAL, &interval, NULL) == -1)
+		return -errno;
+
+	return 0;
+}
+
+static inline unsigned long long tv_to_nsec(struct timeval *tv)
+{
+	/* Cast tv->tv_sec to a long long in order to force this whole
+	 * calculation to 64 bits.  Otherwise, we'll get a negative
+	 * 32-bit number getting cast to a very large 64-bit number on
+	 * return.
+	 */
+
+	return ((unsigned long long) tv->tv_sec) * BILLION +
+		tv->tv_usec * 1000;
+}
+
 void disable_timer(void)
 {
 	struct itimerval disable = ((struct itimerval) { { 0, 0 }, { 0, 0 }});
@@ -74,7 +101,7 @@ unsigned long long os_nsecs(void)
 	struct timeval tv;
 
 	gettimeofday(&tv, NULL);
-	return (unsigned long long) tv.tv_sec * BILLION + tv.tv_usec * 1000;
+	return tv_to_nsec(&tv);
 }
 
 void idle_sleep(int secs)
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
