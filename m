From: akpm@linux-foundation.org
Subject: - gpio-define-gpio_is_valid.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:05 -0700
Message-ID: <200804282157.m3SLv5MF018371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965081AbYD1V5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpio: define gpio_is_valid()
has been removed from the -mm tree.  Its filename was
     gpio-define-gpio_is_valid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: define gpio_is_valid()
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Introduce a gpio_is_valid() predicate; use it in gpiolib.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
    [ use inline function; follow the gpio_* naming convention;
      work without gpiolib; all programming interfaces need docs ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |   10 ++++++++++
 drivers/gpio/gpiolib.c     |   14 +++++++-------
 include/asm-generic/gpio.h |   12 ++++++++++++
 3 files changed, 29 insertions(+), 7 deletions(-)

diff -puN Documentation/gpio.txt~gpio-define-gpio_is_valid Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpio-define-gpio_is_valid
+++ a/Documentation/gpio.txt
@@ -107,6 +107,16 @@ type of GPIO controller, and on one part
 The numbers need not be contiguous; either of those platforms could also
 use numbers 2000-2063 to identify GPIOs in a bank of I2C GPIO expanders.
 
+If you want to initialize a structure with an invalid GPIO number, use
+some negative number (perhaps "-EINVAL"); that will never be valid.  To
+test if a number could reference a GPIO, you may use this predicate:
+
+	int gpio_is_valid(int number);
+
+A number that's not valid will be rejected by calls which may request
+or free GPIOs (see below).  Other numbers may also be rejected; for
+example, a number might be valid but unused on a given board.
+
 Whether a platform supports multiple GPIO controllers is currently a
 platform-specific implementation issue.
 
diff -puN drivers/gpio/gpiolib.c~gpio-define-gpio_is_valid drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpio-define-gpio_is_valid
+++ a/drivers/gpio/gpiolib.c
@@ -99,7 +99,7 @@ int gpiochip_add(struct gpio_chip *chip)
 	 * dynamic allocation.  We don't currently support that.
 	 */
 
-	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS) {
+	if (chip->base < 0 || !gpio_is_valid(chip->base  + chip->ngpio)) {
 		status = -EINVAL;
 		goto fail;
 	}
@@ -174,7 +174,7 @@ int gpio_request(unsigned gpio, const ch
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!gpio_is_valid(gpio))
 		goto done;
 	desc = &gpio_desc[gpio];
 	if (desc->chip == NULL)
@@ -209,7 +209,7 @@ void gpio_free(unsigned gpio)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 
-	if (gpio >= ARCH_NR_GPIOS) {
+	if (!gpio_is_valid(gpio)) {
 		WARN_ON(extra_checks);
 		return;
 	}
@@ -245,7 +245,7 @@ const char *gpiochip_is_requested(struct
 {
 	unsigned gpio = chip->base + offset;
 
-	if (gpio >= ARCH_NR_GPIOS || gpio_desc[gpio].chip != chip)
+	if (!gpio_is_valid(gpio) || gpio_desc[gpio].chip != chip)
 		return NULL;
 	if (test_bit(FLAG_REQUESTED, &gpio_desc[gpio].flags) == 0)
 		return NULL;
@@ -276,7 +276,7 @@ int gpio_direction_input(unsigned gpio)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!gpio_is_valid(gpio))
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->get || !chip->direction_input)
@@ -314,7 +314,7 @@ int gpio_direction_output(unsigned gpio,
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!gpio_is_valid(gpio))
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
@@ -531,7 +531,7 @@ static int gpiolib_show(struct seq_file 
 
 	/* REVISIT this isn't locked against gpio_chip removal ... */
 
-	for (gpio = 0; gpio < ARCH_NR_GPIOS; gpio++) {
+	for (gpio = 0; gpio_is_valid(gpio); gpio++) {
 		if (chip == gpio_desc[gpio].chip)
 			continue;
 		chip = gpio_desc[gpio].chip;
diff -puN include/asm-generic/gpio.h~gpio-define-gpio_is_valid include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpio-define-gpio_is_valid
+++ a/include/asm-generic/gpio.h
@@ -16,6 +16,12 @@
 #define ARCH_NR_GPIOS		256
 #endif
 
+static inline int gpio_is_valid(int number)
+{
+	/* only some non-negative numbers are valid */
+	return ((unsigned)number) < ARCH_NR_GPIOS;
+}
+
 struct seq_file;
 struct module;
 
@@ -99,6 +105,12 @@ extern int __gpio_cansleep(unsigned gpio
 
 #else
 
+static inline int gpio_is_valid(int number)
+{
+	/* only non-negative numbers are valid */
+	return number >= 0;
+}
+
 /* platforms that don't directly support access to GPIOs through I2C, SPI,
  * or other blocking infrastructure can use these wrappers.
  */
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

origin.patch

