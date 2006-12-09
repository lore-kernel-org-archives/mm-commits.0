From: akpm@osdl.org
Subject: + rtc-add-rtc_merge_alarm.patch added to -mm tree
Date: Fri, 08 Dec 2006 20:38:43 -0800
Message-ID: <200612090438.kB94clj6016400@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbWLIEix (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 23:38:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: scottwood@freescale.com, a.zummo@towertech.it


The patch titled
     rtc: Add rtc_merge_alarm()
has been added to the -mm tree.  Its filename is
     rtc-add-rtc_merge_alarm.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: Add rtc_merge_alarm()
From: Scott Wood <scottwood@freescale.com>

Add rtc_merge_alarm(), which can be used by rtc drivers to turn a partially
specified alarm expiry (i.e.  most significant fields set to -1, as with the
RTC_ALM_SET ioctl()) into a fully specified expiry.

If the most significant specified field is earlier than the current time, the
least significant unspecified field is incremented.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-lib.c |   81 ++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc.h   |    1 
 2 files changed, 82 insertions(+)

diff -puN drivers/rtc/rtc-lib.c~rtc-add-rtc_merge_alarm drivers/rtc/rtc-lib.c
--- a/drivers/rtc/rtc-lib.c~rtc-add-rtc_merge_alarm
+++ a/drivers/rtc/rtc-lib.c
@@ -117,4 +117,85 @@ int rtc_tm_to_time(struct rtc_time *tm, 
 }
 EXPORT_SYMBOL(rtc_tm_to_time);
 
+
+/* Merge the valid (i.e. non-negative) fields of alarm into the current
+ * time.  If the valid alarm fields are earlier than the equivalent
+ * fields in the time, carry one into the least significant invalid
+ * field, so that the alarm expiry is in the future.  It assumes that the
+ * least significant invalid field is more significant than the most
+ * significant valid field, and that the seconds field is valid.
+ *
+ * This is used by alarms that take relative (rather than absolute)
+ * times, and/or have a simple binary second counter instead of
+ * day/hour/minute/sec registers.
+ */
+void rtc_merge_alarm(struct rtc_time *now, struct rtc_time *alarm)
+{
+	int *alarmp = &alarm->tm_sec;
+	int *timep = &now->tm_sec;
+	int carry_into, i;
+
+	/* Ignore everything past the 6th element (tm_year). */
+	for (i = 5; i > 0; i--) {
+		if (alarmp[i] < 0)
+			alarmp[i] = timep[i];
+		else
+			break;
+	}
+
+	/* No carry needed if all fields are valid. */
+	if (i == 5)
+		return;
+
+	for (carry_into = i + 1; i >= 0; i--) {
+		if (alarmp[i] < timep[i])
+			break;
+
+		if (alarmp[i] > timep[i])
+			return;
+	}
+
+	switch (carry_into) {
+		case 1:
+			alarm->tm_min++;
+
+			if (alarm->tm_min < 60)
+				return;
+
+			alarm->tm_min = 0;
+			/* fall-through */
+
+		case 2:
+			alarm->tm_hour++;
+
+			if (alarm->tm_hour < 60)
+				return;
+
+			alarm->tm_hour = 0;
+			/* fall-through */
+
+		case 3:
+			alarm->tm_mday++;
+
+			if (alarm->tm_mday <= rtc_days_in_month[alarm->tm_mon])
+				return;
+
+			alarm->tm_mday = 1;
+			/* fall-through */
+
+		case 4:
+			alarm->tm_mon++;
+
+			if (alarm->tm_mon <= 12)
+				return;
+
+			alarm->tm_mon = 1;
+			/* fall-through */
+
+		case 5:
+			alarm->tm_year++;
+	}
+}
+EXPORT_SYMBOL(rtc_merge_alarm);
+
 MODULE_LICENSE("GPL");
diff -puN include/linux/rtc.h~rtc-add-rtc_merge_alarm include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-add-rtc_merge_alarm
+++ a/include/linux/rtc.h
@@ -106,6 +106,7 @@ extern int rtc_year_days(unsigned int da
 extern int rtc_valid_tm(struct rtc_time *tm);
 extern int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time);
 extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
+extern void rtc_merge_alarm(struct rtc_time *now, struct rtc_time *alarm);
 
 #include <linux/device.h>
 #include <linux/seq_file.h>
_

Patches currently in -mm which might be from scottwood@freescale.com are

origin.patch
make-platform_device_add_data-accept-a-const-pointer.patch
rtc-add-rtc_merge_alarm.patch
rtc-rtc-class-driver-for-the-ds1374.patch

