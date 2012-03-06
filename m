From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:35:08 -0800
Message-ID: <20120306193508.53AA6A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:33122 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648Ab2CFTfK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:35:10 -0500
Received: by mail-lpp01m010-f74.google.com with SMTP id i8so203276laa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:35:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-r9701.c: fix crash in r9701_remove()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Anatolij Gustschin <agust@denx.de>
Subject: drivers/rtc/rtc-r9701.c: fix crash in r9701_remove()

If probing the RTC didn't succeed due to failed RTC register access, the
RTC device will be unregistered.  Then, when removing the module
r9701_remove() causes a kernel crash while trying to unregister a not
registered RTC device.  Fix this by doing RTC register access test before
RTC device registration.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-r9701.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~drivers-rtc-rtc-r9701c-fix-crash-in-r9701_remove
+++ a/drivers/rtc/rtc-r9701.c
@@ -125,6 +125,13 @@ static int __devinit r9701_probe(struct 
 	unsigned char tmp;
 	int res;
 
+	tmp = R100CNT;
+	res = read_regs(&spi->dev, &tmp, 1);
+	if (res || tmp != 0x20) {
+		dev_err(&spi->dev, "cannot read RTC register\n");
+		return -ENODEV;
+	}
+
 	rtc = rtc_device_register("r9701",
 				&spi->dev, &r9701_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
@@ -132,13 +139,6 @@ static int __devinit r9701_probe(struct 
 
 	dev_set_drvdata(&spi->dev, rtc);
 
-	tmp = R100CNT;
-	res = read_regs(&spi->dev, &tmp, 1);
-	if (res || tmp != 0x20) {
-		rtc_device_unregister(rtc);
-		return res;
-	}
