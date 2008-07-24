From: akpm@linux-foundation.org
Subject: - sm501-add-inversion-controls-for-vbiasen-and-fpen.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:45 -0700
Message-ID: <200807242332.m6ONWjb6011863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427AbYGXXdU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     sm501: add inversion controls for VBIASEN and FPEN
has been removed from the -mm tree.  Its filename was
     sm501-add-inversion-controls-for-vbiasen-and-fpen.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -73,6 +73,8 @@ extern unsigned long sm501_gpio_get(stru
 #define SM501FB_FLAG_USE_HWACCEL	(1<<3)
 #define SM501FB_FLAG_PANEL_NO_FPEN	(1<<4)
 #define SM501FB_FLAG_PANEL_NO_VBIASEN	(1<<5)
+#define SM501FB_FLAG_PANEL_INV_FPEN	(1<<6)
+#define SM501FB_FLAG_PANEL_INV_VBIASEN	(1<<7)
 
 struct sm501_platdata_fbsub {
 	struct fb_videomode	*def_mode;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
parport-fix-platform-driver-hotplug-coldplug.patch
sm501-add-power-control-callback.patch
sm501-add-gpiolib-support.patch
sm501-gpio-dynamic-registration-for-pci-devices.patch
sm501-gpio-i2c-support.patch
sm501-fixes-for-akpms-comments-on-gpiolib-addition.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

