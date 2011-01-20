From: akpm@linux-foundation.org
Subject: [to-be-updated] backlight-add-backlight-type.patch removed from -mm tree
Date: Thu, 20 Jan 2011 15:14:29 -0800
Message-ID: <201101202314.p0KNETcc008352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab1ATXPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 18:15:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, airlied@linux.ie, alexdeucher@gmail.com, bskeggs@redhat.com, chris@chris-wilson.co.uk, jbarnes@virtuousgeek.org, lenb@kernel.org, rpurdie@rpsys.net, rui.zhang@intel.co


The patch titled
     backlight: add backlight type
has been removed from the -mm tree.  Its filename was
     backlight-add-backlight-type.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: add backlight type
From: Matthew Garrett <mjg@redhat.com>

There may be multiple ways of controlling the backlight on a given
machine.  Allow drivers to expose the type of interface they are
providing, making it possible for userspace to make appropriate policy
decisions.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-class-backlight         |   20 ++++++++
 drivers/acpi/video.c                                   |    1 
 drivers/gpu/drm/nouveau/nouveau_backlight.c            |    2 
 drivers/hid/hid-picolcd.c                              |    1 
 drivers/macintosh/via-pmu-backlight.c                  |    1 
 drivers/platform/x86/acer-wmi.c                        |    1 
 drivers/platform/x86/asus-laptop.c                     |    1 
 drivers/platform/x86/asus_acpi.c                       |    1 
 drivers/platform/x86/classmate-laptop.c                |    1 
 drivers/platform/x86/compal-laptop.c                   |    1 
 drivers/platform/x86/dell-laptop.c                     |    1 
 drivers/platform/x86/eeepc-laptop.c                    |    1 
 drivers/platform/x86/eeepc-wmi.c                       |    1 
 drivers/platform/x86/fujitsu-laptop.c                  |    1 
 drivers/platform/x86/msi-laptop.c                      |    1 
 drivers/platform/x86/msi-wmi.c                         |    1 
 drivers/platform/x86/panasonic-laptop.c                |    1 
 drivers/platform/x86/sony-laptop.c                     |    1 
 drivers/platform/x86/thinkpad_acpi.c                   |    1 
 drivers/platform/x86/toshiba_acpi.c                    |    1 
 drivers/staging/olpc_dcon/olpc_dcon.c                  |    1 
 drivers/staging/samsung-laptop/samsung-laptop.c        |    1 
 drivers/usb/misc/appledisplay.c                        |    1 
 drivers/video/atmel_lcdfb.c                            |    1 
 drivers/video/aty/aty128fb.c                           |    1 
 drivers/video/aty/atyfb_base.c                         |    1 
 drivers/video/aty/radeon_backlight.c                   |    1 
 drivers/video/backlight/88pm860x_bl.c                  |    1 
 drivers/video/backlight/adp5520_bl.c                   |    1 
 drivers/video/backlight/adp8860_bl.c                   |    1 
 drivers/video/backlight/adx_bl.c                       |    1 
 drivers/video/backlight/atmel-pwm-bl.c                 |    1 
 drivers/video/backlight/backlight.c                    |   24 +++++++++-
 drivers/video/backlight/corgi_lcd.c                    |    1 
 drivers/video/backlight/cr_bllcd.c                     |    1 
 drivers/video/backlight/da903x_bl.c                    |    1 
 drivers/video/backlight/ep93xx_bl.c                    |    1 
 drivers/video/backlight/generic_bl.c                   |    1 
 drivers/video/backlight/hp680_bl.c                     |    1 
 drivers/video/backlight/jornada720_bl.c                |    1 
 drivers/video/backlight/kb3886_bl.c                    |    1 
 drivers/video/backlight/locomolcd.c                    |    1 
 drivers/video/backlight/max8925_bl.c                   |    1 
 drivers/video/backlight/mbp_nvidia_bl.c                |    1 
 drivers/video/backlight/omap1_bl.c                     |    1 
 drivers/video/backlight/pcf50633-backlight.c           |    1 
 drivers/video/backlight/progear_bl.c                   |    1 
 drivers/video/backlight/pwm_bl.c                       |    1 
 drivers/video/backlight/s6e63m0.c                      |    1 
 drivers/video/backlight/tosa_bl.c                      |    1 
 drivers/video/backlight/wm831x_bl.c                    |    1 
 drivers/video/bf54x-lq043fb.c                          |    1 
 drivers/video/bfin-t350mcqb-fb.c                       |    1 
 drivers/video/imxfb.c                                  |    1 
 drivers/video/nvidia/nv_backlight.c                    |    1 
 drivers/video/omap2/displays/panel-acx565akm.c         |    1 
 drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c |    1 
 drivers/video/omap2/displays/panel-taal.c              |    2 
 drivers/video/riva/fbdev.c                             |    1 
 include/linux/backlight.h                              |    9 +++
 60 files changed, 111 insertions(+), 1 deletion(-)

