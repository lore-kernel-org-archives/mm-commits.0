From: akpm@linux-foundation.org
Subject: - atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:48 -0700
Message-ID: <200705092150.l49Lom9w002832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756567AbXEIVvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, andrew@sanpeople.com, david-b@pacbell.net, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_spi: remove unnecessary (and wrong) #ifdefs
has been removed from the -mm tree.  Its filename was
     atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atmel_spi: remove unnecessary (and wrong) #ifdefs
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Now that the cpu_is_xxx() macros are available both on AVR32 and AT91, we can
remove a couple of #ifdefs from this driver.  One of them is actually wrong --
new_1 should be set on AVR32 but isn't.  This causes the bus clock to run at
twice the speed it is configured to.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Andrew Victor <andrew@sanpeople.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-remove-unnecessary-and-wrong-ifdefs drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-remove-unnecessary-and-wrong-ifdefs
+++ a/drivers/spi/atmel_spi.c
@@ -22,10 +22,7 @@
 #include <asm/io.h>
 #include <asm/arch/board.h>
 #include <asm/arch/gpio.h>
-
-#ifdef CONFIG_ARCH_AT91
 #include <asm/arch/cpu.h>
-#endif
 
 #include "atmel_spi.h"
 
@@ -552,10 +549,8 @@ static int __init atmel_spi_probe(struct
 		goto out_free_buffer;
 	as->irq = irq;
 	as->clk = clk;
-#ifdef CONFIG_ARCH_AT91
 	if (!cpu_is_at91rm9200())
 		as->new_1 = 1;
-#endif
 
 	ret = request_irq(irq, atmel_spi_interrupt, 0,
 			pdev->dev.bus_id, master);
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
