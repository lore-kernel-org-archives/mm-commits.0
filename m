From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:30:50 -0700
Message-ID: <200707310130.l6V1Uoqf008508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34916 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbXGaBbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:31:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org


The patch titled
     spi_mpc83xx: turn off SPI unit while switching mode
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spi_mpc83xx-turn-off-spi-unit-while-switching-mode.patch
spi_mpc83xx-get-rid-of-magic-numbers.patch
spi_mpc83xx-support-for-lsb-first-transfers.patch
spi_mpc83xx-fix-qelsb-mode-shifts.patch
