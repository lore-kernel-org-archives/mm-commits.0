From: akpm@linux-foundation.org
Subject: + backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch added to -mm tree
Date: Wed, 16 May 2012 12:55:02 -0700
Message-ID: <20120516195502.EFAC2A0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:49692 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713Ab2EPTzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 May 2012 15:55:05 -0400
Received: by lbbgp10 with SMTP id gp10so59633lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 16 May 2012 12:55:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, joe@perches.com, mjg@redhat.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: apple_bl: use pr_debug()/pr_err() instead of printk()
has been added to the -mm tree.  Its filename is
     backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: apple_bl: use pr_debug()/pr_err() instead of printk()

Use pr_debug()/pr_err() instead of printk() to allow dynamic debugging. 
The pr_fmt prefix for pr_ macros is used.  Also fix checkpatch warnings as
below:

WARNING: Prefer pr_debug(... to printk(KERN_DEBUG, ...
WARNING: Prefer pr_err(... to printk(KERN_ERR, ...

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
 
+#define pr_fmt(fmt) "apple_backlight: " fmt
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
Subject: Subject: backlight: apple_bl: use pr_debug()/pr_err() instead of printk()

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-adp8860-use-kstrtoul.patch
backlight-adp8870-use-kstrtoul.patch
backlight-adp5520-use-kstrtoul.patch
backlight-use-pr_warn-and-pr_debug-instead-of-printk.patch
backlight-apple_bl-use-pr_debug-pr_err-instead-of-printk.patch
backlight-cr_bllcd-use-pr_err-pr_info-instead-of-printk.patch
backlight-generic_bl-use-pr_info-instead-of-printk.patch
backlight-jornada720-use-pr_err-pr_info-instead-of-printk.patch
backlight-omap1-use-pr_info-instead-of-printk.patch
backlight-progear-use-pr_err-instead-of-printk.patch

