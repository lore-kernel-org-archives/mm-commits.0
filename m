From: akpm@linux-foundation.org
Subject: - ntp-increase-time_offset-resolution.patch removed from -mm tree
Date: Fri, 02 May 2008 12:42:06 -0700
Message-ID: <200805021942.m42Jg6K5011143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932248AbYEBTnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ntp: increase time_offset resolution
has been removed from the -mm tree.  Its filename was
     ntp-increase-time_offset-resolution.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: increase time_offset resolution
From: Roman Zippel <zippel@linux-m68k.org>

time_offset is already a 64bit value but its resolution barely used, so this
makes better use of it by replacing SHIFT_UPDATE with TICK_LENGTH_SHIFT.

Side note: the SHIFT_HZ in SHIFT_UPDATE was incorrect for CONFIG_NO_HZ and the
primary reason for changing time_offset to 64bit to avoid the overflow.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    9 ++-------
 kernel/time/ntp.c     |   23 +++++++++++------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff -puN include/linux/timex.h~ntp-increase-time_offset-resolution include/linux/timex.h
--- a/include/linux/timex.h~ntp-increase-time_offset-resolution
+++ a/include/linux/timex.h
@@ -76,27 +76,22 @@
 #define MAXTC		10	/* maximum time constant (shift) */
 
 /*
- * The SHIFT_UPDATE define establishes the decimal point of the
- * time_offset variable which represents the current offset with
- * respect to standard time.
- *
  * SHIFT_USEC defines the scaling (shift) of the time_freq and
  * time_tolerance variables, which represent the current frequency
  * offset and maximum frequency tolerance.
  */
-#define SHIFT_UPDATE (SHIFT_HZ + 1) /* time offset scale (shift) */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
 #define PPM_SCALE (NSEC_PER_USEC << (TICK_LENGTH_SHIFT - SHIFT_USEC))
 #define PPM_SCALE_INV_SHIFT 20
 #define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + TICK_LENGTH_SHIFT)) / \
 		       PPM_SCALE + 1)
 
-#define MAXPHASE 512000L        /* max phase error (us) */
+#define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
 #define MAXFREQ_SCALED ((s64)MAXFREQ << TICK_LENGTH_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
 #define MAXSEC 2048		/* max interval between updates (s) */
-#define	NTP_PHASE_LIMIT	(MAXPHASE << 5)	/* beyond max. dispersion */
+#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
 
 /*
  * syscall interface - used (mainly by NTP daemon)
diff -puN kernel/time/ntp.c~ntp-increase-time_offset-resolution kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-increase-time_offset-resolution
+++ a/kernel/time/ntp.c
@@ -65,16 +65,15 @@ static void ntp_update_offset(long offse
 	if (!(time_status & STA_PLL))
 		return;
 
-	time_offset = offset;
 	if (!(time_status & STA_NANO))
-		time_offset *= NSEC_PER_USEC;
+		offset *= NSEC_PER_USEC;
 
 	/*
 	 * Scale the phase adjustment and
 	 * clamp to the operating range.
 	 */
-	time_offset = min(time_offset, (s64)MAXPHASE * NSEC_PER_USEC);
-	time_offset = max(time_offset, (s64)-MAXPHASE * NSEC_PER_USEC);
+	offset = min(offset, MAXPHASE);
+	offset = max(offset, -MAXPHASE);
 
 	/*
 	 * Select how the frequency is to be controlled
@@ -85,19 +84,19 @@ static void ntp_update_offset(long offse
 	mtemp = xtime.tv_sec - time_reftime;
 	time_reftime = xtime.tv_sec;
 
-	freq_adj = time_offset * mtemp;
+	freq_adj = (s64)offset * mtemp;
 	freq_adj <<= TICK_LENGTH_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
 	time_status &= ~STA_MODE;
 	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-		freq_adj += div_s64(time_offset << (TICK_LENGTH_SHIFT - SHIFT_FLL),
+		freq_adj += div_s64((s64)offset << (TICK_LENGTH_SHIFT - SHIFT_FLL),
 				    mtemp);
 		time_status |= STA_MODE;
 	}
 	freq_adj += time_freq;
 	freq_adj = min(freq_adj, MAXFREQ_SCALED);
 	time_freq = max(freq_adj, -MAXFREQ_SCALED);
-	time_offset = div_s64(time_offset, NTP_INTERVAL_FREQ);
-	time_offset <<= SHIFT_UPDATE;
+
+	time_offset = div_s64((s64)offset << TICK_LENGTH_SHIFT, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -128,7 +127,7 @@ void ntp_clear(void)
  */
 void second_overflow(void)
 {
-	long time_adj;
+	s64 time_adj;
 
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
@@ -184,7 +183,7 @@ void second_overflow(void)
 	tick_length = tick_length_base;
 	time_adj = shift_right(time_offset, SHIFT_PLL + time_constant);
 	time_offset -= time_adj;
-	tick_length += (s64)time_adj << (TICK_LENGTH_SHIFT - SHIFT_UPDATE);
+	tick_length += time_adj;
 
 	if (unlikely(time_adjust)) {
 		if (time_adjust > MAX_TICKADJ) {
@@ -363,8 +362,8 @@ int do_adjtimex(struct timex *txc)
 	    (txc->modes == ADJ_OFFSET_SS_READ))
 		txc->offset = save_adjust;
 	else {
-		txc->offset = ((long)shift_right(time_offset, SHIFT_UPDATE)) *
-	    			NTP_INTERVAL_FREQ;
+		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
+					  TICK_LENGTH_SHIFT);
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

origin.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch
git-dvb.patch
git-watchdog.patch

