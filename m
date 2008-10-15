From: akpm@linux-foundation.org
Subject: - viafb-accelc-accelh-update.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:52:44 -0700
Message-ID: <200810152352.m9FNqiB5023904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234AbYJOXwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JosephChan@via.com.tw, josephchan@via.com.tw, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     viafb: accel.c & accel.h (update)
has been removed from the -mm tree.  Its filename was
     viafb-accelc-accelh-update.patch

This patch was dropped because it was folded into viafb-accelc-accelh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: accel.c & accel.h (update)
From: <JosephChan@via.com.tw>

Remove the marco MMIO_OUT32, and replace it with writel() function.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |  202 +++++++++++++++++++++---------------
 drivers/video/via/accel.h |   11 -
 2 files changed, 119 insertions(+), 94 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-accelc-accelh-update drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-accelc-accelh-update
+++ a/drivers/video/via/accel.c
@@ -38,44 +38,44 @@ void viafb_init_2d_engine(void)
 	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
 
 	/* init 2D engine regs to reset 2D engine */
-	MMIO_OUT32(VIA_REG_GEMODE, 0x0);
-	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
-	MMIO_OUT32(VIA_REG_DSTPOS, 0x0);
-	MMIO_OUT32(VIA_REG_DIMENSION, 0x0);
-	MMIO_OUT32(VIA_REG_PATADDR, 0x0);
-	MMIO_OUT32(VIA_REG_FGCOLOR, 0x0);
-	MMIO_OUT32(VIA_REG_BGCOLOR, 0x0);
-	MMIO_OUT32(VIA_REG_CLIPTL, 0x0);
-	MMIO_OUT32(VIA_REG_CLIPBR, 0x0);
-	MMIO_OUT32(VIA_REG_OFFSET, 0x0);
-	MMIO_OUT32(VIA_REG_KEYCONTROL, 0x0);
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
-	MMIO_OUT32(VIA_REG_DSTBASE, 0x0);
-	MMIO_OUT32(VIA_REG_PITCH, 0x0);
-	MMIO_OUT32(VIA_REG_MONOPAT1, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_GEMODE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCPOS);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTPOS);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DIMENSION);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_PATADDR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_FGCOLOR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_BGCOLOR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CLIPTL);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CLIPBR);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_OFFSET);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_KEYCONTROL);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_PITCH);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_MONOPAT1);
 
 	/* Init AGP and VQ regs */
 	switch (viaparinfo->chip_info->gfx_chip_name) {
 	case UNICHROME_K8M890:
 	case UNICHROME_P4M900:
-		MMIO_OUT32(VIA_REG_CR_TRANSET, 0x00100000);
-		MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x680A0000);
-		MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x02000000);
+		writel(0x00100000, viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+		writel(0x680A0000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+		writel(0x02000000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
 		break;
 
 	default:
-		MMIO_OUT32(VIA_REG_TRANSET, 0x00100000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00333004);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x60000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x61000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x62000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x63000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x64000000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x7D000000);
+		writel(0x00100000, viaparinfo->io_virt + VIA_REG_TRANSET);
+		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x00333004, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x60000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x61000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x62000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x63000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x64000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x7D000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
 
-		MMIO_OUT32(VIA_REG_TRANSET, 0xFE020000);
-		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000000);
+		writel(0xFE020000, viaparinfo->io_virt + VIA_REG_TRANSET);
+		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
 		break;
 	}
 	if (viaparinfo->VQ_start != 0) {
@@ -104,37 +104,64 @@ void viafb_init_2d_engine(void)
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M900:
-			MMIO_OUT32(VIA_REG_CR_TRANSET, 0x00100000);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQStartEndH);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQStartL);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQEndL);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, dwVQLen);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x74301001);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x00000000);
+			writel(0x00100000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+			writel(dwVQStartEndH,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(dwVQStartL,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(dwVQEndL,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(dwVQLen,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(0x74301001,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			writel(0x00000000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
 			break;
 		default:
-			MMIO_OUT32(VIA_REG_TRANSET, 0x00FE0000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x080003FE);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0A00027C);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0B000260);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0C000274);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0D000264);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0E000000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0F000020);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x1000027E);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x110002FE);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x200F0060);
-
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000006);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x40008C0F);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x44000000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x45080C04);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x46800408);
-
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQStartEndH);
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQStartL);
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQEndL);
-			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQLen);
+			writel(0x00FE0000,
+				viaparinfo->io_virt + VIA_REG_TRANSET);
+			writel(0x080003FE,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0A00027C,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0B000260,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0C000274,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0D000264,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0E000000,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x0F000020,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x1000027E,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x110002FE,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x200F0060,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+
+			writel(0x00000006,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x40008C0F,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x44000000,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x45080C04,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x46800408,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+
+			writel(dwVQStartEndH,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(dwVQStartL,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(dwVQEndL,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(dwVQLen,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
 			break;
 		}
 	} else {
@@ -142,38 +169,46 @@ void viafb_init_2d_engine(void)
 		switch (viaparinfo->chip_info->gfx_chip_name) {
 		case UNICHROME_K8M890:
 		case UNICHROME_P4M900:
-			MMIO_OUT32(VIA_REG_CR_TRANSET, 0x00100000);
-			MMIO_OUT32(VIA_REG_CR_TRANSPACE, 0x74301000);
+			writel(0x00100000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+			writel(0x74301000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
 			break;
 		default:
-			MMIO_OUT32(VIA_REG_TRANSET, 0x00FE0000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000004);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x40008C0F);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x44000000);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x45080C04);
-			MMIO_OUT32(VIA_REG_TRANSPACE, 0x46800408);
+			writel(0x00FE0000,
+				viaparinfo->io_virt + VIA_REG_TRANSET);
+			writel(0x00000004,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x40008C0F,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x44000000,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x45080C04,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
+			writel(0x46800408,
+				viaparinfo->io_virt + VIA_REG_TRANSPACE);
 			break;
 		}
 	}
 
 	viafb_set_2d_color_depth(viaparinfo->bpp);
 
-	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
-	MMIO_OUT32(VIA_REG_DSTBASE, 0x0);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
 
-	MMIO_OUT32(VIA_REG_PITCH,
-		   VIA_PITCH_ENABLE |
+	writel(VIA_PITCH_ENABLE |
 		   (((viaparinfo->hres *
 		      viaparinfo->bpp >> 3) >> 3) | (((viaparinfo->hres *
 						   viaparinfo->
-						   bpp >> 3) >> 3) << 16)));
+						   bpp >> 3) >> 3) << 16)),
+					viaparinfo->io_virt + VIA_REG_PITCH);
 }
 
 void viafb_set_2d_color_depth(int bpp)
 {
 	u32 dwGEMode;
 
-	dwGEMode = MMIO_IN32(0x04) & 0xFFFFFCFF;
+	dwGEMode = readl(viaparinfo->io_virt + 0x04) & 0xFFFFFCFF;
 
 	switch (bpp) {
 	case 16:
@@ -188,17 +223,18 @@ void viafb_set_2d_color_depth(int bpp)
 	}
 
 	/* Set BPP and Pitch */
-	MMIO_OUT32(VIA_REG_GEMODE, dwGEMode);
+	writel(dwGEMode, viaparinfo->io_virt + VIA_REG_GEMODE);
 }
 
 void viafb_hw_cursor_init(void)
 {
 	/* Set Cursor Image Base Address */
-	MMIO_OUT32(VIA_REG_CURSOR_MODE, viaparinfo->cursor_start);
-	MMIO_OUT32(VIA_REG_CURSOR_POS, 0x0);
-	MMIO_OUT32(VIA_REG_CURSOR_ORG, 0x0);
-	MMIO_OUT32(VIA_REG_CURSOR_BG, 0x0);
-	MMIO_OUT32(VIA_REG_CURSOR_FG, 0x0);
+	writel(viaparinfo->cursor_start,
+		viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_BG);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_FG);
 }
 
 void viafb_show_hw_cursor(struct fb_info *info, int Status)
