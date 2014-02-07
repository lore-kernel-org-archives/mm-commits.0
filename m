From: akpm@linux-foundation.org
Subject: + rtc-rtc-davinci-use-devm_ioremap_resource.patch added to -mm
 tree
Date: Fri, 07 Feb 2014 14:47:01 -0800
Message-ID: <52f56265.vCo0ZB7wsmFMM0e9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaBGWrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:47:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khilman@linaro.org, jg1.han@samsung.com

Subject: + rtc-rtc-davinci-use-devm_ioremap_resource.patch added to -mm tree
To: jg1.han@samsung.com,khilman@linaro.org
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:47:01 -0800


The patch titled
     Subject: rtc: rtc-davinci: use devm_ioremap_resource()
has been added to the -mm tree.  Its filename is
     rtc-rtc-davinci-use-devm_ioremap_resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-davinci-use-devm_ioremap_resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-davinci-use-devm_ioremap_resource.patch

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
Subject: rtc: rtc-davinci: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and remove
redundant return value check of platform_get_resource() because the value
is checked by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_ioremap_resource drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-davinci.c
@@ -119,8 +119,6 @@ static DEFINE_SPINLOCK(davinci_rtc_lock)
 struct davinci_rtc {
 	struct rtc_device		*rtc;
 	void __iomem			*base;
-	resource_size_t			pbase;
-	size_t				base_size;
 	int				irq;
 };
 
@@ -482,7 +480,7 @@ static int __init davinci_rtc_probe(stru
 {
 	struct device *dev = &pdev->dev;
 	struct davinci_rtc *davinci_rtc;
-	struct resource *res, *mem;
+	struct resource *res;
 	int ret = 0;
 
 	davinci_rtc = devm_kzalloc(&pdev->dev, sizeof(struct davinci_rtc), GFP_KERNEL);
@@ -496,28 +494,9 @@ static int __init davinci_rtc_probe(stru
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "no mem resource\n");
-		return -EINVAL;
-	}
-
-	davinci_rtc->pbase = res->start;
-	davinci_rtc->base_size = resource_size(res);
-
-	mem = devm_request_mem_region(dev, davinci_rtc->pbase,
-				davinci_rtc->base_size, pdev->name);
-	if (!mem) {
-		dev_err(dev, "RTC registers at %08x are not free\n",
-			davinci_rtc->pbase);
-		return -EBUSY;
-	}
-
-	davinci_rtc->base = devm_ioremap(dev, davinci_rtc->pbase,
-					davinci_rtc->base_size);
-	if (!davinci_rtc->base) {
-		dev_err(dev, "unable to ioremap MEM resource\n");
-		return -ENOMEM;
-	}
+	davinci_rtc->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(davinci_rtc->base))
+		return PTR_ERR(davinci_rtc->base);
 
 	platform_set_drvdata(pdev, davinci_rtc);
 
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

