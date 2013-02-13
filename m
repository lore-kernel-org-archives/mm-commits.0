From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pl031c-restore-st-variant-functionality.patch removed from -mm tree
Date: Wed, 13 Feb 2013 12:35:54 -0800
Message-ID: <20130213203554.BFBCD31C26F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:52032 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3BMUf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 15:35:56 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so886954ghb.5
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 12:35:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, a.zummo@towertech.it, haojian.zhuang@gmail.com, mian.yousaf.kaukab@stericsson.com, srinidhi.kasagar@stericsson.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: restore ST variant functionality
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pl031c-restore-st-variant-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Linus Walleij <linus.walleij@linaro.org>
Subject: drivers/rtc/rtc-pl031.c: restore ST variant functionality

e7e034e18a0ab ("drivers/rtc/rtc-pl031.c: fix the missing operation on
enable") accidentally broke the ST variants of PL031.

The bit that is being poked as "clockwatch" enable bit for the ST variants
does the work of bit 0 on this variant.  Bit 0 is used for a clock divider
on the ST variants, and setting it to 1 will affect timekeeping in a real
bad way.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-restore-st-variant-functionality drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-restore-st-variant-functionality
+++ a/drivers/rtc/rtc-pl031.c
@@ -350,7 +350,9 @@ static int pl031_probe(struct amba_devic
 	/* Enable the clockwatch on ST Variants */
 	if (vendor->clockwatch)
 		data |= RTC_CR_CWEN;
-	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
+	else
+		data |= RTC_CR_EN;
+	writel(data, ldata->base + RTC_CR);
 
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct
_

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch
rtc-pl031-add-wake-up-support.patch
gpio-convert-to-idr_alloc.patch

