From: akpm@linux-foundation.org
Subject: - acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch removed from -mm tree
Date: Sun, 06 May 2007 23:44:43 -0700
Message-ID: <200705070644.l476ihQD020232@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbXEGGqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, lenb@kernel.org, mingo@elte.hu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: keep TSC stable, when lapic_timer_c2_ok is set
has been removed from the -mm tree.  Its filename was
     acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch

This patch was dropped because I'm not acpi maintainer

------------------------------------------------------
Subject: ACPI: keep TSC stable, when lapic_timer_c2_ok is set
From: Thomas Gleixner <tglx@linutronix.de>

The local apic timer stop in C2 resp.  C3 states is coupled with the stop of
the TSC.  When the local apic timer is marked stable in C2 on the kernel
commandline, then keep the TSC marked stable in C2 as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set
+++ a/drivers/acpi/processor_idle.c
@@ -225,18 +225,23 @@ static void acpi_state_timer_broadcast(s
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-
 	int state = cx - pr->power.states;
 
 	if (state >= pr->power.timer_broadcast_on_state) {
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
 		unsigned long reason;
 
 		reason = broadcast ?  CLOCK_EVT_NOTIFY_BROADCAST_ENTER :
 			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
 		clockevents_notify(reason, &pr->id);
-	}
 #endif
+
+#ifdef CONFIG_GENERIC_TIME
+		/* TSC halts in C2/3, so notify users */
+		mark_tsc_unstable();
+#endif
+	}
 }
 
 #else
@@ -925,11 +930,6 @@ static int acpi_idle_enter_c2(struct cpu
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#ifdef CONFIG_GENERIC_TIME
-	/* TSC halts in C2, so notify users */
-		mark_tsc_unstable("possible TSC halt in C2");
-#endif
-
 	local_irq_enable();
 	current_thread_info()->status |= TS_POLLING;
 
@@ -1009,11 +1009,6 @@ static int acpi_idle_enter_c3(struct cpu
 		spin_unlock(&c3_lock);
 	}
 
-#ifdef CONFIG_GENERIC_TIME
-	/* TSC halts in C3, so notify users */
-		mark_tsc_unstable("TSC halts in C3");
-#endif
-
 	local_irq_enable();
 	current_thread_info()->status |= TS_POLLING;
 
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
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set.patch
acpi-keep-tsc-stable-when-lapic_timer_c2_ok-is-set-vs-x86_64-mm-log-reason-why-tsc-was-marked-unstable.patch
timer_stats-slimmed-down-using-statistics-infrastucture.patch
