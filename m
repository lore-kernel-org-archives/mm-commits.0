From: akpm@linux-foundation.org
Subject: - gpiolib-gpio_to_irq-hooks.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:01 -0700
Message-ID: <200810182316.m9ING1gH028731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560AbYJRXQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: gpio_to_irq() hooks
has been removed from the -mm tree.  Its filename was
     gpiolib-gpio_to_irq-hooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: gpio_to_irq() hooks
From: David Brownell <dbrownell@users.sourceforge.net>

Add a new gpiolib mechanism: gpio_chip instances can provide mappings
between their (input) GPIOs and any associated IRQs.  This makes it easier
for platforms to support IRQs that are provided by board-specific external
chips instead of as part of their core (such as SOC-integrated GPIOs).

Also update the irq_to_gpio() description, saying to avoid it because it's
not always supported.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |    5 +++--
 drivers/gpio/gpiolib.c     |   18 ++++++++++++++++++
 include/asm-generic/gpio.h |    7 +++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff -puN Documentation/gpio.txt~gpiolib-gpio_to_irq-hooks Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-gpio_to_irq-hooks
+++ a/Documentation/gpio.txt
@@ -264,7 +264,7 @@ map between them using calls like:
 	/* map GPIO numbers to IRQ numbers */
 	int gpio_to_irq(unsigned gpio);
 
-	/* map IRQ numbers to GPIO numbers */
+	/* map IRQ numbers to GPIO numbers (avoid using this) */
 	int irq_to_gpio(unsigned irq);
 
 Those return either the corresponding number in the other namespace, or
@@ -284,7 +284,8 @@ system wakeup capabilities.
 
 Non-error values returned from irq_to_gpio() would most commonly be used
 with gpio_get_value(), for example to initialize or update driver state
-when the IRQ is edge-triggered.
+when the IRQ is edge-triggered.  Note that some platforms don't support
+this reverse mapping, so you should avoid using it.
 
 
 Emulating Open Drain Signals
diff -puN drivers/gpio/gpiolib.c~gpiolib-gpio_to_irq-hooks drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-gpio_to_irq-hooks
+++ a/drivers/gpio/gpiolib.c
@@ -1010,6 +1010,24 @@ int __gpio_cansleep(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_cansleep);
 
+/**
+ * __gpio_to_irq() - return the IRQ corresponding to a GPIO
+ * @gpio: gpio whose IRQ will be returned (already requested)
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_to_irq().
+ * It returns the number of the IRQ signaled by this (input) GPIO,
+ * or a negative errno.
+ */
+int __gpio_to_irq(unsigned gpio)
+{
+	struct gpio_chip	*chip;
+
+	chip = gpio_to_chip(gpio);
+	return chip->to_irq ? chip->to_irq(chip, gpio - chip->base) : -ENXIO;
+}
+EXPORT_SYMBOL_GPL(__gpio_to_irq);
+
 
 
 /* There's no value in making it easy to inline GPIO calls that may sleep.
diff -puN include/asm-generic/gpio.h~gpiolib-gpio_to_irq-hooks include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-gpio_to_irq-hooks
+++ a/include/asm-generic/gpio.h
@@ -40,6 +40,8 @@ struct module;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
+ *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
  *	will be used when this is omitted, but custom code can show extra
  *	state (such as pullup/pulldown configuration).
@@ -73,6 +75,10 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
+
+	int			(*to_irq)(struct gpio_chip *chip,
+						unsigned offset);
+
 	void			(*dbg_show)(struct seq_file *s,
 						struct gpio_chip *chip);
 	int			base;
@@ -112,6 +118,7 @@ extern void __gpio_set_value(unsigned gp
 
 extern int __gpio_cansleep(unsigned gpio);
 
+extern int __gpio_to_irq(unsigned gpio);
 
 #ifdef CONFIG_GPIO_SYSFS
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
rtc-cmos-export-second-nvram-bank.patch
gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch
gpiolib-fix-oops-in-gpio_get_value_cansleep.patch

