From: akpm@linux-foundation.org
Subject: + rtc-at32ap700x-fix-irq-init-oops.patch added to -mm tree
Date: Tue, 11 Dec 2007 12:45:53 -0800
Message-ID: <200712112045.lBBKjr2x008164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbXLKUq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 15:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, hcegtvedt@atmel.com


The patch titled
     rtc-at32ap700x: fix irq init oops
has been added to the -mm tree.  Its filename is
     rtc-at32ap700x-fix-irq-init-oops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-at32ap700x: fix irq init oops
From: David Brownell <david-b@pacbell.net>

Reorder at32_rtc_probe() so that it's safe (no oopsing) to fire the
IRQ handler the instant that it's registered.  (Bug noted via "Debug
shared IRQ handlers" kernel debug option.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: <hcegtvedt@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at32ap700x.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-at32ap700x.c~rtc-at32ap700x-fix-irq-init-oops drivers/rtc/rtc-at32ap700x.c
--- a/drivers/rtc/rtc-at32ap700x.c~rtc-at32ap700x-fix-irq-init-oops
+++ a/drivers/rtc/rtc-at32ap700x.c
@@ -225,18 +225,12 @@ static int __init at32_rtc_probe(struct 
 		goto out;
 	}
 
-	ret = request_irq(irq, at32_rtc_interrupt, IRQF_SHARED, "rtc", rtc);
-	if (ret) {
-		dev_dbg(&pdev->dev, "could not request irq %d\n", irq);
-		goto out;
-	}
-
 	rtc->irq = irq;
 	rtc->regs = ioremap(regs->start, regs->end - regs->start + 1);
 	if (!rtc->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
-		goto out_free_irq;
+		goto out;
 	}
 	spin_lock_init(&rtc->lock);
 
@@ -253,12 +247,18 @@ static int __init at32_rtc_probe(struct 
 				| RTC_BIT(CTRL_EN));
 	}
 
+	ret = request_irq(irq, at32_rtc_interrupt, IRQF_SHARED, "rtc", rtc);
+	if (ret) {
+		dev_dbg(&pdev->dev, "could not request irq %d\n", irq);
+		goto out_iounmap;
+	}
+
 	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&at32_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		dev_dbg(&pdev->dev, "could not register rtc device\n");
 		ret = PTR_ERR(rtc->rtc);
-		goto out_iounmap;
+		goto out_free_irq;
 	}
 
 	platform_set_drvdata(pdev, rtc);
@@ -268,10 +268,10 @@ static int __init at32_rtc_probe(struct 
 
 	return 0;
 
-out_iounmap:
-	iounmap(rtc->regs);
 out_free_irq:
 	free_irq(irq, rtc);
+out_iounmap:
+	iounmap(rtc->regs);
 out:
 	kfree(rtc);
 	return ret;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-at32ap700x-fix-irq-init-oops.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
ads7846-stop-updating-dev-powerpower_state.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
