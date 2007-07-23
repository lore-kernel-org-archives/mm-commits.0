From: akpm@linux-foundation.org
Subject: - clockevents-fix-resume-logic.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:00 -0700
Message-ID: <200707230934.l6N9Y03J016340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757398AbXGWJfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, johnstul@us.ibm.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     clockevents: fix resume logic
has been removed from the -mm tree.  Its filename was
     clockevents-fix-resume-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clockevents: fix resume logic
From: Thomas Gleixner <tglx@linutronix.de>

We need to make sure, that the clockevent devices are resumed, before
the tick is resumed. The current resume logic does not guarantee this.

Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
event devices before resuming the tick / oneshot functionality.

Fixup the existing users.

Thanks to Nigel Cunningham for tracking down a long standing thinko,
which affected the jinxed VAIO.

[akpm@linux-foundation.org: xen build fix]
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-davinci/time.c      |    2 
 arch/arm/mach-imx/time.c          |    1 
 arch/arm/mach-ixp4xx/common.c     |    2 
 arch/arm/mach-omap1/time.c        |    1 
 arch/arm/plat-omap/timer32k.c     |    2 
 arch/i386/kernel/apic.c           |    3 +
 arch/i386/kernel/hpet.c           |   71 +---------------------------
 arch/i386/kernel/i8253.c          |   26 ++++------
 arch/i386/kernel/vmiclock.c       |    1 
 arch/i386/xen/time.c              |    3 +
 arch/sh/kernel/timers/timer-tmu.c |    1 
 arch/sparc64/kernel/time.c        |    1 
 drivers/lguest/lguest.c           |    2 
 include/linux/clockchips.h        |    1 
 kernel/time/tick-broadcast.c      |    6 +-
 kernel/time/tick-common.c         |   16 +++---
 16 files changed, 51 insertions(+), 88 deletions(-)

diff -puN arch/arm/mach-davinci/time.c~clockevents-fix-resume-logic arch/arm/mach-davinci/time.c
--- a/arch/arm/mach-davinci/time.c~clockevents-fix-resume-logic
+++ a/arch/arm/mach-davinci/time.c
@@ -285,6 +285,8 @@ static void davinci_set_mode(enum clock_
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		t->opts = TIMER_OPTS_DISABLED;
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
 }
 
diff -puN arch/arm/mach-imx/time.c~clockevents-fix-resume-logic arch/arm/mach-imx/time.c
--- a/arch/arm/mach-imx/time.c~clockevents-fix-resume-logic
+++ a/arch/arm/mach-imx/time.c
@@ -159,6 +159,7 @@ static void imx_set_mode(enum clock_even
 		break;
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_RESUME:
 		/* Left event sources disabled, no more interrupts appears */
 		break;
 	}
diff -puN arch/arm/mach-ixp4xx/common.c~clockevents-fix-resume-logic arch/arm/mach-ixp4xx/common.c
--- a/arch/arm/mach-ixp4xx/common.c~clockevents-fix-resume-logic
+++ a/arch/arm/mach-ixp4xx/common.c
@@ -459,6 +459,8 @@ static void ixp4xx_set_mode(enum clock_e
 	default:
 		osrt = opts = 0;
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
 
 	*IXP4XX_OSRT1 = osrt | opts;
diff -puN arch/arm/mach-omap1/time.c~clockevents-fix-resume-logic arch/arm/mach-omap1/time.c
--- a/arch/arm/mach-omap1/time.c~clockevents-fix-resume-logic
+++ a/arch/arm/mach-omap1/time.c
@@ -156,6 +156,7 @@ static void omap_mpu_set_mode(enum clock
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_RESUME:
 		break;
 	}
 }
