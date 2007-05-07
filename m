From: akpm@linux-foundation.org
Subject: + clockevents-fix-resume-logic-updated-version.patch added to -mm tree
Date: Mon, 07 May 2007 15:43:18 -0700
Message-ID: <200705072243.l47MhIag007288@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbXEGWpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, stable@kernel.org


The patch titled
     clockevents: fix resume logic
has been added to the -mm tree.  Its filename is
     clockevents-fix-resume-logic-updated-version.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>

We need to make sure that the clockevent devices are resumed before the
tick is resumed.  The current resume logic does not guarantee this.

Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
event devices before resuming the tick / oneshot functionality.

Fixup the existing users.

Fix the PIT handling of CLOCK_EVT_SHUTDOWN by disabling the interrupt
instead of switching to oneshot mode, as this causes slowness on a couple
of systems.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c      |    3 +
 arch/i386/kernel/hpet.c      |   71 ++-------------------------------
 arch/i386/kernel/i8253.c     |   43 +++++++++++++------
 include/linux/clockchips.h   |    1 
 kernel/time/tick-broadcast.c |    4 +
 kernel/time/tick-common.c    |   16 ++++---
 6 files changed, 51 insertions(+), 87 deletions(-)

diff -puN arch/i386/kernel/apic.c~clockevents-fix-resume-logic-updated-version arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-fix-resume-logic-updated-version
+++ a/arch/i386/kernel/apic.c
@@ -263,6 +263,9 @@ static void lapic_timer_setup(enum clock
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write_around(APIC_LVTT, v);
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
 	}
 
 	local_irq_restore(flags);
diff -puN arch/i386/kernel/hpet.c~clockevents-fix-resume-logic-updated-version arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clockevents-fix-resume-logic-updated-version
+++ a/arch/i386/kernel/hpet.c
@@ -212,6 +212,10 @@ static void hpet_set_mode(enum clock_eve
 		cfg &= ~HPET_TN_ENABLE;
 		hpet_writel(cfg, HPET_T0_CFG);
 		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		hpet_enable_int();
+		break;
 	}
 }
 
@@ -242,6 +246,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.resume		= hpet_start_counter,
 };
 
 /*
@@ -318,7 +323,6 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
-
 	if (id & HPET_ID_LEGSUP) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
@@ -551,68 +555,3 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
 	return IRQ_HANDLED;
 }
 #endif
-
-
-/*
- * Suspend/resume part
- */
-
-#ifdef CONFIG_PM
-
-static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
-{
-	unsigned long cfg = hpet_readl(HPET_CFG);
-
-	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
-	hpet_writel(cfg, HPET_CFG);
-
-	return 0;
-}
-
-static int hpet_resume(struct sys_device *sys_device)
-{
-	unsigned int id;
-
-	hpet_start_counter();
-
-	id = hpet_readl(HPET_ID);
-
-	if (id & HPET_ID_LEGSUP)
-		hpet_enable_int();
-
-	return 0;
-}
-
-static struct sysdev_class hpet_class = {
-	set_kset_name("hpet"),
-	.suspend	= hpet_suspend,
-	.resume		= hpet_resume,
-};
-
-static struct sys_device hpet_device = {
-	.id		= 0,
-	.cls		= &hpet_class,
-};
-
-
-static __init int hpet_register_sysfs(void)
-{
-	int err;
-
-	if (!is_hpet_capable())
-		return 0;
-
-	err = sysdev_class_register(&hpet_class);
-
-	if (!err) {
-		err = sysdev_register(&hpet_device);
-		if (err)
-			sysdev_class_unregister(&hpet_class);
-	}
-
-	return err;
-}
-
-device_initcall(hpet_register_sysfs);
-
-#endif
diff -puN arch/i386/kernel/i8253.c~clockevents-fix-resume-logic-updated-version arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clockevents-fix-resume-logic-updated-version
+++ a/arch/i386/kernel/i8253.c
@@ -3,11 +3,11 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/jiffies.h>
-#include <linux/sysdev.h>
 #include <linux/module.h>
-#include <linux/init.h>
+#include <linux/spinlock.h>
 
 #include <asm/smp.h>
 #include <asm/delay.h>
@@ -26,6 +26,24 @@ EXPORT_SYMBOL(i8253_lock);
  */
 struct clock_event_device *global_clock_event;
 
