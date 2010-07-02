From: akpm@linux-foundation.org
Subject: + sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch added to -mm tree
Date: Fri, 02 Jul 2010 14:58:23 -0700
Message-ID: <201007022158.o62LwNek029104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab0GBV6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 17:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, ben@simtec.co.uk, linux-mmc@vger.kernel.org, richard.rojfors@pelagicore.com


The patch titled
     sdhci-pltfm: add support for CNS3xxx SoC devices
has been added to the -mm tree.  Its filename is
     sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sdhci-pltfm: add support for CNS3xxx SoC devices
=46rom: Anton Vorontsov <avorontsov@mvista.com>

There's nothing special, just SoC-specific ops and quirks.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>=20
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig         |    9 ++
 drivers/mmc/host/Makefile        |    1=20
 drivers/mmc/host/sdhci-cns3xxx.c |   97 +++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-pltfm.c   |    3=20
 drivers/mmc/host/sdhci-pltfm.h   |    4 +
 5 files changed, 114 insertions(+)

diff -puN drivers/mmc/host/Kconfig~sdhci-pltfm-add-support-for-cns3xxx-=
soc-devices drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~sdhci-pltfm-add-support-for-cns3xxx-soc-=
devices
+++ a/drivers/mmc/host/Kconfig
@@ -129,6 +129,15 @@ config MMC_SDHCI_PLTFM
=20
 	  If unsure, say N.
=20
+config MMC_SDHCI_CNS3XXX
+	bool "SDHCI support on the Cavium Networks CNS3xxx SoC"
+	depends on ARCH_CNS3XXX
+	depends on MMC_SDHCI_PLTFM
+	help
+	  This selects the SDHCI support for CNS3xxx System-on-Chip devices.
+
+	  If unsure, say N.
+
 config MMC_SDHCI_S3C
 	tristate "SDHCI support on Samsung S3C SoC"
 	depends on MMC_SDHCI && PLAT_SAMSUNG
diff -puN drivers/mmc/host/Makefile~sdhci-pltfm-add-support-for-cns3xxx=
-soc-devices drivers/mmc/host/Makefile
--- a/drivers/mmc/host/Makefile~sdhci-pltfm-add-support-for-cns3xxx-soc=
-devices
+++ a/drivers/mmc/host/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_MMC_JZ4740)	+=3D jz4740_mmc.o
=20
 obj-$(CONFIG_MMC_SDHCI_PLTFM)			+=3D sdhci-platform.o
 sdhci-platform-y				:=3D sdhci-pltfm.o
+sdhci-platform-$(CONFIG_MMC_SDHCI_CNS3XXX)	+=3D sdhci-cns3xxx.o
=20
 obj-$(CONFIG_MMC_SDHCI_OF)	+=3D sdhci-of.o
 sdhci-of-y				:=3D sdhci-of-core.o
