From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device.patch removed from -mm tree
Date: Fri, 03 Jun 2011 16:08:44 -0700
Message-ID: <201106032308.p53N8iFG013282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab1FCXJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, a.zummo@towertech.it, johnstul@us.ibm.com, shawn.guo@freescale.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-stmp3xxx.c: Initialize drvdata before registering device
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-stmp3xxxc-initialize-drvdata-before-registering-device.patch

This patch was dropped because an updated version will be merged

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
