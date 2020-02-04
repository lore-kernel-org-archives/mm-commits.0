From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 66/67] treewide: remove redundant IS_ERR() before
 error code check
Date: Mon, 03 Feb 2020 17:37:45 -0800
Message-ID: <20200204013745.FN1IdJS0E%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBhr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:37:47 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bgolaszewski@baylibre.com, ebiggers@kernel.org, julia.lawall@lip6.fr, linux-mm@kvack.org, masahiroy@kernel.org, mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com, robh@kernel.org, sboyd@kernel.org, torvalds@linux-foundation.org, wsa@the-dreams.de

From: Masahiro Yamada <masahiroy@kernel.org>
Subject: treewide: remove redundant IS_ERR() before error code check

'PTR_ERR(p) == -E*' is a stronger condition than IS_ERR(p).
Hence, IS_ERR(p) is unneeded.

The semantic patch that generates this commit is as follows:

// <smpl>
@@
expression ptr;
constant error_code;
@@
-IS_ERR(ptr) && (PTR_ERR(ptr) == - error_code)
+PTR_ERR(ptr) == - error_code
// </smpl>

Link: http://lkml.kernel.org/r/20200106045833.1725-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Acked-by: Stephen Boyd <sboyd@kernel.org> [drivers/clk/clk.c]
Acked-by: Bartosz Golaszewski <bgolaszewski@baylibre.com> [GPIO]
Acked-by: Wolfram Sang <wsa@the-dreams.de> [drivers/i2c]
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com> [acpi/scan.c]
Acked-by: Rob Herring <robh@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/af_alg.c                      |    2 +-
 drivers/acpi/scan.c                  |    2 +-
 drivers/char/hw_random/bcm2835-rng.c |    2 +-
 drivers/char/hw_random/omap-rng.c    |    4 ++--
 drivers/clk/clk.c                    |    2 +-
 drivers/dma/mv_xor_v2.c              |    2 +-
 drivers/gpio/gpiolib-devres.c        |    2 +-
 drivers/gpio/gpiolib-of.c            |    8 ++++----
 drivers/gpio/gpiolib.c               |    2 +-
 drivers/i2c/busses/i2c-mv64xxx.c     |    5 ++---
 drivers/i2c/busses/i2c-synquacer.c   |    2 +-
 drivers/mtd/ubi/build.c              |    2 +-
 drivers/of/device.c                  |    2 +-
 drivers/pci/controller/pci-tegra.c   |    2 +-
 drivers/phy/phy-core.c               |    4 ++--
 drivers/spi/spi-orion.c              |    3 +--
 drivers/video/fbdev/imxfb.c          |    2 +-
 fs/ext4/super.c                      |    2 +-
 fs/f2fs/node.c                       |    2 +-
 fs/ocfs2/suballoc.c                  |    2 +-
 fs/sysfs/group.c                     |    2 +-
 net/core/dev.c                       |    2 +-
 net/core/filter.c                    |    2 +-
 net/xfrm/xfrm_policy.c               |    2 +-
 sound/soc/codecs/ak4104.c            |    3 +--
 sound/soc/codecs/cs4270.c            |    3 +--
 sound/soc/codecs/tlv320aic32x4.c     |    6 ++----
 sound/soc/sunxi/sun4i-spdif.c        |    2 +-
 28 files changed, 35 insertions(+), 41 deletions(-)

