From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch removed from -mm tree
Date: Wed, 15 Aug 2012 13:23:59 -0700
Message-ID: <20120815202359.D8F61100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42598 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab2HOUYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 16:24:01 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so1435034obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 13:24:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zonque@gmail.com, eric.piel@tremplin-utc.net, grant.likely@secretlab.ca, rob.herring@calxeda.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching table passthru code
has been removed from the -mm tree.  Its filename was
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Daniel Mack <zonque@gmail.com>
Subject: drivers/misc/lis3lv02d/lis3lv02d_spi.c: add DT matching table passthru code

If probed from a device tree, this driver now passes the node information
to the generic part, so the runtime information can be derived.

Successfully tested on a PXA3xx board.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_spi.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code drivers/misc/lis3lv02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -17,6 +17,7 @@
 #include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/pm.h>
+#include <linux/of_platform.h>
 
 #include "lis3lv02d.h"
 
@@ -58,6 +59,12 @@ static int lis3_spi_init(struct lis3lv02
 static union axis_conversion lis3lv02d_axis_normal =
 	{ .as_array = { 1, 2, 3 } };
 
+static struct of_device_id lis302dl_spi_dt_ids[] = {
+	{ .compatible = "st,lis302dl-spi" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, lis302dl_spi_dt_ids);
+
 static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 {
 	int ret;
@@ -75,6 +82,12 @@ static int __devinit lis302dl_spi_probe(
 	lis3_dev.irq		= spi->irq;
 	lis3_dev.ac		= lis3lv02d_axis_normal;
 	lis3_dev.pdata		= spi->dev.platform_data;
+
+#ifdef CONFIG_OF
+	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev))
+		lis3_dev.of_node = spi->dev.of_node;
+#endif
+
 	spi_set_drvdata(spi, &lis3_dev);
 
 	return lis3lv02d_init_device(&lis3_dev);
@@ -121,6 +134,7 @@ static struct spi_driver lis302dl_spi_dr
 		.name   = DRV_NAME,
 		.owner  = THIS_MODULE,
 		.pm	= &lis3lv02d_spi_pm,
+		.of_match_table = of_match_ptr(lis302dl_spi_dt_ids),
 	},
 	.probe	= lis302dl_spi_probe,
 	.remove	= __devexit_p(lis302dl_spi_remove),
_

Patches currently in -mm which might be from zonque@gmail.com are

origin.patch
linux-next.patch
drivers-w1-masters-w1-gpioc-add-ext_pullup_enable-pin-in-platform-data.patch
drivers-w1-masters-w1-gpioc-add-dt-bindings.patch

