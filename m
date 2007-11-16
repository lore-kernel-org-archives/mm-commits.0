From: akpm@linux-foundation.org
Subject: + atmel_spi-throughput-improvement.patch added to -mm tree
Date: Thu, 15 Nov 2007 19:06:25 -0800
Message-ID: <200711160306.lAG36Pbp029352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbXKPDGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 22:06:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, dbrownell@users.sourceforge.net


The patch titled
     atmel_spi throughput improvement
has been added to the -mm tree.  Its filename is
     atmel_spi-throughput-improvement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atmel_spi throughput improvement
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Don't insert (undesirable) delays between consecutive words (DLYBCT) or when
activating chipselects (DLYBS).

Removing the between-word delays improves the performance of bulk transfers
(such as mtd_dataflash, m25p80, mmc_spi) significantly.  In one test, the
improvement was a factor of more than eight!

(The large DLYBCT value came from the legacy at91 SPI driver, and it's not
clear why it used such a huge value.)

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-throughput-improvement drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-throughput-improvement
+++ a/drivers/spi/atmel_spi.c
@@ -490,9 +490,14 @@ static int atmel_spi_setup(struct spi_de
 	if (!(spi->mode & SPI_CPHA))
 		csr |= SPI_BIT(NCPHA);
 
-	/* TODO: DLYBS and DLYBCT */
-	csr |= SPI_BF(DLYBS, 10);
-	csr |= SPI_BF(DLYBCT, 10);
+	/* DLYBS is mostly irrelevant since we manage chipselect using GPIOs.
+	 *
+	 * DLYBCT would add delays between words, slowing down transfers.
+	 * It could potentially be useful to cope with DMA bottlenecks, but
+	 * in those cases it's probably best to just use a lower bitrate.
+	 */
+	csr |= SPI_BF(DLYBS, 0);
+	csr |= SPI_BF(DLYBCT, 0);
 
 	/* chipselect must have been muxed as GPIO (e.g. in board setup) */
 	npcs_pin = (unsigned int)spi->controller_data;
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
atmel_spi-labels-gpios-better.patch
atmel_spi-throughput-improvement.patch
git-avr32.patch
git-mtd.patch
read_current_time-cleanups.patch
generic-gpio-gpio_chip-support.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
atmel_spi-chains-dma-transfers.patch