diff -puN Documentation/ABI/stable/sysfs-class-backlight~backlight-add-backlight-type Documentation/ABI/stable/sysfs-class-backlight
--- a/Documentation/ABI/stable/sysfs-class-backlight~backlight-add-backlight-type
+++ a/Documentation/ABI/stable/sysfs-class-backlight
@@ -34,3 +34,23 @@ Contact:	Richard Purdie <rpurdie@rpsys.n
 Description:
 		Maximum brightness for <backlight>.
 Users:		HAL
+
+What:		/sys/class/backlight/<backlight>/type
+Date:		September 2010
+KernelVersion:	2.6.37
+Contact:	Matthew Garrett <mjg@redhat.com>
+Description:
+		The type of interface controlled by <backlight>.
+		"firmware": The driver uses a standard firmware interface
+		"platform": The driver uses a platform-specific interface
+		"raw": The driver controls hardware registers directly
+
+		In the general case, when multiple backlight
+		interfaces are available for a single device, firmware
+		control should be preferred to platform control should
+		be preferred to raw control. Using a firmware
+		interface reduces the probability of confusion with
+		the hardware and the OS independently updating the
+		backlight state. Platform interfaces are mostly a
+		holdover from pre-standardisation of firmware
+		interfaces.
diff -puN drivers/acpi/video.c~backlight-add-backlight-type drivers/acpi/video.c
--- a/drivers/acpi/video.c~backlight-add-backlight-type
+++ a/drivers/acpi/video.c
@@ -795,6 +795,7 @@ static void acpi_video_device_find_cap(s
 		count++;
 
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_FIRMWARE;
 		props.max_brightness = device->brightness->count - 3;
 		device->backlight = backlight_device_register(name, NULL, device,
 							      &acpi_backlight_ops,
diff -puN drivers/gpu/drm/nouveau/nouveau_backlight.c~backlight-add-backlight-type drivers/gpu/drm/nouveau/nouveau_backlight.c
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c~backlight-add-backlight-type
+++ a/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -98,6 +98,7 @@ static int nouveau_nv40_backlight_init(s
 		return 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 31;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
 				       &nv40_bl_ops, &props);
@@ -121,6 +122,7 @@ static int nouveau_nv50_backlight_init(s
 		return 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 1025;
 	bd = backlight_device_register("nv_backlight", &dev->pdev->dev, dev,
 				       &nv50_bl_ops, &props);
diff -puN drivers/hid/hid-picolcd.c~backlight-add-backlight-type drivers/hid/hid-picolcd.c
--- a/drivers/hid/hid-picolcd.c~backlight-add-backlight-type
+++ a/drivers/hid/hid-picolcd.c
@@ -944,6 +944,7 @@ static int picolcd_init_backlight(struct
 	}
 
 	memset(&props, 0, sizeof(props));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	bdev = backlight_device_register(dev_name(dev), dev, data,
 			&picolcd_blops, &props);
diff -puN drivers/macintosh/via-pmu-backlight.c~backlight-add-backlight-type drivers/macintosh/via-pmu-backlight.c
--- a/drivers/macintosh/via-pmu-backlight.c~backlight-add-backlight-type
+++ a/drivers/macintosh/via-pmu-backlight.c
@@ -163,6 +163,7 @@ void __init pmu_backlight_init()
 	snprintf(name, sizeof(name), "pmubl");
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, NULL, NULL, &pmu_backlight_data,
 				       &props);
diff -puN drivers/platform/x86/acer-wmi.c~backlight-add-backlight-type drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/acer-wmi.c
@@ -1032,6 +1032,7 @@ static int __devinit acer_backlight_init
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = max_brightness;
 	bd = backlight_device_register("acer-wmi", dev, NULL, &acer_bl_ops,
 				       &props);
diff -puN drivers/platform/x86/asus-laptop.c~backlight-add-backlight-type drivers/platform/x86/asus-laptop.c
--- a/drivers/platform/x86/asus-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/asus-laptop.c
@@ -667,6 +667,7 @@ static int asus_backlight_init(struct as
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 15;
+	props.type = BACKLIGHT_PLATFORM;
 
 	bd = backlight_device_register(ASUS_LAPTOP_FILE,
 				       &asus->platform_device->dev, asus,
diff -puN drivers/platform/x86/asus_acpi.c~backlight-add-backlight-type drivers/platform/x86/asus_acpi.c
--- a/drivers/platform/x86/asus_acpi.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/asus_acpi.c
@@ -1513,6 +1513,7 @@ static int __init asus_acpi_init(void)
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	asus_backlight_device = backlight_device_register("asus", NULL, NULL,
 							  &asus_backlight_data,
diff -puN drivers/platform/x86/classmate-laptop.c~backlight-add-backlight-type drivers/platform/x86/classmate-laptop.c
--- a/drivers/platform/x86/classmate-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/classmate-laptop.c
@@ -564,6 +564,7 @@ static int cmpc_ipml_add(struct acpi_dev
 		return -ENOMEM;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 7;
 	ipml->bd = backlight_device_register("cmpc_bl", &acpi->dev,
 					     acpi->handle, &cmpc_bl_ops,
diff -puN drivers/platform/x86/compal-laptop.c~backlight-add-backlight-type drivers/platform/x86/compal-laptop.c
--- a/drivers/platform/x86/compal-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/compal-laptop.c
@@ -970,6 +970,7 @@ static int __init compal_init(void)
 	if (!acpi_video_backlight_support()) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = BACKLIGHT_LEVEL_MAX;
 		compalbl_device = backlight_device_register(DRIVER_NAME,
 							    NULL, NULL,
diff -puN drivers/platform/x86/dell-laptop.c~backlight-add-backlight-type drivers/platform/x86/dell-laptop.c
--- a/drivers/platform/x86/dell-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/dell-laptop.c
@@ -651,6 +651,7 @@ static int __init dell_init(void)
 	if (max_intensity) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = max_intensity;
 		dell_backlight_device = backlight_device_register("dell_backlight",
 								  &platform_device->dev,
diff -puN drivers/platform/x86/eeepc-laptop.c~backlight-add-backlight-type drivers/platform/x86/eeepc-laptop.c
--- a/drivers/platform/x86/eeepc-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/eeepc-laptop.c
@@ -1147,6 +1147,7 @@ static int eeepc_backlight_init(struct e
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	bd = backlight_device_register(EEEPC_LAPTOP_FILE,
 				       &eeepc->platform_device->dev, eeepc,
diff -puN drivers/platform/x86/eeepc-wmi.c~backlight-add-backlight-type drivers/platform/x86/eeepc-wmi.c
--- a/drivers/platform/x86/eeepc-wmi.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/eeepc-wmi.c
@@ -518,6 +518,7 @@ static int eeepc_wmi_backlight_init(stru
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 15;
+	props.type = BACKLIGHT_PLATFORM;
 	bd = backlight_device_register(EEEPC_WMI_FILE,
 				       &eeepc->platform_device->dev, eeepc,
 				       &eeepc_wmi_bl_ops, &props);
diff -puN drivers/platform/x86/fujitsu-laptop.c~backlight-add-backlight-type drivers/platform/x86/fujitsu-laptop.c
--- a/drivers/platform/x86/fujitsu-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/fujitsu-laptop.c
@@ -1128,6 +1128,7 @@ static int __init fujitsu_init(void)
 
 		memset(&props, 0, sizeof(struct backlight_properties));
 		max_brightness = fujitsu->max_brightness;
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = max_brightness - 1;
 		fujitsu->bl_device = backlight_device_register("fujitsu-laptop",
 							       NULL, NULL,
diff -puN drivers/platform/x86/msi-laptop.c~backlight-add-backlight-type drivers/platform/x86/msi-laptop.c
--- a/drivers/platform/x86/msi-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/msi-laptop.c
@@ -804,6 +804,7 @@ static int __init msi_init(void)
 	} else {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = MSI_LCD_LEVEL_MAX - 1;
 		msibl_device = backlight_device_register("msi-laptop-bl", NULL,
 							 NULL, &msibl_ops,
diff -puN drivers/platform/x86/msi-wmi.c~backlight-add-backlight-type drivers/platform/x86/msi-wmi.c
--- a/drivers/platform/x86/msi-wmi.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/msi-wmi.c
@@ -254,6 +254,7 @@ static int __init msi_wmi_init(void)
 	if (!acpi_video_backlight_support()) {
 		struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = ARRAY_SIZE(backlight_map) - 1;
 		backlight = backlight_device_register(DRV_NAME, NULL, NULL,
 						      &msi_backlight_ops,
diff -puN drivers/platform/x86/panasonic-laptop.c~backlight-add-backlight-type drivers/platform/x86/panasonic-laptop.c
--- a/drivers/platform/x86/panasonic-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/panasonic-laptop.c
@@ -602,6 +602,7 @@ static int acpi_pcc_hotkey_add(struct ac
 	}
 	/* initialize backlight */
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = pcc->sinf[SINF_AC_MAX_BRIGHT];
 	pcc->backlight = backlight_device_register("panasonic", NULL, pcc,
 						   &pcc_backlight_ops, &props);
diff -puN drivers/platform/x86/sony-laptop.c~backlight-add-backlight-type drivers/platform/x86/sony-laptop.c
--- a/drivers/platform/x86/sony-laptop.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/sony-laptop.c
@@ -1307,6 +1307,7 @@ static int sony_nc_add(struct acpi_devic
 						&handle))) {
 							struct backlight_properties props;
 		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_PLATFORM;
 		props.max_brightness = SONY_MAX_BRIGHTNESS - 1;
 		sony_backlight_device = backlight_device_register("sony", NULL,
 								  NULL,
diff -puN drivers/platform/x86/thinkpad_acpi.c~backlight-add-backlight-type drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/thinkpad_acpi.c
@@ -6311,6 +6311,7 @@ static int __init brightness_init(struct
 		return 1;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = bright_maxlvl;
 	props.brightness = b & TP_EC_BACKLIGHT_LVLMSK;
 	ibm_backlight_device = backlight_device_register(TPACPI_BACKLIGHT_DEV_NAME,
diff -puN drivers/platform/x86/toshiba_acpi.c~backlight-add-backlight-type drivers/platform/x86/toshiba_acpi.c
--- a/drivers/platform/x86/toshiba_acpi.c~backlight-add-backlight-type
+++ a/drivers/platform/x86/toshiba_acpi.c
@@ -1018,6 +1018,7 @@ static int __init toshiba_acpi_init(void
 		create_toshiba_proc_entries();
 	}
 
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 	toshiba_backlight_device = backlight_device_register("toshiba",
 							     &toshiba_acpi.p_dev->dev,
diff -puN drivers/staging/olpc_dcon/olpc_dcon.c~backlight-add-backlight-type drivers/staging/olpc_dcon/olpc_dcon.c
--- a/drivers/staging/olpc_dcon/olpc_dcon.c~backlight-add-backlight-type
+++ a/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -716,6 +716,7 @@ static int dcon_probe(struct i2c_client 
 	}
 	else {
 		dcon_bl_dev->props.max_brightness = 15;
+		dcon_bl_dev->props.type = BACKLIGHT_RAW;
 		dcon_bl_dev->props.power = FB_BLANK_UNBLANK;
 		dcon_bl_dev->props.brightness = dcon_get_backlight();
 
diff -puN drivers/staging/samsung-laptop/samsung-laptop.c~backlight-add-backlight-type drivers/staging/samsung-laptop/samsung-laptop.c
--- a/drivers/staging/samsung-laptop/samsung-laptop.c~backlight-add-backlight-type
+++ a/drivers/staging/samsung-laptop/samsung-laptop.c
@@ -488,6 +488,7 @@ static int __init samsung_init(void)
 
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = MAX_BRIGHT;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
diff -puN drivers/usb/misc/appledisplay.c~backlight-add-backlight-type drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c~backlight-add-backlight-type
+++ a/drivers/usb/misc/appledisplay.c
@@ -282,6 +282,7 @@ static int appledisplay_probe(struct usb
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	pdata->bd = backlight_device_register(bl_name, NULL, pdata,
 					      &appledisplay_bl_data, &props);
diff -puN drivers/video/atmel_lcdfb.c~backlight-add-backlight-type drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~backlight-add-backlight-type
+++ a/drivers/video/atmel_lcdfb.c
@@ -127,6 +127,7 @@ static void init_backlight(struct atmel_
 		return;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	bl = backlight_device_register("backlight", &sinfo->pdev->dev, sinfo,
 				       &atmel_lcdc_bl_ops, &props);
diff -puN drivers/video/aty/aty128fb.c~backlight-add-backlight-type drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~backlight-add-backlight-type
+++ a/drivers/video/aty/aty128fb.c
@@ -1818,6 +1818,7 @@ static void aty128_bl_init(struct aty128
 	snprintf(name, sizeof(name), "aty128bl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &aty128_bl_data,
 				       &props);
diff -puN drivers/video/aty/atyfb_base.c~backlight-add-backlight-type drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~backlight-add-backlight-type
+++ a/drivers/video/aty/atyfb_base.c
@@ -2241,6 +2241,7 @@ static void aty_bl_init(struct atyfb_par
 	snprintf(name, sizeof(name), "atybl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &aty_bl_data,
 				       &props);
diff -puN drivers/video/aty/radeon_backlight.c~backlight-add-backlight-type drivers/video/aty/radeon_backlight.c
--- a/drivers/video/aty/radeon_backlight.c~backlight-add-backlight-type
+++ a/drivers/video/aty/radeon_backlight.c
@@ -158,6 +158,7 @@ void radeonfb_bl_init(struct radeonfb_in
 	snprintf(name, sizeof(name), "radeonbl%d", rinfo->info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, rinfo->info->dev, pdata,
 				       &radeon_bl_data, &props);
diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-add-backlight-type drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -227,6 +227,7 @@ static int pm860x_backlight_probe(struct
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
 	bl = backlight_device_register(name, &pdev->dev, data,
 					&pm860x_backlight_ops, &props);
diff -puN drivers/video/backlight/adp5520_bl.c~backlight-add-backlight-type drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -303,6 +303,7 @@ static int __devinit adp5520_bl_probe(st
 	mutex_init(&data->lock);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = ADP5020_MAX_BRIGHTNESS;
 	bl = backlight_device_register(pdev->name, data->master, data,
 				       &adp5520_bl_ops, &props);
diff -puN drivers/video/backlight/adp8860_bl.c~backlight-add-backlight-type drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -709,6 +709,7 @@ static int __devinit adp8860_probe(struc
 	i2c_set_clientdata(client, data);
 
 	memset(&props, 0, sizeof(props));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = ADP8860_MAX_BRIGHTNESS;
 
 	mutex_init(&data->lock);
diff -puN drivers/video/backlight/adx_bl.c~backlight-add-backlight-type drivers/video/backlight/adx_bl.c
--- a/drivers/video/backlight/adx_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/adx_bl.c
@@ -104,6 +104,7 @@ static int __devinit adx_backlight_probe
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
 	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
 					  bl, &adx_backlight_ops, &props);
diff -puN drivers/video/backlight/atmel-pwm-bl.c~backlight-add-backlight-type drivers/video/backlight/atmel-pwm-bl.c
--- a/drivers/video/backlight/atmel-pwm-bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/atmel-pwm-bl.c
@@ -168,6 +168,7 @@ static int atmel_pwm_bl_probe(struct pla
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
 	bldev = backlight_device_register("atmel-pwm-bl", &pdev->dev, pwmbl,
 					  &atmel_pwm_bl_ops, &props);
diff -puN drivers/video/backlight/backlight.c~backlight-add-backlight-type drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/backlight.c
@@ -19,6 +19,12 @@
 #include <asm/backlight.h>
 #endif
 
+static const char const *backlight_types[] = {
+	[BACKLIGHT_RAW] = "raw",
+	[BACKLIGHT_PLATFORM] = "platform",
+	[BACKLIGHT_FIRMWARE] = "firmware",
+};
+
 #if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
 			   defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE))
 /* This callback gets called when something important happens inside a
@@ -169,6 +175,14 @@ static ssize_t backlight_store_brightnes
 	return rc;
 }
 
+static ssize_t backlight_show_type(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	return sprintf(buf, "%s\n", backlight_types[bd->props.type]);
+}
+
 static ssize_t backlight_show_max_brightness(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -234,6 +248,7 @@ static struct device_attribute bl_device
 	__ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
 		     NULL),
 	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
+	__ATTR(type, 0444, backlight_show_type, NULL),
 	__ATTR_NULL,
 };
 
@@ -292,9 +307,16 @@ struct backlight_device *backlight_devic
 	dev_set_drvdata(&new_bd->dev, devdata);
 
 	/* Set default properties */
-	if (props)
+	if (props) {
 		memcpy(&new_bd->props, props,
 		       sizeof(struct backlight_properties));
+		if (props->type <= 0 || props->type >= BACKLIGHT_TYPE_MAX) {
+			WARN(1, "%s: invalid backlight type", name);
+			new_bd->props.type = BACKLIGHT_RAW;
+		}
+	} else {
+		new_bd->props.type = BACKLIGHT_RAW;
+	}
 
 	rc = device_register(&new_bd->dev);
 	if (rc) {
diff -puN drivers/video/backlight/corgi_lcd.c~backlight-add-backlight-type drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -562,6 +562,7 @@ static int __devinit corgi_lcd_probe(str
 	lcd->mode = (pdata) ? pdata->init_mode : CORGI_LCD_MODE_VGA;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->max_intensity;
 	lcd->bl_dev = backlight_device_register("corgi_bl", &spi->dev, lcd,
 						&corgi_bl_ops, &props);
diff -puN drivers/video/backlight/cr_bllcd.c~backlight-add-backlight-type drivers/video/backlight/cr_bllcd.c
--- a/drivers/video/backlight/cr_bllcd.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/cr_bllcd.c
@@ -193,6 +193,7 @@ static int cr_backlight_probe(struct pla
 	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	bdp = backlight_device_register("cr-backlight", &pdev->dev, NULL,
 					&cr_backlight_ops, &props);
 	if (IS_ERR(bdp)) {
diff -puN drivers/video/backlight/da903x_bl.c~backlight-add-backlight-type drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/da903x_bl.c
@@ -136,6 +136,7 @@ static int da903x_backlight_probe(struct
 		da903x_write(data->da903x_dev, DA9034_WLED_CONTROL2,
 				DA9034_WLED_ISET(pdata->output_current));
 
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_brightness;
 	bl = backlight_device_register(pdev->name, data->da903x_dev, data,
 				       &da903x_backlight_ops, &props);
diff -puN drivers/video/backlight/ep93xx_bl.c~backlight-add-backlight-type drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -87,6 +87,7 @@ static int __init ep93xxbl_probe(struct 
 	ep93xxbl->mmio = EP93XX_RASTER_BRIGHTNESS;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = EP93XX_MAX_BRIGHT;
 	bl = backlight_device_register(dev->name, &dev->dev, ep93xxbl,
 				       &ep93xxbl_ops, &props);
diff -puN drivers/video/backlight/generic_bl.c~backlight-add-backlight-type drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/generic_bl.c
@@ -91,6 +91,7 @@ static int genericbl_probe(struct platfo
 		name = machinfo->name;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
 	bd = backlight_device_register(name, &pdev->dev, NULL, &genericbl_ops,
 				       &props);
diff -puN drivers/video/backlight/hp680_bl.c~backlight-add-backlight-type drivers/video/backlight/hp680_bl.c
--- a/drivers/video/backlight/hp680_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/hp680_bl.c
@@ -109,6 +109,7 @@ static int __devinit hp680bl_probe(struc
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = HP680_MAX_INTENSITY;
 	bd = backlight_device_register("hp680-bl", &pdev->dev, NULL,
 				       &hp680bl_ops, &props);
diff -puN drivers/video/backlight/jornada720_bl.c~backlight-add-backlight-type drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -106,6 +106,7 @@ static int jornada_bl_probe(struct platf
 	struct backlight_device *bd;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = BL_MAX_BRIGHT;
 	bd = backlight_device_register(S1D_DEVICENAME, &pdev->dev, NULL,
 				       &jornada_bl_ops, &props);
diff -puN drivers/video/backlight/kb3886_bl.c~backlight-add-backlight-type drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -149,6 +149,7 @@ static int kb3886bl_probe(struct platfor
 		machinfo->limit_mask = -1;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = machinfo->max_intensity;
 	kb3886_backlight_device = backlight_device_register("kb3886-bl",
 							    &pdev->dev, NULL,
diff -puN drivers/video/backlight/locomolcd.c~backlight-add-backlight-type drivers/video/backlight/locomolcd.c
--- a/drivers/video/backlight/locomolcd.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/locomolcd.c
@@ -184,6 +184,7 @@ static int locomolcd_probe(struct locomo
 	local_irq_restore(flags);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 4;
 	locomolcd_bl_device = backlight_device_register("locomo-bl",
 							&ldev->dev, NULL,
diff -puN drivers/video/backlight/max8925_bl.c~backlight-add-backlight-type drivers/video/backlight/max8925_bl.c
--- a/drivers/video/backlight/max8925_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/max8925_bl.c
@@ -136,6 +136,7 @@ static int __devinit max8925_backlight_p
 	data->current_brightness = 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
 	bl = backlight_device_register(name, &pdev->dev, data,
 					&max8925_backlight_ops, &props);
diff -puN drivers/video/backlight/mbp_nvidia_bl.c~backlight-add-backlight-type drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -367,6 +367,7 @@ static int __init mbp_init(void)
 		return -ENXIO;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
 	mbp_backlight_device = backlight_device_register("mbp_backlight", NULL,
 							 NULL,
diff -puN drivers/video/backlight/omap1_bl.c~backlight-add-backlight-type drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/omap1_bl.c
@@ -146,6 +146,7 @@ static int omapbl_probe(struct platform_
 		return -ENOMEM;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
 	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
 					&props);
diff -puN drivers/video/backlight/pcf50633-backlight.c~backlight-add-backlight-type drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -112,6 +112,7 @@ static int __devinit pcf50633_bl_probe(s
 	if (!pcf_bl)
 		return -ENOMEM;
 
+	bl_props.type = BACKLIGHT_RAW;
 	bl_props.max_brightness = 0x3f;
 	bl_props.power = FB_BLANK_UNBLANK;
 
diff -puN drivers/video/backlight/progear_bl.c~backlight-add-backlight-type drivers/video/backlight/progear_bl.c
--- a/drivers/video/backlight/progear_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/progear_bl.c
@@ -84,6 +84,7 @@ static int progearbl_probe(struct platfo
 	pci_write_config_byte(sb_dev, SB_MPS1, temp | 0x20);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = HW_LEVEL_MAX - HW_LEVEL_MIN;
 	progear_backlight_device = backlight_device_register("progear-bl",
 							     &pdev->dev, NULL,
diff -puN drivers/video/backlight/pwm_bl.c~backlight-add-backlight-type drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/pwm_bl.c
@@ -108,6 +108,7 @@ static int pwm_backlight_probe(struct pl
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = data->max_brightness;
 	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev, pb,
 				       &pwm_backlight_ops, &props);
diff -puN drivers/video/backlight/s6e63m0.c~backlight-add-backlight-type drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/s6e63m0.c
@@ -778,6 +778,7 @@ static int __devinit s6e63m0_probe(struc
 
 	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = MAX_BRIGHTNESS;
+	bd->props.type = BACKLIGHT_RAW;
 	lcd->bd = bd;
 
 	/*
diff -puN drivers/video/backlight/tosa_bl.c~backlight-add-backlight-type drivers/video/backlight/tosa_bl.c
--- a/drivers/video/backlight/tosa_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/tosa_bl.c
@@ -102,6 +102,7 @@ static int __devinit tosa_bl_probe(struc
 	data->i2c = client;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 512 - 1;
 	data->bl = backlight_device_register("tosa-bl", &client->dev, data,
 					     &bl_ops, &props);
diff -puN drivers/video/backlight/wm831x_bl.c~backlight-add-backlight-type drivers/video/backlight/wm831x_bl.c
--- a/drivers/video/backlight/wm831x_bl.c~backlight-add-backlight-type
+++ a/drivers/video/backlight/wm831x_bl.c
@@ -193,6 +193,7 @@ static int wm831x_backlight_probe(struct
 	data->current_brightness = 0;
 	data->isink_reg = isink_reg;
 
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_isel;
 	bl = backlight_device_register("wm831x", &pdev->dev, data,
 				       &wm831x_backlight_ops, &props);
diff -puN drivers/video/bf54x-lq043fb.c~backlight-add-backlight-type drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~backlight-add-backlight-type
+++ a/drivers/video/bf54x-lq043fb.c
@@ -649,6 +649,7 @@ static int __devinit bfin_bf54x_probe(st
 	}
 #ifndef NO_BL_SUPPORT
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 255;
 	bl_dev = backlight_device_register("bf54x-bl", NULL, NULL,
 					   &bfin_lq043fb_bl_ops, &props);
diff -puN drivers/video/bfin-t350mcqb-fb.c~backlight-add-backlight-type drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~backlight-add-backlight-type
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -545,6 +545,7 @@ static int __devinit bfin_t350mcqb_probe
 	}
 #ifndef NO_BL_SUPPORT
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 255;
 	bl_dev = backlight_device_register("bf52x-bl", NULL, NULL,
 					   &bfin_lq043fb_bl_ops, &props);
diff -puN drivers/video/imxfb.c~backlight-add-backlight-type drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~backlight-add-backlight-type
+++ a/drivers/video/imxfb.c
@@ -499,6 +499,7 @@ static void imxfb_init_backlight(struct 
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 0xff;
+	props.type = BACKLIGHT_RAW;
 	writel(fbi->pwmr, fbi->regs + LCDC_PWMR);
 
 	bl = backlight_device_register("imxfb-bl", &fbi->pdev->dev, fbi,
diff -puN drivers/video/nvidia/nv_backlight.c~backlight-add-backlight-type drivers/video/nvidia/nv_backlight.c
--- a/drivers/video/nvidia/nv_backlight.c~backlight-add-backlight-type
+++ a/drivers/video/nvidia/nv_backlight.c
@@ -111,6 +111,7 @@ void nvidia_bl_init(struct nvidia_par *p
 	snprintf(name, sizeof(name), "nvidiabl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &nvidia_bl_ops,
 				       &props);
diff -puN drivers/video/omap2/displays/panel-acx565akm.c~backlight-add-backlight-type drivers/video/omap2/displays/panel-acx565akm.c
--- a/drivers/video/omap2/displays/panel-acx565akm.c~backlight-add-backlight-type
+++ a/drivers/video/omap2/displays/panel-acx565akm.c
@@ -534,6 +534,7 @@ static int acx_panel_probe(struct omap_d
 
 	props.fb_blank = FB_BLANK_UNBLANK;
 	props.power = FB_BLANK_UNBLANK;
+	props.type = BACKLIGHT_RAW;
 
 	bldev = backlight_device_register("acx565akm", &md->spi->dev,
 			md, &acx565akm_bl_ops, &props);
diff -puN drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c~backlight-add-backlight-type drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
--- a/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c~backlight-add-backlight-type
+++ a/drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c
@@ -99,6 +99,7 @@ static int sharp_ls_panel_probe(struct o
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = dssdev->max_backlight_level;
+	props.type = BACKLIGHT_RAW;
 
 	bl = backlight_device_register("sharp-ls", &dssdev->dev, dssdev,
 			&sharp_ls_bl_ops, &props);
diff -puN drivers/video/omap2/displays/panel-taal.c~backlight-add-backlight-type drivers/video/omap2/displays/panel-taal.c
--- a/drivers/video/omap2/displays/panel-taal.c~backlight-add-backlight-type
+++ a/drivers/video/omap2/displays/panel-taal.c
@@ -729,6 +729,8 @@ static int taal_probe(struct omap_dss_de
 		props.max_brightness = 255;
 	else
 		props.max_brightness = 127;
+
+	props.type = BACKLIGHT_RAW;
 	bldev = backlight_device_register("taal", &dssdev->dev, dssdev,
 					  &taal_bl_ops, &props);
 	if (IS_ERR(bldev)) {
diff -puN drivers/video/riva/fbdev.c~backlight-add-backlight-type drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~backlight-add-backlight-type
+++ a/drivers/video/riva/fbdev.c
@@ -355,6 +355,7 @@ static void riva_bl_init(struct riva_par
 	snprintf(name, sizeof(name), "rivabl%d", info->node);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
 	props.max_brightness = FB_BACKLIGHT_LEVELS - 1;
 	bd = backlight_device_register(name, info->dev, par, &riva_bl_ops,
 				       &props);
diff -puN include/linux/backlight.h~backlight-add-backlight-type include/linux/backlight.h
--- a/include/linux/backlight.h~backlight-add-backlight-type
+++ a/include/linux/backlight.h
@@ -32,6 +32,13 @@ enum backlight_update_reason {
 	BACKLIGHT_UPDATE_SYSFS,
 };
 
+enum backlight_type {
+	BACKLIGHT_RAW = 1,
+	BACKLIGHT_PLATFORM,
+	BACKLIGHT_FIRMWARE,
+	BACKLIGHT_TYPE_MAX,
+};
+
 struct backlight_device;
 struct fb_info;
 
@@ -62,6 +69,8 @@ struct backlight_properties {
 	/* FB Blanking active? (values as for power) */
 	/* Due to be removed, please use (state & BL_CORE_FBBLANK) */
 	int fb_blank;
+	/* Backlight type */
+	enum backlight_type type;
 	/* Flags used to signal drivers of state changes */
 	/* Upper 4 bits are reserved for driver internal use */
 	unsigned int state;
_

Patches currently in -mm which might be from mjg@redhat.com are

acerhdf-add-support-for-aspire-1410-bios-v13314.patch
i915-add-native-backlight-control.patch
radeon-expose-backlight-class-device-for-legacy-lvds-encoder.patch
nouveau-change-the-backlight-parent-device-to-the-connector-not-the-pci-dev.patch
acpi-tie-acpi-backlight-devices-to-pci-devices-if-possible.patch
mbp_nvidia_bl-remove-dmi-dependency.patch
mbp_nvidia_bl-check-that-the-backlight-control-functions.patch
mbp_nvidia_bl-rename-to-apple_bl.patch

