From: akpm@linux-foundation.org
Subject: + viafb-introduce-per-output-device-power-management.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:07 -0700
Message-ID: <201009212237.o8LMb7RR006782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0IUWhn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: introduce per output device power management
has been added to the -mm tree.  Its filename is
     viafb-introduce-per-output-device-power-management.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: introduce per output device power management
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Move common parts of dvi.c, lcd.c and vt1636.c to hw.c to start a per
output device power management.  There should be no runtime changes aside
that this patch enables the proc interface to enable/disable devices when
needed which greatly increases the chances that changes to the output
device configuration will work.  However the power management is not yet
complete so it might fail on some configurations.  As this area is quite
complex and touches undocumented things there is a slight chance of
regressions.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/dvi.c      |   25 ------
 drivers/video/via/hw.c       |  132 +++++++++++++++++++++++++++++----
 drivers/video/via/hw.h       |    9 +-
 drivers/video/via/lcd.c      |   10 --
 drivers/video/via/viafbdev.c |   16 ++--
 drivers/video/via/vt1636.c   |   56 --------------
 6 files changed, 137 insertions(+), 111 deletions(-)

diff -puN drivers/video/via/dvi.c~viafb-introduce-per-output-device-power-management drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~viafb-introduce-per-output-device-power-management
+++ a/drivers/video/via/dvi.c
@@ -470,26 +470,6 @@ static void __devinit dvi_get_panel_size
 void viafb_dvi_disable(void)
 {
 	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DVP0)
-		viafb_write_reg(SR1E, VIASR,
-		viafb_read_reg(VIASR, SR1E) & (~0xC0));
-
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DVP1)
-		viafb_write_reg(SR1E, VIASR,
-		viafb_read_reg(VIASR, SR1E) & (~0x30));
-
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DFP_HIGH)
-		viafb_write_reg(SR2A, VIASR,
-		viafb_read_reg(VIASR, SR2A) & (~0x0C));
-
-	if (viaparinfo->chip_info->
-		tmds_chip_info.output_interface == INTERFACE_DFP_LOW)
-		viafb_write_reg(SR2A, VIASR,
-		viafb_read_reg(VIASR, SR2A) & (~0x03));
-
-	if (viaparinfo->chip_info->
 		tmds_chip_info.output_interface == INTERFACE_TMDS)
 		/* Turn off TMDS power. */
 		viafb_write_reg(CRD2, VIACR,
@@ -571,7 +551,6 @@ void viafb_dvi_enable(void)
 	case INTERFACE_DVP0:
 		viafb_write_reg_mask(CR6B, VIACR, 0x01, BIT0);
 		viafb_write_reg_mask(CR6C, VIACR, 0x21, BIT0 + BIT5);
-		viafb_write_reg_mask(SR1E, VIASR, 0xC0, BIT7 + BIT6);
 		dvi_patch_skew_dvp0();
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			tmds_register_write(0x88, 0x3b);
@@ -585,7 +564,6 @@ void viafb_dvi_enable(void)
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			viafb_write_reg_mask(CR93, VIACR, 0x21, BIT0 + BIT5);
 
-		viafb_write_reg_mask(SR1E, VIASR, 0x30, BIT4 + BIT5);
 		/*fix dvi cann't be enabled with MB VT5718C4 - Al Zhang */
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			tmds_register_write(0x88, 0x3b);
@@ -616,14 +594,13 @@ void viafb_dvi_enable(void)
 		if (viaparinfo->chip_info->gfx_chip_name != UNICHROME_CLE266)
 			via_write_reg_mask(VIACR, CR97, 0x03, 0x03);
 
-		viafb_write_reg_mask(SR2A, VIASR, 0x0C, BIT2 + BIT3);
 		via_write_reg_mask(VIACR, 0x91, 0x00, 0x20);
 		break;
 
 	case INTERFACE_DFP_LOW:
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			break;
-		viafb_write_reg_mask(SR2A, VIASR, 0x03, BIT0 + BIT1);
+
 		dvi_patch_skew_dvp_low();
 		via_write_reg_mask(VIACR, 0x91, 0x00, 0x20);
 		break;
diff -puN drivers/video/via/hw.c~viafb-introduce-per-output-device-power-management drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-introduce-per-output-device-power-management
+++ a/drivers/video/via/hw.c
@@ -1036,6 +1036,121 @@ void via_set_source(u32 devices, u8 iga)
 		set_lvds2_source(iga);
 }
 
