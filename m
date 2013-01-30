From: akpm@linux-foundation.org
Subject: + arm-mmp-enable-display-in-ttc_dkb.patch added to -mm tree
Date: Wed, 30 Jan 2013 13:50:19 -0800
Message-ID: <20130130215019.77BAE31C102@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:54647 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995Ab3A3VuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Jan 2013 16:50:20 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so209379vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Jan 2013 13:50:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zzhu3@marvell.com, FlorianSchandinat@gmx.de, cldu@marvell.com, haojian.zhuang@gmail.com, ligq@marvell.com


The patch titled
     Subject: ARM: mmp: enable display in ttc_dkb
has been added to the -mm tree.  Its filename is
     arm-mmp-enable-display-in-ttc_dkb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Zhu <zzhu3@marvell.com>
Subject: ARM: mmp: enable display in ttc_dkb

Enable display in ttc_dkb.

Signed-off-by: Zhou Zhu <zzhu3@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Cc: Lisa Du <cldu@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-mmp/ttc_dkb.c |   92 ++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff -puN arch/arm/mach-mmp/ttc_dkb.c~arm-mmp-enable-display-in-ttc_dkb arch/arm/mach-mmp/ttc_dkb.c
--- a/arch/arm/mach-mmp/ttc_dkb.c~arm-mmp-enable-display-in-ttc_dkb
+++ a/arch/arm/mach-mmp/ttc_dkb.c
@@ -19,6 +19,8 @@
 #include <linux/gpio.h>
 #include <linux/mfd/88pm860x.h>
 #include <linux/platform_data/mv_usb.h>
+#include <linux/spi/spi.h>
+#include <linux/delay.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -184,6 +186,92 @@ static struct pxa3xx_nand_platform_data 
 };
 #endif
 
+#ifdef CONFIG_MMP_DISP
+/* path config */
+#define CFG_IOPADMODE(iopad)   (iopad)  /* 0x0 ~ 0xd */
+#define SCLK_SOURCE_SELECT(x)  (x << 30) /* 0x0 ~ 0x3 */
+/* link config */
+#define CFG_DUMBMODE(mode)     (mode << 28) /* 0x0 ~ 0x6*/
+#define CFG_GRA_SWAPRB(x)      (x << 0) /* 1: rbswap enabled */
+static struct mmp_mach_path_config dkb_disp_config[] = {
+	[0] = {
+		.name = "mmp-parallel",
+		.ovly_num = 2,
+		.output_type = PATH_OUT_PARALLEL,
+		.path_config = CFG_IOPADMODE(0x1)
+			| SCLK_SOURCE_SELECT(0x1),
+		.link_config = CFG_DUMBMODE(0x2)
+			| CFG_GRA_SWAPRB(0x1),
+	},
+};
+
+static struct mmp_mach_plat_info dkb_disp_info = {
+	.name = "mmp-disp",
+	.clk_name = "disp0",
+	.path_num = 1,
+	.paths = dkb_disp_config,
+};
+
+static struct mmp_buffer_driver_mach_info dkb_fb_info = {
+	.name = "mmp-fb",
+	.path_name = "mmp-parallel",
+	.ovly_id = 0,
+	.dmafetch_id = 1,
+	.default_pixfmt = PIXFMT_RGB565,
+};
+
+static void dkb_tpo_panel_power(int on)
+{
+	int err;
+	u32 spi_reset = mfp_to_gpio(MFP_PIN_GPIO106);
+
+	if (on) {
+		err = gpio_request(spi_reset, "TPO_LCD_SPI_RESET");
+		if (err) {
+			pr_err("failed to request GPIO for TPO LCD RESET\n");
+			return;
+		}
+		gpio_direction_output(spi_reset, 0);
+		udelay(100);
+		gpio_set_value(spi_reset, 1);
+		gpio_free(spi_reset);
+	} else {
+		err = gpio_request(spi_reset, "TPO_LCD_SPI_RESET");
+		if (err) {
+			pr_err("failed to request LCD RESET gpio\n");
+			return;
+		}
+		gpio_set_value(spi_reset, 0);
+		gpio_free(spi_reset);
+	}
+}
+
+static struct mmp_mach_panel_info dkb_tpo_panel_info = {
+	.name = "tpo-hvga",
+	.plat_path_name = "mmp-parallel",
+	.plat_set_onoff = dkb_tpo_panel_power,
+};
+
+static struct spi_board_info spi_board_info[] __initdata = {
+	{
+		.modalias       = "tpo-hvga",
+		.platform_data  = &dkb_tpo_panel_info,
+		.bus_num        = 5,
+	}
+};
+
+static void __init add_disp(void)
+{
+	pxa_register_device(&pxa910_device_disp,
+		&dkb_disp_info, sizeof(dkb_disp_info));
+	spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
+	pxa_register_device(&pxa910_device_fb,
+		&dkb_fb_info, sizeof(dkb_fb_info));
+	pxa_register_device(&pxa910_device_panel,
+		&dkb_tpo_panel_info, sizeof(dkb_tpo_panel_info));
+}
+#endif
+
 static void __init ttc_dkb_init(void)
 {
 	mfp_config(ARRAY_AND_SIZE(ttc_dkb_pin_config));
@@ -212,6 +300,10 @@ static void __init ttc_dkb_init(void)
 	pxa168_device_u2ootg.dev.platform_data = &ttc_usb_pdata;
 	platform_device_register(&pxa168_device_u2ootg);
 #endif
+
+#ifdef CONFIG_MMP_DISP
+	add_disp();
+#endif
 }
 
 MACHINE_START(TTC_DKB, "PXA910-based TTC_DKB Development Platform")
_

Patches currently in -mm which might be from zzhu3@marvell.com are

video-mmp-display-subsystem.patch
video-mmp-fb-support.patch
video-mmp-display-controller-support.patch
video-mmp-add-tpo-hvga-panel-supported.patch
video-mmpdisp-add-spi-port-in-display-controller.patch
arm-mmp-add-device-for-display-controller.patch
arm-mmp-enable-display-in-ttc_dkb.patch
arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch

