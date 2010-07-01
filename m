From: akpm@linux-foundation.org
Subject: + gpiolib-decouple-might_sleep_if-from-debug.patch added to -mm tree
Date: Thu, 01 Jul 2010 14:10:17 -0700
Message-ID: <201007012110.o61LAHT0027494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab0GAVKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 17:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, ext-jani.1.nikula@nokia.com, ryan@bluewatersys.com


The patch titled
     gpiolib: decouple might_sleep_if() from DEBUG
has been added to the -mm tree.  Its filename is
     gpiolib-decouple-might_sleep_if-from-debug.patch

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
Subject: gpiolib: decouple might_sleep_if() from DEBUG
From: David Brownell <dbrownell@users.sourceforge.net>

Be more consistent about runtime programming interface abuse warnings,
which can reduce some confusion and trigger bugfixes.  Based on an
observation and patch from Jani Nikula.

Also update doc to highlight some sleeping-call issues and to match some
recent changes.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: "Ryan Mallon" <ryan@bluewatersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt |   35 +++++++++++++++++++++++++++++------
 drivers/gpio/gpiolib.c |   12 ++++++------
 2 files changed, 35 insertions(+), 12 deletions(-)

diff -puN Documentation/gpio.txt~gpiolib-decouple-might_sleep_if-from-debug Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-decouple-might_sleep_if-from-debug
+++ a/Documentation/gpio.txt
@@ -158,10 +158,11 @@ and configure pullups/pulldowns appropri
 Spinlock-Safe GPIO access
 -------------------------
 Most GPIO controllers can be accessed with memory read/write instructions.
-That doesn't need to sleep, and can safely be done from inside IRQ handlers.
-(That includes hardirq contexts on RT kernels.)
+Those don't need to sleep, and can safely be done from inside hard
+(nonthreaded) IRQ handlers and similar contexts.
 
-Use these calls to access such GPIOs:
+Use the following calls to access such GPIOs,
+for which gpio_cansleep() will always return false (see below):
 
 	/* GPIO INPUT:  return zero or nonzero */
 	int gpio_get_value(unsigned gpio);
@@ -210,9 +211,31 @@ To access such GPIOs, a different set of
 	/* GPIO OUTPUT, might sleep */
 	void gpio_set_value_cansleep(unsigned gpio, int value);
 
-Other than the fact that these calls might sleep, and will not be ignored
-for GPIOs that can't be accessed from IRQ handlers, these calls act the
-same as the spinlock-safe calls.
+
+Accessing such GPIOs requires a context which may sleep,  for example
+a threaded IRQ handler, and those accessors must be used instead of
+spinlock-safe accessors without the cansleep() name suffix.
+
+Other than the fact that these accessors might sleep, and will work
+on GPIOs that can't be accessed from hardIRQ handlers, these calls act
+the same as the spinlock-safe calls.
+
+  ** IN ADDITION ** calls to setup and configure such GPIOs must be made
+from contexts which may sleep, since they may need to access the GPIO
+controller chip too:  (These setup calls are usually made from board
+setup or driver probe/teardown code, so this is an easy constraint.)
+
+	gpio_direction_input()
+	gpio_direction_output()
+	gpio_request()
+
+## 	gpio_request_one()
+##	gpio_request_array()
+## 	gpio_free_array()
+
+	gpio_free()
+	gpio_set_debounce()
+
 
 
 Claiming and Releasing GPIOs
diff -puN drivers/gpio/gpiolib.c~gpiolib-decouple-might_sleep_if-from-debug drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-decouple-might_sleep_if-from-debug
+++ a/drivers/gpio/gpiolib.c
@@ -1271,7 +1271,7 @@ void gpio_free(unsigned gpio)
 	if (chip && test_bit(FLAG_REQUESTED, &desc->flags)) {
 		if (chip->free) {
 			spin_unlock_irqrestore(&gpio_lock, flags);
-			might_sleep_if(extra_checks && chip->can_sleep);
+			might_sleep_if(chip->can_sleep);
 			chip->free(chip, gpio - chip->base);
 			spin_lock_irqsave(&gpio_lock, flags);
 		}
@@ -1409,7 +1409,7 @@ int gpio_direction_input(unsigned gpio)
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	might_sleep_if(extra_checks && chip->can_sleep);
+	might_sleep_if(chip->can_sleep);
 
 	if (status) {
 		status = chip->request(chip, gpio);
@@ -1462,7 +1462,7 @@ int gpio_direction_output(unsigned gpio,
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	might_sleep_if(extra_checks && chip->can_sleep);
+	might_sleep_if(chip->can_sleep);
 
 	if (status) {
 		status = chip->request(chip, gpio);
@@ -1520,7 +1520,7 @@ int gpio_set_debounce(unsigned gpio, uns
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	might_sleep_if(extra_checks && chip->can_sleep);
+	might_sleep_if(chip->can_sleep);
 
 	return chip->set_debounce(chip, gpio, debounce);
 
@@ -1570,7 +1570,7 @@ int __gpio_get_value(unsigned gpio)
 	struct gpio_chip	*chip;
 
 	chip = gpio_to_chip(gpio);
-	WARN_ON(extra_checks && chip->can_sleep);
+	WARN_ON(chip->can_sleep);
 	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
 }
 EXPORT_SYMBOL_GPL(__gpio_get_value);
@@ -1589,7 +1589,7 @@ void __gpio_set_value(unsigned gpio, int
 	struct gpio_chip	*chip;
 
 	chip = gpio_to_chip(gpio);
-	WARN_ON(extra_checks && chip->can_sleep);
+	WARN_ON(chip->can_sleep);
 	chip->set(chip, gpio - chip->base, value);
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
maintainers-add-patterns-to-omap-usb.patch
gpiolib-decouple-might_sleep_if-from-debug.patch

