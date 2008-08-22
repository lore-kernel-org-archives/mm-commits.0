From: akpm@linux-foundation.org
Subject: + backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:33:46 -0700
Message-ID: <200808222033.m7MKXliJ015206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758201AbYHVUeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:34:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: private@claudio.ch


The patch titled
     From: Claudio Nieder <private@claudio.ch>
has been added to the -mm tree.  Its filename is
     backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2.patch

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
Subject: From: Claudio Nieder <private@claudio.ch>


Hi,

> These two empty initializers are not needed.

Fixed.

> Now let's add module alias to ensure driver autoloading.
> IMHO the line below should do the trick:
>
> MODULE_ALIAS("dmi:*:svnSDV:pniTouchT201:*");

I usually built the kernel with my driver included. For once I tried to build as
module first without that line added and then with. And by magic the module is
loaded right at boot time. Thank you for your help.

Once again the patch in which all your suggestions are included. Furthermore I
noticed that I had "default y" in Kconfig. Handy for me, but a tad selfish I
think and so corrected that by setting it to "n".

Here the fixed patch:

Signed-off-by: Claudio Nieder <private@claudio.ch>

Backlight driver for Tabletkiosk Sahara TouchIT-213 Tablet PC
---

index 452b770..7dd0ecd 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig     |    2 -
 drivers/video/backlight/kb3886_bl.c |   45 +++++++++++---------------
 2 files changed, 21 insertions(+), 26 deletions(-)

diff -puN drivers/video/backlight/Kconfig~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2 drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2
+++ a/drivers/video/backlight/Kconfig
@@ -167,7 +167,7 @@ config BACKLIGHT_MBP_NVIDIA
 config BACKLIGHT_SAHARA
 	tristate "Tabletkiosk Sahara Touch-iT Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE && X86
-	default y
+	default n
 	help
 	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
 	  backlight driver.
diff -puN drivers/video/backlight/kb3886_bl.c~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2 drivers/video/backlight/kb3886_bl.c
--- a/drivers/video/backlight/kb3886_bl.c~backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2
+++ a/drivers/video/backlight/kb3886_bl.c
@@ -1,7 +1,7 @@
 /*
  *  Backlight Driver for the KB3886 Backlight
  *
- *  Copyright (c) 2007 Claudio Nieder
+ *  Copyright (c) 2007-2008 Claudio Nieder
  *
  *  Based on corgi_bl.c by Richard Purdie and kb3886 driver by Robert Woerle
  *
@@ -19,7 +19,7 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/delay.h>
-
+#include <linux/dmi.h>
 
 /*
  * The following is what corgi has in arch/arm/mach-pxa/corgi.c and
@@ -35,7 +35,7 @@
 
 static DEFINE_MUTEX(bl_mutex);
 
-void kb3886_bl_set_intensity(int intensity)
+static void kb3886_bl_set_intensity(int intensity)
 {
 	mutex_lock(&bl_mutex);
 	intensity = intensity&0xff;
@@ -73,11 +73,6 @@ static struct platform_device *devices[]
 	&kb3886bl_device,
 };
 
-static void __init sahara_init(void)
-{
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
 /*
  * Back to driver
  */
@@ -90,6 +85,17 @@ static unsigned long kb3886bl_flags;
 #define KB3886BL_SUSPENDED     0x01
 #define KB3886BL_BATTLOW       0x02
 
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
 static int kb3886bl_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;
@@ -137,21 +143,6 @@ static int kb3886bl_get_intensity(struct
 	return kb3886bl_intensity;
 }
 
-/*
- * Called when the battery is low to limit the backlight intensity.
- * If limit==0 clear any limit, otherwise limit the intensity
- */
-void kb3886bl_limit_intensity(int limit)
-{
-	if (limit)
-		kb3886bl_flags |= KB3886BL_BATTLOW;
-	else
-		kb3886bl_flags &= ~KB3886BL_BATTLOW;
-	backlight_update_status(kb3886_backlight_device);
-}
-EXPORT_SYMBOL(kb3886bl_limit_intensity);
-
-
 static struct backlight_ops kb3886bl_ops = {
 	.get_brightness = kb3886bl_get_intensity,
 	.update_status  = kb3886bl_send_intensity,
@@ -167,7 +158,7 @@ static int kb3886bl_probe(struct platfor
 
 	kb3886_backlight_device = backlight_device_register("kb3886-bl",
 		&pdev->dev, NULL, &kb3886bl_ops);
-	if (IS_ERR(kb3886_backlight_device))
+	if (IS_ERR (kb3886_backlight_device))
 		return PTR_ERR(kb3886_backlight_device);
 
 	platform_set_drvdata(pdev, kb3886_backlight_device);
@@ -201,7 +192,10 @@ static struct platform_driver kb3886bl_d
 
 static int __init kb3886_init(void)
 {
-	sahara_init();
+	if (!dmi_check_system(kb3886bl_device_table))
+		return -ENODEV;
+
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 	return platform_driver_register(&kb3886bl_driver);
 }
 
@@ -216,3 +210,4 @@ module_exit(kb3886_exit);
 MODULE_AUTHOR("Claudio Nieder <private@claudio.ch>");
 MODULE_DESCRIPTION("Tabletkiosk Sahara Touch-iT Backlight Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("dmi:*:svnSDV:pniTouchT201:*");
_

Patches currently in -mm which might be from private@claudio.ch are

backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc-update-2.patch