diff -puN /dev/null drivers/mmc/host/sdhci-cns3xxx.c
--- /dev/null
+++ a/drivers/mmc/host/sdhci-cns3xxx.c
@@ -0,0 +1,97 @@
+/*
+ * SDHCI support for CNS3xxx SoC
+ *
+ * Copyright 2008 Cavium Networks
+ * Copyright 2010 MontaVista Software, LLC.
+ *
+ * Authors: Scott Shu
+ *	    Anton Vorontsov <avorontsov@mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/mmc/host.h>
+#include <linux/sdhci-pltfm.h>
+#include <mach/cns3xxx.h>
+#include "sdhci.h"
+#include "sdhci-pltfm.h"
+
+static unsigned int sdhci_cns3xxx_get_max_clk(struct sdhci_host *host)
+{
+	return 150000000;
+}
+
+static void sdhci_cns3xxx_set_clock(struct sdhci_host *host, unsigned =
int clock)
+{
+	struct device *dev =3D mmc_dev(host->mmc);
+	int div =3D 1;
+	u16 clk;
+	unsigned long timeout;
+
+	if (clock =3D=3D host->clock)
+		return;
+
+	sdhci_writew(host, 0, SDHCI_CLOCK_CONTROL);
+
+	if (clock =3D=3D 0)
+		goto out;
+
+	while (host->max_clk / div > clock) {
+		/*
+		 * On CNS3xxx divider grows linearly up to 4, and then
+		 * exponentially up to 256.
+		 */
+		if (div < 4)
+			div +=3D 1;
+		else if (div < 256)
+			div *=3D 2;
+		else
+			break;
+	}
+
+	dev_dbg(dev, "desired SD clock: %d, actual: %d\n",
+		clock, host->max_clk / div);
+
+	/* Divide by 3 is special. */
+	if (div !=3D 3)
+		div >>=3D 1;
+
+	clk =3D div << SDHCI_DIVIDER_SHIFT;
+	clk |=3D SDHCI_CLOCK_INT_EN;
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
+
+	timeout =3D 20;
+	while (!((clk =3D sdhci_readw(host, SDHCI_CLOCK_CONTROL))
+			& SDHCI_CLOCK_INT_STABLE)) {
+		if (timeout =3D=3D 0) {
+			dev_warn(dev, "clock is unstable");
+			break;
+		}
+		timeout--;
+		mdelay(1);
+	}
+
+	clk |=3D SDHCI_CLOCK_CARD_EN;
+	sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
+out:
+	host->clock =3D clock;
+}
+
+static struct sdhci_ops sdhci_cns3xxx_ops =3D {
+	.get_max_clock	=3D sdhci_cns3xxx_get_max_clk,
+	.set_clock	=3D sdhci_cns3xxx_set_clock,
+};
+
+struct sdhci_pltfm_data sdhci_cns3xxx_pdata =3D {
+	.ops =3D &sdhci_cns3xxx_ops,
+	.quirks =3D SDHCI_QUIRK_BROKEN_DMA |
+		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
+		  SDHCI_QUIRK_INVERTED_WRITE_PROTECT |
+		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN |
+		  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL |
+		  SDHCI_QUIRK_NONSTANDARD_CLOCK,
+};
diff -puN drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-add-support-for-cn=
s3xxx-soc-devices drivers/mmc/host/sdhci-pltfm.c
--- a/drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-add-support-for-cns3xx=
x-soc-devices
+++ a/drivers/mmc/host/sdhci-pltfm.c
@@ -158,6 +158,9 @@ static int __devexit sdhci_pltfm_remove(
=20
 static const struct platform_device_id sdhci_pltfm_ids[] =3D {
 	{ "sdhci", },
+#ifdef CONFIG_MMC_SDHCI_CNS3XXX
+	{ "sdhci-cns3xxx", (kernel_ulong_t)&sdhci_cns3xxx_pdata },
+#endif
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
diff -puN drivers/mmc/host/sdhci-pltfm.h~sdhci-pltfm-add-support-for-cn=
s3xxx-soc-devices drivers/mmc/host/sdhci-pltfm.h
--- a/drivers/mmc/host/sdhci-pltfm.h~sdhci-pltfm-add-support-for-cns3xx=
x-soc-devices
+++ a/drivers/mmc/host/sdhci-pltfm.h
@@ -11,4 +11,8 @@
 #ifndef _DRIVERS_MMC_SDHCI_PLTFM_H
 #define _DRIVERS_MMC_SDHCI_PLTFM_H
=20
+#include <linux/sdhci-pltfm.h>
+
+extern struct sdhci_pltfm_data sdhci_cns3xxx_pdata;
+
 #endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
_

Patches currently in -mm which might be from avorontsov@mvista.com are

origin.patch
linux-next.patch
sdhci-pltfm-switch-to-module-device-table-matching.patch
sdhci-pltfm-reorganize-makefile-entries-to-support-soc-devices.patch
sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
