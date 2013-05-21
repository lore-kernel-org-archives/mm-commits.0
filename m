From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch added
 to -mm tree
Date: Tue, 21 May 2013 14:42:41 -0700
Message-ID: <519bea51.dZp9kl/yHcR3wgZp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3EUVmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 May 2013 17:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lars@metafoo.de, john.stultz@linaro.org, jkosina@suse.cz, jic23@cam.ac.uk, jg1.han@samsung.com, a.zummo@towertech.it, holler@ahsoftware.de

Subject: + rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch added to -mm tree
To: holler@ahsoftware.de,a.zummo@towertech.it,jg1.han@samsung.com,jic23@cam.ac.uk,jkosina@suse.cz,john.stultz@linaro.org,lars@metafoo.de
From: akpm@linux-foundation.org
Date: Tue, 21 May 2013 14:42:41 -0700


The patch titled
     Subject: rtc: rtc-hid-sensor-time: allow full years (16bit) in HID reports
has been added to the -mm tree.  Its filename is
     rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch

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

rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch

