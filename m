From: akpm@linux-foundation.org
Subject: + da8xx-omap-l1xx-fb-implement-double-buffering.patch added to -mm tree
Date: Mon, 12 Apr 2010 14:44:16 -0700
Message-ID: <201004122144.o3CLiGr6028427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754130Ab0DLVo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 17:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: martin@ti.com, chaithrika@ti.com, krzysztof.h1@poczta.fm, sudhakar.raj@ti.com


The patch titled
     fbdev: da8xx/omap-l1xx: implement double buffering
has been added to the -mm tree.  Its filename is
     da8xx-omap-l1xx-fb-implement-double-buffering.patch

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
Subject: fbdev: da8xx/omap-l1xx: implement double buffering
From: Martin Ambrose <martin@ti.com>

This work includes the following:

- Implement handler for FBIO_WAITFORVSYNC ioctl.

- Allocate the data and palette buffers separately.  A consequence of
  this is that the palette and data loading is now done in different
  phases.  And that the LCD must be disabled temporarily after the palette
  is loaded but this will only happen once after init and each time the
  palette is changed.  I think this is OK.

- Allocate two (ping and pong) framebuffers from memory.

- Add pan_display handler which toggles the LCDC DMA registers between
  the ping and pong buffers.

Signed-off-by: Martin Ambrose <martin@ti.com>
Cc: Chaithrika U S <chaithrika@ti.com>
Cc: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/da8xx-fb.c |  305 ++++++++++++++++++++++++++++---------
 include/video/da8xx-fb.h |    1 
 2 files changed, 237 insertions(+), 69 deletions(-)

diff -puN drivers/video/da8xx-fb.c~da8xx-omap-l1xx-fb-implement-double-buffering drivers/video/da8xx-fb.c
--- a/drivers/video/da8xx-fb.c~da8xx-omap-l1xx-fb-implement-double-buffering
+++ a/drivers/video/da8xx-fb.c
@@ -36,7 +36,9 @@
 #define DRIVER_NAME "da8xx_lcdc"
 
 /* LCD Status Register */
+#define LCD_END_OF_FRAME1		BIT(9)
 #define LCD_END_OF_FRAME0		BIT(8)
+#define LCD_PL_LOAD_DONE		BIT(6)
 #define LCD_FIFO_UNDERFLOW		BIT(5)
 #define LCD_SYNC_LOST			BIT(2)
 
@@ -58,11 +60,13 @@
 #define LCD_PALETTE_LOAD_MODE(x)	((x) << 20)
 #define PALETTE_AND_DATA		0x00
 #define PALETTE_ONLY			0x01
+#define DATA_ONLY			0x02
 
 #define LCD_MONO_8BIT_MODE		BIT(9)
 #define LCD_RASTER_ORDER		BIT(8)
 #define LCD_TFT_MODE			BIT(7)
 #define LCD_UNDERFLOW_INT_ENA		BIT(6)
+#define LCD_PL_ENABLE			BIT(4)
 #define LCD_MONOCHROME_MODE		BIT(1)
 #define LCD_RASTER_ENABLE		BIT(0)
 #define LCD_TFT_ALT_ENABLE		BIT(23)
@@ -87,6 +91,10 @@
 #define  LCD_DMA_CTRL_REG			0x40
 #define  LCD_DMA_FRM_BUF_BASE_ADDR_0_REG	0x44
 #define  LCD_DMA_FRM_BUF_CEILING_ADDR_0_REG	0x48
+#define  LCD_DMA_FRM_BUF_BASE_ADDR_1_REG	0x4C
+#define  LCD_DMA_FRM_BUF_CEILING_ADDR_1_REG	0x50
+
+#define LCD_NUM_BUFFERS	2
 
 #define WSI_TIMEOUT	50
 #define PALETTE_SIZE	256
