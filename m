From: akpm@linux-foundation.org
Subject: - pxafb-preliminary-smart-panel-interface-support.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:22 -0700
Message-ID: <200805010925.m419PMp1030196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755314AbYEAJ0H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, daniel@caiaq.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: preliminary smart panel interface support
has been removed from the -mm tree.  Its filename was
     pxafb-preliminary-smart-panel-interface-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: preliminary smart panel interface support
From: Eric Miao <eric.miao@marvell.com>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig               |    5 
 drivers/video/pxafb.c               |  307 ++++++++++++++++++++++----
 drivers/video/pxafb.h               |   12 +
 include/asm-arm/arch-pxa/pxafb.h    |   26 +-
 include/asm-arm/arch-pxa/regs-lcd.h |   34 ++
 5 files changed, 337 insertions(+), 47 deletions(-)

diff -puN drivers/video/Kconfig~pxafb-preliminary-smart-panel-interface-support drivers/video/Kconfig
--- a/drivers/video/Kconfig~pxafb-preliminary-smart-panel-interface-support
+++ a/drivers/video/Kconfig
@@ -1774,6 +1774,11 @@ config FB_PXA
 
 	  If unsure, say N.
 
+config FB_PXA_SMARTPANEL
+	bool "PXA Smartpanel LCD support"
+	default y
+	depends on FB_PXA
+
 config FB_PXA_PARAMETERS
 	bool "PXA LCD command line parameters"
 	default n
