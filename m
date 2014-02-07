From: akpm@linux-foundation.org
Subject: + rtc-rtc-vt8500-use-devm_ioremap_resource.patch added to -mm
 tree
Date: Fri, 07 Feb 2014 14:47:02 -0800
Message-ID: <52f56266.MNHvRqOh2t2xJDRg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaBGWrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Feb 2014 17:47:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@prisktech.co.nz, jg1.han@samsung.com

Subject: + rtc-rtc-vt8500-use-devm_ioremap_resource.patch added to -mm tree
To: jg1.han@samsung.com,linux@prisktech.co.nz
From: akpm@linux-foundation.org
Date: Fri, 07 Feb 2014 14:47:02 -0800


The patch titled
     Subject: rtc: rtc-vt8500: use devm_ioremap_resource()
has been added to the -mm tree.  Its filename is
     rtc-rtc-vt8500-use-devm_ioremap_resource.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-vt8500-use-devm_ioremap_resource.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-vt8500-use-devm_ioremap_resource.patch

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
Subject: rtc: rtc-vt8500: use devm_ioremap_resource()

Use devm_ioremap_resource() in order to make the code simpler, and move
'struct resource *res' from 'struct vt8500_rtc' to vt8500_rtc_probe()
because the 'res' variable is used only in vt8500_rtc_probe().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_ioremap_resource drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_ioremap_resource
+++ a/drivers/rtc/rtc-vt8500.c
@@ -79,7 +79,6 @@
 
 struct vt8500_rtc {
 	void __iomem		*regbase;
-	struct resource		*res;
 	int			irq_alarm;
 	struct rtc_device	*rtc;
 	spinlock_t		lock;		/* Protects this structure */
@@ -209,6 +208,7 @@ static const struct rtc_class_ops vt8500
 static int vt8500_rtc_probe(struct platform_device *pdev)
 {
 	struct vt8500_rtc *vt8500_rtc;
+	struct resource	*res;
 	int ret;
 
 	vt8500_rtc = devm_kzalloc(&pdev->dev,
@@ -219,34 +219,16 @@ static int vt8500_rtc_probe(struct platf
 	spin_lock_init(&vt8500_rtc->lock);
 	platform_set_drvdata(pdev, vt8500_rtc);
 
-	vt8500_rtc->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!vt8500_rtc->res) {
-		dev_err(&pdev->dev, "No I/O memory resource defined\n");
-		return -ENXIO;
-	}
-
 	vt8500_rtc->irq_alarm = platform_get_irq(pdev, 0);
 	if (vt8500_rtc->irq_alarm < 0) {
 		dev_err(&pdev->dev, "No alarm IRQ resource defined\n");
 		return vt8500_rtc->irq_alarm;
 	}
 
-	vt8500_rtc->res = devm_request_mem_region(&pdev->dev,
-					vt8500_rtc->res->start,
-					resource_size(vt8500_rtc->res),
-					"vt8500-rtc");
-	if (vt8500_rtc->res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		return -EBUSY;
-	}
-
-	vt8500_rtc->regbase = devm_ioremap(&pdev->dev, vt8500_rtc->res->start,
-				      resource_size(vt8500_rtc->res));
-	if (!vt8500_rtc->regbase) {
-		dev_err(&pdev->dev, "Unable to map RTC I/O memory\n");
-		ret = -EBUSY;
-		goto err_return;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	vt8500_rtc->regbase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(vt8500_rtc->regbase))
+		return PTR_ERR(vt8500_rtc->regbase);
 
 	/* Enable RTC and set it to 24-hour mode */
 	writel(VT8500_RTC_CR_ENABLE,
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

