From: akpm@linux-foundation.org
Subject: + backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:49:57 -0700
Message-ID: <200808112049.m7BKnvnW020678@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757289AbYHKUuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: private@claudio.ch, rpurdie@rpsys.net


The patch titled
     Backlight driver for Tabletkiosk Sahara TouchIT-213 Tablet PC
has been added to the -mm tree.  Its filename is
     backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Backlight driver for Tabletkiosk Sahara TouchIT-213 Tablet PC
From: Claudio Nieder <private@claudio.ch>

Signed-off-by: Claudio Nieder <private@claudio.ch>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig     |    7 
 drivers/video/backlight/Makefile    |    1 
 drivers/video/backlight/kb3886_bl.c |  218 ++++++++++++++++++++++++++
 3 files changed, 226 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc
+++ a/drivers/video/backlight/Kconfig
@@ -164,3 +164,10 @@ config BACKLIGHT_MBP_NVIDIA
          If you have an Apple Macbook Pro with Nvidia graphics hardware say Y
 	 to enable a driver for its backlight
 
+config BACKLIGHT_SAHARA
+	tristate "Tabletkiosk Sahara Touch-iT Backlight Driver"
+	depends on BACKLIGHT_CLASS_DEVICE && X86
+	default y
+	help
+	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
+	  backlight driver.
diff -puN drivers/video/backlight/Makefile~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc
+++ a/drivers/video/backlight/Makefile
@@ -16,4 +16,5 @@ obj-$(CONFIG_BACKLIGHT_PROGEAR) += proge
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
 obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
+obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
 
diff -puN /dev/null drivers/video/backlight/kb3886_bl.c
--- /dev/null
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -0,0 +1,218 @@
+/*
+ *  Backlight Driver for the KB3886 Backlight
+ *
+ *  Copyright (c) 2007 Claudio Nieder
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
+
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
+void kb3886_bl_set_intensity(int intensity)
+{
+	mutex_lock(&bl_mutex);
+	intensity = intensity&0xff;
+	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
+	mdelay(10);
+	outb(KB3886_PWM0_WRITE, KB3886_IO);
+	mdelay(10);
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
+static void __init sahara_init(void)
+{
+	platform_add_devices(devices, ARRAY_SIZE(devices));
+}
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
+/*
+ * Called when the battery is low to limit the backlight intensity.
+ * If limit==0 clear any limit, otherwise limit the intensity
+ */
+void kb3886bl_limit_intensity(int limit)
+{
+	if (limit)
+		kb3886bl_flags |= KB3886BL_BATTLOW;
+	else
+		kb3886bl_flags &= ~KB3886BL_BATTLOW;
+	backlight_update_status(kb3886_backlight_device);
+}
+EXPORT_SYMBOL(kb3886bl_limit_intensity);
+
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
+	if (IS_ERR (kb3886_backlight_device))
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
+	sahara_init();
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
_

Patches currently in -mm which might be from private@claudio.ch are

backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch

