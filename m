From: akpm@linux-foundation.org
Subject: - rtc_read_alarm-handles-wraparound.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:57:59 -0700
Message-ID: <200807070257.m672vxR4004408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbYGGC6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 22:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lkml@rtr.ca, mm-commits@vger.kernel.org


The patch titled
     rtc: rtc_read_alarm() handles wraparound
has been removed from the -mm tree.  Its filename was
     rtc_read_alarm-handles-wraparound.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: rtc_read_alarm() handles wraparound
From: David Brownell <david-b@pacbell.net>

While 0e36a9a4a788e4e92407774df76c545910810d35 ("rtc: fix readback from
/sys/class/rtc/rtc?/wakealarm") made sure that active alarms were never
returned with invalid "wildcard" fields (negative), it can still report
(wrongly) that the alarm triggers in the past.

Example, if it's now 10am, an alarm firing at 5am will be triggered
TOMORROW not today.  (Which may also be next month or next year...)

This updates that alarm handling in three ways:

  * Handle alarm rollover in the common cases of RTCs that don't
    support matching on all date fields.

  * Skip the invalid-field logic when it's not needed.

  * Minor bugfix ... tm_isdst should be ignored, it's one of the
    fields Linux doesn't maintain.

A warning is emitted for some of the unhandled rollover cases, but the
possible combinations are a bit too numerous to handle every bit of
potential hardware and firmware braindamage.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Mark Lord <lkml@rtr.ca>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |  102 +++++++++++++++++++++++++++++++++-----
 1 file changed, 91 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/interface.c~rtc_read_alarm-handles-wraparound drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc_read_alarm-handles-wraparound
+++ a/drivers/rtc/interface.c
@@ -126,12 +126,25 @@ int rtc_read_alarm(struct rtc_device *rt
 	int err;
 	struct rtc_time before, now;
 	int first_time = 1;
+	unsigned long t_now, t_alm;
+	enum { none, day, month, year } missing = none;
+	unsigned days;
 
-	/* The lower level RTC driver may not be capable of filling
-	 * in all fields of the rtc_time struct (eg. rtc-cmos),
-	 * and so might instead return -1 in some fields.
-	 * We deal with that here by grabbing a current RTC timestamp
-	 * and using values from that for any missing (-1) values.
+	/* The lower level RTC driver may return -1 in some fields,
+	 * creating invalid alarm->time values, for reasons like:
+	 *
+	 *   - The hardware may not be capable of filling them in;
+	 *     many alarms match only on time-of-day fields, not
+	 *     day/month/year calendar data.
+	 *
+	 *   - Some hardware uses illegal values as "wildcard" match
+	 *     values, which non-Linux firmware (like a BIOS) may try
+	 *     to set up as e.g. "alarm 15 minutes after each hour".
+	 *     Linux uses only oneshot alarms.
+	 *
+	 * When we see that here, we deal with it by using values from
+	 * a current RTC timestamp for any missing (-1) values.  The
+	 * RTC driver prevents "periodic alarm" modes.
 	 *
 	 * But this can be racey, because some fields of the RTC timestamp
 	 * may have wrapped in the interval since we read the RTC alarm,
@@ -174,6 +187,10 @@ int rtc_read_alarm(struct rtc_device *rt
 		if (!alarm->enabled)
 			return 0;
 
+		/* full-function RTCs won't have such missing fields */
+		if (rtc_valid_tm(&alarm->time) == 0)
+			return 0;
+
 		/* get the "after" timestamp, to detect wrapped fields */
 		err = rtc_read_time(rtc, &now);
 		if (err < 0)
@@ -183,22 +200,85 @@ int rtc_read_alarm(struct rtc_device *rt
 	} while (   before.tm_min   != now.tm_min
 		 || before.tm_hour  != now.tm_hour
 		 || before.tm_mon   != now.tm_mon
-		 || before.tm_year  != now.tm_year
-		 || before.tm_isdst != now.tm_isdst);
+		 || before.tm_year  != now.tm_year);
 
-	/* Fill in any missing alarm fields using the timestamp */
+	/* Fill in the missing alarm fields using the timestamp; we
+	 * know there's at least one since alarm->time is invalid.
+	 */
 	if (alarm->time.tm_sec == -1)
 		alarm->time.tm_sec = now.tm_sec;
 	if (alarm->time.tm_min == -1)
 		alarm->time.tm_min = now.tm_min;
 	if (alarm->time.tm_hour == -1)
 		alarm->time.tm_hour = now.tm_hour;
-	if (alarm->time.tm_mday == -1)
+
+	/* For simplicity, only support date rollover for now */
+	if (alarm->time.tm_mday == -1) {
 		alarm->time.tm_mday = now.tm_mday;
-	if (alarm->time.tm_mon == -1)
+		missing = day;
+	}
+	if (alarm->time.tm_mon == -1) {
 		alarm->time.tm_mon = now.tm_mon;
-	if (alarm->time.tm_year == -1)
+		if (missing == none)
+			missing = month;
+	}
+	if (alarm->time.tm_year == -1) {
 		alarm->time.tm_year = now.tm_year;
+		if (missing == none)
+			missing = year;
+	}
+
+	/* with luck, no rollover is needed */
+	rtc_tm_to_time(&now, &t_now);
+	rtc_tm_to_time(&alarm->time, &t_alm);
+	if (t_now < t_alm)
+		goto done;
+
+	switch (missing) {
+
+	/* 24 hour rollover ... if it's now 10am Monday, an alarm that
+	 * that will trigger at 5am will do so at 5am Tuesday, which
+	 * could also be in the next month or year.  This is a common
+	 * case, especially for PCs.
+	 */
+	case day:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "day");
+		t_alm += 24 * 60 * 60;
+		rtc_time_to_tm(t_alm, &alarm->time);
+		break;
+
+	/* Month rollover ... if it's the 31th, an alarm on the 3rd will
+	 * be next month.  An alarm matching on the 30th, 29th, or 28th
+	 * may end up in the month after that!  Many newer PCs support
+	 * this type of alarm.
+	 */
+	case month:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "month");
+		do {
+			if (alarm->time.tm_mon < 11)
+				alarm->time.tm_mon++;
+			else {
+				alarm->time.tm_mon = 0;
+				alarm->time.tm_year++;
+			}
+			days = rtc_month_days(alarm->time.tm_mon,
+					alarm->time.tm_year);
+		} while (days < alarm->time.tm_mday);
+		break;
+
+	/* Year rollover ... easy except for leap years! */
+	case year:
+		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
+		do {
+			alarm->time.tm_year++;
+		} while (!rtc_valid_tm(&alarm->time));
+		break;
+
+	default:
+		dev_warn(&rtc->dev, "alarm rollover not handled\n");
+	}
+
+done:
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
atmel_nand-speedup-via-readwritesbw.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander.patch
gpio-gpio-driver-for-max7301-spi-gpio-expander-checkpatch-fixes.patch
gpio-sysfs-interface-updated-update.patch
gpio-mcp23s08-handles-multiple-chips-per-chipselect.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch

