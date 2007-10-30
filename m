From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-update-handling-of-delay-after-deselect.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:50:55 -0700
Message-ID: <200710302250.l9UMot0k032061@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43207 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbXJ3WvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, cbarfield@cyberdata.net, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin: update handling of delay-after-deselect
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-update-handling-of-delay-after-deselect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin: update handling of delay-after-deselect
From: Bryan Wu <bryan.wu@analog.com>

Move cs_chg_udelay handling (specific to this driver) to cs_deactive(), fixing
a bug when some SPI LCD driver needs delay after cs_deactive.

Fix bug reported by Cameron Barfield <cbarfield@cyberdata.net>
https://blackfin.uclinux.org/gf/project/uclinux-dist/forum/?action=ForumBrowse&forum_id=39&_forum_action=ForumMessageBrowse&thread_id=23630&feedback=Message%20replied.

Cc: Cameron Barfield <cbarfield@cyberdata.net>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c          |   24 +++++++++---------------
 include/asm-blackfin/bfin5xx_spi.h |    2 +-
 2 files changed, 10 insertions(+), 16 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-update-handling-of-delay-after-deselect drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-update-handling-of-delay-after-deselect
+++ a/drivers/spi/spi_bfin5xx.c
@@ -132,7 +132,7 @@ struct chip_data {
 	u8 enable_dma;
 	u8 bits_per_word;	/* 8 or 16 */
 	u8 cs_change_per_word;
-	u8 cs_chg_udelay;
+	u16 cs_chg_udelay;	/* Some devices require > 255usec delay */
 	void (*write) (struct driver_data *);
 	void (*read) (struct driver_data *);
 	void (*duplex) (struct driver_data *);
@@ -211,6 +211,10 @@ static void cs_deactive(struct driver_da
 	flag |= (chip->flag << 8);
 
 	write_FLAG(drv_data, flag);
+
+	/* Move delay here for consistency */
+	if (chip->cs_chg_udelay)
+		udelay(chip->cs_chg_udelay);
 }
 
 #define MAX_SPI_SSEL	7
@@ -307,10 +311,9 @@ static void u8_cs_chg_writer(struct driv
 		write_TDBR(drv_data, (*(u8 *) (drv_data->tx)));
 		while (read_STAT(drv_data) & BIT_STAT_TXS)
 			continue;
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		++drv_data->tx;
 	}
 }
@@ -359,9 +362,6 @@ static void u8_cs_chg_reader(struct driv
 	while (drv_data->rx < drv_data->rx_end - 1) {
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
-
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		cs_active(drv_data, chip);
@@ -412,10 +412,9 @@ static void u8_cs_chg_duplex(struct driv
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		*(u8 *) (drv_data->rx) = read_RDBR(drv_data);
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		++drv_data->rx;
 		++drv_data->tx;
 	}
@@ -452,10 +451,9 @@ static void u16_cs_chg_writer(struct dri
 		write_TDBR(drv_data, (*(u16 *) (drv_data->tx)));
 		while ((read_STAT(drv_data) & BIT_STAT_TXS))
 			continue;
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		drv_data->tx += 2;
 	}
 }
@@ -504,9 +502,6 @@ static void u16_cs_chg_reader(struct dri
 	while (drv_data->rx < drv_data->rx_end - 2) {
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
-
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		cs_active(drv_data, chip);
@@ -557,10 +552,9 @@ static void u16_cs_chg_duplex(struct dri
 		while (!(read_STAT(drv_data) & BIT_STAT_RXS))
 			continue;
 		*(u16 *) (drv_data->rx) = read_RDBR(drv_data);
+
 		cs_deactive(drv_data, chip);
 
-		if (chip->cs_chg_udelay)
-			udelay(chip->cs_chg_udelay);
 		drv_data->rx += 2;
 		drv_data->tx += 2;
 	}
diff -puN include/asm-blackfin/bfin5xx_spi.h~spi-spi_bfin-update-handling-of-delay-after-deselect include/asm-blackfin/bfin5xx_spi.h
--- a/include/asm-blackfin/bfin5xx_spi.h~spi-spi_bfin-update-handling-of-delay-after-deselect
+++ a/include/asm-blackfin/bfin5xx_spi.h
@@ -162,7 +162,7 @@ struct bfin5xx_spi_chip {
 	u8 enable_dma;
 	u8 bits_per_word;
 	u8 cs_change_per_word;
-	u8 cs_chg_udelay;
+	u16 cs_chg_udelay; /* Some devices require 16-bit delays */
 };
 
 #endif /* _SPI_CHANNEL_H_ */
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
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
