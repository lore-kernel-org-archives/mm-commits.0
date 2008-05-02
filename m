From: akpm@linux-foundation.org
Subject: - ntp-ntp4-user-space-bits-update.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:02 -0700
Message-ID: <200805021942.m42Jg2Dv011137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932220AbYEBTm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: NTP4 user space bits update
has been removed from the -mm tree.  Its filename was
     ntp-ntp4-user-space-bits-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: NTP4 user space bits update
From: Roman Zippel <zippel@linux-m68k.org>

This adds a few more things from the ntp nanokernel related to user space. 
It's now possible to select the resolution used of some values via STA_NANO
and the kernel reports in which mode it works (pll/fll).

If some values for adjtimex() are outside the acceptable range, they are now
simply normalized instead of letting the syscall fail.  I removed
MOD_CLKA/MOD_CLKB as the mapping didn't really makes any sense, the kernel
doesn't support setting the clock.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |   12 +++--
 kernel/time/ntp.c     |   91 ++++++++++++++++++++--------------------
 2 files changed, 56 insertions(+), 47 deletions(-)

diff -puN include/linux/timex.h~ntp-ntp4-user-space-bits-update include/linux/timex.h
--- a/include/linux/timex.h~ntp-ntp4-user-space-bits-update
+++ a/include/linux/timex.h
@@ -58,6 +58,8 @@
 
 #include <asm/param.h>
 
+#define NTP_API		4	/* NTP API version */
+
 /*
  * SHIFT_KG and SHIFT_KF establish the damping of the PLL and are chosen
  * for a slightly underdamped convergence characteristic. SHIFT_KH
@@ -135,6 +137,8 @@ struct timex {
 #define ADJ_ESTERROR		0x0008	/* estimated time error */
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
+#define ADJ_MICRO		0x1000	/* select microsecond resolution */
+#define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
 #define ADJ_OFFSET_SINGLESHOT	0x8001	/* old-fashioned adjtime */
 #define ADJ_OFFSET_SS_READ	0xa001  /* read-only adjtime */
@@ -146,8 +150,6 @@ struct timex {
 #define MOD_ESTERROR	ADJ_ESTERROR
 #define MOD_STATUS	ADJ_STATUS
 #define MOD_TIMECONST	ADJ_TIMECONST
-#define MOD_CLKB	ADJ_TICK
-#define MOD_CLKA	ADJ_OFFSET_SINGLESHOT /* 0x8000 in original */
 
 
 /*
@@ -169,9 +171,13 @@ struct timex {
 #define STA_PPSERROR	0x0800	/* PPS signal calibration error (ro) */
 
 #define STA_CLOCKERR	0x1000	/* clock hardware fault (ro) */
+#define STA_NANO	0x2000	/* resolution (0 = us, 1 = ns) (ro) */
+#define STA_MODE	0x4000	/* mode (0 = PLL, 1 = FLL) (ro) */
+#define STA_CLK		0x8000	/* clock source (0 = A, 1 = B) (ro) */
 
+/* read-only bits */
 #define STA_RONLY (STA_PPSSIGNAL | STA_PPSJITTER | STA_PPSWANDER | \
-    STA_PPSERROR | STA_CLOCKERR) /* read-only bits */
+	STA_PPSERROR | STA_CLOCKERR | STA_NANO | STA_MODE | STA_CLK)
 
 /*
  * Clock states (time_state)
diff -puN kernel/time/ntp.c~ntp-ntp4-user-space-bits-update kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-ntp4-user-space-bits-update
+++ a/kernel/time/ntp.c
@@ -65,7 +65,9 @@ static void ntp_update_offset(long offse
 	if (!(time_status & STA_PLL))
 		return;
 
-	time_offset = offset * NSEC_PER_USEC;
+	time_offset = offset;
+	if (!(time_status & STA_NANO))
+		time_offset *= NSEC_PER_USEC;
 
 	/*
 	 * Scale the phase adjustment and
@@ -86,8 +88,11 @@ static void ntp_update_offset(long offse
 	freq_adj = time_offset * mtemp;
 	freq_adj = shift_right(freq_adj, time_constant * 2 +
 			   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
-	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC))
+	time_status &= ~STA_MODE;
+	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
 		freq_adj += div_s64(time_offset << (SHIFT_NSEC - SHIFT_FLL), mtemp);
+		time_status |= STA_MODE;
+	}
 	freq_adj += time_freq;
 	freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 	time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
@@ -272,6 +277,7 @@ static inline void notify_cmos_timer(voi
  */
 int do_adjtimex(struct timex *txc)
 {
+	struct timespec ts;
 	long save_adjust;
 	int result;
 
@@ -282,17 +288,11 @@ int do_adjtimex(struct timex *txc)
 	/* Now we validate the data before disabling interrupts */
 
 	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT) {
-	  /* singleshot must not be used with any other mode bits */
-		if (txc->modes != ADJ_OFFSET_SINGLESHOT &&
-					txc->modes != ADJ_OFFSET_SS_READ)
+		/* singleshot must not be used with any other mode bits */
+		if (txc->modes & ~ADJ_OFFSET_SS_READ)
 			return -EINVAL;
 	}
 
