From: akpm@linux-foundation.org
Subject: + twl4030-gpio-cleanup-debounce.patch added to -mm tree
Date: Fri, 07 Nov 2008 14:36:39 -0800
Message-ID: <200811072236.mA7MadVj001811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbYKGWgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 17:36:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, tony@atomide.com


The patch titled
     twl4030-gpio: cleanup debounce 
has been added to the -mm tree.  Its filename is
     twl4030-gpio-cleanup-debounce.patch

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
Subject: twl4030-gpio: cleanup debounce 
From: David Brownell <dbrownell@users.sourceforge.net>

Provide a static debounce configuration mechanism for twl4030 GPIOs,
replacing the previous dynamic one.  The single user of that mechanism was
for MMC card detect debouncing.

Boards can provide a bitmask saying which GPIOs to debounce (30 msec). 
It's always enabled for pins with the MMC card-detect/VMMCx link active,
so most boards won't need to set the debounce mask.

This is a net code shrink, including runtime footprint.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/twl4030-gpio.c |   54 ++++++++++++++--------------------
 include/linux/i2c/twl4030.h |    9 +----
 2 files changed, 26 insertions(+), 37 deletions(-)

diff -puN drivers/gpio/twl4030-gpio.c~twl4030-gpio-cleanup-debounce drivers/gpio/twl4030-gpio.c
--- a/drivers/gpio/twl4030-gpio.c~twl4030-gpio-cleanup-debounce
+++ a/drivers/gpio/twl4030-gpio.c
@@ -202,37 +202,6 @@ static int twl4030_get_gpio_datain(int g
 	return ret;
 }
 
-/*
- * Configure debounce timing value for a GPIO pin on TWL4030
- */
-int twl4030_set_gpio_debounce(int gpio, int enable)
-{
-	u8 d_bnk = gpio >> 3;
-	u8 d_msk = BIT(gpio & 0x7);
-	u8 reg = 0;
-	u8 base = 0;
-	int ret = 0;
-
-	if (unlikely((gpio >= TWL4030_GPIO_MAX)
-		|| !(gpio_usage_count & BIT(gpio))))
-		return -EPERM;
-
-	base = REG_GPIO_DEBEN1 + d_bnk;
-	mutex_lock(&gpio_lock);
-	ret = gpio_twl4030_read(base);
-	if (ret >= 0) {
-		if (enable)
-			reg = ret | d_msk;
-		else
-			reg = ret & ~d_msk;
-
-		ret = gpio_twl4030_write(base, reg);
-	}
-	mutex_unlock(&gpio_lock);
-	return ret;
-}
-EXPORT_SYMBOL(twl4030_set_gpio_debounce);
-
 /*----------------------------------------------------------------------*/
 
 static int twl_request(struct gpio_chip *chip, unsigned offset)
@@ -405,6 +374,23 @@ static int __devinit gpio_twl4030_pulls(
 				REG_GPIOPUPDCTR1, 5);
 }
 
+static int __devinit gpio_twl4030_debounce(u32 debounce, u8 mmc_cd)
+{
+	u8		message[4];
+
+	/* 30 msec of debouncing is always used for MMC card detect,
+	 * and is optional for everything else.
+	 */
+	message[1] = (debounce & 0xff) | (mmc_cd & 0x03);
+	debounce >>= 8;
+	message[2] = (debounce & 0xff);
+	debounce >>= 8;
+	message[3] = (debounce & 0x03);
+
+	return twl4030_i2c_write(TWL4030_MODULE_GPIO, message,
+				REG_GPIO_DEBEN1, 3);
+}
+
 static int gpio_twl4030_remove(struct platform_device *pdev);
 
 static int __devinit gpio_twl4030_probe(struct platform_device *pdev)
@@ -439,6 +425,12 @@ no_irqs:
 				pdata->pullups, pdata->pulldowns,
 				ret);
 
+	ret = gpio_twl4030_debounce(pdata->debounce, pdata->mmc_cd);
+	if (ret)
+		dev_dbg(&pdev->dev, "debounce %.03x %.01x --> %d\n",
+				pdata->debounce, pdata->mmc_cd,
+				ret);
+
 	twl_gpiochip.base = pdata->gpio_base;
 	twl_gpiochip.ngpio = TWL4030_GPIO_MAX;
 	twl_gpiochip.dev = &pdev->dev;
diff -puN include/linux/i2c/twl4030.h~twl4030-gpio-cleanup-debounce include/linux/i2c/twl4030.h
--- a/include/linux/i2c/twl4030.h~twl4030-gpio-cleanup-debounce
+++ a/include/linux/i2c/twl4030.h
@@ -234,6 +234,9 @@ struct twl4030_gpio_platform_data {
 	/* gpio-n should control VMMC(n+1) if BIT(n) in mmc_cd is set */
 	u8		mmc_cd;
 
+	/* if BIT(N) is set, or VMMC(n+1) is linked, debounce GPIO-N */
+	u32		debounce;
+
 	/* For gpio-N, bit (1 << N) in "pullups" is set if that pullup
 	 * should be enabled.  Else, if that bit is set in "pulldowns",
 	 * that pulldown is enabled.  Don't waste power by letting any
@@ -326,12 +329,6 @@ int twl4030_sih_setup(int module);
 
 #define TWL4030_GPIO_IRQ_NO(n)		(TWL4030_GPIO_IRQ_BASE + (n))
 
-/*
- * Exported TWL4030 GPIO APIs
- *
- * WARNING -- use standard GPIO and IRQ calls instead; these will vanish.
- */
-int twl4030_set_gpio_debounce(int gpio, int enable);
 
 #if defined(CONFIG_TWL4030_BCI_BATTERY) || \
 	defined(CONFIG_TWL4030_BCI_BATTERY_MODULE)
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

atmel_serial-keep-clock-off-when-its-not-needed.patch
linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
spi_gpio-driver.patch
spi_gpio-driver-cleanups.patch
rtc-ds1307-remove-legacy-probe-checks.patch
twl4030-gpio-cleanup-debounce.patch
genirq-warn-when-irqf_disabled-may-be-ignored.patch
genirq-record-irq_level-in-irq_desc.patch