+/* Status of the PIT interrupt */
+static int pit_irq_disabled;
+
+/*
+ * Control pit interrupt enable / disable
+ */
+static void pit_control_irq(int disable)
+{
+	if (pit_irq_disabled == disable)
+		return;
+
+	pit_irq_disabled = disable;
+	if (disable)
+		disable_irq(0);
+	else
+		enable_irq(0);
+}
+
 /*
  * Initialize the PIT timer.
  *
@@ -42,26 +60,23 @@ static void init_pit_timer(enum clock_ev
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
-		udelay(10);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		udelay(10);
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
+		pit_control_irq(0);
 		break;
 
-	/*
-	 * Avoid unnecessary state transitions, as it confuses
-	 * Geode / Cyrix based boxen.
-	 */
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		if (evt->mode == CLOCK_EVT_MODE_UNUSED)
-			break;
 	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
-			break;
+		pit_control_irq(1);
+		break;
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		udelay(10);
+		pit_control_irq(0);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
 		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
diff -puN include/linux/clockchips.h~clockevents-fix-resume-logic-updated-version include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockevents-fix-resume-logic-updated-version
+++ a/include/linux/clockchips.h
@@ -23,6 +23,7 @@ enum clock_event_mode {
 	CLOCK_EVT_MODE_SHUTDOWN,
 	CLOCK_EVT_MODE_PERIODIC,
 	CLOCK_EVT_MODE_ONESHOT,
+	CLOCK_EVT_MODE_RESUME,
 };
 
 /* Clock event notification values */
diff -puN kernel/time/tick-broadcast.c~clockevents-fix-resume-logic-updated-version kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~clockevents-fix-resume-logic-updated-version
+++ a/kernel/time/tick-broadcast.c
@@ -292,7 +292,7 @@ void tick_suspend_broadcast(void)
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	if (bc && tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+	if (bc)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -309,6 +309,8 @@ int tick_resume_broadcast(void)
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc) {
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME);
+
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
 			if(!cpus_empty(tick_broadcast_mask))
diff -puN kernel/time/tick-common.c~clockevents-fix-resume-logic-updated-version kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~clockevents-fix-resume-logic-updated-version
+++ a/kernel/time/tick-common.c
@@ -318,12 +318,17 @@ static void tick_resume(void)
 {
 	struct tick_device *td = &__get_cpu_var(tick_cpu_device);
 	unsigned long flags;
+	int broadcast = tick_resume_broadcast();
 
 	spin_lock_irqsave(&tick_device_lock, flags);
-	if (td->mode == TICKDEV_MODE_PERIODIC)
-		tick_setup_periodic(td->evtdev, 0);
-	else
-		tick_resume_oneshot();
+	clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_RESUME);
+
+	if (!broadcast) {
+		if (td->mode == TICKDEV_MODE_PERIODIC)
+			tick_setup_periodic(td->evtdev, 0);
+		else
+			tick_resume_oneshot();
+	}
 	spin_unlock_irqrestore(&tick_device_lock, flags);
 }
 
@@ -360,8 +365,7 @@ static int tick_notify(struct notifier_b
 		break;
 
 	case CLOCK_EVT_NOTIFY_RESUME:
-		if (!tick_resume_broadcast())
-			tick_resume();
+		tick_resume();
 		break;
 
 	default:
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
h8300-generic-irq.patch
arm-spinlock-initializer-cleanup.patch
git-avr32.patch
drm-spinlock-initializer-cleanup.patch
git-dvb.patch
git-ieee1394.patch
git-mtd.patch
s390-spinlock-initializer-cleanup.patch
optimize-timespec_trunc.patch
kernel-irq-procc-unprotected-iteration-over-the-irq-action-list-in-name_unique.patch
add-support-for-deferrable-timers-respun.patch
irq-check-for-percpu-flag-only-when-adding-first-irqaction.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
replace-deprecated-sa_xxx-interrupt-flags.patch
deprecate-sa_xxx-interrupt-flags-v2.patch
pad-irq_desc-to-internode-cacheline-size.patch
highres-dyntick-prevent-xtime-lock-contention.patch
introduce-a-handy-list_first_entry-macro-v2.patch
the-scheduled-einval-for-invalid-timevals-in-setitimer.patch
clockchipsh-kernel-doc-fix.patch
export-hrtimer_forward.patch
blacklist-dell-optiplex-320-from-using-the-hpet.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
isdn-spinlock-initializer-cleanup.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
declare-struct-ktime.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
clocksource-fix-resume-logic.patch
clockevents-fix-resume-logic-updated-version.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
