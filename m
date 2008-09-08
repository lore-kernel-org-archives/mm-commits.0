From: akpm@linux-foundation.org
Subject: - ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:30 -0700
Message-ID: <200809081907.m88J7UW5005561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbYIHTIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ntp: fix calculation of the next jiffie to trigger RTC sync
has been removed from the -mm tree.  Its filename was
     ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntp: fix calculation of the next jiffie to trigger RTC sync
From: "Maciej W. Rozycki" <macro@linux-mips.org>

We have a bug in the calculation of the next jiffie to trigger the RTC
synchronisation.  The aim here is to run sync_cmos_clock() as close as
possible to the middle of a second.  Which means we want this function to
be called less than or equal to half a jiffie away from when now.tv_nsec
equals 5e8 (500000000).

If this is not the case for a given call to the function, for this purpose
instead of updating the RTC we calculate the offset in nanoseconds to the
next point in time where now.tv_nsec will be equal 5e8.  The calculated
offset is then converted to jiffies as these are the unit used by the
timer.

Hovewer timespec_to_jiffies() used here uses a ceil()-type rounding mode,
where the resulting value is rounded up.  As a result the range of
now.tv_nsec when the timer will trigger is from 5e8 to 5e8 + TICK_NSEC
rather than the desired 5e8 - TICK_NSEC / 2 to 5e8 + TICK_NSEC / 2.

As a result if for example sync_cmos_clock() happens to be called at the
time when now.tv_nsec is between 5e8 + TICK_NSEC / 2 and 5e8 to 5e8 +
TICK_NSEC, it will simply be rescheduled HZ jiffies later, falling in the
same range of now.tv_nsec again.  Similarly for cases offsetted by an
integer multiple of TICK_NSEC.

This change addresses the problem by subtracting TICK_NSEC / 2 from the
nanosecond offset to the next point in time where now.tv_nsec will be
equal 5e8, effectively shifting the following rounding in
timespec_to_jiffies() so that it produces a rounded-to-nearest result.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/ntp.c~ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync
+++ a/kernel/time/ntp.c
@@ -245,7 +245,7 @@ static void sync_cmos_clock(struct work_
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
 		fail = update_persistent_clock(now);
 
-	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
+	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
 		next.tv_nsec += NSEC_PER_SEC;
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch
efifb-imacfb-consolidation-hardware-support.patch

