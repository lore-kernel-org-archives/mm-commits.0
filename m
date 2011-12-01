From: akpm@linux-foundation.org
Subject: [to-be-updated] rtc-ab8500-change-to-mdelay.patch removed from -mm tree
Date: Thu, 01 Dec 2011 13:35:46 -0800
Message-ID: <201112012135.pB1LZkkx021026@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:37439 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1LAVf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 16:35:56 -0500
Received: by vcbfl11 with SMTP id fl11so314982vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 13:35:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jonas.aberg@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc/ab8500: change to mdelay
has been removed from the -mm tree.  Its filename was
     rtc-ab8500-change-to-mdelay.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: rtc/ab8500: change to mdelay

The resolution of msleep is related to HZ, so with HZ set to 100 any
msleep of less than 10ms will become ~10ms.  This does not work for us, so
stick to mdelay(1).

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-change-to-mdelay drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-change-to-mdelay
+++ a/drivers/rtc/rtc-ab8500.c
@@ -90,7 +90,7 @@ static int ab8500_rtc_read_time(struct d
 
 	/* Early AB8500 chips will not clear the rtc read request bit */
 	if (abx500_get_chip_id(dev) == 0) {
-		msleep(1);
+		mdelay(1);
 	} else {
 		/* Wait for some cycles after enabling the rtc read in ab8500 */
 		while (time_before(jiffies, timeout)) {
@@ -102,7 +102,7 @@ static int ab8500_rtc_read_time(struct d
 			if (!(value & RTC_READ_REQUEST))
 				break;
 
-			msleep(1);
+			mdelay(1);
 		}
 	}
 
@@ -295,7 +295,7 @@ static int __devinit ab8500_rtc_probe(st
 		return err;
 
 	/* Wait for reset by the PorRtc */
-	msleep(1);
+	mdelay(1);
 
 	err = abx500_get_register_interruptible(&pdev->dev, AB8500_RTC,
 		AB8500_RTC_STAT_REG, &rtc_ctrl);
_

Patches currently in -mm which might be from jonas.aberg@stericsson.com are

rtc-ab8500-set-can_wake-flag.patch
rtc-ab8500-change-to-msleep-to-usleep_range.patch

