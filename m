From: akpm@osdl.org
Subject: - spi-fix-error-setting-the-spi-mode-in-pxa2xx_spic.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:12 -0800
Message-ID: <200701270131.l0R1VCTt031819@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35377 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXA0BbT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: justin@redfish-group.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix error setting the spi mode in pxa2xx_spi.c
has been removed from the -mm tree.  Its filename was
     spi-fix-error-setting-the-spi-mode-in-pxa2xx_spic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: fix error setting the spi mode in pxa2xx_spi.c
From: Justin Clacherty <justin@redfish-group.com>

Currently the spi mode can be set to the wrong mode if you are switching
from any mode other than mode 0.  This is because the mode is set using a
bitwise or on uncleared bits.  The following patch clears the mode bits
before setting the new mode.  I've also modified it to use the appropriate
defines from pxa-regs.h for readability.

Signed-off-by: Justin Clacherty <justin@redfish-group.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/pxa2xx_spi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-fix-error-setting-the-spi-mode-in-pxa2xx_spic drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-fix-error-setting-the-spi-mode-in-pxa2xx_spic
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1169,8 +1169,9 @@ static int setup(struct spi_device *spi)
 				spi->bits_per_word - 16 : spi->bits_per_word)
 			| SSCR0_SSE
 			| (spi->bits_per_word > 16 ? SSCR0_EDSS : 0);
-	chip->cr1 |= (((spi->mode & SPI_CPHA) != 0) << 4)
-			| (((spi->mode & SPI_CPOL) != 0) << 3);
+	chip->cr1 &= ~(SSCR1_SPO | SSCR1_SPH);
+	chip->cr1 |= (((spi->mode & SPI_CPHA) != 0) ? SSCR1_SPH : 0)
+			| (((spi->mode & SPI_CPOL) != 0) ? SSCR1_SPO : 0);
 
 	/* NOTE:  PXA25x_SSP _could_ use external clocking ... */
 	if (drv_data->ssp_type != PXA25x_SSP)
_

Patches currently in -mm which might be from justin@redfish-group.com are

origin.patch