@@ -111,13 +119,20 @@ static inline void lcdc_write(unsigned i
 struct da8xx_fb_par {
 	resource_size_t p_palette_base;
 	unsigned char *v_palette_base;
+	dma_addr_t		vram_phys;
+	unsigned long		vram_size;
+	void			*vram_virt;
+	unsigned int		dma_start;
+	unsigned int		dma_end;
 	struct clk *lcdc_clk;
 	int irq;
 	unsigned short pseudo_palette[16];
-	unsigned int databuf_sz;
 	unsigned int palette_sz;
 	unsigned int pxl_clk;
 	int blank;
+	wait_queue_head_t	vsync_wait;
+	int			vsync_flag;
+	int			vsync_timeout;
 #ifdef CONFIG_CPU_FREQ
 	struct notifier_block	freq_transition;
 #endif
@@ -148,9 +163,9 @@ static struct fb_fix_screeninfo da8xx_fb
 	.type = FB_TYPE_PACKED_PIXELS,
 	.type_aux = 0,
 	.visual = FB_VISUAL_PSEUDOCOLOR,
-	.xpanstep = 1,
+	.xpanstep = 0,
 	.ypanstep = 1,
-	.ywrapstep = 1,
+	.ywrapstep = 0,
 	.accel = FB_ACCEL_NONE
 };
 
@@ -221,22 +236,48 @@ static inline void lcd_disable_raster(vo
 
 static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
 {
-	u32 tmp = par->p_palette_base + par->databuf_sz - 4;
-	u32 reg;
-
-	/* Update the databuf in the hw. */
-	lcdc_write(par->p_palette_base, LCD_DMA_FRM_BUF_BASE_ADDR_0_REG);
-	lcdc_write(tmp, LCD_DMA_FRM_BUF_CEILING_ADDR_0_REG);
-
-	/* Start the DMA. */
-	reg = lcdc_read(LCD_RASTER_CTRL_REG);
-	reg &= ~(3 << 20);
-	if (load_mode == LOAD_DATA)
-		reg |= LCD_PALETTE_LOAD_MODE(PALETTE_AND_DATA);
-	else if (load_mode == LOAD_PALETTE)
-		reg |= LCD_PALETTE_LOAD_MODE(PALETTE_ONLY);
-
-	lcdc_write(reg, LCD_RASTER_CTRL_REG);
+	u32 start;
+	u32 end;
+	u32 reg_ras;
+	u32 reg_dma;
+
+	/* init reg to clear PLM (loading mode) fields */
+	reg_ras = lcdc_read(LCD_RASTER_CTRL_REG);
+	reg_ras &= ~(3 << 20);
+
+	reg_dma  = lcdc_read(LCD_DMA_CTRL_REG);
+
+	if (load_mode == LOAD_DATA) {
+		start    = par->dma_start;
+		end      = par->dma_end;
+
+		reg_ras |= LCD_PALETTE_LOAD_MODE(DATA_ONLY);
+		reg_dma |= LCD_END_OF_FRAME_INT_ENA;
+		reg_dma |= LCD_DUAL_FRAME_BUFFER_ENABLE;
+
+		lcdc_write(start, LCD_DMA_FRM_BUF_BASE_ADDR_0_REG);
+		lcdc_write(end, LCD_DMA_FRM_BUF_CEILING_ADDR_0_REG);
+		lcdc_write(start, LCD_DMA_FRM_BUF_BASE_ADDR_1_REG);
+		lcdc_write(end, LCD_DMA_FRM_BUF_CEILING_ADDR_1_REG);
+	} else if (load_mode == LOAD_PALETTE) {
+		start    = par->p_palette_base;
+		end      = start + par->palette_sz - 1;
+
+		reg_ras |= LCD_PALETTE_LOAD_MODE(PALETTE_ONLY);
+		reg_ras |= LCD_PL_ENABLE;
+
+		lcdc_write(start, LCD_DMA_FRM_BUF_BASE_ADDR_0_REG);
+		lcdc_write(end, LCD_DMA_FRM_BUF_CEILING_ADDR_0_REG);
+	}
+
+	lcdc_write(reg_dma, LCD_DMA_CTRL_REG);
+	lcdc_write(reg_ras, LCD_RASTER_CTRL_REG);
+
+	/*
+	 * The Raster enable bit must be set after all other control fields are
+	 * set.
+	 */
+	lcd_enable_raster();
 }
 
 /* Configure the Burst Size of DMA */
@@ -368,12 +409,8 @@ static int lcd_cfg_display(const struct 
 static int lcd_cfg_frame_buffer(struct da8xx_fb_par *par, u32 width, u32 height,
 		u32 bpp, u32 raster_order)
 {
-	u32 bpl, reg;
+	u32 reg;
 
-	/* Disable Dual Frame Buffer. */
-	reg = lcdc_read(LCD_DMA_CTRL_REG);
-	lcdc_write(reg & ~LCD_DUAL_FRAME_BUFFER_ENABLE,
-						LCD_DMA_CTRL_REG);
 	/* Set the Panel Width */
 	/* Pixels per line = (PPL + 1)*16 */
 	/*0x3F in bits 4..9 gives max horisontal resolution = 1024 pixels*/
@@ -410,9 +447,6 @@ static int lcd_cfg_frame_buffer(struct d
 		return -EINVAL;
 	}
 
-	bpl = width * bpp / 8;
-	par->databuf_sz = height * bpl + par->palette_sz;
-
 	return 0;
 }
 
@@ -421,8 +455,9 @@ static int fb_setcolreg(unsigned regno, 
 			      struct fb_info *info)
 {
 	struct da8xx_fb_par *par = info->par;
-	unsigned short *palette = (unsigned short *)par->v_palette_base;
+	unsigned short *palette = (unsigned short *) par->v_palette_base;
 	u_short pal;
+	int update_hw = 0;
 
 	if (regno > 255)
 		return 1;
@@ -439,8 +474,10 @@ static int fb_setcolreg(unsigned regno, 
 		pal |= (green & 0x00f0);
 		pal |= (blue & 0x000f);
 
-		palette[regno] = pal;
-
+		if (palette[regno] != pal) {
+			update_hw = 1;
+			palette[regno] = pal;
+		}
 	} else if ((info->var.bits_per_pixel == 16) && regno < 16) {
 		red >>= (16 - info->var.red.length);
 		red <<= info->var.red.offset;
@@ -453,9 +490,16 @@ static int fb_setcolreg(unsigned regno, 
 
 		par->pseudo_palette[regno] = red | green | blue;
 
-		palette[0] = 0x4000;
+		if (palette[0] != 0x4000) {
+			update_hw = 1;
+			palette[0] = 0x4000;
+		}
 	}
 
+	/* Update the palette in the h/w as needed. */
+	if (update_hw)
+		lcd_blit(LOAD_PALETTE, par);
+
 	return 0;
 }
 
@@ -541,15 +585,54 @@ static int lcd_init(struct da8xx_fb_par 
 
 static irqreturn_t lcdc_irq_handler(int irq, void *arg)
 {
+	struct da8xx_fb_par *par = arg;
 	u32 stat = lcdc_read(LCD_STAT_REG);
+	u32 reg_ras;
 
 	if ((stat & LCD_SYNC_LOST) && (stat & LCD_FIFO_UNDERFLOW)) {
 		lcd_disable_raster();
 		lcdc_write(stat, LCD_STAT_REG);
 		lcd_enable_raster();
-	} else
+	} else if (stat & LCD_PL_LOAD_DONE) {
+		/*
+		 * Must disable raster before changing state of any control bit.
+		 * And also must be disabled before clearing the PL loading
+		 * interrupt via the following write to the status register. If
+		 * this is done after then one gets multiple PL done interrupts.
+		 */
+		lcd_disable_raster();
+
+		lcdc_write(stat, LCD_STAT_REG);
+
+		/* Disable PL completion inerrupt */
+		reg_ras  = lcdc_read(LCD_RASTER_CTRL_REG);
+		reg_ras &= ~LCD_PL_ENABLE;
+		lcdc_write(reg_ras, LCD_RASTER_CTRL_REG);
+
+		/* Setup and start data loading mode */
+		lcd_blit(LOAD_DATA, par);
+	} else {
 		lcdc_write(stat, LCD_STAT_REG);
 
+		if (stat & LCD_END_OF_FRAME0) {
+			lcdc_write(par->dma_start,
+				   LCD_DMA_FRM_BUF_BASE_ADDR_0_REG);
+			lcdc_write(par->dma_end,
+				   LCD_DMA_FRM_BUF_CEILING_ADDR_0_REG);
+			par->vsync_flag = 1;
+			wake_up_interruptible(&par->vsync_wait);
+		}
+
+		if (stat & LCD_END_OF_FRAME1) {
+			lcdc_write(par->dma_start,
+				   LCD_DMA_FRM_BUF_BASE_ADDR_1_REG);
+			lcdc_write(par->dma_end,
+				   LCD_DMA_FRM_BUF_CEILING_ADDR_1_REG);
+			par->vsync_flag = 1;
+			wake_up_interruptible(&par->vsync_wait);
+		}
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -654,9 +737,10 @@ static int __devexit fb_remove(struct pl
 
 		unregister_framebuffer(info);
 		fb_dealloc_cmap(&info->cmap);
-		dma_free_coherent(NULL, par->databuf_sz + PAGE_SIZE,
-					info->screen_base - PAGE_SIZE,
-					info->fix.smem_start);
+		dma_free_coherent(NULL, PALETTE_SIZE, par->v_palette_base,
+				  par->p_palette_base);
+		dma_free_coherent(NULL, par->vram_size, par->vram_virt,
+				  par->vram_phys);
 		free_irq(par->irq, par);
 		clk_disable(par->lcdc_clk);
 		clk_put(par->lcdc_clk);
@@ -668,6 +752,39 @@ static int __devexit fb_remove(struct pl
 	return 0;
 }
 
+/*
+ * Function to wait for vertical sync which for this LCD peripheral
+ * translates into waiting for the current raster frame to complete.
+ */
+static int fb_wait_for_vsync(struct fb_info *info)
+{
+	struct da8xx_fb_par *par = info->par;
+	int ret;
+
+	/*
+	 * Set flag to 0 and wait for isr to set to 1. It would seem there is a
+	 * race condition here where the ISR could have occured just before or
+	 * just after this set. But since we are just coarsely waiting for
+	 * a frame to complete then that's OK. i.e. if the frame completed
+	 * just before this code executed then we have to wait another full
+	 * frame time but there is no way to avoid such a situation. On the
+	 * other hand if the frame completed just after then we don't need
+	 * to wait long at all. Either way we are guaranteed to return to the
+	 * user immediately after a frame completion which is all that is
+	 * required.
+	 */
+	par->vsync_flag = 0;
+	ret = wait_event_interruptible_timeout(par->vsync_wait,
+					       par->vsync_flag != 0,
+					       par->vsync_timeout);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static int fb_ioctl(struct fb_info *info, unsigned int cmd,
 			  unsigned long arg)
 {
@@ -697,6 +814,8 @@ static int fb_ioctl(struct fb_info *info
 					sync_arg.pulse_width,
 					sync_arg.front_porch);
 		break;
+	case FBIO_WAITFORVSYNC:
+		return fb_wait_for_vsync(info);
 	default:
 		return -EINVAL;
 	}
@@ -732,10 +851,47 @@ static int cfb_blank(int blank, struct f
 	return ret;
 }
 
+/*
+ * Set new x,y offsets in the virtual display for the visible area and switch
+ * to the new mode.
+ */
+static int da8xx_pan_display(struct fb_var_screeninfo *var,
+			     struct fb_info *fbi)
+{
+	int ret = 0;
+	struct fb_var_screeninfo new_var;
+	struct da8xx_fb_par         *par = fbi->par;
+	struct fb_fix_screeninfo    *fix = &fbi->fix;
+	unsigned int end;
+	unsigned int start;
+
+	if (var->xoffset != fbi->var.xoffset ||
+			var->yoffset != fbi->var.yoffset) {
+		memcpy(&new_var, &fbi->var, sizeof(new_var));
+		new_var.xoffset = var->xoffset;
+		new_var.yoffset = var->yoffset;
+		if (fb_check_var(&new_var, fbi))
+			ret = -EINVAL;
+		else {
+			memcpy(&fbi->var, &new_var, sizeof(new_var));
+
+			start	= fix->smem_start +
+				new_var.yoffset * fix->line_length +
+				new_var.xoffset * var->bits_per_pixel / 8;
+			end	= start + var->yres * fix->line_length - 1;
+			par->dma_start	= start;
+			par->dma_end	= end;
+		}
+	}
+
+	return ret;
+}
+
 static struct fb_ops da8xx_fb_ops = {
 	.owner = THIS_MODULE,
 	.fb_check_var = fb_check_var,
 	.fb_setcolreg = fb_setcolreg,
+	.fb_pan_display = da8xx_pan_display,
 	.fb_ioctl = fb_ioctl,
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
@@ -829,40 +985,53 @@ static int __init fb_probe(struct platfo
 	}
 
 	/* allocate frame buffer */
-	da8xx_fb_info->screen_base = dma_alloc_coherent(NULL,
-					par->databuf_sz + PAGE_SIZE,
-					(resource_size_t *)
-					&da8xx_fb_info->fix.smem_start,
-					GFP_KERNEL | GFP_DMA);
-
-	if (!da8xx_fb_info->screen_base) {
+	par->vram_size = lcdc_info->width * lcdc_info->height * lcd_cfg->bpp;
+	par->vram_size = PAGE_ALIGN(par->vram_size/8);
+	par->vram_size = par->vram_size * LCD_NUM_BUFFERS;
+
+	par->vram_virt = dma_alloc_coherent(NULL,
+					    par->vram_size,
+					    (resource_size_t *) &par->vram_phys,
+					    GFP_KERNEL | GFP_DMA);
+	if (!par->vram_virt) {
 		dev_err(&device->dev,
 			"GLCD: kmalloc for frame buffer failed\n");
 		ret = -EINVAL;
 		goto err_release_fb;
 	}
 
-	/* move palette base pointer by (PAGE_SIZE - palette_sz) bytes */
-	par->v_palette_base = da8xx_fb_info->screen_base +
-				(PAGE_SIZE - par->palette_sz);
-	par->p_palette_base = da8xx_fb_info->fix.smem_start +
-				(PAGE_SIZE - par->palette_sz);
-
-	/* the rest of the frame buffer is pixel data */
-	da8xx_fb_info->screen_base = par->v_palette_base + par->palette_sz;
-	da8xx_fb_fix.smem_start = par->p_palette_base + par->palette_sz;
-	da8xx_fb_fix.smem_len = par->databuf_sz - par->palette_sz;
-	da8xx_fb_fix.line_length = (lcdc_info->width * lcd_cfg->bpp) / 8;
+	da8xx_fb_info->screen_base = (char __iomem *) par->vram_virt;
+	da8xx_fb_fix.smem_start    = par->vram_phys;
+	da8xx_fb_fix.smem_len      = par->vram_size;
+	da8xx_fb_fix.line_length   = (lcdc_info->width * lcd_cfg->bpp) / 8;
+
+	par->dma_start = par->vram_phys;
+	par->dma_end   = par->dma_start + lcdc_info->height *
+		da8xx_fb_fix.line_length - 1;
+
+	/* allocate palette buffer */
+	par->v_palette_base = dma_alloc_coherent(NULL,
+					       PALETTE_SIZE,
+					       (resource_size_t *)
+					       &par->p_palette_base,
+					       GFP_KERNEL | GFP_DMA);
+	if (!par->v_palette_base) {
+		dev_err(&device->dev,
+			"GLCD: kmalloc for palette buffer failed\n");
+		ret = -EINVAL;
+		goto err_release_fb_mem;
+	}
+	memset(par->v_palette_base, 0, PALETTE_SIZE);
 
 	par->irq = platform_get_irq(device, 0);
 	if (par->irq < 0) {
 		ret = -ENOENT;
-		goto err_release_fb_mem;
+		goto err_release_pl_mem;
 	}
 
 	ret = request_irq(par->irq, lcdc_irq_handler, 0, DRIVER_NAME, par);
 	if (ret)
-		goto err_release_fb_mem;
+		goto err_release_pl_mem;
 
 	/* Initialize par */
 	da8xx_fb_info->var.bits_per_pixel = lcd_cfg->bpp;
@@ -870,8 +1039,8 @@ static int __init fb_probe(struct platfo
 	da8xx_fb_var.xres = lcdc_info->width;
 	da8xx_fb_var.xres_virtual = lcdc_info->width;
 
-	da8xx_fb_var.yres = lcdc_info->height;
-	da8xx_fb_var.yres_virtual = lcdc_info->height;
+	da8xx_fb_var.yres         = lcdc_info->height;
+	da8xx_fb_var.yres_virtual = lcdc_info->height * LCD_NUM_BUFFERS;
 
 	da8xx_fb_var.grayscale =
 	    lcd_cfg->p_disp_panel->panel_shade == MONOCHROME ? 1 : 0;
@@ -892,18 +1061,18 @@ static int __init fb_probe(struct platfo
 	ret = fb_alloc_cmap(&da8xx_fb_info->cmap, PALETTE_SIZE, 0);
 	if (ret)
 		goto err_free_irq;
-
-	/* First palette_sz byte of the frame buffer is the palette */
 	da8xx_fb_info->cmap.len = par->palette_sz;
 
-	/* Flush the buffer to the screen. */
-	lcd_blit(LOAD_DATA, par);
-
 	/* initialize var_screeninfo */
 	da8xx_fb_var.activate = FB_ACTIVATE_FORCE;
 	fb_set_var(da8xx_fb_info, &da8xx_fb_var);
 
 	dev_set_drvdata(&device->dev, da8xx_fb_info);
+
+	/* initialize the vsync wait queue */
+	init_waitqueue_head(&par->vsync_wait);
+	par->vsync_timeout = HZ / 5;
+
 	/* Register the Frame Buffer  */
 	if (register_framebuffer(da8xx_fb_info) < 0) {
 		dev_err(&device->dev,
@@ -919,10 +1088,6 @@ static int __init fb_probe(struct platfo
 		goto err_cpu_freq;
 	}
 #endif
-
-	/* enable raster engine */
-	lcd_enable_raster();
-
 	return 0;
 
 #ifdef CONFIG_CPU_FREQ
@@ -936,10 +1101,12 @@ err_dealloc_cmap:
 err_free_irq:
 	free_irq(par->irq, par);
 
+err_release_pl_mem:
+	dma_free_coherent(NULL, PALETTE_SIZE, par->v_palette_base,
+			  par->p_palette_base);
+
 err_release_fb_mem:
-	dma_free_coherent(NULL, par->databuf_sz + PAGE_SIZE,
-				da8xx_fb_info->screen_base - PAGE_SIZE,
-				da8xx_fb_info->fix.smem_start);
+	dma_free_coherent(NULL, par->vram_size, par->vram_virt, par->vram_phys);
 
 err_release_fb:
 	framebuffer_release(da8xx_fb_info);
diff -puN include/video/da8xx-fb.h~da8xx-omap-l1xx-fb-implement-double-buffering include/video/da8xx-fb.h
--- a/include/video/da8xx-fb.h~da8xx-omap-l1xx-fb-implement-double-buffering
+++ a/include/video/da8xx-fb.h
@@ -99,6 +99,7 @@ struct lcd_sync_arg {
 #define FBIPUT_COLOR		_IOW('F', 6, int)
 #define FBIPUT_HSYNC		_IOW('F', 9, int)
 #define FBIPUT_VSYNC		_IOW('F', 10, int)
+#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, u_int32_t)
 
 #endif  /* ifndef DA8XX_FB_H */
 
_

Patches currently in -mm which might be from martin@ti.com are

da8xx-omap-l1xx-fb-implement-double-buffering.patch

