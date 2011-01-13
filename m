From: akpm@linux-foundation.org
Subject: [merged] gpio-langwell_gpio-irq_data-conversion.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:37 -0800
Message-ID: <201101132010.p0DKAICK030053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933663Ab1AMUKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: buytenh@wantstofly.org, alan@linux.intel.com, alek.du@intel.com, buytenh@secretlab.ca, kangkai.yin@intel.com, mm-commits@vger.kernel.org


The patch titled
     gpio: langwell_gpio: irq_data conversion
has been removed from the -mm tree.  Its filename was
     gpio-langwell_gpio-irq_data-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: langwell_gpio: irq_data conversion
From: Lennert Buytenhek <buytenh@wantstofly.org>

Converts irq_chips and flow handlers over to the new struct irq_data based
irq_chip functions.

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Yin Kangkai <kangkai.yin@intel.com>
Cc: Alek Du <alek.du@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/gpio/langwell_gpio.c~gpio-langwell_gpio-irq_data-conversion drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-langwell_gpio-irq_data-conversion
+++ a/drivers/gpio/langwell_gpio.c
@@ -134,10 +134,10 @@ static int lnw_gpio_to_irq(struct gpio_c
 	return lnw->irq_base + offset;
 }
 
-static int lnw_irq_type(unsigned irq, unsigned type)
+static int lnw_irq_type(struct irq_data *d, unsigned type)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
-	u32 gpio = irq - lnw->irq_base;
+	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
+	u32 gpio = d->irq - lnw->irq_base;
 	unsigned long flags;
 	u32 value;
 	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
@@ -162,19 +162,19 @@ static int lnw_irq_type(unsigned irq, un
 	return 0;
 }
 
-static void lnw_irq_unmask(unsigned irq)
+static void lnw_irq_unmask(struct irq_data *d)
 {
 }
 
-static void lnw_irq_mask(unsigned irq)
+static void lnw_irq_mask(struct irq_data *d)
 {
 }
 
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
-	.mask		= lnw_irq_mask,
-	.unmask		= lnw_irq_unmask,
-	.set_type	= lnw_irq_type,
+	.irq_mask	= lnw_irq_mask,
+	.irq_unmask	= lnw_irq_unmask,
+	.irq_set_type	= lnw_irq_type,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
_

Patches currently in -mm which might be from buytenh@wantstofly.org are

origin.patch
linux-next.patch

