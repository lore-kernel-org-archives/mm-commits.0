From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pl031c-enable-clock-on-all-st-variants.patch added to -mm tree
Date: Fri, 06 Apr 2012 16:30:16 -0700
Message-ID: <20120406233016.5478AA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38897 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308Ab2DFXaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 19:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linus.walleij@linaro.org, mian.yousaf.kaukab@stericsson.com, rubini@unipv.it, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: enable clock on all ST variants
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pl031c-enable-clock-on-all-st-variants.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Linus Walleij" <linus.walleij@linaro.org>
Subject: drivers/rtc/rtc-pl031.c: enable clock on all ST variants

The ST variants of the PL031 all require bit 26 in the control register to
be set before they work properly.  Discovered this when testing on the
Nomadik board where it would suprisingly just stand still.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Cc: Alessandro Rubini <rubini@unipv.it>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-enable-clock-on-all-st-variants drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~drivers-rtc-rtc-pl031c-enable-clock-on-all-st-variants
+++ a/drivers/rtc/rtc-pl031.c
@@ -339,8 +339,7 @@ static int pl031_probe(struct amba_devic
 	dev_dbg(&adev->dev, "revision = 0x%01x\n", ldata->hw_revision);
 
 	/* Enable the clockwatch on ST Variants */
-	if ((ldata->hw_designer == AMBA_VENDOR_ST) &&
-	    (ldata->hw_revision > 1))
+	if (ldata->hw_designer == AMBA_VENDOR_ST)
 		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
 		       ldata->base + RTC_CR);
 
_
Subject: Subject: drivers/rtc/rtc-pl031.c: enable clock on all ST variants

Patches currently in -mm which might be from linus.walleij@linaro.org are

origin.patch
linux-next.patch
drivers-rtc-rtc-pl031c-enable-clock-on-all-st-variants.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch

