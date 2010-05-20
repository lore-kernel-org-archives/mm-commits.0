From: akpm@linux-foundation.org
Subject: + arm-omap-gpio-implement-set_debounce-method.patch added to -mm tree
Date: Thu, 20 May 2010 11:12:00 -0700
Message-ID: <201005201812.o4KIC01G029223@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757088Ab0ETSMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 14:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: felipe.balbi@nokia.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, tony@atomide.com


The patch titled
     arm: omap: gpio: implement set_debounce method
has been added to the -mm tree.  Its filename is
     arm-omap-gpio-implement-set_debounce-method.patch

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
Subject: arm: omap: gpio: implement set_debounce method
From: Felipe Balbi <felipe.balbi@nokia.com>

OMAP supports debouncing of gpio lines, implement the method using
gpiolib.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/gpio.c |   68 ++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff -puN arch/arm/plat-omap/gpio.c~arm-omap-gpio-implement-set_debounce-method arch/arm/plat-omap/gpio.c
--- a/arch/arm/plat-omap/gpio.c~arm-omap-gpio-implement-set_debounce-method
+++ a/arch/arm/plat-omap/gpio.c
@@ -624,6 +624,59 @@ do {	\
 	__raw_writel(l, base + reg); \
 } while(0)
 
+/**
+ * _set_gpio_debounce - low level gpio debounce time
+ * @bank: the gpio bank we're acting upon
+ * @gpio: the gpio number on this @gpio
+ * @debounce: debounce time to use
+ *
+ * OMAP's debounce time is in 31us steps so we need
+ * to convert and round up to the closest unit.
+ */
+static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
+		unsigned debounce)
+{
+	void __iomem		*reg = bank->base;
+	u32			val;
+	u32			l;
+
+	if (debounce < 32)
+		debounce = 0x01;
+	else if (debounce > 7936)
+		debounce = 0xff;
+	else
+		debounce = (debounce / 0x1f) - 1;
+
+	l = 1 << get_gpio_index(gpio);
+
+	if (cpu_is_omap44xx())
+		reg += OMAP4_GPIO_DEBOUNCINGTIME;
+	else
+		reg += OMAP24XX_GPIO_DEBOUNCE_VAL;
+
+	__raw_writel(debounce, reg);
+
+	reg = bank->base;
+	if (cpu_is_omap44xx())
+		reg += OMAP4_GPIO_DEBOUNCENABLE;
+	else
+		reg += OMAP24XX_GPIO_DEBOUNCE_EN;
+
+	val = __raw_readl(reg);
+
+	if (debounce) {
+		val |= l;
+		if (cpu_is_omap34xx() || cpu_is_omap44xx())
+			clk_enable(bank->dbck);
+	} else {
+		val &= ~l;
+		if (cpu_is_omap34xx() || cpu_is_omap44xx())
+			clk_disable(bank->dbck);
+	}
+
+	__raw_writel(val, reg);
+}
+
 void omap_set_gpio_debounce(int gpio, int enable)
 {
 	struct gpio_bank *bank;
@@ -1656,6 +1709,20 @@ static int gpio_output(struct gpio_chip 
 	return 0;
 }
 
+static int gpio_debounce(struct gpio_chip *chip, unsigned offset,
+		unsigned debounce)
+{
+	struct gpio_bank *bank;
+	unsigned long flags;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock_irqsave(&bank->lock, flags);
+	_set_gpio_debounce(bank, offset, debounce);
+	spin_unlock_irqrestore(&bank->lock, flags);
+
+	return 0;
+}
+
 static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct gpio_bank *bank;
@@ -1909,6 +1976,7 @@ static int __init _omap_gpio_init(void)
 		bank->chip.direction_input = gpio_input;
 		bank->chip.get = gpio_get;
 		bank->chip.direction_output = gpio_output;
+		bank->chip.set_debounce = gpio_debounce;
 		bank->chip.set = gpio_set;
 		bank->chip.to_irq = gpio_2irq;
 		if (bank_is_mpuio(bank)) {
_

Patches currently in -mm which might be from felipe.balbi@nokia.com are

linux-next.patch
gpiolib-introduce-set_debounce-method.patch
arm-omap-gpio-implement-set_debounce-method.patch
arm-omap-switch-over-to-gpio_set_debounce.patch
arm-omap-remove-the-unused-omap_gpio_set_debounce-methods.patch

