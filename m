From: akpm@linux-foundation.org
Subject: - viafb-accelc-accelh.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:21 -0700
Message-ID: <200810182316.m9INGLLE028794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYJRXQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb: accel.c, accel.h
has been removed from the -mm tree.  Its filename was
     viafb-accelc-accelh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: accel.c, accel.h
From: Joseph Chan <JosephChan@via.com.tw>

2D and HW cursor stuff of viafb driver.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c |  279 ++++++++++++++++++++++++++++++++++++
 drivers/video/via/accel.h |  169 +++++++++++++++++++++
 2 files changed, 448 insertions(+)

diff -puN /dev/null drivers/video/via/accel.c
--- /dev/null
+++ a/drivers/video/via/accel.c
@@ -0,0 +1,279 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include "global.h"
+
+void viafb_init_accel(void)
+{
+	viaparinfo->fbmem_free -= CURSOR_SIZE;
+	viaparinfo->cursor_start = viaparinfo->fbmem_free;
+	viaparinfo->fbmem_used += CURSOR_SIZE;
+
+	/* Reverse 8*1024 memory space for cursor image */
+	viaparinfo->fbmem_free -= (CURSOR_SIZE + VQ_SIZE);
+	viaparinfo->VQ_start = viaparinfo->fbmem_free;
+	viaparinfo->VQ_end = viaparinfo->VQ_start + VQ_SIZE - 1;
+	viaparinfo->fbmem_used += (CURSOR_SIZE + VQ_SIZE); }
+
+void viafb_init_2d_engine(void)
+{
+	u32 dwVQStartAddr, dwVQEndAddr;
+	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
+
+	/* init 2D engine regs to reset 2D engine */
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
+
+	/* Init AGP and VQ regs */
+	switch (viaparinfo->chip_info->gfx_chip_name) {
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M900:
+		writel(0x00100000, viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+		writel(0x680A0000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+		writel(0x02000000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+		break;
+
+	default:
+		writel(0x00100000, viaparinfo->io_virt + VIA_REG_TRANSET);
+		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x00333004, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x60000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x61000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x62000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x63000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x64000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		writel(0x7D000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+
+		writel(0xFE020000, viaparinfo->io_virt + VIA_REG_TRANSET);
+		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
+		break;
+	}
+	if (viaparinfo->VQ_start != 0) {
+		/* Enable VQ */
+		dwVQStartAddr = viaparinfo->VQ_start;
+		dwVQEndAddr = viaparinfo->VQ_end;
+
+		dwVQStartL = 0x50000000 | (dwVQStartAddr & 0xFFFFFF);
+		dwVQEndL = 0x51000000 | (dwVQEndAddr & 0xFFFFFF);
+		dwVQStartEndH = 0x52000000 |
+			((dwVQStartAddr & 0xFF000000) >> 24) |
+			((dwVQEndAddr & 0xFF000000) >> 16);
+		dwVQLen = 0x53000000 | (VQ_SIZE >> 3);
+		switch (viaparinfo->chip_info->gfx_chip_name) {
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M900:
+			dwVQStartL |= 0x20000000;
+			dwVQEndL |= 0x20000000;
+			dwVQStartEndH |= 0x20000000;
+			dwVQLen |= 0x20000000;
+			break;
+		default:
+			break;
+		}
+
+		switch (viaparinfo->chip_info->gfx_chip_name) {
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M900:
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
+			break;
+		default:
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
+			break;
+		}
+	} else {
+		/* Disable VQ */
+		switch (viaparinfo->chip_info->gfx_chip_name) {
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M900:
+			writel(0x00100000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSET);
+			writel(0x74301000,
+				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+			break;
+		default:
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
+			break;
+		}
+	}
+
+	viafb_set_2d_color_depth(viaparinfo->bpp);
+
+	writel(0x0, viaparinfo->io_virt + VIA_REG_SRCBASE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_DSTBASE);
+
+	writel(VIA_PITCH_ENABLE |
+		   (((viaparinfo->hres *
+		      viaparinfo->bpp >> 3) >> 3) | (((viaparinfo->hres *
+						   viaparinfo->
+						   bpp >> 3) >> 3) << 16)),
+					viaparinfo->io_virt + VIA_REG_PITCH);
+}
+
+void viafb_set_2d_color_depth(int bpp)
+{
+	u32 dwGEMode;
+
+	dwGEMode = readl(viaparinfo->io_virt + 0x04) & 0xFFFFFCFF;
+
+	switch (bpp) {
+	case 16:
+		dwGEMode |= VIA_GEM_16bpp;
+		break;
+	case 32:
+		dwGEMode |= VIA_GEM_32bpp;
+		break;
+	default:
+		dwGEMode |= VIA_GEM_8bpp;
+		break;
+	}
+
+	/* Set BPP and Pitch */
+	writel(dwGEMode, viaparinfo->io_virt + VIA_REG_GEMODE);
+}
+
+void viafb_hw_cursor_init(void)
+{
+	/* Set Cursor Image Base Address */
+	writel(viaparinfo->cursor_start,
+		viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_BG);
+	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_FG);
+}
+
+void viafb_show_hw_cursor(struct fb_info *info, int Status)
+{
+	u32 temp;
+	u32 iga_path = ((struct viafb_par *)(info->par))->iga_path;
+
+	temp = readl(viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+	switch (Status) {
+	case HW_Cursor_ON:
+		temp |= 0x1;
+		break;
+	case HW_Cursor_OFF:
+		temp &= 0xFFFFFFFE;
+		break;
+	}
+	switch (iga_path) {
+	case IGA2:
+		temp |= 0x80000000;
+		break;
+	case IGA1:
+	default:
+		temp &= 0x7FFFFFFF;
+	}
+	writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+}
+
+int viafb_wait_engine_idle(void)
+{
+	int loop = 0;
+
+	while (!(readl(viaparinfo->io_virt + VIA_REG_STATUS) &
+			VIA_VR_QUEUE_BUSY) && (loop++ < MAXLOOP))
+		cpu_relax();
+
+	while ((readl(viaparinfo->io_virt + VIA_REG_STATUS) &
+		    (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
+		    (loop++ < MAXLOOP))
+		cpu_relax();
+
+	return loop >= MAXLOOP;
+}
diff -puN /dev/null drivers/video/via/accel.h
--- /dev/null
+++ a/drivers/video/via/accel.h
@@ -0,0 +1,169 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __ACCEL_H__
+#define __ACCEL_H__
+
+#define FB_ACCEL_VIA_UNICHROME  50
+
+/* MMIO Base Address Definition */
+#define MMIO_VGABASE                0x8000
+#define MMIO_CR_READ                (MMIO_VGABASE + 0x3D4)
+#define MMIO_CR_WRITE               (MMIO_VGABASE + 0x3D5)
+#define MMIO_SR_READ                (MMIO_VGABASE + 0x3C4)
+#define MMIO_SR_WRITE               (MMIO_VGABASE + 0x3C5)
+
+/* HW Cursor Status Define */
+#define HW_Cursor_ON    0
+#define HW_Cursor_OFF   1
+
+#define CURSOR_SIZE     (8 * 1024)
+#define VQ_SIZE         (256 * 1024)
+
+#define VIA_MMIO_BLTBASE        0x200000
+#define VIA_MMIO_BLTSIZE        0x200000
+
+/* Defines for 2D registers */
+#define VIA_REG_GECMD           0x000
+#define VIA_REG_GEMODE          0x004
+#define VIA_REG_SRCPOS          0x008
+#define VIA_REG_DSTPOS          0x00C
+/* width and height */
+#define VIA_REG_DIMENSION       0x010
+#define VIA_REG_PATADDR         0x014
+#define VIA_REG_FGCOLOR         0x018
+#define VIA_REG_BGCOLOR         0x01C
+/* top and left of clipping */
+#define VIA_REG_CLIPTL          0x020
+/* bottom and right of clipping */
+#define VIA_REG_CLIPBR          0x024
+#define VIA_REG_OFFSET          0x028
+/* color key control */
+#define VIA_REG_KEYCONTROL      0x02C
+#define VIA_REG_SRCBASE         0x030
+#define VIA_REG_DSTBASE         0x034
+/* pitch of src and dst */
+#define VIA_REG_PITCH           0x038
+#define VIA_REG_MONOPAT0        0x03C
+#define VIA_REG_MONOPAT1        0x040
+/* from 0x100 to 0x1ff */
+#define VIA_REG_COLORPAT        0x100
+
+/* VIA_REG_PITCH(0x38): Pitch Setting */
+#define VIA_PITCH_ENABLE        0x80000000
+
+/* defines for VIA HW cursor registers */
+#define VIA_REG_CURSOR_MODE     0x2D0
+#define VIA_REG_CURSOR_POS      0x2D4
+#define VIA_REG_CURSOR_ORG      0x2D8
+#define VIA_REG_CURSOR_BG       0x2DC
+#define VIA_REG_CURSOR_FG       0x2E0
+
+/* VIA_REG_GEMODE(0x04): GE mode */
+#define VIA_GEM_8bpp            0x00000000
+#define VIA_GEM_16bpp           0x00000100
+#define VIA_GEM_32bpp           0x00000300
+
+/* VIA_REG_GECMD(0x00): 2D Engine Command  */
+#define VIA_GEC_NOOP            0x00000000
+#define VIA_GEC_BLT             0x00000001
+#define VIA_GEC_LINE            0x00000005
+
+/* Rotate Command */
+#define VIA_GEC_ROT             0x00000008
+
+#define VIA_GEC_SRC_XY          0x00000000
+#define VIA_GEC_SRC_LINEAR      0x00000010
+#define VIA_GEC_DST_XY          0x00000000
+#define VIA_GEC_DST_LINRAT      0x00000020
+
+#define VIA_GEC_SRC_FB          0x00000000
+#define VIA_GEC_SRC_SYS         0x00000040
+#define VIA_GEC_DST_FB          0x00000000
+#define VIA_GEC_DST_SYS         0x00000080
+
+/* source is mono */
+#define VIA_GEC_SRC_MONO        0x00000100
+/* pattern is mono */
+#define VIA_GEC_PAT_MONO        0x00000200
+/* mono src is opaque */
+#define VIA_GEC_MSRC_OPAQUE     0x00000000
+/* mono src is transparent */
+#define VIA_GEC_MSRC_TRANS      0x00000400
+/* pattern is in frame buffer */
+#define VIA_GEC_PAT_FB          0x00000000
+/* pattern is from reg setting */
+#define VIA_GEC_PAT_REG         0x00000800
+
+#define VIA_GEC_CLIP_DISABLE    0x00000000
+#define VIA_GEC_CLIP_ENABLE     0x00001000
+
+#define VIA_GEC_FIXCOLOR_PAT    0x00002000
+
+#define VIA_GEC_INCX            0x00000000
+#define VIA_GEC_DECY            0x00004000
+#define VIA_GEC_INCY            0x00000000
+#define VIA_GEC_DECX            0x00008000
+/* mono pattern is opaque */
+#define VIA_GEC_MPAT_OPAQUE     0x00000000
+/* mono pattern is transparent */
+#define VIA_GEC_MPAT_TRANS      0x00010000
+
+#define VIA_GEC_MONO_UNPACK     0x00000000
+#define VIA_GEC_MONO_PACK       0x00020000
+#define VIA_GEC_MONO_DWORD      0x00000000
+#define VIA_GEC_MONO_WORD       0x00040000
+#define VIA_GEC_MONO_BYTE       0x00080000
+
+#define VIA_GEC_LASTPIXEL_ON    0x00000000
+#define VIA_GEC_LASTPIXEL_OFF   0x00100000
+#define VIA_GEC_X_MAJOR         0x00000000
+#define VIA_GEC_Y_MAJOR         0x00200000
+#define VIA_GEC_QUICK_START     0x00800000
+
+/* defines for VIA 3D registers */
+#define VIA_REG_STATUS          0x400
+#define VIA_REG_CR_TRANSET      0x41C
+#define VIA_REG_CR_TRANSPACE	0x420
+#define VIA_REG_TRANSET         0x43C
+#define VIA_REG_TRANSPACE       0x440
+
+/* VIA_REG_STATUS(0x400): Engine Status */
+
+/* Command Regulator is busy */
+#define VIA_CMD_RGTR_BUSY       0x00000080
+/* 2D Engine is busy */
+#define VIA_2D_ENG_BUSY         0x00000002
+/* 3D Engine is busy */
+#define VIA_3D_ENG_BUSY         0x00000001
+/* Virtual Queue is busy */
+#define VIA_VR_QUEUE_BUSY       0x00020000
+
+#define MAXLOOP                 0xFFFFFF
+
+void viafb_init_accel(void);
+void viafb_init_2d_engine(void);
+void set_2d_color_depth(int);
+void viafb_hw_cursor_init(void);
+void viafb_show_hw_cursor(struct fb_info *info, int Status); int
+viafb_wait_engine_idle(void); void viafb_set_2d_color_depth(int bpp);
+
+#endif /* __ACCEL_H__ */
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

origin.patch

