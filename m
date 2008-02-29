From: akpm@linux-foundation.org
Subject: + time-remove-obsolete-clock_tick_adjust.patch added to -mm tree
Date: Fri, 29 Feb 2008 15:24:34 -0800
Message-ID: <200802292324.m1TNOY0L026099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbYB2XZO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 18:25:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: remove obsolete CLOCK_TICK_ADJUST
has been added to the -mm tree.  Its filename is
     time-remove-obsolete-clock_tick_adjust.patch

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
Subject: time: remove obsolete CLOCK_TICK_ADJUST
From: Roman Zippel <zippel@linux-m68k.org>

The first version of the ntp_interval/tick_length inconsistent usage patch was
recently merged as bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

While the fix did greatly improve the situation, it was correctly pointed out
by Roman that it does have a small bug: If the users change clocksources after
the system has been running and NTP has made corrections, the correctoins made
against the old clocksource will be applied against the new clocksource,
causing error.

The second attempt, which corrects the issue in the NTP_INTERVAL_LENGTH
definition has also made it up-stream as commit
e13a2e61dd5152f5499d2003470acf9c838eab84

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e13a2e61dd5152f5499d2003470acf9c838eab84

Roman has correctly pointed out that CLOCK_TICK_ADJUST is calculated
based on the PIT's frequency, and isn't really relevant to non-PIT
driven clocksources (that is, clocksources other then jiffies and pit).

This patch reverts both of those changes, and simply removes
CLOCK_TICK_ADJUST.

This does remove the granularity error correction for users of PIT and Jiffies
clocksource users, but the granularity error but for the majority of users, it
should be within the 500ppm range NTP can accommodate for.

For systems that have granularity errors greater then 500ppm, the
"ntp_tick_adj=" boot option can be used to compensate.

[johnstul@us.ibm.com: provided changelog]
Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Acked-by: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h     |    9 +--------
 kernel/time/ntp.c         |   11 ++++++++++-
 kernel/time/timekeeping.c |    6 ++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/timex.h~time-remove-obsolete-clock_tick_adjust include/linux/timex.h
--- a/include/linux/timex.h~time-remove-obsolete-clock_tick_adjust
+++ a/include/linux/timex.h
@@ -232,14 +232,7 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
-/* Because using NSEC_PER_SEC would be too easy */
-#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC * NSEC_PER_USEC * USER_HZ) + \
-			      CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ)
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
diff -puN kernel/time/ntp.c~time-remove-obsolete-clock_tick_adjust kernel/time/ntp.c
--- a/kernel/time/ntp.c~time-remove-obsolete-clock_tick_adjust
+++ a/kernel/time/ntp.c
@@ -42,12 +42,13 @@ long time_esterror = NTP_PHASE_LIMIT;	/*
 long time_freq;				/* frequency offset (scaled ppm)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
+long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< TICK_LENGTH_SHIFT;
-	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
+	second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
 	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
 
 	tick_length_base = second_length;
@@ -402,3 +403,11 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	notify_cmos_timer();
 	return(result);
 }
+
+static int __init ntp_tick_adj_setup(char *str)
+{
+	ntp_tick_adj = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ntp_tick_adj=", ntp_tick_adj_setup);
diff -puN kernel/time/timekeeping.c~time-remove-obsolete-clock_tick_adjust kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~time-remove-obsolete-clock_tick_adjust
+++ a/kernel/time/timekeeping.c
@@ -187,8 +187,7 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
 
@@ -245,8 +244,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

git-hrt.patch
time-remove-obsolete-clock_tick_adjust.patch
fs-hfsplus-proper-externs.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
fs-affs-filec-use-bug_on.patch
affs-be_add_cpu-conversion.patch
hfs-hfsplus-be_add_cpu-conversion.patch

