From: akpm@linux-foundation.org
Subject: [merged]
 rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:14 -0700
Message-ID: <51db13fa.SLRRQEZTjDbQgx96%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lars@metafoo.de, john.stultz@linaro.org, jkosina@suse.cz, jic23@cam.ac.uk, jg1.han@samsung.com, a.zummo@towertech.it, holler@ahsoftware.de

Subject: [merged] rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch removed from -mm tree
To: holler@ahsoftware.de,a.zummo@towertech.it,jg1.han@samsung.com,jic23@cam.ac.uk,jkosina@suse.cz,john.stultz@linaro.org,lars@metafoo.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:14 -0700


The patch titled
     Subject: rtc: rtc-hid-sensor-time: allow full years (16bit) in HID reports
has been removed from the -mm tree.  Its filename was
     rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: rtc: rtc-hid-sensor-time: allow full years (16bit) in HID reports

The draft for HID-sensors (HUTRR39) currently doesn't define the range for
the attribute year.  Asking one of the authors revealed that full years
(e.g.  2013 instead of just 13) were meant.

So we now allow both, 8 bit and 16 bit values for the attribute year and
assuming full years when the value is 16 bits wide.

We will still support 8 bit values until the specification gets final
(and maybe defines a way to set the time too).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |   33 ++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -85,10 +85,13 @@ static int hid_time_capture_sample(struc
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_TIME_YEAR:
-		time_buf->tm_year = *(u8 *)raw_data;
-		if (time_buf->tm_year < 70)
-			/* assume we are in 1970...2069 */
-			time_buf->tm_year += 100;
+		if (raw_len == 1) {
+			time_buf->tm_year = *(u8 *)raw_data;
+			if (time_buf->tm_year < 70)
+				/* assume we are in 1970...2069 */
+				time_buf->tm_year += 100;
+		} else
+			time_buf->tm_year = *(u16 *)raw_data-1900;
 		break;
 	case HID_USAGE_SENSOR_TIME_MONTH:
 		/* sensor sending the month as 1-12, we need 0-11 */
@@ -151,11 +154,27 @@ static int hid_time_parse_report(struct
 			return -EINVAL;
 		}
 		if (time_state->info[i].size != 1) {
-			dev_err(&pdev->dev,
-				"attribute '%s' not 8 bits wide!\n",
+			/*
+			 * The draft for HID-sensors (HUTRR39) currently
+			 * doesn't define the range for the year attribute.
+			 * Therefor we support both 8 bit (0-99) and 16 bit
+			 * (full) as size for the year.
+			 */
+			if (time_state->info[i].attrib_id !=
+				HID_USAGE_SENSOR_TIME_YEAR) {
+				dev_err(&pdev->dev,
+					"attribute '%s' not 8 bits wide!\n",
 				hid_time_attrib_name(
 					time_state->info[i].attrib_id));
-			return -EINVAL;
+				return -EINVAL;
+			}
+			if (time_state->info[i].size != 2) {
+				dev_err(&pdev->dev,
+					"attribute '%s' not 8 or 16 bits wide!\n",
+				hid_time_attrib_name(
+					time_state->info[i].attrib_id));
+				return -EINVAL;
+			}
 		}
 		if (time_state->info[i].units !=
 				HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED &&
_

Patches currently in -mm which might be from holler@ahsoftware.de are

origin.patch

