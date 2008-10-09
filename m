From: akpm@linux-foundation.org
Subject: - ntp-let-update_persistent_clock-sleep.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:27:04 -0700
Message-ID: <200810092227.m99MR4Ri005924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096AbYJIW2K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, a.zummo@towertech.it, david-b@pacbell.net, riel@redhat.com, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     ntp: let update_persistent_clock() sleep
has been removed from the -mm tree.  Its filename was
     ntp-let-update_persistent_clock-sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
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
@@ -217,11 +217,11 @@ void second_overflow(void)
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
@@ -257,13 +257,13 @@ static void sync_cmos_clock(unsigned lon
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

git-tip.patch
rtc-rtc-m41t80c-add-support-for-the-st-m41t65-rtc.patch
efifb-imacfb-consolidation-hardware-support.patch

