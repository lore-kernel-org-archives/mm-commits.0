From: akpm@linux-foundation.org
Subject: - video-mbp_nvidia_bl-fix-brightness-after-suspend-hibernation.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:53:26 -0800
Message-ID: <200901121953.n0CJrQ0n023266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757248AbZALTzV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 14:55:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwalbe@inf.tu-dresden.de, mjg@redhat.com, rpurdie@rpsys.net, rydberg@euromail.se, mm-commits@vger.kernel.org


The patch titled
     video: mbp_nvidia_bl: fix brightness after suspend/hibernation
has been removed from the -mm tree.  Its filename was
     video-mbp_nvidia_bl-fix-brightness-after-suspend-hibernation.patch

This patch was dropped because of confusion

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video: mbp_nvidia_bl: fix brightness after suspend/hibernation
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>

The mbp_nvidia_bl driver allows to change the display brightness on Apple
MacBook Pro with Nvidia graphics adapters.  However, after resuming from
suspend the brightness is at its maximum instead of the last recently used
value.  This patch converts the driver into a platform_driver in order to
register a resume hook to re-send brightness.  In addition, resources will
be allocated through platform_driver means instead of calling
request_region/release_region directly.

A patch incorporating MacBook 5 MacBook Air 2, and MacBook Pro 5 support
is also available and will be sent next.

Acked-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |   97 +++++++++++++++++-----
 1 file changed, 78 insertions(+), 19 deletions(-)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-fix-brightness-after-suspend-hibernation drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-fix-brightness-after-suspend-hibernation
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -25,8 +25,6 @@
 #include <linux/dmi.h>
 #include <linux/io.h>
 
-static struct backlight_device *mbp_backlight_device;
-
 static struct dmi_system_id __initdata mbp_device_table[] = {
 	{
 		.ident = "3,1",
@@ -75,35 +73,96 @@ static struct backlight_ops mbp_ops = {
 	.update_status  = mbp_send_intensity,
 };
 
+static int mbp_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bd;
+
+	bd = backlight_device_register("mbp_backlight", NULL, NULL, &mbp_ops);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
+
+	bd->props.max_brightness = 15;
+	bd->props.brightness = mbp_get_intensity(bd);
+	backlight_update_status(bd);
+
+	platform_set_drvdata(pdev, bd);
+	return 0;
+}
+
+static int mbp_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	backlight_device_unregister(bd);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int mbp_resume(struct platform_device *pdev)
+{
+	/*
+	 * Nvidia GeForce 8600M GT in MacBookPro 3,1 and MacBookPro 4,1:
+	 *   1. Resume after suspend:
+	 *      SMI still reports the last recently written value, while
+	 *      the brightness is actually at its maximum.
+	 *   2. Resume after hibernation:
+	 *      SMI reports the actual (maximum) value, but the state
+	 *      in props.brightness might be different.
+	 * -> Re-send to fix (1), but do not re-read to fix (2).
+	 */
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	backlight_update_status(bd);
+	return 0;
+}
+#else
+#define mbp_resume NULL
+#endif
+
+static struct platform_driver mbp_driver = {
+	.probe          = mbp_probe,
+	.remove         = mbp_remove,
+	.resume         = mbp_resume,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = "mbp_nvidia_bl"
+	},
+};
+
+static struct resource mbp_iores = {
+	.start          = 0xb2,
+	.end            = 0xb3,
+	.name           = "mbp_nvidia_bl",
+	.flags          = IORESOURCE_IO
+};
+
+static struct platform_device *mbp_device;
+
 static int __init mbp_init(void)
 {
+	int ret;
+
 	if (!dmi_check_system(mbp_device_table))
 		return -ENODEV;
 
-	if (!request_region(0xb2, 2, "Macbook Pro backlight"))
-		return -ENXIO;
-
-	mbp_backlight_device = backlight_device_register("mbp_backlight",
-							 NULL, NULL,
-							 &mbp_ops);
-	if (IS_ERR(mbp_backlight_device)) {
-		release_region(0xb2, 2);
-		return PTR_ERR(mbp_backlight_device);
+	ret = platform_driver_register(&mbp_driver);
+	if (ret)
+		return ret;
+
+	mbp_device = platform_device_register_simple("mbp_nvidia_bl", -1,
+						     &mbp_iores, 1);
+	if (!mbp_device) {
+		platform_driver_unregister(&mbp_driver);
+		return -ENOMEM;
 	}
 
-	mbp_backlight_device->props.max_brightness = 15;
-	mbp_backlight_device->props.brightness =
-		mbp_get_intensity(mbp_backlight_device);
-	backlight_update_status(mbp_backlight_device);
-
 	return 0;
 }
 
 static void __exit mbp_exit(void)
 {
-	backlight_device_unregister(mbp_backlight_device);
