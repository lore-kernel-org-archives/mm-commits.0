From: akpm@linux-foundation.org
Subject: [merged] remove-lots-of-is_err_value-abuses.patch removed from
 -mm tree
Date: Tue, 31 May 2016 10:50:49 -0700
Message-ID: <574dcef9.6Kt1ySGIMjJmrKcK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbcEaRuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, a.hajda@samsung.com, adrian.hunter@intel.com, airlied@linux.ie, linux@armlinux.org.uk, maxime.ripard@free-electrons.com, rjw@rjwysocki.net, robin.murphy@arm.com, rpeterso@redhat.com, srinivas.kandagatla@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: remove lots of IS_ERR_VALUE abuses
has been removed from the -mm tree.  Its filename was
     remove-lots-of-is_err_value-abuses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: remove lots of IS_ERR_VALUE abuses

Most users of IS_ERR_VALUE() in the kernel are wrong, as they
pass an 'int' into a function that takes an 'unsigned long'
argument. This happens to work because the type is sign-extended
on 64-bit architectures before it gets converted into an
unsigned type.

However, anything that passes an 'unsigned short' or 'unsigned int'
argument into IS_ERR_VALUE() is guaranteed to be broken, as are
8-bit integers and types that are wider than 'unsigned long'.

Andrzej Hajda has already fixed a lot of the worst abusers that
were causing actual bugs, but it would be nice to prevent any
users that are not passing 'unsigned long' arguments.

This patch changes all users of IS_ERR_VALUE() that I could find
on 32-bit ARM randconfig builds and x86 allmodconfig. For the
moment, this doesn't change the definition of IS_ERR_VALUE()
because there are probably still architecture specific users
elsewhere.

Almost all the warnings I got are for files that are better off
using 'if (err)' or 'if (err < 0)'.
The only legitimate user I could find that we get a warning for
is the (32-bit only) freescale fman driver, so I did not remove
the IS_ERR_VALUE() there but changed the type to 'unsigned long'.
For 9pfs, I just worked around one user whose calling conventions
are so obscure that I did not dare change the behavior.

I was using this definition for testing:

 #define IS_ERR_VALUE(x) ((unsigned long*)NULL == (typeof (x)*)NULL &&        unlikely((unsigned long long)(x) >= (unsigned long long)(typeof(x))-MAX_ERRNO))

which ends up making all 16-bit or wider types work correctly with
the most plausible interpretation of what IS_ERR_VALUE() was supposed
to return according to its users, but also causes a compile-time
warning for any users that do not pass an 'unsigned long' argument.

I suggested this approach earlier this year, but back then we ended
up deciding to just fix the users that are obviously broken. After
the initial warning that caused me to get involved in the discussion
(fs/gfs2/dir.c) showed up again in the mainline kernel, Linus
asked me to send the whole thing again.

Link: http://lkml.kernel.org/r/1464384685-347275-1-git-send-email-arnd@arndb.de
Link: https://lkml.org/lkml/2016/1/7/363
Link: https://lkml.org/lkml/2016/5/27/486
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>	[nvmem]
Cc: Russell King <linux@armlinux.org.uk>
Cc: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_dbg.c                          |   22 ++++++-------
 drivers/ata/sata_highbank.c                      |    2 -
 drivers/clk/tegra/clk-tegra210.c                 |    2 -
 drivers/cpufreq/omap-cpufreq.c                   |    2 -
 drivers/crypto/caam/ctrl.c                       |    2 -
 drivers/dma/sun4i-dma.c                          |   16 ++++-----
 drivers/gpio/gpio-xlp.c                          |    2 -
 drivers/gpu/drm/sti/sti_vtg.c                    |    4 +-
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c           |    2 -
 drivers/gpu/host1x/hw/intr_hw.c                  |    2 -
 drivers/iommu/arm-smmu-v3.c                      |   18 +++++-----
 drivers/iommu/arm-smmu.c                         |    8 ++--
 drivers/irqchip/irq-clps711x.c                   |    2 -
 drivers/irqchip/irq-gic.c                        |    2 -
 drivers/irqchip/irq-hip04.c                      |    2 -
 drivers/irqchip/spear-shirq.c                    |    2 -
 drivers/media/i2c/adp1653.c                      |   10 ++---
 drivers/media/platform/s5p-tv/mixer_drv.c        |    2 -
 drivers/mfd/twl4030-irq.c                        |    2 -
 drivers/mmc/core/mmc.c                           |    4 +-
 drivers/mmc/host/dw_mmc.c                        |    6 +--
 drivers/mmc/host/sdhci-esdhc-imx.c               |    2 -
 drivers/mmc/host/sdhci-of-at91.c                 |    2 -
 drivers/mmc/host/sdhci.c                         |    4 +-
 drivers/net/ethernet/freescale/fman/fman.c       |    2 -
 drivers/net/ethernet/freescale/fman/fman_muram.c |    4 +-
 drivers/net/ethernet/freescale/fman/fman_muram.h |    4 +-
 drivers/net/wireless/ti/wlcore/spi.c             |    4 +-
 drivers/nvmem/core.c                             |   22 ++++++-------
 drivers/tty/serial/amba-pl011.c                  |    2 -
 drivers/tty/serial/sprd_serial.c                 |    2 -
 drivers/video/fbdev/da8xx-fb.c                   |    4 +-
 fs/afs/write.c                                   |    4 --
 fs/binfmt_flat.c                                 |    6 +--
 fs/gfs2/dir.c                                    |   15 +++++---
 kernel/pid.c                                     |    2 -
 net/9p/client.c                                  |    4 +-
 sound/soc/qcom/lpass-platform.c                  |    4 +-
 38 files changed, 100 insertions(+), 101 deletions(-)

diff -puN drivers/acpi/acpi_dbg.c~remove-lots-of-is_err_value-abuses drivers/acpi/acpi_dbg.c
--- a/drivers/acpi/acpi_dbg.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/acpi/acpi_dbg.c
@@ -265,7 +265,7 @@ static int acpi_aml_write_kern(const cha
 	char *p;
 
 	ret = acpi_aml_lock_write(crc, ACPI_AML_OUT_KERN);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		return ret;
 	/* sync tail before inserting logs */
 	smp_mb();
@@ -286,7 +286,7 @@ static int acpi_aml_readb_kern(void)
 	char *p;
 
 	ret = acpi_aml_lock_read(crc, ACPI_AML_IN_KERN);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		return ret;
 	/* sync head before removing cmds */
 	smp_rmb();
@@ -330,7 +330,7 @@ again:
 				goto again;
 			break;
 		}
-		if (IS_ERR_VALUE(ret))
+		if (ret < 0)
 			break;
 		size += ret;
 		count -= ret;
@@ -373,7 +373,7 @@ again:
 			if (ret == 0)
 				goto again;
 		}
-		if (IS_ERR_VALUE(ret))
+		if (ret < 0)
 			break;
 		*(msg + size) = (char)ret;
 		size++;
@@ -526,7 +526,7 @@ static int acpi_aml_open(struct inode *i
 	}
 	acpi_aml_io.users++;
 err_lock:
-	if (IS_ERR_VALUE(ret)) {
+	if (ret < 0) {
 		if (acpi_aml_active_reader == file)
 			acpi_aml_active_reader = NULL;
 	}
@@ -587,7 +587,7 @@ static int acpi_aml_read_user(char __use
 	char *p;
 
 	ret = acpi_aml_lock_read(crc, ACPI_AML_OUT_USER);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		return ret;
 	/* sync head before removing logs */
 	smp_rmb();
@@ -602,7 +602,7 @@ static int acpi_aml_read_user(char __use
 	crc->tail = (crc->tail + n) & (ACPI_AML_BUF_SIZE - 1);
 	ret = n;
 out:
-	acpi_aml_unlock_fifo(ACPI_AML_OUT_USER, !IS_ERR_VALUE(ret));
+	acpi_aml_unlock_fifo(ACPI_AML_OUT_USER, !ret);
 	return ret;
 }
 
@@ -634,7 +634,7 @@ again:
 					goto again;
 			}
 		}
