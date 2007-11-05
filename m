From: akpm@linux-foundation.org
Subject: + blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch added to -mm tree
Date: Mon, 05 Nov 2007 15:50:04 -0800
Message-ID: <200711052350.lA5No4fA026007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754241AbXKEXu3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 18:50:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, david-b@pacbell.net


The patch titled
     Blackfin SPI driver: reconfigure speed_hz and bits_per_word in each spi transfer
has been added to the -mm tree.  Its filename is
     blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Blackfin SPI driver: reconfigure speed_hz and bits_per_word in each spi transfer
From: Bryan Wu <bryan.wu@analog.com>

 - reconfigure SPI baud from speed_hz of each spi transfer
 - according to spi_transfer.bits_per_word to reprogram register and setup
   correct SPI operation handlers

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   52 +++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 7 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer
+++ a/drivers/spi/spi_bfin5xx.c
@@ -234,10 +234,8 @@ static int restore_state(struct driver_d
 	dev_dbg(&drv_data->pdev->dev, "restoring spi ctl state\n");
 
 	/* Load the registers */
-	write_BAUD(drv_data, chip->baud);
-	chip->ctl_reg &= (~BIT_CTL_TIMOD);
-	chip->ctl_reg |= (chip->width << 8);
 	write_CTRL(drv_data, chip->ctl_reg);
+	write_BAUD(drv_data, chip->baud);
 
 	bfin_spi_enable(drv_data);
 	cs_active(drv_data, chip);
@@ -679,6 +677,7 @@ static void pump_transfers(unsigned long
 	message = drv_data->cur_msg;
 	transfer = drv_data->cur_transfer;
 	chip = drv_data->cur_chip;
+
 	/*
 	 * if msg is error or done, report it back using complete() callback
 	 */
@@ -736,15 +735,48 @@ static void pump_transfers(unsigned long
 	drv_data->len_in_bytes = transfer->len;
 	drv_data->cs_change = transfer->cs_change;
 
-	width = chip->width;
+	/* Bits per word setup */
+	switch (transfer->bits_per_word) {
+	case 8:
+		drv_data->n_bytes = 1;
+		width = CFG_SPI_WORDSIZE8;
+		drv_data->read = chip->cs_change_per_word ?
+			u8_cs_chg_reader : u8_reader;
+		drv_data->write = chip->cs_change_per_word ?
+			u8_cs_chg_writer : u8_writer;
+		drv_data->duplex = chip->cs_change_per_word ?
+			u8_cs_chg_duplex : u8_duplex;
+		break;
+
+	case 16:
+		drv_data->n_bytes = 2;
+		width = CFG_SPI_WORDSIZE16;
+		drv_data->read = chip->cs_change_per_word ?
+			u16_cs_chg_reader : u16_reader;
+		drv_data->write = chip->cs_change_per_word ?
+			u16_cs_chg_writer : u16_writer;
+		drv_data->duplex = chip->cs_change_per_word ?
+			u16_cs_chg_duplex : u16_duplex;
+		break;
+
+	default:
+		/* No change, the same as default setting */
+		drv_data->n_bytes = chip->n_bytes;
+		width = chip->width;
+		drv_data->write = drv_data->tx ? chip->write : null_writer;
+		drv_data->read = drv_data->rx ? chip->read : null_reader;
+		drv_data->duplex = chip->duplex ? chip->duplex : null_writer;
+		break;
+	}
+	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
+	cr |= (width << 8);
+	write_CTRL(drv_data, cr);
+
 	if (width == CFG_SPI_WORDSIZE16) {
 		drv_data->len = (transfer->len) >> 1;
 	} else {
 		drv_data->len = transfer->len;
 	}
-	drv_data->write = drv_data->tx ? chip->write : null_writer;
-	drv_data->read = drv_data->rx ? chip->read : null_reader;
-	drv_data->duplex = chip->duplex ? chip->duplex : null_writer;
 	dev_dbg(&drv_data->pdev->dev, "transfer: ",
 		"drv_data->write is %p, chip->write is %p, null_wr is %p\n",
 		drv_data->write, chip->write, null_writer);
@@ -753,6 +785,12 @@ static void pump_transfers(unsigned long
 	message->state = RUNNING_STATE;
 	dma_config = 0;
 
+	/* Speed setup (surely valid because already checked) */
+	if (transfer->speed_hz)
+		write_BAUD(drv_data, hz_to_spi_baud(transfer->speed_hz));
+	else
+		write_BAUD(drv_data, chip->baud);
+
 	write_STAT(drv_data, BIT_STAT_CLR);
 	cr = (read_CTRL(drv_data) & (~BIT_CTL_TIMOD));
 	cs_active(drv_data, chip);
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
