From: akpm@linux-foundation.org
Subject: + gpiolib-request-free-hooks.patch added to -mm tree
Date: Fri, 10 Oct 2008 19:47:09 -0700
Message-ID: <200810110247.m9B2l9MQ002427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717AbYJKCrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 22:47:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, magnus.damm@gmail.com


The patch titled
     gpiolib: request/free hooks
has been added to the -mm tree.  Its filename is
     gpiolib-request-free-hooks.patch

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
Subject: gpiolib: request/free hooks
From: David Brownell <dbrownell@users.sourceforge.net>

Add a new internal mechanism to gpiolib to support low power
operations by letting gpio_chip instances see when their GPIOs
are in use.  When no GPIOs are active, chips may be able to
enter lower powered runtime states by disabling clocks and/or
power domains.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: "Magnus Damm" <magnus.damm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |    4 +
 drivers/gpio/gpiolib.c     |   91 ++++++++++++++++++++++++++++++-----
 include/asm-generic/gpio.h |    9 +++
 3 files changed, 91 insertions(+), 13 deletions(-)

diff -puN Documentation/gpio.txt~gpiolib-request-free-hooks Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-request-free-hooks
+++ a/Documentation/gpio.txt
@@ -240,6 +240,10 @@ signal, or (b) something wrongly believe
 needed to manage a signal that's in active use.  That is, requesting a
 GPIO can serve as a kind of lock.
 
+Some platforms may also use knowledge about what GPIOs are active for
+power management, such as by powering down unused chip sectors and, more
+easily, gating off unused clocks.
+
 These two calls are optional because not not all current Linux platforms
 offer such functionality in their GPIO support; a valid implementation
 could return success for all gpio_request() calls.  Unlike the other calls,
diff -puN drivers/gpio/gpiolib.c~gpiolib-request-free-hooks drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-request-free-hooks
+++ a/drivers/gpio/gpiolib.c
@@ -67,17 +67,28 @@ static inline void desc_set_label(struct
  * when setting direction, and otherwise illegal.  Until board setup code
  * and drivers use explicit requests everywhere (which won't happen when
  * those calls have no teeth) we can't avoid autorequesting.  This nag
- * message should motivate switching to explicit requests...
+ * message should motivate switching to explicit requests... so should
+ * the weaker cleanup after faults, compared to gpio_request().
  */
-static void gpio_ensure_requested(struct gpio_desc *desc)
+static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 {
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
-		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
+		struct gpio_chip *chip = desc->chip;
+		int gpio = chip->base + offset;
+
+		if (!try_module_get(chip->owner)) {
+			pr_err("GPIO-%d: module can't be gotten \n", gpio);
+			clear_bit(FLAG_REQUESTED, &desc->flags);
+			/* lose */
+			return -EIO;
+		}
+		pr_warning("GPIO-%d autorequested\n", gpio);
 		desc_set_label(desc, "[auto]");
-		if (!try_module_get(desc->chip->owner))
-			pr_err("GPIO-%d: module can't be gotten \n",
-					(int)(desc - gpio_desc));
+		/* caller must chip->request() w/o spinlock */
+		if (chip->request)
+			return 1;
 	}
+	return 0;
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
@@ -752,6 +763,7 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
 int gpio_request(unsigned gpio, const char *label)
 {
 	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
 	int			status = -EINVAL;
 	unsigned long		flags;
 
@@ -760,14 +772,15 @@ int gpio_request(unsigned gpio, const ch
 	if (!gpio_is_valid(gpio))
 		goto done;
 	desc = &gpio_desc[gpio];
-	if (desc->chip == NULL)
+	chip = desc->chip;
+	if (chip == NULL)
 		goto done;
 
-	if (!try_module_get(desc->chip->owner))
+	if (!try_module_get(chip->owner))
 		goto done;
 
 	/* NOTE:  gpio_request() can be called in early boot,
-	 * before IRQs are enabled.
+	 * before IRQs are enabled, for non-sleeping (SOC) GPIOs.
 	 */
 
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
@@ -775,7 +788,20 @@ int gpio_request(unsigned gpio, const ch
 		status = 0;
 	} else {
 		status = -EBUSY;
-		module_put(desc->chip->owner);
+		module_put(chip->owner);
+	}
+
+	if (chip->request) {
+		/* chip->request may sleep */
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		status = chip->request(chip, gpio - chip->base);
+		spin_lock_irqsave(&gpio_lock, flags);
+
+		if (status < 0) {
+			desc_set_label(desc, NULL);
+			module_put(chip->owner);
+			clear_bit(FLAG_REQUESTED, &desc->flags);
+		}
 	}
 
 done:
@@ -791,6 +817,7 @@ void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
 
 	might_sleep();
 
@@ -804,9 +831,17 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
-	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
+	chip = desc->chip;
+	if (chip && test_bit(FLAG_REQUESTED, &desc->flags)) {
+		if (chip->free) {
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			might_sleep_if(extra_checks && chip->can_sleep);
+			chip->free(chip, gpio - chip->base);
+			spin_lock_irqsave(&gpio_lock, flags);
+		}
 		desc_set_label(desc, NULL);
 		module_put(desc->chip->owner);
+		clear_bit(FLAG_REQUESTED, &desc->flags);
 	} else
 		WARN_ON(extra_checks);
 
@@ -871,7 +906,9 @@ int gpio_direction_input(unsigned gpio)
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(desc);
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
 
 	/* now we know the gpio is valid and chip won't vanish */
 
@@ -879,9 +916,22 @@ int gpio_direction_input(unsigned gpio)
 
 	might_sleep_if(extra_checks && chip->can_sleep);
 
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
 	status = chip->direction_input(chip, gpio);
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
+lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -909,7 +959,9 @@ int gpio_direction_output(unsigned gpio,
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(desc);
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
 
 	/* now we know the gpio is valid and chip won't vanish */
 
@@ -917,9 +969,22 @@ int gpio_direction_output(unsigned gpio,
 
 	might_sleep_if(extra_checks && chip->can_sleep);
 
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
 	status = chip->direction_output(chip, gpio, value);
 	if (status == 0)
 		set_bit(FLAG_IS_OUT, &desc->flags);
+lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
diff -puN include/asm-generic/gpio.h~gpiolib-request-free-hooks include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-request-free-hooks
+++ a/include/asm-generic/gpio.h
@@ -35,6 +35,10 @@ struct module;
  * @label: for diagnostics
  * @dev: optional device providing the GPIOs
  * @owner: helps prevent removal of modules exporting active GPIOs
+ * @request: optional hook for chip-specific activation, such as
+ *	enabling module power and clock; may sleep
+ * @free: optional hook for chip-specific deactivation, such as
+ *	disabling module power and clock; may sleep
  * @direction_input: configures signal "offset" as input, or returns error
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
@@ -67,6 +71,11 @@ struct gpio_chip {
 	struct device		*dev;
 	struct module		*owner;
 
+	int			(*request)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*free)(struct gpio_chip *chip,
+						unsigned offset);
+
 	int			(*direction_input)(struct gpio_chip *chip,
 						unsigned offset);
 	int			(*get)(struct gpio_chip *chip,
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

git-tip.patch
git-arm.patch
git-avr32.patch
git-net.patch
git-mtd.patch
git-input.patch
git-mfd.patch
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
omap-drivers-switch-to-standard-gpio-calls.patch
gpiolib-request-free-hooks.patch

