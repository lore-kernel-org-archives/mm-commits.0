From: akpm@linux-foundation.org
Subject: + rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch
 added to -mm tree
Date: Tue, 21 May 2013 14:42:44 -0700
Message-ID: <519bea54.AhUuBcAj1/k9AH5r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3EUVmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 17:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lars@metafoo.de, john.stultz@linaro.org, jkosina@suse.cz, jic23@cam.ac.uk, jg1.han@samsung.com, a.zummo@towertech.it, holler@ahsoftware.de

Subject: + rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch added to -mm tree
To: holler@ahsoftware.de,a.zummo@towertech.it,jg1.han@samsung.com,jic23@cam.ac.uk,jkosina@suse.cz,john.stultz@linaro.org,lars@metafoo.de
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 14:42:44 -0700


The patch titled
     Subject: rtc: rtc-hid-sensor-time: add support for milliseconds
has been added to the -mm tree.  Its filename is
     rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: rtc: rtc-hid-sensor-time: add support for milliseconds

If a device sends milliseconds too, the driver will use them if it sets
the system clock at startup (through module option hctosys).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |   37 ++++++++++++++++++++++++----
 include/linux/hid-sensor-ids.h    |    1 
 2 files changed, 34 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-add-support-for-milliseconds drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-add-support-for-milliseconds
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -40,6 +40,7 @@ enum hid_time_channel {
 	CHANNEL_SCAN_INDEX_HOUR,
 	CHANNEL_SCAN_INDEX_MINUTE,
 	CHANNEL_SCAN_INDEX_SECOND,
+	CHANNEL_SCAN_INDEX_MILLISECOND, /* optional */
 	TIME_RTC_CHANNEL_MAX,
 };
 
@@ -53,9 +54,11 @@ struct hid_time_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info info[TIME_RTC_CHANNEL_MAX];
 	struct rtc_time last_time;
+	unsigned last_ms; /* == UINT_MAX to indicate ms aren't supported */
 	spinlock_t lock_last_time;
 	struct completion comp_last_time;
 	struct rtc_time time_buf;
+	unsigned ms_buf;
 	struct rtc_device *rtc;
 	struct hid_time_workts *workts;
 };
