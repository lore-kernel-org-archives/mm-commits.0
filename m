From: akpm@linux-foundation.org
Subject: - atmel_spi-work-around-required-for-new-hw-bug-in-at91sam9263-revb-spi-controller.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:12 -0800
Message-ID: <200811132127.mADLRCQN027799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbYKMV1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jcl@develtech.com, david-b@pacbell.net, haavard.skinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_spi: work-around required for new HW bug in AT91SAM9263 Rev.B SPI controller
has been removed from the -mm tree.  Its filename was
     atmel_spi-work-around-required-for-new-hw-bug-in-at91sam9263-revb-spi-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_spi: work-around required for new HW bug in AT91SAM9263 Rev.B SPI controller
From: Jean-Christophe Lallemand <jcl@develtech.com>

We're working with an AT91SAM9263 Rev B in our design and I experienced
some inconsistency in spi-based touchscreen usage between our board and
the Atmel evaluation kit we have that runs on a Rev A chip.  The data was
apparently delayed by 1 byte and got ridiculous data out of the
touchscreen driver, very strange.  As everything looked normal in the spi,
touchscreen and dma logs, I contacted the Atmel support and they triggered
me on a new HW bug that appeared in the Rev B SPI controller.

The problem is that the SPI controller on the Rev B needs that the
software reset is performed two times so that it's performed correctly.

Applying the patch below solves the issue on my Rev B board.  I've tested
it as well on my Rev A evaluation kit and it has apparently no unwanted
side effect, things continue to work as expected.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-work-around-required-for-new-hw-bug-in-at91sam9263-revb-spi-controller drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-work-around-required-for-new-hw-bug-in-at91sam9263-revb-spi-controller
+++ a/drivers/spi/atmel_spi.c
@@ -766,6 +766,7 @@ static int __init atmel_spi_probe(struct
 	/* Initialize the hardware */
 	clk_enable(clk);
 	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
 	spi_writel(as, MR, SPI_BIT(MSTR) | SPI_BIT(MODFDIS));
 	spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
 	spi_writel(as, CR, SPI_BIT(SPIEN));
@@ -782,6 +783,7 @@ static int __init atmel_spi_probe(struct
 
 out_reset_hw:
 	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
 	clk_disable(clk);
 	free_irq(irq, master);
 out_unmap_regs:
@@ -805,6 +807,7 @@ static int __exit atmel_spi_remove(struc
 	spin_lock_irq(&as->lock);
 	as->stopping = 1;
 	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
 	spi_readl(as, SR);
 	spin_unlock_irq(&as->lock);
 
_

Patches currently in -mm which might be from jcl@develtech.com are

origin.patch

