From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pl031c-restore-st-variant-functionality.patch added to -mm tree
Date: Tue, 05 Feb 2013 13:59:32 -0800
Message-ID: <20130205215932.A8A1F5A406B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:51557 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3BEV7e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 16:59:34 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so33216ggn.2
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 13:59:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@linaro.org, a.zummo@towertech.it, haojian.zhuang@gmail.com, mian.yousaf.kaukab@stericsson.com, srinidhi.kasagar@stericsson.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: restore ST variant functionality
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl031c-restore-st-variant-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-rtc-rtc-pl031c-restore-st-variant-functionality.patch
linux-next.patch
rtc-pl031-add-wake-up-support.patch

