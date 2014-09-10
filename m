From: akpm@linux-foundation.org
Subject: + clk-rk808-add-clkout-driver-for-rk808.patch added to -mm tree
Date: Wed, 10 Sep 2014 13:39:09 -0700
Message-ID: <5410b6ed.bkpG7sVhboL23WBm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaIJUjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 16:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zyw@rock-chips.com, a.zummo@towertech.it, dianders@chromium.org, dtor@chromium.org, heiko@sntech.de, ijc+devicetree@hellion.org.uk, javier.martinez@collabora.co.uk, kever.yang@rock-chips.com, mark.rutland@arm.com, olof@lixom.net, pawel.moll@arm.com, rmk@arm.linux.org.uk, sameo@linux.intel.com, zhong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: clk: RK808: add clkout driver for RK808
has been added to the -mm tree.  Its filename is
     clk-rk808-add-clkout-driver-for-rk808.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/clk-rk808-add-clkout-driver-for-rk808.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/clk-rk808-add-clkout-driver-for-rk808.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Zhong <zyw@rock-chips.com>
Subject: clk: RK808: add clkout driver for RK808

This is the initial version of the RK808 PMIC.  This is a power management
IC for multimedia products.  It provides regulators that are able to
supply power to processor cores and other components.  The chip provides
other modules including RTC, Clockout.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com> says:
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Olof Johansson <olof@lixom.net>
Cc: Dmitry Torokhov <dtor@chromium.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kever Yang <kever.yang@rock-chips.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clk/Kconfig     |    9 ++
 drivers/clk/Makefile    |    1 
 drivers/clk/clk-rk808.c |  170 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 180 insertions(+)

diff -puN drivers/clk/Kconfig~clk-rk808-add-clkout-driver-for-rk808 drivers/clk/Kconfig
--- a/drivers/clk/Kconfig~clk-rk808-add-clkout-driver-for-rk808
+++ a/drivers/clk/Kconfig
@@ -38,6 +38,15 @@ config COMMON_CLK_MAX77686
 	---help---
 	  This driver supports Maxim 77686 crystal oscillator clock. 
 
+config COMMON_CLK_RK808
+	tristate "Clock driver for RK808"
+	depends on MFD_RK808
+	---help---
+	  This driver supports RK808 crystal oscillator clock. These
+	  multi-function devices have two fixed-rate oscillators,
+	  clocked at 32KHz each. Clkout1 is always on, Clkout2 can off
+	  by control register.
+
 config COMMON_CLK_SI5351
 	tristate "Clock driver for SiLabs 5351A/B/C"
 	depends on I2C
diff -puN drivers/clk/Makefile~clk-rk808-add-clkout-driver-for-rk808 drivers/clk/Makefile
--- a/drivers/clk/Makefile~clk-rk808-add-clkout-driver-for-rk808
+++ a/drivers/clk/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_ARCH_NOMADIK)		+= clk-nomad
 obj-$(CONFIG_ARCH_NSPIRE)		+= clk-nspire.o
 obj-$(CONFIG_COMMON_CLK_PALMAS)		+= clk-palmas.o
 obj-$(CONFIG_CLK_PPC_CORENET)		+= clk-ppc-corenet.o
+obj-$(CONFIG_COMMON_CLK_RK808)		+= clk-rk808.o
 obj-$(CONFIG_COMMON_CLK_S2MPS11)	+= clk-s2mps11.o
 obj-$(CONFIG_COMMON_CLK_SI5351)		+= clk-si5351.o
 obj-$(CONFIG_COMMON_CLK_SI570)		+= clk-si570.o
