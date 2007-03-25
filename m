From: akpm@linux-foundation.org
Subject: + ntp-avoid-time_offset-overflows.patch added to -mm tree
Date: Sun, 25 Mar 2007 14:13:48 -0800
Message-ID: <200703252213.l2PMDmIu004006@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60366 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXCYWO5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 18:14:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     ntp: avoid time_offset overflows
has been added to the -mm tree.  Its filename is
     ntp-avoid-time_offset-overflows.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ntp: avoid time_offset overflows
From: john stultz <johnstul@us.ibm.com>

I've been seeing some odd NTP behavior recently on a few boxes and
finally narrowed it down to time_offset overflowing when converted to
SHIFT_UPDATE units (which was a side effect from my HZfreeNTP patch).

This patch converts time_offset from a long to a s64 which resolves the
issue.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

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
+	long mtemp, save_adjust;
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
@@ -314,8 +314,8 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
-		    			<< SHIFT_UPDATE;
+		    do_div(time_offset, NTP_INTERVAL_FREQ);
+		    time_offset <<= SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
 	    if (txc->modes & ADJ_TICK)
@@ -330,7 +330,7 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT)
 	    txc->offset	   = save_adjust;
 	else
-	    txc->offset    = shift_right(time_offset, SHIFT_UPDATE)
+	    txc->offset    = ((long)shift_right(time_offset, SHIFT_UPDATE))
 	    			* NTP_INTERVAL_FREQ / 1000;
 	txc->freq	   = (time_freq / NSEC_PER_USEC)
 				<< (SHIFT_USEC - SHIFT_NSEC);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
correct-slow-acpi_pm-rating.patch
dynticks-fix-hrtimer-rounding-error-in.patch
clocksource-fix-thinko-in-watchdog-selection.patch
ntp-avoid-time_offset-overflows.patch
log-reason-why-tsc-was-marked-unstable.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
optimize-timespec_trunc.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
