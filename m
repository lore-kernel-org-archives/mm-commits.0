From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-fix-qelsb-mode-shifts.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:57:01 -0700
Message-ID: <200707312357.l6VNv1F1029355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51561 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760813AbXHAARC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: fix QE+LSB mode shifts
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-fix-qelsb-mode-shifts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx: fix QE+LSB mode shifts
From: Anton Vorontsov <avorontsov@ru.mvista.com>

spi_mpc83xx should use other shifts when running in QE+LSB mode.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-qelsb-mode-shifts drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-qelsb-mode-shifts
+++ a/drivers/spi/spi_mpc83xx.c
@@ -237,6 +237,14 @@ int mpc83xx_spi_setup_transfer(struct sp
 	} else
 		return -EINVAL;
 
+	if (mpc83xx_spi->qe_mode && spi->mode & SPI_LSB_FIRST) {
+		mpc83xx_spi->tx_shift = 0;
+		if (bits_per_word <= 8)
+			mpc83xx_spi->rx_shift = 8;
+		else
+			mpc83xx_spi->rx_shift = 0;
+	}
+
 	/* nsecs = (clock period)/2 */
 	if (!hz)
 		hz = spi->max_speed_hz;
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
