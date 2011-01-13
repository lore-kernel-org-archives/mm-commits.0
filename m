From: akpm@linux-foundation.org
Subject: [merged] gpio-pl061-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:44 -0800
Message-ID: <201101132010.p0DKAPdr030062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933682Ab1AMULL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, baruch@tkos.co.il, buytenh@secretlab.ca, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: pl061: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-pl061-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pl061: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data based
irq_chip functions.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pl061.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/gpio/pl061.c~gpio-pl061-irq_data-conversion drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~gpio-pl061-irq_data-conversion
+++ a/drivers/gpio/pl061.c
@@ -129,10 +129,10 @@ static int pl061_to_irq(struct gpio_chip
 /*
  * PL061 GPIO IRQ
  */
-static void pl061_irq_disable(unsigned irq)
+static void pl061_irq_disable(struct irq_data *d)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq - chip->irq_base;
+	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -143,10 +143,10 @@ static void pl061_irq_disable(unsigned i
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static void pl061_irq_enable(unsigned irq)
+static void pl061_irq_enable(struct irq_data *d)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq - chip->irq_base;
+	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -157,10 +157,10 @@ static void pl061_irq_enable(unsigned ir
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static int pl061_irq_type(unsigned irq, unsigned trigger)
+static int pl061_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq - chip->irq_base;
+	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
 
@@ -203,9 +203,9 @@ static int pl061_irq_type(unsigned irq, 
 
 static struct irq_chip pl061_irqchip = {
 	.name		= "GPIO",
-	.enable		= pl061_irq_enable,
-	.disable	= pl061_irq_disable,
-	.set_type	= pl061_irq_type,
+	.irq_enable	= pl061_irq_enable,
+	.irq_disable	= pl061_irq_disable,
+	.irq_set_type	= pl061_irq_type,
 };
 
 static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
@@ -214,7 +214,7 @@ static void pl061_irq_handler(unsigned i
 	struct list_head *ptr;
 	struct pl061_gpio *chip;
 
-	desc->chip->ack(irq);
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
 		int offset;
@@ -229,7 +229,7 @@ static void pl061_irq_handler(unsigned i
 		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
 			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
-	desc->chip->unmask(irq);
+	desc->irq_data.chip->irq_unmask(&desc->irq_data);
 }
 
 static int pl061_probe(struct amba_device *dev, struct amba_id *id)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
linux-next.patch

