From: akpm@linux-foundation.org
Subject: + spi-spi_mpc83xx-clockrate-fixes.patch added to -mm tree
Date: Sun, 29 Jun 2008 00:15:36 -0700
Message-ID: <200806290715.m5T7FaKl009700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756519AbYF2HQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jun 2008 03:16:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.chen@freescale.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_mpc83xx clockrate fixes
has been added to the -mm tree.  Its filename is
     spi-spi_mpc83xx-clockrate-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_mpc83xx clockrate fixes
From: Chen Gong <g.chen@freescale.com>

This updates the SPI clock rate calculations for the spi_mpc83xx driver. 
Some boundary conditions were wrong, and in several cases divide-by-16
wasn't always needed

Signed-off-by: Chen Gong <g.chen@freescale.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN drivers/spi/spi_mpc83xx.c~spi-spi_mpc83xx-clockrate-fixes drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-spi_mpc83xx-clockrate-fixes
+++ a/drivers/spi/spi_mpc83xx.c
@@ -266,21 +266,24 @@ int mpc83xx_spi_setup_transfer(struct sp
 
 	cs->hw_mode |= SPMODE_LEN(bits_per_word);
 
-	if ((mpc83xx_spi->spibrg / hz) >= 64) {
-		pm = mpc83xx_spi->spibrg / (hz * 64) - 1;
-		if (pm > 0x0f) {
-			dev_err(&spi->dev, "Requested speed is too "
-				"low: %d Hz. Will use %d Hz instead.\n",
-				hz, mpc83xx_spi->spibrg / 1024);
-			pm = 0x0f;
+	if ((mpc83xx_spi->spibrg / hz) > 64) {
+		pm = mpc83xx_spi->spibrg / (hz * 64);
+		if (pm > 16) {
+			cs->hw_mode |= SPMODE_DIV16;
+			pm /= 16;
+			if (pm > 16) {
+				dev_err(&spi->dev, "Requested speed is too "
+					"low: %d Hz. Will use %d Hz instead.\n",
+					hz, mpc83xx_spi->spibrg / 1024);
+				pm = 16;
+			}
 		}
-		cs->hw_mode |= SPMODE_PM(pm) | SPMODE_DIV16;
-	} else {
+	} else
 		pm = mpc83xx_spi->spibrg / (hz * 4);
-		if (pm)
-			pm--;
-		cs->hw_mode |= SPMODE_PM(pm);
-	}
+	if (pm)
+		pm--;
+
+	cs->hw_mode |= SPMODE_PM(pm);
 	regval =  mpc83xx_spi_read_reg(&mpc83xx_spi->base->mode);
 	if (cs->hw_mode != regval) {
 		unsigned long flags;
_

Patches currently in -mm which might be from g.chen@freescale.com are

spi-spi_mpc83xx-clockrate-fixes.patch

