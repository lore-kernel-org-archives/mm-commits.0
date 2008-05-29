From: akpm@linux-foundation.org
Subject: + ntp-let-update_persistent_clock-sleep.patch added to -mm tree
Date: Thu, 29 May 2008 12:53:23 -0700
Message-ID: <200805291953.m4TJrNii019161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760053AbYE2TzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 15:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, a.zummo@towertech.it, david-b@pacbell.net, riel@redhat.com, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     ntp: let update_persistent_clock() sleep
has been added to the -mm tree.  Its filename is
     ntp-let-update_persistent_clock-sleep.patch

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
Subject: ntp: let update_persistent_clock() sleep
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a change that makes the 11-minute RTC update be run in the process
context.  This is so that update_persistent_clock() can sleep, which may
be required for certain types of RTC hardware -- most notably I2C devices.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/time/ntp.c~ntp-let-update_persistent_clock-sleep kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-let-update_persistent_clock-sleep
+++ a/kernel/time/ntp.c
@@ -10,13 +10,13 @@
 
 #include <linux/mm.h>
 #include <linux/time.h>
-#include <linux/timer.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
 #include <linux/capability.h>
 #include <linux/math64.h>
 #include <linux/clocksource.h>
+#include <linux/workqueue.h>
 #include <asm/timex.h>
 
 /*
@@ -218,11 +218,11 @@ void second_overflow(void)
 /* Disable the cmos update - used by virtualization and embedded */
 int no_sync_cmos_clock  __read_mostly;
 
-static void sync_cmos_clock(unsigned long dummy);
+static void sync_cmos_clock(struct work_struct *work);
 
-static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
-static void sync_cmos_clock(unsigned long dummy)
+static void sync_cmos_clock(struct work_struct *work)
 {
 	struct timespec now, next;
 	int fail = 1;
@@ -258,13 +258,13 @@ static void sync_cmos_clock(unsigned lon
 		next.tv_sec++;
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
-	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
+	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
 static void notify_cmos_timer(void)
 {
 	if (!no_sync_cmos_clock)
-		mod_timer(&sync_cmos_timer, jiffies + 1);
+		schedule_delayed_work(&sync_cmos_work, 0);
 }
 
 #else
_

Patches currently in -mm which might be from macro@linux-mips.org are

serial-fix-driver_name-conflicts.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

