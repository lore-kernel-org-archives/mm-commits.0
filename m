From: akpm@linux-foundation.org
Subject: - omap_uwire-spi_cpha-mode-bugfix.patch removed from -mm tree
Date: Tue, 29 May 2007 11:53:20 -0700
Message-ID: <200705291853.l4TIrJhm008458@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765108AbXE2Sxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@solidboot.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     omap_uwire: SPI_CPHA mode bugfix
has been removed from the -mm tree.  Its filename was
     omap_uwire-spi_cpha-mode-bugfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: omap_uwire: SPI_CPHA mode bugfix
From: Imre Deak <imre.deak@solidboot.com>

The omap_uwire controller driver handles SPI_CPHA incorrectly;
It should mean:

  CPHA=0 ... sample at leading edge of clock
  CPHA=1 ... sample at trailing edge of clock

This bug has been masked by inverse bugs in layered drivers;
and was uncovered by running some of them on non-OMAP hardware.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap_uwire.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/omap_uwire.c~omap_uwire-spi_cpha-mode-bugfix drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~omap_uwire-spi_cpha-mode-bugfix
+++ a/drivers/spi/omap_uwire.c
@@ -358,11 +358,11 @@ static int uwire_setup_transfer(struct s
 	switch (spi->mode & (SPI_CPOL | SPI_CPHA)) {
 	case SPI_MODE_0:
 	case SPI_MODE_3:
-		flags |= UWIRE_WRITE_RISING_EDGE | UWIRE_READ_FALLING_EDGE;
+		flags |= UWIRE_WRITE_FALLING_EDGE | UWIRE_READ_RISING_EDGE;
 		break;
 	case SPI_MODE_1:
 	case SPI_MODE_2:
-		flags |= UWIRE_WRITE_FALLING_EDGE | UWIRE_READ_RISING_EDGE;
+		flags |= UWIRE_WRITE_RISING_EDGE | UWIRE_READ_FALLING_EDGE;
 		break;
 	}
 
_

Patches currently in -mm which might be from imre.deak@solidboot.com are
