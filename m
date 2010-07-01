From: akpm@linux-foundation.org
Subject: + sdhci-pltfm-switch-to-module-device-table-matching.patch added to -mm tree
Date: Thu, 01 Jul 2010 13:51:53 -0700
Message-ID: <201007012051.o61KprJa026049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933003Ab0GAUwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 16:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, ben@simtec.co.uk, linux-mmc@vger.kernel.org, richard.rojfors@pelagicore.com


The patch titled
     sdhci-pltfm: switch to module device table matching
has been added to the -mm tree.  Its filename is
     sdhci-pltfm-switch-to-module-device-table-matching.patch

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
Subject: sdhci-pltfm: switch to module device table matching
=46rom: Anton Vorontsov <avorontsov@mvista.com>

Sometimes want to place SoC-specific parts alongside with the generic
driver, and to do so, we have to switch the driver over to the module
device table matching.

Note that drivers/mmc/host/sdhci-pltfm.h is so far empty, but it'll hol=
d
SoC-specific driver data handlers soon.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>=20
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pltfm.c |   14 +++++++++++++-
 drivers/mmc/host/sdhci-pltfm.h |   14 ++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-switch-to-module-d=
evice-table-matching drivers/mmc/host/sdhci-pltfm.c
--- a/drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-switch-to-module-devic=
e-table-matching
+++ a/drivers/mmc/host/sdhci-pltfm.c
@@ -24,6 +24,7 @@
=20
 #include <linux/delay.h>
 #include <linux/highmem.h>
+#include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
=20
 #include <linux/mmc/host.h>
@@ -32,6 +33,7 @@
 #include <linux/sdhci-pltfm.h>
=20
 #include "sdhci.h"
+#include "sdhci-pltfm.h"
=20
 /*********************************************************************=
********\
  *                                                                    =
       *
@@ -51,10 +53,14 @@ static struct sdhci_ops sdhci_pltfm_ops=20
 static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 {
 	struct sdhci_pltfm_data *pdata =3D pdev->dev.platform_data;
+	const struct platform_device_id *platid =3D platform_get_device_id(pd=
ev);
 	struct sdhci_host *host;
 	struct resource *iomem;
 	int ret;
=20
+	if (!pdata && platid && platid->driver_data)
+		pdata =3D (void *)platid->driver_data;
+
 	iomem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iomem) {
 		ret =3D -ENOMEM;
@@ -150,6 +156,12 @@ static int __devexit sdhci_pltfm_remove(
 	return 0;
 }
=20
+static const struct platform_device_id sdhci_pltfm_ids[] =3D {
+	{ "sdhci", },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, sdhci_pltfm_ids);
+
 static struct platform_driver sdhci_pltfm_driver =3D {
 	.driver =3D {
 		.name	=3D "sdhci",
@@ -157,6 +169,7 @@ static struct platform_driver sdhci_pltf
 	},
 	.probe		=3D sdhci_pltfm_probe,
 	.remove		=3D __devexit_p(sdhci_pltfm_remove),
+	.id_table	=3D sdhci_pltfm_ids,
 };
=20
 /*********************************************************************=
********\
@@ -181,4 +194,3 @@ module_exit(sdhci_drv_exit);
 MODULE_DESCRIPTION("Secure Digital Host Controller Interface platform =
driver");
 MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:sdhci");
diff -puN /dev/null drivers/mmc/host/sdhci-pltfm.h
--- /dev/null
+++ a/drivers/mmc/host/sdhci-pltfm.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright 2010 MontaVista Software, LLC.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DRIVERS_MMC_SDHCI_PLTFM_H
+#define _DRIVERS_MMC_SDHCI_PLTFM_H
+
+#endif /* _DRIVERS_MMC_SDHCI_PLTFM_H */
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
