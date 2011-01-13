From: akpm@linux-foundation.org
Subject: [merged] gpio-tc35892-gpio-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:52 -0800
Message-ID: <201101132010.p0DKAXWX030072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933746Ab1AMUWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@secretlab.ca, rabin.vincent@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     gpio: tc35892-gpio: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-tc35892-gpio-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: tc35892-gpio: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data based
irq_chip functions.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/tc3589x-gpio.c |   36 +++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/gpio/tc3589x-gpio.c~gpio-tc35892-gpio-irq_data-conversion drivers/gpio/tc3589x-gpio.c
--- a/drivers/gpio/tc3589x-gpio.c~gpio-tc35892-gpio-irq_data-conversion
+++ a/drivers/gpio/tc3589x-gpio.c
@@ -110,10 +110,10 @@ static struct gpio_chip template_chip = 
 	.can_sleep		= 1,
 };
 
-static int tc3589x_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int tc3589x_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc3589x_gpio->irq_base;
+	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc3589x_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -137,16 +137,16 @@ static int tc3589x_gpio_irq_set_type(uns
 	return 0;
 }
 
-static void tc3589x_gpio_irq_lock(unsigned int irq)
+static void tc3589x_gpio_irq_lock(struct irq_data *d)
 {
-	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
+	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&tc3589x_gpio->irq_lock);
 }
 
-static void tc3589x_gpio_irq_sync_unlock(unsigned int irq)
+static void tc3589x_gpio_irq_sync_unlock(struct irq_data *d)
 {
-	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
+	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
 	struct tc3589x *tc3589x = tc3589x_gpio->tc3589x;
 	static const u8 regmap[] = {
 		[REG_IBE]	= TC3589x_GPIOIBE0,
@@ -172,20 +172,20 @@ static void tc3589x_gpio_irq_sync_unlock
 	mutex_unlock(&tc3589x_gpio->irq_lock);
 }
 
-static void tc3589x_gpio_irq_mask(unsigned int irq)
+static void tc3589x_gpio_irq_mask(struct irq_data *d)
 {
-	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc3589x_gpio->irq_base;
+	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc3589x_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	tc3589x_gpio->regs[REG_IE][regoffset] &= ~mask;
 }
 
-static void tc3589x_gpio_irq_unmask(unsigned int irq)
+static void tc3589x_gpio_irq_unmask(struct irq_data *d)
 {
-	struct tc3589x_gpio *tc3589x_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc3589x_gpio->irq_base;
+	struct tc3589x_gpio *tc3589x_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc3589x_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -194,11 +194,11 @@ static void tc3589x_gpio_irq_unmask(unsi
 
 static struct irq_chip tc3589x_gpio_irq_chip = {
 	.name			= "tc3589x-gpio",
-	.bus_lock		= tc3589x_gpio_irq_lock,
-	.bus_sync_unlock	= tc3589x_gpio_irq_sync_unlock,
-	.mask			= tc3589x_gpio_irq_mask,
-	.unmask			= tc3589x_gpio_irq_unmask,
-	.set_type		= tc3589x_gpio_irq_set_type,
+	.irq_bus_lock		= tc3589x_gpio_irq_lock,
+	.irq_bus_sync_unlock	= tc3589x_gpio_irq_sync_unlock,
+	.irq_mask		= tc3589x_gpio_irq_mask,
+	.irq_unmask		= tc3589x_gpio_irq_unmask,
+	.irq_set_type		= tc3589x_gpio_irq_set_type,
 };
 
 static irqreturn_t tc3589x_gpio_irq(int irq, void *dev)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
linux-next.patch

