From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:49:56 -0800
Message-ID: <200711052349.lA5Nnuxn025989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162AbXKEXuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:50:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, david-b@pacbell.net


The patch titled
     Blackfin SPI driver: use cpu_relax() to replace continue in while busywait
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin SPI driver: use cpu_relax() to replace continue in while busywait
From: Bryan Wu <bryan.wu@analog.com>

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   78 ++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait
+++ a/drivers/spi/spi_bfin5xx.c
@@ -186,7 +186,7 @@ static int flush(struct driver_data *drv
 
 	/* wait for stop and clear stat */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && limit--)
-		continue;
+		cpu_relax();
 
 	write_STAT(drv_data, BIT_STAT_CLR);
 
@@ -262,7 +262,7 @@ static void null_writer(struct driver_da
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, 0);
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			continue;
+			cpu_relax();
 		drv_data->tx += n_bytes;
 	}
 }
@@ -274,7 +274,7 @@ static void null_reader(struct driver_da
 
 	while (drv_data->rx < drv_data->rx_end) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		dummy_read(drv_data);
 		drv_data->rx += n_bytes;
 	}
@@ -287,12 +287,12 @@ static void u8_writer(struct driver_data
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		++drv_data->tx;
 	}
 }
@@ -303,14 +303,14 @@ static void u8_cs_chg_writer(struct driv
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 
 		cs_deactive(drv_data, chip);
 
@@ -325,7 +325,7 @@ static void u8_reader(struct driver_data
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -334,13 +334,13 @@ static void u8_reader(struct driver_data
 
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 	}
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 	++drv_data->rx;
 }
@@ -351,7 +351,7 @@ static void u8_cs_chg_reader(struct driv
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -363,7 +363,7 @@ static void u8_cs_chg_reader(struct driv
 		cs_deactive(drv_data, chip);
 
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		cs_active(drv_data, chip);
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
@@ -371,7 +371,7 @@ static void u8_cs_chg_reader(struct driv
 	cs_deactive(drv_data, chip);
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u8 *) (drv_data->rx) = read_SHAW(drv_data);
 	++drv_data->rx;
 }
@@ -380,15 +380,15 @@ static void u8_duplex(struct driver_data
 {
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->rx < drv_data->rx_end) {
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 		++drv_data->rx;
 		++drv_data->tx;
@@ -401,16 +401,16 @@ static void u8_cs_chg_duplex(struct driv
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->rx < drv_data->rx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
 
 		cs_deactive(drv_data, chip);
@@ -427,12 +427,12 @@ static void u16_writer(struct driver_dat
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			continue;
+			cpu_relax();
 		drv_data->tx += 2;
 	}
 }
@@ -443,14 +443,14 @@ static void u16_cs_chg_writer(struct dri
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
-			continue;
+			cpu_relax();
 
 		cs_deactive(drv_data, chip);
 
@@ -465,7 +465,7 @@ static void u16_reader(struct driver_dat
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -474,13 +474,13 @@ static void u16_reader(struct driver_dat
 
 	while (drv_data->rx < (drv_data->rx_end - 2)) {
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 	}
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
 	drv_data->rx += 2;
 }
@@ -491,7 +491,7 @@ static void u16_cs_chg_reader(struct dri
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* clear TDBR buffer before read(else it will be shifted out) */
 	write_TDBR(drv_data, 0xFFFF);
@@ -503,7 +503,7 @@ static void u16_cs_chg_reader(struct dri
 		cs_deactive(drv_data, chip);
 
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		cs_active(drv_data, chip);
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
@@ -511,7 +511,7 @@ static void u16_cs_chg_reader(struct dri
 	cs_deactive(drv_data, chip);
 
 	while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-		continue;
+		cpu_relax();
 	*(u16 *) (drv_data->rx) = read_SHAW(drv_data);
 	drv_data->rx += 2;
 }
@@ -520,15 +520,15 @@ static void u16_duplex(struct driver_dat
 {
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	/* in duplex mode, clk is triggered by writing of TDBR */
 	while (drv_data->tx < drv_data->tx_end) {
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
@@ -541,16 +541,16 @@ static void u16_cs_chg_duplex(struct dri
 
 	/* poll for SPI completion before start */
 	while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-		continue;
+		cpu_relax();
 
 	while (drv_data->tx < drv_data->tx_end) {
 		cs_active(drv_data, chip);
 
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
-			continue;
+			cpu_relax();
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
-			continue;
+			cpu_relax();
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
 
 		cs_deactive(drv_data, chip);
@@ -624,7 +624,7 @@ static irqreturn_t dma_irq_handler(int i
 
 	/* Wait for DMA to complete */
 	while (get_dma_curr_irqstat(drv_data->dma_channel) & DMA_RUN)
-		continue;
+		cpu_relax();
 
 	/*
 	 * wait for the last transaction shifted out.  HRM states:
@@ -635,11 +635,11 @@ static irqreturn_t dma_irq_handler(int i
 	if (drv_data->tx != NULL) {
 		while ((read_STAT(drv_data) & TXS) ||
 		       (read_STAT(drv_data) & TXS))
-			continue;
+			cpu_relax();
 	}
 
 	while (!(read_STAT(drv_data) & SPIF))
-		continue;
+		cpu_relax();
 
 	msg->actual_length += drv_data->len_in_bytes;
 
@@ -783,7 +783,7 @@ static void pump_transfers(unsigned long
 
 		/* poll for SPI completion before start */
 		while (!(read_STAT(drv_data) & BIT_STAT_SPIF))
-			continue;
+			cpu_relax();
 
 		/* dirty hack for autobuffer DMA mode */
 		if (drv_data->tx_dma == 0xFFFF) {
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-mm_ptovvtop.patch
spi-initial-bf54x-spi-support.patch
spi-bfin-spi-uses-portmux-calls.patch
spi-spi_bfin-cleanups-error-handling.patch
spi-spi_bfin-handles-spi_transfercs_change.patch
spi-spi_bfin-dont-bypass-spi-framework.patch
spi-spi_bfin-uses-platform-device-resources.patch
spi-spi_bfin-uses-portmux-for-additional-busses.patch
spi-spi_bfin-rearrange-portmux-calls.patch
spi-spi_bfin-change-handling-of-communication-parameters.patch
spi-spi_bfin-relocate-spin-waits.patch
spi-spi_bfin-handle-multiple-spi_masters.patch
spi-spi_bfin-bugfix-for-816-bit-word-sizes.patch
spi-spi_bfin-update-handling-of-delay-after-deselect.patch
spi-spi_bfin-resequence-dma-start-stop.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
