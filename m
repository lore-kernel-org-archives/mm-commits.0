From: akpm@linux-foundation.org
Subject: - hz-free-ntp.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:13:26 -0800
Message-ID: <200702170713.l1H7DQv5021454@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51185 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946520AbXBQHQ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     HZ free ntp
has been removed from the -mm tree.  Its filename was
     hz-free-ntp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: HZ free ntp
From: john stultz <johnstul@us.ibm.com>

Distangle the NTP update from HZ.  This is necessary for dynamic tick enabled
kernels.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
git-acpi.patch
profile-likely-unlikely-macros-x86_64-fix.patch
