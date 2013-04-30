From: akpm@linux-foundation.org
Subject: [merged] misc-generic-on-chip-sram-allocation-driver.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:42 -0700
Message-ID: <20130430185042.9557531C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:39123 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3Suo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:44 -0400
Received: by mail-qe0-f73.google.com with SMTP id 9so86279qea.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: p.zabel@pengutronix.de, dong.aisheng@linaro.org, fabio.estevam@freescale.com, grant.likely@secretlab.ca, gregkh@linuxfoundation.org, javier.martin@vista-silicon.com, monstr@monstr.eu, mporter@ti.com, paul.gortmaker@windriver.com, rob.herring@calxeda.com, shawn.guo@linaro.org, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: misc: generic on-chip SRAM allocation driver
has been removed from the -mm tree.  Its filename was
     misc-generic-on-chip-sram-allocation-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: misc: generic on-chip SRAM allocation driver

This driver requests and remaps a memory region as configured in the
device tree.  It serves memory from this region via the genalloc API.  It
optionally enables the SRAM clock.

Other drivers can retrieve the genalloc pool from a phandle pointing to
this drivers' device node in the device tree.

The allocation granularity is hard-coded to 32 bytes for now, to make the
SRAM driver useful for the 6502 remoteproc driver.  There is overhead for
bigger SRAMs, where only a much coarser allocation granularity is needed:
At 32 bytes minimum allocation size, a 256 KiB SRAM needs a 1 KiB bitmap
to track allocations.

[akpm@linux-foundation.org: fix Kconfig text, make sram_init static]
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Michal Simek <monstr@monstr.eu>
Cc: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Matt Porter <mporter@ti.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/misc/sram.txt |   16 +
 drivers/misc/Kconfig                            |    9 +
 drivers/misc/Makefile                           |    1 
 drivers/misc/sram.c                             |  121 ++++++++++++++
 4 files changed, 147 insertions(+)

diff -puN /dev/null Documentation/devicetree/bindings/misc/sram.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/misc/sram.txt
@@ -0,0 +1,16 @@
+Generic on-chip SRAM
+
+Simple IO memory regions to be managed by the genalloc API.
+
+Required properties:
+
+- compatible : mmio-sram
+
+- reg : SRAM iomem address range
+
+Example:
+
+sram: sram@5c000000 {
+	compatible = "mmio-sram";
+	reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
+};
diff -puN drivers/misc/Kconfig~misc-generic-on-chip-sram-allocation-driver drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-generic-on-chip-sram-allocation-driver
+++ a/drivers/misc/Kconfig
@@ -518,6 +518,15 @@ config LATTICE_ECP3_CONFIG
 
 	  If unsure, say N.
 
+config SRAM
+	bool "Generic on-chip SRAM driver"
+	depends on HAS_IOMEM
+	select GENERIC_ALLOCATOR
+	help
+	  This driver allows you to declare a memory region to be managed by
+	  the genalloc API. It is supposed to be used for small on-chip SRAM
+	  areas found on many SoCs.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff -puN drivers/misc/Makefile~misc-generic-on-chip-sram-allocation-driver drivers/misc/Makefile
--- a/drivers/misc/Makefile~misc-generic-on-chip-sram-allocation-driver
+++ a/drivers/misc/Makefile
@@ -52,3 +52,4 @@ obj-$(CONFIG_ALTERA_STAPL)	+=altera-stap
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
+obj-$(CONFIG_SRAM)		+= sram.o
diff -puN /dev/null drivers/misc/sram.c
--- /dev/null
+++ a/drivers/misc/sram.c
@@ -0,0 +1,121 @@
+/*
+ * Generic on-chip SRAM allocation driver
+ *
+ * Copyright (C) 2012 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/genalloc.h>
+
+#define SRAM_GRANULARITY	32
+
+struct sram_dev {
+	struct gen_pool *pool;
+	struct clk *clk;
+};
+
+static int sram_probe(struct platform_device *pdev)
+{
+	void __iomem *virt_base;
+	struct sram_dev *sram;
+	struct resource *res;
+	unsigned long size;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
+	size = resource_size(res);
+
+	virt_base = devm_request_and_ioremap(&pdev->dev, res);
+	if (!virt_base)
+		return -EADDRNOTAVAIL;
+
+	sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
+	if (!sram)
+		return -ENOMEM;
+
+	sram->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(sram->clk))
+		sram->clk = NULL;
+	else
+		clk_prepare_enable(sram->clk);
+
+	sram->pool = devm_gen_pool_create(&pdev->dev, ilog2(SRAM_GRANULARITY), -1);
+	if (!sram->pool)
+		return -ENOMEM;
+
+	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
+				res->start, size, -1);
+	if (ret < 0) {
+		gen_pool_destroy(sram->pool);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, sram);
+
+	dev_dbg(&pdev->dev, "SRAM pool: %ld KiB @ 0x%p\n", size / 1024, virt_base);
+
+	return 0;
+}
+
+static int sram_remove(struct platform_device *pdev)
+{
+	struct sram_dev *sram = platform_get_drvdata(pdev);
+
+	if (gen_pool_avail(sram->pool) < gen_pool_size(sram->pool))
+		dev_dbg(&pdev->dev, "removed while SRAM allocated\n");
+
+	gen_pool_destroy(sram->pool);
+
+	if (sram->clk)
+		clk_disable_unprepare(sram->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static struct of_device_id sram_dt_ids[] = {
+	{ .compatible = "mmio-sram" },
+	{}
+};
+#endif
+
+static struct platform_driver sram_driver = {
+	.driver = {
+		.name = "sram",
+		.of_match_table = of_match_ptr(sram_dt_ids),
+	},
+	.probe = sram_probe,
+	.remove = sram_remove,
+};
+
+static int __init sram_init(void)
+{
+	return platform_driver_register(&sram_driver);
+}
+
+postcore_initcall(sram_init);
_

Patches currently in -mm which might be from p.zabel@pengutronix.de are

origin.patch
linux-next.patch

