From: akpm@linux-foundation.org
Subject: [merged] viafb-support-color-depth-15-and-30.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:56:49 -0400
Message-ID: <201003150657.o2F6vMOG016366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934519Ab0COG51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, mm-commits@vger.kernel.org


The patch titled
     viafb: support color depth 15 and 30
has been removed from the -mm tree.  Its filename was
     viafb-support-color-depth-15-and-30.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: support color depth 15 and 30
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Add support for the color depth 15 on IGA1 and 30 on IGA1 and IGA2.  To
allow the usage of those the driver now refuses color depth that are
totally off and otherwise the selection in viafb_check_var is used. 
Therefore the first call to this for the first framebuffer was delayed a
bit.  It only enables the new formats if they are requested exactly
(viafb_bpp=15|30).

As this is a new feature, no regressions are expected.  The color depth 15
was successfully tested.  Didn't get anything usable for 30 but that might
be the programs fault.  I would like to get some feedback whether it works
as expected or not if somebody knows a program/configuration where it
should.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |    9 ++++++
 drivers/video/via/viafbdev.c |   43 +++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 18 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-support-color-depth-15-and-30 drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-support-color-depth-15-and-30
+++ a/drivers/video/via/hw.c
@@ -694,12 +694,18 @@ void viafb_set_primary_color_depth(u8 de
 	case 8:
 		value = 0x00;
 		break;
+	case 15:
+		value = 0x04;
+		break;
 	case 16:
 		value = 0x14;
 		break;
 	case 24:
 		value = 0x0C;
 		break;
+	case 30:
+		value = 0x08;
+		break;
 	default:
 		printk(KERN_WARNING "viafb_set_primary_color_depth: "
 			"Unsupported depth: %d\n", depth);
@@ -724,6 +730,9 @@ void viafb_set_secondary_color_depth(u8 
 	case 24:
 		value = 0xC0;
 		break;
+	case 30:
+		value = 0x80;
+		break;
 	default:
 		printk(KERN_WARNING "viafb_set_secondary_color_depth: "
 			"Unsupported depth: %d\n", depth);
diff -puN drivers/video/via/viafbdev.c~viafb-support-color-depth-15-and-30 drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-support-color-depth-15-and-30
+++ a/drivers/video/via/viafbdev.c
@@ -80,6 +80,15 @@ static void viafb_fill_var_color_info(st
 		var->green.length = 8;
 		var->blue.length = 8;
 		break;
+	case 15:
+		var->bits_per_pixel = 16;
+		var->red.offset = 10;
+		var->green.offset = 5;
+		var->blue.offset = 0;
+		var->red.length = 5;
+		var->green.length = 5;
+		var->blue.length = 5;
+		break;
 	case 16:
 		var->bits_per_pixel = 16;
 		var->red.offset = 11;
@@ -98,6 +107,15 @@ static void viafb_fill_var_color_info(st
 		var->green.length = 8;
 		var->blue.length = 8;
 		break;
+	case 30:
+		var->bits_per_pixel = 32;
+		var->red.offset = 20;
+		var->green.offset = 10;
+		var->blue.offset = 0;
+		var->red.length = 10;
+		var->green.length = 10;
+		var->blue.length = 10;
+		break;
 	}
 }
 
@@ -171,6 +189,10 @@ static int viafb_check_var(struct fb_var
 		return -EINVAL;
 	else if (!depth)
 		depth = 24;
+	else if (depth == 15 && viafb_dual_fb && ppar->iga_path == IGA1)
+		depth = 15;
+	else if (depth == 30)
+		depth = 30;
 	else if (depth <= 8)
 		depth = 8;
 	else if (depth <= 16)
@@ -1811,19 +1833,6 @@ static int __devinit via_pci_probe(struc
 			viafb_second_virtual_yres = viafb_second_yres;
 	}
 
-	switch (viafb_bpp) {
-	case 0 ... 8:
-		viafb_bpp = 8;
-		break;
-	case 9 ... 16:
-		viafb_bpp = 16;
-		break;
-	case 17 ... 32:
-		viafb_bpp = 32;
-		break;
-	default:
-		viafb_bpp = 8;
-	}
 	default_var.xres = default_xres;
 	default_var.yres = default_yres;
 	switch (default_xres) {
@@ -1836,8 +1845,6 @@ static int __devinit via_pci_probe(struc
 	}
 	default_var.yres_virtual = default_yres;
 	default_var.bits_per_pixel = viafb_bpp;
-	if (default_var.bits_per_pixel == 15)
-		default_var.bits_per_pixel = 16;
 	default_var.pixclock =
 	    viafb_get_pixclock(default_xres, default_yres, viafb_refresh);
 	default_var.left_margin = (default_xres >> 3) & 0xf8;
@@ -1847,7 +1854,6 @@ static int __devinit via_pci_probe(struc
 	default_var.hsync_len = default_var.left_margin;
 	default_var.vsync_len = 4;
 	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
-	viafb_check_var(&default_var, viafbinfo);
 	viafbinfo->var = default_var;
 
 	if (viafb_dual_fb) {
@@ -1883,8 +1889,6 @@ static int __devinit via_pci_probe(struc
 		default_var.yres = viafb_second_yres;
 		default_var.xres_virtual = viafb_second_virtual_xres;
 		default_var.yres_virtual = viafb_second_virtual_yres;
-		if (viafb_bpp1 != viafb_bpp)
-			viafb_bpp1 = viafb_bpp;
 		default_var.bits_per_pixel = viafb_bpp1;
 		default_var.pixclock =
 		    viafb_get_pixclock(viafb_second_xres, viafb_second_yres,
@@ -1904,6 +1908,7 @@ static int __devinit via_pci_probe(struc
 			&viafbinfo1->fix);
 	}
 
+	viafb_check_var(&viafbinfo->var, viafbinfo);
 	viafb_update_fix(viafbinfo);
 	viaparinfo->depth = fb_get_color_depth(&viafbinfo->var,
 		&viafbinfo->fix);
@@ -2070,6 +2075,8 @@ static int __init viafb_init(void)
 #endif
 	if (parse_mode(viafb_mode, &dummy, &dummy)
 		|| parse_mode(viafb_mode1, &dummy, &dummy)
+		|| viafb_bpp < 0 || viafb_bpp > 32
+		|| viafb_bpp1 < 0 || viafb_bpp1 > 32
 		|| parse_active_dev())
 		return -EINVAL;
 
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

