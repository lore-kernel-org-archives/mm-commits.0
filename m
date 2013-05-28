From: akpm@linux-foundation.org
Subject: + rtc-rtc-rx8025-use-devm_-functions.patch added to -mm tree
Date: Tue, 28 May 2013 15:22:08 -0700
Message-ID: <51a52e10.Cjpn/9gLV+5BHZiy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab3E1WWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 18:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + rtc-rtc-rx8025-use-devm_-functions.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 15:22:08 -0700


The patch titled
     Subject: rtc: rtc-rx8025: use devm_*() functions
has been added to the -mm tree.  Its filename is
     rtc-rtc-rx8025-use-devm_-functions.patch

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
Subject: rtc: rtc-rx8025: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx8025.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-rx8025.c~rtc-rtc-rx8025-use-devm_-functions drivers/rtc/rtc-rx8025.c
--- a/drivers/rtc/rtc-rx8025.c~rtc-rtc-rx8025-use-devm_-functions
+++ a/drivers/rtc/rtc-rx8025.c
@@ -549,7 +549,7 @@ static int rx8025_probe(struct i2c_clien
 		goto errout;
 	}
 
-	rx8025 = kzalloc(sizeof(*rx8025), GFP_KERNEL);
+	rx8025 = devm_kzalloc(&client->dev, sizeof(*rx8025), GFP_KERNEL);
 	if (!rx8025) {
 		dev_err(&adapter->dev, "failed to alloc memory\n");
 		err = -ENOMEM;
@@ -562,7 +562,7 @@ static int rx8025_probe(struct i2c_clien
 
 	err = rx8025_init_client(client, &need_reset);
 	if (err)
-		goto errout_free;
+		goto errout;
 
 	if (need_reset) {
 		struct rtc_time tm;
@@ -572,12 +572,12 @@ static int rx8025_probe(struct i2c_clien
 		rx8025_set_time(&client->dev, &tm);
 	}
 
-	rx8025->rtc = rtc_device_register(client->name, &client->dev,
+	rx8025->rtc = devm_rtc_device_register(&client->dev, client->name,
 					  &rx8025_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rx8025->rtc)) {
 		err = PTR_ERR(rx8025->rtc);
 		dev_err(&client->dev, "unable to register the class device\n");
-		goto errout_free;
+		goto errout;
 	}
 
 	if (client->irq > 0) {
@@ -586,7 +586,7 @@ static int rx8025_probe(struct i2c_clien
 				  0, "rx8025", client);
 		if (err) {
 			dev_err(&client->dev, "unable to request IRQ\n");
-			goto errout_reg;
+			goto errout;
 		}
 	}
 
@@ -603,12 +603,6 @@ errout_irq:
 	if (client->irq > 0)
 		free_irq(client->irq, client);
 
-errout_reg:
-	rtc_device_unregister(rx8025->rtc);
-
-errout_free:
-	kfree(rx8025);
-
 errout:
 	dev_err(&adapter->dev, "probing for rx8025 failed\n");
 	return err;
@@ -629,8 +623,6 @@ static int rx8025_remove(struct i2c_clie
 	}
 
 	rx8025_sysfs_unregister(&client->dev);
-	rtc_device_unregister(rx8025->rtc);
-	kfree(rx8025);
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

