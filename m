From: akpm@linux-foundation.org
Subject: - ntp-avoid-time_offset-overflows.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:14 -0700
Message-ID: <200703290742.l2T7gEV2030288@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXC2Hmr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ntp: avoid time_offset overflows
has been removed from the -mm tree.  Its filename was
     ntp-avoid-time_offset-overflows.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ntp: avoid time_offset overflows
From: john stultz <johnstul@us.ibm.com>

I've been seeing some odd NTP behavior recently on a few boxes and
finally narrowed it down to time_offset overflowing when converted to
SHIFT_UPDATE units (which was a side effect from my HZfreeNTP patch).

This patch converts time_offset from a long to a s64 which resolves the
issue.

[tglx@linutronix.de: signedness fixes]
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff -puN kernel/time/ntp.c~ntp-avoid-time_offset-overflows kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-avoid-time_offset-overflows
+++ a/kernel/time/ntp.c
@@ -32,7 +32,7 @@ static u64 tick_length, tick_length_base
 /* TIME_ERROR prevents overwriting the CMOS clock */
 static int time_state = TIME_OK;	/* clock synchronization status	*/
 int time_status = STA_UNSYNC;		/* clock status bits		*/
-static long time_offset;		/* time adjustment (ns)		*/
+static s64 time_offset;		/* time adjustment (ns)		*/
 static long time_constant = 2;		/* pll time constant		*/
 long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
 long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
@@ -196,7 +196,7 @@ void __attribute__ ((weak)) notify_arch_
  */
 int do_adjtimex(struct timex *txc)
 {
-	long ltemp, mtemp, save_adjust;
+	long mtemp, save_adjust, rem;
 	s64 freq_adj, temp64;
 	int result;
 
@@ -277,14 +277,14 @@ int do_adjtimex(struct timex *txc)
 		    time_adjust = txc->offset;
 		}
 		else if (time_status & STA_PLL) {
-		    ltemp = txc->offset * NSEC_PER_USEC;
+		    time_offset = txc->offset * NSEC_PER_USEC;
 
 		    /*
 		     * Scale the phase adjustment and
 		     * clamp to the operating range.
 		     */
-		    time_offset = min(ltemp, MAXPHASE * NSEC_PER_USEC);
-		    time_offset = max(time_offset, -MAXPHASE * NSEC_PER_USEC);
+		    time_offset = min(time_offset, (s64)MAXPHASE * NSEC_PER_USEC);
+		    time_offset = max(time_offset, (s64)-MAXPHASE * NSEC_PER_USEC);
 
 		    /*
 		     * Select whether the frequency is to be controlled
@@ -297,11 +297,11 @@ int do_adjtimex(struct timex *txc)
 		    mtemp = xtime.tv_sec - time_reftime;
 		    time_reftime = xtime.tv_sec;
 
-		    freq_adj = (s64)time_offset * mtemp;
+		    freq_adj = time_offset * mtemp;
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
 		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-			temp64 = (s64)time_offset << (SHIFT_NSEC - SHIFT_FLL);
+			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
 			if (time_offset < 0) {
 			    temp64 = -temp64;
 			    do_div(temp64, mtemp);
@@ -314,8 +314,10 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
-		    			<< SHIFT_UPDATE;
+		    time_offset = div_long_long_rem_signed(time_offset,
+							   NTP_INTERVAL_FREQ,
+							   &rem);
+		    time_offset <<= SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
 	    if (txc->modes & ADJ_TICK)
@@ -328,12 +330,12 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 		result = TIME_ERROR;
 
 	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT)
-	    txc->offset	   = save_adjust;
+		txc->offset = save_adjust;
 	else
-	    txc->offset    = shift_right(time_offset, SHIFT_UPDATE)
-	    			* NTP_INTERVAL_FREQ / 1000;
-	txc->freq	   = (time_freq / NSEC_PER_USEC)
-				<< (SHIFT_USEC - SHIFT_NSEC);
+		txc->offset = ((long)shift_right(time_offset, SHIFT_UPDATE)) *
+	    			NTP_INTERVAL_FREQ / 1000;
+	txc->freq	   = (time_freq / NSEC_PER_USEC) <<
+				(SHIFT_USEC - SHIFT_NSEC);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
log-reason-why-tsc-was-marked-unstable.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
declare-struct-ktime.patch
