From: akpm@linux-foundation.org
Subject: [merged] gpio-adp5588-gpio-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:35 -0800
Message-ID: <201101132010.p0DKAGht030050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933670Ab1AMUKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, Michael.Hennerich@analog.com, broonie@opensource.wolfsonmicro.com, buytenh@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     gpio: adp5588-gpio: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-adp5588-gpio-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: adp5588-gpio: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data based
irq_chip functions.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Acked-by: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/adp5588-gpio.c |   39 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff -puN drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-irq_data-conversion drivers/gpio/adp5588-gpio.c
--- a/drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-irq_data-conversion
+++ a/drivers/gpio/adp5588-gpio.c
@@ -146,9 +146,10 @@ static int adp5588_gpio_to_irq(struct gp
 	return dev->irq_base + off;
 }
 
-static void adp5588_irq_bus_lock(unsigned int irq)
+static void adp5588_irq_bus_lock(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+
 	mutex_lock(&dev->irq_lock);
 }
 
@@ -160,9 +161,9 @@ static void adp5588_irq_bus_lock(unsigne
   * and unlocks the bus.
   */
 
-static void adp5588_irq_bus_sync_unlock(unsigned int irq)
+static void adp5588_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++)
@@ -175,31 +176,31 @@ static void adp5588_irq_bus_sync_unlock(
 	mutex_unlock(&dev->irq_lock);
 }
 
-static void adp5588_irq_mask(unsigned int irq)
+static void adp5588_irq_mask(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	unsigned gpio = d->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] &= ~ADP5588_BIT(gpio);
 }
 
-static void adp5588_irq_unmask(unsigned int irq)
+static void adp5588_irq_unmask(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	unsigned gpio = d->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] |= ADP5588_BIT(gpio);
 }
 
-static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
+static int adp5588_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	uint16_t gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	uint16_t gpio = d->irq - dev->irq_base;
 	unsigned bank, bit;
 
 	if ((type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			d->irq, type);
 		return -EINVAL;
 	}
 
@@ -222,11 +223,11 @@ static int adp5588_irq_set_type(unsigned
 
 static struct irq_chip adp5588_irq_chip = {
 	.name			= "adp5588",
-	.mask			= adp5588_irq_mask,
-	.unmask			= adp5588_irq_unmask,
-	.bus_lock		= adp5588_irq_bus_lock,
-	.bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
-	.set_type		= adp5588_irq_set_type,
+	.irq_mask		= adp5588_irq_mask,
+	.irq_unmask		= adp5588_irq_unmask,
+	.irq_bus_lock		= adp5588_irq_bus_lock,
+	.irq_bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
+	.irq_set_type		= adp5588_irq_set_type,
 };
 
 static int adp5588_gpio_read_intstat(struct i2c_client *client, u8 *buf)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
linux-next.patch

