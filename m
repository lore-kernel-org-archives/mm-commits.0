From: akpm@linux-foundation.org
Subject: + sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch added to -mm tree
Date: Tue, 24 Jun 2008 15:17:03 -0700
Message-ID: <200806242217.m5OMHMKv009021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbYFXWSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 18:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     sm501: fixes for akpms comments on gpiolib addition
has been added to the -mm tree.  Its filename is
     sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch

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
Subject: sm501: fixes for akpms comments on gpiolib addition
From: Ben Dooks <ben-linux@fluff.org>

Fixup the comments from the patch that added the gpiolib support from
Andrew Morton.  These include spotting some missing frees on error or
release, and changing a memcpy for a type-safe assingment.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-fixes-for-akpms-comments-on-gpiolib-addition drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-fixes-for-akpms-comments-on-gpiolib-addition
+++ a/drivers/mfd/sm501.c
@@ -999,7 +999,7 @@ static int __devinit sm501_gpio_register
 	struct gpio_chip *gchip = &chip->gpio;
 	int base = pdata->gpio_base;
 
-	memcpy(chip, &gpio_chip_template, sizeof(struct gpio_chip));
+	chip->gpio = gpio_chip_template;
 
 	if (chip == &gpio->high) {
 		if (base > 0)
@@ -1039,7 +1039,7 @@ static int sm501_register_gpio(struct sm
 	if (gpio->regs == NULL) {
 		dev_err(sm->dev, "gpio: failed to remap registers\n");
 		ret = -ENXIO;
-		goto err_mapped;
+		goto err_claimed;
 	}
 
 	/* Register both our chips. */
@@ -1068,6 +1068,9 @@ static int sm501_register_gpio(struct sm
 	}
 
  err_mapped:
+	iounmap(gpio->regs);
+
+ err_claimed:
 	release_resource(gpio->regs_res);
 	kfree(gpio->regs_res);
 
@@ -1076,33 +1079,38 @@ static int sm501_register_gpio(struct sm
 
 static void sm501_gpio_remove(struct sm501_devdata *sm)
 {
+	struct sm501_gpio *gpio = &sm->gpio;
 	int ret;
 
-	ret = gpiochip_remove(&sm->gpio.low.gpio);
+	ret = gpiochip_remove(&gpio->low.gpio);
 	if (ret)
 		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
 
-	ret = gpiochip_remove(&sm->gpio.high.gpio);
+	ret = gpiochip_remove(&gpio->high.gpio);
 	if (ret)
 		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
+
+	iounmap(gpio->regs);
+	release_resource(gpio->regs_res);
+	kfree(gpio->regs_res);
 }
 
-static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+static inline int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
 	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
 }
 #else
-static int sm501_register_gpio(struct sm501_devdata *sm)
+static inline int sm501_register_gpio(struct sm501_devdata *sm)
 {
 	return 0;
 }
 
-static void sm501_gpio_remove(struct sm501_devdata *sm)
+static inline void sm501_gpio_remove(struct sm501_devdata *sm)
 {
 }
 
-static int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
+static inline int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
 {
 	return -1;
 }
_

Patches currently in -mm which might be from ben-linux@fluff.org are

sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

