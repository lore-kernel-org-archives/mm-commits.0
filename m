From: akpm@linux-foundation.org
Subject: + mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch added to -mm tree
Date: Wed, 02 Jul 2008 10:00:07 -0700
Message-ID: <200807021700.m62H07ln026641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbYGBRBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 13:01:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     mfd: sm501 fix gpio number calculation for upper bank
has been added to the -mm tree.  Its filename is
     mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch

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
Subject: mfd: sm501 fix gpio number calculation for upper bank
From: Ben Dooks <ben-linux@fluff.org>

The sm501_gpio_pin2nr() routine returns the wrong values for gpios in the
upper bank.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~mfd-sm501-fix-gpio-number-calculation-for-upper-bank drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~mfd-sm501-fix-gpio-number-calculation-for-upper-bank
+++ a/drivers/mfd/sm501.c
@@ -1108,7 +1108,9 @@ static void sm501_gpio_remove(struct sm5
 static inline int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
-	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+	int base = (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+
+	return (pin % 32) + base;
 }
 
 static inline int sm501_gpio_isregistered(struct sm501_devdata *sm)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

mfd-maintainer.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
fb-add-support-for-the-ili9320-video-display-controller-fix.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

