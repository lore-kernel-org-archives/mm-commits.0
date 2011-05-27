From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device.patch added to -mm tree
Date: Fri, 27 May 2011 16:48:10 -0700
Message-ID: <201105272348.p4RNmAUH029243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757046Ab1E0XtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 19:49:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, a.zummo@towertech.it, johnstul@us.ibm.com, shawn.guo@freescale.com


The patch titled
     drivers/rtc/rtc-stmp3xxx.c: Initialize drvdata before registering device
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-stmp3xxx.c: Initialize drvdata before registering device
From: Wolfram Sang <w.sang@pengutronix.de>

Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") uncovered an
issue in a number of RTC drivers, where the drivers call
rtc_device_register before initializing the device or platform drvdata.

This frequently results in null pointer dereferences when the
rtc_device_register immediately makes use of the rtc device, calling
rtc_read_alarm.

The solution is to ensure the drvdata is initialized prior to registering
the rtc device.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Tested-by: Shawn Guo <shawn.guo@freescale.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -172,6 +172,7 @@ static int stmp3xxx_rtc_remove(struct pl
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
 	free_irq(rtc_data->irq_1msec, &pdev->dev);
 	rtc_device_unregister(rtc_data->rtc);
+	platform_set_drvdata(pdev, NULL);
 	iounmap(rtc_data->io);
 	kfree(rtc_data);
 
@@ -212,11 +213,14 @@ static int stmp3xxx_rtc_probe(struct pla
 		goto out_remap;
 	}
 
+	platform_set_drvdata(pdev, rtc_data);
+
 	mxs_reset_block(rtc_data->io);
 	__mxs_clrl(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0);
+
 	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_data->rtc)) {
@@ -240,8 +244,6 @@ static int stmp3xxx_rtc_probe(struct pla
 		goto out_irq1;
 	}
 
-	platform_set_drvdata(pdev, rtc_data);
-
 	return 0;
 
 out_irq1:
@@ -251,6 +253,7 @@ out_irq_alarm:
 			rtc_data->io + STMP3XXX_RTC_CTRL);
 	rtc_device_unregister(rtc_data->rtc);
 out_remap:
+	platform_set_drvdata(pdev, NULL);
 	iounmap(rtc_data->io);
 out_free:
 	kfree(rtc_data);
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
rtc-driver-for-pt7c4338-chip.patch
drivers-rtc-rtc-stmp3xxxc-get-rid-of-platform-specific-include-for-register-names.patch
drivers-rtc-rtc-stmp3xxxc-port-stmp-functions-to-mxs-equivalents.patch
drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device.patch
drivers-rtc-rtc-stmp3xxxc-get-rid-of-mach-specific-accessors.patch
drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers.patch
gpio-make-gpio_requestfree_array-gpio-array-parameter-const.patch

