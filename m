From: akpm@linux-foundation.org
Subject: + uml-generic_clockevents-support.patch added to -mm tree
Date: Thu, 20 Sep 2007 21:45:28 -0700
Message-ID: <200709210445.l8L4jSc6019106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50482 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbXIUEqP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 00:46:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de


The patch titled
     uml: GENERIC_CLOCKEVENTS support
has been added to the -mm tree.  Its filename is
     uml-generic_clockevents-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: GENERIC_CLOCKEVENTS support
From: Jeff Dike <jdike@addtoit.com>

Enable CONFIG_GENERIC_CLOCKEVENTS.

timer_irq gets its name changed to timer_handler, and becomes the recipient of
timer signals.

The clock_event_device is set up to imitate the current ticking clock, i.e. 
CLOCK_EVT_FEAT_ONESHOT is not enabled yet.

disable_timer now doesn't ignore SIGALRM and SIGVTALRM because that breaks
delay calibration.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig         |    4 +
 arch/um/defconfig       |    3 +
 arch/um/kernel/time.c   |   99 ++++++++++++++++++--------------------
 arch/um/os-Linux/time.c |    4 -
 4 files changed, 54 insertions(+), 56 deletions(-)

diff -puN arch/um/Kconfig~uml-generic_clockevents-support arch/um/Kconfig
--- a/arch/um/Kconfig~uml-generic_clockevents-support
+++ a/arch/um/Kconfig
@@ -59,6 +59,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CLOCKEVENTS
+	bool
+	default y
+
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool
diff -puN arch/um/defconfig~uml-generic_clockevents-support arch/um/defconfig
--- a/arch/um/defconfig~uml-generic_clockevents-support
+++ a/arch/um/defconfig
@@ -73,6 +73,9 @@ CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_TICK_ONESHOT is not set
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
 CONFIG_LD_SCRIPT_DYN=y
 CONFIG_NET=y
 CONFIG_BINFMT_ELF=y
diff -puN arch/um/kernel/time.c~uml-generic_clockevents-support arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-generic_clockevents-support
+++ a/arch/um/kernel/time.c
@@ -3,6 +3,7 @@
  * Licensed under the GPL
  */
 
+#include "linux/clockchips.h"
 #include "linux/interrupt.h"
 #include "linux/jiffies.h"
 #include "linux/threads.h"
@@ -24,9 +25,10 @@ static unsigned long long prev_nsecs[NR_
 static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
-void timer_irq(struct uml_pt_regs *regs)
+void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	unsigned long long ticks = 0;
+	unsigned long flags;
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
 	int c = cpu();
 	if (prev_nsecs[c]) {
@@ -47,89 +49,82 @@ void timer_irq(struct uml_pt_regs *regs)
 #else
 	ticks = 1;
 #endif
+
+	local_irq_save(flags);
 	while (ticks > 0) {
 		do_IRQ(TIMER_IRQ, regs);
 		ticks--;
 	}
+	local_irq_restore(flags);
 }
 
-/* Protects local_offset */
-static DEFINE_SPINLOCK(timer_spinlock);
-static unsigned long long local_offset = 0;
-
-static inline unsigned long long get_time(void)
+static void itimer_set_mode(enum clock_event_mode mode,
+			    struct clock_event_device *evt)
 {
-	unsigned long long nsecs;
-	unsigned long flags;
-
-	spin_lock_irqsave(&timer_spinlock, flags);
-	nsecs = os_nsecs();
-	nsecs += local_offset;
-	spin_unlock_irqrestore(&timer_spinlock, flags);
+	switch(mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		set_interval();
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		disable_timer();
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+		BUG();
+		break;
 
-	return nsecs;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	}
 }
 
-irqreturn_t um_timer(int irq, void *dev)
-{
-	unsigned long long nsecs;
-	unsigned long flags;
-
-	write_seqlock_irqsave(&xtime_lock, flags);
+static struct clock_event_device itimer_clockevent = {
+	.name		= "itimer",
+	.rating		= 250,
+	.cpumask	= CPU_MASK_ALL,
+	.features	= CLOCK_EVT_FEAT_PERIODIC,
+	.set_mode	= itimer_set_mode,
+	.set_next_event = NULL,
+	.shift		= 32,
+	.irq		= 0,
+};
 
-	do_timer(1);
-
-#ifdef CONFIG_UML_REAL_TIME_CLOCK
-	nsecs = get_time();
-#else
-	nsecs = (unsigned long long) xtime.tv_sec * BILLION + xtime.tv_nsec +
-		BILLION / HZ;
-#endif
-	xtime.tv_sec = nsecs / NSEC_PER_SEC;
-	xtime.tv_nsec = nsecs - xtime.tv_sec * NSEC_PER_SEC;
-
-	write_sequnlock_irqrestore(&xtime_lock, flags);
+static irqreturn_t um_timer(int irq, void *dev)
+{
+	(*itimer_clockevent.event_handler)(&itimer_clockevent);
 
 	return IRQ_HANDLED;
 }
 
-static void register_timer(void)
+static void __init setup_itimer(void)
 {
 	int err;
 
-	timer_init();
-
 	err = request_irq(TIMER_IRQ, um_timer, IRQF_DISABLED, "timer", NULL);
 	if (err != 0)
 		printk(KERN_ERR "register_timer : request_irq failed - "
 		       "errno = %d\n", -err);
 
-	err = set_interval();
-	if (err != 0)
-		printk(KERN_ERR "register_timer : set_interval failed - "
-		       "errno = %d\n", -err);
+	itimer_clockevent.mult = div_sc(HZ, NSEC_PER_SEC, 32);
+	itimer_clockevent.max_delta_ns =
+		clockevent_delta2ns(60 * HZ, &itimer_clockevent);
+	itimer_clockevent.min_delta_ns =
+		clockevent_delta2ns(1, &itimer_clockevent);
+	clockevents_register_device(&itimer_clockevent);
 }
 
 extern void (*late_time_init)(void);
 
-void time_init(void)
+void __init time_init(void)
 {
 	long long nsecs;
 
+	timer_init();
+
 	nsecs = os_nsecs();
 	set_normalized_timespec(&wall_to_monotonic, -nsecs / BILLION,
 				-nsecs % BILLION);
 	set_normalized_timespec(&xtime, nsecs / BILLION, nsecs % BILLION);
-	late_time_init = register_timer;
-}
-
-void timer_handler(int sig, struct uml_pt_regs *regs)
-{
-	if (current_thread->cpu == 0)
-		timer_irq(regs);
-	local_irq_disable();
-	irq_enter();
-	update_process_times(regs->is_user);
-	irq_exit();
-	local_irq_enable();
+	late_time_init = setup_itimer;
 }
diff -puN arch/um/os-Linux/time.c~uml-generic_clockevents-support arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-generic_clockevents-support
+++ a/arch/um/os-Linux/time.c
@@ -34,10 +34,6 @@ void disable_timer(void)
 	    (setitimer(ITIMER_REAL, &disable, NULL) < 0))
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
 		       "errno = %d\n", errno);
-
-	/* If there are signals already queued, after unblocking ignore them */
-	signal(SIGALRM, SIG_IGN);
-	signal(SIGVTALRM, SIG_IGN);
 }
 
 int switch_timers(int to_real)
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
