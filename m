From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch added to -mm tree
Date: Tue, 21 May 2013 14:42:42 -0700
Message-ID: <519bea52.FFZ/NzOjZWIe/xv7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3EUVmn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 17:42:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lars@metafoo.de, john.stultz@linaro.org, jkosina@suse.cz, jic23@cam.ac.uk, jg1.han@samsung.com, a.zummo@towertech.it, holler@ahsoftware.de

Subject: + rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch added to -mm tree
To: holler@ahsoftware.de,a.zummo@towertech.it,jg1.han@samsung.com,jic23@cam.ac.uk,jkosina@suse.cz,john.stultz@linaro.org,lars@metafoo.de
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 14:42:42 -0700


The patch titled
     Subject: rtc: rtc-hid-sensor-time: allow 16 and 32 bit values for all attributes.
has been added to the -mm tree.  Its filename is
     rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch

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
Subject: rtc: rtc-hid-sensor-time: allow 16 and 32 bit values for all attributes.

There is no real reason to not support 16 or 32 bit values too.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |   59 +++++++++++++++-------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -76,6 +76,20 @@ static int hid_time_proc_event(struct hi
 	return 0;
 }
 
+static u32 hid_time_value(size_t raw_len, char *raw_data)
+{
+	switch (raw_len) {
+	case 1:
+		return *(u8 *)raw_data;
+	case 2:
+		return *(u16 *)raw_data;
+	case 4:
+		return *(u32 *)raw_data;
+	default:
+		return (u32)(~0U); /* 0xff... or -1 to denote an error */
+	}
+}
+
 static int hid_time_capture_sample(struct hid_sensor_hub_device *hsdev,
 				unsigned usage_id, size_t raw_len,
 				char *raw_data, void *priv)
@@ -85,29 +99,35 @@ static int hid_time_capture_sample(struc
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_TIME_YEAR:
+		/*
+		 * The draft for HID-sensors (HUTRR39) currently doesn't define
+		 * the range for the year attribute. Therefor we support
+		 * 8 bit (0-99) and 16 or 32 bits (full) as size for the year.
+		 */
 		if (raw_len == 1) {
 			time_buf->tm_year = *(u8 *)raw_data;
 			if (time_buf->tm_year < 70)
 				/* assume we are in 1970...2069 */
 				time_buf->tm_year += 100;
 		} else
-			time_buf->tm_year = *(u16 *)raw_data-1900;
+			time_buf->tm_year =
+				(int)hid_time_value(raw_len, raw_data)-1900;
 		break;
 	case HID_USAGE_SENSOR_TIME_MONTH:
-		/* sensor sending the month as 1-12, we need 0-11 */
-		time_buf->tm_mon = *(u8 *)raw_data-1;
+		/* sensors are sending the month as 1-12, we need 0-11 */
+		time_buf->tm_mon = (int)hid_time_value(raw_len, raw_data)-1;
 		break;
 	case HID_USAGE_SENSOR_TIME_DAY:
-		time_buf->tm_mday = *(u8 *)raw_data;
+		time_buf->tm_mday = (int)hid_time_value(raw_len, raw_data);
 		break;
 	case HID_USAGE_SENSOR_TIME_HOUR:
-		time_buf->tm_hour = *(u8 *)raw_data;
+		time_buf->tm_hour = (int)hid_time_value(raw_len, raw_data);
 		break;
 	case HID_USAGE_SENSOR_TIME_MINUTE:
-		time_buf->tm_min = *(u8 *)raw_data;
+		time_buf->tm_min = (int)hid_time_value(raw_len, raw_data);
 		break;
 	case HID_USAGE_SENSOR_TIME_SECOND:
-		time_buf->tm_sec = *(u8 *)raw_data;
+		time_buf->tm_sec = (int)hid_time_value(raw_len, raw_data);
 		break;
 	default:
 		return -EINVAL;
@@ -153,28 +173,13 @@ static int hid_time_parse_report(struct
 				"not all needed attributes inside the same report!\n");
 			return -EINVAL;
 		}
-		if (time_state->info[i].size != 1) {
-			/*
-			 * The draft for HID-sensors (HUTRR39) currently
-			 * doesn't define the range for the year attribute.
-			 * Therefor we support both 8 bit (0-99) and 16 bit
-			 * (full) as size for the year.
-			 */
-			if (time_state->info[i].attrib_id !=
-				HID_USAGE_SENSOR_TIME_YEAR) {
-				dev_err(&pdev->dev,
-					"attribute '%s' not 8 bits wide!\n",
-				hid_time_attrib_name(
-					time_state->info[i].attrib_id));
-				return -EINVAL;
-			}
-			if (time_state->info[i].size != 2) {
-				dev_err(&pdev->dev,
-					"attribute '%s' not 8 or 16 bits wide!\n",
+		if (time_state->info[i].size == 3 ||
+				time_state->info[i].size > 4) {
+			dev_err(&pdev->dev,
+				"attribute '%s' not 8, 16 or 32 bits wide!\n",
 				hid_time_attrib_name(
 					time_state->info[i].attrib_id));
-				return -EINVAL;
-			}
+			return -EINVAL;
 		}
 		if (time_state->info[i].units !=
 				HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED &&
_

Patches currently in -mm which might be from holler@ahsoftware.de are

rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch

