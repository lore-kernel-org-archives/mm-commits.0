From: akpm@linux-foundation.org
Subject: [merged] backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch removed from -mm tree
Date: Thu, 31 May 2012 12:18:43 -0700
Message-ID: <20120531191843.73E5BA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53340 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab2EaTSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:18:44 -0400
Received: by ghbz15 with SMTP id z15so134798ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:18:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, joe@perches.com, mjg@redhat.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: apple_bl: use pr_debug()/pr_err() instead of printk()
has been removed from the -mm tree.  Its filename was
     backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: apple_bl: use pr_debug()/pr_err() instead of printk()

Use pr_debug()/pr_err() instead of printk() to allow dynamic debugging. 
The pr_fmt prefix for pr_ macros is used.  Also fix checkpatch warnings as
below:

WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

[akpm@linux-foundation.org: use KBUILD_MODNAME, per Joe]
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/apple_bl.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/apple_bl.c~backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk drivers/video/backlight/apple_bl.c
--- a/drivers/video/backlight/apple_bl.c~backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk
+++ a/drivers/video/backlight/apple_bl.c
@@ -16,6 +16,8 @@
  *  get at the firmware code in order to figure out what it's actually doing.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -40,8 +42,6 @@ struct hw_data {
 
 static const struct hw_data *hw_data;
 
-#define DRIVER "apple_backlight: "
-
 /* Module parameters. */
 static int debug;
 module_param_named(debug, debug, int, 0644);
@@ -61,8 +61,7 @@ static int intel_chipset_send_intensity(
 	int intensity = bd->props.brightness;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
+		pr_debug("setting brightness to %d\n", intensity);
 
 	intel_chipset_set_brightness(intensity);
 	return 0;
@@ -77,8 +76,7 @@ static int intel_chipset_get_intensity(s
 	intensity = inb(0xb3) >> 4;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
+		pr_debug("read brightness of %d\n", intensity);
 
 	return intensity;
 }
@@ -108,8 +106,7 @@ static int nvidia_chipset_send_intensity
 	int intensity = bd->props.brightness;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "setting brightness to %d\n",
-		       intensity);
+		pr_debug("setting brightness to %d\n", intensity);
 
 	nvidia_chipset_set_brightness(intensity);
 	return 0;
@@ -124,8 +121,7 @@ static int nvidia_chipset_get_intensity(
 	intensity = inb(0x52f) >> 4;
 
 	if (debug)
-		printk(KERN_DEBUG DRIVER "read brightness of %d\n",
-		       intensity);
+		pr_debug("read brightness of %d\n", intensity);
 
 	return intensity;
 }
@@ -150,7 +146,7 @@ static int __devinit apple_bl_add(struct
 	host = pci_get_bus_and_slot(0, 0);
 
 	if (!host) {
-		printk(KERN_ERR DRIVER "unable to find PCI host\n");
+		pr_err("unable to find PCI host\n");
 		return -ENODEV;
 	}
 
@@ -162,7 +158,7 @@ static int __devinit apple_bl_add(struct
 	pci_dev_put(host);
 
 	if (!hw_data) {
-		printk(KERN_ERR DRIVER "unknown hardware\n");
+		pr_err("unknown hardware\n");
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

