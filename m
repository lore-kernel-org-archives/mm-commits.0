From: akpm@linux-foundation.org
Subject: [merged] atmel-mci-unified-atmel-mci-drivers-avr32-at91.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:02 -0700
Message-ID: <200909231956.n8NJu2k2004035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbZIWUDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@emanuele.us, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org, linux@maxim.org.za, nicolas.ferre@atmel.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     atmel-mci: unified Atmel MCI drivers (AVR32 & AT91)
has been removed from the -mm tree.  Its filename was
     atmel-mci-unified-atmel-mci-drivers-avr32-at91.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel-mci: unified Atmel MCI drivers (AVR32 & AT91)
From: Rob Emanuele <rob@emanuele.us>

Unification of the atmel-mci driver to support the AT91 processors MCI
interface.  The atmel-mci driver currently supports the AVR32 and this
patch adds AT91 support.

Add read/write proof selection switch dependent on chip availability of
this feature.

To use this new driver on a at91 the platform driver for your board needs
to be updated.

[nicolas.ferre@atmel.com indent, Kconfig comment and one printk modification]
Signed-off-by: Rob Emanuele <rob@emanuele.us>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig     |   16 ++++++++++++----
 drivers/mmc/host/atmel-mci.c |   33 ++++++++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/host/Kconfig~atmel-mci-unified-atmel-mci-drivers-avr32-at91 drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~atmel-mci-unified-atmel-mci-drivers-avr32-at91
+++ a/drivers/mmc/host/Kconfig
@@ -160,6 +160,12 @@ config MMC_AU1X
 
 	  If unsure, say N.
 
+choice
+	prompt "Atmel SD/MMC Driver"
+	default MMC_ATMELMCI if AVR32
+	help
+	  Choose which driver to use for the Atmel MCI Silicon
+
 config MMC_AT91
 	tristate "AT91 SD/MMC Card Interface support"
 	depends on ARCH_AT91
@@ -170,17 +176,19 @@ config MMC_AT91
 
 config MMC_ATMELMCI
 	tristate "Atmel Multimedia Card Interface support"
-	depends on AVR32
+	depends on AVR32 || ARCH_AT91
 	help
 	  This selects the Atmel Multimedia Card Interface driver. If
-	  you have an AT32 (AVR32) platform with a Multimedia Card
-	  slot, say Y or M here.
+	  you have an AT32 (AVR32) or AT91 platform with a Multimedia
+	  Card slot, say Y or M here.
 
 	  If unsure, say N.
 
+endchoice
+
 config MMC_ATMELMCI_DMA
 	bool "Atmel MCI DMA support (EXPERIMENTAL)"
-	depends on MMC_ATMELMCI && DMA_ENGINE && EXPERIMENTAL
+	depends on MMC_ATMELMCI && AVR32 && DMA_ENGINE && EXPERIMENTAL
 	help
 	  Say Y here to have the Atmel MCI driver use a DMA engine to
 	  do data transfers and thus increase the throughput and
diff -puN drivers/mmc/host/atmel-mci.c~atmel-mci-unified-atmel-mci-drivers-avr32-at91 drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~atmel-mci-unified-atmel-mci-drivers-avr32-at91
+++ a/drivers/mmc/host/atmel-mci.c
@@ -30,6 +30,7 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
+#include <mach/cpu.h>
 #include <mach/board.h>
 
 #include "atmel-mci-regs.h"
@@ -210,6 +211,18 @@ struct atmel_mci_slot {
 	set_bit(event, &host->pending_events)
 
 /*
+ * Enable or disable features/registers based on
+ * whether the processor supports them
+ */
+static bool mci_has_rwproof(void)
+{
+	if (cpu_is_at91sam9261() || cpu_is_at91rm9200())
+		return false;
+	else
+		return true;
+}
+
+/*
  * The debugfs stuff below is mostly optimized away when
  * CONFIG_DEBUG_FS is not set.
  */
@@ -276,8 +289,13 @@ static void atmci_show_status_reg(struct
 		[3]	= "BLKE",
 		[4]	= "DTIP",
 		[5]	= "NOTBUSY",
+		[6]	= "ENDRX",
+		[7]	= "ENDTX",
 		[8]	= "SDIOIRQA",
 		[9]	= "SDIOIRQB",
+		[12]	= "SDIOWAIT",
+		[14]	= "RXBUFF",
+		[15]	= "TXBUFE",
 		[16]	= "RINDE",
 		[17]	= "RDIRE",
 		[18]	= "RCRCE",
@@ -285,6 +303,11 @@ static void atmci_show_status_reg(struct
 		[20]	= "RTOE",
 		[21]	= "DCRCE",
 		[22]	= "DTOE",
+		[23]	= "CSTOE",
+		[24]	= "BLKOVRE",
+		[25]	= "DMADONE",
+		[26]	= "FIFOEMPTY",
+		[27]	= "XFRDONE",
 		[30]	= "OVRE",
 		[31]	= "UNRE",
 	};
@@ -849,13 +872,15 @@ static void atmci_set_ios(struct mmc_hos
 			clkdiv = 255;
 		}
 
+		host->mode_reg = MCI_MR_CLKDIV(clkdiv);
+
 		/*
 		 * WRPROOF and RDPROOF prevent overruns/underruns by
 		 * stopping the clock when the FIFO is full/empty.
 		 * This state is not expected to last for long.
 		 */
-		host->mode_reg = MCI_MR_CLKDIV(clkdiv) | MCI_MR_WRPROOF
-					| MCI_MR_RDPROOF;
+		if (mci_has_rwproof())
+			host->mode_reg |= (MCI_MR_WRPROOF | MCI_MR_RDPROOF);
 
 		if (list_empty(&host->queue))
 			mci_writel(host, MR, host->mode_reg);
@@ -1648,8 +1673,10 @@ static int __init atmci_probe(struct pla
 			nr_slots++;
 	}
 
-	if (!nr_slots)
+	if (!nr_slots) {
+		dev_err(&pdev->dev, "init failed: no slot defined\n");
 		goto err_init_slot;
+	}
 
 	dev_info(&pdev->dev,
 			"Atmel MCI controller at 0x%08lx irq %d, %u slots\n",
_

Patches currently in -mm which might be from rob@emanuele.us are

origin.patch

