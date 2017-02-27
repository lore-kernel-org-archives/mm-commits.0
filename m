From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:23:32 -0800
Message-ID: <58b48ac4.zRG58sKlrZYxYVP3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdB0UYm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/clock/st,stm32-rcc.txt |    3 
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts     |    4 
 arch/arm/mach-ux500/platsmp.c                            |    4 
 arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi    |   15 ---
 arch/arm64/boot/dts/exynos/exynos5433-tm2.dts            |   24 -----
 arch/arm64/boot/dts/exynos/exynos5433-tm2e.dts           |    3 
 arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi          |   42 ----------
 drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c         |   30 -------
 drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smc.c     |    4 
 drivers/gpu/drm/nouveau/dispnv04/dfp.c                   |    4 
 drivers/gpu/drm/nouveau/nouveau_bo.c                     |    4 
 drivers/gpu/drm/nouveau/nouveau_drm.c                    |    4 
 drivers/gpu/drm/rockchip/Kconfig                         |    3 
 drivers/gpu/drm/rockchip/cdn-dp-core.c                   |    7 -
 drivers/gpu/drm/sti/sti_drv.c                            |    3 
 drivers/gpu/drm/sti/sti_vtg.c                            |   12 --
 drivers/gpu/drm/zte/zx_plane.c                           |    8 -
 include/dt-bindings/clock/stm32fx-clock.h                |    3 
 lib/Kconfig                                              |    4 
 19 files changed, 181 deletions(-)

diff -puN Documentation/devicetree/bindings/clock/st,stm32-rcc.txt~linux-next-git-rejects Documentation/devicetree/bindings/clock/st,stm32-rcc.txt
--- a/Documentation/devicetree/bindings/clock/st,stm32-rcc.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/clock/st,stm32-rcc.txt
@@ -84,8 +84,6 @@ The secondary index is bound with the fo
 	11	CLK_SAI2
 	12	CLK_I2SQ_PDIV	(post divisor of pll i2s q divisor)
 	13	CLK_SAIQ_PDIV	(post divisor of pll sai q divisor)
-<<<<<<< HEAD
-=======
 
 	14	CLK_HSI		(Internal ocscillator clock)
 	15	CLK_SYSCLK	(System Clock)
@@ -105,7 +103,6 @@ The secondary index is bound with the fo
 	29	CLK_I2C4
 	30	CLK_LPTIMER	(LPTimer1 clock)
 )
->>>>>>> linux-next/akpm-base
 
 Example:
 
