From: akpm@osdl.org
Subject: + hz-free-ntp.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:35:41 -0800
Message-ID: <200701250635.l0P6Zftn008262@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965628AbXAYGkB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:40:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     HZ free ntp
has been added to the -mm tree.  Its filename is
     hz-free-ntp.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: HZ free ntp
From: john stultz <johnstul@us.ibm.com>

Distangle the NTP update from HZ.  This is necessary for dynamic tick enabled
kernels.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/timex.h |    7 +++++++
 kernel/hrtimer.c      |   11 ++++++++---
 kernel/time/ntp.c     |   30 +++++++++++++++++++-----------
 kernel/timer.c        |    4 ++--
 4 files changed, 36 insertions(+), 16 deletions(-)

diff -puN include/linux/timex.h~hz-free-ntp include/linux/timex.h
--- a/include/linux/timex.h~hz-free-ntp
+++ a/include/linux/timex.h
@@ -286,6 +286,13 @@ static inline void time_interpolator_upd
 
 #define TICK_LENGTH_SHIFT	32
 
+#ifdef CONFIG_NO_HZ
+#define NTP_INTERVAL_FREQ  (2)
+#else
+#define NTP_INTERVAL_FREQ  (HZ)
+#endif
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
+
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
 
diff -puN kernel/hrtimer.c~hz-free-ntp kernel/hrtimer.c
--- a/kernel/hrtimer.c~hz-free-ntp
+++ a/kernel/hrtimer.c
@@ -128,15 +128,20 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
 static void hrtimer_get_softirq_time(struct hrtimer_base *base)
 {
 	ktime_t xtim, tomono;
+	struct timespec xts;
 	unsigned long seq;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		xtim = timespec_to_ktime(xtime);
-		tomono = timespec_to_ktime(wall_to_monotonic);
-
+#ifdef CONFIG_NO_HZ
+		getnstimeofday(&xts);
+#else
+		xts = xtime;
+#endif
 	} while (read_seqretry(&xtime_lock, seq));
 
+	xtim = timespec_to_ktime(xts);
+	tomono = timespec_to_ktime(wall_to_monotonic);
 	base[CLOCK_REALTIME].softirq_time = xtim;
 	base[CLOCK_MONOTONIC].softirq_time = ktime_add(xtim, tomono);
 }
diff -puN kernel/time/ntp.c~hz-free-ntp kernel/time/ntp.c
--- a/kernel/time/ntp.c~hz-free-ntp
+++ a/kernel/time/ntp.c
@@ -24,7 +24,7 @@ static u64 tick_length, tick_length_base
 
 #define MAX_TICKADJ		500		/* microsecs */
 #define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
-				  TICK_LENGTH_SHIFT) / HZ)
+				  TICK_LENGTH_SHIFT) / NTP_INTERVAL_FREQ)
 
 /*
  * phase-lock loop variables
@@ -46,13 +46,17 @@ long time_adjust;
 
 static void ntp_update_frequency(void)
 {
-	tick_length_base = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ) << TICK_LENGTH_SHIFT;
-	tick_length_base += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
-	tick_length_base += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
+	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
+				<< TICK_LENGTH_SHIFT;
+	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
+	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
 
-	do_div(tick_length_base, HZ);
+	tick_length_base = second_length;
 
-	tick_nsec = tick_length_base >> TICK_LENGTH_SHIFT;
+	do_div(second_length, HZ);
+	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
+
+	do_div(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -162,7 +166,7 @@ void second_overflow(void)
 			tick_length -= MAX_TICKADJ_SCALED;
 		} else {
 			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
-					     HZ) << TICK_LENGTH_SHIFT;
+					NTP_INTERVAL_FREQ) << TICK_LENGTH_SHIFT;
 			time_adjust = 0;
 		}
 	}
@@ -239,7 +243,8 @@ int do_adjtimex(struct timex *txc)
 		    result = -EINVAL;
 		    goto leave;
 		}
-		time_freq = ((s64)txc->freq * NSEC_PER_USEC) >> (SHIFT_USEC - SHIFT_NSEC);
+		time_freq = ((s64)txc->freq * NSEC_PER_USEC)
+				>> (SHIFT_USEC - SHIFT_NSEC);
 	    }
 
 	    if (txc->modes & ADJ_MAXERROR) {
@@ -309,7 +314,8 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = (time_offset / HZ) << SHIFT_UPDATE;
+		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
+		    			<< SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
 	    if (txc->modes & ADJ_TICK)
@@ -324,8 +330,10 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT)
 	    txc->offset	   = save_adjust;
 	else
-	    txc->offset    = shift_right(time_offset, SHIFT_UPDATE) * HZ / 1000;
-	txc->freq	   = (time_freq / NSEC_PER_USEC) << (SHIFT_USEC - SHIFT_NSEC);
+	    txc->offset    = shift_right(time_offset, SHIFT_UPDATE)
+	    			* NTP_INTERVAL_FREQ / 1000;
+	txc->freq	   = (time_freq / NSEC_PER_USEC)
+				<< (SHIFT_USEC - SHIFT_NSEC);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
diff -puN kernel/timer.c~hz-free-ntp kernel/timer.c
--- a/kernel/timer.c~hz-free-ntp
+++ a/kernel/timer.c
@@ -890,7 +890,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock, tick_nsec);
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -1092,7 +1092,7 @@ static void update_wall_time(void)
 	if (change_clocksource()) {
 		clock->error = 0;
 		clock->xtime_nsec = 0;
-		clocksource_calculate_interval(clock, tick_nsec);
+		clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	}
 }
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
i386-enable-dynticks-in-kconfig.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
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
profile-likely-unlikely-macros-x86_64-fix.patch
