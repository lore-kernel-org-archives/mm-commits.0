From: akpm@linux-foundation.org
Subject: + spi-atmel_spi-update-chipselect-handling.patch added to -mm tree
Date: Sat, 22 Nov 2008 13:14:30 -0800
Message-ID: <200811222114.mAMLEUdZ023548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbYKVVOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Nov 2008 16:14:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haavard.skinnemoen@atmel.com, dbrownell@users.sourceforge.net


The patch titled
     spi: atmel_spi update chipselect handling
has been added to the -mm tree.  Its filename is
     spi-atmel_spi-update-chipselect-handling.patch

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
Subject: spi: atmel_spi update chipselect handling
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

This solves several issues:
  * It fixes the wrong idle clock polarity issue in a cleaner and less
    expensive way.
  * It handles the AT32AP7000 errata "SPI Chip Select 0 BITS field
    overrides other Chip Selects". Other chips, e.g. AT91SAM9261, have
    similar issues.

Currently, the AT91RM9200 code path is left alone. But it might be
interesting to try the same technique on RM9200 using a different CSR
register.

[dbrownell@users.sourceforge.net: restore debug message for activation]
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   93 +++++++++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 26 deletions(-)

diff -puN drivers/spi/atmel_spi.c~spi-atmel_spi-update-chipselect-handling drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-atmel_spi-update-chipselect-handling
+++ a/drivers/spi/atmel_spi.c
@@ -51,6 +51,12 @@ struct atmel_spi {
 	dma_addr_t		buffer_dma;
 };
 
+/* Controller-specific per-slave state */
+struct atmel_spi_device {
+	unsigned int		npcs_pin;
+	u32			csr;
+};
+
 #define BUFFER_SIZE		PAGE_SIZE
 #define INVALID_DMA_ADDRESS	0xffffffff
 
@@ -89,39 +95,58 @@ static bool atmel_spi_is_v2(void)
  * Master on Chip Select 0.")  No workaround exists for that ... so for
  * nCS0 on that chip, we (a) don't use the GPIO, (b) can't support CS_HIGH,
  * and (c) will trigger that first erratum in some cases.
