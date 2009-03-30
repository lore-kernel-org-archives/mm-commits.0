From: akpm@linux-foundation.org
Subject: [merged] mtd-rbtx4939-map-driver-v2.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:05:47 -0700
Message-ID: <200903301905.n2UJ5lPh018776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757525AbZC3T2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:28:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MTD: RBTX4939 map driver
has been removed from the -mm tree.  Its filename was
     mtd-rbtx4939-map-driver-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD: RBTX4939 map driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This is a map driver for NOR flash chips on RBTX4939 board.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig          |    6 
 drivers/mtd/maps/Makefile         |    1 
 drivers/mtd/maps/rbtx4939-flash.c |  208 ++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+)

diff -puN drivers/mtd/maps/Kconfig~mtd-rbtx4939-map-driver-v2 drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-rbtx4939-map-driver-v2
+++ a/drivers/mtd/maps/Kconfig
@@ -542,6 +542,12 @@ config MTD_INTEL_VR_NOR
 	  Map driver for a NOR flash bank located on the Expansion Bus of the
 	  Intel Vermilion Range chipset.
 
+config MTD_RBTX4939
+	tristate "Map driver for RBTX4939 board"
+	depends on TOSHIBA_RBTX4939 && MTD_CFI && MTD_COMPLEX_MAPPINGS
+	help
+	  Map driver for NOR flash chips on RBTX4939 board.
+
 config MTD_PLATRAM
 	tristate "Map driver for platform device RAM (mtd-ram)"
 	select MTD_RAM
diff -puN drivers/mtd/maps/Makefile~mtd-rbtx4939-map-driver-v2 drivers/mtd/maps/Makefile
--- a/drivers/mtd/maps/Makefile~mtd-rbtx4939-map-driver-v2
+++ a/drivers/mtd/maps/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_MTD_NETSC520)	+= netsc520.o
 obj-$(CONFIG_MTD_TS5500)	+= ts5500_flash.o
 obj-$(CONFIG_MTD_SUN_UFLASH)	+= sun_uflash.o
 obj-$(CONFIG_MTD_VMAX)		+= vmax301.o
+obj-$(CONFIG_MTD_RBTX4939)	+= rbtx4939-flash.o
 obj-$(CONFIG_MTD_SCx200_DOCFLASH)+= scx200_docflash.o
 obj-$(CONFIG_MTD_DBOX2)		+= dbox2-flash.o
 obj-$(CONFIG_MTD_SOLUTIONENGINE)+= solutionengine.o
