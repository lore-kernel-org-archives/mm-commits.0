From: akpm@linux-foundation.org
Subject: + sdhci-pltfm-implement-platform-data-passing.patch added to -mm tree
Date: Mon, 22 Mar 2010 12:31:00 -0700
Message-ID: <201003221931.o2MJV03K022734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755602Ab0CVTb0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 15:31:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben@simtec.co.uk, david.vrabel@csr.com, linux-mmc@vger.kernel.org, pierre@ossman.eu, richard.rojfors@pelagicore.com


The patch titled
     sdhci-pltfm: implement platform data passing
has been added to the -mm tree.  Its filename is
     sdhci-pltfm-implement-platform-data-passing.patch

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
Subject: sdhci-pltfm: implement platform data passing
=46rom: Anton Vorontsov <avorontsov@ru.mvista.com>

This includes platform ops, quirks and (de)initialization callbacks.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: David Vrabel <david.vrabel@csr.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pltfm.c |   24 ++++++++++++++++++++----
 include/linux/sdhci-pltfm.h    |   27 +++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 4 deletions(-)

diff -puN drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-implement-platform=
-data-passing drivers/mmc/host/sdhci-pltfm.c
--- a/drivers/mmc/host/sdhci-pltfm.c~sdhci-pltfm-implement-platform-dat=
a-passing
+++ a/drivers/mmc/host/sdhci-pltfm.c
@@ -29,6 +29,7 @@
 #include <linux/mmc/host.h>
=20
 #include <linux/io.h>
+#include <linux/sdhci-pltfm.h>
=20
 #include "sdhci.h"
=20
@@ -49,12 +50,11 @@ static struct sdhci_ops sdhci_pltfm_ops=20
=20
 static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 {
+	struct sdhci_pltfm_data *pdata =3D pdev->dev.platform_data;
 	struct sdhci_host *host;
 	struct resource *iomem;
 	int ret;
=20
-	BUG_ON(pdev =3D=3D NULL);
-
 	iomem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iomem) {
 		ret =3D -ENOMEM;
@@ -76,7 +76,12 @@ static int __devinit sdhci_pltfm_probe(s
 	}
=20
 	host->hw_name =3D "platform";
-	host->ops =3D &sdhci_pltfm_ops;
+	if (pdata && pdata->ops)
+		host->ops =3D pdata->ops;
+	else
+		host->ops =3D &sdhci_pltfm_ops;
+	if (pdata)
+		host->quirks =3D pdata->quirks;
 	host->irq =3D platform_get_irq(pdev, 0);
=20
 	if (!request_mem_region(iomem->start, resource_size(iomem),
@@ -93,6 +98,12 @@ static int __devinit sdhci_pltfm_probe(s
 		goto err_remap;
 	}
=20
+	if (pdata && pdata->init) {
+		ret =3D pdata->init(host);
+		if (ret)
+			goto err_plat_init;
+	}
+
 	ret =3D sdhci_add_host(host);
 	if (ret)
 		goto err_add_host;
@@ -102,6 +113,9 @@ static int __devinit sdhci_pltfm_probe(s
 	return 0;
=20
 err_add_host:
+	if (pdata && pdata->exit)
+		pdata->exit(host);
+err_plat_init:
 	iounmap(host->ioaddr);
 err_remap:
 	release_mem_region(iomem->start, resource_size(iomem));
@@ -114,6 +128,7 @@ err:
=20
 static int __devexit sdhci_pltfm_remove(struct platform_device *pdev)
 {
+	struct sdhci_pltfm_data *pdata =3D pdev->dev.platform_data;
 	struct sdhci_host *host =3D platform_get_drvdata(pdev);
 	struct resource *iomem =3D platform_get_resource(pdev, IORESOURCE_MEM=
, 0);
 	int dead;
@@ -125,6 +140,8 @@ static int __devexit sdhci_pltfm_remove(
 		dead =3D 1;
=20
 	sdhci_remove_host(host, dead);
+	if (pdata && pdata->exit)
+		pdata->exit(host);
 	iounmap(host->ioaddr);
 	release_mem_region(iomem->start, resource_size(iomem));
 	sdhci_free_host(host);
@@ -165,4 +182,3 @@ MODULE_DESCRIPTION("Secure Digital Host=20
 MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:sdhci");
-
diff -puN /dev/null include/linux/sdhci-pltfm.h
--- /dev/null
+++ a/include/linux/sdhci-pltfm.h
@@ -0,0 +1,27 @@
+/*
+ * Platform data declarations for the sdhci-pltfm driver.
+ *
+ * Copyright (c) 2010 MontaVista Software, LLC.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or (=
at
+ * your option) any later version.
+ */
+
+#ifndef _SDHCI_PLTFM_H
+#define _SDHCI_PLTFM_H
+
+struct sdhci_ops;
+struct sdhci_host;
+
+struct sdhci_pltfm_data {
+	struct sdhci_ops *ops;
+	unsigned int quirks;
+	int (*init)(struct sdhci_host *host);
+	void (*exit)(struct sdhci_host *host);
+};
+
+#endif /* _SDHCI_PLTFM_H */
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com a=
re

linux-next.patch
gpiolib-introduce-chip-addition-removal-notifier.patch
of-gpio-add-support-for-two-stage-registration-for-the-of_gpio_chips.pa=
tch
of-gpio-implement-gpiolib-notifier-hooks.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
powerpc-mcu_mpc8349emitx-remove-of-gpio-handling-stuff.patch
gpiolib-cosmetic-improvements-for-error-handling-in-gpiochip_add.patch
sdhci-implement-cap_clock_base_broken-quirk.patch
sdhci-pltfm-implement-platform-data-passing.patch
sdhci-pltfm-do-not-print-errors-in-case-of-an-extended-iomem-size.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
