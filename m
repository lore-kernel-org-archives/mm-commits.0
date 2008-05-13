From: akpm@linux-foundation.org
Subject: + ntp-make-the-rtc-sync-mode-11-minute-again.patch added to -mm tree
Date: Mon, 12 May 2008 17:22:31 -0700
Message-ID: <200805130022.m4D0MW7b016429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbYEMAXb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 20:23:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     ntp: make the RTC sync mode 11-minute again
has been added to the -mm tree.  Its filename is
     ntp-make-the-rtc-sync-mode-11-minute-again.patch

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
Subject: ntp: make the RTC sync mode 11-minute again
From: "Maciej W. Rozycki" <macro@linux-mips.org>

As a result of the rewrite to drive the RTC sync from NTP code to use a
timer, the piece of code responsible for doing this is triggered each time
do_adjtimex() is called.  Which may be as often as once per 64 seconds as
this is the minimum interval between NTP packets used by the daemon.  Make
the interval 11 minutes again, by not reactivating the timer if pending
already.

Note with this approach, there is a small window where the timer has
expired, but has not been rearmed yet, for example when the handler is
still early in sync_cmos_clock() by the time this function is called.  The
likelihood of this event is epsilon and it should not be enough of a
problem to justify designing a mutex solution to avoid it -- if the
scenario happens either the RTC will be updated twice or mod_timer() will
be called from sync_cmos_clock() even before the newly-armed timer
expires, cancelling the additional update.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/ntp.c~ntp-make-the-rtc-sync-mode-11-minute-again kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-make-the-rtc-sync-mode-11-minute-again
+++ a/kernel/time/ntp.c
@@ -263,7 +263,7 @@ static void sync_cmos_clock(unsigned lon
 
 static void notify_cmos_timer(void)
 {
-	if (!no_sync_cmos_clock)
+	if (!no_sync_cmos_clock && !timer_pending(&sync_cmos_timer))
 		mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
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

