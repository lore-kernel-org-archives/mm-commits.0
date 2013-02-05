From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-isl1208c-call-rtc_update_irq-from-the-alarm-irq-handler.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:39 -0800
Message-ID: <20130205202039.A1AF431C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:65421 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3BEUUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:40 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so65665ghb.4
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlu@pengutronix.de, a.zummo@towertech.it, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-isl1208c-call-rtc_update_irq-from-the-alarm-irq-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler

Previously the alarm event was not propagated into the RTC subsystem.  By
adding a call to rtc_update_irq, this fixes a timeout problem with the
hwclock utility.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-call-rtc_update_irq-from-the-alarm-irq-handler drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~drivers-rtc-rtc-isl1208c-call-rtc_update_irq-from-the-alarm-irq-handler
+++ a/drivers/rtc/rtc-isl1208.c
@@ -506,6 +506,7 @@ isl1208_rtc_interrupt(int irq, void *dat
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	struct i2c_client *client = data;
+	struct rtc_device *rtc = i2c_get_clientdata(client);
 	int handled = 0, sr, err;
 
 	/*
@@ -528,6 +529,8 @@ isl1208_rtc_interrupt(int irq, void *dat
 	if (sr & ISL1208_REG_SR_ALM) {
 		dev_dbg(&client->dev, "alarm!\n");
 
+		rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
 		/* Clear the alarm */
 		sr &= ~ISL1208_REG_SR_ALM;
 		sr = i2c_smbus_write_byte_data(client, ISL1208_REG_SR, sr);
_

Patches currently in -mm which might be from jlu@pengutronix.de are

origin.patch

