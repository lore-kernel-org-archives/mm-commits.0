From: akpm@linux-foundation.org
Subject: + ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup.patch added to -mm tree
Date: Mon, 18 Aug 2008 13:32:24 -0700
Message-ID: <200808182032.m7IKWODv011251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077AbYHRUdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 16:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, johnstul@us.ibm.com, mingo@elte.hu, mtk.manpages@googlemail.com, tglx@linutronix.de


The patch titled
     ntp: fix ADJ_OFFSET_SS_READ bug and do_adjtimex() cleanup
has been added to the -mm tree.  Its filename is
     ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: fix ADJ_OFFSET_SS_READ bug and do_adjtimex() cleanup
From: Roman Zippel <zippel@linux-m68k.org>

Thanks to the review by Michael Kerrisk a bug in the recent
ADJ_OFFSET_SS_READ option was discovered, where the ntp time_offset was
inadvertently set by it.  This fixes this by making the adjtime code
more separate from the ntp_adjtime code (both of which really want to
be separate syscalls).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    9 ++++
 kernel/time/ntp.c     |   76 +++++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 37 deletions(-)

diff -puN include/linux/timex.h~ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup include/linux/timex.h
--- a/include/linux/timex.h~ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup
+++ a/include/linux/timex.h
@@ -141,8 +141,15 @@ struct timex {
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
+
+#ifdef __KERNEL__
+#define ADJ_ADJTIME		0x8000	/* switch between adjtime/adjtimex modes */
+#define ADJ_OFFSET_SINGLESHOT	0x0001	/* old-fashioned adjtime */
+#define ADJ_OFFSET_READONLY	0x2000	/* read-only adjtime */
+#else
 #define ADJ_OFFSET_SINGLESHOT	0x8001	/* old-fashioned adjtime */
-#define ADJ_OFFSET_SS_READ	0xa001  /* read-only adjtime */
+#define ADJ_OFFSET_SS_READ	0xa001	/* read-only adjtime */
+#endif
 
 /* xntp 3.4 compatibility names */
 #define MOD_OFFSET	ADJ_OFFSET
diff -puN kernel/time/ntp.c~ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup
+++ a/kernel/time/ntp.c
@@ -277,38 +277,50 @@ static inline void notify_cmos_timer(voi
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
-	long save_adjust, sec;
 	int result;
 
-	/* In order to modify anything, you gotta be super-user! */
-	if (txc->modes && !capable(CAP_SYS_TIME))
-		return -EPERM;
-
-	/* Now we validate the data before disabling interrupts */
-
-	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT) {
+	/* Validate the data before disabling interrupts */
+	if (txc->modes & ADJ_ADJTIME) {
 		/* singleshot must not be used with any other mode bits */
-		if (txc->modes & ~ADJ_OFFSET_SS_READ)
+		if (!(txc->modes & ADJ_OFFSET_SINGLESHOT))
 			return -EINVAL;
-	}
+		if (!(txc->modes & ADJ_OFFSET_READONLY) &&
+		    !capable(CAP_SYS_TIME))
+			return -EPERM;
+	} else {
+		/* In order to modify anything, you gotta be super-user! */
+		 if (txc->modes && !capable(CAP_SYS_TIME))
+			return -EPERM;
+
+		/* if the quartz is off by more than 10% something is VERY wrong! */
+		if (txc->modes & ADJ_TICK &&
+		    (txc->tick <  900000/USER_HZ ||
+		     txc->tick > 1100000/USER_HZ))
+				return -EINVAL;
 
-	/* if the quartz is off by more than 10% something is VERY wrong ! */
-	if (txc->modes & ADJ_TICK)
-		if (txc->tick <  900000/USER_HZ ||
-		    txc->tick > 1100000/USER_HZ)
-			return -EINVAL;
+		if (txc->modes & ADJ_STATUS && time_state != TIME_OK)
+			hrtimer_cancel(&leap_timer);
+	}
 
-	if (time_state != TIME_OK && txc->modes & ADJ_STATUS)
-		hrtimer_cancel(&leap_timer);
 	getnstimeofday(&ts);
 
 	write_seqlock_irq(&xtime_lock);
 
-	/* Save for later - semantics of adjtime is to return old value */
-	save_adjust = time_adjust;
-
 	/* If there are input parameters, then process them */
+	if (txc->modes & ADJ_ADJTIME) {
+		long save_adjust = time_adjust;
+
+		if (!(txc->modes & ADJ_OFFSET_READONLY)) {
+			/* adjtime() is independent from ntp_adjtime() */
+			time_adjust = txc->offset;
+			ntp_update_frequency();
+		}
+		txc->offset = save_adjust;
+		goto adj_done;
+	}
 	if (txc->modes) {
+		long sec;
+
 		if (txc->modes & ADJ_STATUS) {
 			if ((time_status & STA_PLL) &&
 			    !(txc->status & STA_PLL)) {
@@ -375,13 +387,8 @@ int do_adjtimex(struct timex *txc)
 		if (txc->modes & ADJ_TAI && txc->constant > 0)
 			time_tai = txc->constant;
 
-		if (txc->modes & ADJ_OFFSET) {
-			if (txc->modes == ADJ_OFFSET_SINGLESHOT)
-				/* adjtime() is independent from ntp_adjtime() */
-				time_adjust = txc->offset;
-			else
-				ntp_update_offset(txc->offset);
-		}
+		if (txc->modes & ADJ_OFFSET)
+			ntp_update_offset(txc->offset);
 		if (txc->modes & ADJ_TICK)
 			tick_usec = txc->tick;
 
@@ -389,19 +396,16 @@ int do_adjtimex(struct timex *txc)
 			ntp_update_frequency();
 	}
 
+	txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
+				  NTP_SCALE_SHIFT);
+	if (!(time_status & STA_NANO))
+		txc->offset /= NSEC_PER_USEC;
+
+adj_done:
 	result = time_state;	/* mostly `TIME_OK' */
 	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
 		result = TIME_ERROR;
 
-	if ((txc->modes == ADJ_OFFSET_SINGLESHOT) ||
-	    (txc->modes == ADJ_OFFSET_SS_READ))
-		txc->offset = save_adjust;
-	else {
-		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
-					  NTP_SCALE_SHIFT);
-		if (!(time_status & STA_NANO))
-			txc->offset /= NSEC_PER_USEC;
-	}
 	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
 					 (s64)PPM_SCALE_INV,
 					 NTP_SCALE_SHIFT);
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

ntp-let-update_persistent_clock-sleep.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch
hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch

