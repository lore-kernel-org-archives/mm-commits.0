From: akpm@linux-foundation.org
Subject: [merged]
 rtc-da9052-add-extra-reads-with-timeouts-to-avoid-returning-partially-updated-values.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:50 -0700
Message-ID: <553550de.tm2OySx64YcV6No2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbbDTTL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam.ward.opensource@diasemi.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: add extra reads with timeouts to avoid returning partially updated values
has been removed from the -mm tree.  Its filename was
     rtc-da9052-add-extra-reads-with-timeouts-to-avoid-returning-partially-updated-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Adam Ward <adam.ward.opensource@diasemi.com>
Subject: drivers/rtc/rtc-da9052.c: add extra reads with timeouts to avoid returning partially updated values

The RTC is in a different clock domain so a quick read after write
can retrieve a mangled value of the old/new values

Signed-off-by: Adam Ward <adam.ward.opensource@diasemi.com>
Tested-by: Adam Ward <adam.ward.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |   87 ++++++++++++++++++++++++++++---------
 1 file changed, 66 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-da9052.c~rtc-da9052-add-extra-reads-with-timeouts-to-avoid-returning-partially-updated-values drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-da9052-add-extra-reads-with-timeouts-to-avoid-returning-partially-updated-values
+++ a/drivers/rtc/rtc-da9052.c
@@ -16,6 +16,7 @@
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/err.h>
+#include <linux/delay.h>
 
 #include <linux/mfd/da9052/da9052.h>
 #include <linux/mfd/da9052/reg.h>
@@ -23,6 +24,8 @@
 #define rtc_err(rtc, fmt, ...) \
 		dev_err(rtc->da9052->dev, "%s: " fmt, __func__, ##__VA_ARGS__)
 
+#define DA9052_GET_TIME_RETRIES 5
+
 struct da9052_rtc {
 	struct rtc_device *rtc;
 	struct da9052 *da9052;
@@ -58,22 +61,43 @@ static irqreturn_t da9052_rtc_irq(int ir
 static int da9052_read_alarm(struct da9052_rtc *rtc, struct rtc_time *rtc_tm)
 {
 	int ret;
-	uint8_t v[5];
+	uint8_t v[2][5];
+	int idx = 1;
+	int timeout = DA9052_GET_TIME_RETRIES;
 
-	ret = da9052_group_read(rtc->da9052, DA9052_ALARM_MI_REG, 5, v);
-	if (ret != 0) {
+	ret = da9052_group_read(rtc->da9052, DA9052_ALARM_MI_REG, 5, &v[0][0]);
+	if (ret) {
 		rtc_err(rtc, "Failed to group read ALM: %d\n", ret);
 		return ret;
 	}
 
-	rtc_tm->tm_year = (v[4] & DA9052_RTC_YEAR) + 100;
-	rtc_tm->tm_mon  = (v[3] & DA9052_RTC_MONTH) - 1;
-	rtc_tm->tm_mday = v[2] & DA9052_RTC_DAY;
-	rtc_tm->tm_hour = v[1] & DA9052_RTC_HOUR;
-	rtc_tm->tm_min  = v[0] & DA9052_RTC_MIN;
+	do {
+		ret = da9052_group_read(rtc->da9052,
+					DA9052_ALARM_MI_REG, 5, &v[idx][0]);
+		if (ret) {
+			rtc_err(rtc, "Failed to group read ALM: %d\n", ret);
+			return ret;
+		}
+
+		if (memcmp(&v[0][0], &v[1][0], 5) == 0) {
+			rtc_tm->tm_year = (v[0][4] & DA9052_RTC_YEAR) + 100;
+			rtc_tm->tm_mon  = (v[0][3] & DA9052_RTC_MONTH) - 1;
+			rtc_tm->tm_mday = v[0][2] & DA9052_RTC_DAY;
+			rtc_tm->tm_hour = v[0][1] & DA9052_RTC_HOUR;
+			rtc_tm->tm_min  = v[0][0] & DA9052_RTC_MIN;
+
+			ret = rtc_valid_tm(rtc_tm);
+			return ret;
+		}
 
-	ret = rtc_valid_tm(rtc_tm);
-	return ret;
+		idx = (1-idx);
+		msleep(20);
+
+	} while (timeout--);
+
+	rtc_err(rtc, "Timed out reading alarm time\n");
+
+	return -EIO;
 }
 
 static int da9052_set_alarm(struct da9052_rtc *rtc, struct rtc_time *rtc_tm)
@@ -135,24 +159,45 @@ static int da9052_rtc_get_alarm_status(s
 static int da9052_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 {
 	struct da9052_rtc *rtc = dev_get_drvdata(dev);
-	uint8_t v[6];
 	int ret;
+	uint8_t v[2][6];
+	int idx = 1;
+	int timeout = DA9052_GET_TIME_RETRIES;
 
-	ret = da9052_group_read(rtc->da9052, DA9052_COUNT_S_REG, 6, v);
-	if (ret < 0) {
+	ret = da9052_group_read(rtc->da9052, DA9052_COUNT_S_REG, 6, &v[0][0]);
+	if (ret) {
 		rtc_err(rtc, "Failed to read RTC time : %d\n", ret);
 		return ret;
 	}
 
-	rtc_tm->tm_year = (v[5] & DA9052_RTC_YEAR) + 100;
-	rtc_tm->tm_mon  = (v[4] & DA9052_RTC_MONTH) - 1;
-	rtc_tm->tm_mday = v[3] & DA9052_RTC_DAY;
-	rtc_tm->tm_hour = v[2] & DA9052_RTC_HOUR;
-	rtc_tm->tm_min  = v[1] & DA9052_RTC_MIN;
-	rtc_tm->tm_sec  = v[0] & DA9052_RTC_SEC;
+	do {
+		ret = da9052_group_read(rtc->da9052,
+					DA9052_COUNT_S_REG, 6, &v[idx][0]);
+		if (ret) {
+			rtc_err(rtc, "Failed to read RTC time : %d\n", ret);
+			return ret;
+		}
+
+		if (memcmp(&v[0][0], &v[1][0], 6) == 0) {
+			rtc_tm->tm_year = (v[0][5] & DA9052_RTC_YEAR) + 100;
+			rtc_tm->tm_mon  = (v[0][4] & DA9052_RTC_MONTH) - 1;
+			rtc_tm->tm_mday = v[0][3] & DA9052_RTC_DAY;
+			rtc_tm->tm_hour = v[0][2] & DA9052_RTC_HOUR;
+			rtc_tm->tm_min  = v[0][1] & DA9052_RTC_MIN;
+			rtc_tm->tm_sec  = v[0][0] & DA9052_RTC_SEC;
+
+			ret = rtc_valid_tm(rtc_tm);
+			return ret;
+		}
 
-	ret = rtc_valid_tm(rtc_tm);
-	return ret;
+		idx = (1-idx);
+		msleep(20);
+
+	} while (timeout--);
+
+	rtc_err(rtc, "Timed out reading time\n");
+
+	return -EIO;
 }
 
 static int da9052_rtc_set_time(struct device *dev, struct rtc_time *tm)
_

Patches currently in -mm which might be from adam.ward.opensource@diasemi.com are

origin.patch

