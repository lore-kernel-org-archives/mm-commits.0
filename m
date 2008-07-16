From: akpm@linux-foundation.org
Subject: + timekeeping-fix-rounding-problem-during-clock-update.patch added to -mm tree
Date: Wed, 16 Jul 2008 13:28:43 -0700
Message-ID: <200807162028.m6GKShYT011461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756477AbYGPUaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 16:30:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     timekeeping: fix rounding problem during clock update
has been added to the -mm tree.  Its filename is
     timekeeping-fix-rounding-problem-during-clock-update.patch

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
Subject: timekeeping: fix rounding problem during clock update
From: Roman Zippel <zippel@linux-m68k.org>

Due to a rounding problem during a clock update it's possible for readers
to observe the clock jumping back by 1nsec.  The following simplified
example demonstrates the problem:

cycle	xtime
0	0
1000	999999.6
2000	1999999.2
3000	2999998.8
...

1500 =	1499999.4
=	0.0 + 1499999.4
=	999999.6 + 499999.8

When reading the clock only the full nanosecond part is used, while
timekeeping internally keeps nanosecond fractions.  If the clock is now
updated at cycle 1500 here, a nanosecond is missing due to the truncation.

The simple fix is to round up the xtime value during the update, this also
changes the distance to the reference time, but the adjustment will
automatically take care that it stays under control.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timekeeping.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/time/timekeeping.c~timekeeping-fix-rounding-problem-during-clock-update kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~timekeeping-fix-rounding-problem-during-clock-update
+++ a/kernel/time/timekeeping.c
@@ -454,7 +454,7 @@ void update_wall_time(void)
 #else
 	offset = clock->cycle_interval;
 #endif
-	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
+	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
@@ -479,9 +479,12 @@ void update_wall_time(void)
 	/* correct the clock when NTP error is too big */
 	clocksource_adjust(offset);
 
-	/* store full nanoseconds into xtime */
-	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
+	/* store full nanoseconds into xtime after rounding it up and
+	 * add the remainder to the error difference.
+	 */
+	xtime.tv_nsec = ((s64)clock->xtime_nsec >> clock->shift) + 1;
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
+	clock->error += clock->xtime_nsec << (NTP_SCALE_SHIFT - clock->shift);
 
 	update_xtime_cache(cyc2ns(clock, offset));
 
_

Patches currently in -mm which might be from zippel@linux-m68k.org are

linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
hfs-convert-bitmap_lock-in-a-mutex.patch
hfs-convert-extents_lock-in-a-mutex.patch
hfsplus-convert-the-extents_lock-in-a-mutex.patch
affs-convert-s_bmlock-into-a-mutex.patch

