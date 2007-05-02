From: akpm@linux-foundation.org
Subject: + clockevents-fix-resume-logic.patch added to -mm tree
Date: Tue, 01 May 2007 17:34:06 -0700
Message-ID: <200705020034.l420Y6X4010238@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992536AbXEBAeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2007 20:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     clockevents: fix resume logic
has been added to the -mm tree.  Its filename is
     clockevents-fix-resume-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>

We need to make sure, that the clockevent devices are resumed, before the tick
is resumed.  The current resume logic does not guarantee this.

Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock event
devices before resuming the tick / oneshot functionality.

Fixup the existing users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c      |    3 +
 arch/i386/kernel/hpet.c      |   71 ++-------------------------------
 arch/i386/kernel/i8253.c     |    4 +
 arch/sparc64/kernel/time.c   |    1 
 include/linux/clockchips.h   |    1 
 kernel/time/tick-broadcast.c |    2 
 kernel/time/tick-common.c    |   16 ++++---
 7 files changed, 26 insertions(+), 72 deletions(-)

diff -puN arch/i386/kernel/apic.c~clockevents-fix-resume-logic arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~clockevents-fix-resume-logic
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
diff -puN arch/i386/kernel/hpet.c~clockevents-fix-resume-logic arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~clockevents-fix-resume-logic
+++ a/arch/i386/kernel/hpet.c
@@ -187,6 +187,10 @@ static void hpet_set_mode(enum clock_eve
 		cfg &= ~HPET_TN_ENABLE;
 		hpet_writel(cfg, HPET_T0_CFG);
 		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		hpet_enable_int();
+		break;
 	}
 }
 
@@ -217,6 +221,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.resume		= hpet_start_counter,
 };
 
 /*
@@ -291,7 +296,6 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
-
 	if (id & HPET_ID_LEGSUP) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
@@ -524,68 +528,3 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
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
diff -puN arch/i386/kernel/i8253.c~clockevents-fix-resume-logic arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~clockevents-fix-resume-logic
+++ a/arch/i386/kernel/i8253.c
@@ -62,6 +62,10 @@ static void init_pit_timer(enum clock_ev
 		outb_p(0x38, PIT_MODE);
 		udelay(10);
 		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
 }
diff -puN arch/sparc64/kernel/time.c~clockevents-fix-resume-logic arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~clockevents-fix-resume-logic
+++ a/arch/sparc64/kernel/time.c
@@ -927,6 +927,7 @@ static void sparc64_timer_setup(enum clo
 	case CLOCK_EVT_MODE_PERIODIC:
 	case CLOCK_EVT_MODE_UNUSED:
 		WARN_ON(1);
+	case CLOCK_EVT_MODE_RESUME:
 		break;
 	};
 }
diff -puN include/linux/clockchips.h~clockevents-fix-resume-logic include/linux/clockchips.h
--- a/include/linux/clockchips.h~clockevents-fix-resume-logic
+++ a/include/linux/clockchips.h
@@ -23,6 +23,7 @@ enum clock_event_mode {
 	CLOCK_EVT_MODE_SHUTDOWN,
 	CLOCK_EVT_MODE_PERIODIC,
 	CLOCK_EVT_MODE_ONESHOT,
+	CLOCK_EVT_MODE_RESUME,
 };
 
 /* Clock event notification values */
diff -puN kernel/time/tick-broadcast.c~clockevents-fix-resume-logic kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~clockevents-fix-resume-logic
+++ a/kernel/time/tick-broadcast.c
@@ -309,6 +309,8 @@ int tick_resume_broadcast(void)
 	bc = tick_broadcast_device.evtdev;
 
 	if (bc) {
+		clockevents_set_mode(bc, CLOCK_EVT_MODE_RESUME);
+
 		switch (tick_broadcast_device.mode) {
 		case TICKDEV_MODE_PERIODIC:
 			if(!cpus_empty(tick_broadcast_mask))
diff -puN kernel/time/tick-common.c~clockevents-fix-resume-logic kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~clockevents-fix-resume-logic
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
git-arm.patch
git-avr32.patch
git-ieee1394.patch
git-input.patch
h8300-generic-irq.patch
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
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch
clockevents-fix-resume-logic.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
