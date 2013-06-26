From: akpm@linux-foundation.org
Subject: [to-be-updated]
 rtc-rtc-hid-sensor-time-delay-registering-as-rtc-into-a-work.patch removed
 from -mm tree
Date: Wed, 26 Jun 2013 14:41:59 -0700
Message-ID: <51cb6027./Vo57m3CgrdgFRoH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3FZVl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jun 2013 17:41:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holler@ahsoftware.de

Subject: [to-be-updated] rtc-rtc-hid-sensor-time-delay-registering-as-rtc-into-a-work.patch removed from -mm tree
To: holler@ahsoftware.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 26 Jun 2013 14:41:59 -0700


The patch titled
     Subject: drivers/rtc/rtc-hid-sensor-time.c: delay registering as rtc into a work
has been removed from the -mm tree.  Its filename was
     rtc-rtc-hid-sensor-time-delay-registering-as-rtc-into-a-work.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: drivers/rtc/rtc-hid-sensor-time.c: delay registering as rtc into a work

rtc_device_register() might want to read the clock which doesn't work
before the hid device is registered.  Therefor we delay the registration
of the rtc driver by moving it to a work.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |   64 ++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-delay-registering-as-rtc-into-a-work drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~rtc-rtc-hid-sensor-time-delay-registering-as-rtc-into-a-work
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -37,6 +37,11 @@ enum hid_time_channel {
 	TIME_RTC_CHANNEL_MAX,
 };
 
+struct hid_time_workts {
+	struct work_struct work;
+	struct hid_time_state *time_state;
+};
+
 struct hid_time_state {
 	struct hid_sensor_hub_callbacks callbacks;
 	struct hid_sensor_common common_attributes;
@@ -46,6 +51,7 @@ struct hid_time_state {
 	struct completion comp_last_time;
 	struct rtc_time time_buf;
 	struct rtc_device *rtc;
+	struct hid_time_workts *workts;
 };
 
 static const u32 hid_time_addresses[TIME_RTC_CHANNEL_MAX] = {
@@ -237,6 +243,36 @@ static const struct rtc_class_ops hid_ti
 	.read_time = hid_rtc_read_time,
 };
 
+static void hid_time_register_rtc_work(struct work_struct *work)
+{
+	struct hid_time_state *time_state =
+		container_of(work, struct hid_time_workts, work)
+			->time_state;
+	struct platform_device *pdev = time_state->callbacks.pdev;
+
+	time_state->rtc = devm_rtc_device_register(&pdev->dev,
+					"hid-sensor-time", &hid_time_rtc_ops,
+					THIS_MODULE);
+	if (IS_ERR_OR_NULL(time_state->rtc)) {
+		struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
+		time_state->rtc = NULL;
+		dev_err(&pdev->dev, "rtc device register failed!\n");
+		/*
+		 *  I haven't a found a way to remove only this device from
+		 *  hid-sensor-hub. Removing the device a level above (the
+		 *  complete HID device) doesn't work, because a sensor-hub
+		 *  might provide more than just a time-sensor and thus we
+		 *  would remove all sensors not just this one.
+		 *  So we just leave this driver idling around until I or
+		 *  someone else has figured out how to remove this device
+		 *  from hid-sensor-hub.
+		 */
+	}
+	time_state->workts = NULL;
+	kfree(work);
+}
+
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -279,22 +315,34 @@ static int hid_time_probe(struct platfor
 		return ret;
 	}
 
-	time_state->rtc = devm_rtc_device_register(&pdev->dev,
-					"hid-sensor-time", &hid_time_rtc_ops,
-					THIS_MODULE);
-
-	if (IS_ERR(time_state->rtc)) {
-		dev_err(&pdev->dev, "rtc device register failed!\n");
-		return PTR_ERR(time_state->rtc);
+	/*
+	 * The HID device has to be registered to read the clock.
+	 * Because rtc_device_register() might read the time, we have to delay
+	 * rtc_device_register() to a work in order to finish the probe before.
+	 */
+	time_state->workts = kmalloc(sizeof(struct hid_time_workts),
+		GFP_KERNEL);
+	if (time_state->workts == NULL) {
+		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
+		return -ENOMEM;
 	}
+	time_state->workts->time_state = time_state;
+	INIT_WORK(&time_state->workts->work,
+			hid_time_register_rtc_work);
+	schedule_work(&time_state->workts->work);
 
-	return ret;
+	return 0;
 }
 
 static int hid_time_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
+	if (time_state->workts) {
+		flush_work(&time_state->workts->work);
+		WARN_ON(time_state->workts != NULL);
+	}
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
 	return 0;
_

Patches currently in -mm which might be from holler@ahsoftware.de are

rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-delay-registering-as-rtc-into-a-work-fix.patch

