From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails.patch added to -mm tree
Date: Thu, 08 Aug 2013 15:11:23 -0700
Message-ID: <5204178b.ND5IYMAmuBXEisV8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab3HHWL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Aug 2013 18:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, holler@ahsoftware.de

Subject: + drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails.patch added to -mm tree
To: holler@ahsoftware.de
From: akpm@linux-foundation.org
Date: Thu, 08 Aug 2013 15:11:23 -0700


The patch titled
     Subject: drivers/rtc/rtc-hid-sensor-time.c: improve error handling when rtc register fails
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails.patch

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
Subject: drivers/rtc/rtc-hid-sensor-time.c: improve error handling when rtc register fails

Stop processing hid input when registering the RTC fails and handle a NULL
returned from devm_rtc_device_register() as a failure too.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-hid-sensor-time.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -279,9 +279,11 @@ static int hid_time_probe(struct platfor
 					"hid-sensor-time", &hid_time_rtc_ops,
 					THIS_MODULE);
 
-	if (IS_ERR(time_state->rtc)) {
+	if (IS_ERR_OR_NULL(time_state->rtc)) {
+		ret = time_state->rtc ? PTR_ERR(time_state->rtc) : -ENODEV;
+		time_state->rtc = NULL;
+		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 		dev_err(&pdev->dev, "rtc device register failed!\n");
-		return PTR_ERR(time_state->rtc);
 	}
 
 	return ret;
_

Patches currently in -mm which might be from holler@ahsoftware.de are

drivers-rtc-rtc-hid-sensor-timec-add-module-alias-to-let-the-module-load-automatically.patch
drivers-rtc-rtc-hid-sensor-timec-improve-error-handling-when-rtc-register-fails.patch
drivers-rtc-rtc-hid-sensor-timec-enable-hid-input-processing-early.patch
linux-next.patch

