From: akpm@linux-foundation.org
Subject: - atmel_spi-fix-clock-polarity.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:44 -0800
Message-ID: <200802250044.m1P0iiCX006132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227AbYBYAo6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, david-b@pacbell.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_spi: fix clock polarity
has been removed from the -mm tree.  Its filename was
     atmel_spi-fix-clock-polarity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_spi: fix clock polarity
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The atmel_spi driver does not initialize clock polarity correctly (except for
at91rm9200 CS0 channel) in some case.

The atmel_spi driver uses gpio-controlled chipselect.  OTOH spi clock signal
is controlled by CSRn.CPOL bit, but this register controls clock signal
correctly only in 'real transfer' duration.  At the time of cs_activate()
call, CSRn.CPOL will be initialized correctly, but the controller do not know
which channel is to be used next, so clock signal will stay at the inactive
state of last transfer.  If clock polarity of new transfer and last transfer
was differ, new transfer will start with wrong clock signal state.

For example, if you started SPI MODE 2 or 3 transfer after SPI MODE 0 or 1
transfer, the clock signal state at the assertion of chipselect will be low. 
Of course this will violates SPI transfer.

This patch is short term solution for this problem.  It makes all CSRn.CPOL
match for the transfer before activating chipselect.  For longer term, the
best fix might be to let NPCS0 stay selected permanently in MR and overwrite
CSR0 with to the new slave's settings before asserting CS.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-fix-clock-polarity drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-fix-clock-polarity
+++ a/drivers/spi/atmel_spi.c
@@ -87,6 +87,16 @@ static void cs_activate(struct atmel_spi
 	unsigned gpio = (unsigned) spi->controller_data;
 	unsigned active = spi->mode & SPI_CS_HIGH;
 	u32 mr;
+	int i;
+	u32 csr;
+	u32 cpol = (spi->mode & SPI_CPOL) ? SPI_BIT(CPOL) : 0;
+
+	/* Make sure clock polarity is correct */
+	for (i = 0; i < spi->master->num_chipselect; i++) {
+		csr = spi_readl(as, CSR0 + 4 * i);
+		if ((csr ^ cpol) & SPI_BIT(CPOL))
+			spi_writel(as, CSR0 + 4 * i, csr ^ SPI_BIT(CPOL));
+	}
 
 	mr = spi_readl(as, MR);
 	mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

macb-fix-speed-setting.patch
