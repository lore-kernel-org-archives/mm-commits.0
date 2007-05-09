From: akpm@linux-foundation.org
Subject: - remove-rtc_alm_set-mode-bugs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:39 -0700
Message-ID: <200705090254.l492sdGB009826@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032288AbXEICy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, scottwood@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rtc: remove "RTC_ALM_SET mode" bugs
has been removed from the -mm tree.  Its filename was
     remove-rtc_alm_set-mode-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: remove "RTC_ALM_SET mode" bugs
From: David Brownell <david-b@pacbell.net>

This fixes a common glitch in how RTC drivers handle two "set alarm" modes,
by getting rid of the surprising/hidden one that was rarely implemented
correctly (and which could expose nonportable hardware-specific behavior).

The glitch comes from the /dev/rtcX logic implementing the legacy
RTC_ALM_SET (limited to 24 hours, needing RTC_AIE_ON) ioctl on top of the
RTC driver call providing access to the newer RTC_WKALM_SET (without those
limitations) by initializing the day/month/year fields to be invalid ... 
that second mode.

Now, since few RTC drivers check those fields, and most hardware misbehaves
when faced with invalid date fields, many RTC drivers will set bogus alarm
times on those RTC_ALM_SET code paths.  (Several in-tree drivers have that
issue, and I also noticed it with code reviews on several new RTC drivers.)

This patch ensures that RTC drivers never see such invalid alarm fields, by
moving some logic out of rtc-omap into the RTC_ALM_SET code and adding an
explicit check (which will prevent the issue on other code paths).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt   |    7 +-----
 drivers/rtc/interface.c |    4 +++
 drivers/rtc/rtc-dev.c   |   42 +++++++++++++++++++++++++++++++++++---
 drivers/rtc/rtc-omap.c  |   28 -------------------------
 4 files changed, 45 insertions(+), 36 deletions(-)

diff -puN Documentation/rtc.txt~remove-rtc_alm_set-mode-bugs Documentation/rtc.txt
--- a/Documentation/rtc.txt~remove-rtc_alm_set-mode-bugs
+++ a/Documentation/rtc.txt
@@ -147,7 +147,7 @@ RTC class framework, but can't be suppor
 
     *	RTC_AIE_ON, RTC_AIE_OFF, RTC_ALM_SET, RTC_ALM_READ ... when the RTC
 	is connected to an IRQ line, it can often issue an alarm IRQ up to
-	24 hours in the future.
+	24 hours in the future.  (Use RTC_WKALM_* by preference.)
 
     *	RTC_WKALM_SET, RTC_WKALM_RD ... RTCs that can issue alarms beyond
 	the next 24 hours use a slightly more powerful API, which supports
@@ -175,10 +175,7 @@ driver returns ENOIOCTLCMD.  Some common
 	called with appropriate values.
 
     *	RTC_ALM_SET, RTC_ALM_READ, RTC_WKALM_SET, RTC_WKALM_RD: the
-	set_alarm/read_alarm functions will be called.  To differentiate
-	between the ALM and WKALM, check the larger fields of the rtc_wkalrm
-	struct (like tm_year).  These will be set to -1 when using ALM and
-	will be set to proper values when using WKALM.
+	set_alarm/read_alarm functions will be called.
 
     *	RTC_IRQP_SET, RTC_IRQP_READ: the irq_set_freq function will be called
 	to set the frequency while the framework will handle the read for you
diff -puN drivers/rtc/interface.c~remove-rtc_alm_set-mode-bugs drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~remove-rtc_alm_set-mode-bugs
+++ a/drivers/rtc/interface.c
@@ -125,6 +125,10 @@ int rtc_set_alarm(struct rtc_device *rtc
 {
 	int err;
 
+	err = rtc_valid_tm(&alarm->time);
+	if (err != 0)
+		return err;
+
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return -EBUSY;
diff -puN drivers/rtc/rtc-dev.c~remove-rtc_alm_set-mode-bugs drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~remove-rtc_alm_set-mode-bugs
+++ a/drivers/rtc/rtc-dev.c
@@ -277,12 +277,48 @@ static int rtc_dev_ioctl(struct inode *i
 
 		alarm.enabled = 0;
 		alarm.pending = 0;
-		alarm.time.tm_mday = -1;
-		alarm.time.tm_mon = -1;
-		alarm.time.tm_year = -1;
 		alarm.time.tm_wday = -1;
 		alarm.time.tm_yday = -1;
 		alarm.time.tm_isdst = -1;
+
+		/* RTC_ALM_SET alarms may be up to 24 hours in the future.
+		 * Rather than expecting every RTC to implement "don't care"
+		 * for day/month/year fields, just force the alarm to have
+		 * the right values for those fields.
+		 *
+		 * RTC_WKALM_SET should be used instead.  Not only does it
+		 * eliminate the need for a separate RTC_AIE_ON call, it
+		 * doesn't have the "alarm 23:59:59 in the future" race.
+		 *
+		 * NOTE:  some legacy code may have used invalid fields as
+		 * wildcards, exposing hardware "periodic alarm" capabilities.
+		 * Not supported here.
+		 */
+		{
+			unsigned long now, then;
+
+			err = rtc_read_time(rtc, &tm);
+			if (err < 0)
+				return err;
+			rtc_tm_to_time(&tm, &now);
+
+			alarm.time.tm_mday = tm.tm_mday;
+			alarm.time.tm_mon = tm.tm_mon;
+			alarm.time.tm_year = tm.tm_year;
+			err  = rtc_valid_tm(&alarm.time);
+			if (err < 0)
+				return err;
+			rtc_tm_to_time(&alarm.time, &then);
+
+			/* alarm may need to wrap into tomorrow */
+			if (then < now) {
+				rtc_time_to_tm(now + 24 * 60 * 60, &tm);
+				alarm.time.tm_mday = tm.tm_mday;
+				alarm.time.tm_mon = tm.tm_mon;
+				alarm.time.tm_year = tm.tm_year;
+			}
+		}
+
 		err = rtc_set_alarm(rtc, &alarm);
 		break;
 
diff -puN drivers/rtc/rtc-omap.c~remove-rtc_alm_set-mode-bugs drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~remove-rtc_alm_set-mode-bugs
+++ a/drivers/rtc/rtc-omap.c
@@ -289,34 +289,6 @@ static int omap_rtc_set_alarm(struct dev
 {
 	u8 reg;
 
-	/* Much userspace code uses RTC_ALM_SET, thus "don't care" for
-	 * day/month/year specifies alarms up to 24 hours in the future.
-	 * So we need to handle that ... but let's ignore the "don't care"
-	 * values for hours/minutes/seconds.
-	 */
-	if (alm->time.tm_mday <= 0
-			&& alm->time.tm_mon < 0
-			&& alm->time.tm_year < 0) {
-		struct rtc_time tm;
-		unsigned long now, then;
-
-		omap_rtc_read_time(dev, &tm);
-		rtc_tm_to_time(&tm, &now);
-
-		alm->time.tm_mday = tm.tm_mday;
-		alm->time.tm_mon = tm.tm_mon;
-		alm->time.tm_year = tm.tm_year;
-		rtc_tm_to_time(&alm->time, &then);
-
-		/* sometimes the alarm wraps into tomorrow */
-		if (then < now) {
-			rtc_time_to_tm(now + 24 * 60 * 60, &tm);
-			alm->time.tm_mday = tm.tm_mday;
-			alm->time.tm_mon = tm.tm_mon;
-			alm->time.tm_year = tm.tm_year;
-		}
-	}
-
 	if (tm2bcd(&alm->time) < 0)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
