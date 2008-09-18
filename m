From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-fix-clockrate-calculation-for-low-speed.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:55:52 -0700
Message-ID: <200809182055.m8IKtqsj019142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452AbYIRU4P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacmet@sunsite.dk, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: fix clockrate calculation for low speed
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-fix-clockrate-calculation-for-low-speed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: fix clockrate calculation for low speed
From: Peter Korsgaard <jacmet@sunsite.dk>

Commit a61f5345 (spi_mpc83xx clockrate fixes) broke clockrate calculation
for low speeds.  SPMODE_DIV16 should be set if the divider is higher than
64, not only if the divider gets clipped to 1024.

Furthermore, the clipping check was off by a factor 16 as well.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-clockrate-calculation-for-low-speed drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-fix-clockrate-calculation-for-low-speed
+++ a/drivers/spi/spi_mpc83xx.c
@@ -267,16 +267,13 @@ int mpc83xx_spi_setup_transfer(struct sp
 	cs->hw_mode |= SPMODE_LEN(bits_per_word);
 
 	if ((mpc83xx_spi->spibrg / hz) > 64) {
+		cs->hw_mode |= SPMODE_DIV16;
 		pm = mpc83xx_spi->spibrg / (hz * 64);
 		if (pm > 16) {
-			cs->hw_mode |= SPMODE_DIV16;
-			pm /= 16;
-			if (pm > 16) {
-				dev_err(&spi->dev, "Requested speed is too "
-					"low: %d Hz. Will use %d Hz instead.\n",
-					hz, mpc83xx_spi->spibrg / 1024);
-				pm = 16;
-			}
+			dev_err(&spi->dev, "Requested speed is too "
+				"low: %d Hz. Will use %d Hz instead.\n",
+				hz, mpc83xx_spi->spibrg / 1024);
+			pm = 16;
 		}
 	} else
 		pm = mpc83xx_spi->spibrg / (hz * 4);
_

Patches currently in -mm which might be from jacmet@sunsite.dk are

origin.patch
linux-next.patch
smc911x-remove-duplicate-debug-printout.patch