diff -puN drivers/video/pxafb.c~pxafb-preliminary-smart-panel-interface-support drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-preliminary-smart-panel-interface-support
+++ a/drivers/video/pxafb.c
@@ -40,6 +40,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/completion.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -455,7 +457,7 @@ static int pxafb_mmap(struct fb_info *in
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
 
 	if (off < info->fix.smem_len) {
-		vma->vm_pgoff += 1;
+		vma->vm_pgoff += fbi->video_offset / PAGE_SIZE;
 		return dma_mmap_writecombine(fbi->dev, vma, fbi->map_cpu,
 					     fbi->map_dma, fbi->map_size);
 	}
@@ -594,6 +596,183 @@ static int setup_frame_dma(struct pxafb_
 	return 0;
 }
 
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+static int setup_smart_dma(struct pxafb_info *fbi)
+{
+	struct pxafb_dma_descriptor *dma_desc;
+	unsigned long dma_desc_off, cmd_buff_off;
+
+	dma_desc = &fbi->dma_buff->dma_desc[DMA_CMD];
+	dma_desc_off = offsetof(struct pxafb_dma_buff, dma_desc[DMA_CMD]);
+	cmd_buff_off = offsetof(struct pxafb_dma_buff, cmd_buff);
+
+	dma_desc->fdadr = fbi->dma_buff_phys + dma_desc_off;
+	dma_desc->fsadr = fbi->dma_buff_phys + cmd_buff_off;
+	dma_desc->fidr  = 0;
+	dma_desc->ldcmd = fbi->n_smart_cmds * sizeof(uint16_t);
+
+	fbi->fdadr[DMA_CMD] = dma_desc->fdadr;
+	return 0;
+}
+
+int pxafb_smart_flush(struct fb_info *info)
+{
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
+	uint32_t prsr;
+	int ret = 0;
+
+	/* disable controller until all registers are set up */
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 & ~LCCR0_ENB);
+
+	/* 1. make it an even number of commands to align on 32-bit boundary
+	 * 2. add the interrupt command to the end of the chain so we can
+	 *    keep track of the end of the transfer
+	 */
+
+	while (fbi->n_smart_cmds & 1)
+		fbi->smart_cmds[fbi->n_smart_cmds++] = SMART_CMD_NOOP;
+
+	fbi->smart_cmds[fbi->n_smart_cmds++] = SMART_CMD_INTERRUPT;
+	fbi->smart_cmds[fbi->n_smart_cmds++] = SMART_CMD_WAIT_FOR_VSYNC;
+	setup_smart_dma(fbi);
+
+	/* continue to execute next command */
+	prsr = lcd_readl(fbi, PRSR) | PRSR_ST_OK | PRSR_CON_NT;
+	lcd_writel(fbi, PRSR, prsr);
+
+	/* stop the processor in case it executed "wait for sync" cmd */
+	lcd_writel(fbi, CMDCR, 0x0001);
+
+	/* don't send interrupts for fifo underruns on channel 6 */
+	lcd_writel(fbi, LCCR5, LCCR5_IUM(6));
+
+	lcd_writel(fbi, LCCR1, fbi->reg_lccr1);
+	lcd_writel(fbi, LCCR2, fbi->reg_lccr2);
+	lcd_writel(fbi, LCCR3, fbi->reg_lccr3);
+	lcd_writel(fbi, FDADR0, fbi->fdadr[0]);
+	lcd_writel(fbi, FDADR6, fbi->fdadr[6]);
+
+	/* begin sending */
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 | LCCR0_ENB);
+
+	if (wait_for_completion_timeout(&fbi->command_done, HZ/2) == 0) {
+		pr_warning("%s: timeout waiting for command done\n",
+				__func__);
+		ret = -ETIMEDOUT;
+	}
+
+	/* quick disable */
+	prsr = lcd_readl(fbi, PRSR) & ~(PRSR_ST_OK | PRSR_CON_NT);
+	lcd_writel(fbi, PRSR, prsr);
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 & ~LCCR0_ENB);
+	lcd_writel(fbi, FDADR6, 0);
+	fbi->n_smart_cmds = 0;
+	return ret;
+}
+
+int pxafb_smart_queue(struct fb_info *info, uint16_t *cmds, int n_cmds)
+{
+	int i;
+	struct pxafb_info *fbi = container_of(info, struct pxafb_info, fb);
+
+	/* leave 2 commands for INTERRUPT and WAIT_FOR_SYNC */
+	for (i = 0; i < n_cmds; i++) {
+		if (fbi->n_smart_cmds == CMD_BUFF_SIZE - 8)
+			pxafb_smart_flush(info);
+
+		fbi->smart_cmds[fbi->n_smart_cmds++] = *cmds++;
+	}
+
+	return 0;
+}
+
+static unsigned int __smart_timing(unsigned time_ns, unsigned long lcd_clk)
+{
+	unsigned int t = (time_ns * (lcd_clk / 1000000) / 1000);
+	return (t == 0) ? 1 : t;
+}
+
+static void setup_smart_timing(struct pxafb_info *fbi,
+				struct fb_var_screeninfo *var)
+{
+	struct pxafb_mach_info *inf = fbi->dev->platform_data;
+	struct pxafb_mode_info *mode = &inf->modes[0];
+	unsigned long lclk = clk_get_rate(fbi->clk);
+	unsigned t1, t2, t3, t4;
+
+	t1 = max(mode->a0csrd_set_hld, mode->a0cswr_set_hld);
+	t2 = max(mode->rd_pulse_width, mode->wr_pulse_width);
+	t3 = mode->op_hold_time;
+	t4 = mode->cmd_inh_time;
+
+	fbi->reg_lccr1 =
+		LCCR1_DisWdth(var->xres) |
+		LCCR1_BegLnDel(__smart_timing(t1, lclk)) |
+		LCCR1_EndLnDel(__smart_timing(t2, lclk)) |
+		LCCR1_HorSnchWdth(__smart_timing(t3, lclk));
+
+	fbi->reg_lccr2 = LCCR2_DisHght(var->yres);
+	fbi->reg_lccr3 = LCCR3_PixClkDiv(__smart_timing(t4, lclk));
+
+	/* FIXME: make this configurable */
+	fbi->reg_cmdcr = 1;
+}
+
+static int pxafb_smart_thread(void *arg)
+{
+	struct pxafb_info *fbi = (struct pxafb_info *) arg;
+	struct pxafb_mach_info *inf = fbi->dev->platform_data;
+
+	if (!fbi || !inf->smart_update) {
+		pr_err("%s: not properly initialized, thread terminated\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	pr_debug("%s(): task starting\n", __func__);
+
+	set_freezable();
+	while (!kthread_should_stop()) {
+
+		if (try_to_freeze())
+			continue;
+
+		if (fbi->state == C_ENABLE) {
+			inf->smart_update(&fbi->fb);
+			complete(&fbi->refresh_done);
+		}
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(30 * HZ / 1000);
+	}
+
+	pr_debug("%s(): task ending\n", __func__);
+	return 0;
+}
+
+static int pxafb_smart_init(struct pxafb_info *fbi)
+{
+	fbi->smart_thread = kthread_run(pxafb_smart_thread, fbi,
+					"lcd_refresh");
+	if (IS_ERR(fbi->smart_thread)) {
+		printk(KERN_ERR "%s: unable to create kernel thread\n",
+				__func__);
+		return PTR_ERR(fbi->smart_thread);
+	}
+	return 0;
+}
+#else
+int pxafb_smart_queue(struct fb_info *info, uint16_t *cmds, int n_cmds)
+{
+	return 0;
+}
+
+int pxafb_smart_flush(struct fb_info *info)
+{
+	return 0;
+}
+#endif /* CONFIG_FB_SMART_PANEL */
+
 static void setup_parallel_timing(struct pxafb_info *fbi,
 				  struct fb_var_screeninfo *var)
 {
@@ -643,47 +822,55 @@ static int pxafb_activate_var(struct fb_
 	size_t nbytes;
 
 #if DEBUG_VAR
-	if (var->xres < 16 || var->xres > 1024)
-		printk(KERN_ERR "%s: invalid xres %d\n",
-			fbi->fb.fix.id, var->xres);
-	switch (var->bits_per_pixel) {
-	case 1:
-	case 2:
-	case 4:
-	case 8:
-	case 16:
-		break;
-	default:
-		printk(KERN_ERR "%s: invalid bit depth %d\n",
-		       fbi->fb.fix.id, var->bits_per_pixel);
-		break;
+	if (!(fbi->lccr0 & LCCR0_LCDT)) {
+		if (var->xres < 16 || var->xres > 1024)
+			printk(KERN_ERR "%s: invalid xres %d\n",
+				fbi->fb.fix.id, var->xres);
+		switch (var->bits_per_pixel) {
+		case 1:
+		case 2:
+		case 4:
+		case 8:
+		case 16:
+			break;
+		default:
+			printk(KERN_ERR "%s: invalid bit depth %d\n",
+			       fbi->fb.fix.id, var->bits_per_pixel);
+			break;
+		}
+
+		if (var->hsync_len < 1 || var->hsync_len > 64)
+			printk(KERN_ERR "%s: invalid hsync_len %d\n",
+				fbi->fb.fix.id, var->hsync_len);
+		if (var->left_margin < 1 || var->left_margin > 255)
+			printk(KERN_ERR "%s: invalid left_margin %d\n",
+				fbi->fb.fix.id, var->left_margin);
+		if (var->right_margin < 1 || var->right_margin > 255)
+			printk(KERN_ERR "%s: invalid right_margin %d\n",
+				fbi->fb.fix.id, var->right_margin);
+		if (var->yres < 1 || var->yres > 1024)
+			printk(KERN_ERR "%s: invalid yres %d\n",
+				fbi->fb.fix.id, var->yres);
+		if (var->vsync_len < 1 || var->vsync_len > 64)
+			printk(KERN_ERR "%s: invalid vsync_len %d\n",
+				fbi->fb.fix.id, var->vsync_len);
+		if (var->upper_margin < 0 || var->upper_margin > 255)
+			printk(KERN_ERR "%s: invalid upper_margin %d\n",
+				fbi->fb.fix.id, var->upper_margin);
+		if (var->lower_margin < 0 || var->lower_margin > 255)
+			printk(KERN_ERR "%s: invalid lower_margin %d\n",
+				fbi->fb.fix.id, var->lower_margin);
 	}
-	if (var->hsync_len < 1 || var->hsync_len > 64)
-		printk(KERN_ERR "%s: invalid hsync_len %d\n",
-			fbi->fb.fix.id, var->hsync_len);
-	if (var->left_margin < 1 || var->left_margin > 255)
-		printk(KERN_ERR "%s: invalid left_margin %d\n",
-			fbi->fb.fix.id, var->left_margin);
-	if (var->right_margin < 1 || var->right_margin > 255)
-		printk(KERN_ERR "%s: invalid right_margin %d\n",
-			fbi->fb.fix.id, var->right_margin);
-	if (var->yres < 1 || var->yres > 1024)
-		printk(KERN_ERR "%s: invalid yres %d\n",
-			fbi->fb.fix.id, var->yres);
-	if (var->vsync_len < 1 || var->vsync_len > 64)
-		printk(KERN_ERR "%s: invalid vsync_len %d\n",
-			fbi->fb.fix.id, var->vsync_len);
-	if (var->upper_margin < 0 || var->upper_margin > 255)
-		printk(KERN_ERR "%s: invalid upper_margin %d\n",
-			fbi->fb.fix.id, var->upper_margin);
-	if (var->lower_margin < 0 || var->lower_margin > 255)
-		printk(KERN_ERR "%s: invalid lower_margin %d\n",
-			fbi->fb.fix.id, var->lower_margin);
 #endif
 	/* Update shadow copy atomically */
 	local_irq_save(flags);
 
-	setup_parallel_timing(fbi, var);
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+	if (fbi->lccr0 & LCCR0_LCDT)
+		setup_smart_timing(fbi, var);
+	else
+#endif
+		setup_parallel_timing(fbi, var);
 
 	fbi->reg_lccr0 = fbi->lccr0 |
 		(LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM |
@@ -698,7 +885,7 @@ static int pxafb_activate_var(struct fb_
 		setup_frame_dma(fbi, DMA_LOWER, PAL_NONE, nbytes, nbytes);
 	}
 
-	if (var->bits_per_pixel >= 16)
+	if ((var->bits_per_pixel >= 16) || (fbi->lccr0 & LCCR0_LCDT))
 		setup_frame_dma(fbi, DMA_BASE, PAL_NONE, 0, nbytes);
 	else
 		setup_frame_dma(fbi, DMA_BASE, PAL_BASE, 0, nbytes);
@@ -801,6 +988,9 @@ static void pxafb_enable_controller(stru
 	/* enable LCD controller clock */
 	clk_enable(fbi->clk);
 
+	if (fbi->lccr0 & LCCR0_LCDT)
+		return;
+
 	/* Sequence from 11.7.10 */
 	lcd_writel(fbi, LCCR3, fbi->reg_lccr3);
 	lcd_writel(fbi, LCCR2, fbi->reg_lccr2);
@@ -816,6 +1006,14 @@ static void pxafb_disable_controller(str
 {
 	uint32_t lccr0;
 
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+	if (fbi->lccr0 & LCCR0_LCDT) {
+		wait_for_completion_timeout(&fbi->refresh_done,
+				200 * HZ / 1000);
+		return;
+	}
+#endif
+
 	/* Clear LCD Status Register */
 	lcd_writel(fbi, LCSR, 0xffffffff);
 
@@ -843,6 +1041,11 @@ static irqreturn_t pxafb_handle_irq(int 
 		complete(&fbi->disable_done);
 	}
 
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+	if (lcsr & LCSR_CMD_INT)
+		complete(&fbi->command_done);
+#endif
+
 	lcd_writel(fbi, LCSR, lcsr);
 	return IRQ_HANDLED;
 }
@@ -1050,15 +1253,17 @@ static int __init pxafb_map_video_memory
 	 * We reserve one page for the palette, plus the size
 	 * of the framebuffer.
 	 */
-	fbi->map_size = PAGE_ALIGN(fbi->fb.fix.smem_len + PAGE_SIZE);
+	fbi->video_offset = PAGE_ALIGN(sizeof(struct pxafb_dma_buff));
+	fbi->map_size = PAGE_ALIGN(fbi->fb.fix.smem_len + fbi->video_offset);
 	fbi->map_cpu = dma_alloc_writecombine(fbi->dev, fbi->map_size,
 					      &fbi->map_dma, GFP_KERNEL);
 
 	if (fbi->map_cpu) {
 		/* prevent initial garbage on screen */
 		memset(fbi->map_cpu, 0, fbi->map_size);
-		fbi->fb.screen_base = fbi->map_cpu + PAGE_SIZE;
-		fbi->screen_dma = fbi->map_dma + PAGE_SIZE;
+		fbi->fb.screen_base = fbi->map_cpu + fbi->video_offset;
+		fbi->screen_dma = fbi->map_dma + fbi->video_offset;
+
 		/*
 		 * FIXME: this is actually the wrong thing to place in
 		 * smem_start.  But fbdev suffers from the problem that
@@ -1068,9 +1273,14 @@ static int __init pxafb_map_video_memory
 		fbi->fb.fix.smem_start = fbi->screen_dma;
 		fbi->palette_size = fbi->fb.var.bits_per_pixel == 8 ? 256 : 16;
 
-		fbi->dma_buff = (void *)fbi->map_cpu;
+		fbi->dma_buff = (void *) fbi->map_cpu;
 		fbi->dma_buff_phys = fbi->map_dma;
-		fbi->palette_cpu = (u16 *)&fbi->dma_buff->palette[0];
+		fbi->palette_cpu = (u16 *) fbi->dma_buff->palette;
+
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+		fbi->smart_cmds = (uint16_t *) fbi->dma_buff->cmd_buff;
+		fbi->n_smart_cmds = 0;
+#endif
 	}
 
 	return fbi->map_cpu ? 0 : -ENOMEM;
@@ -1191,6 +1401,10 @@ static struct pxafb_info * __init pxafb_
 	INIT_WORK(&fbi->task, pxafb_task);
 	init_MUTEX(&fbi->ctrlr_sem);
 	init_completion(&fbi->disable_done);
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+	init_completion(&fbi->command_done);
+	init_completion(&fbi->refresh_done);
+#endif
 
 	return fbi;
 }
@@ -1510,6 +1724,13 @@ static int __init pxafb_probe(struct pla
 		goto failed_free_mem;
 	}
 
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+	ret = pxafb_smart_init(fbi);
+	if (ret) {
+		dev_err(&dev->dev, "failed to initialize smartpanel\n");
+		goto failed_free_irq;
+	}
+#endif
 	/*
 	 * This makes sure that our colour bitfield
 	 * descriptors are correctly initialised.
diff -puN drivers/video/pxafb.h~pxafb-preliminary-smart-panel-interface-support drivers/video/pxafb.h
--- a/drivers/video/pxafb.h~pxafb-preliminary-smart-panel-interface-support
+++ a/drivers/video/pxafb.h
@@ -52,9 +52,11 @@ enum {
 
 /* maximum palette size - 256 entries, each 4 bytes long */
 #define PALETTE_SIZE	(256 * 4)
+#define CMD_BUFF_SIZE	(1024 * 50)
 
 struct pxafb_dma_buff {
 	unsigned char palette[PAL_MAX * PALETTE_SIZE];
+	uint16_t cmd_buff[CMD_BUFF_SIZE];
 	struct pxafb_dma_descriptor pal_desc[PAL_MAX];
 	struct pxafb_dma_descriptor dma_desc[DMA_MAX];
 };
@@ -84,6 +86,7 @@ struct pxafb_info {
 	dma_addr_t		screen_dma;	/* physical address of frame buffer */
 	u16 *			palette_cpu;	/* virtual address of palette memory */
 	u_int			palette_size;
+	ssize_t			video_offset;
 
 	u_int			lccr0;
 	u_int			lccr3;
@@ -97,6 +100,7 @@ struct pxafb_info {
 	u_int			reg_lccr2;
 	u_int			reg_lccr3;
 	u_int			reg_lccr4;
+	u_int			reg_cmdcr;
 
 	unsigned long	hsync_time;
 
@@ -108,6 +112,14 @@ struct pxafb_info {
 
 	struct completion	disable_done;
 
+#ifdef CONFIG_FB_PXA_SMARTPANEL
+	uint16_t		*smart_cmds;
+	size_t			n_smart_cmds;
+	struct completion	command_done;
+	struct completion	refresh_done;
+	struct task_struct	*smart_thread;
+#endif
+
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 	struct notifier_block	freq_policy;
diff -puN include/asm-arm/arch-pxa/pxafb.h~pxafb-preliminary-smart-panel-interface-support include/asm-arm/arch-pxa/pxafb.h
--- a/include/asm-arm/arch-pxa/pxafb.h~pxafb-preliminary-smart-panel-interface-support
+++ a/include/asm-arm/arch-pxa/pxafb.h
@@ -48,6 +48,7 @@
 #define LCD_COLOR_DSTN_16BPP	((16 << 4) | LCD_TYPE_COLOR_DSTN)
 #define LCD_COLOR_TFT_16BPP	((16 << 4) | LCD_TYPE_COLOR_TFT)
 #define LCD_COLOR_TFT_18BPP	((18 << 4) | LCD_TYPE_COLOR_TFT)
+#define LCD_SMART_PANEL_8BPP	((8  << 4) | LCD_TYPE_SMART_PANEL)
 #define LCD_SMART_PANEL_16BPP	((16 << 4) | LCD_TYPE_SMART_PANEL)
 #define LCD_SMART_PANEL_18BPP	((18 << 4) | LCD_TYPE_SMART_PANEL)
 
@@ -69,6 +70,10 @@ struct pxafb_mode_info {
 	u_short		yres;
 
 	u_char		bpp;
+	u_int		cmap_greyscale:1,
+			unused:31;
+
+	/* Parallel Mode Timing */
 	u_char		hsync_len;
 	u_char		left_margin;
 	u_char		right_margin;
@@ -78,8 +83,20 @@ struct pxafb_mode_info {
 	u_char		lower_margin;
 	u_char		sync;
 
-	u_int		cmap_greyscale:1,
-			unused:31;
+	/* Smart Panel Mode Timing - see PXA27x DM 7.4.15.0.3 for details
+	 * Note:
+	 * 1. all parameters in nanosecond (ns)
+	 * 2. a0cs{rd,wr}_set_hld are controlled by the same register bits
+	 *    in pxa27x and pxa3xx, initialize them to the same value or
+	 *    the larger one will be used
+	 * 3. same to {rd,wr}_pulse_width
+	 */
+	unsigned	a0csrd_set_hld;	/* A0 and CS Setup/Hold Time before/after L_FCLK_RD */
+	unsigned	a0cswr_set_hld;	/* A0 and CS Setup/Hold Time before/after L_PCLK_WR */
+	unsigned	wr_pulse_width;	/* L_PCLK_WR pulse width */
+	unsigned	rd_pulse_width;	/* L_FCLK_RD pulse width */
+	unsigned	cmd_inh_time;	/* Command Inhibit time between two writes */
+	unsigned	op_hold_time;	/* Output Hold time from L_FCLK_RD negation */
 };
 
 struct pxafb_mach_info {
@@ -123,8 +140,11 @@ struct pxafb_mach_info {
 	u_int		lccr4;
 	void (*pxafb_backlight_power)(int);
 	void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);
-
+	void (*smart_update)(struct fb_info *);
 };
 void set_pxa_fb_info(struct pxafb_mach_info *hard_pxa_fb_info);
 void set_pxa_fb_parent(struct device *parent_dev);
 unsigned long pxafb_get_hsync_time(struct device *dev);
+
+extern int pxafb_smart_queue(struct fb_info *info, uint16_t *cmds, int);
+extern int pxafb_smart_flush(struct fb_info *info);
diff -puN include/asm-arm/arch-pxa/regs-lcd.h~pxafb-preliminary-smart-panel-interface-support include/asm-arm/arch-pxa/regs-lcd.h
--- a/include/asm-arm/arch-pxa/regs-lcd.h~pxafb-preliminary-smart-panel-interface-support
+++ a/include/asm-arm/arch-pxa/regs-lcd.h
@@ -7,7 +7,8 @@
 #define LCCR1		(0x004)	/* LCD Controller Control Register 1 */
 #define LCCR2		(0x008)	/* LCD Controller Control Register 2 */
 #define LCCR3		(0x00C)	/* LCD Controller Control Register 3 */
-#define LCCR4		(0x010)	/* LCD Controller Control Register 3 */
+#define LCCR4		(0x010)	/* LCD Controller Control Register 4 */
+#define LCCR5		(0x014)	/* LCD Controller Control Register 5 */
 #define DFBR0		(0x020)	/* DMA Channel 0 Frame Branch Register */
 #define DFBR1		(0x024)	/* DMA Channel 1 Frame Branch Register */
 #define LCSR		(0x038)	/* LCD Controller Status Register */
@@ -15,6 +16,9 @@
 #define TMEDRGBR	(0x040)	/* TMED RGB Seed Register */
 #define TMEDCR		(0x044)	/* TMED Control Register */
 
+#define CMDCR		(0x100)	/* Command Control Register */
+#define PRSR		(0x104)	/* Panel Read Status Register */
+
 #define LCCR3_1BPP	(0 << 24)
 #define LCCR3_2BPP	(1 << 24)
 #define LCCR3_4BPP	(2 << 24)
@@ -39,6 +43,9 @@
 #define FSADR1		(0x214)	/* DMA Channel 1 Frame Source Address Register */
 #define FIDR1		(0x218)	/* DMA Channel 1 Frame ID Register */
 #define LDCMD1		(0x21C)	/* DMA Channel 1 Command Register */
+#define FDADR6		(0x260) /* DMA Channel 6 Frame Descriptor Address Register */
+#define FSADR6		(0x264) /* DMA Channel 6 Frame Source Address Register */
+#define FIDR6		(0x268) /* DMA Channel 6 Frame ID Register */
 
 #define LCCR0_ENB	(1 << 0)	/* LCD Controller enable */
 #define LCCR0_CMS	(1 << 1)	/* Color/Monochrome Display Select */
@@ -122,6 +129,11 @@
 #define LCCR3_VrtSnchH	(LCCR3_VSP*0)	/*  VSP Active High */
 #define LCCR3_VrtSnchL	(LCCR3_VSP*1)	/*  VSP Active Low */
 
+#define LCCR5_IUM(x)	(1 << ((x) + 23)) /* input underrun mask */
+#define LCCR5_BSM(x)	(1 << ((x) + 15)) /* branch mask */
+#define LCCR5_EOFM(x)	(1 << ((x) + 7))  /* end of frame mask */
+#define LCCR5_SOFM(x)	(1 << ((x) + 0))  /* start of frame mask */
+
 #define LCSR_LDD	(1 << 0)	/* LCD Disable Done */
 #define LCSR_SOF	(1 << 1)	/* Start of frame */
 #define LCSR_BER	(1 << 2)	/* Bus error */
@@ -133,7 +145,27 @@
 #define LCSR_EOF	(1 << 8)	/* end of frame */
 #define LCSR_BS		(1 << 9)	/* branch status */
 #define LCSR_SINT	(1 << 10)	/* subsequent interrupt */
+#define LCSR_RD_ST	(1 << 11)	/* read status */
+#define LCSR_CMD_INT	(1 << 12)	/* command interrupt */
 
 #define LDCMD_PAL	(1 << 26)	/* instructs DMA to load palette buffer */
 
+/* smartpanel related */
+#define PRSR_DATA(x)	((x) & 0xff)	/* Panel Data */
+#define PRSR_A0		(1 << 8)	/* Read Data Source */
+#define PRSR_ST_OK	(1 << 9)	/* Status OK */
+#define PRSR_CON_NT	(1 << 10)	/* Continue to Next Command */
+
+#define SMART_CMD_A0			 (0x1 << 8)
+#define SMART_CMD_READ_STATUS_REG	 (0x0 << 9)
+#define SMART_CMD_READ_FRAME_BUFFER	((0x0 << 9) | SMART_CMD_A0)
+#define SMART_CMD_WRITE_COMMAND		 (0x1 << 9)
+#define SMART_CMD_WRITE_DATA		((0x1 << 9) | SMART_CMD_A0)
+#define SMART_CMD_WRITE_FRAME		((0x2 << 9) | SMART_CMD_A0)
+#define SMART_CMD_WAIT_FOR_VSYNC	 (0x3 << 9)
+#define SMART_CMD_NOOP			 (0x4 << 9)
+#define SMART_CMD_INTERRUPT		 (0x5 << 9)
+
+#define SMART_CMD(x)	(SMART_CMD_WRITE_COMMAND | ((x) & 0xff))
+#define SMART_DAT(x)	(SMART_CMD_WRITE_DATA | ((x) & 0xff))
 #endif /* __ASM_ARCH_REGS_LCD_H */
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

