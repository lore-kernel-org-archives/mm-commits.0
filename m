From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-handle-other-freescale-processors.patch added to -mm tree
Date: Mon, 04 May 2009 13:56:09 -0700
Message-ID: <200905042056.n44Ku9gT016681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045AbZEDU7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org


The patch titled
     spi_mpc83xx: handle other Freescale processors
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-handle-other-freescale-processors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mpc52xx_psc_spi-convert-to-cs_control-callback.patch
spi_mpc83xx-handle-other-freescale-processors.patch
spi_mpc83xx-quieten-down-the-requested-speed-is-too-low-message.patch
spi_mpc83xx-add-small-delay-after-asserting-chip-select-line.patch
powerpc-86xx-add-mmc-spi-support-for-mpc8610hpcd-boards.patch
spi_mpc83xx-fix-checkpatch-issues.patch
spi_mpc83xx-split-mpc83xx_spi_work-into-two-routines.patch
spi_mpc83xx-remove-dead-code.patch
spi_mpc83xx-rename-spi_83xxc-to-spi_8xxxc.patch
spi_mpc8xxx-s-83xx-8xxx-g.patch

