From: akpm@linux-foundation.org
Subject: - x86_64-use-generic-cmos-update.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:43 -0700
Message-ID: <200707192010.l6JKAhbh020698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761284AbXGSUVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, chrisw@sous-sol.org, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64: use generic cmos update
has been removed from the -mm tree.  Its filename was
     x86_64-use-generic-cmos-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: use generic cmos update
From: Thomas Gleixner <tglx@linutronix.de>

Use the generic cmos update function in kernel/time/ntp.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig       |    4 ++++
 arch/x86_64/kernel/time.c |   25 +++++++++----------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff -puN arch/x86_64/Kconfig~x86_64-use-generic-cmos-update arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-use-generic-cmos-update
+++ a/arch/x86_64/Kconfig
@@ -32,6 +32,10 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
 config ZONE_DMA32
 	bool
 	default y
diff -puN arch/x86_64/kernel/time.c~x86_64-use-generic-cmos-update arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~x86_64-use-generic-cmos-update
+++ a/arch/x86_64/kernel/time.c
@@ -82,8 +82,9 @@ EXPORT_SYMBOL(profile_pc);
  * sheet for details.
  */
 
-static void set_rtc_mmss(unsigned long nowtime)
+static int set_rtc_mmss(unsigned long nowtime)
 {
+	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
 
@@ -123,6 +124,7 @@ static void set_rtc_mmss(unsigned long n
 	if (abs(real_minutes - cmos_minutes) >= 30) {
 		printk(KERN_WARNING "time.c: can't update CMOS clock "
 		       "from %d to %d\n", cmos_minutes, real_minutes);
+		retval = -1;
 	} else {
 		BIN_TO_BCD(real_seconds);
 		BIN_TO_BCD(real_minutes);
@@ -142,12 +144,17 @@ static void set_rtc_mmss(unsigned long n
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
 	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
+int update_persistent_clock(struct timespec now)
+{
+	return set_rtc_mmss(now.tv_sec);
+}
 
 void main_timer_handler(void)
 {
-	static unsigned long rtc_update = 0;
 /*
  * Here we are in the timer irq handler. We have irqs locally disabled (so we
  * don't need spin_lock_irqsave()) but we don't know if the timer_bh is running
@@ -175,20 +182,6 @@ void main_timer_handler(void)
 	if (!using_apic_timer)
 		smp_local_timer_interrupt();
 
-/*
- * If we have an externally synchronized Linux clock, then update CMOS clock
- * accordingly every ~11 minutes. set_rtc_mmss() will be called in the jiffy
- * closest to exactly 500 ms before the next second. If the update fails, we
- * don't care, as it'll be updated on the next turn, and the problem (time way
- * off) isn't likely to go away much sooner anyway.
- */
-
-	if (ntp_synced() && xtime.tv_sec > rtc_update &&
-		abs(xtime.tv_nsec - 500000000) <= tick_nsec / 2) {
-		set_rtc_mmss(xtime.tv_sec);
-		rtc_update = xtime.tv_sec + 660;
-	}
- 
 	write_sequnlock(&xtime_lock);
 }
 
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
