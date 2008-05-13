From: akpm@linux-foundation.org
Subject: + ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch added to -mm tree
Date: Mon, 12 May 2008 17:22:36 -0700
Message-ID: <200805130022.m4D0Map2016452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112AbYEMAXd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:23:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     ntp: fix calculation of the next jiffie to trigger RTC sync
has been added to the -mm tree.  Its filename is
     ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch

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
@@ -245,7 +245,7 @@ static void sync_cmos_clock(unsigned lon
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
 		fail = update_persistent_clock(now);
 
-	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
+	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
 		next.tv_nsec += NSEC_PER_SEC;
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch
rtc-watchdog-m41t80-fix-a-potential-use-of-unitialized-data.patch
rtc-m41t80-include-linux-kernelh-for-printk.patch
linux-next.patch
ntp-make-the-rtc-sync-mode-11-minute-again.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

