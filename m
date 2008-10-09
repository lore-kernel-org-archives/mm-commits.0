From: akpm@linux-foundation.org
Subject: - timekeeping-fix-rounding-problem-during-clock-update.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:10 -0700
Message-ID: <200810092227.m99MRAfK005930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbYJIW1f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:27:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zippel@linux-m68k.org, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timekeeping: fix rounding problem during clock update
has been removed from the -mm tree.  Its filename was
     timekeeping-fix-rounding-problem-during-clock-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -487,7 +487,7 @@ void update_wall_time(void)
 #else
 	offset = clock->cycle_interval;
 #endif
-	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
+	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;
 
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
@@ -518,9 +518,12 @@ void update_wall_time(void)
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

git-tip.patch
hfsplus-quieten-down-mounting-hfsplus-journaled-fs-read-only.patch
hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch
hfsplus-check-read_mapping_page-return-value.patch
hfsplus-fix-another-bug-when-reading-a-corrupted-image.patch
hfs-fix-namelength-memory-corruption.patch
hfsplus-check-hfs_bnode_find-return-value.patch
hfsplus-missing-o_largefile-check.patch

