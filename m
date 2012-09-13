From: akpm@linux-foundation.org
Subject: + sections-fix-section-conflicts-in-arch-arm.patch added to -mm tree
Date: Thu, 13 Sep 2012 16:36:38 -0700
Message-ID: <20120913233639.251CF1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:32968 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137Ab2IMXgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 19:36:40 -0400
Received: by qcqs25 with SMTP id s25so389385qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 16:36:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, rmk@arm.linux.org.uk


The patch titled
     Subject: sections: fix section conflicts in arch/arm/
has been added to the -mm tree.  Its filename is
     sections-fix-section-conflicts-in-arch-arm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/arm/

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/clock.c                  |    2 
 arch/arm/mach-davinci/board-tnetv107x-evm.c |    6 +-
 arch/arm/mach-davinci/da830.c               |   48 +++++++++---------
 arch/arm/mach-davinci/da850.c               |    6 +-
 arch/arm/mach-msm/board-qsd8x50.c           |    4 -
 arch/arm/mach-omap2/display.c               |    6 +-
 6 files changed, 36 insertions(+), 36 deletions(-)

diff -puN arch/arm/mach-at91/clock.c~sections-fix-section-conflicts-in-arch-arm arch/arm/mach-at91/clock.c
--- a/arch/arm/mach-at91/clock.c~sections-fix-section-conflicts-in-arch-arm
+++ a/arch/arm/mach-at91/clock.c
@@ -625,7 +625,7 @@ fail:
 	return 0;
 }
 