@@ -67,16 +70,18 @@ static const u32 hid_time_addresses[TIME
 	HID_USAGE_SENSOR_TIME_HOUR,
 	HID_USAGE_SENSOR_TIME_MINUTE,
 	HID_USAGE_SENSOR_TIME_SECOND,
+	HID_USAGE_SENSOR_TIME_MILLISECOND, /* optional */
 };
 
 /* Channel names for verbose error messages */
 static const char * const hid_time_channel_names[TIME_RTC_CHANNEL_MAX] = {
-	"year", "month", "day", "hour", "minute", "second",
+	"year", "month", "day", "hour", "minute", "second", "millisecond",
 };
 
 static void hid_time_hctosys(struct hid_time_state *time_state)
 {
 	struct timespec ts;
+	char msbuf[5];
 	int rc = rtc_valid_tm(&time_state->last_time);
 
 	if (rc) {
@@ -102,18 +107,25 @@ static void hid_time_hctosys(struct hid_
 		 */
 		return;
 
-	ts.tv_nsec = NSEC_PER_SEC >> 1;
+	if (time_state->last_ms != UINT_MAX) {
+		ts.tv_nsec = time_state->last_ms * NSEC_PER_MSEC;
+		snprintf(msbuf, sizeof(msbuf), ":%03d", time_state->last_ms);
+	} else {
+		ts.tv_nsec = NSEC_PER_SEC >> 1;
+		*msbuf = 0;
+	}
 	rtc_tm_to_time(&time_state->last_time, &ts.tv_sec);
 	rc = do_settimeofday(&ts);
 	dev_info(time_state->rtc->dev.parent,
 		"hctosys: setting system clock to "
-		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+		"%d-%02d-%02d %02d:%02d:%02d%s UTC (%u)\n",
 		time_state->last_time.tm_year + 1900,
 		time_state->last_time.tm_mon + 1,
 		time_state->last_time.tm_mday,
 		time_state->last_time.tm_hour,
 		time_state->last_time.tm_min,
 		time_state->last_time.tm_sec,
+		msbuf,
 		(unsigned int) ts.tv_sec);
 }
 
@@ -126,6 +138,8 @@ static int hid_time_proc_event(struct hi
 
 	spin_lock_irqsave(&time_state->lock_last_time, flags);
 	time_state->last_time = time_state->time_buf;
+	if (time_state->last_ms != UINT_MAX)
+		time_state->last_ms = time_state->ms_buf;
 	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
 	complete(&time_state->comp_last_time);
 	if (unlikely(!hid_time_time_set_once && hid_time_hctosys_enabled)) {
@@ -188,6 +202,9 @@ static int hid_time_capture_sample(struc
 	case HID_USAGE_SENSOR_TIME_SECOND:
 		time_buf->tm_sec = (int)hid_time_value(raw_len, raw_data);
 		break;
+	case HID_USAGE_SENSOR_TIME_MILLISECOND:
+		time_state->ms_buf = hid_time_value(raw_len, raw_data);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -214,12 +231,18 @@ static int hid_time_parse_report(struct
 {
 	int report_id, i;
 
-	for (i = 0; i < TIME_RTC_CHANNEL_MAX; ++i)
+	/* Check if all required attributes are available */
+	for (i = 0; i < CHANNEL_SCAN_INDEX_MILLISECOND; ++i)
 		if (sensor_hub_input_get_attribute_info(hsdev,
 				HID_INPUT_REPORT, usage_id,
 				hid_time_addresses[i],
 				&time_state->info[i]) < 0)
 			return -EINVAL;
+	if (!sensor_hub_input_get_attribute_info(hsdev, HID_INPUT_REPORT,
+		usage_id, hid_time_addresses[i], &time_state->info[i])) {
+		dev_info(&pdev->dev, "milliseconds supported\n");
+		time_state->last_ms = 0;
+	}
 	/* Check the (needed) attributes for sanity */
 	report_id = time_state->info[0].report_id;
 	if (report_id < 0) {
@@ -227,6 +250,10 @@ static int hid_time_parse_report(struct
 		return -EINVAL;
 	}
 	for (i = 0; i < TIME_RTC_CHANNEL_MAX; ++i) {
+		if (time_state->info[i].attrib_id ==
+				HID_USAGE_SENSOR_TIME_MILLISECOND &&
+				time_state->last_ms == UINT_MAX)
+			continue;
 		if (time_state->info[i].report_id != report_id) {
 			dev_err(&pdev->dev,
 				"not all needed attributes inside the same report!\n");
@@ -319,6 +346,8 @@ static int hid_time_probe(struct platfor
 	if (time_state == NULL)
 		return -ENOMEM;
 
+	time_state->last_ms = UINT_MAX;
+
 	platform_set_drvdata(pdev, time_state);
 
 	spin_lock_init(&time_state->lock_last_time);
diff -puN include/linux/hid-sensor-ids.h~rtc-rtc-hid-sensor-time-add-support-for-milliseconds include/linux/hid-sensor-ids.h
--- a/include/linux/hid-sensor-ids.h~rtc-rtc-hid-sensor-time-add-support-for-milliseconds
+++ a/include/linux/hid-sensor-ids.h
@@ -74,6 +74,7 @@
 #define HID_USAGE_SENSOR_TIME_HOUR				0x200525
 #define HID_USAGE_SENSOR_TIME_MINUTE				0x200526
 #define HID_USAGE_SENSOR_TIME_SECOND				0x200527
+#define HID_USAGE_SENSOR_TIME_MILLISECOND			0x200528
 
 /* Units */
 #define HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED			0x00
_

Patches currently in -mm which might be from holler@ahsoftware.de are

rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch

