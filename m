From: akpm@linux-foundation.org
Subject: - correct-inconsistent-ntp-interval-tick_length-usage.patch removed from -mm tree
Date: Wed, 30 Jan 2008 18:04:22 -0800
Message-ID: <200801310204.m0V243hY003497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199AbYAaCEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jan 2008 21:04:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ntp: correct inconsistent interval/tick_length usage
has been removed from the -mm tree.  Its filename was
     correct-inconsistent-ntp-interval-tick_length-usage.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: correct inconsistent interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>

Correct NTP drift caused by using inconsistent NTP_INTERVAL_LENGTHs in
clocksource initialization and error accumulation.  This corrects a 280ppm
drift seen on some systems using acpi_pm, and affects other clocksources as
well (likely to a lesser degree).

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    8 +++++++-
 kernel/time/ntp.c     |    4 ----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/timex.h~correct-inconsistent-ntp-interval-tick_length-usage include/linux/timex.h
--- a/include/linux/timex.h~correct-inconsistent-ntp-interval-tick_length-usage
+++ a/include/linux/timex.h
@@ -232,7 +232,13 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
+
+#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
+#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
+					(s64)CLOCK_TICK_RATE)
+
+/* Because using NSEC_PER_SEC would be too easy */
+#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC*NSEC_PER_USEC*USER_HZ)+CLOCK_TICK_ADJUST)/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
diff -puN kernel/time/ntp.c~correct-inconsistent-ntp-interval-tick_length-usage kernel/time/ntp.c
--- a/kernel/time/ntp.c~correct-inconsistent-ntp-interval-tick_length-usage
+++ a/kernel/time/ntp.c
@@ -43,10 +43,6 @@ long time_freq;				/* frequency offset (
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
 
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

git-x86.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
correct-inconsistent-ntp-interval-tick_length-usage.patch
