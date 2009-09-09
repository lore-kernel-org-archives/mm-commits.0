From: akpm@linux-foundation.org
Subject: + viafb-hardware-acceleration-initialization-cleanup.patch added to -mm tree
Date: Tue, 08 Sep 2009 17:26:35 -0700
Message-ID: <200909090026.n890QZDW031699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZIIA1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 20:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: hardware acceleration initialization cleanup
has been added to the -mm tree.  Its filename is
     viafb-hardware-acceleration-initialization-cleanup.patch

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
Subject: viafb: hardware acceleration initialization cleanup
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

The main motivation of this patch was to merge the three initialization
functions in one and clean it up. However as some changes in other code
areas where needed to do it right some small other changes were made.

Changes to viafb_par:

io_virt renamed as engine_mmio and moved to shared
VQ_start renamed as vq_vram_addr and moved to shared
VQ_end removed as it is easily recalculatable

vq_vram_addr is not strictly needed but keep it to track where we
allocated video memory.  The memory allocated for the virtual queue was
shrunk to VQ_SIZE as VQ_SIZE+CURSOR_SIZE looked like a bug to me.  But to
be honest I don't have the faintest idea what virtual queues are for in
the graphic hardware and whether the driver needs them in any way.  I only
know that they aren't directly accessed by the driver and so the only
potential current use would be as hardware internal buffers.  For now keep
them to avoid regressions and only remove the double cursor allocation.

The most changes were caused by renames and the mentioned structure
changes so the chance of regressions is pretty low.  The meaning of
viafb_accel changed slightly as previously it was changed back and forth
in the code and allowed to enable the hardware acceleration by software if
previously disabled.  The new behaviour is that viafb_accel=0 always
prevents hardware acceleration.  With viafb_accel!=0 the acceleration can
be freely choosen by set_var.  This means viafb_accel is a diagnostic tool
and if someone has to use viafb_accel=0 the driver needs to be fixed.

As this is mostly a code cleanup no regressions beside the slightly change
of viafb_accel is expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/accel.c    |  274 +++++++++++++--------------------
 drivers/video/via/accel.h    |    8 
 drivers/video/via/global.c   |    1 
 drivers/video/via/hw.h       |    1 
 drivers/video/via/viafbdev.c |   80 ++++-----
 drivers/video/via/viafbdev.h |    7 
 6 files changed, 151 insertions(+), 220 deletions(-)

diff -puN drivers/video/via/accel.c~viafb-hardware-acceleration-initialization-cleanup drivers/video/via/accel.c
--- a/drivers/video/via/accel.c~viafb-hardware-acceleration-initialization-cleanup
+++ a/drivers/video/via/accel.c
@@ -308,9 +308,22 @@ static int hw_bitblt_2(void __iomem *eng
 	return 0;
 }
 
-void viafb_init_accel(struct viafb_shared *shared)
+int viafb_init_engine(struct fb_info *info)
 {
-	switch (shared->chip_info.gfx_chip_name) {
+	struct viafb_par *viapar = info->par;
+	void __iomem *engine;
+	u32 vq_start_addr, vq_end_addr, vq_start_low, vq_end_low, vq_high,
+		vq_len, chip_name = viapar->shared->chip_info.gfx_chip_name;
+
+	engine = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
+	viapar->shared->engine_mmio = engine;
+	if (!engine) {
+		printk(KERN_WARNING "viafb_init_accel: ioremap failed, "
+			"hardware acceleration disabled\n");
+		return -ENOMEM;
+	}
+
+	switch (chip_name) {
 	case UNICHROME_CLE266:
 	case UNICHROME_K400:
 	case UNICHROME_K800:
@@ -321,186 +334,115 @@ void viafb_init_accel(struct viafb_share
 	case UNICHROME_K8M890:
 	case UNICHROME_P4M890:
 	case UNICHROME_P4M900:
-		shared->hw_bitblt = hw_bitblt_1;
+		viapar->shared->hw_bitblt = hw_bitblt_1;
 		break;
 	case UNICHROME_VX800:
-		shared->hw_bitblt = hw_bitblt_2;
+		viapar->shared->hw_bitblt = hw_bitblt_2;
 		break;
 	default:
-		shared->hw_bitblt = NULL;
+		viapar->shared->hw_bitblt = NULL;
 	}
 
-	viaparinfo->fbmem_free -= CURSOR_SIZE;
-	shared->cursor_vram_addr = viaparinfo->fbmem_free;
-	viaparinfo->fbmem_used += CURSOR_SIZE;
-
-	/* Reverse 8*1024 memory space for cursor image */
-	viaparinfo->fbmem_free -= (CURSOR_SIZE + VQ_SIZE);
-	viaparinfo->VQ_start = viaparinfo->fbmem_free;
-	viaparinfo->VQ_end = viaparinfo->VQ_start + VQ_SIZE - 1;
-	viaparinfo->fbmem_used += (CURSOR_SIZE + VQ_SIZE);
-}
+	viapar->fbmem_free -= CURSOR_SIZE;
+	viapar->shared->cursor_vram_addr = viapar->fbmem_free;
+	viapar->fbmem_used += CURSOR_SIZE;
 
-void viafb_init_2d_engine(void)
-{
-	u32 dwVQStartAddr, dwVQEndAddr;
-	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
+	viapar->fbmem_free -= VQ_SIZE;
+	viapar->shared->vq_vram_addr = viapar->fbmem_free;
+	viapar->fbmem_used += VQ_SIZE;
 
 	/* Init AGP and VQ regs */
-	switch (viaparinfo->chip_info->gfx_chip_name) {
+	switch (chip_name) {
 	case UNICHROME_K8M890:
 	case UNICHROME_P4M900:
-		writel(0x00100000, viaparinfo->io_virt + VIA_REG_CR_TRANSET);
-		writel(0x680A0000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-		writel(0x02000000, viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
+		writel(0x00100000, engine + VIA_REG_CR_TRANSET);
+		writel(0x680A0000, engine + VIA_REG_CR_TRANSPACE);
+		writel(0x02000000, engine + VIA_REG_CR_TRANSPACE);
 		break;
 
 	default:
-		writel(0x00100000, viaparinfo->io_virt + VIA_REG_TRANSET);
-		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		writel(0x00333004, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		writel(0x60000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		writel(0x61000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		writel(0x62000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		writel(0x63000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		writel(0x64000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		writel(0x7D000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-
-		writel(0xFE020000, viaparinfo->io_virt + VIA_REG_TRANSET);
-		writel(0x00000000, viaparinfo->io_virt + VIA_REG_TRANSPACE);
-		break;
-	}
-	if (viaparinfo->VQ_start != 0) {
-		/* Enable VQ */
-		dwVQStartAddr = viaparinfo->VQ_start;
-		dwVQEndAddr = viaparinfo->VQ_end;
-
-		dwVQStartL = 0x50000000 | (dwVQStartAddr & 0xFFFFFF);
-		dwVQEndL = 0x51000000 | (dwVQEndAddr & 0xFFFFFF);
-		dwVQStartEndH = 0x52000000 |
-			((dwVQStartAddr & 0xFF000000) >> 24) |
-			((dwVQEndAddr & 0xFF000000) >> 16);
-		dwVQLen = 0x53000000 | (VQ_SIZE >> 3);
-		switch (viaparinfo->chip_info->gfx_chip_name) {
-		case UNICHROME_K8M890:
-		case UNICHROME_P4M900:
-			dwVQStartL |= 0x20000000;
-			dwVQEndL |= 0x20000000;
-			dwVQStartEndH |= 0x20000000;
-			dwVQLen |= 0x20000000;
-			break;
-		default:
-			break;
-		}
-
-		switch (viaparinfo->chip_info->gfx_chip_name) {
-		case UNICHROME_K8M890:
-		case UNICHROME_P4M900:
-			writel(0x00100000,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSET);
-			writel(dwVQStartEndH,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-			writel(dwVQStartL,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-			writel(dwVQEndL,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-			writel(dwVQLen,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-			writel(0x74301001,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-			writel(0x00000000,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-			break;
-		default:
-			writel(0x00FE0000,
-				viaparinfo->io_virt + VIA_REG_TRANSET);
-			writel(0x080003FE,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x0A00027C,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x0B000260,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x0C000274,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x0D000264,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x0E000000,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x0F000020,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x1000027E,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x110002FE,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x200F0060,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-
-			writel(0x00000006,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x40008C0F,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x44000000,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x45080C04,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x46800408,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-
-			writel(dwVQStartEndH,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(dwVQStartL,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(dwVQEndL,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(dwVQLen,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			break;
-		}
-	} else {
-		/* Disable VQ */
-		switch (viaparinfo->chip_info->gfx_chip_name) {
-		case UNICHROME_K8M890:
-		case UNICHROME_P4M900:
-			writel(0x00100000,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSET);
-			writel(0x74301000,
-				viaparinfo->io_virt + VIA_REG_CR_TRANSPACE);
-			break;
-		default:
-			writel(0x00FE0000,
-				viaparinfo->io_virt + VIA_REG_TRANSET);
-			writel(0x00000004,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x40008C0F,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x44000000,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x45080C04,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			writel(0x46800408,
-				viaparinfo->io_virt + VIA_REG_TRANSPACE);
-			break;
-		}
+		writel(0x00100000, engine + VIA_REG_TRANSET);
+		writel(0x00000000, engine + VIA_REG_TRANSPACE);
+		writel(0x00333004, engine + VIA_REG_TRANSPACE);
+		writel(0x60000000, engine + VIA_REG_TRANSPACE);
+		writel(0x61000000, engine + VIA_REG_TRANSPACE);
+		writel(0x62000000, engine + VIA_REG_TRANSPACE);
+		writel(0x63000000, engine + VIA_REG_TRANSPACE);
+		writel(0x64000000, engine + VIA_REG_TRANSPACE);
+		writel(0x7D000000, engine + VIA_REG_TRANSPACE);
+
+		writel(0xFE020000, engine + VIA_REG_TRANSET);
+		writel(0x00000000, engine + VIA_REG_TRANSPACE);
+		break;
+	}
+
+	/* Enable VQ */
+	vq_start_addr = viapar->shared->vq_vram_addr;
+	vq_end_addr = viapar->shared->vq_vram_addr + VQ_SIZE - 1;
+
+	vq_start_low = 0x50000000 | (vq_start_addr & 0xFFFFFF);
+	vq_end_low = 0x51000000 | (vq_end_addr & 0xFFFFFF);
+	vq_high = 0x52000000 | ((vq_start_addr & 0xFF000000) >> 24) |
+		((vq_end_addr & 0xFF000000) >> 16);
+	vq_len = 0x53000000 | (VQ_SIZE >> 3);
+
+	switch (chip_name) {
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M900:
+		vq_start_low |= 0x20000000;
+		vq_end_low |= 0x20000000;
+		vq_high |= 0x20000000;
+		vq_len |= 0x20000000;
+
+		writel(0x00100000, engine + VIA_REG_CR_TRANSET);
+		writel(vq_high, engine + VIA_REG_CR_TRANSPACE);
+		writel(vq_start_low, engine + VIA_REG_CR_TRANSPACE);
+		writel(vq_end_low, engine + VIA_REG_CR_TRANSPACE);
+		writel(vq_len, engine + VIA_REG_CR_TRANSPACE);
+		writel(0x74301001, engine + VIA_REG_CR_TRANSPACE);
+		writel(0x00000000, engine + VIA_REG_CR_TRANSPACE);
+		break;
+	default:
+		writel(0x00FE0000, engine + VIA_REG_TRANSET);
+		writel(0x080003FE, engine + VIA_REG_TRANSPACE);
+		writel(0x0A00027C, engine + VIA_REG_TRANSPACE);
+		writel(0x0B000260, engine + VIA_REG_TRANSPACE);
+		writel(0x0C000274, engine + VIA_REG_TRANSPACE);
+		writel(0x0D000264, engine + VIA_REG_TRANSPACE);
+		writel(0x0E000000, engine + VIA_REG_TRANSPACE);
+		writel(0x0F000020, engine + VIA_REG_TRANSPACE);
+		writel(0x1000027E, engine + VIA_REG_TRANSPACE);
+		writel(0x110002FE, engine + VIA_REG_TRANSPACE);
+		writel(0x200F0060, engine + VIA_REG_TRANSPACE);
+
+		writel(0x00000006, engine + VIA_REG_TRANSPACE);
+		writel(0x40008C0F, engine + VIA_REG_TRANSPACE);
+		writel(0x44000000, engine + VIA_REG_TRANSPACE);
+		writel(0x45080C04, engine + VIA_REG_TRANSPACE);
+		writel(0x46800408, engine + VIA_REG_TRANSPACE);
+
+		writel(vq_high, engine + VIA_REG_TRANSPACE);
+		writel(vq_start_low, engine + VIA_REG_TRANSPACE);
+		writel(vq_end_low, engine + VIA_REG_TRANSPACE);
+		writel(vq_len, engine + VIA_REG_TRANSPACE);
+		break;
 	}
-}
 
-void viafb_hw_cursor_init(void)
-{
 	/* Set Cursor Image Base Address */
-	writel(viaparinfo->shared->cursor_vram_addr,
-		viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_POS);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_ORG);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_BG);
-	writel(0x0, viaparinfo->io_virt + VIA_REG_CURSOR_FG);
+	writel(viapar->shared->cursor_vram_addr, engine + VIA_REG_CURSOR_MODE);
+	writel(0x0, engine + VIA_REG_CURSOR_POS);
+	writel(0x0, engine + VIA_REG_CURSOR_ORG);
+	writel(0x0, engine + VIA_REG_CURSOR_BG);
+	writel(0x0, engine + VIA_REG_CURSOR_FG);
+	return 0;
 }
 
 void viafb_show_hw_cursor(struct fb_info *info, int Status)
 {
-	u32 temp;
-	u32 iga_path = ((struct viafb_par *)(info->par))->iga_path;
+	struct viafb_par *viapar = info->par;
+	u32 temp, iga_path = viapar->iga_path;
 
-	temp = readl(viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+	temp = readl(viapar->shared->engine_mmio + VIA_REG_CURSOR_MODE);
 	switch (Status) {
 	case HW_Cursor_ON:
 		temp |= 0x1;
@@ -517,25 +459,27 @@ void viafb_show_hw_cursor(struct fb_info
 	default:
 		temp &= 0x7FFFFFFF;
 	}
-	writel(temp, viaparinfo->io_virt + VIA_REG_CURSOR_MODE);
+	writel(temp, viapar->shared->engine_mmio + VIA_REG_CURSOR_MODE);
 }
 
-int viafb_wait_engine_idle(void)
+void viafb_wait_engine_idle(struct fb_info *info)
 {
+	struct viafb_par *viapar = info->par;
 	int loop = 0;
 
-	while (!(readl(viaparinfo->io_virt + VIA_REG_STATUS) &
+	while (!(readl(viapar->shared->engine_mmio + VIA_REG_STATUS) &
 			VIA_VR_QUEUE_BUSY) && (loop < MAXLOOP)) {
 		loop++;
 		cpu_relax();
 	}
 
-	while ((readl(viaparinfo->io_virt + VIA_REG_STATUS) &
+	while ((readl(viapar->shared->engine_mmio + VIA_REG_STATUS) &
 		    (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY)) &&
 		    (loop < MAXLOOP)) {
 		loop++;
 		cpu_relax();
 	}
 
-	return loop >= MAXLOOP;
+	if (loop >= MAXLOOP)
+		printk(KERN_ERR "viafb_wait_engine_idle: not syncing\n");
 }
diff -puN drivers/video/via/accel.h~viafb-hardware-acceleration-initialization-cleanup drivers/video/via/accel.h
--- a/drivers/video/via/accel.h~viafb-hardware-acceleration-initialization-cleanup
+++ a/drivers/video/via/accel.h
@@ -163,10 +163,8 @@
 #define VIA_BITBLT_MONO		2
 #define VIA_BITBLT_FILL		3
 
-void viafb_init_accel(struct viafb_shared *shared);
-void viafb_init_2d_engine(void);
-void viafb_hw_cursor_init(void);
-void viafb_show_hw_cursor(struct fb_info *info, int Status); int
-viafb_wait_engine_idle(void); void viafb_set_2d_color_depth(int bpp);
+int viafb_init_engine(struct fb_info *info);
+void viafb_show_hw_cursor(struct fb_info *info, int Status);
+void viafb_wait_engine_idle(struct fb_info *info);
 
 #endif /* __ACCEL_H__ */
diff -puN drivers/video/via/global.c~viafb-hardware-acceleration-initialization-cleanup drivers/video/via/global.c
--- a/drivers/video/via/global.c~viafb-hardware-acceleration-initialization-cleanup
+++ a/drivers/video/via/global.c
@@ -32,7 +32,6 @@ int viafb_lcd_dsp_method = LCD_EXPANDSIO
 int viafb_lcd_mode = LCD_OPENLDI;
 int viafb_bpp = 32;
 int viafb_bpp1 = 32;
-int viafb_accel = 1;
 int viafb_CRT_ON = 1;
 int viafb_DVI_ON;
 int viafb_LCD_ON ;
diff -puN drivers/video/via/hw.h~viafb-hardware-acceleration-initialization-cleanup drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-hardware-acceleration-initialization-cleanup
+++ a/drivers/video/via/hw.h
@@ -855,7 +855,6 @@ extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
 extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
-extern int viafb_accel;
 extern int viafb_hotplug;
 
 void viafb_write_reg_mask(u8 index, int io_port, u8 data, u8 mask);
diff -puN drivers/video/via/viafbdev.c~viafb-hardware-acceleration-initialization-cleanup drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-hardware-acceleration-initialization-cleanup
+++ a/drivers/video/via/viafbdev.c
@@ -33,6 +33,8 @@ static u32 pseudo_pal[17];
 static char *viafb_mode = "640x480";
 static char *viafb_mode1 = "640x480";
 
+static int viafb_accel = 1;
+
 /* Added for specifying active devices.*/
 char *viafb_active_dev = "";
 
@@ -140,6 +142,9 @@ static int viafb_check_var(struct fb_var
 
 	/* Adjust var according to our driver's own table */
 	viafb_fill_var_timing_info(var, viafb_refresh, vmode_index);
+	if (info->var.accel_flags & FB_ACCELF_TEXT &&
+		!ppar->shared->engine_mmio)
+		info->var.accel_flags = 0;
 
 	return 0;
 }
@@ -177,8 +182,10 @@ static int viafb_set_par(struct fb_info 
 
 		viafb_update_fix(info);
 		viafb_bpp = info->var.bits_per_pixel;
-		/* Update viafb_accel, it is necessary to our 2D accelerate */
-		viafb_accel = info->var.accel_flags;
+		if (info->var.accel_flags & FB_ACCELF_TEXT)
+			info->flags &= ~FBINFO_HWACCEL_DISABLED;
+		else
+			info->flags |= FBINFO_HWACCEL_DISABLED;
 	}
 
 	return 0;
@@ -764,10 +771,11 @@ static void viafb_fillrect(struct fb_inf
 	const struct fb_fillrect *rect)
 {
 	struct viafb_par *viapar = info->par;
+	struct viafb_shared *shared = viapar->shared;
 	u32 fg_color;
 	u8 rop;
 
-	if (!viapar->shared->hw_bitblt) {
+	if (info->flags & FBINFO_HWACCEL_DISABLED || !shared->hw_bitblt) {
 		cfb_fillrect(info, rect);
 		return;
 	}
@@ -786,7 +794,7 @@ static void viafb_fillrect(struct fb_inf
 		rop = 0xF0;
 
 	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: fillrect\n");
-	if (viapar->shared->hw_bitblt(viapar->io_virt, VIA_BITBLT_FILL,
+	if (shared->hw_bitblt(shared->engine_mmio, VIA_BITBLT_FILL,
 		rect->width, rect->height, info->var.bits_per_pixel,
 		viapar->vram_addr, info->fix.line_length, rect->dx, rect->dy,
 		NULL, 0, 0, 0, 0, fg_color, 0, rop))
@@ -797,8 +805,9 @@ static void viafb_copyarea(struct fb_inf
 	const struct fb_copyarea *area)
 {
 	struct viafb_par *viapar = info->par;
+	struct viafb_shared *shared = viapar->shared;
 
-	if (!viapar->shared->hw_bitblt) {
+	if (info->flags & FBINFO_HWACCEL_DISABLED || !shared->hw_bitblt) {
 		cfb_copyarea(info, area);
 		return;
 	}
@@ -807,7 +816,7 @@ static void viafb_copyarea(struct fb_inf
 		return;
 
 	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: copyarea\n");
-	if (viapar->shared->hw_bitblt(viapar->io_virt, VIA_BITBLT_COLOR,
+	if (shared->hw_bitblt(shared->engine_mmio, VIA_BITBLT_COLOR,
 		area->width, area->height, info->var.bits_per_pixel,
 		viapar->vram_addr, info->fix.line_length, area->dx, area->dy,
 		NULL, viapar->vram_addr, info->fix.line_length,
@@ -819,10 +828,11 @@ static void viafb_imageblit(struct fb_in
 	const struct fb_image *image)
 {
 	struct viafb_par *viapar = info->par;
+	struct viafb_shared *shared = viapar->shared;
 	u32 fg_color = 0, bg_color = 0;
 	u8 op;
 
-	if (!viapar->shared->hw_bitblt ||
+	if (info->flags & FBINFO_HWACCEL_DISABLED || !shared->hw_bitblt ||
 		(image->depth != 1 && image->depth != viapar->depth)) {
 		cfb_imageblit(info, image);
 		return;
@@ -843,7 +853,7 @@ static void viafb_imageblit(struct fb_in
 		op = VIA_BITBLT_COLOR;
 
 	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: imageblit\n");
-	if (viapar->shared->hw_bitblt(viapar->io_virt, op,
+	if (shared->hw_bitblt(shared->engine_mmio, op,
 		image->width, image->height, info->var.bits_per_pixel,
 		viapar->vram_addr, info->fix.line_length, image->dx, image->dy,
 		(u32 *)image->data, 0, 0, 0, 0, fg_color, bg_color, 0))
@@ -853,6 +863,7 @@ static void viafb_imageblit(struct fb_in
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	struct viafb_par *viapar = info->par;
+	void __iomem *engine = viapar->shared->engine_mmio;
 	u32 temp, xx, yy, bg_color = 0, fg_color = 0,
 		chip_name = viapar->shared->chip_info.gfx_chip_name;
 	int i, j = 0, cur_size = 64;
@@ -867,7 +878,7 @@ static int viafb_cursor(struct fb_info *
 
 	if (cursor->set & FB_CUR_SETHOT) {
 		temp = (cursor->hot.x << 16) + cursor->hot.y;
-		writel(temp, viapar->io_virt + VIA_REG_CURSOR_ORG);
+		writel(temp, engine + VIA_REG_CURSOR_ORG);
 	}
 
 	if (cursor->set & FB_CUR_SETPOS) {
@@ -875,7 +886,7 @@ static int viafb_cursor(struct fb_info *
 		xx = cursor->image.dx - info->var.xoffset;
 		temp = yy & 0xFFFF;
 		temp |= (xx << 16);
-		writel(temp, viapar->io_virt + VIA_REG_CURSOR_POS);
+		writel(temp, engine + VIA_REG_CURSOR_POS);
 	}
 
 	if (cursor->image.width <= 32 && cursor->image.height <= 32)
@@ -889,13 +900,13 @@ static int viafb_cursor(struct fb_info *
 	}
 
 	if (cursor->set & FB_CUR_SETSIZE) {
-		temp = readl(viapar->io_virt + VIA_REG_CURSOR_MODE);
+		temp = readl(engine + VIA_REG_CURSOR_MODE);
 		if (cur_size == 32)
 			temp |= 0x2;
 		else
 			temp &= ~0x2;
 
-		writel(temp, viapar->io_virt + VIA_REG_CURSOR_MODE);
+		writel(temp, engine + VIA_REG_CURSOR_MODE);
 	}
 
 	if (cursor->set & FB_CUR_SETCMAP) {
@@ -922,8 +933,8 @@ static int viafb_cursor(struct fb_info *
 				((info->cmap.blue[bg_color] & 0xFF00) >> 8);
 		}
 
-		writel(bg_color, viapar->io_virt + VIA_REG_CURSOR_BG);
-		writel(fg_color, viapar->io_virt + VIA_REG_CURSOR_FG);
+		writel(bg_color, engine + VIA_REG_CURSOR_BG);
+		writel(fg_color, engine + VIA_REG_CURSOR_FG);
 	}
 
 	if (cursor->set & FB_CUR_SETSHAPE) {
@@ -996,8 +1007,8 @@ static int viafb_cursor(struct fb_info *
 
 static int viafb_sync(struct fb_info *info)
 {
-	if (viafb_accel)
-		viafb_wait_engine_idle();
+	if (!(info->flags & FBINFO_HWACCEL_DISABLED))
+		viafb_wait_engine_idle(info);
 	return 0;
 }
 
@@ -1867,22 +1878,18 @@ static int __devinit via_pci_probe(void)
 
 	viafb_get_mmio_info(&viafbinfo->fix.mmio_start,
 		&viafbinfo->fix.mmio_len);
-	viaparinfo->io_virt = ioremap_nocache(viafbinfo->fix.mmio_start,
-		viafbinfo->fix.mmio_len);
-	if (!viaparinfo->io_virt) {
-		printk(KERN_WARNING "ioremap failed: hardware acceleration disabled\n");
-		viafb_accel = 0;
-	}
-
 	viafbinfo->node = 0;
 	viafbinfo->fbops = &viafb_ops;
 	viafbinfo->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 
 	viafbinfo->pseudo_palette = pseudo_pal;
-	if (viafb_accel) {
-		viafb_init_accel(viaparinfo->shared);
-		viafb_init_2d_engine();
-		viafb_hw_cursor_init();
+	if (viafb_accel && !viafb_init_engine(viafbinfo)) {
+		viafbinfo->flags |= FBINFO_HWACCEL_COPYAREA |
+			FBINFO_HWACCEL_FILLRECT |  FBINFO_HWACCEL_IMAGEBLIT;
+		default_var.accel_flags = FB_ACCELF_TEXT;
+	} else {
+		viafbinfo->flags |= FBINFO_HWACCEL_DISABLED;
+		default_var.accel_flags = 0;
 	}
 
 	if (viafb_second_size && (viafb_second_size < 8)) {
@@ -1963,15 +1970,6 @@ static int __devinit via_pci_probe(void)
 	default_var.lower_margin = 4;
 	default_var.hsync_len = default_var.left_margin;
 	default_var.vsync_len = 4;
-	default_var.accel_flags = 0;
-
-	if (viafb_accel) {
-		viafbinfo->flags |=
-		    (FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT |
-		     FBINFO_HWACCEL_IMAGEBLIT);
-		default_var.accel_flags |= FB_ACCELF_TEXT;
-	} else
-		viafbinfo->flags |= FBINFO_HWACCEL_DISABLED;
 
 	if (viafb_dual_fb) {
 		viafbinfo1 = framebuffer_alloc(viafb_par_length, NULL);
@@ -1994,12 +1992,6 @@ static int __devinit via_pci_probe(void)
 			viaparinfo1->fbmem_used;
 		viaparinfo->fbmem_free = viaparinfo->memsize;
 		viaparinfo->fbmem_used = 0;
-		if (viafb_accel) {
-			viaparinfo1->VQ_start = viaparinfo->VQ_start -
-				viafb_second_offset;
-			viaparinfo1->VQ_end = viaparinfo->VQ_end -
-				viafb_second_offset;
-		}
 
 		viaparinfo->iga_path = IGA1;
 		viaparinfo1->iga_path = IGA2;
@@ -2073,7 +2065,7 @@ static void __devexit via_pci_remove(voi
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
 	iounmap((void *)viafbinfo->screen_base);
-	iounmap(viaparinfo->io_virt);
+	iounmap(viaparinfo->shared->engine_mmio);
 
 	viafb_delete_i2c_buss(viaparinfo);
 
@@ -2235,7 +2227,7 @@ MODULE_PARM_DESC(viafb_SAMM_ON,
 
 module_param(viafb_accel, int, 0);
 MODULE_PARM_DESC(viafb_accel,
-	"Set 2D Hardware Acceleration.(Default = OFF)");
+	"Set 2D Hardware Acceleration: 0 = OFF, 1 = ON (default)");
 
 module_param(viafb_active_dev, charp, 0);
 MODULE_PARM_DESC(viafb_active_dev, "Specify active devices.");
diff -puN drivers/video/via/viafbdev.h~viafb-hardware-acceleration-initialization-cleanup drivers/video/via/viafbdev.h
--- a/drivers/video/via/viafbdev.h~viafb-hardware-acceleration-initialization-cleanup
+++ a/drivers/video/via/viafbdev.h
@@ -51,7 +51,9 @@ struct viafb_shared {
 	struct chip_information chip_info;
 
 	/* hardware acceleration stuff */
+	void __iomem *engine_mmio;
 	u32 cursor_vram_addr;
+	u32 vq_vram_addr;	/* virtual queue address in video ram */
 	int (*hw_bitblt)(void __iomem *engine, u8 op, u32 width, u32 height,
 		u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 		u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
@@ -61,13 +63,11 @@ struct viafb_shared {
 struct viafb_par {
 	u8 depth;
 	u32 vram_addr;
-	void __iomem *io_virt;	/*iospace virtual memory address */
+
 	unsigned int fbmem;	/*framebuffer physical memory address */
 	unsigned int memsize;	/*size of fbmem */
 	u32 fbmem_free;		/* Free FB memory */
 	u32 fbmem_used;		/* Use FB memory size */
-	u32 VQ_start;		/* Virtual Queue Start Address */
-	u32 VQ_end;		/* Virtual Queue End Address */
 	u32 iga_path;
 
 	struct viafb_shared *shared;
@@ -90,7 +90,6 @@ extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
 extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
-extern int viafb_accel;
 extern int viafb_hotplug;
 extern int viafb_memsize;
 
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
viafb-2d-engine-rewrite.patch
viafb-2d-engine-rewrite-v2.patch
viafb-switch-to-seq_file.patch
viafb-cleanup-viafb_cursor.patch
viafb-improve-pitch-handling.patch
viafb-hardware-acceleration-initialization-cleanup.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

