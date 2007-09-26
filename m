From: akpm@linux-foundation.org
Subject: + rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:04:14 -0700
Message-ID: <200709262204.l8QM4ElL006258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbXIZWEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:04:38 -0400
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

Fix /sys/class/rtc/rtc?/wakealarm so that readback values now agree with
the written values.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/rtc/rtc-sysfs.c~rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm
+++ a/drivers/rtc/rtc-sysfs.c
@@ -88,6 +88,9 @@ rtc_sysfs_show_wakealarm(struct device *
 	ssize_t retval;
 	unsigned long alarm;
 	struct rtc_wkalrm alm;
+	struct rtc_time before, now;
+	struct rtc_device *rtc = to_rtc_device(dev);
+	int first_time = 1;
 
 	/* Don't show disabled alarms; but the RTC could leave the
 	 * alarm enabled after it's already triggered.  Alarms are
@@ -97,13 +100,68 @@ rtc_sysfs_show_wakealarm(struct device *
 	 * REVISIT maybe we should require RTC implementations to
 	 * disable the RTC alarm after it triggers, for uniformity.
 	 */
-	retval = rtc_read_alarm(to_rtc_device(dev), &alm);
-	if (retval == 0 && alm.enabled) {
-		rtc_tm_to_time(&alm.time, &alarm);
-		retval = sprintf(buf, "%lu\n", alarm);
-	}
 
-	return retval;
+	/* The lower level RTC driver may not be capable of filling
+	 * in all fields of the rtc_time struct (eg. rtc-cmos),
+	 * and so might instead return -1 in some fields.
+	 * We deal with that here by grabbing a current timestamp
+	 * and using values from that for any missing (-1) values.
+	 *
+	 * But this could be racey, in that some fields might wrap
+	 * to a new day/month/year/etc.. between reading the time
+	 * and then reading the alarm (which internally may also
+	 * read the time).
+	 *
+	 * So we read the time *again* afterward, and if the two
+	 * timestamps differ then we know we need to repeat the
+	 * procedure to avoid any field wrap issues.
+	 *
+	 * This could all instead be done in the lower level driver,
+	 * but if more than one RTC implementation needs it,
+	 * then it might be best to leave it here.
+	 */
+
+	/* get the "before" timestamp */
+	retval = rtc_read_time(rtc, &before);
+	if (retval < 0)
+		return retval;
+	do {
+		if (!first_time)
+			memcpy(&before, &now, sizeof(struct rtc_time));
+		first_time = 0;
+
+		/* get the RTC alarm values, which may be incomplete */
+		retval = rtc_read_alarm(to_rtc_device(dev), &alm);
+		if (retval)
+			return retval;
+		if (!alm.enabled)
+			return 0;
+
+		/* get the "after" timestamp, to detect wrapped fields */
+		retval = rtc_read_time(rtc, &now);
+		if (retval < 0)
+			return retval;
+
+	} while (   before.tm_hour  != now.tm_hour
+	         || before.tm_mday  != now.tm_mday
+		 || before.tm_mon   != now.tm_mon
+		 || before.tm_year  != now.tm_year
+		 || before.tm_isdst != now.tm_isdst);
+
+	/* fill in missing alarm fields using the timestamp */
+	if (alm.time.tm_hour == -1)
+		alm.time.tm_hour = now.tm_hour;
+	if (alm.time.tm_mday == -1)
+		alm.time.tm_mday = now.tm_mday;
+	if (alm.time.tm_mon == -1)
+		alm.time.tm_mon = now.tm_mon;
+	if (alm.time.tm_year == -1)
+		alm.time.tm_year = now.tm_year;
+	if (alm.time.tm_isdst == -1)
+		alm.time.tm_yday = now.tm_isdst;
+
+	rtc_tm_to_time(&alm.time, &alarm);
+	return sprintf(buf, "%lu\n", alarm);
 }
 
 static ssize_t
_

Patches currently in -mm which might be from lkml@rtr.ca are

rtc-fix-readback-from-sys-class-rtc-rtc-wakealarm.patch