-	if (txc->modes != ADJ_OFFSET_SINGLESHOT && (txc->modes & ADJ_OFFSET))
-	  /* adjustment Offset limited to +- .512 seconds */
-		if (txc->offset <= - MAXPHASE || txc->offset >= MAXPHASE )
-			return -EINVAL;
-
 	/* if the quartz is off by more than 10% something is VERY wrong ! */
 	if (txc->modes & ADJ_TICK)
 		if (txc->tick <  900000/USER_HZ ||
@@ -300,51 +300,46 @@ int do_adjtimex(struct timex *txc)
 			return -EINVAL;
 
 	write_seqlock_irq(&xtime_lock);
-	result = time_state;	/* mostly `TIME_OK' */
 
 	/* Save for later - semantics of adjtime is to return old value */
 	save_adjust = time_adjust;
 
-#if 0	/* STA_CLOCKERR is never set yet */
-	time_status &= ~STA_CLOCKERR;		/* reset STA_CLOCKERR */
-#endif
 	/* If there are input parameters, then process them */
 	if (txc->modes) {
-		if (txc->modes & ADJ_STATUS)	/* only set allowed bits */
-			time_status = (txc->status & ~STA_RONLY) |
-				      (time_status & STA_RONLY);
+		if (txc->modes & ADJ_STATUS) {
+			if ((time_status & STA_PLL) &&
+			    !(txc->status & STA_PLL)) {
+				time_state = TIME_OK;
+				time_status = STA_UNSYNC;
+			}
+			/* only set allowed bits */
+			time_status &= STA_RONLY;
+			time_status |= txc->status & ~STA_RONLY;
+		}
+
+		if (txc->modes & ADJ_NANO)
+			time_status |= STA_NANO;
+		if (txc->modes & ADJ_MICRO)
+			time_status &= ~STA_NANO;
 
 		if (txc->modes & ADJ_FREQUENCY) {
-			if (txc->freq > MAXFREQ || txc->freq < -MAXFREQ) {
-				result = -EINVAL;
-				goto leave;
-			}
-			time_freq = ((s64)txc->freq * NSEC_PER_USEC)
+			time_freq = min(txc->freq, MAXFREQ);
+			time_freq = min(time_freq, -MAXFREQ);
+			time_freq = ((s64)time_freq * NSEC_PER_USEC)
 					>> (SHIFT_USEC - SHIFT_NSEC);
 		}
 
-		if (txc->modes & ADJ_MAXERROR) {
-			if (txc->maxerror < 0 || txc->maxerror >= NTP_PHASE_LIMIT) {
-				result = -EINVAL;
-				goto leave;
-			}
+		if (txc->modes & ADJ_MAXERROR)
 			time_maxerror = txc->maxerror;
-		}
-
-		if (txc->modes & ADJ_ESTERROR) {
-			if (txc->esterror < 0 || txc->esterror >= NTP_PHASE_LIMIT) {
-				result = -EINVAL;
-				goto leave;
-			}
+		if (txc->modes & ADJ_ESTERROR)
 			time_esterror = txc->esterror;
-		}
 
 		if (txc->modes & ADJ_TIMECONST) {
-			if (txc->constant < 0) {	/* NTP v4 uses values > 6 */
-				result = -EINVAL;
-				goto leave;
-			}
-			time_constant = min(txc->constant + 4, (long)MAXTC);
+			time_constant = txc->constant;
+			if (!(time_status & STA_NANO))
+				time_constant += 4;
+			time_constant = min(time_constant, (long)MAXTC);
+			time_constant = max(time_constant, 0l);
 		}
 
 		if (txc->modes & ADJ_OFFSET) {
@@ -360,16 +355,20 @@ int do_adjtimex(struct timex *txc)
 		if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
 			ntp_update_frequency();
 	}
-leave:
+
+	result = time_state;	/* mostly `TIME_OK' */
 	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
 		result = TIME_ERROR;
 
 	if ((txc->modes == ADJ_OFFSET_SINGLESHOT) ||
 	    (txc->modes == ADJ_OFFSET_SS_READ))
 		txc->offset = save_adjust;
-	else
+	else {
 		txc->offset = ((long)shift_right(time_offset, SHIFT_UPDATE)) *
-	    			NTP_INTERVAL_FREQ / 1000;
+	    			NTP_INTERVAL_FREQ;
+		if (!(time_status & STA_NANO))
+			txc->offset /= NSEC_PER_USEC;
+	}
 	txc->freq	   = (time_freq / NSEC_PER_USEC) <<
 				(SHIFT_USEC - SHIFT_NSEC);
 	txc->maxerror	   = time_maxerror;
@@ -391,7 +390,11 @@ leave:
 	txc->stbcnt	   = 0;
 	write_sequnlock_irq(&xtime_lock);
 
-	do_gettimeofday(&txc->time);
+	getnstimeofday(&ts);
+	txc->time.tv_sec = ts.tv_sec;
+	txc->time.tv_usec = ts.tv_nsec;
+	if (!(time_status & STA_NANO))
+		txc->time.tv_usec /= NSEC_PER_USEC;
 
 	notify_cmos_timer();
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

