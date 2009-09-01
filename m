From: akpm@linux-foundation.org
Subject: + rtc-at91rm9200-fixes.patch added to -mm tree
Date: Tue, 01 Sep 2009 13:44:15 -0700
Message-ID: <200909012044.n81KiFMT022477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842AbZIAUoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 16:44:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, a.zummo@towertech.it, linux@maxim.org.za


The patch titled
     rtc: at91rm9200 fixes
has been added to the -mm tree.  Its filename is
     rtc-at91rm9200-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: at91rm9200 fixes
From: David Brownell <dbrownell@users.sourceforge.net>

Fix two new-ish runtime warnings in the at91rm9200 (etc) RTC:

 Platform driver 'at91_rtc' needs updating - please use dev_pm_ops
 	... by just switching

 IRQ 1/at91_rtc: IRQF_DISABLED is not guaranteed on shared IRQs
 	... no longer needed now that rtc_update_irq() changed

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-fixes drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-at91rm9200-fixes
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -289,7 +289,7 @@ static int __init at91_rtc_probe(struct 
 					AT91_RTC_CALEV);
 
 	ret = request_irq(AT91_ID_SYS, at91_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
+				IRQF_SHARED,
 				"at91_rtc", pdev);
 	if (ret) {
 		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
@@ -340,7 +340,7 @@ static int __exit at91_rtc_remove(struct
 
 static u32 at91_rtc_imr;
 
-static int at91_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int at91_rtc_suspend(struct device *dev)
 {
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
@@ -348,7 +348,7 @@ static int at91_rtc_suspend(struct platf
 	at91_rtc_imr = at91_sys_read(AT91_RTC_IMR)
 			& (AT91_RTC_ALARM|AT91_RTC_SECEV);
 	if (at91_rtc_imr) {
-		if (device_may_wakeup(&pdev->dev))
+		if (device_may_wakeup(dev))
 			enable_irq_wake(AT91_ID_SYS);
 		else
 			at91_sys_write(AT91_RTC_IDR, at91_rtc_imr);
@@ -356,28 +356,34 @@ static int at91_rtc_suspend(struct platf
 	return 0;
 }
 
-static int at91_rtc_resume(struct platform_device *pdev)
+static int at91_rtc_resume(struct device *dev)
 {
 	if (at91_rtc_imr) {
-		if (device_may_wakeup(&pdev->dev))
+		if (device_may_wakeup(dev))
 			disable_irq_wake(AT91_ID_SYS);
 		else
 			at91_sys_write(AT91_RTC_IER, at91_rtc_imr);
 	}
 	return 0;
 }
+
+static const struct dev_pm_ops at91_rtc_pm = {
+	.suspend =	at91_rtc_suspend,
+	.resume =	at91_rtc_resume,
+};
+
+#define at91_rtc_pm_ptr	&at91_rtc_pm
+
 #else
-#define at91_rtc_suspend NULL
-#define at91_rtc_resume  NULL
+#define at91_rtc_pm_ptr	NULL
 #endif
 
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
-	.suspend	= at91_rtc_suspend,
-	.resume		= at91_rtc_resume,
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
+		.pm	= at91_rtc_pm_ptr,
 	},
 };
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
spi-omap2_mcspi-use-bitn.patch
spi-add-spi_ppc4xx-driver.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
spi-add-default-selection-of-pl022-for-arm-reference-platforms.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
pxa2xx_spi-register-earlier.patch
rtc-at91rm9200-fixes.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
gpiolib-allow-poll-on-value.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

