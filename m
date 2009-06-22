From: akpm@linux-foundation.org
Subject: [merged] spi_mpc83xx-handle-other-freescale-processors.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:04 -0700
Message-ID: <200906221700.n5MH04gY009239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbZFVRKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: handle other Freescale processors
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-handle-other-freescale-processors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: handle other Freescale processors
From: Anton Vorontsov <avorontsov@ru.mvista.com>

With this patch we'll able to select spi_mpc83xx driver on the MPC86xx
platforms.  Let the driver depend on FSL_SOC, so we don't have to worry
about Kconfig anymore.

Also remove the "experimental" dependency, the driver has been tested to
work on a various hardware, and surely not experimental anymore.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/spi/Kconfig~spi_mpc83xx-handle-other-freescale-processors drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi_mpc83xx-handle-other-freescale-processors
+++ a/drivers/spi/Kconfig
@@ -140,16 +140,14 @@ config SPI_MPC52xx_PSC
 	  Controller in master SPI mode.
 
 config SPI_MPC83xx
-	tristate "Freescale MPC83xx/QUICC Engine SPI controller"
-	depends on (PPC_83xx || QUICC_ENGINE) && EXPERIMENTAL
+	tristate "Freescale MPC8xxx SPI controller"
+	depends on FSL_SOC
 	help
-	  This enables using the Freescale MPC83xx and QUICC Engine SPI
-	  controllers in master mode.
+	  This enables using the Freescale MPC8xxx SPI controllers in master
+	  mode.
 
-	  Note, this driver uniquely supports the SPI controller on the MPC83xx
-	  family of PowerPC processors, plus processors with QUICC Engine
-	  technology. This driver uses a simple set of shift registers for data
-	  (opposed to the CPM based descriptor model).
+	  This driver uses a simple set of shift registers for data (opposed
+	  to the CPM based descriptor model).
 
 config SPI_OMAP_UWIRE
 	tristate "OMAP1 MicroWire"
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
usb-mutually-exclusive-port_status.patch

