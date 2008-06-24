From: akpm@linux-foundation.org
Subject: + sm501-add-inversion-controls-for-vbiasen-and-fpen.patch added to -mm tree
Date: Tue, 24 Jun 2008 00:09:39 -0700
Message-ID: <200806240709.m5O79dXe005964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbYFXHKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 03:10:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org


The patch titled
     sm501: add inversion controls for VBIASEN and FPEN
has been added to the -mm tree.  Its filename is
     sm501-add-inversion-controls-for-vbiasen-and-fpen.patch

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
Subject: sm501: add inversion controls for VBIASEN and FPEN
From: Ben Dooks <ben-linux@fluff.org>

Add flags to allow the driver to invert the sense of both VBIASEN and FPEN
signals comming from the SM501.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |   26 ++++++++++++++++++++++----
 include/linux/sm501.h   |    2 ++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501-add-inversion-controls-for-vbiasen-and-fpen drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-add-inversion-controls-for-vbiasen-and-fpen
+++ a/drivers/video/sm501fb.c
@@ -663,15 +663,25 @@ static void sm501fb_panel_power(struct s
 		sm501fb_sync_regs(fbi);
 		mdelay(10);
 
+		/* VBIASEN */
+
 		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_VBIASEN)) {
-			control |= SM501_DC_PANEL_CONTROL_BIAS;	/* VBIASEN */
+			if (pd->flags & SM501FB_FLAG_PANEL_INV_VBIASEN)
+				control &= ~SM501_DC_PANEL_CONTROL_BIAS;
+			else
+				control |= SM501_DC_PANEL_CONTROL_BIAS;
+
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
 
 		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_FPEN)) {
-			control |= SM501_DC_PANEL_CONTROL_FPEN;
+			if (pd->flags & SM501FB_FLAG_PANEL_INV_FPEN)
+				control &= ~SM501_DC_PANEL_CONTROL_FPEN;
+			else
+				control |= SM501_DC_PANEL_CONTROL_FPEN;
+
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
@@ -679,14 +689,22 @@ static void sm501fb_panel_power(struct s
 	} else if (!to && (control & SM501_DC_PANEL_CONTROL_VDD) != 0) {
 		/* disable panel power */
 		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_FPEN)) {
-			control &= ~SM501_DC_PANEL_CONTROL_FPEN;
+			if (pd->flags & SM501FB_FLAG_PANEL_INV_FPEN)
+				control |= SM501_DC_PANEL_CONTROL_FPEN;
+			else
+				control &= ~SM501_DC_PANEL_CONTROL_FPEN;
+
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
 
 		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_VBIASEN)) {
-			control &= ~SM501_DC_PANEL_CONTROL_BIAS;
+			if (pd->flags & SM501FB_FLAG_PANEL_INV_VBIASEN)
+				control |= SM501_DC_PANEL_CONTROL_BIAS;
+			else
+				control &= ~SM501_DC_PANEL_CONTROL_BIAS;
+
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
diff -puN include/linux/sm501.h~sm501-add-inversion-controls-for-vbiasen-and-fpen include/linux/sm501.h
--- a/include/linux/sm501.h~sm501-add-inversion-controls-for-vbiasen-and-fpen
+++ a/include/linux/sm501.h
@@ -55,6 +55,8 @@ extern unsigned long sm501_modify_reg(st
 #define SM501FB_FLAG_USE_HWACCEL	(1<<3)
 #define SM501FB_FLAG_PANEL_NO_FPEN	(1<<4)
 #define SM501FB_FLAG_PANEL_NO_VBIASEN	(1<<5)
+#define SM501FB_FLAG_PANEL_INV_FPEN	(1<<6)
+#define SM501FB_FLAG_PANEL_INV_VBIASEN	(1<<7)
 
 struct sm501_platdata_fbsub {
 	struct fb_videomode	*def_mode;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-add-inversion-controls-for-vbiasen-and-fpen.patch
sm501-restructure-init-to-allow-only-1-fb-on-an-sm501.patch
fb-add-support-for-the-ili9320-video-display-controller.patch
lcd-add-lcd_device-to-check_fb-entry-in-lcd_ops.patch
lcd-add-platform_lcd-driver.patch

