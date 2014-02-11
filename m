From: akpm@linux-foundation.org
Subject: + rtc-rtc-jz4740-use-devm_ioremap_resource.patch added to -mm
 tree
Date: Mon, 10 Feb 2014 16:11:03 -0800
Message-ID: <52f96a97.SM3ThSK3kkK948y7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbaBKALE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:11:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lars@metafoo.de, jg1.han@samsung.com

Subject: + rtc-rtc-jz4740-use-devm_ioremap_resource.patch added to -mm tree
To: jg1.han@samsung.com,lars@metafoo.de
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:11:03 -0800


The patch titled
     Subject: rtc: rtc-jz4740: use devm_ioremap_resource()
has been added to the -mm tree.  Its filename is
     rtc-rtc-jz4740-use-devm_ioremap_resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-jz4740-use-devm_ioremap_resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-jz4740-use-devm_ioremap_resource.patch

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
Subject: rtc: rtc-jz4740: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and move
'struct resource *mem' from 'struct jz4740_rtc' to jz4740_rtc_probe()
because the 'mem' variable is used only in jz4740_rtc_probe().  Also the
redundant return value check of platform_get_resource() is removed,
because the value is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-jz4740.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff -puN drivers/rtc/rtc-jz4740.c~rtc-rtc-jz4740-use-devm_ioremap_resource drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~rtc-rtc-jz4740-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-jz4740.c
@@ -38,7 +38,6 @@
 #define JZ_RTC_CTRL_ENABLE	BIT(0)
 
 struct jz4740_rtc {
-	struct resource *mem;
 	void __iomem *base;
 
 	struct rtc_device *rtc;
@@ -216,6 +215,7 @@ static int jz4740_rtc_probe(struct platf
 	int ret;
 	struct jz4740_rtc *rtc;
 	uint32_t scratchpad;
+	struct resource *mem;
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
@@ -227,25 +227,10 @@ static int jz4740_rtc_probe(struct platf
 		return -ENOENT;
 	}
 
-	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!rtc->mem) {
-		dev_err(&pdev->dev, "Failed to get platform mmio memory\n");
-		return -ENOENT;
-	}
-
-	rtc->mem = devm_request_mem_region(&pdev->dev, rtc->mem->start,
-					resource_size(rtc->mem), pdev->name);
-	if (!rtc->mem) {
-		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		return -EBUSY;
-	}
-
-	rtc->base = devm_ioremap_nocache(&pdev->dev, rtc->mem->start,
-					resource_size(rtc->mem));
-	if (!rtc->base) {
-		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		return -EBUSY;
-	}
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	rtc->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(rtc->base))
+		return PTR_ERR(rtc->base);
 
 	spin_lock_init(&rtc->lock);
 
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
rtc-rtc-jz4740-use-devm_ioremap_resource.patch
linux-next.patch