diff -puN /dev/null drivers/mtd/maps/rbtx4939-flash.c
--- /dev/null
+++ a/drivers/mtd/maps/rbtx4939-flash.c
@@ -0,0 +1,208 @@
+/*
+ * rbtx4939-flash (based on physmap.c)
+ *
+ * This is a simplified physmap driver with map_init callback function.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Copyright (C) 2009 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+#include <asm/txx9/rbtx4939.h>
+
+struct rbtx4939_flash_info {
+	struct mtd_info *mtd;
+	struct map_info map;
+#ifdef CONFIG_MTD_PARTITIONS
+	int nr_parts;
+	struct mtd_partition *parts;
+#endif
+};
+
+static int rbtx4939_flash_remove(struct platform_device *dev)
+{
+	struct rbtx4939_flash_info *info;
+
+	info = platform_get_drvdata(dev);
+	if (!info)
+		return 0;
+	platform_set_drvdata(dev, NULL);
+
+	if (info->mtd) {
+#ifdef CONFIG_MTD_PARTITIONS
+		struct rbtx4939_flash_data *pdata = dev->dev.platform_data;
+
+		if (info->nr_parts) {
+			del_mtd_partitions(info->mtd);
+			kfree(info->parts);
+		} else if (pdata->nr_parts)
+			del_mtd_partitions(info->mtd);
+		else
+			del_mtd_device(info->mtd);
+#else
+		del_mtd_device(info->mtd);
+#endif
+		map_destroy(info->mtd);
+	}
+	return 0;
+}
+
+static const char *rom_probe_types[] = { "cfi_probe", "jedec_probe", NULL };
+#ifdef CONFIG_MTD_PARTITIONS
+static const char *part_probe_types[] = { "cmdlinepart", NULL };
+#endif
+
+static int rbtx4939_flash_probe(struct platform_device *dev)
+{
+	struct rbtx4939_flash_data *pdata;
+	struct rbtx4939_flash_info *info;
+	struct resource *res;
+	const char **probe_type;
+	int err = 0;
+	unsigned long size;
+
+	pdata = dev->dev.platform_data;
+	if (!pdata)
+		return -ENODEV;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	info = devm_kzalloc(&dev->dev, sizeof(struct rbtx4939_flash_info),
+			    GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	platform_set_drvdata(dev, info);
+
+	size = resource_size(res);
+	pr_notice("rbtx4939 platform flash device: %pR\n", res);
+
+	if (!devm_request_mem_region(&dev->dev, res->start, size,
+				     dev_name(&dev->dev)))
+		return -EBUSY;
+
+	info->map.name = dev_name(&dev->dev);
+	info->map.phys = res->start;
+	info->map.size = size;
+	info->map.bankwidth = pdata->width;
+
+	info->map.virt = devm_ioremap(&dev->dev, info->map.phys, size);
+	if (!info->map.virt)
+		return -EBUSY;
+
+	if (pdata->map_init)
+		(*pdata->map_init)(&info->map);
+	else
+		simple_map_init(&info->map);
+
+	probe_type = rom_probe_types;
+	for (; !info->mtd && *probe_type; probe_type++)
+		info->mtd = do_map_probe(*probe_type, &info->map);
+	if (!info->mtd) {
+		dev_err(&dev->dev, "map_probe failed\n");
+		err = -ENXIO;
+		goto err_out;
+	}
+	info->mtd->owner = THIS_MODULE;
+	if (err)
+		goto err_out;
+
+#ifdef CONFIG_MTD_PARTITIONS
+	err = parse_mtd_partitions(info->mtd, part_probe_types,
+				&info->parts, 0);
+	if (err > 0) {
+		add_mtd_partitions(info->mtd, info->parts, err);
+		info->nr_parts = err;
+		return 0;
+	}
+
+	if (pdata->nr_parts) {
+		pr_notice("Using rbtx4939 partition information\n");
+		add_mtd_partitions(info->mtd, pdata->parts, pdata->nr_parts);
+		return 0;
+	}
+#endif
+
+	add_mtd_device(info->mtd);
+	return 0;
+
+err_out:
+	rbtx4939_flash_remove(dev);
+	return err;
+}
+
+#ifdef CONFIG_PM
+static int rbtx4939_flash_suspend(struct platform_device *dev,
+				  pm_message_t state)
+{
+	struct rbtx4939_flash_info *info = platform_get_drvdata(dev);
+
+	if (info->mtd->suspend)
+		return info->mtd->suspend(info->mtd);
+	return 0;
+}
+
+static int rbtx4939_flash_resume(struct platform_device *dev)
+{
+	struct rbtx4939_flash_info *info = platform_get_drvdata(dev);
+
+	if (info->mtd->resume)
+		info->mtd->resume(info->mtd);
+	return 0;
+}
+
+static void rbtx4939_flash_shutdown(struct platform_device *dev)
+{
+	struct rbtx4939_flash_info *info = platform_get_drvdata(dev);
+
+	if (info->mtd->suspend && info->mtd->resume)
+		if (info->mtd->suspend(info->mtd) == 0)
+			info->mtd->resume(info->mtd);
+}
+#else
+#define rbtx4939_flash_suspend NULL
+#define rbtx4939_flash_resume NULL
+#define rbtx4939_flash_shutdown NULL
+#endif
+
+static struct platform_driver rbtx4939_flash_driver = {
+	.probe		= rbtx4939_flash_probe,
+	.remove		= rbtx4939_flash_remove,
+	.suspend	= rbtx4939_flash_suspend,
+	.resume		= rbtx4939_flash_resume,
+	.shutdown	= rbtx4939_flash_shutdown,
+	.driver		= {
+		.name	= "rbtx4939-flash",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init rbtx4939_flash_init(void)
+{
+	return platform_driver_register(&rbtx4939_flash_driver);
+}
+
+static void __exit rbtx4939_flash_exit(void)
+{
+	platform_driver_unregister(&rbtx4939_flash_driver);
+}
+
+module_init(rbtx4939_flash_init);
+module_exit(rbtx4939_flash_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RBTX4939 MTD map driver");
+MODULE_ALIAS("platform:rbtx4939-flash");
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

