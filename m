From: akpm@linux-foundation.org
Subject: + gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch added to -mm tree
Date: Wed, 05 Jan 2011 13:45:33 -0800
Message-ID: <201101052145.p05LjXfo020155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab1AEVqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 16:46:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomoya-linux@dsn.okisemi.com, akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, linus.walleij@stericsson.com, maz@misterjones.org, rabin.vincent@stericsson.com, sameo@linux.intel.com


The patch titled
     drivers/gpio/ml_ioh_gpio.c: fix resource leak
has been added to the -mm tree.  Its filename is
     gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch

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
Subject: drivers/gpio/ml_ioh_gpio.c: fix resource leak
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

- add gpiochip_remove processing in case gpiochip_add fails.

- for readability, move variable initialization to outside for-condition.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/ml_ioh_gpio.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/ml_ioh_gpio.c~gpio-ml_ioh_gpio-ml7213-gpio-driver-fix drivers/gpio/ml_ioh_gpio.c
--- a/drivers/gpio/ml_ioh_gpio.c~gpio-ml_ioh_gpio-ml7213-gpio-driver-fix
+++ a/drivers/gpio/ml_ioh_gpio.c
@@ -208,7 +208,8 @@ static int __devinit ioh_gpio_probe(stru
 		goto err_kzalloc;
 	}
 
-	for (i = 0, chip = chip_save; i < 8; i++, chip++) {
+	chip = chip_save;
+	for (i = 0; i < 8; i++, chip++) {
 		chip->dev = &pdev->dev;
 		chip->base = base;
 		chip->reg = chip->base;
@@ -228,6 +229,12 @@ static int __devinit ioh_gpio_probe(stru
 	return 0;
 
 err_gpiochip_add:
+	for (; i != 0; i--) {
+		chip--;
+		ret = gpiochip_remove(&chip->gpio);
+		if (ret)
+			dev_err(&pdev->dev, "Failed gpiochip_remove(%d)\n", i);
+	}
 	kfree(chip_save);
 
 err_kzalloc:
_

Patches currently in -mm which might be from tomoya-linux@dsn.okisemi.com are

linux-next.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver.patch
gpio-ml_ioh_gpio-ml7213-gpio-driver-fix.patch

