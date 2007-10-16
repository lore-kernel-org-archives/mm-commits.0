From: akpm@linux-foundation.org
Subject: - spi_mpc83xx-handles-other-processors-with.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:48 -0700
Message-ID: <200710162039.l9GKdm7p015592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760449AbXJPVWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx handles other processors with  QUICC engine
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-handles-other-processors-with.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx handles other processors with  QUICC engine
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Currently, all QE SPI controllers are almost the same comparing to
MPC83xx's, thus let's use that driver for them.

Tested to work on MPC85xx in loopback mode.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/spi/Kconfig~spi_mpc83xx-handles-other-processors-with drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi_mpc83xx-handles-other-processors-with
+++ a/drivers/spi/Kconfig
@@ -124,16 +124,17 @@ config SPI_MPC52xx_PSC
 	  Controller in master SPI mode.
 
 config SPI_MPC83xx
-	tristate "Freescale MPC83xx SPI controller"
-	depends on SPI_MASTER && PPC_83xx && EXPERIMENTAL
+	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
+	depends on SPI_MASTER && (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
 	select SPI_BITBANG
 	help
-	  This enables using the Freescale MPC83xx SPI controller in master
-	  mode.
+	  This enables using the Freescale MPC83xx and QUICC Engine SPI
+	  controllers in master mode.
 
 	  Note, this driver uniquely supports the SPI controller on the MPC83xx
-	  family of PowerPC processors.  The MPC83xx uses a simple set of shift
-	  registers for data (opposed to the CPM based descriptor model).
+	  family of PowerPC processors, plus processors with QUICC Engine
+	  technology. This driver uses a simple set of shift registers for data
+	  (opposed to the CPM based descriptor model).
 
 config SPI_OMAP_UWIRE
 	tristate "OMAP1 MicroWire"
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
