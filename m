From: akpm@linux-foundation.org
Subject: + sm501fb-control-panel-pin-usage-with-platform-data-flags.patch added to -mm tree
Date: Mon, 21 Jan 2008 18:40:06 -0800
Message-ID: <200801220239.m0M2dlau000312@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42666 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795AbYAVClI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 21:41:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, adaplas@pol.net, ben-linux@fluff.org, damm@igel.co.jp, lethal@linux-sh.org


The patch titled
     sm501fb: control panel pin usage with platform data flags
has been added to the -mm tree.  Its filename is
     sm501fb-control-panel-pin-usage-with-platform-data-flags.patch

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
Subject: sm501fb: control panel pin usage with platform data flags
From: Magnus Damm <magnus.damm@gmail.com>

This patch makes it possible to control panel pins usage with flags passed
from the platform data.  Without this patch the sm501fb driver always controls
the VBIASEN and FPEN pins.  The polarity and use of these pins are very
platform specific, so this patch introduces the flags
SM501FB_FLAG_PANEL_USE_VBIASEN and SM501FB_FLAG_PANEL_USE_FPEN which enable
the use of these pins.

This patch is needed to support the a Sharp LQ104V1DG21 lcd panel on SuperH
platforms such as R2D-1 and R2D-PLUS boards.  Letting the sm501fb driver
control the FPEN and VBIASEN pins like today just results in lcd panel
flicker.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |   41 +++++++++++++++++++++++---------------
 include/linux/sm501.h   |    2 +
 2 files changed, 27 insertions(+), 16 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501fb-control-panel-pin-usage-with-platform-data-flags drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501fb-control-panel-pin-usage-with-platform-data-flags
+++ a/drivers/video/sm501fb.c
@@ -641,6 +641,7 @@ static void sm501fb_panel_power(struct s
 {
 	unsigned long control;
 	void __iomem *ctrl_reg = fbi->regs + SM501_DC_PANEL_CONTROL;
+	struct sm501_platdata_fbsub *pd = fbi->pdata->fb_pnl;
 
 	control = readl(ctrl_reg);
 
@@ -657,26 +658,34 @@ static void sm501fb_panel_power(struct s
 		sm501fb_sync_regs(fbi);
 		mdelay(10);
 
-		control |= SM501_DC_PANEL_CONTROL_BIAS;	/* VBIASEN */
-		writel(control, ctrl_reg);
-		sm501fb_sync_regs(fbi);
-		mdelay(10);
-
-		control |= SM501_DC_PANEL_CONTROL_FPEN;
-		writel(control, ctrl_reg);
+		if (pd->flags & SM501FB_FLAG_PANEL_USE_VBIASEN) {
+			control |= SM501_DC_PANEL_CONTROL_BIAS;	/* VBIASEN */
+			writel(control, ctrl_reg);
+			sm501fb_sync_regs(fbi);
+			mdelay(10);
+		}
 
+		if (pd->flags & SM501FB_FLAG_PANEL_USE_FPEN) {
+			control |= SM501_DC_PANEL_CONTROL_FPEN;
+			writel(control, ctrl_reg);
+			sm501fb_sync_regs(fbi);
+			mdelay(10);
+		}
 	} else if (!to && (control & SM501_DC_PANEL_CONTROL_VDD) != 0) {
 		/* disable panel power */
+		if (pd->flags & SM501FB_FLAG_PANEL_USE_FPEN) {
+			control &= ~SM501_DC_PANEL_CONTROL_FPEN;
+			writel(control, ctrl_reg);
+			sm501fb_sync_regs(fbi);
+			mdelay(10);
+		}
 
-		control &= ~SM501_DC_PANEL_CONTROL_FPEN;
-		writel(control, ctrl_reg);
-		sm501fb_sync_regs(fbi);
-		mdelay(10);
-
-		control &= ~SM501_DC_PANEL_CONTROL_BIAS;
-		writel(control, ctrl_reg);
-		sm501fb_sync_regs(fbi);
-		mdelay(10);
+		if (pd->flags & SM501FB_FLAG_PANEL_USE_VBIASEN) {
+			control &= ~SM501_DC_PANEL_CONTROL_BIAS;
+			writel(control, ctrl_reg);
+			sm501fb_sync_regs(fbi);
+			mdelay(10);
+		}
 
 		control &= ~SM501_DC_PANEL_CONTROL_DATA;
 		writel(control, ctrl_reg);
diff -puN include/linux/sm501.h~sm501fb-control-panel-pin-usage-with-platform-data-flags include/linux/sm501.h
--- a/include/linux/sm501.h~sm501fb-control-panel-pin-usage-with-platform-data-flags
+++ a/include/linux/sm501.h
@@ -70,6 +70,8 @@ extern unsigned long sm501_gpio_get(stru
 #define SM501FB_FLAG_DISABLE_AT_EXIT	(1<<1)
 #define SM501FB_FLAG_USE_HWCURSOR	(1<<2)
 #define SM501FB_FLAG_USE_HWACCEL	(1<<3)
+#define SM501FB_FLAG_PANEL_USE_FPEN	(1<<4)
+#define SM501FB_FLAG_PANEL_USE_VBIASEN	(1<<5)
 
 struct sm501_platdata_fbsub {
 	struct fb_videomode	*def_mode;
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

sm501fb-control-panel-pin-usage-with-platform-data-flags.patch
sm501fb-clear-framebuffer-memory-and-palette.patch
