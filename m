From: akpm@linux-foundation.org
Subject: + rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch added to -mm tree
Date: Thu, 27 Sep 2007 17:35:28 -0700
Message-ID: <200709280035.l8S0ZSaV003099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbXI1Ag1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 20:36:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, a.zummo@towertech.it, david-b@pacbell.net, mlord@pobox.com


The patch titled
     rtc: fix readback from /sys/class/rtc/rtc?/wakealarm
has been added to the -mm tree.  Its filename is
     rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: fix readback from /sys/class/rtc/rtc?/wakealarm
From: Mark Lord <lkml@rtr.ca>

Fix readback of RTC alarms on platforms which return -1 in
non-hardware-supported RTC alarm fields.

To fill in the missing (-1) values, we grab an RTC timestamp along with the
RTC alarm value, and use the timestamp fields to populate the missing alarm
fields.

To counter field-wrap races (since the timestamp and alarm are not read
together atomically), we read the RTC timestamp both before and after
reading the RTC alarm value, and then check for wrapped fields --> if any
have wrapped, we know we have a possible inconsistency, so we loop and
reread the timestamp and alarm again.

Wrapped fields in the RTC timestamps are an issue because rtc-cmos.c, for
example, also gets/uses an RTC timestamp internally while fetching the RTC
alarm.  If our timestamp here wasn't the same (minutes and higher) as what
was used internally there, then we might end up populating the -1 fields
with inconsistent values.

This fixes readbacks from /sys/class/rtc/rtc?/wakealarm, as well as other
code paths which call rtc_read_alarm().

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/interface.c~rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm
+++ a/drivers/rtc/interface.c
@@ -99,7 +99,7 @@ int rtc_set_mmss(struct rtc_device *rtc,
 }
 EXPORT_SYMBOL_GPL(rtc_set_mmss);
 
-int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+static int rtc_read_alarm_internal(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	int err;
 
@@ -119,6 +119,87 @@ int rtc_read_alarm(struct rtc_device *rt
 	mutex_unlock(&rtc->ops_lock);
 	return err;
 }
+
+int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+{
+	int err;
+	struct rtc_time before, now;
+	int first_time = 1;
+
+	/* The lower level RTC driver may not be capable of filling
+	 * in all fields of the rtc_time struct (eg. rtc-cmos),
+	 * and so might instead return -1 in some fields.
+	 * We deal with that here by grabbing a current RTC timestamp
+	 * and using values from that for any missing (-1) values.
+	 *
+	 * But this can be racey, because some fields of the RTC timestamp
+	 * may have wrapped in the interval since we read the RTC alarm,
+	 * which would lead to us inserting inconsistent values in place
+	 * of the -1 fields.
+	 *
+	 * Reading the alarm and timestamp in the reverse sequence
+	 * would have the same race condition, and not solve the issue.
+	 *
+	 * So, we must first read the RTC timestamp,
+	 * then read the RTC alarm value,
+	 * and then read a second RTC timestamp.
+	 *
+	 * If any fields of the second timestamp have changed
+	 * when compared with the first timestamp, then we know
+	 * our timestamp may be inconsistent with that used by
+	 * the low-level rtc_read_alarm_internal() function.
+	 *
+	 * So, when the two timestamps disagree, we just loop and do
+	 * the process again to get a fully consistent set of values.
+	 *
+	 * This could all instead be done in the lower level driver,
+	 * but since more than one lower level RTC implementation needs it,
+	 * then it's probably best best to do it here instead of there..
+	 */
+
+	/* Get the "before" timestamp */
+	err = rtc_read_time(rtc, &before);
+	if (err < 0)
+		return err;
+	do {
+		if (!first_time)
+			memcpy(&before, &now, sizeof(struct rtc_time));
+		first_time = 0;
+
+		/* get the RTC alarm values, which may be incomplete */
+		err = rtc_read_alarm_internal(rtc, alarm);
+		if (err)
+			return err;
+		if (!alarm->enabled)
+			return 0;
+
+		/* get the "after" timestamp, to detect wrapped fields */
+		err = rtc_read_time(rtc, &now);
+		if (err < 0)
+			return err;
+
+		/* note that tm_sec is a "don't care" value here: */
+	} while (   before.tm_min   != now.tm_min
+		 || before.tm_hour  != now.tm_hour
+		 || before.tm_mon   != now.tm_mon
+		 || before.tm_year  != now.tm_year
+		 || before.tm_isdst != now.tm_isdst);
+
+	/* Fill in any missing alarm fields using the timestamp */
+	if (alarm->time.tm_sec == -1)
+		alarm->time.tm_sec = now.tm_sec;
+	if (alarm->time.tm_min == -1)
+		alarm->time.tm_min = now.tm_min;
+	if (alarm->time.tm_hour == -1)
+		alarm->time.tm_hour = now.tm_hour;
+	if (alarm->time.tm_mday == -1)
+		alarm->time.tm_mday = now.tm_mday;
+	if (alarm->time.tm_mon == -1)
+		alarm->time.tm_mon = now.tm_mon;
+	if (alarm->time.tm_year == -1)
+		alarm->time.tm_year = now.tm_year;
+	return 0;
+}
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
 int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
_

Patches currently in -mm which might be from lkml@rtr.ca are

acpi-fix-bdc-handling-in-drivers-acpi-sleep-procc.patch
rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch
