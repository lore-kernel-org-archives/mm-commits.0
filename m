From: akpm@linux-foundation.org
Subject: - gbefb-cmap-fifo-timeout.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:35 -0700
Message-ID: <200807301915.m6UJFZNE011036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbYG3TRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tsbogend@alpha.franken.de, adaplas@pol.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     gbefb: cmap FIFO timeout
has been removed from the -mm tree.  Its filename was
     gbefb-cmap-fifo-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gbefb: cmap FIFO timeout
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Writes to the cmap fifo while the display is blanked caused cmap FIFO
timeout messages and a wrong colormap.  To avoid this the driver now
maintains a colormap in memory and updates the colormap after the display
is unblanked.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/gbefb.c |   50 +++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff -puN drivers/video/gbefb.c~gbefb-cmap-fifo-timeout drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~gbefb-cmap-fifo-timeout
+++ a/drivers/video/gbefb.c
@@ -87,6 +87,8 @@ static int gbe_revision;
 static int ypan, ywrap;
 
 static uint32_t pseudo_palette[16];
+static uint32_t gbe_cmap[256];
+static int gbe_turned_on; /* 0 turned off, 1 turned on */
 
 static char *mode_option __initdata = NULL;
 
@@ -208,6 +210,8 @@ void gbe_turn_off(void)
 	int i;
 	unsigned int val, x, y, vpixen_off;
 
+	gbe_turned_on = 0;
+
 	/* check if pixel counter is on */
 	val = gbe->vt_xy;
 	if (GET_GBE_FIELD(VT_XY, FREEZE, val) == 1)
@@ -371,6 +375,22 @@ static void gbe_turn_on(void)
 	}
 	if (i == 10000)
 		printk(KERN_ERR "gbefb: turn on DMA timed out\n");
+
+	gbe_turned_on = 1;
+}
+
+static void gbe_loadcmap(void)
+{
+	int i, j;
+
+	for (i = 0; i < 256; i++) {
+		for (j = 0; j < 1000 && gbe->cm_fifo >= 63; j++)
+			udelay(10);
+		if (j == 1000)
+			printk(KERN_ERR "gbefb: cmap FIFO timeout\n");
+
+		gbe->cmap[i] = gbe_cmap[i];
+	}
 }
 
 /*
@@ -382,6 +402,7 @@ static int gbefb_blank(int blank, struct
 	switch (blank) {
 	case FB_BLANK_UNBLANK:		/* unblank */
 		gbe_turn_on();
+		gbe_loadcmap();
 		break;
 
 	case FB_BLANK_NORMAL:		/* blank */
@@ -796,16 +817,10 @@ static int gbefb_set_par(struct fb_info 
 		gbe->gmap[i] = (i << 24) | (i << 16) | (i << 8);
 
 	/* Initialize the color map */
-	for (i = 0; i < 256; i++) {
-		int j;
-
-		for (j = 0; j < 1000 && gbe->cm_fifo >= 63; j++)
-			udelay(10);
-		if (j == 1000)
-			printk(KERN_ERR "gbefb: cmap FIFO timeout\n");
+	for (i = 0; i < 256; i++)
+		gbe_cmap[i] = (i << 8) | (i << 16) | (i << 24);
 
-		gbe->cmap[i] = (i << 8) | (i << 16) | (i << 24);
-	}
+	gbe_loadcmap();
 
 	return 0;
 }
@@ -855,14 +870,17 @@ static int gbefb_setcolreg(unsigned regn
 	blue >>= 8;
 
 	if (info->var.bits_per_pixel <= 8) {
-		/* wait for the color map FIFO to have a free entry */
-		for (i = 0; i < 1000 && gbe->cm_fifo >= 63; i++)
-			udelay(10);
-		if (i == 1000) {
-			printk(KERN_ERR "gbefb: cmap FIFO timeout\n");
-			return 1;
+		gbe_cmap[regno] = (red << 24) | (green << 16) | (blue << 8);
+		if (gbe_turned_on) {
+			/* wait for the color map FIFO to have a free entry */
+			for (i = 0; i < 1000 && gbe->cm_fifo >= 63; i++)
+				udelay(10);
+			if (i == 1000) {
+				printk(KERN_ERR "gbefb: cmap FIFO timeout\n");
+				return 1;
+			}
+			gbe->cmap[regno] = gbe_cmap[regno];
 		}
-		gbe->cmap[regno] = (red << 24) | (green << 16) | (blue << 8);
 	} else if (regno < 16) {
 		switch (info->var.bits_per_pixel) {
 		case 15:
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

origin.patch
linux-next.patch

