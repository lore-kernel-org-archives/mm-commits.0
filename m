From: akpm@linux-foundation.org
Subject: + video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch added to -mm tree
Date: Wed, 17 Dec 2008 13:13:45 -0800
Message-ID: <200812172113.mBHLDkuJ023922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYLQVOg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 16:14:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwalbe@inf.tu-dresden.de, hugang@soulinfo.com, mjg59@srcf.ucam.org, rpurdie@rpsys.net


The patch titled
     video: mbp_nvidia_bl: Add support for MacBook 5, MacBook Air 2, and MacBook Pro 5
has been added to the -mm tree.  Its filename is
     video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch

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
Subject: video: mbp_nvidia_bl: Add support for MacBook 5, MacBook Air 2, and MacBook Pro 5
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>

This patch adds support for the new Apple models incorporating an Nvidia
chipset.  Apple still uses the same protocol as on older models, but the
registers moved to a different address.

The initial code has been contributed by Hu Gang <hugang@soulinfo.com>.

Changes:
    * new structure to be passed to the DMI_MATCH function
    * separated implementation for Intel/Nvidia chipset models
    * added new entries to the device table (moved down)
    * used driver_data structure to request resources/access ops
      where necessary

Known to work on:
    * MacBook Pro 3
    * MacBook Pro 4
    * MacBook Pro 5

Known to work with limitations on:
    * MacBook 5 / MacBook Air 2:
         Changing brightness within X doesn't work, if using
         Nvidia's proprietary graphics driver. No fix known yet.
         Changing brightness on a text console or using the open-source
         driver does work.

Known Bugs:
    * MacBook Pro 5:
         Initial brightness after bootup is the last recently used
         brightness (in Mac OSX), while the firmware reports maximum.
         Impossible to fix.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |  171 ++++++++++++++++------
 1 file changed, 132 insertions(+), 39 deletions(-)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5 drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -25,63 +25,163 @@
 #include <linux/dmi.h>
 #include <linux/io.h>
 
-static struct dmi_system_id __initdata mbp_device_table[] = {
-	{
-		.ident = "3,1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,1"),
-		},
-	},
-	{
-		.ident = "3,2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,2"),
-		},
-	},
-	{
-		.ident = "4,1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4,1"),
-		},
-	},
-	{ }
+/* Structure to be passed to the DMI_MATCH function. */
+struct dmi_match_data {
+	/* I/O resource to allocate. */
+	struct resource iores;
+	/* Backlight operations structure. */
+	struct backlight_ops backlight_ops;
 };
 
-static int mbp_send_intensity(struct backlight_device *bd)
+/*
+ * Implementation for MacBooks with Intel chipset.
+ */
+static int intel_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;
 
 	outb(0x04 | (intensity << 4), 0xb3);
 	outb(0xbf, 0xb2);
-
 	return 0;
 }
 
-static int mbp_get_intensity(struct backlight_device *bd)
+static int intel_chipset_get_intensity(struct backlight_device *bd)
 {
 	outb(0x03, 0xb3);
 	outb(0xbf, 0xb2);
 	return inb(0xb3) >> 4;
 }
 
-static struct backlight_ops mbp_ops = {
-	.get_brightness = mbp_get_intensity,
-	.update_status  = mbp_send_intensity,
+static const struct dmi_match_data intel_chipset_data = {
+	.iores = {
+		.start		= 0xb2,
+		.end		= 0xb3,
+		.name		= "mbp_nvidia_bl",
+		.flags		= IORESOURCE_IO
+	},
+	.backlight_ops		= {
+		.get_brightness	= intel_chipset_get_intensity,
+		.update_status	= intel_chipset_send_intensity,
+	}
 };
 
+/*
+ * Implementation for MacBooks with Nvidia chipset.
+ */
+static int nvidia_chipset_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	outb(0x04 | (intensity << 4), 0x52f);
+	outb(0xbf, 0x52e);
+	return 0;
+}
+
+static int nvidia_chipset_get_intensity(struct backlight_device *bd)
+{
+	outb(0x03, 0x52f);
+	outb(0xbf, 0x52e);
+	return inb(0x52f) >> 4;
+}
+
+static const struct dmi_match_data nvidia_chipset_data = {
+	.iores = {
+		.start		= 0x52e,
+		.end		= 0x52f,
+		.name		= "mbp_nvidia_bl",
+		.flags		= IORESOURCE_IO,
+	},
+	.backlight_ops		= {
+		.get_brightness	= nvidia_chipset_get_intensity,
+		.update_status	= nvidia_chipset_send_intensity
+	}
+};
+
+/*
+ * DMI matching.
+ */
+static /* const */ struct dmi_match_data *driver_data;
+
+static int dmi_match(const struct dmi_system_id *id)
+{
+	driver_data = id->driver_data;
+
+	printk(KERN_INFO "mbp_nvidia_bl: %s detected\n", id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id __initdata mbp_device_table[] = {
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 3,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 3,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,2"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 4,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBook 5,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookAir 2,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 5,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{ }
+};
+
+/*
+ * Platform driver implementation.
+ */
 static int mbp_probe(struct platform_device *pdev)
 {
 	struct backlight_device *bd;
 
-	bd = backlight_device_register("mbp_backlight", NULL, NULL, &mbp_ops);
+	bd = backlight_device_register("mbp_backlight", NULL, NULL,
+				       &driver_data->backlight_ops);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
 
 	bd->props.max_brightness = 15;
-	bd->props.brightness = mbp_get_intensity(bd);
+	bd->props.brightness = bd->ops->get_brightness(bd);
 	backlight_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
@@ -128,13 +228,6 @@ static struct platform_driver mbp_driver
 	},
 };
 
-static struct resource mbp_iores = {
-	.start          = 0xb2,
-	.end            = 0xb3,
-	.name           = "mbp_nvidia_bl",
-	.flags          = IORESOURCE_IO
-};
