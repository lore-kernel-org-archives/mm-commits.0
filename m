From: akpm@linux-foundation.org
Subject: [merged] broadsheetfb-add-multiple-panel-type-support.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:53 -0400
Message-ID: <201003150656.o2F6uQOp016282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934451Ab0COG4v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, geert@linux-m68k.org, krzysztof.h1@wp.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     broadsheetfb: add multiple panel type support
has been removed from the -mm tree.  Its filename was
     broadsheetfb-add-multiple-panel-type-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: broadsheetfb: add multiple panel type support
From: Jaya Kumar <jayakumar.lkml@gmail.com>

Update broadsheetfb to add support for multiple panel types.  The 3.7" and
6" are known to work but the 9.7" is untested due to lack of hardware.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/am300epd.c |    2 
 drivers/video/broadsheetfb.c |  125 ++++++++++++++++++++++++++++-----
 include/video/broadsheetfb.h |    1 
 3 files changed, 111 insertions(+), 17 deletions(-)

diff -puN arch/arm/mach-pxa/am300epd.c~broadsheetfb-add-multiple-panel-type-support arch/arm/mach-pxa/am300epd.c
--- a/arch/arm/mach-pxa/am300epd.c~broadsheetfb-add-multiple-panel-type-support
+++ a/arch/arm/mach-pxa/am300epd.c
@@ -288,7 +288,7 @@ int __init am300_init(void)
 }
 
 module_param(panel_type, uint, 0);
-MODULE_PARM_DESC(panel_type, "Select the panel type: 6, 8, 97");
+MODULE_PARM_DESC(panel_type, "Select the panel type: 37, 6, 97");
 
 MODULE_DESCRIPTION("board driver for am300 epd kit");
 MODULE_AUTHOR("Jaya Kumar");
diff -puN drivers/video/broadsheetfb.c~broadsheetfb-add-multiple-panel-type-support drivers/video/broadsheetfb.c
--- a/drivers/video/broadsheetfb.c~broadsheetfb-add-multiple-panel-type-support
+++ a/drivers/video/broadsheetfb.c
@@ -33,7 +33,60 @@
 
 #include <video/broadsheetfb.h>
 
-/* Display specific information */
+/* track panel specific parameters */
+struct panel_info {
+	int w;
+	int h;
+	u16 sdcfg;
+	u16 gdcfg;
+	u16 lutfmt;
+	u16 fsynclen;
+	u16 fendfbegin;
+	u16 lsynclen;
+	u16 lendlbegin;
+	u16 pixclk;
+};
+
+/* table of panel specific parameters to be indexed into by the board drivers */
+static struct panel_info panel_table[] = {
+	{	/* standard 6" on TFT backplane */
+		.w = 800,
+		.h = 600,
+		.sdcfg = (100 | (1 << 8) | (1 << 9)),
+		.gdcfg = 2,
+		.lutfmt = (4 | (1 << 7)),
+		.fsynclen = 4,
+		.fendfbegin = (10 << 8) | 4,
+		.lsynclen = 10,
+		.lendlbegin = (100 << 8) | 4,
+		.pixclk = 6,
+	},
+	{	/* custom 3.7" flexible on PET or steel */
+		.w = 320,
+		.h = 240,
+		.sdcfg = (67 | (0 << 8) | (0 << 9) | (0 << 10) | (0 << 12)),
+		.gdcfg = 3,
+		.lutfmt = (4 | (1 << 7)),
+		.fsynclen = 0,
+		.fendfbegin = (80 << 8) | 4,
+		.lsynclen = 10,
+		.lendlbegin = (80 << 8) | 20,
+		.pixclk = 14,
+	},
+	{	/* standard 9.7" on TFT backplane */
+		.w = 1200,
+		.h = 825,
+		.sdcfg = (100 | (1 << 8) | (1 << 9) | (0 << 10) | (0 << 12)),
+		.gdcfg = 2,
+		.lutfmt = (4 | (1 << 7)),
+		.fsynclen = 0,
+		.fendfbegin = (4 << 8) | 4,
+		.lsynclen = 4,
+		.lendlbegin = (60 << 8) | 10,
+		.pixclk = 3,
+	},
+};
+
 #define DPY_W 800
 #define DPY_H 600
 
@@ -160,6 +213,14 @@ static void broadsheet_write_reg(struct 
 	par->board->set_ctl(par, BS_CS, 1);
 }
 
+static void broadsheet_write_reg32(struct broadsheetfb_par *par, u16 reg,
+					u32 data)
+{
+	broadsheet_write_reg(par, reg, cpu_to_le32(data) & 0xFFFF);
+	broadsheet_write_reg(par, reg + 2, (cpu_to_le32(data) >> 16) & 0xFFFF);
+}
+
+
 static u16 broadsheet_read_reg(struct broadsheetfb_par *par, u16 reg)
 {
 	broadsheet_send_command(par, reg);
@@ -170,24 +231,28 @@ static u16 broadsheet_read_reg(struct br
 static void __devinit broadsheet_init_display(struct broadsheetfb_par *par)
 {
 	u16 args[5];
+	int xres = par->info->var.xres;
+	int yres = par->info->var.yres;
 
-	args[0] = DPY_W;
-	args[1] = DPY_H;
-	args[2] = (100 | (1 << 8) | (1 << 9)); /* sdcfg */
-	args[3] = 2; /* gdrv cfg */
-	args[4] = (4 | (1 << 7)); /* lut index format */
+	args[0] = panel_table[par->panel_index].w;
+	args[1] = panel_table[par->panel_index].h;
+	args[2] = panel_table[par->panel_index].sdcfg;
+	args[3] = panel_table[par->panel_index].gdcfg;
+	args[4] = panel_table[par->panel_index].lutfmt;
 	broadsheet_send_cmdargs(par, BS_CMD_INIT_DSPE_CFG, 5, args);
 
 	/* did the controller really set it? */
 	broadsheet_send_cmdargs(par, BS_CMD_INIT_DSPE_CFG, 5, args);
 
-	args[0] = 4; /* fsync len */
-	args[1] = (10 << 8) | 4; /* fend/fbegin len */
-	args[2] = 10; /* line sync len */
-	args[3] = (100 << 8) | 4; /* line end/begin len */
-	args[4] = 6; /* pixel clock cfg */
+	args[0] = panel_table[par->panel_index].fsynclen;
+	args[1] = panel_table[par->panel_index].fendfbegin;
+	args[2] = panel_table[par->panel_index].lsynclen;
+	args[3] = panel_table[par->panel_index].lendlbegin;
+	args[4] = panel_table[par->panel_index].pixclk;
 	broadsheet_send_cmdargs(par, BS_CMD_INIT_DSPE_TMG, 5, args);
 
+	broadsheet_write_reg32(par, 0x310, xres*yres*2);
+
 	/* setup waveform */
 	args[0] = 0x886;
 	args[1] = 0;
@@ -207,8 +272,9 @@ static void __devinit broadsheet_init_di
 	args[0] = 0x154;
 	broadsheet_send_cmdargs(par, BS_CMD_WR_REG, 1, args);
 
-	broadsheet_burst_write(par, DPY_W*DPY_H/2,
-				(u16 *) par->info->screen_base);
+	broadsheet_burst_write(par, (panel_table[par->panel_index].w *
+					panel_table[par->panel_index].h)/2,
+					(u16 *) par->info->screen_base);
 
 	broadsheet_send_command(par, BS_CMD_LD_IMG_END);
 
@@ -277,8 +343,9 @@ static void broadsheetfb_dpy_update(stru
 
 	args[0] = 0x154;
 	broadsheet_send_cmdargs(par, BS_CMD_WR_REG, 1, args);
-	broadsheet_burst_write(par, DPY_W*DPY_H/2,
-				(u16 *) par->info->screen_base);
+	broadsheet_burst_write(par, (panel_table[par->panel_index].w *
+					panel_table[par->panel_index].h)/2,
+					(u16 *) par->info->screen_base);
 
 	broadsheet_send_command(par, BS_CMD_LD_IMG_END);
 
@@ -436,6 +503,8 @@ static int __devinit broadsheetfb_probe(
 	unsigned char *videomemory;
 	struct broadsheetfb_par *par;
 	int i;
+	int dpyw, dpyh;
+	int panel_index;
 
 	/* pick up board specific routines */
 	board = dev->dev.platform_data;
@@ -450,7 +519,24 @@ static int __devinit broadsheetfb_probe(
 	if (!info)
 		goto err;
 
-	videomemorysize = (DPY_W*DPY_H);
+	switch (board->get_panel_type()) {
+	case 37:
+		panel_index = 1;
+		break;
+	case 97:
+		panel_index = 2;
+		break;
+	case 6:
+	default:
+		panel_index = 0;
+		break;
+	}
+
+	dpyw = panel_table[panel_index].w;
+	dpyh = panel_table[panel_index].h;
+
+	videomemorysize = roundup((dpyw*dpyh), PAGE_SIZE);
+
 	videomemory = vmalloc(videomemorysize);
 	if (!videomemory)
 		goto err_fb_rel;
@@ -460,10 +546,17 @@ static int __devinit broadsheetfb_probe(
 	info->screen_base = (char *)videomemory;
 	info->fbops = &broadsheetfb_ops;
 
+	broadsheetfb_var.xres = dpyw;
+	broadsheetfb_var.yres = dpyh;
+	broadsheetfb_var.xres_virtual = dpyw;
+	broadsheetfb_var.yres_virtual = dpyh;
 	info->var = broadsheetfb_var;
+
+	broadsheetfb_fix.line_length = dpyw;
 	info->fix = broadsheetfb_fix;
 	info->fix.smem_len = videomemorysize;
 	par = info->par;
+	par->panel_index = panel_index;
 	par->info = info;
 	par->board = board;
 	par->write_reg = broadsheet_write_reg;
diff -puN include/video/broadsheetfb.h~broadsheetfb-add-multiple-panel-type-support include/video/broadsheetfb.h
--- a/include/video/broadsheetfb.h~broadsheetfb-add-multiple-panel-type-support
+++ a/include/video/broadsheetfb.h
@@ -41,6 +41,7 @@ struct broadsheetfb_par {
 	void (*write_reg)(struct broadsheetfb_par *, u16 reg, u16 val);
 	u16 (*read_reg)(struct broadsheetfb_par *, u16 reg);
 	wait_queue_head_t waitq;
+	int panel_index;
 };
 
 /* board specific routines */
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

origin.patch

