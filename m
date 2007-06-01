From: akpm@linux-foundation.org
Subject: + spi-controller-drivers-check-for-unsupported-modes-update.patch added to -mm tree
Date: Fri, 01 Jun 2007 16:38:25 -0700
Message-ID: <200706012338.l51NcPWv022022@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850AbXFAXjD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 19:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spi controller mode check update
has been added to the -mm tree.  Its filename is
     spi-controller-drivers-check-for-unsupported-modes-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi controller mode check update
From: David Brownell <david-b@pacbell.net>

This lets bitbanging SPI controller drivers declare that they
support modes like SPI_CS_HIGH and SPI_3WIRE.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bitbang.c       |   12 +++---------
 include/linux/spi/spi_bitbang.h |    1 +
 2 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/spi/spi_bitbang.c~spi-controller-drivers-check-for-unsupported-modes-update drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-controller-drivers-check-for-unsupported-modes-update
+++ a/drivers/spi/spi_bitbang.c
@@ -187,16 +187,10 @@ int spi_bitbang_setup(struct spi_device 
 
 	bitbang = spi_master_get_devdata(spi->master);
 
-	/* REVISIT: some systems will want to support devices using lsb-first
-	 * bit encodings on the wire.  In pure software that would be trivial,
-	 * just bitbang_txrx_le_cphaX() routines shifting the other way, and
-	 * some hardware controllers also have this support.
-	 *
-	 * REVISIT: we should accept SPI_CS_HIGH in some cases; it's
-	 * easy to implement that with GPIOs, but we don't know if the
-	 * underlying chipselect() method support that...
+	/* Bitbangers can support SPI_CS_HIGH, SPI_3WIRE, and so on;
+	 * add those to master->flags, and provide the other support.
 	 */
-	if ((spi->mode & ~(SPI_CPOL|SPI_CPHA)) != 0)
+	if ((spi->mode & ~(SPI_CPOL|SPI_CPHA|bitbang->flags)) != 0)
 		return -EINVAL;
 
 	if (!cs) {
diff -puN include/linux/spi/spi_bitbang.h~spi-controller-drivers-check-for-unsupported-modes-update include/linux/spi/spi_bitbang.h
--- a/include/linux/spi/spi_bitbang.h~spi-controller-drivers-check-for-unsupported-modes-update
+++ a/include/linux/spi/spi_bitbang.h
@@ -26,6 +26,7 @@ struct spi_bitbang {
 	struct list_head	queue;
 	u8			busy;
 	u8			use_dma;
+	u8			flags;		/* extra spi->mode support */
 
 	struct spi_master	*master;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
spi-dynamic-busid-generation-bugfix.patch
git-avr32.patch
git-leds.patch
git-mmc.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-controller-drivers-check-for-unsupported-modes-update.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
