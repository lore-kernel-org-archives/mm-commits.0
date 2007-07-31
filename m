From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-get-rid-of-magic-numbers.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:56 -0700
Message-ID: <200707312356.l6VNuuRP029349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbXHAARB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: get rid of magic numbers
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-get-rid-of-magic-numbers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx: get rid of magic numbers
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Magic-numbers-R-Evil

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-get-rid-of-magic-numbers drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-get-rid-of-magic-numbers
+++ a/drivers/spi/spi_mpc83xx.c
@@ -153,7 +153,8 @@ static void mpc83xx_spi_chipselect(struc
 			len = len - 1;
 
 		/* mask out bits we are going to set */
-		regval &= ~0x38ff0000;
+		regval &= ~(SPMODE_CP_BEGIN_EDGECLK | SPMODE_CI_INACTIVEHIGH |
+			    SPMODE_LEN(0xF) | SPMODE_DIV16 | SPMODE_PM(0xF));
 
 		if (spi->mode & SPI_CPHA)
 			regval |= SPMODE_CP_BEGIN_EDGECLK;
@@ -248,7 +249,7 @@ int mpc83xx_spi_setup_transfer(struct sp
 	regval = mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
 
 	/* Mask out bits_per_wordgth */
-	regval &= 0xff0fffff;
+	regval &= ~SPMODE_LEN(0xF);
 	regval |= SPMODE_LEN(bits_per_word);
 
 	/* Turn off SPI unit prior changing mode */
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