diff -puN /dev/null drivers/clk/clk-rk808.c
--- /dev/null
+++ a/drivers/clk/clk-rk808.c
@@ -0,0 +1,170 @@
+/*
+ * Clkout driver for Rockchip RK808
+ *
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * Author:Chris Zhong <zyw@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/rk808.h>
+#include <linux/i2c.h>
+
+#define RK808_NR_OUTPUT 2
+
+struct rk808_clkout {
+	struct rk808 *rk808;
+	struct clk_onecell_data clk_data;
+	struct clk_hw		clkout1_hw;
+	struct clk_hw		clkout2_hw;
+};
+
+static unsigned long rk808_clkout_recalc_rate(struct clk_hw *hw,
+					      unsigned long parent_rate)
+{
+	return 32768;
+}
+
+static int rk808_clkout2_enable(struct clk_hw *hw, bool enable)
+{
+	struct rk808_clkout *rk808_clkout = container_of(hw,
+							 struct rk808_clkout,
+							 clkout2_hw);
+	struct rk808 *rk808 = rk808_clkout->rk808;
+
+	return regmap_update_bits(rk808->regmap, RK808_CLK32OUT_REG,
+				  CLK32KOUT2_EN, enable ? CLK32KOUT2_EN : 0);
+}
+
+static int rk808_clkout2_prepare(struct clk_hw *hw)
+{
+	return rk808_clkout2_enable(hw, true);
+}
+
+static void rk808_clkout2_unprepare(struct clk_hw *hw)
+{
+	rk808_clkout2_enable(hw, false);
+}
+
+static int rk808_clkout2_is_prepared(struct clk_hw *hw)
+{
+	struct rk808_clkout *rk808_clkout = container_of(hw,
+							 struct rk808_clkout,
+							 clkout2_hw);
+	struct rk808 *rk808 = rk808_clkout->rk808;
+	uint32_t val;
+
+	int ret = regmap_read(rk808->regmap, RK808_CLK32OUT_REG, &val);
+
+	if (ret < 0)
+		return ret;
+
+	return (val & CLK32KOUT2_EN) ? 1 : 0;
+}
+
+static const struct clk_ops rk808_clkout1_ops = {
+	.recalc_rate = rk808_clkout_recalc_rate,
+};
+
+static const struct clk_ops rk808_clkout2_ops = {
+	.prepare = rk808_clkout2_prepare,
+	.unprepare = rk808_clkout2_unprepare,
+	.is_prepared = rk808_clkout2_is_prepared,
+	.recalc_rate = rk808_clkout_recalc_rate,
+};
+
+static int rk808_clkout_probe(struct platform_device *pdev)
+{
+	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
+	struct i2c_client *client = rk808->i2c;
+	struct device_node *node = client->dev.of_node;
+	struct clk_init_data init = {};
+	struct clk **clk_table;
+	struct rk808_clkout *rk808_clkout;
+
+	rk808_clkout = devm_kzalloc(&client->dev,
+				    sizeof(*rk808_clkout), GFP_KERNEL);
+	if (!rk808_clkout)
+		return -ENOMEM;
+
+	rk808_clkout->rk808 = rk808;
+
+	clk_table = devm_kcalloc(&client->dev, RK808_NR_OUTPUT,
+				 sizeof(struct clk *), GFP_KERNEL);
+	if (!clk_table)
+		return -ENOMEM;
+
+	init.flags = CLK_IS_ROOT;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	init.name = "rk808-clkout1";
+	init.ops = &rk808_clkout1_ops;
+	rk808_clkout->clkout1_hw.init = &init;
+
+	/* optional override of the clockname */
+	of_property_read_string_index(node, "clock-output-names",
+				      0, &init.name);
+
+	clk_table[0] = devm_clk_register(&client->dev,
+					 &rk808_clkout->clkout1_hw);
+	if (IS_ERR(clk_table[0]))
+		return PTR_ERR(clk_table[0]);
+
+	init.name = "rk808-clkout2";
+	init.ops = &rk808_clkout2_ops;
+	rk808_clkout->clkout2_hw.init = &init;
+
+	/* optional override of the clockname */
+	of_property_read_string_index(node, "clock-output-names",
+				      1, &init.name);
+
+	clk_table[1] = devm_clk_register(&client->dev,
+					 &rk808_clkout->clkout2_hw);
+	if (IS_ERR(clk_table[1]))
+		return PTR_ERR(clk_table[1]);
+
+	rk808_clkout->clk_data.clks = clk_table;
+	rk808_clkout->clk_data.clk_num = RK808_NR_OUTPUT;
+
+	return of_clk_add_provider(node, of_clk_src_onecell_get,
+				   &rk808_clkout->clk_data);
+}
+
+static int rk808_clkout_remove(struct platform_device *pdev)
+{
+	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
+	struct i2c_client *client = rk808->i2c;
+	struct device_node *node = client->dev.of_node;
+
+	of_clk_del_provider(node);
+
+	return 0;
+}
+
+static struct platform_driver rk808_clkout_driver = {
+	.probe = rk808_clkout_probe,
+	.remove = rk808_clkout_remove,
+	.driver		= {
+		.name	= "rk808-clkout",
+	},
+};
+
+module_platform_driver(rk808_clkout_driver);
+
+MODULE_DESCRIPTION("Clkout driver for the rk808 series PMICs");
+MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rk808-clkout");
_

Patches currently in -mm which might be from zyw@rock-chips.com are

rtc-rk808-add-rtc-driver-for-rk808.patch
clk-rk808-add-clkout-driver-for-rk808.patch
linux-next.patch

