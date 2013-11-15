From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:09:01 -0800
Message-ID: <52867f5d.VpUFywnIerxBkkXg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3KOUJC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:01 -0800


The patch titled
     Subject: drivers/rtc/rtc-hid-sensor-time.c: use dev_get_platdata()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-hid-sensor-time.c: use dev_get_platdata()

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.  This is a cosmetic change to make
the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -236,7 +236,7 @@ static const struct rtc_class_ops hid_ti
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_sensor_hub_device *hsdev = dev_get_platdata(&pdev->dev);
 	struct hid_time_state *time_state = devm_kzalloc(&pdev->dev,
 		sizeof(struct hid_time_state), GFP_KERNEL);
 
@@ -303,7 +303,7 @@ err_open:
 
 static int hid_time_remove(struct platform_device *pdev)
 {
-	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_sensor_hub_device *hsdev = dev_get_platdata(&pdev->dev);
 
 	sensor_hub_device_close(hsdev);
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
linux-next.patch

