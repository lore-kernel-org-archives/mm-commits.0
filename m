From: akpm@linux-foundation.org
Subject: [merged] rtc-hid-sensor-time-use-devm_rtc_device_register.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:57:25 -0700
Message-ID: <20130430185725.700A631C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:42402 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3D3S50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:57:26 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so86927vbf.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:57:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: hid-sensor-time: use devm_rtc_device_register()
has been removed from the -mm tree.  Its filename was
     rtc-hid-sensor-time-use-devm_rtc_device_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: hid-sensor-time: use devm_rtc_device_register()

devm_rtc_device_register() is device managed and makes cleanup paths
simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~rtc-hid-sensor-time-use-devm_rtc_device_register drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~rtc-hid-sensor-time-use-devm_rtc_device_register
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -255,8 +255,9 @@ static int hid_time_probe(struct platfor
 		return ret;
 	}
 
-	time_state->rtc = rtc_device_register("hid-sensor-time",
-				&pdev->dev, &hid_time_rtc_ops, THIS_MODULE);
+	time_state->rtc = devm_rtc_device_register(&pdev->dev,
+					"hid-sensor-time", &hid_time_rtc_ops,
+					THIS_MODULE);
 
 	if (IS_ERR(time_state->rtc)) {
 		dev_err(&pdev->dev, "rtc device register failed!\n");
@@ -269,9 +270,7 @@ static int hid_time_probe(struct platfor
 static int hid_time_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
-	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(time_state->rtc);
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
 	return 0;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

