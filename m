From: akpm@linux-foundation.org
Subject: - ads7846-spi_cpha-mode-bugfix.patch removed from -mm tree
Date: Wed, 23 May 2007 13:20:48 -0700
Message-ID: <200705232020.l4NKKl3D030985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbXEWUU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 16:20:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: semih.hazar@indefia.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     ads7846: SPI_CPHA mode bugfix
has been removed from the -mm tree.  Its filename was
     ads7846-spi_cpha-mode-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ads7846: SPI_CPHA mode bugfix
From: Semih Hazar <semih.hazar@indefia.com>

In commit [1] the SPI mode is set to 1, but it should be 0.  As stated in the
commit, ads784x samples the data on the rising edge.  SPI mode 1 samples on
the falling edge [2] though.

The root cause of this is a bug in the omap_uwire code, which treats
CPHA=1 incorrectly; so these two bugs cancel each other out on one
of the main regression test platforms for this driver.

[1] kernel.org GIT 7937e86a70235e1584486654687dc9908a11e00a
[2] http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ads7846.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/ads7846.c~ads7846-spi_cpha-mode-bugfix drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~ads7846-spi_cpha-mode-bugfix
+++ a/drivers/input/touchscreen/ads7846.c
@@ -847,7 +847,7 @@ static int __devinit ads7846_probe(struc
 	 * may not.  So we stick to very-portable 8 bit words, both RX and TX.
 	 */
 	spi->bits_per_word = 8;
-	spi->mode = SPI_MODE_1;
+	spi->mode = SPI_MODE_0;
 	err = spi_setup(spi);
 	if (err < 0)
 		return err;
_

Patches currently in -mm which might be from semih.hazar@indefia.com are

origin.patch
