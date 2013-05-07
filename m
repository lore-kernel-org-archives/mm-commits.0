From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata.patch added to -mm tree
Date: Tue, 07 May 2013 15:49:47 -0700
Message-ID: <20130507224947.C58F05A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:50132 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3EGWts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:49:48 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so110134ghb.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:49:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-s3c: remove unnecessary platform_set_drvdata()
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata.patch

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
Subject: rtc: rtc-s3c: remove unnecessary platform_set_drvdata()

The driver core clears the driver data to NULL after device_release or on
probe failure, since commit 0998d063100 ("device-core: Ensure drvdata =
NULL when no driver is bound").  Thus, it is not needed to manually clear
the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata
+++ a/drivers/rtc/rtc-s3c.c
@@ -421,8 +421,6 @@ static void s3c_rtc_enable(struct platfo
 
 static int s3c_rtc_remove(struct platform_device *dev)
 {
-	platform_set_drvdata(dev, NULL);
-
 	s3c_rtc_setaie(&dev->dev, 0);
 
 	clk_unprepare(rtc_clk);
@@ -554,23 +552,20 @@ static int s3c_rtc_probe(struct platform
 			  0,  "s3c2410-rtc alarm", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
-		goto err_alarm_irq;
+		goto err_nortc;
 	}
 
 	ret = devm_request_irq(&pdev->dev, s3c_rtc_tickno, s3c_rtc_tickirq,
 			  0,  "s3c2410-rtc tick", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
-		goto err_alarm_irq;
+		goto err_nortc;
 	}
 
 	clk_disable(rtc_clk);
 
 	return 0;
 
- err_alarm_irq:
-	platform_set_drvdata(pdev, NULL);
-
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
 	clk_disable_unprepare(rtc_clk);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch
backlight-ep93xx-remove-unnecessary-platform_set_drvdata.patch
backlight-lp8788-remove-unnecessary-platform_set_drvdata.patch
backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch
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
drivers-rtc-rtc-pxac-use-devm_-apis.patch