diff -puN arch/arm/plat-omap/timer32k.c~clockevents-fix-resume-logic arch/arm/plat-omap/timer32k.c
--- a/arch/arm/plat-omap/timer32k.c~clockevents-fix-resume-logic
+++ a/arch/arm/plat-omap/timer32k.c
@@ -156,6 +156,8 @@ static void omap_32k_timer_set_mode(enum
 	case CLOCK_EVT_MODE_SHUTDOWN:
 		omap_32k_timer_stop();
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
 }
 
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
@@ -41,26 +41,24 @@ static void init_pit_timer(enum clock_ev
 	case CLOCK_EVT_MODE_PERIODIC:
 		/* binary, mode 2, LSB/MSB, ch 0 */
 		outb_p(0x34, PIT_MODE);
-		udelay(10);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		udelay(10);
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
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
+		outb_p(0x30, PIT_MODE);
+		outb_p(0, PIT_CH0);	/* LSB */
+		outb_p(0, PIT_CH0);	/* MSB */
+		break;
+
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		udelay(10);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
 		break;
 	}
 	spin_unlock_irqrestore(&i8253_lock, flags);
diff -puN arch/i386/kernel/vmiclock.c~clockevents-fix-resume-logic arch/i386/kernel/vmiclock.c
--- a/arch/i386/kernel/vmiclock.c~clockevents-fix-resume-logic
+++ a/arch/i386/kernel/vmiclock.c
@@ -142,6 +142,7 @@ static void vmi_timer_set_mode(enum cloc
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		cycles_per_hz = vmi_timer_ops.get_cycle_frequency();
diff -puN arch/i386/xen/time.c~clockevents-fix-resume-logic arch/i386/xen/time.c
--- a/arch/i386/xen/time.c~clockevents-fix-resume-logic
+++ a/arch/i386/xen/time.c
@@ -412,6 +412,7 @@ static void xen_timerop_set_mode(enum cl
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
 		break;
 
 	case CLOCK_EVT_MODE_UNUSED:
@@ -474,6 +475,8 @@ static void xen_vcpuop_set_mode(enum clo
 		    HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL))
 			BUG();
 		break;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
 }
 
diff -puN arch/sh/kernel/timers/timer-tmu.c~clockevents-fix-resume-logic arch/sh/kernel/timers/timer-tmu.c
--- a/arch/sh/kernel/timers/timer-tmu.c~clockevents-fix-resume-logic
+++ a/arch/sh/kernel/timers/timer-tmu.c
@@ -80,6 +80,7 @@ static void tmu_set_mode(enum clock_even
 		break;
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_RESUME:
 		break;
 	}
 }
diff -puN arch/sparc64/kernel/time.c~clockevents-fix-resume-logic arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~clockevents-fix-resume-logic
+++ a/arch/sparc64/kernel/time.c
@@ -931,6 +931,7 @@ static void sparc64_timer_setup(enum clo
 {
 	switch (mode) {
 	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_RESUME:
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
diff -puN drivers/lguest/lguest.c~clockevents-fix-resume-logic drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~clockevents-fix-resume-logic
+++ a/drivers/lguest/lguest.c
@@ -398,6 +398,8 @@ static void lguest_clockevent_set_mode(e
 		break;
 	case CLOCK_EVT_MODE_PERIODIC:
 		BUG();
+	case CLOCK_EVT_MODE_RESUME:
+		break;
 	}
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
@@ -49,7 +49,7 @@ cpumask_t *tick_get_broadcast_mask(void)
  */
 static void tick_broadcast_start_periodic(struct clock_event_device *bc)
 {
-	if (bc && bc->mode == CLOCK_EVT_MODE_SHUTDOWN)
+	if (bc)
 		tick_setup_periodic(bc, 1);
 }
 
@@ -299,7 +299,7 @@ void tick_suspend_broadcast(void)
 	spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	bc = tick_broadcast_device.evtdev;
-	if (bc && tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+	if (bc)
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_SHUTDOWN);
 
 	spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -316,6 +316,8 @@ int tick_resume_broadcast(void)
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

git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
