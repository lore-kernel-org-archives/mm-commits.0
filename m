From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-isl1208c-call-rtc_update_irq-from-the-alarm-irq-handler.patch added to -mm tree
Date: Tue, 29 Jan 2013 16:02:27 -0800
Message-ID: <20130130000227.9110D5A42B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50279 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3A3AC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 19:02:29 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so101677vch.2
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 16:02:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlu@pengutronix.de, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-isl1208c-call-rtc_update_irq-from-the-alarm-irq-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Luebbe <jlu@pengutronix.de>
Subject: drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq handler

Previously the alarm event was not propagated into the RTC subsystem.  By
adding a call to rtc_update_irq, this fixes a timeout problem with the
hwclock utility.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
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

drivers-rtc-rtc-isl1208c-call-rtc_update_irq-from-the-alarm-irq-handler.patch

