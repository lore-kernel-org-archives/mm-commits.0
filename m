From: akpm@linux-foundation.org
Subject: [merged] spi-add-spi_master-flag-word.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:27:05 -0700
Message-ID: <200907011727.n61HR5IU001848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbZGAR1Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:27:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     spi: add spi_master flag word
has been removed from the -mm tree.  Its filename was
     spi-add-spi_master-flag-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: add spi_master flag word
From: David Brownell <dbrownell@users.sourceforge.net>

Add a new spi_master.flags word listing constraints relevant to that
controller.  Define the first constraint bit: a half duplex restriction. 
Include that constraint in the OMAP1 MicroWire controller driver.

Have the mmc_spi host be the first customer of this flag.  Its coding
relies heavily on full duplex transfers, so it must fail when the
underlying controller driver won't perform them.

(The spi_write_then_read routine could use it too: use the
temporarily-withdrawn full-duplex speedup unless this flag is set, in
which case the existing code applies.  Similarly, any spi_master
implementing only SPI_3WIRE should set the flag.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mmc_spi.c |    6 ++++++
 drivers/spi/omap_uwire.c   |    2 ++
 include/linux/spi/spi.h    |    4 ++++
 3 files changed, 12 insertions(+)

diff -puN drivers/mmc/host/mmc_spi.c~spi-add-spi_master-flag-word drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~spi-add-spi_master-flag-word
+++ a/drivers/mmc/host/mmc_spi.c
@@ -1313,6 +1313,12 @@ static int mmc_spi_probe(struct spi_devi
 	struct mmc_spi_host	*host;
 	int			status;
 
+	/* We rely on full duplex transfers, mostly to reduce
+	 * per-transfer overheads (by making fewer transfers).
+	 */
+	if (spi->master->flags & SPI_MASTER_HALF_DUPLEX)
+		return -EINVAL;
+
 	/* MMC and SD specs only seem to care that sampling is on the
 	 * rising edge ... meaning SPI modes 0 or 3.  So either SPI mode
 	 * should be legit.  We'll use mode 0 since the steady state is 0,
diff -puN drivers/spi/omap_uwire.c~spi-add-spi_master-flag-word drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-add-spi_master-flag-word
+++ a/drivers/spi/omap_uwire.c
@@ -514,6 +514,8 @@ static int __init uwire_probe(struct pla
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
+	master->flags = SPI_MASTER_HALF_DUPLEX;
+
 	master->bus_num = 2;	/* "official" */
 	master->num_chipselect = 4;
 	master->setup = uwire_setup;
diff -puN include/linux/spi/spi.h~spi-add-spi_master-flag-word include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-add-spi_master-flag-word
+++ a/include/linux/spi/spi.h
@@ -250,6 +250,10 @@ struct spi_master {
 	/* spi_device.mode flags understood by this controller driver */
 	u16			mode_bits;
 
+	/* other constraints relevant to this driver */
+	u16			flags;
+#define SPI_MASTER_HALF_DUPLEX	BIT(0)		/* can't do full duplex */
+
 	/* Setup mode and clock, etc (spi driver may call many times).
 	 *
 	 * IMPORTANT:  this may be called when transfers to another
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

