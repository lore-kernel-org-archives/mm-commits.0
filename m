From: akpm@linux-foundation.org
Subject: + gpiolib-better-rmmod-infrastructure.patch added to -mm tree
Date: Mon, 11 Feb 2008 14:33:40 -0800
Message-ID: <200802112233.m1BMXfUY004253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbYBKWem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:34:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net


The patch titled
     gpiolib: better rmmod infrastructure
has been added to the -mm tree.  Its filename is
     gpiolib-better-rmmod-infrastructure.patch

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
Subject: gpiolib: better rmmod infrastructure
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

As long as one or more GPIOs on a gpio chip are used its driver should not be
unloaded.  The existing mechanism (gpiochip_remove failure) doesn't address
that, since rmmod can no longer be made to fail by having the cleanup code
report errors.  Module usecounts are the solution.

Assuming standard "initialize struct to zero" policies, this change won't
affect SOC platform drivers.  However, drivers for external chips (on I2C and
SPI busses) should be updated if they can be built as modules.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
[ gpio_ensure_requested() needs to update module usecounts too ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c     |   15 ++++++++++++---
 include/asm-generic/gpio.h |    2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-better-rmmod-infrastructure drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-better-rmmod-infrastructure
+++ a/drivers/gpio/gpiolib.c
@@ -68,6 +68,9 @@ static void gpio_ensure_requested(struct
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
 		desc_set_label(desc, "[auto]");
+		if (!try_module_get(desc->chip->owner))
+			pr_err("GPIO-%d: module can't be gotten \n",
+					(int)(desc - gpio_desc));
 	}
 }
 
@@ -177,6 +180,9 @@ int gpio_request(unsigned gpio, const ch
 	if (desc->chip == NULL)
 		goto done;
 
+	if (!try_module_get(desc->chip->owner))
+		goto done;
+
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled.
 	 */
@@ -184,8 +190,10 @@ int gpio_request(unsigned gpio, const ch
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 		desc_set_label(desc, label ? : "?");
 		status = 0;
-	} else
+	} else {
 		status = -EBUSY;
+		module_put(desc->chip->owner);
+	}
 
 done:
 	if (status)
@@ -209,9 +217,10 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
-	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags))
+	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
 		desc_set_label(desc, NULL);
-	else
+		module_put(desc->chip->owner);
+	} else
 		WARN_ON(extra_checks);
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
diff -puN include/asm-generic/gpio.h~gpiolib-better-rmmod-infrastructure include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-better-rmmod-infrastructure
+++ a/include/asm-generic/gpio.h
@@ -17,6 +17,7 @@
 #endif
 
 struct seq_file;
+struct module;
 
 /**
  * struct gpio_chip - abstract a GPIO controller
@@ -48,6 +49,7 @@ struct seq_file;
  */
 struct gpio_chip {
 	char			*label;
+	struct module		*owner;
 
 	int			(*direction_input)(struct gpio_chip *chip,
 						unsigned offset);
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

origin.patch
lib-scatterlisto-needed-by-a-module-only-link-it-in-unconditionally.patch
git-dvb.patch
gpiolib-better-rmmod-infrastructure.patch
gpiolib-i2c-spi-drivers-handler-rmmod-better.patch
gpio-define-gpio_is_valid.patch
