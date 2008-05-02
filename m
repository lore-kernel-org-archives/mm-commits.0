From: akpm@linux-foundation.org
Subject: - ntp-rename-tick_length_shift-to-ntp_scale_shift.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:10 -0700
Message-ID: <200805021942.m42JgAWS011149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176AbYEBTmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: rename TICK_LENGTH_SHIFT to NTP_SCALE_SHIFT
has been removed from the -mm tree.  Its filename was
     ntp-rename-tick_length_shift-to-ntp_scale_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: rename TICK_LENGTH_SHIFT to NTP_SCALE_SHIFT
From: Roman Zippel <zippel@linux-m68k.org>

As TICK_LENGTH_SHIFT is used for more than just the tick length, the name
isn't quite approriate anymore, so this renames it to NTP_SCALE_SHIFT.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/time.c |    2 +-
 include/linux/timex.h      |    8 ++++----
 kernel/time/ntp.c          |   20 ++++++++++----------
 kernel/time/timekeeping.c  |   10 +++++-----
 4 files changed, 20 insertions(+), 20 deletions(-)

diff -puN arch/powerpc/kernel/time.c~ntp-rename-tick_length_shift-to-ntp_scale_shift arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~ntp-rename-tick_length_shift-to-ntp_scale_shift
+++ a/arch/powerpc/kernel/time.c
@@ -149,7 +149,7 @@ EXPORT_SYMBOL(tb_ticks_per_sec);	/* for 
 u64 tb_to_xs;
 unsigned tb_to_us;
 
-#define TICKLEN_SCALE	TICK_LENGTH_SHIFT
+#define TICKLEN_SCALE	NTP_SCALE_SHIFT
 u64 last_tick_len;	/* units are ns / 2^TICKLEN_SCALE */
 u64 ticklen_to_xs;	/* 0.64 fraction */
 
diff -puN include/linux/timex.h~ntp-rename-tick_length_shift-to-ntp_scale_shift include/linux/timex.h
--- a/include/linux/timex.h~ntp-rename-tick_length_shift-to-ntp_scale_shift
+++ a/include/linux/timex.h
@@ -81,14 +81,14 @@
  * offset and maximum frequency tolerance.
  */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
-#define PPM_SCALE (NSEC_PER_USEC << (TICK_LENGTH_SHIFT - SHIFT_USEC))
+#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
 #define PPM_SCALE_INV_SHIFT 20
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + TICK_LENGTH_SHIFT)) / \
+#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
 		       PPM_SCALE + 1)
 
 #define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
-#define MAXFREQ_SCALED ((s64)MAXFREQ << TICK_LENGTH_SHIFT)
+#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
 #define MAXSEC 2048		/* max interval between updates (s) */
 #define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
@@ -230,7 +230,7 @@ static inline int ntp_synced(void)
 	__x < 0 ? -(-__x >> __s) : __x >> __s;	\
 })
 
-#define TICK_LENGTH_SHIFT	32
+#define NTP_SCALE_SHIFT		32
 
 #ifdef CONFIG_NO_HZ
 #define NTP_INTERVAL_FREQ  (2)
diff -puN kernel/time/ntp.c~ntp-rename-tick_length_shift-to-ntp_scale_shift kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-rename-tick_length_shift-to-ntp_scale_shift
+++ a/kernel/time/ntp.c
@@ -27,7 +27,7 @@ static u64 tick_length, tick_length_base
 
 #define MAX_TICKADJ		500		/* microsecs */
 #define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
-				  TICK_LENGTH_SHIFT) / NTP_INTERVAL_FREQ)
+				  NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
 
 /*
  * phase-lock loop variables
@@ -48,13 +48,13 @@ static long ntp_tick_adj;
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
-				<< TICK_LENGTH_SHIFT;
-	second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
+				<< NTP_SCALE_SHIFT;
+	second_length += (s64)ntp_tick_adj << NTP_SCALE_SHIFT;
 	second_length += time_freq;
 
 	tick_length_base = second_length;
 
-	tick_nsec = div_u64(second_length, HZ) >> TICK_LENGTH_SHIFT;
+	tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
 	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
@@ -86,10 +86,10 @@ static void ntp_update_offset(long offse
 	time_reftime = xtime.tv_sec;
 
 	freq_adj = (s64)offset * mtemp;
-	freq_adj <<= TICK_LENGTH_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
+	freq_adj <<= NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
 	time_status &= ~STA_MODE;
 	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-		freq_adj += div_s64((s64)offset << (TICK_LENGTH_SHIFT - SHIFT_FLL),
+		freq_adj += div_s64((s64)offset << (NTP_SCALE_SHIFT - SHIFT_FLL),
 				    mtemp);
 		time_status |= STA_MODE;
 	}
@@ -97,7 +97,7 @@ static void ntp_update_offset(long offse
 	freq_adj = min(freq_adj, MAXFREQ_SCALED);
 	time_freq = max(freq_adj, -MAXFREQ_SCALED);
 
-	time_offset = div_s64((s64)offset << TICK_LENGTH_SHIFT, NTP_INTERVAL_FREQ);
+	time_offset = div_s64((s64)offset << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -197,7 +197,7 @@ void second_overflow(void)
 			tick_length -= MAX_TICKADJ_SCALED;
 		} else {
 			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
-					NTP_INTERVAL_FREQ) << TICK_LENGTH_SHIFT;
+					NTP_INTERVAL_FREQ) << NTP_SCALE_SHIFT;
 			time_adjust = 0;
 		}
 	}
@@ -369,13 +369,13 @@ int do_adjtimex(struct timex *txc)
 		txc->offset = save_adjust;
 	else {
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
-					  TICK_LENGTH_SHIFT);
+					  NTP_SCALE_SHIFT);
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
 	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
 					 (s64)PPM_SCALE_INV,
-					 TICK_LENGTH_SHIFT);
+					 NTP_SCALE_SHIFT);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
diff -puN kernel/time/timekeeping.c~ntp-rename-tick_length_shift-to-ntp_scale_shift kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~ntp-rename-tick_length_shift-to-ntp_scale_shift
+++ a/kernel/time/timekeeping.c
@@ -371,7 +371,7 @@ static __always_inline int clocksource_b
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -381,7 +381,7 @@ static __always_inline int clocksource_b
 	 * remove the single look ahead already included in the error.
 	 */
 	tick_error = current_tick_length() >>
-		(TICK_LENGTH_SHIFT - clock->shift + 1);
+		(NTP_SCALE_SHIFT - clock->shift + 1);
 	tick_error -= clock->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -412,7 +412,7 @@ static void clocksource_adjust(s64 offse
 	s64 error, interval = clock->cycle_interval;
 	int adj;
 
-	error = clock->error >> (TICK_LENGTH_SHIFT - clock->shift - 1);
+	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
@@ -434,7 +434,7 @@ static void clocksource_adjust(s64 offse
 	clock->xtime_interval += interval;
 	clock->xtime_nsec -= offset;
 	clock->error -= (interval - offset) <<
-			(TICK_LENGTH_SHIFT - clock->shift);
+			(NTP_SCALE_SHIFT - clock->shift);
 }
 
 /**
@@ -474,7 +474,7 @@ void update_wall_time(void)
 
 		/* accumulate error between NTP and clock interval */
 		clock->error += current_tick_length();
-		clock->error -= clock->xtime_interval << (TICK_LENGTH_SHIFT - clock->shift);
+		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
 	}
 
 	/* correct the clock when NTP error is too big */
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

