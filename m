From: akpm@linux-foundation.org
Subject: [merged] gpio-stmpe-gpio-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:47 -0800
Message-ID: <201101132010.p0DKASac030065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45006 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933670Ab1AMULN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@secretlab.ca, l.fu@pengutronix.de, linus.walleij@stericsson.com, rabin.vincent@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     gpio: stmpe-gpio: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-stmpe-gpio-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: stmpe-gpio: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data based
irq_chip functions.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Luotao Fu <l.fu@pengutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/stmpe-gpio.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/gpio/stmpe-gpio.c~gpio-stmpe-gpio-irq_data-conversion drivers/gpio/stmpe-gpio.c
--- a/drivers/gpio/stmpe-gpio.c~gpio-stmpe-gpio-irq_data-conversion
+++ a/drivers/gpio/stmpe-gpio.c
@@ -122,10 +122,10 @@ static struct gpio_chip template_chip = 
 	.can_sleep		= 1,
 };
 
-static int stmpe_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
-	int offset = irq - stmpe_gpio->irq_base;
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -145,16 +145,16 @@ static int stmpe_gpio_irq_set_type(unsig
 	return 0;
 }
 
-static void stmpe_gpio_irq_lock(unsigned int irq)
+static void stmpe_gpio_irq_lock(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&stmpe_gpio->irq_lock);
 }
 
-static void stmpe_gpio_irq_sync_unlock(unsigned int irq)
+static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
 	int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
 	static const u8 regmap[] = {
@@ -180,20 +180,20 @@ static void stmpe_gpio_irq_sync_unlock(u
 	mutex_unlock(&stmpe_gpio->irq_lock);
 }
 
-static void stmpe_gpio_irq_mask(unsigned int irq)
+static void stmpe_gpio_irq_mask(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
-	int offset = irq - stmpe_gpio->irq_base;
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	stmpe_gpio->regs[REG_IE][regoffset] &= ~mask;
 }
 
-static void stmpe_gpio_irq_unmask(unsigned int irq)
+static void stmpe_gpio_irq_unmask(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
-	int offset = irq - stmpe_gpio->irq_base;
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -202,11 +202,11 @@ static void stmpe_gpio_irq_unmask(unsign
 
 static struct irq_chip stmpe_gpio_irq_chip = {
 	.name			= "stmpe-gpio",
-	.bus_lock		= stmpe_gpio_irq_lock,
-	.bus_sync_unlock	= stmpe_gpio_irq_sync_unlock,
-	.mask			= stmpe_gpio_irq_mask,
-	.unmask			= stmpe_gpio_irq_unmask,
-	.set_type		= stmpe_gpio_irq_set_type,
+	.irq_bus_lock		= stmpe_gpio_irq_lock,
+	.irq_bus_sync_unlock	= stmpe_gpio_irq_sync_unlock,
+	.irq_mask		= stmpe_gpio_irq_mask,
+	.irq_unmask		= stmpe_gpio_irq_unmask,
+	.irq_set_type		= stmpe_gpio_irq_set_type,
 };
 
 static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
linux-next.patch

