From: akpm@linux-foundation.org
Subject: + atmel_spi-clean-up-spiv1-quirk-handling.patch added to -mm tree
Date: Tue, 18 Nov 2008 21:18:43 -0800
Message-ID: <200811190518.mAJ5Ih1p010806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYKSFTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 00:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, dbrownell@users.sourceforge.net


The patch titled
     atmel_spi: clean up SPIv1 quirk handling
has been added to the -mm tree.  Its filename is
     atmel_spi-clean-up-spiv1-quirk-handling.patch

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
Subject: atmel_spi: clean up SPIv1 quirk handling
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Currently, we have a flag called "new_1" which is basically equivalent
to cpu_is_at91rm9200(). The latter is also called directly a few places.

Clean up this mess by introducing a atmel_spi_v2() function for
determining the controller version, and move all version dependent code
over to use it. This allows us to remove the new_1 flag.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   40 ++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-clean-up-spiv1-quirk-handling drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-clean-up-spiv1-quirk-handling
+++ a/drivers/spi/atmel_spi.c
@@ -30,13 +30,6 @@
  * The core SPI transfer engine just talks to a register bank to set up
  * DMA transfers; transfer queue progress is driven by IRQs.  The clock
  * framework provides the base clock, subdivided for each spi_device.
- *
- * Newer controllers, marked with "new_1" flag, have:
- *  - CR.LASTXFER
- *  - SPI_MR.DIV32 may become FDIV or must-be-zero (here: always zero)
- *  - SPI_SR.TXEMPTY, SPI_SR.NSSR (and corresponding irqs)
- *  - SPI_CSRx.CSAAT
- *  - SPI_CSRx.SBCR allows faster clocking
  */
 struct atmel_spi {
 	spinlock_t		lock;
@@ -45,7 +38,6 @@ struct atmel_spi {
 	int			irq;
 	struct clk		*clk;
 	struct platform_device	*pdev;
-	unsigned		new_1:1;
 	struct spi_device	*stay;
 
 	u8			stopping;
@@ -63,6 +55,23 @@ struct atmel_spi {
 #define INVALID_DMA_ADDRESS	0xffffffff
 
 /*
+ * Version 2 of the SPI controller has
+ *  - CR.LASTXFER
+ *  - SPI_MR.DIV32 may become FDIV or must-be-zero (here: always zero)
+ *  - SPI_SR.TXEMPTY, SPI_SR.NSSR (and corresponding irqs)
+ *  - SPI_CSRx.CSAAT
+ *  - SPI_CSRx.SBCR allows faster clocking
+ *
+ * We can determine the controller version by reading the VERSION
+ * register, but I haven't checked that it exists on all chips, and
+ * this is cheaper anyway.
+ */
+static bool atmel_spi_is_v2(void)
+{
+	return !cpu_is_at91rm9200();
+}
+
+/*
  * Earlier SPI controllers (e.g. on at91rm9200) have a design bug whereby
  * they assume that spi slave device state will not change on deselect, so
  * that automagic deselection is OK.  ("NPCSx rises if no data is to be
@@ -105,7 +114,7 @@ static void cs_activate(struct atmel_spi
 			gpio, active ? " (high)" : "",
 			mr);
 
-	if (!(cpu_is_at91rm9200() && spi->chip_select == 0))
+	if (atmel_spi_is_v2() || spi->chip_select != 0)
 		gpio_set_value(gpio, active);
 	spi_writel(as, MR, mr);
 }
@@ -129,7 +138,7 @@ static void cs_deactivate(struct atmel_s
 			gpio, active ? " (low)" : "",
 			mr);
 
-	if (!(cpu_is_at91rm9200() && spi->chip_select == 0))
+	if (atmel_spi_is_v2() || spi->chip_select != 0)
 		gpio_set_value(gpio, !active);
 }
 
@@ -536,19 +545,16 @@ static int atmel_spi_setup(struct spi_de
 	}
 
 	/* see notes above re chipselect */
-	if (cpu_is_at91rm9200()
+	if (!atmel_spi_is_v2()
 			&& spi->chip_select == 0
 			&& (spi->mode & SPI_CS_HIGH)) {
 		dev_dbg(&spi->dev, "setup: can't be active-high\n");
 		return -EINVAL;
 	}
 
-	/*
-	 * Pre-new_1 chips start out at half the peripheral
-	 * bus speed.
-	 */
+	/* v1 chips start out at half the peripheral bus speed. */
 	bus_hz = clk_get_rate(as->clk);
-	if (!as->new_1)
+	if (!atmel_spi_is_v2())
 		bus_hz /= 2;
 
 	if (spi->max_speed_hz) {
@@ -755,8 +761,6 @@ static int __init atmel_spi_probe(struct
 		goto out_free_buffer;
 	as->irq = irq;
 	as->clk = clk;
-	if (!cpu_is_at91rm9200())
-		as->new_1 = 1;
 
 	ret = request_irq(irq, atmel_spi_interrupt, 0,
 			pdev->dev.bus_id, master);
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

linux-next.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch

