From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 12 Sep 2017 12:29:31 -0700
Message-ID: <20170912192931.QSxGwngCr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdILT3d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2017 15:29:33 -0400
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

 Documentation/devicetree/bindings/watchdog/mtk-wdt.txt |    3 --
 arch/arm64/boot/dts/rockchip/rk3328-evb.dts            |   14 ----------
 drivers/clk/meson/gxbb.c                               |    6 ----
 include/dt-bindings/clock/rv1108-cru.h                 |   12 --------
 4 files changed, 35 deletions(-)

diff -puN arch/arm64/boot/dts/rockchip/rk3328-evb.dts~linux-next-git-rejects arch/arm64/boot/dts/rockchip/rk3328-evb.dts
--- a/arch/arm64/boot/dts/rockchip/rk3328-evb.dts~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/rockchip/rk3328-evb.dts
@@ -60,16 +60,6 @@
 		regulator-max-microvolt = <12000000>;
 	};
 
-<<<<<<< HEAD
-	vcc_sys: vcc-sys {
-		compatible = "regulator-fixed";
-		regulator-name = "vcc_sys";
-		regulator-always-on;
-		regulator-boot-on;
-		regulator-min-microvolt = <5000000>;
-		regulator-max-microvolt = <5000000>;
-		vin-supply = <&dc_12v>;
-=======
 	sdio_pwrseq: sdio-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		pinctrl-names = "default";
@@ -82,7 +72,6 @@
 		 * - PDN (power down when low)
 		 */
 		reset-gpios = <&gpio1 18 GPIO_ACTIVE_LOW>;
->>>>>>> linux-next/akpm-base
 	};
 
 	vcc_phy: vcc-phy-regulator {
@@ -252,8 +241,6 @@
 			rockchip,pins = <2 RK_PA6 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
-<<<<<<< HEAD
-=======
 
 	sdio-pwrseq {
 		wifi_enable_h: wifi-enable-h {
@@ -286,7 +273,6 @@
 	pinctrl-0 = <&sdmmc0_clk &sdmmc0_cmd &sdmmc0_dectn &sdmmc0_bus4>;
 	vmmc-supply = <&vcc_sd>;
 	status = "okay";
->>>>>>> linux-next/akpm-base
 };
 
 &tsadc {
diff -puN Documentation/devicetree/bindings/watchdog/mtk-wdt.txt~linux-next-git-rejects Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
--- a/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt~linux-next-git-rejects
+++ a/Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
@@ -4,11 +4,8 @@ Required properties:
 
 - compatible should contain:
 	"mediatek,mt2701-wdt", "mediatek,mt6589-wdt": for MT2701
-<<<<<<< HEAD
-=======
 	"mediatek,mt7622-wdt", "mediatek,mt6589-wdt": for MT7622
 	"mediatek,mt7623-wdt", "mediatek,mt6589-wdt": for MT7623
->>>>>>> linux-next/akpm-base
 	"mediatek,mt6589-wdt": for MT6589
 	"mediatek,mt6797-wdt", "mediatek,mt6589-wdt": for MT6797
 
diff -puN drivers/clk/meson/gxbb.c~linux-next-git-rejects drivers/clk/meson/gxbb.c
--- a/drivers/clk/meson/gxbb.c~linux-next-git-rejects
+++ a/drivers/clk/meson/gxbb.c
@@ -1340,8 +1340,6 @@ static struct clk_hw_onecell_data gxbb_h
 		[CLKID_32K_CLK]		    = &gxbb_32k_clk.hw,
 		[CLKID_32K_CLK_SEL]	    = &gxbb_32k_clk_sel.hw,
 		[CLKID_32K_CLK_DIV]	    = &gxbb_32k_clk_div.hw,
-<<<<<<< HEAD
-=======
 		[CLKID_SD_EMMC_A_CLK0_SEL]  = &gxbb_sd_emmc_a_clk0_sel.hw,
 		[CLKID_SD_EMMC_A_CLK0_DIV]  = &gxbb_sd_emmc_a_clk0_div.hw,
 		[CLKID_SD_EMMC_A_CLK0]	    = &gxbb_sd_emmc_a_clk0.hw,
@@ -1351,7 +1349,6 @@ static struct clk_hw_onecell_data gxbb_h
 		[CLKID_SD_EMMC_C_CLK0_SEL]  = &gxbb_sd_emmc_c_clk0_sel.hw,
 		[CLKID_SD_EMMC_C_CLK0_DIV]  = &gxbb_sd_emmc_c_clk0_div.hw,
 		[CLKID_SD_EMMC_C_CLK0]	    = &gxbb_sd_emmc_c_clk0.hw,
->>>>>>> linux-next/akpm-base
 		[NR_CLKS]		    = NULL,
 	},
 	.num = NR_CLKS,
@@ -1475,8 +1472,6 @@ static struct clk_hw_onecell_data gxl_hw
 		[CLKID_32K_CLK]		    = &gxbb_32k_clk.hw,
 		[CLKID_32K_CLK_SEL]	    = &gxbb_32k_clk_sel.hw,
 		[CLKID_32K_CLK_DIV]	    = &gxbb_32k_clk_div.hw,
-<<<<<<< HEAD
-=======
 		[CLKID_SD_EMMC_A_CLK0_SEL]  = &gxbb_sd_emmc_a_clk0_sel.hw,
 		[CLKID_SD_EMMC_A_CLK0_DIV]  = &gxbb_sd_emmc_a_clk0_div.hw,
 		[CLKID_SD_EMMC_A_CLK0]	    = &gxbb_sd_emmc_a_clk0.hw,
@@ -1486,7 +1481,6 @@ static struct clk_hw_onecell_data gxl_hw
 		[CLKID_SD_EMMC_C_CLK0_SEL]  = &gxbb_sd_emmc_c_clk0_sel.hw,
 		[CLKID_SD_EMMC_C_CLK0_DIV]  = &gxbb_sd_emmc_c_clk0_div.hw,
 		[CLKID_SD_EMMC_C_CLK0]	    = &gxbb_sd_emmc_c_clk0.hw,
->>>>>>> linux-next/akpm-base
 		[NR_CLKS]		    = NULL,
 	},
 	.num = NR_CLKS,
diff -puN include/dt-bindings/clock/rv1108-cru.h~linux-next-git-rejects include/dt-bindings/clock/rv1108-cru.h
--- a/include/dt-bindings/clock/rv1108-cru.h~linux-next-git-rejects
+++ a/include/dt-bindings/clock/rv1108-cru.h
@@ -67,15 +67,9 @@
 #define SCLK_SPI			108
 #define SCLK_SARADC			109
 #define SCLK_TSADC			110
-<<<<<<< HEAD
-#define SCLK_MACPHY_PRE			111
-#define SCLK_MACPHY			112
-#define SCLK_MACPHY_RX			113
-=======
 #define SCLK_MAC_PRE			111
 #define SCLK_MAC			112
 #define SCLK_MAC_RX			113
->>>>>>> linux-next/akpm-base
 #define SCLK_MAC_REF			114
 #define SCLK_MAC_REFOUT			115
 #define SCLK_DSP_PFM			116
@@ -116,10 +110,7 @@
 #define ACLK_CIF2			207
 #define ACLK_CIF3			208
 #define ACLK_PERI			209
-<<<<<<< HEAD
-=======
 #define ACLK_GMAC			210
->>>>>>> linux-next/akpm-base
 
 /* pclk gates */
 #define PCLK_GPIO1			256
@@ -151,10 +142,7 @@
 #define PCLK_EFUSE0			282
 #define PCLK_EFUSE1			283
 #define PCLK_WDT			284
-<<<<<<< HEAD
-=======
 #define PCLK_GMAC			285
->>>>>>> linux-next/akpm-base
 
 /* hclk gates */
 #define HCLK_I2S0_8CH			320
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

