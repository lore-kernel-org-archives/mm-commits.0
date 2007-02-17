From: akpm@linux-foundation.org
Subject: - i386-use-gtod-persistent-clock-support.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:39 -0800
Message-ID: <200702170713.l1H7DdZx021469@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946552AbXBQHRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, akpm@linux-foundation.org, bunk@stusta.de, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     i386: use GTOD persistent clock support
has been removed from the -mm tree.  Its filename was
     i386-use-gtod-persistent-clock-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: use GTOD persistent clock support
From: John Stultz <johnstul@us.ibm.com>

Persistent clock support: do proper timekeeping across suspend/resume, i386
arch support.

[bunk@stusta.de: cleanup]
Build-fixes-from: Andrew Morton <akpm@osdl.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c  |   44 ------------------------------
 arch/i386/kernel/time.c |   54 --------------------------------------
 2 files changed, 1 insertion(+), 97 deletions(-)

diff -puN arch/i386/kernel/apm.c~i386-use-gtod-persistent-clock-support arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~i386-use-gtod-persistent-clock-support
+++ a/arch/i386/kernel/apm.c
@@ -236,7 +236,6 @@
 
 #include "io_ports.h"
 
-extern unsigned long get_cmos_time(void);
 extern void machine_real_restart(unsigned char *, int);
 
 #if defined(CONFIG_APM_DISPLAY_BLANK) && defined(CONFIG_VT)
@@ -1176,28 +1175,6 @@ out:
 	spin_unlock(&user_list_lock);
 }
 
-static void set_time(void)
-{
-	struct timespec ts;
-	if (got_clock_diff) {	/* Must know time zone in order to set clock */
-		ts.tv_sec = get_cmos_time() + clock_cmos_diff;
-		ts.tv_nsec = 0;
-		do_settimeofday(&ts);
-	} 
-}
-
-static void get_time_diff(void)
-{
-#ifndef CONFIG_APM_RTC_IS_GMT
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	clock_cmos_diff = -get_cmos_time();
-	clock_cmos_diff += get_seconds();
-	got_clock_diff = 1;
-#endif
-}
-
 static void reinit_timer(void)
 {
 #ifdef INIT_TIMER_AFTER_SUSPEND
@@ -1237,19 +1214,6 @@ static int suspend(int vetoable)
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
 
-	/* serialize with the timer interrupt */
-	write_seqlock(&xtime_lock);
-
-	/* protect against access to timer chip registers */
-	spin_lock(&i8253_lock);
-
-	get_time_diff();
-	/*
-	 * Irq spinlock must be dropped around set_system_power_state.
-	 * We'll undo any timer changes due to interrupts below.
-	 */
-	spin_unlock(&i8253_lock);
-	write_sequnlock(&xtime_lock);
 	local_irq_enable();
 
 	save_processor_state();
@@ -1258,7 +1222,6 @@ static int suspend(int vetoable)
 	restore_processor_state();
 
 	local_irq_disable();
-	set_time();
 	reinit_timer();
 
 	if (err == APM_NO_ERROR)
@@ -1288,11 +1251,6 @@ static void standby(void)
 
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
-	/* serialize with the timer interrupt */
-	write_seqlock(&xtime_lock);
-	/* If needed, notify drivers here */
-	get_time_diff();
-	write_sequnlock(&xtime_lock);
 	local_irq_enable();
 
 	err = set_system_power_state(APM_STATE_STANDBY);
@@ -1386,7 +1344,6 @@ static void check_events(void)
 			ignore_bounce = 1;
 			if ((event != APM_NORMAL_RESUME)
 			    || (ignore_normal_resume == 0)) {
-				set_time();
 				device_resume();
 				pm_send_all(PM_RESUME, (void *)0);
 				queue_event(event, NULL);
@@ -1402,7 +1359,6 @@ static void check_events(void)
 			break;
 
 		case APM_UPDATE_TIME:
-			set_time();
 			break;
 
 		case APM_CRITICAL_SUSPEND:
diff -puN arch/i386/kernel/time.c~i386-use-gtod-persistent-clock-support arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~i386-use-gtod-persistent-clock-support
+++ a/arch/i386/kernel/time.c
@@ -212,7 +212,7 @@ irqreturn_t timer_interrupt(int irq, voi
 }
 
 /* not static: needed by APM */
-unsigned long get_cmos_time(void)
+unsigned long read_persistent_clock(void)
 {
 	unsigned long retval;
 	unsigned long flags;
@@ -225,7 +225,6 @@ unsigned long get_cmos_time(void)
 
 	return retval;
 }
-EXPORT_SYMBOL(get_cmos_time);
 
 static void sync_cmos_clock(unsigned long dummy);
 
@@ -278,58 +277,19 @@ void notify_arch_cmos_timer(void)
 		mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
-static long clock_cmos_diff;
-static unsigned long sleep_start;
-
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	unsigned long ctime =  get_cmos_time();
-
-	clock_cmos_diff = -ctime;
-	clock_cmos_diff += get_seconds();
-	sleep_start = ctime;
-	return 0;
-}
-
 static int timer_resume(struct sys_device *dev)
 {
-	unsigned long flags;
-	unsigned long sec;
-	unsigned long ctime = get_cmos_time();
-	long sleep_length = (ctime - sleep_start) * HZ;
-	struct timespec ts;
-
-	if (sleep_length < 0) {
-		printk(KERN_WARNING "CMOS clock skew detected in timer resume!\n");
-		/* The time after the resume must not be earlier than the time
-		 * before the suspend or some nasty things will happen
-		 */
-		sleep_length = 0;
-		ctime = sleep_start;
-	}
 #ifdef CONFIG_HPET_TIMER
 	if (is_hpet_enabled())
 		hpet_reenable();
 #endif
 	setup_pit_timer();
-
-	sec = ctime + clock_cmos_diff;
-	ts.tv_sec = sec;
-	ts.tv_nsec = 0;
-	do_settimeofday(&ts);
-	write_seqlock_irqsave(&xtime_lock, flags);
-	jiffies_64 += sleep_length;
-	write_sequnlock_irqrestore(&xtime_lock, flags);
 	touch_softlockup_watchdog();
 	return 0;
 }
 
 static struct sysdev_class timer_sysclass = {
 	.resume = timer_resume,
-	.suspend = timer_suspend,
 	set_kset_name("timer"),
 };
 
@@ -355,12 +315,6 @@ extern void (*late_time_init)(void);
 /* Duplicate of time_init() below, with hpet_enable part added */
 static void __init hpet_time_init(void)
 {
-	struct timespec ts;
-	ts.tv_sec = get_cmos_time();
-	ts.tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
-
-	do_settimeofday(&ts);
-
 	if ((hpet_enable() >= 0) && hpet_use_timer) {
 		printk("Using HPET for base-timer\n");
 	}
@@ -371,7 +325,6 @@ static void __init hpet_time_init(void)
 
 void __init time_init(void)
 {
-	struct timespec ts;
 #ifdef CONFIG_HPET_TIMER
 	if (is_hpet_capable()) {
 		/*
@@ -382,10 +335,5 @@ void __init time_init(void)
 		return;
 	}
 #endif
-	ts.tv_sec = get_cmos_time();
-	ts.tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
-
-	do_settimeofday(&ts);
-
 	do_time_init();
 }
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
git-acpi.patch
profile-likely-unlikely-macros-x86_64-fix.patch
