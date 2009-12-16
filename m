From: akpm@linux-foundation.org
Subject: + sdhci-of-add-support-for-the-wii-sdhci-controller.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:48:04 -0800
Message-ID: <200912162248.nBGMm4o4019647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762891AbZLPWsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:48:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albert_herranz@yahoo.es, linux-mmc@vger.kernel.org


The patch titled
     sdhci-of: add support for the wii sdhci controller
has been added to the -mm tree.  Its filename is
     sdhci-of-add-support-for-the-wii-sdhci-controller.patch

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
Subject: sdhci-of: add support for the wii sdhci controller
From: Albert Herranz <albert_herranz@yahoo.es>

Add support for the Secure Digital Host Controller Interface found on the
"Hollywood" chipset of the Nintendo Wii video game console.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig         |   13 +++++
 drivers/mmc/host/Makefile        |    1 
 drivers/mmc/host/sdhci-of-core.c |    3 +
 drivers/mmc/host/sdhci-of-hlwd.c |   65 +++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-of.h      |    1 
 5 files changed, 82 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/Kconfig~sdhci-of-add-support-for-the-wii-sdhci-controller drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~sdhci-of-add-support-for-the-wii-sdhci-controller
+++ a/drivers/mmc/host/Kconfig
@@ -55,7 +55,7 @@ config MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_S
 	  has the effect of scrambling the addresses and formats of data
 	  accessed in sizes other than the datum size.
 
-	  This is the case for the Freescale eSDHC.
+	  This is the case for the Freescale eSDHC and Nintendo Wii SDHCI.
 
 config MMC_SDHCI_PCI
 	tristate "SDHCI support on PCI bus"
@@ -103,6 +103,17 @@ config MMC_SDHCI_OF_ESDHC
 
 	  If unsure, say N.
 
+config MMC_SDHCI_OF_HLWD
+	bool "SDHCI OF support for the Nintendo Wii SDHCI controllers"
+	depends on MMC_SDHCI_OF
+	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
+	help
+	  This selects the Secure Digital Host Controller Interface (SDHCI)
+	  found in the "Hollywood" chipset of the Nintendo Wii video game
+	  console.
+
+	  If unsure, say N.
+
 config MMC_SDHCI_PLTFM
 	tristate "SDHCI support on the platform specific bus"
 	depends on MMC_SDHCI
diff -puN drivers/mmc/host/Makefile~sdhci-of-add-support-for-the-wii-sdhci-controller drivers/mmc/host/Makefile
--- a/drivers/mmc/host/Makefile~sdhci-of-add-support-for-the-wii-sdhci-controller
+++ a/drivers/mmc/host/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_SDH_BFIN)		+= bfin_sdh.o
 obj-$(CONFIG_MMC_SDHCI_OF)	+= sdhci-of.o
 sdhci-of-y				:= sdhci-of-core.o
 sdhci-of-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
+sdhci-of-$(CONFIG_MMC_SDHCI_OF_HLWD)	+= sdhci-of-hlwd.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff -puN drivers/mmc/host/sdhci-of-core.c~sdhci-of-add-support-for-the-wii-sdhci-controller drivers/mmc/host/sdhci-of-core.c
--- a/drivers/mmc/host/sdhci-of-core.c~sdhci-of-add-support-for-the-wii-sdhci-controller
+++ a/drivers/mmc/host/sdhci-of-core.c
@@ -196,6 +196,9 @@ static const struct of_device_id sdhci_o
 	{ .compatible = "fsl,mpc8536-esdhc", .data = &sdhci_esdhc, },
 	{ .compatible = "fsl,esdhc", .data = &sdhci_esdhc, },
 #endif
+#ifdef CONFIG_MMC_SDHCI_OF_HLWD
+	{ .compatible = "nintendo,hollywood-sdhci", .data = &sdhci_hlwd, },
+#endif
 	{ .compatible = "generic-sdhci", },
 	{},
 };
diff -puN /dev/null drivers/mmc/host/sdhci-of-hlwd.c
--- /dev/null
+++ a/drivers/mmc/host/sdhci-of-hlwd.c
@@ -0,0 +1,65 @@
+/*
+ * drivers/mmc/host/sdhci-of-hlwd.c
+ *
+ * Nintendo Wii Secure Digital Host Controller Interface.
+ * Copyright (C) 2009 The GameCube Linux Team
+ * Copyright (C) 2009 Albert Herranz
+ *
+ * Based on sdhci-of-esdhc.c
+ *
+ * Copyright (c) 2007 Freescale Semiconductor, Inc.
+ * Copyright (c) 2009 MontaVista Software, Inc.
+ *
+ * Authors: Xiaobo Xie <X.Xie@freescale.com>
+ *	    Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/mmc/host.h>
+#include "sdhci-of.h"
+#include "sdhci.h"
+
+/*
+ * Ops and quirks for the Nintendo Wii SDHCI controllers.
+ */
+
+/*
+ * We need a small delay after each write, or things go horribly wrong.
+ */
+#define SDHCI_HLWD_WRITE_DELAY	5 /* usecs */
+
+static void sdhci_hlwd_writel(struct sdhci_host *host, u32 val, int reg)
+{
+	sdhci_be32bs_writel(host, val, reg);
+	udelay(SDHCI_HLWD_WRITE_DELAY);
+}
+
+static void sdhci_hlwd_writew(struct sdhci_host *host, u16 val, int reg)
+{
+	sdhci_be32bs_writew(host, val, reg);
+	udelay(SDHCI_HLWD_WRITE_DELAY);
+}
+
+static void sdhci_hlwd_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	sdhci_be32bs_writeb(host, val, reg);
+	udelay(SDHCI_HLWD_WRITE_DELAY);
+}
+
+struct sdhci_of_data sdhci_hlwd = {
+	.quirks = SDHCI_QUIRK_32BIT_DMA_ADDR |
+		  SDHCI_QUIRK_32BIT_DMA_SIZE,
+	.ops = {
+		.readl = sdhci_be32bs_readl,
+		.readw = sdhci_be32bs_readw,
+		.readb = sdhci_be32bs_readb,
+		.writel = sdhci_hlwd_writel,
+		.writew = sdhci_hlwd_writew,
+		.writeb = sdhci_hlwd_writeb,
+	},
+};
diff -puN drivers/mmc/host/sdhci-of.h~sdhci-of-add-support-for-the-wii-sdhci-controller drivers/mmc/host/sdhci-of.h
--- a/drivers/mmc/host/sdhci-of.h~sdhci-of-add-support-for-the-wii-sdhci-controller
+++ a/drivers/mmc/host/sdhci-of.h
@@ -37,5 +37,6 @@ extern void sdhci_be32bs_writew(struct s
 extern void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg);
 
 extern struct sdhci_of_data sdhci_esdhc;
+extern struct sdhci_of_data sdhci_hlwd;
 
 #endif /* __SDHCI_OF_H */
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

origin.patch
linux-next.patch
sdhci-protect-header-file-against-multi-inclusion.patch
sdhci-of-rename-main-driver-file-prior-to-reorganization.patch
sdhci-of-reorganize-driver-to-support-additional-hardware.patch
sdhci-of-add-support-for-the-wii-sdhci-controller.patch
sdio-recognize-io-card-without-powercycle.patch

