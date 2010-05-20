From: akpm@linux-foundation.org
Subject: + gpiolib-introduce-set_debounce-method.patch added to -mm tree
Date: Thu, 20 May 2010 11:11:58 -0700
Message-ID: <201005201811.o4KIBwee029220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757087Ab0ETSMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 14:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: felipe.balbi@nokia.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, tony@atomide.com


The patch titled
     gpiolib: introduce set_debounce method
has been added to the -mm tree.  Its filename is
     gpiolib-introduce-set_debounce-method.patch

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
Subject: gpiolib: introduce set_debounce method
From: Felipe Balbi <felipe.balbi@nokia.com>

A few architectures, like OMAP, allow you to set a debouncing time for the
gpio before generating the IRQ.  Teach gpiolib about that.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c     |   43 +++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    5 ++++
 include/linux/gpio.h       |    5 ++++
 3 files changed, 53 insertions(+)

diff -puN drivers/gpio/gpiolib.c~gpiolib-introduce-set_debounce-method drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-introduce-set_debounce-method
+++ a/drivers/gpio/gpiolib.c
@@ -1466,6 +1466,49 @@ fail:
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
 
+/**
+ * gpio_set_debounce - sets @debounce time for a @gpio
+ * @gpio: the gpio to set debounce time
+ * @debounce: debounce time is microseconds
+ */
+int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	unsigned long		flags;
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+	chip = desc->chip;
+	if (!chip || !chip->set || !chip->set_debounce)
+		goto fail;
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
+
+	/* now we know the gpio is valid and chip won't vanish */
+
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	might_sleep_if(extra_checks && chip->can_sleep);
+
+	return chip->set_debounce(chip, gpio, debounce);
+
+fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_set_debounce);
 
 /* I/O calls are only valid after configuration completed; the relevant
  * "is this a valid GPIO" error checks should already have been done.
diff -puN include/asm-generic/gpio.h~gpiolib-introduce-set_debounce-method include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-introduce-set_debounce-method
+++ a/include/asm-generic/gpio.h
@@ -91,6 +91,9 @@ struct gpio_chip {
 						unsigned offset);
 	int			(*direction_output)(struct gpio_chip *chip,
 						unsigned offset, int value);
+	int			(*set_debounce)(struct gpio_chip *chip,
+						unsigned offset, unsigned debounce);
+
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
 
@@ -124,6 +127,8 @@ extern void gpio_free(unsigned gpio);
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
 
+extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
+
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
diff -puN include/linux/gpio.h~gpiolib-introduce-set_debounce-method include/linux/gpio.h
--- a/include/linux/gpio.h~gpiolib-introduce-set_debounce-method
+++ a/include/linux/gpio.h
@@ -51,6 +51,11 @@ static inline int gpio_direction_output(
 	return -ENOSYS;
 }
 
+static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_get_value(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
_

Patches currently in -mm which might be from felipe.balbi@nokia.com are

linux-next.patch
gpiolib-introduce-set_debounce-method.patch
arm-omap-gpio-implement-set_debounce-method.patch
arm-omap-switch-over-to-gpio_set_debounce.patch
arm-omap-remove-the-unused-omap_gpio_set_debounce-methods.patch

