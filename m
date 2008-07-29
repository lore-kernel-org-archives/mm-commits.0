From: akpm@linux-foundation.org
Subject: + blackfin-rtc-driver-add-support-for-power-management-framework.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:20:36 -0700
Message-ID: <200807292220.m6TMKafG024679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbYG2WVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, a.zummo@towertech.it, bryan.wu@analog.com, cooloney@kernel.org, david-b@pacbell.net


The patch titled
     blackfin RTC driver: add support for power management framework
has been added to the -mm tree.  Its filename is
     blackfin-rtc-driver-add-support-for-power-management-framework.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin RTC driver: add support for power management framework
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-add-support-for-power-management-framework drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-add-support-for-power-management-framework
+++ a/drivers/rtc/rtc-bfin.c
@@ -2,7 +2,7 @@
  * Blackfin On-Chip Real Time Clock Driver
  *  Supports BF52[257]/BF53[123]/BF53[467]/BF54[24789]
  *
- * Copyright 2004-2007 Analog Devices Inc.
+ * Copyright 2004-2008 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -412,6 +412,8 @@ static int __devinit bfin_rtc_probe(stru
 
 	platform_set_drvdata(pdev, rtc);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	return 0;
 
  err:
@@ -433,25 +435,28 @@ static int __devexit bfin_rtc_remove(str
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-#ifdef PM_WAKEUP_SIC_IWR
 	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
-#endif
-	bfin_rtc_reset(&pdev->dev);
-#ifdef PM_WAKEUP_SIC_IWR
-	bfin_write_RTC_SWCNT(10);
-	bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
-#endif
+
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(IRQ_RTC);
+	else
+		bfin_rtc_int_clear(rtc, -1);
+
 	return 0;
 }
 
 static int bfin_rtc_resume(struct platform_device *pdev)
 {
-#ifdef PM_WAKEUP_SIC_IWR
-	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
-	bfin_rtc_int_clear(rtc, RTC_ISTAT_STOPWATCH);
-#endif
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(IRQ_RTC);
+	else
+		bfin_write_RTC_ISTAT(-1);
+
 	return 0;
 }
+#else
+# define bfin_rtc_suspend NULL
+# define bfin_rtc_resume  NULL
 #endif
 
 static struct platform_driver bfin_rtc_driver = {
@@ -461,10 +466,8 @@ static struct platform_driver bfin_rtc_d
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= __devexit_p(bfin_rtc_remove),
-#ifdef CONFIG_PM
 	.suspend	= bfin_rtc_suspend,
 	.resume		= bfin_rtc_resume,
-#endif
 };
 
 static int __init bfin_rtc_init(void)
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

blackfin-nfc-driver-fix-bug-do-not-clobber-the-status-from-the-first-256-bytes-if-operating-on-512-pages.patch
blackfin-nfc-driver-fix-bug-hw-ecc-calc-by-making-sure-we-extract-11-bits-from-each-register-instead-of-10.patch
blackfin-nfc-driver-add-support-for-the-ecc-layout-the-blackfin-bootrom-uses.patch
blackfin-nfc-driver-add-proper-devinit-devexit-markings-to-probe-remove-functions.patch
blackfin-nfc-driver-enable-blackfin-nand-hwecc-support-by-default.patch
blackfin-nfc-driver-use-standard-dev_err-rather-than-printk.patch
blackfin-nfc-driver-cleanup-the-error-exit-path-of-bf5xx_nand_probe-function.patch
blackfin-rtc-driver-add-support-for-power-management-framework.patch
blackfin-rtc-driver-dont-bother-passing-the-rtc-struct-down-to-bfin_rtc_int_setclear-since-it-isnt-needed-shaves-off-100bytes.patch
blackfin-rtc-driver-disable-the-write-complete-irq-upon-close.patch
blackfin-rtc-driver-wait-for-the-write-complete-interrupt-complete-before-sleeping.patch
blackfin-rtc-driver-convert-pie-handling-to-irq_set_state-as-pointed-out-by-david-brownell.patch
blackfin-rtc-driver-drop-pie-stopwatch-code-since-the-hardware-can-only-do-a-max-of-1hz-and-this-same-functionality-is-provided-by-uie.patch

