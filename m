From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:54 -0700
Message-ID: <200707312356.l6VNusvL029346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758839AbXHAAQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: turn off SPI unit while switching mode
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx: turn off SPI unit while switching mode
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Documentation clearly states, that mode should not be changed till
SPMODE_ENABLE bit set.  I've seen hangs w/o this patch.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-turn-off-spi-unit-while-switching-mode drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-turn-off-spi-unit-while-switching-mode
+++ a/drivers/spi/spi_mpc83xx.c
@@ -176,6 +176,8 @@ static void mpc83xx_spi_chipselect(struc
 			regval |= SPMODE_PM(pm);
 		}
 
+		/* Turn off SPI unit prior changing mode */
+		mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, 0);
 		mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, regval);
 		if (mpc83xx_spi->activate_cs)
 			mpc83xx_spi->activate_cs(spi->chip_select, pol);
@@ -249,6 +251,8 @@ int mpc83xx_spi_setup_transfer(struct sp
 	regval &= 0xff0fffff;
 	regval |= SPMODE_LEN(bits_per_word);
 
+	/* Turn off SPI unit prior changing mode */
+	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, 0);
 	mpc83xx_spi_write_reg(&mpc83xx_spi->base->mode, regval);
 
 	return 0;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