+ *
+ * TODO: Test if the atmel_spi_is_v2() branch below works on
+ * AT91RM9200 if we use some other register than CSR0. However, don't
+ * do this unconditionally since AP7000 has an errata where the BITS
+ * field in CSR0 overrides all other CSRs.
  */
 
 static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 {
-	unsigned gpio = (unsigned) spi->controller_data;
+	struct atmel_spi_device *asd = spi->controller_state;
 	unsigned active = spi->mode & SPI_CS_HIGH;
 	u32 mr;
-	int i;
-	u32 csr;
-	u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
-
-	/* Make sure clock polarity is correct */
-	for (i = 0; i < spi->master->num_chipselect; i++) {
-		csr = spi_readl(as, CSR0 + 4 * i);
-		if ((csr ^ cpol) & SPI_BIT(CPOL))
-			spi_writel(as, CSR0 + 4 * i, csr ^ SPI_BIT(CPOL));
-	}
 
-	mr = spi_readl(as, MR);
-	mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
+	if (atmel_spi_is_v2()) {
+		/*
+		 * Always use CSR0. This ensures that the clock
+		 * switches to the correct idle polarity before we
+		 * toggle the CS.
+		 */
+		spi_writel(as, CSR0, asd->csr);
+		spi_writel(as, MR, SPI_BF(PCS, 0x0e) | SPI_BIT(MODFDIS)
+				| SPI_BIT(MSTR));
+		mr = spi_readl(as, MR);
+		gpio_set_value(asd->npcs_pin, active);
+	} else {
+		u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
+		int i;
+		u32 csr;
+
+		/* Make sure clock polarity is correct */
+		for (i = 0; i < spi->master->num_chipselect; i++) {
+			csr = spi_readl(as, CSR0 + 4 * i);
+			if ((csr ^ cpol) & SPI_BIT(CPOL))
+				spi_writel(as, CSR0 + 4 * i,
+						csr ^ SPI_BIT(CPOL));
+		}
+
+		mr = spi_readl(as, MR);
+		mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
+		if (spi->chip_select != 0)
+			gpio_set_value(asd->npcs_pin, active);
+		spi_writel(as, MR, mr);
+	}
 
 	dev_dbg(&spi->dev, "activate %u%s, mr %08x\n",
-			gpio, active ? " (high)" : "",
+			asd->npcs_pin, active ? " (high)" : "",
 			mr);
-
-	if (atmel_spi_is_v2() || spi->chip_select != 0)
-		gpio_set_value(gpio, active);
-	spi_writel(as, MR, mr);
 }
 
 static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 {
-	unsigned gpio = (unsigned) spi->controller_data;
+	struct atmel_spi_device *asd = spi->controller_state;
 	unsigned active = spi->mode & SPI_CS_HIGH;
 	u32 mr;
 
@@ -135,11 +160,11 @@ static void cs_deactivate(struct atmel_s
 	}
 
 	dev_dbg(&spi->dev, "DEactivate %u%s, mr %08x\n",
-			gpio, active ? " (low)" : "",
+			asd->npcs_pin, active ? " (low)" : "",
 			mr);
 
 	if (atmel_spi_is_v2() || spi->chip_select != 0)
-		gpio_set_value(gpio, !active);
+		gpio_set_value(asd->npcs_pin, !active);
 }
 
 static inline int atmel_spi_xfer_is_last(struct spi_message *msg,
@@ -511,6 +536,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 static int atmel_spi_setup(struct spi_device *spi)
 {
 	struct atmel_spi	*as;
+	struct atmel_spi_device	*asd;
 	u32			scbr, csr;
 	unsigned int		bits = spi->bits_per_word;
 	unsigned long		bus_hz;
@@ -595,11 +621,20 @@ static int atmel_spi_setup(struct spi_de
 
 	/* chipselect must have been muxed as GPIO (e.g. in board setup) */
 	npcs_pin = (unsigned int)spi->controller_data;
-	if (!spi->controller_state) {
+	asd = spi->controller_state;
+	if (!asd) {
+		asd = kzalloc(sizeof(struct atmel_spi_device), GFP_KERNEL);
+		if (!asd)
+			return -ENOMEM;
+
 		ret = gpio_request(npcs_pin, spi->dev.bus_id);
-		if (ret)
+		if (ret) {
+			kfree(asd);
 			return ret;
-		spi->controller_state = (void *)npcs_pin;
+		}
+
+		asd->npcs_pin = npcs_pin;
+		spi->controller_state = asd;
 		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
 	} else {
 		unsigned long		flags;
@@ -611,11 +646,14 @@ static int atmel_spi_setup(struct spi_de
 		spin_unlock_irqrestore(&as->lock, flags);
 	}
 
+	asd->csr = csr;
+
 	dev_dbg(&spi->dev,
 		"setup: %lu Hz bpw %u mode 0x%x -> csr%d %08x\n",
 		bus_hz / scbr, bits, spi->mode, spi->chip_select, csr);
 
-	spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
+	if (!atmel_spi_is_v2())
+		spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
 
 	return 0;
 }
@@ -690,10 +728,11 @@ static int atmel_spi_transfer(struct spi
 static void atmel_spi_cleanup(struct spi_device *spi)
 {
 	struct atmel_spi	*as = spi_master_get_devdata(spi->master);
+	struct atmel_spi_device	*asd = spi->controller_state;
 	unsigned		gpio = (unsigned) spi->controller_data;
 	unsigned long		flags;
 
-	if (!spi->controller_state)
+	if (!asd)
 		return;
 
 	spin_lock_irqsave(&as->lock, flags);
@@ -703,7 +742,9 @@ static void atmel_spi_cleanup(struct spi
 	}
 	spin_unlock_irqrestore(&as->lock, flags);
 
+	spi->controller_state = NULL;
 	gpio_free(gpio);
+	kfree(asd);
 }
 
 /*-------------------------------------------------------------------------*/
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

linux-next.patch
atmel_spi-clean-up-spiv1-quirk-handling.patch
spi-atmel_spi-update-chipselect-handling.patch

