From: akpm@linux-foundation.org
Subject: - uml-generic_clockevents-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:46 -0700
Message-ID: <200710162038.l9GKckUd015480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965698AbXJPV3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uml: GENERIC_CLOCKEVENTS support
has been removed from the -mm tree.  Its filename was
     uml-generic_clockevents-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
