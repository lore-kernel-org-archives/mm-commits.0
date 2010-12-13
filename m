From: akpm@linux-foundation.org
Subject: + gpio-sx150x-irq_data-conversion.patch added to -mm tree
Date: Mon, 13 Dec 2010 15:51:19 -0800
Message-ID: <201012132351.oBDNpJIS019677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756767Ab0LMXvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 18:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: buytenh@wantstofly.org, buytenh@secretlab.ca, gbean@codeaurora.org


The patch titled
     gpio: sx150x: irq_data conversion
has been added to the -mm tree.  Its filename is
     gpio-sx150x-irq_data-conversion.patch

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
Subject: gpio: sx150x: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Gregory Bean <gbean@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/sx150x.c |   46 ++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN drivers/gpio/sx150x.c~gpio-sx150x-irq_data-conversion drivers/gpio/sx150x.c
--- a/drivers/gpio/sx150x.c~gpio-sx150x-irq_data-conversion
+++ a/drivers/gpio/sx150x.c
@@ -304,36 +304,36 @@ static int sx150x_gpio_to_irq(struct gpi
 	return chip->irq_base + offset;
 }
 
-static void sx150x_irq_mask(unsigned int irq)
+static void sx150x_irq_mask(struct irq_data *d)
 {
-	struct irq_chip *ic = get_irq_chip(irq);
+	struct irq_chip *ic = irq_data_get_irq_chip(d);
 	struct sx150x_chip *chip;
 	unsigned n;
 
 	chip = container_of(ic, struct sx150x_chip, irq_chip);
-	n = irq - chip->irq_base;
+	n = d->irq - chip->irq_base;
 
 	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 1);
 	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense, 0);
 }
 
-static void sx150x_irq_unmask(unsigned int irq)
+static void sx150x_irq_unmask(struct irq_data *d)
 {
-	struct irq_chip *ic = get_irq_chip(irq);
+	struct irq_chip *ic = irq_data_get_irq_chip(d);
 	struct sx150x_chip *chip;
 	unsigned n;
 
 	chip = container_of(ic, struct sx150x_chip, irq_chip);
-	n = irq - chip->irq_base;
+	n = d->irq - chip->irq_base;
 
 	sx150x_write_cfg(chip, n, 1, chip->dev_cfg->reg_irq_mask, 0);
 	sx150x_write_cfg(chip, n, 2, chip->dev_cfg->reg_sense,
 			 chip->irq_sense >> (n * 2));
 }
 
-static int sx150x_irq_set_type(unsigned int irq, unsigned int flow_type)
+static int sx150x_irq_set_type(struct irq_data *d, unsigned int flow_type)
 {
-	struct irq_chip *ic = get_irq_chip(irq);
+	struct irq_chip *ic = irq_data_get_irq_chip(d);
 	struct sx150x_chip *chip;
 	unsigned n, val = 0;
 
@@ -341,7 +341,7 @@ static int sx150x_irq_set_type(unsigned 
 		return -EINVAL;
 
 	chip = container_of(ic, struct sx150x_chip, irq_chip);
-	n = irq - chip->irq_base;
+	n = d->irq - chip->irq_base;
 
 	if (flow_type & IRQ_TYPE_EDGE_RISING)
 		val |= 0x1;
@@ -386,9 +386,9 @@ static irqreturn_t sx150x_irq_thread_fn(
 	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
 }
 
-static void sx150x_irq_bus_lock(unsigned int irq)
+static void sx150x_irq_bus_lock(struct irq_data *d)
 {
-	struct irq_chip *ic = get_irq_chip(irq);
+	struct irq_chip *ic = irq_data_get_irq_chip(d);
 	struct sx150x_chip *chip;
 
 	chip = container_of(ic, struct sx150x_chip, irq_chip);
@@ -396,9 +396,9 @@ static void sx150x_irq_bus_lock(unsigned
 	mutex_lock(&chip->lock);
 }
 
-static void sx150x_irq_bus_sync_unlock(unsigned int irq)
+static void sx150x_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct irq_chip *ic = get_irq_chip(irq);
+	struct irq_chip *ic = irq_data_get_irq_chip(d);
 	struct sx150x_chip *chip;
 	unsigned n;
 
@@ -437,16 +437,16 @@ static void sx150x_init_chip(struct sx15
 	if (pdata->oscio_is_gpo)
 		++chip->gpio_chip.ngpio;
 
-	chip->irq_chip.name            = client->name;
-	chip->irq_chip.mask            = sx150x_irq_mask;
-	chip->irq_chip.unmask          = sx150x_irq_unmask;
-	chip->irq_chip.set_type        = sx150x_irq_set_type;
-	chip->irq_chip.bus_lock        = sx150x_irq_bus_lock;
-	chip->irq_chip.bus_sync_unlock = sx150x_irq_bus_sync_unlock;
-	chip->irq_summary              = -1;
-	chip->irq_base                 = -1;
-	chip->irq_sense                = 0;
-	chip->irq_set_type_pending     = 0;
+	chip->irq_chip.name                = client->name;
+	chip->irq_chip.irq_mask            = sx150x_irq_mask;
+	chip->irq_chip.irq_unmask          = sx150x_irq_unmask;
+	chip->irq_chip.irq_set_type        = sx150x_irq_set_type;
+	chip->irq_chip.irq_bus_lock        = sx150x_irq_bus_lock;
+	chip->irq_chip.irq_bus_sync_unlock = sx150x_irq_bus_sync_unlock;
+	chip->irq_summary                  = -1;
+	chip->irq_base                     = -1;
+	chip->irq_sense                    = 0;
+	chip->irq_set_type_pending         = 0;
 }
 
 static int sx150x_init_io(struct sx150x_chip *chip, u8 base, u16 cfg)
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

linux-next.patch
maintainers-openwrt-devel-is-subscribers-only.patch
gpio-adp5588-gpio-irq_data-conversion.patch
gpio-langwell_gpio-irq_data-conversion.patch
gpio-max732x-irq_data-conversion.patch
gpio-pca953x-irq_data-conversion.patch
gpio-pl061-irq_data-conversion.patch
gpio-stmpe-gpio-irq_data-conversion.patch
gpio-sx150x-irq_data-conversion.patch
gpio-tc35892-gpio-irq_data-conversion.patch
gpio-timbgpio-irq_data-conversion.patch
gpio-vr41xx_giu-irq_data-conversion.patch

