From: akpm@linux-foundation.org
Subject: + gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add.patch added to -mm tree
Date: Mon, 22 Feb 2010 14:26:07 -0800
Message-ID: <201002222226.o1MMQ7TU027062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754687Ab0BVW0L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 17:26:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, david-b@pacbell.net, grant.likely@secretlab.ca


The patch titled
     gpiolib: cosmetic improvements for error handling in gpiochip_add()
has been added to the -mm tree.  Its filename is
     gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add.patch

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
Subject: gpiolib: cosmetic improvements for error handling in gpiochip_add()
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Hopefully it makes the code look nicer and makes it easier to extend
this function.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Suggested-by: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add
+++ a/drivers/gpio/gpiolib.c
@@ -1103,17 +1103,23 @@ int gpiochip_add(struct gpio_chip *chip)
 
 unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status == 0)
-		status = gpiochip_export(chip);
+
+	if (status)
+		goto fail;
+
+	status = gpiochip_export(chip);
+	if (status)
+		goto fail;
+
+	blocking_notifier_call_chain(&gpio_notifier, GPIO_NOTIFY_CHIP_ADDED,
+				     chip);
+
+	return 0;
 fail:
 	/* failures here can mean systems won't boot... */
-	if (status)
-		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
-			chip->base, chip->base + chip->ngpio - 1,
-			chip->label ? : "generic");
-	else
-		blocking_notifier_call_chain(&gpio_notifier,
-					     GPIO_NOTIFY_CHIP_ADDED, chip);
+	pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
+		chip->base, chip->base + chip->ngpio - 1,
+		chip->label ? : "generic");
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
leds-gpio-fix-default-state-handling-on-of-platforms.patch
adcxx-fix-for-single-channel-adcs.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.patch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch
gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add.patch

