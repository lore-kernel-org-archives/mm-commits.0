From: akpm@linux-foundation.org
Subject: + arm-omap-remove-the-unused-omap_gpio_set_debounce-methods.patch added to -mm tree
Date: Thu, 20 May 2010 11:12:04 -0700
Message-ID: <201005201812.o4KIC4TV029237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085Ab0ETSMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 14:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: felipe.balbi@nokia.com, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, tony@atomide.com


The patch titled
     arm: omap: remove the unused omap_gpio_set_debounce methods
has been added to the -mm tree.  Its filename is
     arm-omap-remove-the-unused-omap_gpio_set_debounce-methods.patch

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
Subject: arm: omap: remove the unused omap_gpio_set_debounce methods
From: Felipe Balbi <felipe.balbi@nokia.com>

Nobody uses that anymore, so remove and expect drivers to use the gpiolib
implementation.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/gpio.c |   74 ------------------------------------
 1 file changed, 74 deletions(-)

diff -puN arch/arm/plat-omap/gpio.c~arm-omap-remove-the-unused-omap_gpio_set_debounce-methods arch/arm/plat-omap/gpio.c
--- a/arch/arm/plat-omap/gpio.c~arm-omap-remove-the-unused-omap_gpio_set_debounce-methods
+++ a/arch/arm/plat-omap/gpio.c
@@ -677,80 +677,6 @@ static void _set_gpio_debounce(struct gp
 	__raw_writel(val, reg);
 }
 
-void omap_set_gpio_debounce(int gpio, int enable)
-{
-	struct gpio_bank *bank;
-	void __iomem *reg;
-	unsigned long flags;
-	u32 val, l = 1 << get_gpio_index(gpio);
-
-	if (cpu_class_is_omap1())
-		return;
-
-	bank = get_gpio_bank(gpio);
-	reg = bank->base;
-
-	if (cpu_is_omap44xx())
-		reg += OMAP4_GPIO_DEBOUNCENABLE;
-	else
-		reg += OMAP24XX_GPIO_DEBOUNCE_EN;
-
-	if (!(bank->mod_usage & l)) {
-		printk(KERN_ERR "GPIO %d not requested\n", gpio);
-		return;
-	}
-
-	spin_lock_irqsave(&bank->lock, flags);
-	val = __raw_readl(reg);
-
-	if (enable && !(val & l))
-		val |= l;
-	else if (!enable && (val & l))
-		val &= ~l;
-	else
-		goto done;
-
-	if (cpu_is_omap34xx() || cpu_is_omap44xx()) {
-		bank->dbck_enable_mask = val;
-		if (enable)
-			clk_enable(bank->dbck);
-		else
-			clk_disable(bank->dbck);
-	}
-
-	__raw_writel(val, reg);
-done:
-	spin_unlock_irqrestore(&bank->lock, flags);
-}
-EXPORT_SYMBOL(omap_set_gpio_debounce);
-
-void omap_set_gpio_debounce_time(int gpio, int enc_time)
-{
-	struct gpio_bank *bank;
-	void __iomem *reg;
-
-	if (cpu_class_is_omap1())
-		return;
-
-	bank = get_gpio_bank(gpio);
-	reg = bank->base;
-
-	if (!bank->mod_usage) {
-		printk(KERN_ERR "GPIO not requested\n");
-		return;
-	}
-
-	enc_time &= 0xff;
-
-	if (cpu_is_omap44xx())
-		reg += OMAP4_GPIO_DEBOUNCINGTIME;
-	else
-		reg += OMAP24XX_GPIO_DEBOUNCE_VAL;
-
-	__raw_writel(enc_time, reg);
-}
-EXPORT_SYMBOL(omap_set_gpio_debounce_time);
