From: akpm@linux-foundation.org
Subject: [merged] gpio-langwell-gpio-driver-miscellaneous-clean-ups.patch removed from -mm tree
Date: Thu, 03 Dec 2009 12:35:57 -0800
Message-ID: <200912032035.nB3KZvrO011096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbZLCUfy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 15:35:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alek.du@intel.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: Langwell GPIO driver bugfixes
has been removed from the -mm tree.  Its filename was
     gpio-langwell-gpio-driver-miscellaneous-clean-ups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: Langwell GPIO driver bugfixes
From: Alek Du <alek.du@intel.com>

- Remove wrong and unnecessary unmask operation

- Remove extra GEDR reading

This fixes the loss of interrupts which occurs when two or more pins are
triggered in close succession.

Signed-off-by: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/langwell_gpio.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN drivers/gpio/langwell_gpio.c~gpio-langwell-gpio-driver-miscellaneous-clean-ups drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-langwell-gpio-driver-miscellaneous-clean-ups
+++ a/drivers/gpio/langwell_gpio.c
@@ -144,13 +144,6 @@ static int lnw_irq_type(unsigned irq, un
 
 static void lnw_irq_unmask(unsigned irq)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
-	u32 gpio = irq - lnw->irq_base;
-	u8 reg = gpio / 32;
-	void __iomem *gedr;
-
-	gedr = (void __iomem *)(&lnw->reg_base->GEDR[reg]);
-	writel(BIT(gpio % 32), gedr);
 };
 
 static void lnw_irq_mask(unsigned irq)
@@ -183,13 +176,11 @@ static void lnw_irq_handler(unsigned irq
 		gedr_v = readl(gedr);
 		if (!gedr_v)
 			continue;
-		for (gpio = reg*32; gpio < reg*32+32; gpio++) {
-			gedr_v = readl(gedr);
+		for (gpio = reg*32; gpio < reg*32+32; gpio++)
 			if (gedr_v & BIT(gpio % 32)) {
 				pr_debug("pin %d triggered\n", gpio);
 				generic_handle_irq(lnw->irq_base + gpio);
 			}
-		}
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
_

Patches currently in -mm which might be from alek.du@intel.com are

gpio-fix-test-on-unsigned-in-lnw_irq_type.patch

