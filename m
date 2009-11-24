From: akpm@linux-foundation.org
Subject: + gpio-langwell-gpio-driver-miscellaneous-clean-ups.patch added to -mm tree
Date: Tue, 24 Nov 2009 12:29:42 -0800
Message-ID: <200911242029.nAOKTg8I029765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932420AbZKXU3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 15:29:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alek.du@intel.com, david-b@pacbell.net


The patch titled
     gpio: Langwell GPIO driver miscellaneous clean-ups and bugfixes
has been added to the -mm tree.  Its filename is
     gpio-langwell-gpio-driver-miscellaneous-clean-ups.patch

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
Subject: gpio: Langwell GPIO driver miscellaneous clean-ups and bugfixes
From: Alek Du <alek.du@intel.com>

1. Use >= N to check invalid gpio number (unsigned type)
2. Remove wrong and unnecessary unmask operation
3. Remove extra GEDR reading

The 2) and 3) will fix interrupts losing when two or more pins are
triggered at close time.

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
gpio-langwell-gpio-driver-miscellaneous-clean-ups.patch

