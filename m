From: akpm@linux-foundation.org
Subject: - gpiolib-better-rmmod-infrastructure.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:00 -0700
Message-ID: <200804282157.m3SLv0TH018291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965117AbYD1V5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: better rmmod infrastructure
has been removed from the -mm tree.  Its filename was
     gpiolib-better-rmmod-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

