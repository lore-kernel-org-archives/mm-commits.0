From: akpm@linux-foundation.org
Subject: + video-mbp_nvidia_bl-add-a-debug-switch.patch added to -mm tree
Date: Wed, 17 Dec 2008 13:14:27 -0800
Message-ID: <200812172114.mBHLERsP024382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101AbYLQVOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 16:14:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwalbe@inf.tu-dresden.de, mjg59@srcf.ucam.org, rpurdie@rpsys.net


The patch titled
     video: mbp_nvidia_bl: Add a debug switch
has been added to the -mm tree.  Its filename is
     video-mbp_nvidia_bl-add-a-debug-switch.patch

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
Subject: video: mbp_nvidia_bl: Add a debug switch
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>

This patch adds a debug switch to enable (little) diagnostic
output, to help to trace down the remaining problems.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |   37 ++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-a-debug-switch drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-a-debug-switch
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -33,6 +33,11 @@ struct dmi_match_data {
 	struct backlight_ops backlight_ops;
 };
 
+/* Module parameters. */
+static int debug;
+module_param_named(debug, debug, int, 0644);
+MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");
+
 /*
  * Implementation for MacBooks with Intel chipset.
  */
@@ -40,6 +45,10 @@ static int intel_chipset_send_intensity(
 {
 	int intensity = bd->props.brightness;
 
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: setting brightness to %d\n",
+		       intensity);
+
 	outb(0x04 | (intensity << 4), 0xb3);
 	outb(0xbf, 0xb2);
 	return 0;
@@ -47,9 +56,17 @@ static int intel_chipset_send_intensity(
 
 static int intel_chipset_get_intensity(struct backlight_device *bd)
 {
+	int intensity;
+
 	outb(0x03, 0xb3);
 	outb(0xbf, 0xb2);
-	return inb(0xb3) >> 4;
+	intensity = inb(0xb3) >> 4;
+
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: read brightness of %d\n",
+		       intensity);
+
+	return intensity;
 }
 
 static const struct dmi_match_data intel_chipset_data = {
@@ -72,6 +89,10 @@ static int nvidia_chipset_send_intensity
 {
 	int intensity = bd->props.brightness;
 
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: setting brightness to %d\n",
+		       intensity);
+
 	outb(0x04 | (intensity << 4), 0x52f);
 	outb(0xbf, 0x52e);
 	return 0;
@@ -79,9 +100,17 @@ static int nvidia_chipset_send_intensity
 
 static int nvidia_chipset_get_intensity(struct backlight_device *bd)
 {
+	int intensity;
+
 	outb(0x03, 0x52f);
 	outb(0xbf, 0x52e);
-	return inb(0x52f) >> 4;
+	intensity = inb(0x52f) >> 4;
+
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: read brightness of %d\n",
+		       intensity);
+
+	return intensity;
 }
 
 static const struct dmi_match_data nvidia_chipset_data = {
@@ -211,6 +240,10 @@ static int mbp_resume(struct platform_de
 	 */
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: resuming with"
+		       " brightness %d\n", bd->props.brightness);
+
 	backlight_update_status(bd);
 	return 0;
 }
_

Patches currently in -mm which might be from schwalbe@inf.tu-dresden.de are

video-mbp_nvidia_bl-fix-brightness-after-suspend-hibernation.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
video-mbp_nvidia_bl-add-a-debug-switch.patch