-static struct clk *const standard_pmc_clocks[] __initdata = {
+static struct clk *const standard_pmc_clocks[] __initconst = {
 	/* four primary clocks */
 	&clk32k,
 	&main_clk,
diff -puN arch/arm/mach-davinci/board-tnetv107x-evm.c~sections-fix-section-conflicts-in-arch-arm arch/arm/mach-davinci/board-tnetv107x-evm.c
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c~sections-fix-section-conflicts-in-arch-arm
+++ a/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -88,7 +88,7 @@ static struct davinci_mmc_config mmc_con
 	.version	= MMC_CTLR_VERSION_1,
 };
 
-static const short sdio1_pins[] __initdata = {
+static const short sdio1_pins[] __initconst = {
 	TNETV107X_SDIO1_CLK_1,		TNETV107X_SDIO1_CMD_1,
 	TNETV107X_SDIO1_DATA0_1,	TNETV107X_SDIO1_DATA1_1,
 	TNETV107X_SDIO1_DATA2_1,	TNETV107X_SDIO1_DATA3_1,
@@ -96,12 +96,12 @@ static const short sdio1_pins[] __initda
 	-1
 };
 
-static const short uart1_pins[] __initdata = {
+static const short uart1_pins[] __initconst = {
 	TNETV107X_UART1_RD,		TNETV107X_UART1_TD,
 	-1
 };
 
-static const short ssp_pins[] __initdata = {
+static const short ssp_pins[] __initconst = {
 	TNETV107X_SSP0_0, TNETV107X_SSP0_1, TNETV107X_SSP0_2,
 	TNETV107X_SSP1_0, TNETV107X_SSP1_1, TNETV107X_SSP1_2,
 	TNETV107X_SSP1_3, -1
diff -puN arch/arm/mach-davinci/da830.c~sections-fix-section-conflicts-in-arch-arm arch/arm/mach-davinci/da830.c
--- a/arch/arm/mach-davinci/da830.c~sections-fix-section-conflicts-in-arch-arm
+++ a/arch/arm/mach-davinci/da830.c
@@ -838,7 +838,7 @@ static const struct mux_config da830_pin
 #endif
 };
 
-const short da830_emif25_pins[] __initdata = {
+const short da830_emif25_pins[] __initconst = {
 	DA830_EMA_D_0, DA830_EMA_D_1, DA830_EMA_D_2, DA830_EMA_D_3,
 	DA830_EMA_D_4, DA830_EMA_D_5, DA830_EMA_D_6, DA830_EMA_D_7,
 	DA830_EMA_D_8, DA830_EMA_D_9, DA830_EMA_D_10, DA830_EMA_D_11,
@@ -853,19 +853,19 @@ const short da830_emif25_pins[] __initda
 	-1
 };
 
-const short da830_spi0_pins[] __initdata = {
+const short da830_spi0_pins[] __initconst = {
 	DA830_SPI0_SOMI_0, DA830_SPI0_SIMO_0, DA830_SPI0_CLK, DA830_NSPI0_ENA,
 	DA830_NSPI0_SCS_0,
 	-1
 };
 
-const short da830_spi1_pins[] __initdata = {
+const short da830_spi1_pins[] __initconst = {
 	DA830_SPI1_SOMI_0, DA830_SPI1_SIMO_0, DA830_SPI1_CLK, DA830_NSPI1_ENA,
 	DA830_NSPI1_SCS_0,
 	-1
 };
 
-const short da830_mmc_sd_pins[] __initdata = {
+const short da830_mmc_sd_pins[] __initconst = {
 	DA830_MMCSD_DAT_0, DA830_MMCSD_DAT_1, DA830_MMCSD_DAT_2,
 	DA830_MMCSD_DAT_3, DA830_MMCSD_DAT_4, DA830_MMCSD_DAT_5,
 	DA830_MMCSD_DAT_6, DA830_MMCSD_DAT_7, DA830_MMCSD_CLK,
@@ -873,32 +873,32 @@ const short da830_mmc_sd_pins[] __initda
 	-1
 };
 
-const short da830_uart0_pins[] __initdata = {
+const short da830_uart0_pins[] __initconst = {
 	DA830_NUART0_CTS, DA830_NUART0_RTS, DA830_UART0_RXD, DA830_UART0_TXD,
 	-1
 };
 
-const short da830_uart1_pins[] __initdata = {
+const short da830_uart1_pins[] __initconst = {
 	DA830_UART1_RXD, DA830_UART1_TXD,
 	-1
 };
 
-const short da830_uart2_pins[] __initdata = {
+const short da830_uart2_pins[] __initconst = {
 	DA830_UART2_RXD, DA830_UART2_TXD,
 	-1
 };
 
-const short da830_usb20_pins[] __initdata = {
+const short da830_usb20_pins[] __initconst = {
 	DA830_USB0_DRVVBUS, DA830_USB_REFCLKIN,
 	-1
 };
 
-const short da830_usb11_pins[] __initdata = {
+const short da830_usb11_pins[] __initconst = {
 	DA830_USB_REFCLKIN,
 	-1
 };
 
-const short da830_uhpi_pins[] __initdata = {
+const short da830_uhpi_pins[] __initconst = {
 	DA830_UHPI_HD_0, DA830_UHPI_HD_1, DA830_UHPI_HD_2, DA830_UHPI_HD_3,
 	DA830_UHPI_HD_4, DA830_UHPI_HD_5, DA830_UHPI_HD_6, DA830_UHPI_HD_7,
 	DA830_UHPI_HD_8, DA830_UHPI_HD_9, DA830_UHPI_HD_10, DA830_UHPI_HD_11,
@@ -909,14 +909,14 @@ const short da830_uhpi_pins[] __initdata
 	-1
 };
 
-const short da830_cpgmac_pins[] __initdata = {
+const short da830_cpgmac_pins[] __initconst = {
 	DA830_RMII_TXD_0, DA830_RMII_TXD_1, DA830_RMII_TXEN, DA830_RMII_CRS_DV,
 	DA830_RMII_RXD_0, DA830_RMII_RXD_1, DA830_RMII_RXER, DA830_MDIO_CLK,
 	DA830_MDIO_D,
 	-1
 };
 
-const short da830_emif3c_pins[] __initdata = {
+const short da830_emif3c_pins[] __initconst = {
 	DA830_EMB_SDCKE, DA830_EMB_CLK_GLUE, DA830_EMB_CLK, DA830_NEMB_CS_0,
 	DA830_NEMB_CAS, DA830_NEMB_RAS, DA830_NEMB_WE, DA830_EMB_BA_1,
 	DA830_EMB_BA_0, DA830_EMB_A_0, DA830_EMB_A_1, DA830_EMB_A_2,
@@ -935,7 +935,7 @@ const short da830_emif3c_pins[] __initda
 	-1
 };
 
-const short da830_mcasp0_pins[] __initdata = {
+const short da830_mcasp0_pins[] __initconst = {
 	DA830_AHCLKX0, DA830_ACLKX0, DA830_AFSX0,
 	DA830_AHCLKR0, DA830_ACLKR0, DA830_AFSR0, DA830_AMUTE0,
 	DA830_AXR0_0, DA830_AXR0_1, DA830_AXR0_2, DA830_AXR0_3,
@@ -945,7 +945,7 @@ const short da830_mcasp0_pins[] __initda
 	-1
 };
 
-const short da830_mcasp1_pins[] __initdata = {
+const short da830_mcasp1_pins[] __initconst = {
 	DA830_AHCLKX1, DA830_ACLKX1, DA830_AFSX1,
 	DA830_AHCLKR1, DA830_ACLKR1, DA830_AFSR1, DA830_AMUTE1,
 	DA830_AXR1_0, DA830_AXR1_1, DA830_AXR1_2, DA830_AXR1_3,
@@ -954,24 +954,24 @@ const short da830_mcasp1_pins[] __initda
 	-1
 };
 
-const short da830_mcasp2_pins[] __initdata = {
+const short da830_mcasp2_pins[] __initconst = {
 	DA830_AHCLKX2, DA830_ACLKX2, DA830_AFSX2,
 	DA830_AHCLKR2, DA830_ACLKR2, DA830_AFSR2, DA830_AMUTE2,
 	DA830_AXR2_0, DA830_AXR2_1, DA830_AXR2_2, DA830_AXR2_3,
 	-1
 };
 
-const short da830_i2c0_pins[] __initdata = {
+const short da830_i2c0_pins[] __initconst = {
 	DA830_I2C0_SDA, DA830_I2C0_SCL,
 	-1
 };
 
-const short da830_i2c1_pins[] __initdata = {
+const short da830_i2c1_pins[] __initconst = {
 	DA830_I2C1_SCL, DA830_I2C1_SDA,
 	-1
 };
 
-const short da830_lcdcntl_pins[] __initdata = {
+const short da830_lcdcntl_pins[] __initconst = {
 	DA830_LCD_D_0, DA830_LCD_D_1, DA830_LCD_D_2, DA830_LCD_D_3,
 	DA830_LCD_D_4, DA830_LCD_D_5, DA830_LCD_D_6, DA830_LCD_D_7,
 	DA830_LCD_D_8, DA830_LCD_D_9, DA830_LCD_D_10, DA830_LCD_D_11,
@@ -981,34 +981,34 @@ const short da830_lcdcntl_pins[] __initd
 	-1
 };
 
-const short da830_pwm_pins[] __initdata = {
+const short da830_pwm_pins[] __initconst = {
 	DA830_ECAP0_APWM0, DA830_ECAP1_APWM1, DA830_EPWM0B, DA830_EPWM0A,
 	DA830_EPWMSYNCI, DA830_EPWMSYNC0, DA830_ECAP2_APWM2, DA830_EHRPWMGLUETZ,
 	DA830_EPWM2B, DA830_EPWM2A, DA830_EPWM1B, DA830_EPWM1A,
 	-1
 };
 
-const short da830_ecap0_pins[] __initdata = {
+const short da830_ecap0_pins[] __initconst = {
 	DA830_ECAP0_APWM0,
 	-1
 };
 
-const short da830_ecap1_pins[] __initdata = {
+const short da830_ecap1_pins[] __initconst = {
 	DA830_ECAP1_APWM1,
 	-1
 };
 
-const short da830_ecap2_pins[] __initdata = {
+const short da830_ecap2_pins[] __initconst = {
 	DA830_ECAP2_APWM2,
 	-1
 };
 
-const short da830_eqep0_pins[] __initdata = {
+const short da830_eqep0_pins[] __initconst = {
 	DA830_EQEP0I, DA830_EQEP0S, DA830_EQEP0A, DA830_EQEP0B,
 	-1
 };
 
-const short da830_eqep1_pins[] __initdata = {
+const short da830_eqep1_pins[] __initconst = {
 	DA830_EQEP1I, DA830_EQEP1S, DA830_EQEP1A, DA830_EQEP1B,
 	-1
 };
diff -puN arch/arm/mach-davinci/da850.c~sections-fix-section-conflicts-in-arch-arm arch/arm/mach-davinci/da850.c
--- a/arch/arm/mach-davinci/da850.c~sections-fix-section-conflicts-in-arch-arm
+++ a/arch/arm/mach-davinci/da850.c
@@ -576,17 +576,17 @@ static const struct mux_config da850_pin
 #endif
 };
 
-const short da850_i2c0_pins[] __initdata = {
+const short da850_i2c0_pins[] __initconst = {
 	DA850_I2C0_SDA, DA850_I2C0_SCL,
 	-1
 };
 
-const short da850_i2c1_pins[] __initdata = {
+const short da850_i2c1_pins[] __initconst = {
 	DA850_I2C1_SCL, DA850_I2C1_SDA,
 	-1
 };
 
-const short da850_lcdcntl_pins[] __initdata = {
+const short da850_lcdcntl_pins[] __initconst = {
 	DA850_LCD_D_0, DA850_LCD_D_1, DA850_LCD_D_2, DA850_LCD_D_3,
 	DA850_LCD_D_4, DA850_LCD_D_5, DA850_LCD_D_6, DA850_LCD_D_7,
 	DA850_LCD_D_8, DA850_LCD_D_9, DA850_LCD_D_10, DA850_LCD_D_11,
diff -puN arch/arm/mach-msm/board-qsd8x50.c~sections-fix-section-conflicts-in-arch-arm arch/arm/mach-msm/board-qsd8x50.c
--- a/arch/arm/mach-msm/board-qsd8x50.c~sections-fix-section-conflicts-in-arch-arm
+++ a/arch/arm/mach-msm/board-qsd8x50.c
@@ -37,8 +37,8 @@
 #include "devices.h"
 #include "common.h"
 
-static const resource_size_t qsd8x50_surf_smc91x_base __initdata = 0x70000300;
-static const unsigned        qsd8x50_surf_smc91x_gpio __initdata = 156;
+static const resource_size_t qsd8x50_surf_smc91x_base __initconst = 0x70000300;
+static const unsigned        qsd8x50_surf_smc91x_gpio __initconst = 156;
 
 /* Leave smc91x resources empty here, as we'll fill them in
  * at run-time: they vary from board to board, and the true
diff -puN arch/arm/mach-omap2/display.c~sections-fix-section-conflicts-in-arch-arm arch/arm/mach-omap2/display.c
--- a/arch/arm/mach-omap2/display.c~sections-fix-section-conflicts-in-arch-arm
+++ a/arch/arm/mach-omap2/display.c
@@ -76,14 +76,14 @@ struct omap_dss_hwmod_data {
 	const int id;
 };
 
-static const struct omap_dss_hwmod_data omap2_dss_hwmod_data[] __initdata = {
+static const struct omap_dss_hwmod_data omap2_dss_hwmod_data[] __initconst = {
 	{ "dss_core", "omapdss_dss", -1 },
 	{ "dss_dispc", "omapdss_dispc", -1 },
 	{ "dss_rfbi", "omapdss_rfbi", -1 },
 	{ "dss_venc", "omapdss_venc", -1 },
 };
 
-static const struct omap_dss_hwmod_data omap3_dss_hwmod_data[] __initdata = {
+static const struct omap_dss_hwmod_data omap3_dss_hwmod_data[] __initconst = {
 	{ "dss_core", "omapdss_dss", -1 },
 	{ "dss_dispc", "omapdss_dispc", -1 },
 	{ "dss_rfbi", "omapdss_rfbi", -1 },
@@ -91,7 +91,7 @@ static const struct omap_dss_hwmod_data 
 	{ "dss_dsi1", "omapdss_dsi", 0 },
 };
 
-static const struct omap_dss_hwmod_data omap4_dss_hwmod_data[] __initdata = {
+static const struct omap_dss_hwmod_data omap4_dss_hwmod_data[] __initconst = {
 	{ "dss_core", "omapdss_dss", -1 },
 	{ "dss_dispc", "omapdss_dispc", -1 },
 	{ "dss_rfbi", "omapdss_rfbi", -1 },
_

Patches currently in -mm which might be from ak@linux.intel.com are

compilerh-add-__visible.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
sections-disable-const-sections-for-pa-risc-v2.patch
sections-fix-section-conflicts-in-arch-arm.patch
sections-fix-section-conflicts-in-arch-frv.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-arch-ia64.patch
sections-fix-section-conflicts-in-arch-mips.patch
sections-fix-section-conflicts-in-arch-powerpc.patch
sections-fix-section-conflicts-in-arch-score.patch
sections-fix-section-conflicts-in-arch-sh.patch
sections-fix-section-conflicts-in-arch-x86.patch
sections-fix-section-conflicts-in-drivers-atm.patch
sections-fix-section-conflicts-in-drivers-char.patch
sections-fix-section-conflicts-in-drivers-cpufreq.patch
sections-fix-section-conflicts-in-drivers-ide.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sections-fix-section-conflicts-in-drivers-mfd.patch
sections-fix-section-conflicts-in-drivers-mmc.patch
sections-fix-section-conflicts-in-drivers-net.patch
sections-fix-section-conflicts-in-drivers-net-hamradio.patch
sections-fix-section-conflicts-in-drivers-net-wan.patch
sections-fix-section-conflicts-in-drivers-platform-x86.patch
sections-fix-section-conflicts-in-drivers-scsi.patch
sections-fix-section-conflicts-in-drivers-video.patch
sections-fix-section-conflicts-in-mm-percpuc.patch
sections-fix-section-conflicts-in-net-can.patch
sections-fix-section-conflicts-in-net.patch
sections-fix-section-conflicts-in-sound.patch
sectons-fix-const-sections-for-crc32-table.patch
compat_ioctl-remove-unused-local-typedef.patch

