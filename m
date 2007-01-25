From: akpm@osdl.org
Subject: - hrtimers-clean-up-callback-tracking.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:12:02 -0800
Message-ID: <200701250612.l0P6C2Yk007751@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49157 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965391AbXAYGMr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:12:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hrtimers: clean up callback tracking
has been removed from the -mm tree.  Its filename was
     hrtimers-clean-up-callback-tracking.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: hrtimers: clean up callback tracking
From: Thomas Gleixner <tglx@linutronix.de>

Reintroduce ktimers feature "optimized away" by the ktimers review
process: remove the curr_timer pointer from the cpu-base and use the
hrtimer state.

No functional changes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |    1 -
 kernel/hrtimer.c        |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN include/linux/hrtimer.h~hrtimers-clean-up-callback-tracking include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~hrtimers-clean-up-callback-tracking
+++ a/include/linux/hrtimer.h
@@ -136,7 +136,6 @@ struct hrtimer_cpu_base {
 	spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
-	struct hrtimer			*curr_timer;
 };
 
 /*
diff -puN kernel/hrtimer.c~hrtimers-clean-up-callback-tracking kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimers-clean-up-callback-tracking
+++ a/kernel/hrtimer.c
@@ -167,8 +167,6 @@ static inline int hrtimer_callback_runni
  */
 #ifdef CONFIG_SMP
 
-#define set_curr_timer(b, t)		do { (b)->curr_timer = (t); } while (0)
-
 /*
  * We are using hashed locking: holding per_cpu(hrtimer_bases)[n].lock
  * means that all timers which are tied to this base via timer->base are
@@ -222,7 +220,7 @@ switch_hrtimer_base(struct hrtimer *time
 		 * completed. There is no conflict as we hold the lock until
 		 * the timer is enqueued.
 		 */
-		if (unlikely(base->cpu_base->curr_timer == timer))
+		if (unlikely(timer->state & HRTIMER_STATE_CALLBACK))
 			return base;
 
 		/* See the comment in lock_timer_base() */
@@ -236,8 +234,6 @@ switch_hrtimer_base(struct hrtimer *time
 
 #else /* CONFIG_SMP */
 
-#define set_curr_timer(b, t)		do { } while (0)
-
 static inline struct hrtimer_clock_base *
 lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
@@ -665,7 +661,6 @@ static inline void run_hrtimer_queue(str
 			break;
 
 		fn = timer->function;
-		set_curr_timer(cpu_base, timer);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
 		spin_unlock_irq(&cpu_base->lock);
 
@@ -679,7 +674,6 @@ static inline void run_hrtimer_queue(str
 			enqueue_hrtimer(timer, base);
 		}
 	}
-	set_curr_timer(cpu_base, NULL);
 	spin_unlock_irq(&cpu_base->lock);
 }
 
@@ -866,8 +860,6 @@ static void migrate_hrtimers(int cpu)
 	spin_lock(&old_base->lock);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		BUG_ON(old_base->curr_timer);
-
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
 	}
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
