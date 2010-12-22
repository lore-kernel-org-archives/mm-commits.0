From: akpm@linux-foundation.org
Subject: + pata_mpc52xx-driver-needs-bmdma.patch added to -mm tree
Date: Wed, 22 Dec 2010 14:08:29 -0800
Message-ID: <201012222208.oBMM8TML022205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab0LVWJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Dec 2010 17:09:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, jeff@garzik.org


The patch titled
     pata_mpc52xx: driver needs BMDMA
has been added to the -mm tree.  Its filename is
     pata_mpc52xx-driver-needs-bmdma.patch

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
Subject: pata_mpc52xx: driver needs BMDMA
From: Wolfram Sang <w.sang@pengutronix.de>

Found by this build-error if BMDMA is disabled:

drivers/ata/pata_mpc52xx.c: In function 'mpc52xx_ata_init_one':
drivers/ata/pata_mpc52xx.c:662: error: 'ata_bmdma_interrupt' undeclared (first use in this function)
...

Move the Kconfig entry to the proper location as needed since
9a7780c9acb821fe1c2b6fc53f74cc2556ff5364 ("libata-sff: make BMDMA
optional").

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/Kconfig  |   20 ++++++++++----------
 drivers/ata/Makefile |    2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/ata/Kconfig~pata_mpc52xx-driver-needs-bmdma drivers/ata/Kconfig
--- a/drivers/ata/Kconfig~pata_mpc52xx-driver-needs-bmdma
+++ a/drivers/ata/Kconfig
@@ -136,16 +136,6 @@ config PDC_ADMA
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx && PPC_BESTCOMM
-	select PPC_BESTCOMM_ATA
-	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
-
-	  If unsure, say N.
-
 config PATA_OCTEON_CF
 	tristate "OCTEON Boot Bus Compact Flash support"
 	depends on CPU_CAVIUM_OCTEON
@@ -499,6 +489,16 @@ config PATA_MARVELL
 
 	  If unsure, say N.
 
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on PPC_MPC52xx && PPC_BESTCOMM
+	select PPC_BESTCOMM_ATA
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
 	depends on PCI
diff -puN drivers/ata/Makefile~pata_mpc52xx-driver-needs-bmdma drivers/ata/Makefile
--- a/drivers/ata/Makefile~pata_mpc52xx-driver-needs-bmdma
+++ a/drivers/ata/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460e
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
-obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
 obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_octeon_cf.o
 obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
 obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
@@ -53,6 +52,7 @@ obj-$(CONFIG_PATA_IT821X)	+= pata_it821x
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
 obj-$(CONFIG_PATA_MACIO)	+= pata_macio.o
 obj-$(CONFIG_PATA_MARVELL)	+= pata_marvell.o
+obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
 obj-$(CONFIG_PATA_NINJA32)	+= pata_ninja32.o
 obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

rtc-rs5c372-fix-buffer-size.patch
linux-next.patch
pata_mpc52xx-driver-needs-bmdma.patch

