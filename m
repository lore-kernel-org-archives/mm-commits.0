From: akpm@linux-foundation.org
Subject: - neofb-drop-redundant-code.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:12 -0700
Message-ID: <200807242333.m6ONXC1r011909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452AbYGXXdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     neofb: drop redundant code
has been removed from the -mm tree.  Its filename was
     neofb-drop-redundant-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: neofb: drop redundant code
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Drop structure which is only set but never read.  Drop variables which are
only set and never read.  Convert one long switch into two shorter ones.

Add cpu_relax() in busy waiting loop.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   95 +++++++++-------------------------------
 1 file changed, 22 insertions(+), 73 deletions(-)

diff -puN drivers/video/neofb.c~neofb-drop-redundant-code drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-drop-redundant-code
+++ a/drivers/video/neofb.c
@@ -479,7 +479,8 @@ static inline int neo2200_sync(struct fb
 {
 	struct neofb_par *par = info->par;
 
-	while (readl(&par->neo2200->bltStat) & 1);
+	while (readl(&par->neo2200->bltStat) & 1)
+		cpu_relax();
 	return 0;
 }
 
@@ -587,34 +588,14 @@ static int
 neofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct neofb_par *par = info->par;
-	unsigned int pixclock = var->pixclock;
-	struct xtimings timings;
 	int memlen, vramlen;
 	int mode_ok = 0;
 
 	DBG("neofb_check_var");
 
-	if (!pixclock)
-		pixclock = 10000;	/* 10ns = 100MHz */
-	timings.pixclock = 1000000000 / pixclock;
-	if (timings.pixclock < 1)
-		timings.pixclock = 1;
-
-	if (timings.pixclock > par->maxClock)
+	if (PICOS2KHZ(var->pixclock) > par->maxClock)
 		return -EINVAL;
 
-	timings.dblscan = var->vmode & FB_VMODE_DOUBLE;
-	timings.interlaced = var->vmode & FB_VMODE_INTERLACED;
-	timings.HDisplay = var->xres;
-	timings.HSyncStart = timings.HDisplay + var->right_margin;
-	timings.HSyncEnd = timings.HSyncStart + var->hsync_len;
-	timings.HTotal = timings.HSyncEnd + var->left_margin;
-	timings.VDisplay = var->yres;
-	timings.VSyncStart = timings.VDisplay + var->lower_margin;
-	timings.VSyncEnd = timings.VSyncStart + var->vsync_len;
-	timings.VTotal = timings.VSyncEnd + var->upper_margin;
-	timings.sync = var->sync;
-
 	/* Is the mode larger than the LCD panel? */
 	if (par->internal_display &&
             ((var->xres > par->NeoPanelWidth) ||
@@ -1923,9 +1904,6 @@ static int __devinit neo_init_hw(struct 
 	int maxClock = 65000;
 	int CursorMem = 1024;
 	int CursorOff = 0x100;
-	int linearSize = 1024;
-	int maxWidth = 1024;
-	int maxHeight = 1024;
 
 	DBG("neo_init_hw");
 
@@ -1944,81 +1922,52 @@ static int __devinit neo_init_hw(struct 
 	case FB_ACCEL_NEOMAGIC_NM2070:
 		videoRam = 896;
 		maxClock = 65000;
-		CursorMem = 2048;
-		CursorOff = 0x100;
-		linearSize = 1024;
-		maxWidth = 1024;
-		maxHeight = 1024;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2090:
 	case FB_ACCEL_NEOMAGIC_NM2093:
-		videoRam = 1152;
-		maxClock = 80000;
-		CursorMem = 2048;
-		CursorOff = 0x100;
-		linearSize = 2048;
-		maxWidth = 1024;
-		maxHeight = 1024;
-		break;
 	case FB_ACCEL_NEOMAGIC_NM2097:
 		videoRam = 1152;
 		maxClock = 80000;
-		CursorMem = 1024;
-		CursorOff = 0x100;
-		linearSize = 2048;
-		maxWidth = 1024;
-		maxHeight = 1024;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2160:
 		videoRam = 2048;
 		maxClock = 90000;
-		CursorMem = 1024;
-		CursorOff = 0x100;
-		linearSize = 2048;
-		maxWidth = 1024;
-		maxHeight = 1024;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2200:
 		videoRam = 2560;
 		maxClock = 110000;
-		CursorMem = 1024;
-		CursorOff = 0x1000;
-		linearSize = 4096;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
-
-		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2230:
 		videoRam = 3008;
 		maxClock = 110000;
-		CursorMem = 1024;
-		CursorOff = 0x1000;
-		linearSize = 4096;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
-
-		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2360:
 		videoRam = 4096;
 		maxClock = 110000;
-		CursorMem = 1024;
-		CursorOff = 0x1000;
-		linearSize = 4096;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
-
-		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2380:
 		videoRam = 6144;
 		maxClock = 110000;
+		break;
+	}
+	switch (info->fix.accel) {
+	case FB_ACCEL_NEOMAGIC_NM2070:
+	case FB_ACCEL_NEOMAGIC_NM2090:
+	case FB_ACCEL_NEOMAGIC_NM2093:
+		CursorMem = 2048;
+		CursorOff = 0x100;
+		break;
+	case FB_ACCEL_NEOMAGIC_NM2097:
+	case FB_ACCEL_NEOMAGIC_NM2160:
+		CursorMem = 1024;
+		CursorOff = 0x100;
+		break;
+	case FB_ACCEL_NEOMAGIC_NM2200:
+	case FB_ACCEL_NEOMAGIC_NM2230:
+	case FB_ACCEL_NEOMAGIC_NM2360:
+	case FB_ACCEL_NEOMAGIC_NM2380:
 		CursorMem = 1024;
 		CursorOff = 0x1000;
-		linearSize = 8192;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
 
 		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
@@ -2032,7 +1981,7 @@ static int __devinit neo_init_hw(struct 
 */
 	par->maxClock = maxClock;
 	par->cursorOff = CursorOff;
-	return ((videoRam * 1024));
+	return videoRam * 1024;
 }
 
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