diff -puN arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts~linux-next-git-rejects arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts~linux-next-git-rejects
+++ a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2-emmc.dts
@@ -56,11 +56,7 @@
 };
 
 &pio {
-<<<<<<< HEAD
-	mmc2_pins_nrst: mmc2-rst-pin {
-=======
 	mmc2_pins_nrst: mmc2@0 {
->>>>>>> linux-next/akpm-base
 		pins = "PC16";
 		function = "gpio_out";
 	};
diff -puN arch/arm/mach-ux500/platsmp.c~linux-next-git-rejects arch/arm/mach-ux500/platsmp.c
--- a/arch/arm/mach-ux500/platsmp.c~linux-next-git-rejects
+++ a/arch/arm/mach-ux500/platsmp.c
@@ -79,11 +79,7 @@ static int ux500_boot_secondary(unsigned
 	 * backup ram register at offset 0x1FF0, which is what boot rom code
 	 * is waiting for. This will wake up the secondary core from WFE.
 	 */
-<<<<<<< HEAD
-	writel(virt_to_phys(secondary_startup),
-=======
 	writel(__pa_symbol(secondary_startup),
->>>>>>> linux-next/akpm-base
 	       backupram + UX500_CPU1_JUMPADDR_OFFSET);
 	writel(0xA1FEED01,
 	       backupram + UX500_CPU1_WAKEMAGIC_OFFSET);
diff -puN arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi~linux-next-git-rejects arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
--- a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/exynos/exynos5433-tm2-common.dtsi
@@ -217,21 +217,6 @@
 	assigned-clock-parents = <&cmu_top CLK_FOUT_AUD_PLL>;
 };
 
-<<<<<<< HEAD
-&cmu_disp {
-	assigned-clocks = <&cmu_mif CLK_MOUT_SCLK_DECON_TV_ECLK_A>,
-			  <&cmu_mif CLK_DIV_SCLK_DECON_TV_ECLK>,
-			  <&cmu_disp CLK_MOUT_SCLK_DECON_TV_ECLK_USER>,
-			  <&cmu_disp CLK_MOUT_SCLK_DECON_TV_ECLK>;
-	assigned-clock-parents = <&cmu_mif CLK_MOUT_BUS_PLL_DIV2>,
-				 <0>,
-				 <&cmu_mif CLK_SCLK_DECON_TV_ECLK_DISP>,
-				 <&cmu_disp CLK_MOUT_SCLK_DECON_TV_ECLK_USER>;
-	assigned-clock-rates = <0>, <400000000>;
-};
-
-=======
->>>>>>> linux-next/akpm-base
 &cmu_fsys {
 	assigned-clocks = <&cmu_top CLK_MOUT_SCLK_USBDRD30>,
 		<&cmu_top CLK_MOUT_SCLK_USBHOST30>,
diff -puN arch/arm64/boot/dts/exynos/exynos5433-tm2.dts~linux-next-git-rejects arch/arm64/boot/dts/exynos/exynos5433-tm2.dts
--- a/arch/arm64/boot/dts/exynos/exynos5433-tm2.dts~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/exynos/exynos5433-tm2.dts
@@ -16,29 +16,6 @@
 / {
 	model = "Samsung TM2 board";
 	compatible = "samsung,tm2", "samsung,exynos5433";
-<<<<<<< HEAD
-};
-
-&hsi2c_9 {
-	status = "okay";
-
-	touchkey@20 {
-		compatible = "cypress,tm2-touchkey";
-		reg = <0x20>;
-		interrupt-parent = <&gpa3>;
-		interrupts = <2 IRQ_TYPE_EDGE_FALLING>;
-		vcc-supply = <&ldo32_reg>;
-		vdd-supply = <&ldo33_reg>;
-	};
-};
-
-&ldo31_reg {
-	regulator-name = "TSP_VDD_1.85V_AP";
-	regulator-min-microvolt = <1850000>;
-	regulator-max-microvolt = <1850000>;
-};
-
-=======
 };
 
 &cmu_disp {
@@ -94,7 +71,6 @@
 	regulator-max-microvolt = <1850000>;
 };
 
->>>>>>> linux-next/akpm-base
 &ldo38_reg {
 	regulator-name = "VCC_3.0V_MOTOR_AP";
 	regulator-min-microvolt = <3000000>;
diff -puN arch/arm64/boot/dts/exynos/exynos5433-tm2e.dts~linux-next-git-rejects arch/arm64/boot/dts/exynos/exynos5433-tm2e.dts
--- a/arch/arm64/boot/dts/exynos/exynos5433-tm2e.dts~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/exynos/exynos5433-tm2e.dts
@@ -18,8 +18,6 @@
 	compatible = "samsung,tm2e", "samsung,exynos5433";
 };
 
-<<<<<<< HEAD
-=======
 &cmu_disp {
 	/*
 	 * TM2 and TM2e differ only by DISP_PLL rate, but define all assigned
@@ -54,7 +52,6 @@
 	assigned-clock-rates = <278000000>, <400000000>;
 };
 
->>>>>>> linux-next/akpm-base
 &ldo31_reg {
 	regulator-name = "TSP_VDD_1.8V_AP";
 	regulator-min-microvolt = <1800000>;
diff -puN arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi~linux-next-git-rejects arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
--- a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/exynos/exynos7-pinctrl.dtsi
@@ -497,93 +497,51 @@
 
 	sd0_clk: sd0-clk {
 		samsung,pins = "gpr0-0";
-<<<<<<< HEAD
-		samsung,pin-function = <2>;
-		samsung,pin-pud = <0>;
-		samsung,pin-drv = <4>;
-=======
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS7_FSYS1_PIN_DRV_LV2>;
->>>>>>> linux-next/akpm-base
 	};
 
 	sd0_cmd: sd0-cmd {
 		samsung,pins = "gpr0-1";
-<<<<<<< HEAD
-		samsung,pin-function = <2>;
-		samsung,pin-pud = <3>;
-		samsung,pin-drv = <4>;
-=======
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_UP>;
 		samsung,pin-drv = <EXYNOS7_FSYS1_PIN_DRV_LV2>;
->>>>>>> linux-next/akpm-base
 	};
 
 	sd0_ds: sd0-ds {
 		samsung,pins = "gpr0-2";
-<<<<<<< HEAD
-		samsung,pin-function = <2>;
-		samsung,pin-pud = <1>;
-		samsung,pin-drv = <4>;
-=======
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_DOWN>;
 		samsung,pin-drv = <EXYNOS7_FSYS1_PIN_DRV_LV2>;
->>>>>>> linux-next/akpm-base
 	};
 
 	sd0_qrdy: sd0-qrdy {
 		samsung,pins = "gpr0-3";
-<<<<<<< HEAD
-		samsung,pin-function = <2>;
-		samsung,pin-pud = <1>;
-		samsung,pin-drv = <4>;
-=======
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_DOWN>;
 		samsung,pin-drv = <EXYNOS7_FSYS1_PIN_DRV_LV2>;
->>>>>>> linux-next/akpm-base
 	};
 
 	sd0_bus1: sd0-bus-width1 {
 		samsung,pins = "gpr1-0";
-<<<<<<< HEAD
-		samsung,pin-function = <2>;
-		samsung,pin-pud = <3>;
-		samsung,pin-drv = <4>;
-=======
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_UP>;
 		samsung,pin-drv = <EXYNOS7_FSYS1_PIN_DRV_LV2>;
->>>>>>> linux-next/akpm-base
 	};
 
 	sd0_bus4: sd0-bus-width4 {
 		samsung,pins = "gpr1-1", "gpr1-2", "gpr1-3";
-<<<<<<< HEAD
-		samsung,pin-function = <2>;
-		samsung,pin-pud = <3>;
-		samsung,pin-drv = <4>;
-=======
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_UP>;
 		samsung,pin-drv = <EXYNOS7_FSYS1_PIN_DRV_LV2>;
->>>>>>> linux-next/akpm-base
 	};
 
 	sd0_bus8: sd0-bus-width8 {
 		samsung,pins = "gpr1-4", "gpr1-5", "gpr1-6", "gpr1-7";
-<<<<<<< HEAD
-		samsung,pin-function = <2>;
-		samsung,pin-pud = <3>;
-		samsung,pin-drv = <4>;
-=======
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_UP>;
 		samsung,pin-drv = <EXYNOS7_FSYS1_PIN_DRV_LV2>;
->>>>>>> linux-next/akpm-base
 	};
 
 	sd1_clk: sd1-clk {
diff -puN drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c~linux-next-git-rejects drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -2555,7 +2555,6 @@ static int smu7_get_profiling_clk(struct
 		}
 		if (count < 0 || level == AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK)
 			*sclk_mask = 0;
-<<<<<<< HEAD
 
 		if (level == AMD_DPM_FORCED_LEVEL_PROFILE_PEAK)
 			*sclk_mask = table_info->vdd_dep_on_sclk->count - 1;
@@ -2566,18 +2565,6 @@ static int smu7_get_profiling_clk(struct
 	else if (level == AMD_DPM_FORCED_LEVEL_PROFILE_PEAK)
 		*mclk_mask = golden_dpm_table->mclk_table.count - 1;
 
-=======
-
-		if (level == AMD_DPM_FORCED_LEVEL_PROFILE_PEAK)
-			*sclk_mask = table_info->vdd_dep_on_sclk->count - 1;
-	}
-
-	if (level == AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK)
-		*mclk_mask = 0;
-	else if (level == AMD_DPM_FORCED_LEVEL_PROFILE_PEAK)
-		*mclk_mask = golden_dpm_table->mclk_table.count - 1;
-
->>>>>>> linux-next/akpm-base
 	*pcie_mask = data->dpm_table.pcie_speed_table.count - 1;
 	return 0;
 }
@@ -2634,22 +2621,6 @@ static int smu7_force_dpm_level(struct p
 		if (ret)
 			return ret;
 		hwmgr->dpm_level = level;
-<<<<<<< HEAD
-		break;
-	case AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD:
-	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK:
-	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK:
-	case AMD_DPM_FORCED_LEVEL_PROFILE_PEAK:
-		ret = smu7_get_profiling_clk(hwmgr, level, &sclk_mask, &mclk_mask, &pcie_mask);
-		if (ret)
-			return ret;
-		hwmgr->dpm_level = level;
-		smu7_force_clock_level(hwmgr, PP_SCLK, 1<<sclk_mask);
-		smu7_force_clock_level(hwmgr, PP_MCLK, 1<<mclk_mask);
-		smu7_force_clock_level(hwmgr, PP_PCIE, 1<<pcie_mask);
-
-		break;
-=======
 		break;
 	case AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD:
 	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK:
@@ -2664,7 +2635,6 @@ static int smu7_force_dpm_level(struct p
 		smu7_force_clock_level(hwmgr, PP_PCIE, 1<<pcie_mask);
 
 		break;
->>>>>>> linux-next/akpm-base
 	case AMD_DPM_FORCED_LEVEL_MANUAL:
 		hwmgr->dpm_level = level;
 		break;
diff -puN drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smc.c~linux-next-git-rejects drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smc.c
--- a/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smc.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/powerplay/smumgr/polaris10_smc.c
@@ -503,11 +503,7 @@ static int polaris10_populate_ulv_level(
 	state->VddcOffsetVid = (uint8_t)(table_info->us_ulv_voltage_offset *
 			VOLTAGE_VID_OFFSET_SCALE2 / VOLTAGE_VID_OFFSET_SCALE1);
 
-<<<<<<< HEAD
-	if (smumgr->chip_id == CHIP_POLARIS12 || smumgr->is_kicker)
-=======
 	if (smumgr->is_kicker)
->>>>>>> linux-next/akpm-base
 		state->VddcPhase = data->vddc_phase_shed_control ^ 0x3;
 	else
 		state->VddcPhase = (data->vddc_phase_shed_control) ? 0 : 1;
diff -puN drivers/gpu/drm/nouveau/dispnv04/dfp.c~linux-next-git-rejects drivers/gpu/drm/nouveau/dispnv04/dfp.c
--- a/drivers/gpu/drm/nouveau/dispnv04/dfp.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/nouveau/dispnv04/dfp.c
@@ -417,11 +417,7 @@ static void nv04_dfp_mode_set(struct drm
 	if ((nv_connector->dithering_mode == DITHERING_MODE_ON) ||
 	    (nv_connector->dithering_mode == DITHERING_MODE_AUTO &&
 	     fb->format->depth > connector->display_info.bpc * 3)) {
-<<<<<<< HEAD
 		if (drm->client.device.info.chipset == 0x11)
-=======
-		if (drm->device.info.chipset == 0x11)
->>>>>>> linux-next/akpm-base
 			regp->dither = savep->dither | 0x00010000;
 		else {
 			int i;
diff -puN drivers/gpu/drm/nouveau/nouveau_bo.c~linux-next-git-rejects drivers/gpu/drm/nouveau/nouveau_bo.c
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1198,11 +1198,7 @@ out:
 
 static void
 nouveau_bo_move_ntfy(struct ttm_buffer_object *bo, bool evict,
-<<<<<<< HEAD
 		     struct ttm_mem_reg *new_reg)
-=======
-		     struct ttm_mem_reg *new_mem)
->>>>>>> linux-next/akpm-base
 {
 	struct nouveau_bo *nvbo = nouveau_bo(bo);
 	struct nvkm_vma *vma;
diff -puN drivers/gpu/drm/nouveau/nouveau_drm.c~linux-next-git-rejects drivers/gpu/drm/nouveau/nouveau_drm.c
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -546,12 +546,8 @@ nouveau_drm_unload(struct drm_device *de
 
 	if (drm->hdmi_device)
 		pci_dev_put(drm->hdmi_device);
-<<<<<<< HEAD
 	nouveau_cli_fini(&drm->client);
 	kfree(drm);
-=======
-	nouveau_cli_destroy(&drm->client);
->>>>>>> linux-next/akpm-base
 }
 
 void
diff -puN drivers/gpu/drm/rockchip/Kconfig~linux-next-git-rejects drivers/gpu/drm/rockchip/Kconfig
--- a/drivers/gpu/drm/rockchip/Kconfig~linux-next-git-rejects
+++ a/drivers/gpu/drm/rockchip/Kconfig
@@ -24,10 +24,7 @@ config ROCKCHIP_ANALOGIX_DP
 config ROCKCHIP_CDN_DP
         tristate "Rockchip cdn DP"
         depends on DRM_ROCKCHIP
-<<<<<<< HEAD
-=======
 	depends on EXTCON
->>>>>>> linux-next/akpm-base
 	select SND_SOC_HDMI_CODEC if SND_SOC
         help
 	  This selects support for Rockchip SoC specific extensions
diff -puN drivers/gpu/drm/rockchip/cdn-dp-core.c~linux-next-git-rejects drivers/gpu/drm/rockchip/cdn-dp-core.c
--- a/drivers/gpu/drm/rockchip/cdn-dp-core.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/rockchip/cdn-dp-core.c
@@ -111,11 +111,7 @@ static int cdn_dp_clk_enable(struct cdn_
 	ret = pm_runtime_get_sync(dp->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dp->dev, "cannot get pm runtime %d\n", ret);
-<<<<<<< HEAD
-		goto err_pclk;
-=======
 		goto err_pm_runtime_get;
->>>>>>> linux-next/akpm-base
 	}
 
 	reset_control_assert(dp->core_rst);
@@ -137,11 +133,8 @@ static int cdn_dp_clk_enable(struct cdn_
 	return 0;
 
 err_set_rate:
-<<<<<<< HEAD
-=======
 	pm_runtime_put(dp->dev);
 err_pm_runtime_get:
->>>>>>> linux-next/akpm-base
 	clk_disable_unprepare(dp->core_clk);
 err_core_clk:
 	clk_disable_unprepare(dp->pclk);
diff -puN drivers/gpu/drm/sti/sti_drv.c~linux-next-git-rejects drivers/gpu/drm/sti/sti_drv.c
--- a/drivers/gpu/drm/sti/sti_drv.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/sti/sti_drv.c
@@ -117,8 +117,6 @@ err:
 	return ret;
 }
 
-<<<<<<< HEAD
-=======
 static void sti_drm_dbg_cleanup(struct drm_minor *minor)
 {
 	drm_debugfs_remove_files(sti_drm_dbg_list,
@@ -128,7 +126,6 @@ static void sti_drm_dbg_cleanup(struct d
 				 1, minor);
 }
 
->>>>>>> linux-next/akpm-base
 static int sti_atomic_check(struct drm_device *dev,
 			    struct drm_atomic_state *state)
 {
diff -puN drivers/gpu/drm/sti/sti_vtg.c~linux-next-git-rejects drivers/gpu/drm/sti/sti_vtg.c
--- a/drivers/gpu/drm/sti/sti_vtg.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/sti/sti_vtg.c
@@ -411,7 +411,6 @@ static int vtg_probe(struct platform_dev
 		DRM_ERROR("failed to remap I/O memory\n");
 		return -ENOMEM;
 	}
-<<<<<<< HEAD
 
 	vtg->irq = platform_get_irq(pdev, 0);
 	if (vtg->irq < 0) {
@@ -421,17 +420,6 @@ static int vtg_probe(struct platform_dev
 
 	RAW_INIT_NOTIFIER_HEAD(&vtg->notifier_list);
 
-=======
-
-	vtg->irq = platform_get_irq(pdev, 0);
-	if (vtg->irq < 0) {
-		DRM_ERROR("Failed to get VTG interrupt\n");
-		return vtg->irq;
-	}
-
-	RAW_INIT_NOTIFIER_HEAD(&vtg->notifier_list);
-
->>>>>>> linux-next/akpm-base
 	ret = devm_request_threaded_irq(dev, vtg->irq, vtg_irq,
 					vtg_irq_thread, IRQF_ONESHOT,
 					dev_name(dev), vtg);
diff -puN drivers/gpu/drm/zte/zx_plane.c~linux-next-git-rejects drivers/gpu/drm/zte/zx_plane.c
--- a/drivers/gpu/drm/zte/zx_plane.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/zte/zx_plane.c
@@ -159,11 +159,7 @@ static void zx_vl_rsz_setup(struct zx_pl
 	void __iomem *rsz = zplane->rsz;
 	u32 src_chroma_w = src_w;
 	u32 src_chroma_h = src_h;
-<<<<<<< HEAD
-	u32 fmt;
-=======
 	int fmt;
->>>>>>> linux-next/akpm-base
 
 	/* Set up source and destination resolution */
 	zx_writel(rsz + RSZ_SRC_CFG, RSZ_VER(src_h - 1) | RSZ_HOR(src_w - 1));
@@ -207,11 +203,7 @@ static void zx_vl_plane_atomic_update(st
 	u32 src_x, src_y, src_w, src_h;
 	u32 dst_x, dst_y, dst_w, dst_h;
 	uint32_t format;
-<<<<<<< HEAD
-	u32 fmt;
-=======
 	int fmt;
->>>>>>> linux-next/akpm-base
 	int num_planes;
 	int i;
 
diff -puN include/dt-bindings/clock/stm32fx-clock.h~linux-next-git-rejects include/dt-bindings/clock/stm32fx-clock.h
--- a/include/dt-bindings/clock/stm32fx-clock.h~linux-next-git-rejects
+++ a/include/dt-bindings/clock/stm32fx-clock.h
@@ -36,8 +36,6 @@
 
 #define END_PRIMARY_CLK		14
 
-<<<<<<< HEAD
-=======
 #define CLK_HSI			14
 #define CLK_SYSCLK		15
 #define CLK_HDMI_CEC		16
@@ -58,5 +56,4 @@
 
 #define END_PRIMARY_CLK_F7	31
 
->>>>>>> linux-next/akpm-base
 #endif
diff -puN lib/Kconfig~linux-next-git-rejects lib/Kconfig
--- a/lib/Kconfig~linux-next-git-rejects
+++ a/lib/Kconfig
@@ -552,14 +552,10 @@ config PARMAN
 	tristate
 
 config PRIME_NUMBERS
-<<<<<<< HEAD
-	tristate
-=======
 	tristate "Prime number generator"
 	default n
 	help
 	  Provides a helper module to generate prime numbers. Useful for writing
 	  test code, especially when checking multiplication and divison.
->>>>>>> linux-next/akpm-base
 
 endmenu
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

