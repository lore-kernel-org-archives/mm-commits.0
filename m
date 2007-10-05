From: akpm@linux-foundation.org
Subject: + spi_mpc83xx-handles-other-processors-with.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:21:50 -0700
Message-ID: <200710052321.l95NLorW030266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbXJEXWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, dbrownell@users.sourceforge.net, galak@kernel.crashing.org


The patch titled
     spi_mpc83xx handles other processors with  QUICC engine
has been added to the -mm tree.  Its filename is
     spi_mpc83xx-handles-other-processors-with.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi_mpc83xx handles other processors with  QUICC engine
From: Anton Vorontsov <avorontsov@ru.mvista.com>

Currently, all QE SPI controllers are almost the same comparing to
MPC83xx's, thus let's use that driver for them.

Tested to work on MPC85xx in loopback mode.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

git-powerpc.patch
spi_mpc83xx-handles-other-processors-with.patch