-		if (IS_ERR_VALUE(ret)) {
+		if (ret < 0) {
 			if (!acpi_aml_running())
 				ret = 0;
 			break;
@@ -657,7 +657,7 @@ static int acpi_aml_write_user(const cha
 	char *p;
 
 	ret = acpi_aml_lock_write(crc, ACPI_AML_IN_USER);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		return ret;
 	/* sync tail before inserting cmds */
 	smp_mb();
@@ -672,7 +672,7 @@ static int acpi_aml_write_user(const cha
 	crc->head = (crc->head + n) & (ACPI_AML_BUF_SIZE - 1);
 	ret = n;
 out:
-	acpi_aml_unlock_fifo(ACPI_AML_IN_USER, !IS_ERR_VALUE(ret));
+	acpi_aml_unlock_fifo(ACPI_AML_IN_USER, !ret);
 	return n;
 }
 
@@ -704,7 +704,7 @@ again:
 					goto again;
 			}
 		}
-		if (IS_ERR_VALUE(ret)) {
+		if (ret < 0) {
 			if (!acpi_aml_running())
 				ret = 0;
 			break;
diff -puN drivers/ata/sata_highbank.c~remove-lots-of-is_err_value-abuses drivers/ata/sata_highbank.c
--- a/drivers/ata/sata_highbank.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/ata/sata_highbank.c
@@ -197,7 +197,7 @@ static void highbank_set_em_messages(str
 
 	for (i = 0; i < SGPIO_PINS; i++) {
 		err = of_get_named_gpio(np, "calxeda,sgpio-gpio", i);
-		if (IS_ERR_VALUE(err))
+		if (err < 0)
 			return;
 
 		pdata->sgpio_gpio[i] = err;
diff -puN drivers/clk/tegra/clk-tegra210.c~remove-lots-of-is_err_value-abuses drivers/clk/tegra/clk-tegra210.c
--- a/drivers/clk/tegra/clk-tegra210.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/clk/tegra/clk-tegra210.c
@@ -1221,7 +1221,7 @@ static int tegra210_pll_fixed_mdiv_cfg(s
 		p = rate >= params->vco_min ? 1 : -EINVAL;
 	}
 
-	if (IS_ERR_VALUE(p))
+	if (p < 0)
 		return -EINVAL;
 
 	cfg->m = tegra_pll_get_fixed_mdiv(hw, input_rate);
diff -puN drivers/cpufreq/omap-cpufreq.c~remove-lots-of-is_err_value-abuses drivers/cpufreq/omap-cpufreq.c
--- a/drivers/cpufreq/omap-cpufreq.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/cpufreq/omap-cpufreq.c
@@ -54,7 +54,7 @@ static int omap_target(struct cpufreq_po
 
 	freq = new_freq * 1000;
 	ret = clk_round_rate(policy->clk, freq);
-	if (IS_ERR_VALUE(ret)) {
+	if (ret < 0) {
 		dev_warn(mpu_dev,
 			 "CPUfreq: Cannot find matching frequency for %lu\n",
 			 freq);
diff -puN drivers/crypto/caam/ctrl.c~remove-lots-of-is_err_value-abuses drivers/crypto/caam/ctrl.c
--- a/drivers/crypto/caam/ctrl.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/crypto/caam/ctrl.c
@@ -402,7 +402,7 @@ int caam_get_era(void)
 	ret = of_property_read_u32(caam_node, "fsl,sec-era", &prop);
 	of_node_put(caam_node);
 
-	return IS_ERR_VALUE(ret) ? -ENOTSUPP : prop;
+	return ret ? -ENOTSUPP : prop;
 }
 EXPORT_SYMBOL(caam_get_era);
 
diff -puN drivers/dma/sun4i-dma.c~remove-lots-of-is_err_value-abuses drivers/dma/sun4i-dma.c
--- a/drivers/dma/sun4i-dma.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/dma/sun4i-dma.c
@@ -461,25 +461,25 @@ generate_ndma_promise(struct dma_chan *c
 
 	/* Source burst */
 	ret = convert_burst(sconfig->src_maxburst);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_SRC_BURST_LENGTH(ret);
 
 	/* Destination burst */
 	ret = convert_burst(sconfig->dst_maxburst);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_DST_BURST_LENGTH(ret);
 
 	/* Source bus width */
 	ret = convert_buswidth(sconfig->src_addr_width);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_SRC_DATA_WIDTH(ret);
 
 	/* Destination bus width */
 	ret = convert_buswidth(sconfig->dst_addr_width);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_DST_DATA_WIDTH(ret);
 
@@ -518,25 +518,25 @@ generate_ddma_promise(struct dma_chan *c
 
 	/* Source burst */
 	ret = convert_burst(sconfig->src_maxburst);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_SRC_BURST_LENGTH(ret);
 
 	/* Destination burst */
 	ret = convert_burst(sconfig->dst_maxburst);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_DST_BURST_LENGTH(ret);
 
 	/* Source bus width */
 	ret = convert_buswidth(sconfig->src_addr_width);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_SRC_DATA_WIDTH(ret);
 
 	/* Destination bus width */
 	ret = convert_buswidth(sconfig->dst_addr_width);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto fail;
 	promise->cfg |= SUN4I_DMA_CFG_DST_DATA_WIDTH(ret);
 
diff -puN drivers/gpio/gpio-xlp.c~remove-lots-of-is_err_value-abuses drivers/gpio/gpio-xlp.c
--- a/drivers/gpio/gpio-xlp.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/gpio/gpio-xlp.c
@@ -393,7 +393,7 @@ static int xlp_gpio_probe(struct platfor
 		irq_base = irq_alloc_descs(-1, 0, gc->ngpio, 0);
 	else
 		irq_base = irq_alloc_descs(-1, XLP_GPIO_IRQ_BASE, gc->ngpio, 0);
-	if (IS_ERR_VALUE(irq_base)) {
+	if (irq_base < 0) {
 		dev_err(&pdev->dev, "Failed to allocate IRQ numbers\n");
 		return irq_base;
 	}
diff -puN drivers/gpu/drm/sti/sti_vtg.c~remove-lots-of-is_err_value-abuses drivers/gpu/drm/sti/sti_vtg.c
--- a/drivers/gpu/drm/sti/sti_vtg.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/gpu/drm/sti/sti_vtg.c
@@ -437,7 +437,7 @@ static int vtg_probe(struct platform_dev
 			return -EPROBE_DEFER;
 	} else {
 		vtg->irq = platform_get_irq(pdev, 0);
-		if (IS_ERR_VALUE(vtg->irq)) {
+		if (vtg->irq < 0) {
 			DRM_ERROR("Failed to get VTG interrupt\n");
 			return vtg->irq;
 		}
@@ -447,7 +447,7 @@ static int vtg_probe(struct platform_dev
 		ret = devm_request_threaded_irq(dev, vtg->irq, vtg_irq,
 				vtg_irq_thread, IRQF_ONESHOT,
 				dev_name(dev), vtg);
-		if (IS_ERR_VALUE(ret)) {
+		if (ret < 0) {
 			DRM_ERROR("Failed to register VTG interrupt\n");
 			return ret;
 		}
diff -puN drivers/gpu/drm/tilcdc/tilcdc_tfp410.c~remove-lots-of-is_err_value-abuses drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -342,7 +342,7 @@ static int tfp410_probe(struct platform_
 
 	tfp410_mod->gpio = of_get_named_gpio_flags(node, "powerdn-gpio",
 			0, NULL);
-	if (IS_ERR_VALUE(tfp410_mod->gpio)) {
+	if (tfp410_mod->gpio < 0) {
 		dev_warn(&pdev->dev, "No power down GPIO\n");
 	} else {
 		ret = gpio_request(tfp410_mod->gpio, "DVI_PDn");
diff -puN drivers/gpu/host1x/hw/intr_hw.c~remove-lots-of-is_err_value-abuses drivers/gpu/host1x/hw/intr_hw.c
--- a/drivers/gpu/host1x/hw/intr_hw.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/gpu/host1x/hw/intr_hw.c
@@ -85,7 +85,7 @@ static int _host1x_intr_init_host_sync(s
 	err = devm_request_irq(host->dev, host->intr_syncpt_irq,
 			       syncpt_thresh_isr, IRQF_SHARED,
 			       "host1x_syncpt", host);
-	if (IS_ERR_VALUE(err)) {
+	if (err < 0) {
 		WARN_ON(1);
 		return err;
 	}
diff -puN drivers/iommu/arm-smmu-v3.c~remove-lots-of-is_err_value-abuses drivers/iommu/arm-smmu-v3.c
--- a/drivers/iommu/arm-smmu-v3.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/iommu/arm-smmu-v3.c
@@ -1477,7 +1477,7 @@ static int arm_smmu_domain_finalise_s1(s
 	struct arm_smmu_s1_cfg *cfg = &smmu_domain->s1_cfg;
 
 	asid = arm_smmu_bitmap_alloc(smmu->asid_map, smmu->asid_bits);
-	if (IS_ERR_VALUE(asid))
+	if (asid < 0)
 		return asid;
 
 	cfg->cdptr = dmam_alloc_coherent(smmu->dev, CTXDESC_CD_DWORDS << 3,
@@ -1508,7 +1508,7 @@ static int arm_smmu_domain_finalise_s2(s
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
 
 	vmid = arm_smmu_bitmap_alloc(smmu->vmid_map, smmu->vmid_bits);
-	if (IS_ERR_VALUE(vmid))
+	if (vmid < 0)
 		return vmid;
 
 	cfg->vmid	= (u16)vmid;
@@ -1569,7 +1569,7 @@ static int arm_smmu_domain_finalise(stru
 	smmu_domain->pgtbl_ops = pgtbl_ops;
 
 	ret = finalise_stage_fn(smmu_domain, &pgtbl_cfg);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		free_io_pgtable_ops(pgtbl_ops);
 
 	return ret;
@@ -1642,7 +1642,7 @@ static void arm_smmu_detach_dev(struct d
 	struct arm_smmu_group *smmu_group = arm_smmu_group_get(dev);
 
 	smmu_group->ste.bypass = true;
-	if (IS_ERR_VALUE(arm_smmu_install_ste_for_group(smmu_group)))
+	if (arm_smmu_install_ste_for_group(smmu_group) < 0)
 		dev_warn(dev, "failed to install bypass STE\n");
 
 	smmu_group->domain = NULL;
@@ -1694,7 +1694,7 @@ static int arm_smmu_attach_dev(struct io
 	smmu_group->ste.bypass	= domain->type == IOMMU_DOMAIN_DMA;
 
 	ret = arm_smmu_install_ste_for_group(smmu_group);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		smmu_group->domain = NULL;
 
 out_unlock:
@@ -2235,7 +2235,7 @@ static int arm_smmu_setup_irqs(struct ar
 						arm_smmu_evtq_handler,
 						arm_smmu_evtq_thread,
 						0, "arm-smmu-v3-evtq", smmu);
-		if (IS_ERR_VALUE(ret))
+		if (ret < 0)
 			dev_warn(smmu->dev, "failed to enable evtq irq\n");
 	}
 
@@ -2244,7 +2244,7 @@ static int arm_smmu_setup_irqs(struct ar
 		ret = devm_request_irq(smmu->dev, irq,
 				       arm_smmu_cmdq_sync_handler, 0,
 				       "arm-smmu-v3-cmdq-sync", smmu);
-		if (IS_ERR_VALUE(ret))
+		if (ret < 0)
 			dev_warn(smmu->dev, "failed to enable cmdq-sync irq\n");
 	}
 
@@ -2252,7 +2252,7 @@ static int arm_smmu_setup_irqs(struct ar
 	if (irq) {
 		ret = devm_request_irq(smmu->dev, irq, arm_smmu_gerror_handler,
 				       0, "arm-smmu-v3-gerror", smmu);
-		if (IS_ERR_VALUE(ret))
+		if (ret < 0)
 			dev_warn(smmu->dev, "failed to enable gerror irq\n");
 	}
 
@@ -2264,7 +2264,7 @@ static int arm_smmu_setup_irqs(struct ar
 							arm_smmu_priq_thread,
 							0, "arm-smmu-v3-priq",
 							smmu);
-			if (IS_ERR_VALUE(ret))
+			if (ret < 0)
 				dev_warn(smmu->dev,
 					 "failed to enable priq irq\n");
 			else
diff -puN drivers/iommu/arm-smmu.c~remove-lots-of-is_err_value-abuses drivers/iommu/arm-smmu.c
--- a/drivers/iommu/arm-smmu.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/iommu/arm-smmu.c
@@ -950,7 +950,7 @@ static int arm_smmu_init_domain_context(
 
 	ret = __arm_smmu_alloc_bitmap(smmu->context_map, start,
 				      smmu->num_context_banks);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		goto out_unlock;
 
 	cfg->cbndx = ret;
@@ -989,7 +989,7 @@ static int arm_smmu_init_domain_context(
 	irq = smmu->irqs[smmu->num_global_irqs + cfg->irptndx];
 	ret = request_irq(irq, arm_smmu_context_fault, IRQF_SHARED,
 			  "arm-smmu-context-fault", domain);
-	if (IS_ERR_VALUE(ret)) {
+	if (ret < 0) {
 		dev_err(smmu->dev, "failed to request context IRQ %d (%u)\n",
 			cfg->irptndx, irq);
 		cfg->irptndx = INVALID_IRPTNDX;
@@ -1099,7 +1099,7 @@ static int arm_smmu_master_configure_smr
 	for (i = 0; i < cfg->num_streamids; ++i) {
 		int idx = __arm_smmu_alloc_bitmap(smmu->smr_map, 0,
 						  smmu->num_mapping_groups);
-		if (IS_ERR_VALUE(idx)) {
+		if (idx < 0) {
 			dev_err(smmu->dev, "failed to allocate free SMR\n");
 			goto err_free_smrs;
 		}
@@ -1233,7 +1233,7 @@ static int arm_smmu_attach_dev(struct io
 
 	/* Ensure that the domain is finalised */
 	ret = arm_smmu_init_domain_context(domain, smmu);
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		return ret;
 
 	/*
diff -puN drivers/irqchip/irq-clps711x.c~remove-lots-of-is_err_value-abuses drivers/irqchip/irq-clps711x.c
--- a/drivers/irqchip/irq-clps711x.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/irqchip/irq-clps711x.c
@@ -182,7 +182,7 @@ static int __init _clps711x_intc_init(st
 	writel_relaxed(0, clps711x_intc->intmr[2]);
 
 	err = irq_alloc_descs(-1, 0, ARRAY_SIZE(clps711x_irqs), numa_node_id());
-	if (IS_ERR_VALUE(err))
+	if (err < 0)
 		goto out_iounmap;
 
 	clps711x_intc->ops.map = clps711x_intc_irq_map;
diff -puN drivers/irqchip/irq-gic.c~remove-lots-of-is_err_value-abuses drivers/irqchip/irq-gic.c
--- a/drivers/irqchip/irq-gic.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/irqchip/irq-gic.c
@@ -1123,7 +1123,7 @@ static int __init __gic_init_bases(struc
 
 		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
 					   numa_node_id());
-		if (IS_ERR_VALUE(irq_base)) {
+		if (irq_base < 0) {
 			WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
 			     irq_start);
 			irq_base = irq_start;
diff -puN drivers/irqchip/irq-hip04.c~remove-lots-of-is_err_value-abuses drivers/irqchip/irq-hip04.c
--- a/drivers/irqchip/irq-hip04.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/irqchip/irq-hip04.c
@@ -402,7 +402,7 @@ hip04_of_init(struct device_node *node,
 	nr_irqs -= hwirq_base; /* calculate # of irqs to allocate */
 
 	irq_base = irq_alloc_descs(-1, hwirq_base, nr_irqs, numa_node_id());
-	if (IS_ERR_VALUE(irq_base)) {
+	if (irq_base < 0) {
 		pr_err("failed to allocate IRQ numbers\n");
 		return -EINVAL;
 	}
diff -puN drivers/irqchip/spear-shirq.c~remove-lots-of-is_err_value-abuses drivers/irqchip/spear-shirq.c
--- a/drivers/irqchip/spear-shirq.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/irqchip/spear-shirq.c
@@ -232,7 +232,7 @@ static int __init shirq_init(struct spea
 		nr_irqs += shirq_blocks[i]->nr_irqs;
 
 	virq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
-	if (IS_ERR_VALUE(virq_base)) {
+	if (virq_base < 0) {
 		pr_err("%s: irq desc alloc failed\n", __func__);
 		goto err_unmap;
 	}
diff -puN drivers/media/i2c/adp1653.c~remove-lots-of-is_err_value-abuses drivers/media/i2c/adp1653.c
--- a/drivers/media/i2c/adp1653.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/media/i2c/adp1653.c
@@ -95,7 +95,7 @@ static int adp1653_get_fault(struct adp1
 	int rval;
 
 	fault = i2c_smbus_read_byte_data(client, ADP1653_REG_FAULT);
-	if (IS_ERR_VALUE(fault))
+	if (fault < 0)
 		return fault;
 
 	flash->fault |= fault;
@@ -105,13 +105,13 @@ static int adp1653_get_fault(struct adp1
 
 	/* Clear faults. */
 	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, 0);
-	if (IS_ERR_VALUE(rval))
+	if (rval < 0)
 		return rval;
 
 	flash->led_mode->val = V4L2_FLASH_LED_MODE_NONE;
 
 	rval = adp1653_update_hw(flash);
-	if (IS_ERR_VALUE(rval))
+	if (rval)
 		return rval;
 
 	return flash->fault;
@@ -158,7 +158,7 @@ static int adp1653_get_ctrl(struct v4l2_
 	int rval;
 
 	rval = adp1653_get_fault(flash);
-	if (IS_ERR_VALUE(rval))
+	if (rval)
 		return rval;
 
 	ctrl->cur.val = 0;
@@ -184,7 +184,7 @@ static int adp1653_set_ctrl(struct v4l2_
 	int rval;
 
 	rval = adp1653_get_fault(flash);
-	if (IS_ERR_VALUE(rval))
+	if (rval)
 		return rval;
 	if ((rval & (ADP1653_REG_FAULT_FLT_SCP |
 		     ADP1653_REG_FAULT_FLT_OT |
diff -puN drivers/media/platform/s5p-tv/mixer_drv.c~remove-lots-of-is_err_value-abuses drivers/media/platform/s5p-tv/mixer_drv.c
--- a/drivers/media/platform/s5p-tv/mixer_drv.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -146,7 +146,7 @@ int mxr_power_get(struct mxr_device *mde
 
 	/* returning 1 means that power is already enabled,
 	 * so zero success be returned */
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		return ret;
 	return 0;
 }
diff -puN drivers/mfd/twl4030-irq.c~remove-lots-of-is_err_value-abuses drivers/mfd/twl4030-irq.c
--- a/drivers/mfd/twl4030-irq.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/mfd/twl4030-irq.c
@@ -696,7 +696,7 @@ int twl4030_init_irq(struct device *dev,
 	nr_irqs = TWL4030_PWR_NR_IRQS + TWL4030_CORE_NR_IRQS;
 
 	irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
-	if (IS_ERR_VALUE(irq_base)) {
+	if (irq_base < 0) {
 		dev_err(dev, "Fail to allocate IRQ descs\n");
 		return irq_base;
 	}
diff -puN drivers/mmc/core/mmc.c~remove-lots-of-is_err_value-abuses drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/mmc/core/mmc.c
@@ -1276,7 +1276,7 @@ static int mmc_select_hs200(struct mmc_c
 	 * switch to HS200 mode if bus width is set successfully.
 	 */
 	err = mmc_select_bus_width(card);
-	if (!IS_ERR_VALUE(err)) {
+	if (!err) {
 		val = EXT_CSD_TIMING_HS200 |
 		      card->drive_strength << EXT_CSD_DRV_STR_SHIFT;
 		err = __mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -1583,7 +1583,7 @@ static int mmc_init_card(struct mmc_host
 	} else if (mmc_card_hs(card)) {
 		/* Select the desired bus width optionally */
 		err = mmc_select_bus_width(card);
-		if (!IS_ERR_VALUE(err)) {
+		if (!err) {
 			err = mmc_select_hs_ddr(card);
 			if (err)
 				goto free_card;
diff -puN drivers/mmc/host/dw_mmc.c~remove-lots-of-is_err_value-abuses drivers/mmc/host/dw_mmc.c
--- a/drivers/mmc/host/dw_mmc.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/mmc/host/dw_mmc.c
@@ -1431,7 +1431,7 @@ static int dw_mci_get_ro(struct mmc_host
 	int gpio_ro = mmc_gpio_get_ro(mmc);
 
 	/* Use platform get_ro function, else try on board write protect */
-	if (!IS_ERR_VALUE(gpio_ro))
+	if (gpio_ro >= 0)
 		read_only = gpio_ro;
 	else
 		read_only =
@@ -1454,7 +1454,7 @@ static int dw_mci_get_cd(struct mmc_host
 	if ((mmc->caps & MMC_CAP_NEEDS_POLL) ||
 	    (mmc->caps & MMC_CAP_NONREMOVABLE))
 		present = 1;
-	else if (!IS_ERR_VALUE(gpio_cd))
+	else if (gpio_cd >= 0)
 		present = gpio_cd;
 	else
 		present = (mci_readl(slot->host, CDETECT) & (1 << slot->id))
@@ -2927,7 +2927,7 @@ static void dw_mci_enable_cd(struct dw_m
 		if (slot->mmc->caps & MMC_CAP_NEEDS_POLL)
 			return;
 
-		if (IS_ERR_VALUE(mmc_gpio_get_cd(slot->mmc)))
+		if (mmc_gpio_get_cd(slot->mmc) < 0)
 			break;
 	}
 	if (i == host->num_slots)
diff -puN drivers/mmc/host/sdhci-esdhc-imx.c~remove-lots-of-is_err_value-abuses drivers/mmc/host/sdhci-esdhc-imx.c
--- a/drivers/mmc/host/sdhci-esdhc-imx.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1011,7 +1011,7 @@ sdhci_esdhc_imx_probe_dt(struct platform
 	if (ret)
 		return ret;
 
-	if (!IS_ERR_VALUE(mmc_gpio_get_cd(host->mmc)))
+	if (mmc_gpio_get_cd(host->mmc) >= 0)
 		host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 
 	return 0;
diff -puN drivers/mmc/host/sdhci-of-at91.c~remove-lots-of-is_err_value-abuses drivers/mmc/host/sdhci-of-at91.c
--- a/drivers/mmc/host/sdhci-of-at91.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/mmc/host/sdhci-of-at91.c
@@ -289,7 +289,7 @@ static int sdhci_at91_probe(struct platf
 	 * to enable polling via device tree with broken-cd property.
 	 */
 	if (!(host->mmc->caps & MMC_CAP_NONREMOVABLE) &&
-	    IS_ERR_VALUE(mmc_gpio_get_cd(host->mmc))) {
+	    mmc_gpio_get_cd(host->mmc) < 0) {
 		host->mmc->caps |= MMC_CAP_NEEDS_POLL;
 		host->quirks &= ~SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 	}
diff -puN drivers/mmc/host/sdhci.c~remove-lots-of-is_err_value-abuses drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/mmc/host/sdhci.c
@@ -1624,7 +1624,7 @@ static int sdhci_get_cd(struct mmc_host
 	 * Try slot gpio detect, if defined it take precedence
 	 * over build in controller functionality
 	 */
-	if (!IS_ERR_VALUE(gpio_cd))
+	if (gpio_cd >= 0)
 		return !!gpio_cd;
 
 	/* If polling, assume that the card is always present. */
@@ -3077,7 +3077,7 @@ int sdhci_add_host(struct sdhci_host *ho
 
 	if ((host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION) &&
 	    !(mmc->caps & MMC_CAP_NONREMOVABLE) &&
-	    IS_ERR_VALUE(mmc_gpio_get_cd(host->mmc)))
+	    mmc_gpio_get_cd(host->mmc) < 0)
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
 
 	/* If there are external regulators, get them */
diff -puN drivers/net/ethernet/freescale/fman/fman.c~remove-lots-of-is_err_value-abuses drivers/net/ethernet/freescale/fman/fman.c
--- a/drivers/net/ethernet/freescale/fman/fman.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/net/ethernet/freescale/fman/fman.c
@@ -615,7 +615,7 @@ struct fman {
 	struct fman_cfg *cfg;
 	struct muram_info *muram;
 	/* cam section in muram */
-	int cam_offset;
+	unsigned long cam_offset;
 	size_t cam_size;
 	/* Fifo in MURAM */
 	int fifo_offset;
diff -puN drivers/net/ethernet/freescale/fman/fman_muram.c~remove-lots-of-is_err_value-abuses drivers/net/ethernet/freescale/fman/fman_muram.c
--- a/drivers/net/ethernet/freescale/fman/fman_muram.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/net/ethernet/freescale/fman/fman_muram.c
@@ -129,7 +129,7 @@ unsigned long fman_muram_offset_to_vbase
  *
  * Return: address of the allocated memory; NULL otherwise.
  */
-int fman_muram_alloc(struct muram_info *muram, size_t size)
+unsigned long fman_muram_alloc(struct muram_info *muram, size_t size)
 {
 	unsigned long vaddr;
 
@@ -150,7 +150,7 @@ int fman_muram_alloc(struct muram_info *
  *
  * Free an allocated memory from FM-MURAM partition.
  */
-void fman_muram_free_mem(struct muram_info *muram, u32 offset, size_t size)
+void fman_muram_free_mem(struct muram_info *muram, unsigned long offset, size_t size)
 {
 	unsigned long addr = fman_muram_offset_to_vbase(muram, offset);
 
diff -puN drivers/net/ethernet/freescale/fman/fman_muram.h~remove-lots-of-is_err_value-abuses drivers/net/ethernet/freescale/fman/fman_muram.h
--- a/drivers/net/ethernet/freescale/fman/fman_muram.h~remove-lots-of-is_err_value-abuses
+++ a/drivers/net/ethernet/freescale/fman/fman_muram.h
@@ -44,8 +44,8 @@ struct muram_info *fman_muram_init(phys_
 unsigned long fman_muram_offset_to_vbase(struct muram_info *muram,
 					 unsigned long offset);
 
-int fman_muram_alloc(struct muram_info *muram, size_t size);
+unsigned long fman_muram_alloc(struct muram_info *muram, size_t size);
 
-void fman_muram_free_mem(struct muram_info *muram, u32 offset, size_t size);
+void fman_muram_free_mem(struct muram_info *muram, unsigned long offset, size_t size);
 
 #endif /* __FM_MURAM_EXT */
diff -puN drivers/net/wireless/ti/wlcore/spi.c~remove-lots-of-is_err_value-abuses drivers/net/wireless/ti/wlcore/spi.c
--- a/drivers/net/wireless/ti/wlcore/spi.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/net/wireless/ti/wlcore/spi.c
@@ -382,7 +382,7 @@ static int wlcore_probe_of(struct spi_de
 
 	ret = of_property_read_u32(dt_node, "ref-clock-frequency",
 				   &pdev_data->ref_clock_freq);
-	if (IS_ERR_VALUE(ret)) {
+	if (ret) {
 		dev_err(glue->dev,
 			"can't get reference clock frequency (%d)\n", ret);
 		return ret;
@@ -425,7 +425,7 @@ static int wl1271_probe(struct spi_devic
 	}
 
 	ret = wlcore_probe_of(spi, glue, &pdev_data);
-	if (IS_ERR_VALUE(ret)) {
+	if (ret) {
 		dev_err(glue->dev,
 			"can't get device tree parameters (%d)\n", ret);
 		return ret;
diff -puN drivers/nvmem/core.c~remove-lots-of-is_err_value-abuses drivers/nvmem/core.c
--- a/drivers/nvmem/core.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/nvmem/core.c
@@ -113,7 +113,7 @@ static ssize_t bin_attr_nvmem_read(struc
 
 	rc = nvmem_reg_read(nvmem, pos, buf, count);
 
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	return count;
@@ -147,7 +147,7 @@ static ssize_t bin_attr_nvmem_write(stru
 
 	rc = nvmem_reg_write(nvmem, pos, buf, count);
 
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	return count;
@@ -366,7 +366,7 @@ static int nvmem_add_cells(struct nvmem_
 		}
 
 		rval = nvmem_cell_info_to_nvmem_cell(nvmem, &info[i], cells[i]);
-		if (IS_ERR_VALUE(rval)) {
+		if (rval) {
 			kfree(cells[i]);
 			goto err;
 		}
@@ -963,7 +963,7 @@ static int __nvmem_cell_read(struct nvme
 
 	rc = nvmem_reg_read(nvmem, cell->offset, buf, cell->bytes);
 
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	/* shift bits in-place */
@@ -998,7 +998,7 @@ void *nvmem_cell_read(struct nvmem_cell
 		return ERR_PTR(-ENOMEM);
 
 	rc = __nvmem_cell_read(nvmem, cell, buf, len);
-	if (IS_ERR_VALUE(rc)) {
+	if (rc) {
 		kfree(buf);
 		return ERR_PTR(rc);
 	}
@@ -1083,7 +1083,7 @@ int nvmem_cell_write(struct nvmem_cell *
 	if (cell->bit_offset || cell->nbits)
 		kfree(buf);
 
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	return len;
@@ -1111,11 +1111,11 @@ ssize_t nvmem_device_cell_read(struct nv
 		return -EINVAL;
 
 	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	rc = __nvmem_cell_read(nvmem, &cell, buf, &len);
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	return len;
@@ -1141,7 +1141,7 @@ int nvmem_device_cell_write(struct nvmem
 		return -EINVAL;
 
 	rc = nvmem_cell_info_to_nvmem_cell(nvmem, info, &cell);
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	return nvmem_cell_write(&cell, buf, cell.bytes);
@@ -1170,7 +1170,7 @@ int nvmem_device_read(struct nvmem_devic
 
 	rc = nvmem_reg_read(nvmem, offset, buf, bytes);
 
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 	return bytes;
@@ -1198,7 +1198,7 @@ int nvmem_device_write(struct nvmem_devi
 
 	rc = nvmem_reg_write(nvmem, offset, buf, bytes);
 
-	if (IS_ERR_VALUE(rc))
+	if (rc)
 		return rc;
 
 
diff -puN drivers/tty/serial/amba-pl011.c~remove-lots-of-is_err_value-abuses drivers/tty/serial/amba-pl011.c
--- a/drivers/tty/serial/amba-pl011.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/tty/serial/amba-pl011.c
@@ -2360,7 +2360,7 @@ static int pl011_probe_dt_alias(int inde
 		return ret;
 
 	ret = of_alias_get_id(np, "serial");
-	if (IS_ERR_VALUE(ret)) {
+	if (ret < 0) {
 		seen_dev_without_alias = true;
 		ret = index;
 	} else {
diff -puN drivers/tty/serial/sprd_serial.c~remove-lots-of-is_err_value-abuses drivers/tty/serial/sprd_serial.c
--- a/drivers/tty/serial/sprd_serial.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/tty/serial/sprd_serial.c
@@ -654,7 +654,7 @@ static int sprd_probe_dt_alias(int index
 		return ret;
 
 	ret = of_alias_get_id(np, "serial");
-	if (IS_ERR_VALUE(ret))
+	if (ret < 0)
 		ret = index;
 	else if (ret >= ARRAY_SIZE(sprd_port) || sprd_port[ret] != NULL) {
 		dev_warn(dev, "requested serial port %d not available.\n", ret);
diff -puN drivers/video/fbdev/da8xx-fb.c~remove-lots-of-is_err_value-abuses drivers/video/fbdev/da8xx-fb.c
--- a/drivers/video/fbdev/da8xx-fb.c~remove-lots-of-is_err_value-abuses
+++ a/drivers/video/fbdev/da8xx-fb.c
@@ -713,7 +713,7 @@ static int da8xx_fb_config_clk_divider(s
 
 	if (par->lcdc_clk_rate != lcdc_clk_rate) {
 		ret = clk_set_rate(par->lcdc_clk, lcdc_clk_rate);
-		if (IS_ERR_VALUE(ret)) {
+		if (ret) {
 			dev_err(par->dev,
 				"unable to set clock rate at %u\n",
 				lcdc_clk_rate);
@@ -784,7 +784,7 @@ static int lcd_init(struct da8xx_fb_par
 	int ret = 0;
 
 	ret = da8xx_fb_calc_config_clk_divider(par, panel);
-	if (IS_ERR_VALUE(ret)) {
+	if (ret) {
 		dev_err(par->dev, "unable to configure clock\n");
 		return ret;
 	}
diff -puN fs/afs/write.c~remove-lots-of-is_err_value-abuses fs/afs/write.c
--- a/fs/afs/write.c~remove-lots-of-is_err_value-abuses
+++ a/fs/afs/write.c
@@ -643,10 +643,6 @@ ssize_t afs_file_write(struct kiocb *ioc
 		return 0;
 
 	result = generic_file_write_iter(iocb, from);
-	if (IS_ERR_VALUE(result)) {
-		_leave(" = %zd", result);
-		return result;
-	}
 
 	_leave(" = %zd", result);
 	return result;
diff -puN fs/binfmt_flat.c~remove-lots-of-is_err_value-abuses fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~remove-lots-of-is_err_value-abuses
+++ a/fs/binfmt_flat.c
@@ -337,7 +337,7 @@ calc_reloc(unsigned long r, struct lib_i
 					"(%d != %d)", (unsigned) r, curid, id);
 			goto failed;
 		} else if ( ! p->lib_list[id].loaded &&
-				IS_ERR_VALUE(load_flat_shared_library(id, p))) {
+				load_flat_shared_library(id, p) < 0) {
 			printk("BINFMT_FLAT: failed to load library %d", id);
 			goto failed;
 		}
@@ -837,7 +837,7 @@ static int load_flat_shared_library(int
 
 	res = prepare_binprm(&bprm);
 
-	if (!IS_ERR_VALUE(res))
+	if (res >= 0)
 		res = load_flat_file(&bprm, libs, id, NULL);
 
 	abort_creds(bprm.cred);
@@ -883,7 +883,7 @@ static int load_flat_binary(struct linux
 	stack_len += FLAT_STACK_ALIGN - 1;  /* reserve for upcoming alignment */
 	
 	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
-	if (IS_ERR_VALUE(res))
+	if (res < 0)
 		return res;
 	
 	/* Update data segment pointers for all libraries */
diff -puN fs/gfs2/dir.c~remove-lots-of-is_err_value-abuses fs/gfs2/dir.c
--- a/fs/gfs2/dir.c~remove-lots-of-is_err_value-abuses
+++ a/fs/gfs2/dir.c
@@ -783,12 +783,15 @@ static int get_leaf_nr(struct gfs2_inode
 		       u64 *leaf_out)
 {
 	__be64 *hash;
+	int error;
 
 	hash = gfs2_dir_get_hash_table(dip);
-	if (IS_ERR(hash))
-		return PTR_ERR(hash);
-	*leaf_out = be64_to_cpu(*(hash + index));
-	return 0;
+	error = PTR_ERR_OR_ZERO(hash);
+
+	if (!error)
+		*leaf_out = be64_to_cpu(*(hash + index));
+
+	return error;
 }
 
 static int get_first_leaf(struct gfs2_inode *dip, u32 index,
@@ -798,7 +801,7 @@ static int get_first_leaf(struct gfs2_in
 	int error;
 
 	error = get_leaf_nr(dip, index, &leaf_no);
-	if (!IS_ERR_VALUE(error))
+	if (!error)
 		error = get_leaf(dip, leaf_no, bh_out);
 
 	return error;
@@ -1014,7 +1017,7 @@ static int dir_split_leaf(struct inode *
 
 	index = name->hash >> (32 - dip->i_depth);
 	error = get_leaf_nr(dip, index, &leaf_no);
-	if (IS_ERR_VALUE(error))
+	if (error)
 		return error;
 
 	/*  Get the old leaf block  */
diff -puN kernel/pid.c~remove-lots-of-is_err_value-abuses kernel/pid.c
--- a/kernel/pid.c~remove-lots-of-is_err_value-abuses
+++ a/kernel/pid.c
@@ -311,7 +311,7 @@ struct pid *alloc_pid(struct pid_namespa
 	pid->level = ns->level;
 	for (i = ns->level; i >= 0; i--) {
 		nr = alloc_pidmap(tmp);
-		if (IS_ERR_VALUE(nr)) {
+		if (nr < 0) {
 			retval = nr;
 			goto out_free;
 		}
diff -puN net/9p/client.c~remove-lots-of-is_err_value-abuses net/9p/client.c
--- a/net/9p/client.c~remove-lots-of-is_err_value-abuses
+++ a/net/9p/client.c
@@ -521,7 +521,7 @@ static int p9_check_errors(struct p9_cli
 		if (p9_is_proto_dotu(c))
 			err = -ecode;
 
-		if (!err || !IS_ERR_VALUE(err)) {
+		if (!err || !IS_ERR_VALUE((unsigned long)err)) {
 			err = p9_errstr2errno(ename, strlen(ename));
 
 			p9_debug(P9_DEBUG_9P, "<<< RERROR (%d) %s\n",
@@ -608,7 +608,7 @@ static int p9_check_zc_errors(struct p9_
 		if (p9_is_proto_dotu(c))
 			err = -ecode;
 
-		if (!err || !IS_ERR_VALUE(err)) {
+		if (!err || !IS_ERR_VALUE((unsigned long)err)) {
 			err = p9_errstr2errno(ename, strlen(ename));
 
 			p9_debug(P9_DEBUG_9P, "<<< RERROR (%d) %s\n",
diff -puN sound/soc/qcom/lpass-platform.c~remove-lots-of-is_err_value-abuses sound/soc/qcom/lpass-platform.c
--- a/sound/soc/qcom/lpass-platform.c~remove-lots-of-is_err_value-abuses
+++ a/sound/soc/qcom/lpass-platform.c
@@ -491,7 +491,7 @@ static int lpass_platform_pcm_new(struct
 			data->rdma_ch = v->alloc_dma_channel(drvdata,
 						SNDRV_PCM_STREAM_PLAYBACK);
 
-		if (IS_ERR_VALUE(data->rdma_ch))
+		if (data->rdma_ch < 0)
 			return data->rdma_ch;
 
 		drvdata->substream[data->rdma_ch] = psubstream;
@@ -518,7 +518,7 @@ static int lpass_platform_pcm_new(struct
 			data->wrdma_ch = v->alloc_dma_channel(drvdata,
 						SNDRV_PCM_STREAM_CAPTURE);
 
-		if (IS_ERR_VALUE(data->wrdma_ch))
+		if (data->wrdma_ch < 0)
 			goto capture_alloc_err;
 
 		drvdata->substream[data->wrdma_ch] = csubstream;
_

Patches currently in -mm which might be from arnd@arndb.de are

reiserfs-avoid-uninitialized-variable-use.patch