+static void set_crt_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x00;
+		break;
+	case VIA_STATE_STANDBY:
+		value = 0x10;
+		break;
+	case VIA_STATE_SUSPEND:
+		value = 0x20;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x30;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIACR, 0x36, value, 0x30);
+}
+
+static void set_96_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0xC0;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x1E, value, 0xC0);
+}
+
+static void set_dvp1_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x30;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x1E, value, 0x30);
+}
+
+static void set_lvds1_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x03;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x2A, value, 0x03);
+}
+
+static void set_lvds2_state(u8 state)
+{
+	u8 value;
+
+	switch (state) {
+	case VIA_STATE_ON:
+		value = 0x0C;
+		break;
+	case VIA_STATE_OFF:
+		value = 0x00;
+		break;
+	default:
+		return;
+	}
+
+	via_write_reg_mask(VIASR, 0x2A, value, 0x0C);
+}
+
+void via_set_state(u32 devices, u8 state)
+{
+	/*
+	TODO: Can we enable/disable these devices? How?
+	if (devices & VIA_6C)
+	if (devices & VIA_93)
+	*/
+	if (devices & VIA_96)
+		set_96_state(state);
+	if (devices & VIA_CRT)
+		set_crt_state(state);
+	if (devices & VIA_DVP1)
+		set_dvp1_state(state);
+	if (devices & VIA_LVDS1)
+		set_lvds1_state(state);
+	if (devices & VIA_LVDS2)
+		set_lvds2_state(state);
+}
+
 u32 via_parse_odev(char *input, char **end)
 {
 	char *ptr = input;
@@ -2224,6 +2339,8 @@ int viafb_setmode(struct VideoModeTable 
 {
 	int i, j;
 	int port;
+	u32 devices = viaparinfo->shared->iga1_devices
+		| viaparinfo->shared->iga2_devices;
 	u8 value, index, mask;
 	struct crt_mode_table *crt_timing;
 	struct crt_mode_table *crt_timing1 = NULL;
@@ -2271,6 +2388,7 @@ int viafb_setmode(struct VideoModeTable 
 	}
 
 	device_off();
+	via_set_state(devices, VIA_STATE_OFF);
 
 	/* Fill VPIT Parameters */
 	/* Write Misc Register */
@@ -2430,6 +2548,7 @@ int viafb_setmode(struct VideoModeTable 
 			viafb_DeviceStatus = CRT_Device;
 	}
 	device_on();
+	via_set_state(devices, VIA_STATE_ON);
 	device_screen_on();
 	return 1;
 }
@@ -2470,31 +2589,18 @@ int viafb_get_refresh(int hres, int vres
 
 static void device_off(void)
 {
-	viafb_crt_disable();
 	viafb_dvi_disable();
 	viafb_lcd_disable();
 }
 
 static void device_on(void)
 {
-	if (viafb_CRT_ON == 1)
-		viafb_crt_enable();
 	if (viafb_DVI_ON == 1)
 		viafb_dvi_enable();
 	if (viafb_LCD_ON == 1)
 		viafb_lcd_enable();
 }
 
-void viafb_crt_disable(void)
-{
-	viafb_write_reg_mask(CR36, VIACR, BIT5 + BIT4, BIT5 + BIT4);
-}
-
-void viafb_crt_enable(void)
-{
-	viafb_write_reg_mask(CR36, VIACR, 0x0, BIT5 + BIT4);
-}
-
 static void enable_second_display_channel(void)
 {
 	/* to enable second display channel. */
diff -puN drivers/video/via/hw.h~viafb-introduce-per-output-device-power-management drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-introduce-per-output-device-power-management
+++ a/drivers/video/via/hw.h
@@ -41,6 +41,12 @@
 #define VIA_LVDS1	0x00000040
 #define VIA_LVDS2	0x00000080
 
+/* VIA output device power states */
+#define VIA_STATE_ON		0
+#define VIA_STATE_STANDBY	1
+#define VIA_STATE_SUSPEND	2
+#define VIA_STATE_OFF		3
+
 /***************************************************
 * Definition IGA1 Design Method of CRTC Registers *
 ****************************************************/
@@ -904,9 +910,8 @@ void viafb_set_vclock(u32 CLK, int set_i
 void viafb_load_reg(int timing_value, int viafb_load_reg_num,
 	struct io_register *reg,
 	      int io_type);
-void viafb_crt_disable(void);
-void viafb_crt_enable(void);
 void via_set_source(u32 devices, u8 iga);
+void via_set_state(u32 devices, u8 state);
 u32 via_parse_odev(char *input, char **end);
 void via_odev_to_seq(struct seq_file *m, u32 odev);
 void init_ad9389(void);
diff -puN drivers/video/via/lcd.c~viafb-introduce-per-output-device-power-management drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-introduce-per-output-device-power-management
+++ a/drivers/video/via/lcd.c
@@ -703,9 +703,6 @@ static void integrated_lvds_disable(stru
 		viafb_write_reg_mask(CR91, VIACR, 0xC0, BIT6 + BIT7);
 	}
 
-	/* Turn DFP High/Low Pad off. */
-	viafb_write_reg_mask(SR2A, VIASR, 0, BIT0 + BIT1 + BIT2 + BIT3);
-
 	/* Power off LVDS channel. */
 	switch (plvds_chip_info->output_interface) {
 	case INTERFACE_LVDS0:
@@ -761,9 +758,6 @@ static void integrated_lvds_enable(struc
 		break;
 	}
 
-	/* Turn DFP High/Low pad on. */
-	viafb_write_reg_mask(SR2A, VIASR, 0x0F, BIT0 + BIT1 + BIT2 + BIT3);
-
 	/* Power on LVDS channel. */
 	switch (plvds_chip_info->output_interface) {
 	case INTERFACE_LVDS0:
@@ -812,8 +806,6 @@ void viafb_lcd_disable(void)
 		viafb_disable_lvds_vt1636(viaparinfo->lvds_setting_info,
 				    &viaparinfo->chip_info->lvds_chip_info);
 	} else {
-		/* DFP-HL pad off          */
-		viafb_write_reg_mask(SR2A, VIASR, 0x00, 0x0F);
 		/* Backlight off           */
 		viafb_write_reg_mask(SR3D, VIASR, 0x00, 0x20);
 		/* 24 bit DI data paht off */
@@ -879,8 +871,6 @@ void viafb_lcd_enable(void)
 		viafb_enable_lvds_vt1636(viaparinfo->lvds_setting_info,
 				   &viaparinfo->chip_info->lvds_chip_info);
 	} else {
-		/* DFP-HL pad on           */
-		viafb_write_reg_mask(SR2A, VIASR, 0x0F, 0x0F);
 		/* Backlight on            */
 		viafb_write_reg_mask(SR3D, VIASR, 0x20, 0x20);
 		/* 24 bit DI data paht on  */
diff -puN drivers/video/via/viafbdev.c~viafb-introduce-per-output-device-power-management drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-introduce-per-output-device-power-management
+++ a/drivers/video/via/viafbdev.c
@@ -332,22 +332,22 @@ static int viafb_blank(int blank_mode, s
 	case FB_BLANK_UNBLANK:
 		/* Screen: On, HSync: On, VSync: On */
 		/* control CRT monitor power management */
-		viafb_write_reg_mask(CR36, VIACR, 0x00, BIT4 + BIT5);
+		via_set_state(VIA_CRT, VIA_STATE_ON);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
 		/* Screen: Off, HSync: Off, VSync: On */
 		/* control CRT monitor power management */
-		viafb_write_reg_mask(CR36, VIACR, 0x10, BIT4 + BIT5);
+		via_set_state(VIA_CRT, VIA_STATE_STANDBY);
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
 		/* Screen: Off, HSync: On, VSync: Off */
 		/* control CRT monitor power management */
-		viafb_write_reg_mask(CR36, VIACR, 0x20, BIT4 + BIT5);
+		via_set_state(VIA_CRT, VIA_STATE_SUSPEND);
 		break;
 	case FB_BLANK_POWERDOWN:
 		/* Screen: Off, HSync: Off, VSync: Off */
 		/* control CRT monitor power management */
-		viafb_write_reg_mask(CR36, VIACR, 0x30, BIT4 + BIT5);
+		via_set_state(VIA_CRT, VIA_STATE_OFF);
 		break;
 	}
 
@@ -457,7 +457,7 @@ static int viafb_ioctl(struct fb_info *i
 		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
 			return -EFAULT;
 		if (gpu32 & CRT_Device)
-			viafb_crt_enable();
+			via_set_state(VIA_CRT, VIA_STATE_ON);
 		if (gpu32 & DVI_Device)
 			viafb_dvi_enable();
 		if (gpu32 & LCD_Device)
@@ -467,7 +467,7 @@ static int viafb_ioctl(struct fb_info *i
 		if (copy_from_user(&gpu32, argp, sizeof(gpu32)))
 			return -EFAULT;
 		if (gpu32 & CRT_Device)
-			viafb_crt_disable();
+			via_set_state(VIA_CRT, VIA_STATE_OFF);
 		if (gpu32 & DVI_Device)
 			viafb_dvi_disable();
 		if (gpu32 & LCD_Device)
@@ -1487,7 +1487,9 @@ static ssize_t viafb_iga1_odev_proc_writ
 	dev_on = dev_new & ~dev_old;
 	viaparinfo->shared->iga1_devices = dev_new;
 	viaparinfo->shared->iga2_devices &= ~dev_new;
+	via_set_state(dev_off, VIA_STATE_OFF);
 	via_set_source(dev_new, IGA1);
+	via_set_state(dev_on, VIA_STATE_ON);
 	return res;
 }
 
@@ -1525,7 +1527,9 @@ static ssize_t viafb_iga2_odev_proc_writ
 	dev_on = dev_new & ~dev_old;
 	viaparinfo->shared->iga2_devices = dev_new;
 	viaparinfo->shared->iga1_devices &= ~dev_new;
+	via_set_state(dev_off, VIA_STATE_OFF);
 	via_set_source(dev_new, IGA2);
+	via_set_state(dev_on, VIA_STATE_ON);
 	return res;
 }
 
diff -puN drivers/video/via/vt1636.c~viafb-introduce-per-output-device-power-management drivers/video/via/vt1636.c
--- a/drivers/video/via/vt1636.c~viafb-introduce-per-output-device-power-management
+++ a/drivers/video/via/vt1636.c
@@ -92,34 +92,6 @@ void viafb_enable_lvds_vt1636(struct lvd
 
 	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
 				 VDD_ON_TBL_VT1636[0]);
-
-	/* Pad on: */
-	switch (plvds_chip_info->output_interface) {
-	case INTERFACE_DVP0:
-		{
-			viafb_write_reg_mask(SR1E, VIASR, 0xC0, 0xC0);
-			break;
-		}
-
-	case INTERFACE_DVP1:
-		{
-			viafb_write_reg_mask(SR1E, VIASR, 0x30, 0x30);
-			break;
-		}
-
-	case INTERFACE_DFP_LOW:
-		{
-			viafb_write_reg_mask(SR2A, VIASR, 0x03, 0x03);
-			break;
-		}
-
-	case INTERFACE_DFP_HIGH:
-		{
-			viafb_write_reg_mask(SR2A, VIASR, 0x03, 0x0C);
-			break;
-		}
-
-	}
 }
 
 void viafb_disable_lvds_vt1636(struct lvds_setting_information
@@ -129,34 +101,6 @@ void viafb_disable_lvds_vt1636(struct lv
 
 	viafb_gpio_i2c_write_mask_lvds(plvds_setting_info, plvds_chip_info,
 				 VDD_OFF_TBL_VT1636[0]);
-
-	/* Pad off: */
-	switch (plvds_chip_info->output_interface) {
-	case INTERFACE_DVP0:
-		{
-			viafb_write_reg_mask(SR1E, VIASR, 0x00, 0xC0);
-			break;
-		}
-
-	case INTERFACE_DVP1:
-		{
-			viafb_write_reg_mask(SR1E, VIASR, 0x00, 0x30);
-			break;
-		}
-
-	case INTERFACE_DFP_LOW:
-		{
-			viafb_write_reg_mask(SR2A, VIASR, 0x00, 0x03);
-			break;
-		}
-
-	case INTERFACE_DFP_HIGH:
-		{
-			viafb_write_reg_mask(SR2A, VIASR, 0x00, 0x0C);
-			break;
-		}
