From: akpm@linux-foundation.org
Subject: - i386-hpet-check-if-the-counter-works.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:29 -0700
Message-ID: <200707192010.l6JKATjl020677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761663AbXGSURJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     i386: HPET, check if the counter works
has been removed from the -mm tree.  Its filename was
     i386-hpet-check-if-the-counter-works.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: HPET, check if the counter works
From: Thomas Gleixner <tglx@linutronix.de>

Some systems have a HPET which is not incrementing, which leads to a
complete hang.  Detect it during HPET setup.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/hpet.c~i386-hpet-check-if-the-counter-works arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~i386-hpet-check-if-the-counter-works
+++ a/arch/i386/kernel/hpet.c
@@ -226,7 +226,8 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 	uint64_t hpet_freq;
-	u64 tmp;
+	u64 tmp, start, now;
+	cycle_t t1;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -273,6 +274,27 @@ int __init hpet_enable(void)
 	/* Start the counter */
 	hpet_start_counter();
 
+	/* Verify whether hpet counter works */
+	t1 = read_hpet();
+	rdtscll(start);
+
+	/*
+	 * We don't know the TSC frequency yet, but waiting for
+	 * 200000 TSC cycles is safe:
+	 * 4 GHz == 50us
+	 * 1 GHz == 200us
+	 */
+	do {
+		rep_nop();
+		rdtscll(now);
+	} while ((now - start) < 200000UL);
+
+	if (t1 == read_hpet()) {
+		printk(KERN_WARNING
+		       "HPET counter not counting. HPET disabled\n");
+		goto out_nohpet;
+	}
+
 	/* Initialize and register HPET clocksource
 	 *
 	 * hpet period is in femto seconds per cycle
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
