From: akpm@linux-foundation.org
Subject: - spi_bfin-use-more-useful-gpio-labels.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:01 -0800
Message-ID: <200802070025.m170PgRh006741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933915AbYBGAol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_bfin: use more useful GPIO labels
has been removed from the -mm tree.  Its filename was
     spi_bfin-use-more-useful-gpio-labels.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bfin: use more useful GPIO labels
From: Bryan Wu <bryan.wu@analog.com>

Use the SPI driver's name when requesting gpio lines.  When there are gpio
conflicts, this helps to narrow down the problems; "bfin-spi" is not
informative.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin-use-more-useful-gpio-labels drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin-use-more-useful-gpio-labels
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1176,7 +1176,7 @@ static int setup(struct spi_device *spi)
 	if ((chip->chip_select_num > 0)
 		&& (chip->chip_select_num <= spi->master->num_chipselect))
 		peripheral_request(ssel[spi->master->bus_num]
-			[chip->chip_select_num-1], DRV_NAME);
+			[chip->chip_select_num-1], spi->modalias);
 
 	cs_deactive(drv_data, chip);
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
git-watchdog.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
procfs-constify-function-pointer-tables.patch
