From: akpm@linux-foundation.org
Subject: + ntp-let-update_persistent_clock-sleep.patch added to -mm tree
Date: Wed, 28 May 2008 20:16:20 -0700
Message-ID: <200805290316.m4T3GKsG013775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbYE2DSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 23:18:05 -0400
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
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/ntp.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN kernel/time/ntp.c~ntp-let-update_persistent_clock-sleep kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-let-update_persistent_clock-sleep
+++ a/kernel/time/ntp.c
@@ -3,6 +3,8 @@
  *
  * NTP state machine interfaces and logic.
  *
+ * Copyright (c) 2008  Maciej W. Rozycki
+ *
  * This code was mainly moved from kernel/timer.c and kernel/time.c
  * Please see those files for relevant copyright info and historical
  * changelogs.
@@ -17,6 +19,7 @@
 #include <linux/capability.h>
 #include <linux/math64.h>
 #include <linux/clocksource.h>
+#include <linux/workqueue.h>
 #include <asm/timex.h>
 
 /*
@@ -218,11 +221,13 @@ void second_overflow(void)
 /* Disable the cmos update - used by virtualization and embedded */
 int no_sync_cmos_clock  __read_mostly;
 
-static void sync_cmos_clock(unsigned long dummy);
+static void sync_cmos_clock(unsigned long data);
+static void do_sync_cmos_clock(struct work_struct *work);
 
 static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+static DECLARE_WORK(sync_cmos_work, do_sync_cmos_clock);
 
-static void sync_cmos_clock(unsigned long dummy)
+static void do_sync_cmos_clock(struct work_struct *work)
 {
 	struct timespec now, next;
 	int fail = 1;
@@ -261,6 +266,12 @@ static void sync_cmos_clock(unsigned lon
 	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
 }
 
+static void sync_cmos_clock(unsigned long data)
+{
+	/* Some implementations of update_persistent_clock() may sleep.  */
+	schedule_work(&sync_cmos_work);
+}
+
 static void notify_cmos_timer(void)
 {
 	if (!no_sync_cmos_clock)
_

Patches currently in -mm which might be from macro@linux-mips.org are

linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
ntp-make-the-rtc-sync-mode-11-minute-again.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch

