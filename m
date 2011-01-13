From: akpm@linux-foundation.org
Subject: [merged] gpio-max732x-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:39 -0800
Message-ID: <201101132010.p0DKAKZB030056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933703Ab1AMUQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, buytenh@secretlab.ca, eric.y.miao@gmail.com, maz@misterjones.org, mm-commits@vger.kernel.org


The patch titled
     gpio: max732x: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-max732x-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: max732x: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data based
irq_chip functions.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Acked-by: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max732x.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN drivers/gpio/max732x.c~gpio-max732x-irq_data-conversion drivers/gpio/max732x.c
--- a/drivers/gpio/max732x.c~gpio-max732x-irq_data-conversion
+++ a/drivers/gpio/max732x.c
@@ -327,40 +327,40 @@ static int max732x_gpio_to_irq(struct gp
 	return chip->irq_base + off;
 }
 
-static void max732x_irq_mask(unsigned int irq)
+static void max732x_irq_mask(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask_cur &= ~(1 << (irq - chip->irq_base));
+	chip->irq_mask_cur &= ~(1 << (d->irq - chip->irq_base));
 }
 
-static void max732x_irq_unmask(unsigned int irq)
+static void max732x_irq_unmask(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask_cur |= 1 << (irq - chip->irq_base);
+	chip->irq_mask_cur |= 1 << (d->irq - chip->irq_base);
 }
 
-static void max732x_irq_bus_lock(unsigned int irq)
+static void max732x_irq_bus_lock(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&chip->irq_lock);
 	chip->irq_mask_cur = chip->irq_mask;
 }
 
-static void max732x_irq_bus_sync_unlock(unsigned int irq)
+static void max732x_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	max732x_irq_update_mask(chip);
 	mutex_unlock(&chip->irq_lock);
 }
 
-static int max732x_irq_set_type(unsigned int irq, unsigned int type)
+static int max732x_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
-	uint16_t off = irq - chip->irq_base;
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
+	uint16_t off = d->irq - chip->irq_base;
 	uint16_t mask = 1 << off;
 
 	if (!(mask & chip->dir_input)) {
@@ -371,7 +371,7 @@ static int max732x_irq_set_type(unsigned
 
 	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			d->irq, type);
 		return -EINVAL;
 	}
 
@@ -390,11 +390,11 @@ static int max732x_irq_set_type(unsigned
 
 static struct irq_chip max732x_irq_chip = {
 	.name			= "max732x",
-	.mask			= max732x_irq_mask,
-	.unmask			= max732x_irq_unmask,
-	.bus_lock		= max732x_irq_bus_lock,
-	.bus_sync_unlock	= max732x_irq_bus_sync_unlock,
-	.set_type		= max732x_irq_set_type,
+	.irq_mask		= max732x_irq_mask,
+	.irq_unmask		= max732x_irq_unmask,
+	.irq_bus_lock		= max732x_irq_bus_lock,
+	.irq_bus_sync_unlock	= max732x_irq_bus_sync_unlock,
+	.irq_set_type		= max732x_irq_set_type,
 };
 
 static uint8_t max732x_irq_pending(struct max732x_chip *chip)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
linux-next.patch

