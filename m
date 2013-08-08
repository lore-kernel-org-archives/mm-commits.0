From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch
 added to -mm tree
Date: Thu, 08 Aug 2013 15:11:24 -0700
Message-ID: <5204178c.Upto9qBXf9pjquMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3HHWLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 18:11:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holler@ahsoftware.de

Subject: + drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch added to -mm tree
To: holler@ahsoftware.de
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 15:11:24 -0700


The patch titled
     Subject: drivers/rtc/rtc-hid-sensor-time.c: enable HID input processing early
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch

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
@@ -275,11 +275,18 @@ static int hid_time_probe(struct platfor
 		return ret;
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
 		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
_

Patches currently in -mm which might be from holler@ahsoftware.de are

drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch
drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails.patch
drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch
linux-next.patch

