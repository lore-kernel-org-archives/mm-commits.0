From: akpm@linux-foundation.org
Subject: + rtc-rtc-m48t59-use-devm_-functions.patch added to -mm tree
Date: Tue, 28 May 2013 15:22:05 -0700
Message-ID: <51a52e0d.8td/lJ6t3cNzsO2g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab3E1WWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 18:22:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-rtc-m48t59-use-devm_-functions.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 15:22:05 -0700


The patch titled
     Subject: rtc: rtc-m48t59: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-m48t59-use-devm_-functions.patch

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
Subject: rtc: rtc-m48t59: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |   53 +++++++++++--------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-rtc-m48t59-use-devm_-functions drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-rtc-m48t59-use-devm_-functions
+++ a/drivers/rtc/rtc-m48t59.c
@@ -409,7 +409,8 @@ static int m48t59_rtc_probe(struct platf
 	} else if (res->flags & IORESOURCE_MEM) {
 		/* we are memory-mapped */
 		if (!pdata) {
-			pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+			pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata),
+						GFP_KERNEL);
 			if (!pdata)
 				return -ENOMEM;
 			/* Ensure we only kmalloc platform data once */
@@ -425,7 +426,7 @@ static int m48t59_rtc_probe(struct platf
 			pdata->read_byte = m48t59_mem_readb;
 	}
 
-	m48t59 = kzalloc(sizeof(*m48t59), GFP_KERNEL);
+	m48t59 = devm_kzalloc(&pdev->dev, sizeof(*m48t59), GFP_KERNEL);
 	if (!m48t59)
 		return -ENOMEM;
 
@@ -433,9 +434,10 @@ static int m48t59_rtc_probe(struct platf
 
 	if (!m48t59->ioaddr) {
 		/* ioaddr not mapped externally */
-		m48t59->ioaddr = ioremap(res->start, resource_size(res));
+		m48t59->ioaddr = devm_ioremap(&pdev->dev, res->start,
+						resource_size(res));
 		if (!m48t59->ioaddr)
-			goto out;
+			return ret;
 	}
 
 	/* Try to get irq number. We also can work in
@@ -446,10 +448,11 @@ static int m48t59_rtc_probe(struct platf
 		m48t59->irq = NO_IRQ;
 
 	if (m48t59->irq != NO_IRQ) {
-		ret = request_irq(m48t59->irq, m48t59_rtc_interrupt,
-			IRQF_SHARED, "rtc-m48t59", &pdev->dev);
+		ret = devm_request_irq(&pdev->dev, m48t59->irq,
+				m48t59_rtc_interrupt, IRQF_SHARED,
+				"rtc-m48t59", &pdev->dev);
 		if (ret)
-			goto out;
+			return ret;
 	}
 	switch (pdata->type) {
 	case M48T59RTC_TYPE_M48T59:
@@ -469,51 +472,29 @@ static int m48t59_rtc_probe(struct platf
 		break;
 	default:
 		dev_err(&pdev->dev, "Unknown RTC type\n");
-		ret = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
 
 	spin_lock_init(&m48t59->lock);
 	platform_set_drvdata(pdev, m48t59);
 
-	m48t59->rtc = rtc_device_register(name, &pdev->dev, ops, THIS_MODULE);
-	if (IS_ERR(m48t59->rtc)) {
-		ret = PTR_ERR(m48t59->rtc);
-		goto out;
-	}
+	m48t59->rtc = devm_rtc_device_register(&pdev->dev, name, ops,
+						THIS_MODULE);
+	if (IS_ERR(m48t59->rtc))
+		return PTR_ERR(m48t59->rtc);
 
 	m48t59_nvram_attr.size = pdata->offset;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
-	if (ret) {
-		rtc_device_unregister(m48t59->rtc);
-		goto out;
-	}
+	if (ret)
+		return ret;
 
 	return 0;
-
-out:
-	if (m48t59->irq != NO_IRQ)
-		free_irq(m48t59->irq, &pdev->dev);
-	if (m48t59->ioaddr)
-		iounmap(m48t59->ioaddr);
-		kfree(m48t59);
-	return ret;
 }
 
 static int m48t59_rtc_remove(struct platform_device *pdev)
 {
-	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
-
 	sysfs_remove_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
-	if (!IS_ERR(m48t59->rtc))
-		rtc_device_unregister(m48t59->rtc);
-	if (m48t59->ioaddr && !pdata->ioaddr)
-		iounmap(m48t59->ioaddr);
-	if (m48t59->irq != NO_IRQ)
-		free_irq(m48t59->irq, &pdev->dev);
-	kfree(m48t59);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch
backlight-ep93xx-remove-unnecessary-platform_set_drvdata.patch
backlight-lp8788-remove-unnecessary-platform_set_drvdata.patch
backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch
backlight-add-devm_backlight_device_registerunregister.patch
lcd-add-devm_lcd_device_registerunregister.patch
maintainers-add-backlight-subsystem-co-maintainer.patch
rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
rtc-rtc-88pm860x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab3100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at32ap700x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91rm9200-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91sam9-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-au1xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bfin-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bq4802-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-coh901331-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9052-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9055-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-davinci-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-dm355evm-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ep93xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-jz4740-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lp8788-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lpc32xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ls1x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t59-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8925-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8998-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-msm6242-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mxc-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-nuc900-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pcap-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pm8xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sa1100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sh-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-spear-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-stmp3xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-twl-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vr41xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vt8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t86-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-puv3-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-rp5c01-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-tile-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-hid-sensor-time-add-option-hctosys-to-set-time-at-boot.patch
rtc-rtc-hid-sensor-time-add-support-for-milliseconds.patch
rtc-rtc-ds1307-use-devm_-functions.patch
rtc-rtc-jz4740-use-devm_-functions.patch
rtc-rtc-mpc5121-use-devm_-functions.patch
rtc-rtc-m48t59-use-devm_-functions.patch
rtc-rtc-pm8xxx-use-devm_-functions.patch
rtc-rtc-pxa-use-devm_-functions.patch
rtc-rtc-rx8025-use-devm_-functions.patch
rtc-rtc-sh-use-devm_-functions.patch