--- a/crypto/af_alg.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/crypto/af_alg.c
@@ -171,7 +171,7 @@ static int alg_bind(struct socket *sock,
 	sa->salg_name[sizeof(sa->salg_name) + addr_len - sizeof(*sa) - 1] = 0;
 
 	type = alg_get_type(sa->salg_type);
-	if (IS_ERR(type) && PTR_ERR(type) == -ENOENT) {
+	if (PTR_ERR(type) == -ENOENT) {
 		request_module("algif-%s", sa->salg_type);
 		type = alg_get_type(sa->salg_type);
 	}
--- a/drivers/acpi/scan.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/acpi/scan.c
@@ -1462,7 +1462,7 @@ int acpi_dma_configure(struct device *de
 	iort_dma_setup(dev, &dma_addr, &size);
 
 	iommu = iort_iommu_configure(dev);
-	if (IS_ERR(iommu) && PTR_ERR(iommu) == -EPROBE_DEFER)
+	if (PTR_ERR(iommu) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
 	arch_setup_dma_ops(dev, dma_addr, size,
--- a/drivers/char/hw_random/bcm2835-rng.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/char/hw_random/bcm2835-rng.c
@@ -157,7 +157,7 @@ static int bcm2835_rng_probe(struct plat
 
 	/* Clock is optional on most platforms */
 	priv->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
 	priv->rng.name = pdev->name;
--- a/drivers/char/hw_random/omap-rng.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/char/hw_random/omap-rng.c
@@ -476,7 +476,7 @@ static int omap_rng_probe(struct platfor
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 	if (!IS_ERR(priv->clk)) {
 		ret = clk_prepare_enable(priv->clk);
@@ -488,7 +488,7 @@ static int omap_rng_probe(struct platfor
 	}
 
 	priv->clk_reg = devm_clk_get(&pdev->dev, "reg");
-	if (IS_ERR(priv->clk_reg) && PTR_ERR(priv->clk_reg) == -EPROBE_DEFER)
+	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 	if (!IS_ERR(priv->clk_reg)) {
 		ret = clk_prepare_enable(priv->clk_reg);
--- a/drivers/clk/clk.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/clk/clk.c
@@ -429,7 +429,7 @@ static void clk_core_fill_parent_index(s
 			parent = ERR_PTR(-EPROBE_DEFER);
 	} else {
 		parent = clk_core_get(core, index);
-		if (IS_ERR(parent) && PTR_ERR(parent) == -ENOENT && entry->name)
+		if (PTR_ERR(parent) == -ENOENT && entry->name)
 			parent = clk_core_lookup(entry->name);
 	}
 
--- a/drivers/dma/mv_xor_v2.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/dma/mv_xor_v2.c
@@ -750,7 +750,7 @@ static int mv_xor_v2_probe(struct platfo
 	}
 
 	xor_dev->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(xor_dev->clk) && PTR_ERR(xor_dev->clk) == -EPROBE_DEFER) {
+	if (PTR_ERR(xor_dev->clk) == -EPROBE_DEFER) {
 		ret = EPROBE_DEFER;
 		goto disable_reg_clk;
 	}
--- a/drivers/gpio/gpiolib.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/gpio/gpiolib.c
@@ -5039,7 +5039,7 @@ struct gpio_descs *__must_check gpiod_ge
 	struct gpio_descs *descs;
 
 	descs = gpiod_get_array(dev, con_id, flags);
-	if (IS_ERR(descs) && (PTR_ERR(descs) == -ENOENT))
+	if (PTR_ERR(descs) == -ENOENT)
 		return NULL;
 
 	return descs;
--- a/drivers/gpio/gpiolib-devres.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/gpio/gpiolib-devres.c
@@ -308,7 +308,7 @@ devm_gpiod_get_array_optional(struct dev
 	struct gpio_descs *descs;
 
 	descs = devm_gpiod_get_array(dev, con_id, flags);
-	if (IS_ERR(descs) && (PTR_ERR(descs) == -ENOENT))
+	if (PTR_ERR(descs) == -ENOENT)
 		return NULL;
 
 	return descs;
--- a/drivers/gpio/gpiolib-of.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/gpio/gpiolib-of.c
@@ -484,24 +484,24 @@ struct gpio_desc *of_find_gpio(struct de
 			break;
 	}
 
-	if (IS_ERR(desc) && PTR_ERR(desc) == -ENOENT) {
+	if (PTR_ERR(desc) == -ENOENT) {
 		/* Special handling for SPI GPIOs if used */
 		desc = of_find_spi_gpio(dev, con_id, &of_flags);
 	}
 
-	if (IS_ERR(desc) && PTR_ERR(desc) == -ENOENT) {
+	if (PTR_ERR(desc) == -ENOENT) {
 		/* This quirk looks up flags and all */
 		desc = of_find_spi_cs_gpio(dev, con_id, idx, flags);
 		if (!IS_ERR(desc))
 			return desc;
 	}
 
-	if (IS_ERR(desc) && PTR_ERR(desc) == -ENOENT) {
+	if (PTR_ERR(desc) == -ENOENT) {
 		/* Special handling for regulator GPIOs if used */
 		desc = of_find_regulator_gpio(dev, con_id, &of_flags);
 	}
 
-	if (IS_ERR(desc) && PTR_ERR(desc) == -ENOENT)
+	if (PTR_ERR(desc) == -ENOENT)
 		desc = of_find_arizona_gpio(dev, con_id, &of_flags);
 
 	if (IS_ERR(desc))
--- a/drivers/i2c/busses/i2c-mv64xxx.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/i2c/busses/i2c-mv64xxx.c
@@ -901,14 +901,13 @@ mv64xxx_i2c_probe(struct platform_device
 
 	/* Not all platforms have clocks */
 	drv_data->clk = devm_clk_get(&pd->dev, NULL);
-	if (IS_ERR(drv_data->clk) && PTR_ERR(drv_data->clk) == -EPROBE_DEFER)
+	if (PTR_ERR(drv_data->clk) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 	if (!IS_ERR(drv_data->clk))
 		clk_prepare_enable(drv_data->clk);
 
 	drv_data->reg_clk = devm_clk_get(&pd->dev, "reg");
-	if (IS_ERR(drv_data->reg_clk) &&
-	    PTR_ERR(drv_data->reg_clk) == -EPROBE_DEFER)
+	if (PTR_ERR(drv_data->reg_clk) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 	if (!IS_ERR(drv_data->reg_clk))
 		clk_prepare_enable(drv_data->reg_clk);
--- a/drivers/i2c/busses/i2c-synquacer.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/i2c/busses/i2c-synquacer.c
@@ -553,7 +553,7 @@ static int synquacer_i2c_probe(struct pl
 				 &i2c->pclkrate);
 
 	i2c->pclk = devm_clk_get(&pdev->dev, "pclk");
-	if (IS_ERR(i2c->pclk) && PTR_ERR(i2c->pclk) == -EPROBE_DEFER)
+	if (PTR_ERR(i2c->pclk) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 	if (!IS_ERR_OR_NULL(i2c->pclk)) {
 		dev_dbg(&pdev->dev, "clock source %p\n", i2c->pclk);
--- a/drivers/mtd/ubi/build.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/mtd/ubi/build.c
@@ -1180,7 +1180,7 @@ static struct mtd_info * __init open_mtd
 		 * MTD device name.
 		 */
 		mtd = get_mtd_device_nm(mtd_dev);
-		if (IS_ERR(mtd) && PTR_ERR(mtd) == -ENODEV)
+		if (PTR_ERR(mtd) == -ENODEV)
 			/* Probably this is an MTD character device node path */
 			mtd = open_mtd_by_chdev(mtd_dev);
 	} else
--- a/drivers/of/device.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/of/device.c
@@ -161,7 +161,7 @@ int of_dma_configure(struct device *dev,
 		coherent ? " " : " not ");
 
 	iommu = of_iommu_configure(dev, np);
-	if (IS_ERR(iommu) && PTR_ERR(iommu) == -EPROBE_DEFER)
+	if (PTR_ERR(iommu) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
 	dev_dbg(dev, "device is%sbehind an iommu\n",
--- a/drivers/pci/controller/pci-tegra.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/pci/controller/pci-tegra.c
@@ -1406,7 +1406,7 @@ static struct phy *devm_of_phy_optional_
 	phy = devm_of_phy_get(dev, np, name);
 	kfree(name);
 
-	if (IS_ERR(phy) && PTR_ERR(phy) == -ENODEV)
+	if (PTR_ERR(phy) == -ENODEV)
 		phy = NULL;
 
 	return phy;
--- a/drivers/phy/phy-core.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/phy/phy-core.c
@@ -712,7 +712,7 @@ struct phy *phy_optional_get(struct devi
 {
 	struct phy *phy = phy_get(dev, string);
 
-	if (IS_ERR(phy) && (PTR_ERR(phy) == -ENODEV))
+	if (PTR_ERR(phy) == -ENODEV)
 		phy = NULL;
 
 	return phy;
@@ -766,7 +766,7 @@ struct phy *devm_phy_optional_get(struct
 {
 	struct phy *phy = devm_phy_get(dev, string);
 
-	if (IS_ERR(phy) && (PTR_ERR(phy) == -ENODEV))
+	if (PTR_ERR(phy) == -ENODEV)
 		phy = NULL;
 
 	return phy;
--- a/drivers/spi/spi-orion.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/spi/spi-orion.c
@@ -646,8 +646,7 @@ static int orion_spi_probe(struct platfo
 
 	/* The following clock is only used by some SoCs */
 	spi->axi_clk = devm_clk_get(&pdev->dev, "axi");
-	if (IS_ERR(spi->axi_clk) &&
-	    PTR_ERR(spi->axi_clk) == -EPROBE_DEFER) {
+	if (PTR_ERR(spi->axi_clk) == -EPROBE_DEFER) {
 		status = -EPROBE_DEFER;
 		goto out_rel_clk;
 	}
--- a/drivers/video/fbdev/imxfb.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/drivers/video/fbdev/imxfb.c
@@ -1017,7 +1017,7 @@ static int imxfb_probe(struct platform_d
 	}
 
 	fbi->lcd_pwr = devm_regulator_get(&pdev->dev, "lcd");
-	if (IS_ERR(fbi->lcd_pwr) && (PTR_ERR(fbi->lcd_pwr) == -EPROBE_DEFER)) {
+	if (PTR_ERR(fbi->lcd_pwr) == -EPROBE_DEFER) {
 		ret = -EPROBE_DEFER;
 		goto failed_lcd;
 	}
--- a/fs/ext4/super.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/fs/ext4/super.c
@@ -6043,7 +6043,7 @@ static ssize_t ext4_quota_write(struct s
 		bh = ext4_bread(handle, inode, blk,
 				EXT4_GET_BLOCKS_CREATE |
 				EXT4_GET_BLOCKS_METADATA_NOFAIL);
-	} while (IS_ERR(bh) && (PTR_ERR(bh) == -ENOSPC) &&
+	} while (PTR_ERR(bh) == -ENOSPC &&
 		 ext4_should_retry_alloc(inode->i_sb, &retries));
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
--- a/fs/f2fs/node.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/fs/f2fs/node.c
@@ -875,7 +875,7 @@ static int truncate_dnode(struct dnode_o
 
 	/* get direct node */
 	page = f2fs_get_node_page(F2FS_I_SB(dn->inode), dn->nid);
-	if (IS_ERR(page) && PTR_ERR(page) == -ENOENT)
+	if (PTR_ERR(page) == -ENOENT)
 		return 1;
 	else if (IS_ERR(page))
 		return PTR_ERR(page);
--- a/fs/ocfs2/suballoc.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/fs/ocfs2/suballoc.c
@@ -696,7 +696,7 @@ static int ocfs2_block_group_alloc(struc
 
 	bg_bh = ocfs2_block_group_alloc_contig(osb, handle, alloc_inode,
 					       ac, cl);
-	if (IS_ERR(bg_bh) && (PTR_ERR(bg_bh) == -ENOSPC))
+	if (PTR_ERR(bg_bh) == -ENOSPC)
 		bg_bh = ocfs2_block_group_alloc_discontig(handle,
 							  alloc_inode,
 							  ac, cl);
--- a/fs/sysfs/group.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/fs/sysfs/group.c
@@ -449,7 +449,7 @@ int __compat_only_sysfs_link_entry_to_ko
 	}
 
 	link = kernfs_create_link(kobj->sd, target_name, entry);
-	if (IS_ERR(link) && PTR_ERR(link) == -EEXIST)
+	if (PTR_ERR(link) == -EEXIST)
 		sysfs_warn_dup(kobj->sd, target_name);
 
 	kernfs_put(entry);
--- a/net/core/dev.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/net/core/dev.c
@@ -5792,7 +5792,7 @@ static enum gro_result dev_gro_receive(s
 	if (&ptype->list == head)
 		goto normal;
 
-	if (IS_ERR(pp) && PTR_ERR(pp) == -EINPROGRESS) {
+	if (PTR_ERR(pp) == -EINPROGRESS) {
 		ret = GRO_CONSUMED;
 		goto ok;
 	}
--- a/net/core/filter.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/net/core/filter.c
@@ -1573,7 +1573,7 @@ int sk_reuseport_attach_bpf(u32 ufd, str
 		return -EPERM;
 
 	prog = bpf_prog_get_type(ufd, BPF_PROG_TYPE_SOCKET_FILTER);
-	if (IS_ERR(prog) && PTR_ERR(prog) == -EINVAL)
+	if (PTR_ERR(prog) == -EINVAL)
 		prog = bpf_prog_get_type(ufd, BPF_PROG_TYPE_SK_REUSEPORT);
 	if (IS_ERR(prog))
 		return PTR_ERR(prog);
--- a/net/xfrm/xfrm_policy.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/net/xfrm/xfrm_policy.c
@@ -3189,7 +3189,7 @@ struct dst_entry *xfrm_lookup_route(stru
 					    flags | XFRM_LOOKUP_QUEUE |
 					    XFRM_LOOKUP_KEEP_DST_REF);
 
-	if (IS_ERR(dst) && PTR_ERR(dst) == -EREMOTE)
+	if (PTR_ERR(dst) == -EREMOTE)
 		return make_blackhole(net, dst_orig->ops->family, dst_orig);
 
 	if (IS_ERR(dst))
--- a/sound/soc/codecs/ak4104.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/sound/soc/codecs/ak4104.c
@@ -295,8 +295,7 @@ static int ak4104_spi_probe(struct spi_d
 
 	reset_gpiod = devm_gpiod_get_optional(&spi->dev, "reset",
 					      GPIOD_OUT_HIGH);
-	if (IS_ERR(reset_gpiod) &&
-	    PTR_ERR(reset_gpiod) == -EPROBE_DEFER)
+	if (PTR_ERR(reset_gpiod) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
 	/* read the 'reserved' register - according to the datasheet, it
--- a/sound/soc/codecs/cs4270.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/sound/soc/codecs/cs4270.c
@@ -681,8 +681,7 @@ static int cs4270_i2c_probe(struct i2c_c
 
 	reset_gpiod = devm_gpiod_get_optional(&i2c_client->dev, "reset",
 					      GPIOD_OUT_HIGH);
-	if (IS_ERR(reset_gpiod) &&
-	    PTR_ERR(reset_gpiod) == -EPROBE_DEFER)
+	if (PTR_ERR(reset_gpiod) == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
 	cs4270->regmap = devm_regmap_init_i2c(i2c_client, &cs4270_regmap);
--- a/sound/soc/codecs/tlv320aic32x4.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/sound/soc/codecs/tlv320aic32x4.c
@@ -1098,11 +1098,9 @@ static int aic32x4_setup_regulators(stru
 			return PTR_ERR(aic32x4->supply_av);
 		}
 	} else {
-		if (IS_ERR(aic32x4->supply_dv) &&
-				PTR_ERR(aic32x4->supply_dv) == -EPROBE_DEFER)
+		if (PTR_ERR(aic32x4->supply_dv) == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
-		if (IS_ERR(aic32x4->supply_av) &&
-				PTR_ERR(aic32x4->supply_av) == -EPROBE_DEFER)
+		if (PTR_ERR(aic32x4->supply_av) == -EPROBE_DEFER)
 			return -EPROBE_DEFER;
 	}
 
--- a/sound/soc/sunxi/sun4i-spdif.c~treewide-remove-redundent-is_err-before-error-code-check
+++ a/sound/soc/sunxi/sun4i-spdif.c
@@ -555,7 +555,7 @@ static int sun4i_spdif_probe(struct plat
 	if (quirks->has_reset) {
 		host->rst = devm_reset_control_get_optional_exclusive(&pdev->dev,
 								      NULL);
-		if (IS_ERR(host->rst) && PTR_ERR(host->rst) == -EPROBE_DEFER) {
+		if (PTR_ERR(host->rst) == -EPROBE_DEFER) {
 			ret = -EPROBE_DEFER;
 			dev_err(&pdev->dev, "Failed to get reset: %d\n", ret);
 			return ret;
_
