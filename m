From: akpm@linux-foundation.org
Subject: + rtc-rtc-coh901331-use-devm_ioremap_resource.patch added to -mm
 tree
Date: Fri, 07 Feb 2014 14:47:00 -0800
Message-ID: <52f56264.tADubm+1lTZd+dLP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaBGWrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:47:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linus.walleij@linaro.org, jg1.han@samsung.com

Subject: + rtc-rtc-coh901331-use-devm_ioremap_resource.patch added to -mm tree
To: jg1.han@samsung.com,linus.walleij@linaro.org
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:47:00 -0800


The patch titled
     Subject: rtc: rtc-coh901331: use devm_ioremap_resource()
has been added to the -mm tree.  Its filename is
     rtc-rtc-coh901331-use-devm_ioremap_resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-coh901331-use-devm_ioremap_resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-coh901331-use-devm_ioremap_resource.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-coh901331: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and remove
redundant return value check of platform_get_resource() because the value
is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_ioremap_resource drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-coh901331.c
@@ -43,8 +43,6 @@
 struct coh901331_port {
 	struct rtc_device *rtc;
 	struct clk *clk;
-	u32 phybase;
-	u32 physize;
 	void __iomem *virtbase;
 	int irq;
 #ifdef CONFIG_PM_SLEEP
@@ -173,19 +171,9 @@ static int __init coh901331_probe(struct
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
-	rtap->phybase = res->start;
-	rtap->physize = resource_size(res);
-
-	if (devm_request_mem_region(&pdev->dev, rtap->phybase, rtap->physize,
-				    "rtc-coh901331") == NULL)
-		return -EBUSY;
-
-	rtap->virtbase = devm_ioremap(&pdev->dev, rtap->phybase, rtap->physize);
-	if (!rtap->virtbase)
-		return -ENOMEM;
+	rtap->virtbase  = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(rtap->virtbase))
+		return PTR_ERR(rtap->virtbase);
 
 	rtap->irq = platform_get_irq(pdev, 0);
 	if (devm_request_irq(&pdev->dev, rtap->irq, coh901331_interrupt, 0,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-update-bd-state-fb_blank-properties-when-necessary.patch
backlight-update-backlight-status-when-necessary.patch
backlight-aat2870-remove-unnecessary-oom-messages.patch
backlight-adp8860-remove-unnecessary-oom-messages.patch
backlight-adp8870-remove-unnecessary-oom-messages.patch
backlight-corgi_lcd-remove-unnecessary-oom-messages.patch
backlight-hx8357-remove-unnecessary-oom-messages.patch
backlight-ili922x-remove-unnecessary-oom-messages.patch
backlight-ili9320-remove-unnecessary-oom-messages.patch
backlight-l4f00242t03-remove-unnecessary-oom-messages.patch
backlight-lm3533_bl-remove-unnecessary-oom-messages.patch
backlight-lms283gf05-remove-unnecessary-oom-messages.patch
backlight-platform_lcd-remove-unnecessary-oom-messages.patch
backlight-tps65217_bl-remove-unnecessary-oom-messages.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
rtc-rtc-at32ap700x-remove-unnecessary-oom-messages.patch
rtc-rtc-davinci-remove-unnecessary-oom-messages.patch
rtc-rtc-ds1390-remove-unnecessary-oom-messages.patch
rtc-rtc-moxart-remove-unnecessary-oom-messages.patch
rtc-rtc-nuc900-remove-unnecessary-oom-messages.patch
rtc-rtc-pm8xxx-remove-unnecessary-oom-messages.patch
rtc-rtc-rx8025-remove-unnecessary-oom-messages.patch
rtc-rtc-sirfsoc-remove-unnecessary-oom-messages.patch
rtc-rtc-lpc32xx-remove-unnecessary-oom-messages.patch
rtc-rtc-spear-remove-unnecessary-oom-messages.patch
rtc-rtc-coh901331-use-devm_ioremap_resource.patch
rtc-rtc-davinci-use-devm_ioremap_resource.patch
rtc-rtc-vt8500-use-devm_ioremap_resource.patch
linux-next.patch

