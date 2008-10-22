From: akpm@linux-foundation.org
Subject: - backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch removed from -mm tree
Date: Wed, 22 Oct 2008 13:09:04 -0700
Message-ID: <200810222009.m9MK94m9013982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753088AbYJVUJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Oct 2008 16:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: private@claudio.ch, pazke@pazke.donpac.ru, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Backlight driver for Tabletkiosk Sahara TouchIT-213 Tablet PC
has been removed from the -mm tree.  Its filename was
     backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Backlight driver for Tabletkiosk Sahara TouchIT-213 Tablet PC
From: Claudio Nieder <private@claudio.ch>

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Claudio Nieder <private@claudio.ch>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrey Panin <pazke@pazke.donpac.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig     |    7 
 drivers/video/backlight/Makefile    |    1 
 drivers/video/backlight/kb3886_bl.c |  213 ++++++++++++++++++++++++++
 3 files changed, 221 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc
+++ a/drivers/video/backlight/Kconfig
@@ -204,3 +204,10 @@ config BACKLIGHT_TOSA
 	  If you have an Sharp SL-6000 Zaurus say Y to enable a driver
 	  for its backlight
 
+config BACKLIGHT_SAHARA
+	tristate "Tabletkiosk Sahara Touch-iT Backlight Driver"
+	depends on BACKLIGHT_CLASS_DEVICE && X86
+	default n
+	help
+	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
+	  backlight driver.
diff -puN drivers/video/backlight/Makefile~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc
+++ a/drivers/video/backlight/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_BACKLIGHT_CORGI)	+= corgi_b
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
+obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
diff -puN /dev/null drivers/video/backlight/kb3886_bl.c
--- /dev/null
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -0,0 +1,213 @@
+/*
+ *  Backlight Driver for the KB3886 Backlight
+ *
+ *  Copyright (c) 2007-2008 Claudio Nieder
+ *
+ *  Based on corgi_bl.c by Richard Purdie and kb3886 driver by Robert Woerle
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/dmi.h>
+
+/*
+ * The following is what corgi has in arch/arm/mach-pxa/corgi.c and
+ * corgi_lcd.c. On kernelnebwies it was suggested I put the platform_device
+ * code in my driver.
+ */
+
+#define KB3886_PARENT 0x64
+#define KB3886_IO 0x60
+#define KB3886_ADC_DAC_PWM 0xC4
+#define KB3886_PWM0_WRITE 0x81
+#define KB3886_PWM0_READ 0x41
+
+static DEFINE_MUTEX(bl_mutex);
+
+static void kb3886_bl_set_intensity(int intensity)
+{
+	mutex_lock(&bl_mutex);
+	intensity = intensity&0xff;
+	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
+	msleep(10);
+	outb(KB3886_PWM0_WRITE, KB3886_IO);
+	msleep(10);
+	outb(intensity, KB3886_IO);
+	mutex_unlock(&bl_mutex);
+}
+
+struct kb3886bl_machinfo {
+	int max_intensity;
+	int default_intensity;
+	int limit_mask;
+	void (*set_bl_intensity)(int intensity);
+};
+
+static struct kb3886bl_machinfo kb3886_bl_machinfo = {
+	.max_intensity = 0xff,
+	.default_intensity = 0xa0,
+	.limit_mask = 0x7f,
+	.set_bl_intensity = kb3886_bl_set_intensity,
+};
+
+static struct platform_device kb3886bl_device = {
+	.name		= "kb3886-bl",
+	.dev		= {
+		.platform_data	= &kb3886_bl_machinfo,
+	},
+	.id		= -1,
+};
+
+static struct platform_device *devices[] __initdata = {
+	&kb3886bl_device,
+};
+
+/*
+ * Back to driver
+ */
+
+static int kb3886bl_intensity;
+static struct backlight_device *kb3886_backlight_device;
+static struct kb3886bl_machinfo *bl_machinfo;
+
+static unsigned long kb3886bl_flags;
+#define KB3886BL_SUSPENDED     0x01
+#define KB3886BL_BATTLOW       0x02
+
+static struct dmi_system_id __initdata kb3886bl_device_table[] = {
+	{
+		.ident = "Sahara Touch-iT",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SDV"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iTouch T201"),
+		},
+	},
+	{ }
+};
+
+static int kb3886bl_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	if (bd->props.power != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (kb3886bl_flags & KB3886BL_SUSPENDED)
+		intensity = 0;
+	if (kb3886bl_flags & KB3886BL_BATTLOW)
+		intensity &= bl_machinfo->limit_mask;
+
+	bl_machinfo->set_bl_intensity(intensity);
+
+	kb3886bl_intensity = intensity;
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int kb3886bl_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	kb3886bl_flags |= KB3886BL_SUSPENDED;
+	backlight_update_status(bd);
+	return 0;
+}
+
+static int kb3886bl_resume(struct platform_device *pdev)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	kb3886bl_flags &= ~KB3886BL_SUSPENDED;
+	backlight_update_status(bd);
+	return 0;
+}
+#else
+#define kb3886bl_suspend	NULL
+#define kb3886bl_resume		NULL
+#endif
+
+static int kb3886bl_get_intensity(struct backlight_device *bd)
+{
+	return kb3886bl_intensity;
+}
+
+static struct backlight_ops kb3886bl_ops = {
+	.get_brightness = kb3886bl_get_intensity,
+	.update_status  = kb3886bl_send_intensity,
+};
+
+static int kb3886bl_probe(struct platform_device *pdev)
+{
+	struct kb3886bl_machinfo *machinfo = pdev->dev.platform_data;
+
+	bl_machinfo = machinfo;
+	if (!machinfo->limit_mask)
+		machinfo->limit_mask = -1;
+
+	kb3886_backlight_device = backlight_device_register("kb3886-bl",
+		&pdev->dev, NULL, &kb3886bl_ops);
+	if (IS_ERR(kb3886_backlight_device))
+		return PTR_ERR(kb3886_backlight_device);
+
+	platform_set_drvdata(pdev, kb3886_backlight_device);
+
+	kb3886_backlight_device->props.max_brightness = machinfo->max_intensity;
+	kb3886_backlight_device->props.power = FB_BLANK_UNBLANK;
+	kb3886_backlight_device->props.brightness = machinfo->default_intensity;
+	backlight_update_status(kb3886_backlight_device);
+
+	return 0;
+}
+
+static int kb3886bl_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	backlight_device_unregister(bd);
+
+	return 0;
+}
+
+static struct platform_driver kb3886bl_driver = {
+	.probe		= kb3886bl_probe,
+	.remove		= kb3886bl_remove,
+	.suspend	= kb3886bl_suspend,
+	.resume		= kb3886bl_resume,
+	.driver		= {
+		.name	= "kb3886-bl",
+	},
+};
+
+static int __init kb3886_init(void)
+{
+	if (!dmi_check_system(kb3886bl_device_table))
+		return -ENODEV;
+
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+	return platform_driver_register(&kb3886bl_driver);
+}
+
+static void __exit kb3886_exit(void)
+{
+	platform_driver_unregister(&kb3886bl_driver);
+}
+
+module_init(kb3886_init);
+module_exit(kb3886_exit);
+
+MODULE_AUTHOR("Claudio Nieder <private@claudio.ch>");
+MODULE_DESCRIPTION("Tabletkiosk Sahara Touch-iT Backlight Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("dmi:*:svnSDV:pniTouchT201:*");
_

Patches currently in -mm which might be from private@claudio.ch are

linux-next.patch

