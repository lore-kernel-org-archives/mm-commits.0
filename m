From: akpm@linux-foundation.org
Subject: + rtc-ab8500-change-to-mdelay.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:13:00 -0800
Message-ID: <201111282313.pASND0Tj023727@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57459 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1K1XNE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:13:04 -0500
Received: by ywb26 with SMTP id 26so513298ywb.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:13:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jonas.aberg@stericsson.com, a.zummo@towertech.it, linus.walleij@linaro.org


The patch titled
     Subject: rtc/ab8500: change to mdelay
has been added to the -mm tree.  Its filename is
     rtc-ab8500-change-to-mdelay.patch

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
Subject: Subject: rtc/ab8500: change to mdelay

Patches currently in -mm which might be from jonas.aberg@stericsson.com are

rtc-ab8500-set-can_wake-flag.patch
rtc-ab8500-change-to-mdelay.patch