@@ -206,7 +242,7 @@ void viafb_show_hw_cursor(struct fb_info
 	u32 temp;
 	u32 iga_path = ((struct viafb_par *)(info->par))->iga_path;
 
-	temp = MMIO_IN32(VIA_REG_CURSOR_MODE);
+	temp = readl(viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 	switch (Status) {
 	case HW_Cursor_ON:
 		temp |= 0x1;
@@ -223,18 +259,18 @@ void viafb_show_hw_cursor(struct fb_info
 	default:
 		temp &= 0x7FFFFFFF;
 	}
-	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp);
+	writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
 }
 
 int viafb_wait_engine_idle(void)
 {
 	int loop = 0;
 
-	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) &&
-			(loop++ < MAXLOOP))
+	while (!(readl(viaparinfo->io_virt + VIA_REG_STATUS) &
+			VIA_VR_QUEUE_BUSY) && (loop++ < MAXLOOP))
 		cpu_relax();
 
-	while ((MMIO_IN32(VIA_REG_STATUS) &
+	while ((readl(viaparinfo->io_virt + VIA_REG_STATUS) &
 		    (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
 		    (loop++ < MAXLOOP))
 		cpu_relax();
diff -puN drivers/video/via/accel.h~viafb-accelc-accelh-update drivers/video/via/accel.h
--- a/drivers/video/via/accel.h~viafb-accelc-accelh-update
+++ a/drivers/video/via/accel.h
@@ -31,17 +31,6 @@
 #define MMIO_SR_READ                (MMIO_VGABASE + 0x3C4)
 #define MMIO_SR_WRITE               (MMIO_VGABASE + 0x3C5)
 
-#define VIA_MMIO 1
-
-#if VIA_MMIO
-#define MMIO_OUT32(reg, val) writel(val, viaparinfo->io_virt + reg)
-#define MMIO_IN32(reg)      readl(viaparinfo->io_virt + reg)
-
-#else
-#define MMIO_OUT32(reg, val) outl(val, reg)
-#define MMIO_IN32(reg)      inl(reg)
-#endif
-
 /* HW Cursor Status Define */
 #define HW_Cursor_ON    0
 #define HW_Cursor_OFF   1
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

viafb-viafbmodes-viafbtxt.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-update.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
viafb-viafbdevc-update.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
viafb-maintainers-entry.patch

