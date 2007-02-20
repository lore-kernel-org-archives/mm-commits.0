From: akpm@linux-foundation.org
Subject: - backlight-tree-versus-acpi-tree.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:10:46 -0800
Message-ID: <200702202010.l1KKAkao018299@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030404AbXBTUMD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:12:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpurdie@rpsys.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     backlight tree versus acpi tree
has been removed from the -mm tree.  Its filename was
     backlight-tree-versus-acpi-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: backlight tree versus acpi tree
From: Richard Purdie <rpurdie@rpsys.net>

Fix up the sony-laptop driver in git-acpi to work with the recent
changes in the git-backlight tree.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/misc/sony-laptop.c~backlight-tree-versus-acpi-tree drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~backlight-tree-versus-acpi-tree
+++ a/drivers/misc/sony-laptop.c
@@ -384,7 +384,7 @@ static void sony_snc_pf_remove(void)
 static int sony_backlight_update_status(struct backlight_device *bd)
 {
 	return acpi_callsetfunc(sony_acpi_handle, "SBRT",
-				bd->props->brightness + 1, NULL);
+				bd->props.brightness + 1, NULL);
 }
 
 static int sony_backlight_get_brightness(struct backlight_device *bd)
@@ -398,11 +398,9 @@ static int sony_backlight_get_brightness
 }
 
 static struct backlight_device *sony_backlight_device;
-static struct backlight_properties sony_backlight_properties = {
-	.owner = THIS_MODULE,
+static struct backlight_ops sony_backlight_ops = {
 	.update_status = sony_backlight_update_status,
 	.get_brightness = sony_backlight_get_brightness,
-	.max_brightness = SONY_MAX_BRIGHTNESS - 1,
 };
 
 /*
@@ -484,15 +482,17 @@ static int sony_acpi_add(struct acpi_dev
 	if (ACPI_SUCCESS(acpi_get_handle(sony_acpi_handle, "GBRT", &handle))) {
 		sony_backlight_device = backlight_device_register("sony", NULL,
 								  NULL,
-								  &sony_backlight_properties);
+								&sony_backlight_ops);
 
 		if (IS_ERR(sony_backlight_device)) {
 			printk(LOG_PFX "unable to register backlight device\n");
 			sony_backlight_device = NULL;
-		} else
-			sony_backlight_properties.brightness =
-			    sony_backlight_get_brightness
-			    (sony_backlight_device);
+		} else {
+			sony_backlight_device->props.brightness =
+				sony_backlight_get_brightness(sony_backlight_device);
+			sony_backlight_device->props.max_brightness =
+				SONY_MAX_BRIGHTNESS - 1;
+		}
 	}
 
 	if (sony_snc_pf_add())
_

Patches currently in -mm which might be from rpurdie@rpsys.net are

origin.patch
git-leds.patch
