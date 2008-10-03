From: akpm@linux-foundation.org
Subject: + gpiolib-gpio_to_irq-hooks.patch added to -mm tree
Date: Thu, 02 Oct 2008 17:03:53 -0700
Message-ID: <200810030003.m9303rDA001361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753338AbYJCAEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 20:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     gpiolib: gpio_to_irq() hooks
has been added to the -mm tree.  Its filename is
     gpiolib-gpio_to_irq-hooks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

rtc-fix-kernel-panic-on-second-use-of-sigio-nofitication.patch
orion_spi-fix-handling-of-default-transfer-speed.patch
git-arm.patch
git-avr32.patch
git-x86.patch
git-mtd.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
spi-simplify-spi_write_then_read.patch
spi_s3c24xx-pin-configuration-updates.patch
pxa2xx_spi-minor-cleanup.patch
pxa2xx_spi-fix-chip_info-defaults-and-documentation.patch
orion_spi-handle-88f6183-erratum.patch
spi-core-and-gpio-expanders-use-subsys_init.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
rtc-cmos-strongly-avoid-hpet-emulation.patch
rtc-cmos-export-second-nvram-bank.patch
make-gpiochip-label-const.patch
gpio-i2c-expanders-use-subsys_init.patch
gpiolib-gpio_to_irq-hooks.patch

