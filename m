From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-fix-clockrate-calculation-for-low-speed.patch added to -mm tree
Date: Mon, 08 Sep 2008 17:40:53 -0700
Message-ID: <200809090040.m890er6x018323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbYIIAlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 20:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacmet@sunsite.dk, dbrownell@users.sourceforge.net


The patch titled
     spi_mpc83xx: fix clockrate calculation for low speed
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-fix-clockrate-calculation-for-low-speed.patch

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

spi_mpc83xx-fix-clockrate-calculation-for-low-speed.patch
smc911x-remove-duplicate-debug-printout.patch

