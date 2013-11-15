From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:03 -0800
Message-ID: <52867f5f.WxAa1C4sWoHb4WGS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3KOUJD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holler@ahsoftware.de

Subject: [merged] drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch removed from -mm tree
To: holler@ahsoftware.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:03 -0800


The patch titled
     Subject: drivers/rtc/rtc-hid-sensor-time.c: enable HID input processing early
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Holler <holler@ahsoftware.de>
Subject: drivers/rtc/rtc-hid-sensor-time.c: enable HID input processing early

Enable the processing of HID input records before the RTC will be
registered, in order to allow the RTC register function to read clock. 
Without doing that the clock can only be read after the probe function has
finished.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -281,11 +281,18 @@ static int hid_time_probe(struct platfor
 		goto err_open;
 	}
 
+	/*
+	 * Enable HID input processing early in order to be able to read the
+	 * clock already in devm_rtc_device_register().
+	 */
+	hid_device_io_start(hsdev->hdev);
+
 	time_state->rtc = devm_rtc_device_register(&pdev->dev,
 					"hid-sensor-time", &hid_time_rtc_ops,
 					THIS_MODULE);
 
 	if (IS_ERR_OR_NULL(time_state->rtc)) {
+		hid_device_io_stop(hsdev->hdev);
 		ret = time_state->rtc ? PTR_ERR(time_state->rtc) : -ENODEV;
 		time_state->rtc = NULL;
 		dev_err(&pdev->dev, "rtc device register failed!\n");
_

Patches currently in -mm which might be from holler@ahsoftware.de are

origin.patch
linux-next.patch

