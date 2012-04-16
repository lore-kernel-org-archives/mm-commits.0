From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pl031c-enable-clock-on-all-st-variants.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:42 -0700
Message-ID: <20120416201542.660EAA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:52584 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2DPUPo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@linaro.org, mian.yousaf.kaukab@stericsson.com, rubini@unipv.it, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: enable clock on all ST variants
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pl031c-enable-clock-on-all-st-variants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from linus.walleij@linaro.org are

linux-next.patch
arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch

