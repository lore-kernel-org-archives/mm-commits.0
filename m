From: akpm@linux-foundation.org
Subject: + cirrusfb-checkpatchpl-cleanup.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:23:36 -0700
Message-ID: <200708272223.l7RMNakA031664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56685 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842AbXH0WXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     cirrusfb: checkpatch.pl cleanup
has been added to the -mm tree.  Its filename is
     cirrusfb-checkpatchpl-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cirrusfb: checkpatch.pl cleanup
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes over 850 errors and warnings pointed out by the checkpatch.pl
script.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c | 1776 ++++++++++++++++++++-----------------
 1 files changed, 977 insertions(+), 799 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-checkpatchpl-cleanup drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-checkpatchpl-cleanup
+++ a/drivers/video/cirrusfb.c
@@ -59,7 +59,7 @@
 #endif
 #ifdef CONFIG_PPC_PREP
 #include <asm/machdep.h>
-#define isPReP (machine_is(prep))
+#define isPReP(machine_is(prep))
 #else
 #define isPReP 0
 #endif
@@ -67,7 +67,6 @@
 #include "video/vga.h"
 #include "video/cirrus.h"
 
-
 /*****************************************************************
  *
  * debugging and utility macros
@@ -82,7 +81,8 @@
 
 /* debug output */
 #ifdef CIRRUSFB_DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#define DPRINTK(fmt, args...) \
+	printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
@@ -90,20 +90,19 @@
 /* debugging assertions */
 #ifndef CIRRUSFB_NDEBUG
 #define assert(expr) \
-        if(!(expr)) { \
-        printk( "Assertion failed! %s,%s,%s,line=%d\n",\
-        #expr,__FILE__,__FUNCTION__,__LINE__); \
-        }
+	if (!(expr)) { \
+		printk("Assertion failed! %s,%s,%s,line=%d\n", \
+		#expr, __FILE__, __FUNCTION__, __LINE__); \
+	}
 #else
 #define assert(expr)
 #endif
 
-#define MB_ (1024*1024)
+#define MB_ (1024 * 1024)
 #define KB_ (1024)
 
 #define MAX_NUM_BOARDS 7
 
-
 /*****************************************************************
  *
  * chipset information
@@ -123,7 +122,6 @@ typedef enum {
 	BT_LAGUNA,	/* GD546x */
 } cirrusfb_board_t;
 
-
 /*
  * per-board-type information, used for enumerating and abstracting
  * chip-specific information
@@ -139,7 +137,8 @@ static const struct cirrusfb_board_info_
 	/* for  1/4bpp, 8bpp 15/16bpp, 24bpp, 32bpp - numbers from xorg code */
 	bool init_sr07 : 1; /* init SR07 during init_vgachip() */
 	bool init_sr1f : 1; /* write SR1F during init_vgachip() */
-	bool scrn_start_bit19 : 1; /* construct bit 19 of screen start address */
+	/* construct bit 19 of screen start address */
+	bool scrn_start_bit19 : 1;
 
 	/* initial SR07 value, then for each mode */
 	unsigned char sr07;
@@ -261,30 +260,28 @@ static const struct cirrusfb_board_info_
 	}
 };
 
-
 #ifdef CONFIG_PCI
 #define CHIP(id, btype) \
 	{ PCI_VENDOR_ID_CIRRUS, id, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (btype) }
 
 static struct pci_device_id cirrusfb_pci_table[] = {
-	CHIP( PCI_DEVICE_ID_CIRRUS_5436, BT_ALPINE ),
-	CHIP( PCI_DEVICE_ID_CIRRUS_5434_8, BT_ALPINE ),
-	CHIP( PCI_DEVICE_ID_CIRRUS_5434_4, BT_ALPINE ),
-	CHIP( PCI_DEVICE_ID_CIRRUS_5430, BT_ALPINE ), /* GD-5440 is same id */
-	CHIP( PCI_DEVICE_ID_CIRRUS_7543, BT_ALPINE ),
-	CHIP( PCI_DEVICE_ID_CIRRUS_7548, BT_ALPINE ),
-	CHIP( PCI_DEVICE_ID_CIRRUS_5480, BT_GD5480 ), /* MacPicasso likely */
-	CHIP( PCI_DEVICE_ID_CIRRUS_5446, BT_PICASSO4 ), /* Picasso 4 is 5446 */
-	CHIP( PCI_DEVICE_ID_CIRRUS_5462, BT_LAGUNA ), /* CL Laguna */
-	CHIP( PCI_DEVICE_ID_CIRRUS_5464, BT_LAGUNA ), /* CL Laguna 3D */
-	CHIP( PCI_DEVICE_ID_CIRRUS_5465, BT_LAGUNA ), /* CL Laguna 3DA*/
+	CHIP(PCI_DEVICE_ID_CIRRUS_5436, BT_ALPINE),
+	CHIP(PCI_DEVICE_ID_CIRRUS_5434_8, BT_ALPINE),
+	CHIP(PCI_DEVICE_ID_CIRRUS_5434_4, BT_ALPINE),
+	CHIP(PCI_DEVICE_ID_CIRRUS_5430, BT_ALPINE), /* GD-5440 is same id */
+	CHIP(PCI_DEVICE_ID_CIRRUS_7543, BT_ALPINE),
+	CHIP(PCI_DEVICE_ID_CIRRUS_7548, BT_ALPINE),
+	CHIP(PCI_DEVICE_ID_CIRRUS_5480, BT_GD5480), /* MacPicasso likely */
+	CHIP(PCI_DEVICE_ID_CIRRUS_5446, BT_PICASSO4), /* Picasso 4 is 5446 */
+	CHIP(PCI_DEVICE_ID_CIRRUS_5462, BT_LAGUNA), /* CL Laguna */
+	CHIP(PCI_DEVICE_ID_CIRRUS_5464, BT_LAGUNA), /* CL Laguna 3D */
+	CHIP(PCI_DEVICE_ID_CIRRUS_5465, BT_LAGUNA), /* CL Laguna 3DA*/
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, cirrusfb_pci_table);
 #undef CHIP
 #endif /* CONFIG_PCI */
 
-
 #ifdef CONFIG_ZORRO
 static const struct zorro_device_id cirrusfb_zorro_table[] = {
 	{
@@ -294,7 +291,7 @@ static const struct zorro_device_id cirr
 		.id		= ZORRO_PROD_HELFRICH_PICCOLO_RAM,
 		.driver_data	= BT_PICCOLO,
 	}, {
-		.id		= ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_RAM,
+		.id	= ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_RAM,
 		.driver_data	= BT_PICASSO,
 	}, {
 		.id		= ZORRO_PROD_GVP_EGS_28_24_SPECTRUM_RAM,
@@ -333,7 +330,6 @@ static const struct {
 };
 #endif /* CONFIG_ZORRO */
 
-
 struct cirrusfb_regs {
 	__u32 line_length;	/* in BYTES! */
 	__u32 visual;
@@ -364,17 +360,12 @@ struct cirrusfb_regs {
 	long VertBlankEnd;
 };
 
-
-
 #ifdef CIRRUSFB_DEBUG
 typedef enum {
-        CRT,
-        SEQ
+	CRT,
+	SEQ
 } cirrusfb_dbg_reg_class_t;
-#endif                          /* CIRRUSFB_DEBUG */
-
-
-
+#endif		/* CIRRUSFB_DEBUG */
 
 /* info about board */
 struct cirrusfb_info {
@@ -405,9 +396,8 @@ struct cirrusfb_info {
 	void (*unmap)(struct cirrusfb_info *cinfo);
 };
 
-
 static unsigned cirrusfb_def_mode = 1;
-static int noaccel = 0;
+static int noaccel;
 
 /*
  *    Predefined Video Modes
@@ -441,7 +431,7 @@ static const struct {
 			.lower_margin	= 8,
 			.hsync_len	= 96,
 			.vsync_len	= 4,
-			.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+			.sync	= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 			.vmode		= FB_VMODE_NONINTERLACED
 		 }
 	}, {
@@ -502,27 +492,29 @@ static const struct {
 /****************************************************************************/
 /**** BEGIN PROTOTYPES ******************************************************/
 
-
 /*--- Interface used by the world ------------------------------------------*/
-static int cirrusfb_init (void);
+static int cirrusfb_init(void);
 #ifndef MODULE
-static int cirrusfb_setup (char *options);
+static int cirrusfb_setup(char *options);
 #endif
 
-static int cirrusfb_open (struct fb_info *info, int user);
-static int cirrusfb_release (struct fb_info *info, int user);
-static int cirrusfb_setcolreg (unsigned regno, unsigned red, unsigned green,
-			       unsigned blue, unsigned transp,
-			       struct fb_info *info);
-static int cirrusfb_check_var (struct fb_var_screeninfo *var,
-			       struct fb_info *info);
-static int cirrusfb_set_par (struct fb_info *info);
-static int cirrusfb_pan_display (struct fb_var_screeninfo *var,
-				 struct fb_info *info);
-static int cirrusfb_blank (int blank_mode, struct fb_info *info);
-static void cirrusfb_fillrect (struct fb_info *info, const struct fb_fillrect *region);
-static void cirrusfb_copyarea(struct fb_info *info, const struct fb_copyarea *area);
-static void cirrusfb_imageblit(struct fb_info *info, const struct fb_image *image);
+static int cirrusfb_open(struct fb_info *info, int user);
+static int cirrusfb_release(struct fb_info *info, int user);
+static int cirrusfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			      unsigned blue, unsigned transp,
+			      struct fb_info *info);
+static int cirrusfb_check_var(struct fb_var_screeninfo *var,
+			      struct fb_info *info);
+static int cirrusfb_set_par(struct fb_info *info);
+static int cirrusfb_pan_display(struct fb_var_screeninfo *var,
+				struct fb_info *info);
+static int cirrusfb_blank(int blank_mode, struct fb_info *info);
+static void cirrusfb_fillrect(struct fb_info *info,
+			      const struct fb_fillrect *region);
+static void cirrusfb_copyarea(struct fb_info *info,
+			      const struct fb_copyarea *area);
+static void cirrusfb_imageblit(struct fb_info *info,
+			       const struct fb_image *image);
 
 /* function table of the above functions */
 static struct fb_ops cirrusfb_ops = {
@@ -540,68 +532,68 @@ static struct fb_ops cirrusfb_ops = {
 };
 
 /*--- Hardware Specific Routines -------------------------------------------*/
-static int cirrusfb_decode_var (const struct fb_var_screeninfo *var,
+static int cirrusfb_decode_var(const struct fb_var_screeninfo *var,
 				struct cirrusfb_regs *regs,
 				const struct fb_info *info);
 /*--- Internal routines ----------------------------------------------------*/
-static void init_vgachip (struct cirrusfb_info *cinfo);
-static void switch_monitor (struct cirrusfb_info *cinfo, int on);
-static void WGen (const struct cirrusfb_info *cinfo,
-		  int regnum, unsigned char val);
-static unsigned char RGen (const struct cirrusfb_info *cinfo, int regnum);
-static void AttrOn (const struct cirrusfb_info *cinfo);
-static void WHDR (const struct cirrusfb_info *cinfo, unsigned char val);
-static void WSFR (struct cirrusfb_info *cinfo, unsigned char val);
-static void WSFR2 (struct cirrusfb_info *cinfo, unsigned char val);
-static void WClut (struct cirrusfb_info *cinfo, unsigned char regnum, unsigned char red,
-		   unsigned char green,
-		   unsigned char blue);
+static void init_vgachip(struct cirrusfb_info *cinfo);
+static void switch_monitor(struct cirrusfb_info *cinfo, int on);
+static void WGen(const struct cirrusfb_info *cinfo,
+		 int regnum, unsigned char val);
+static unsigned char RGen(const struct cirrusfb_info *cinfo, int regnum);
+static void AttrOn(const struct cirrusfb_info *cinfo);
+static void WHDR(const struct cirrusfb_info *cinfo, unsigned char val);
+static void WSFR(struct cirrusfb_info *cinfo, unsigned char val);
+static void WSFR2(struct cirrusfb_info *cinfo, unsigned char val);
+static void WClut(struct cirrusfb_info *cinfo, unsigned char regnum,
+		  unsigned char red, unsigned char green, unsigned char blue);
 #if 0
-static void RClut (struct cirrusfb_info *cinfo, unsigned char regnum, unsigned char *red,
-		   unsigned char *green,
-		   unsigned char *blue);
-#endif
-static void cirrusfb_WaitBLT (u8 __iomem *regbase);
-static void cirrusfb_BitBLT (u8 __iomem *regbase, int bits_per_pixel,
-			     u_short curx, u_short cury,
-			     u_short destx, u_short desty,
-			     u_short width, u_short height,
-			     u_short line_length);
-static void cirrusfb_RectFill (u8 __iomem *regbase, int bits_per_pixel,
-			       u_short x, u_short y,
-			       u_short width, u_short height,
-			       u_char color, u_short line_length);
-
-static void bestclock (long freq, long *best,
-		       long *nom, long *den,
-		       long *div, long maxfreq);
+static void RClut(struct cirrusfb_info *cinfo, unsigned char regnum,
+		  unsigned char *red, unsigned char *green,
+		  unsigned char *blue);
+#endif
+static void cirrusfb_WaitBLT(u8 __iomem *regbase);
+static void cirrusfb_BitBLT(u8 __iomem *regbase, int bits_per_pixel,
+			    u_short curx, u_short cury,
+			    u_short destx, u_short desty,
+			    u_short width, u_short height,
+			    u_short line_length);
+static void cirrusfb_RectFill(u8 __iomem *regbase, int bits_per_pixel,
+			      u_short x, u_short y,
+			      u_short width, u_short height,
+			      u_char color, u_short line_length);
+
+static void bestclock(long freq, long *best,
+		      long *nom, long *den,
+		      long *div, long maxfreq);
 
 #ifdef CIRRUSFB_DEBUG
-static void cirrusfb_dump (void);
-static void cirrusfb_dbg_reg_dump (caddr_t regbase);
-static void cirrusfb_dbg_print_regs (caddr_t regbase, cirrusfb_dbg_reg_class_t reg_class,...);
-static void cirrusfb_dbg_print_byte (const char *name, unsigned char val);
+static void cirrusfb_dump(void);
+static void cirrusfb_dbg_reg_dump(caddr_t regbase);
+static void cirrusfb_dbg_print_regs(caddr_t regbase,
+				    cirrusfb_dbg_reg_class_t reg_class, ...);
+static void cirrusfb_dbg_print_byte(const char *name, unsigned char val);
 #endif /* CIRRUSFB_DEBUG */
 
 /*** END   PROTOTYPES ********************************************************/
 /*****************************************************************************/
 /*** BEGIN Interface Used by the World ***************************************/
 
-static int opencount = 0;
+static int opencount;
 
 /*--- Open /dev/fbx ---------------------------------------------------------*/
-static int cirrusfb_open (struct fb_info *info, int user)
+static int cirrusfb_open(struct fb_info *info, int user)
 {
 	if (opencount++ == 0)
-		switch_monitor (info->par, 1);
+		switch_monitor(info->par, 1);
 	return 0;
 }
 
 /*--- Close /dev/fbx --------------------------------------------------------*/
-static int cirrusfb_release (struct fb_info *info, int user)
+static int cirrusfb_release(struct fb_info *info, int user)
 {
 	if (--opencount == 0)
-		switch_monitor (info->par, 0);
+		switch_monitor(info->par, 0);
 	return 0;
 }
 
@@ -610,11 +602,11 @@ static int cirrusfb_release (struct fb_i
 /**** BEGIN Hardware specific Routines **************************************/
 
 /* Get a good MCLK value */
-static long cirrusfb_get_mclk (long freq, int bpp, long *div)
+static long cirrusfb_get_mclk(long freq, int bpp, long *div)
 {
 	long mclk;
 
-	assert (div != NULL);
+	assert(div != NULL);
 
 	/* Calculate MCLK, in case VCLK is high enough to require > 50MHz.
 	 * Assume a 64-bit data path for now.  The formula is:
@@ -624,23 +616,23 @@ static long cirrusfb_get_mclk (long freq
 	mclk = (mclk * 12) / 10;
 	if (mclk < 50000)
 		mclk = 50000;
-	DPRINTK ("Use MCLK of %ld kHz\n", mclk);
+	DPRINTK("Use MCLK of %ld kHz\n", mclk);
 
 	/* Calculate value for SR1F.  Multiply by 2 so we can round up. */
 	mclk = ((mclk * 16) / 14318);
 	mclk = (mclk + 1) / 2;
-	DPRINTK ("Set SR1F[5:0] to 0x%lx\n", mclk);
+	DPRINTK("Set SR1F[5:0] to 0x%lx\n", mclk);
 
 	/* Determine if we should use MCLK instead of VCLK, and if so, what we
 	   * should divide it by to get VCLK */
 	switch (freq) {
 	case 24751 ... 25249:
 		*div = 2;
-		DPRINTK ("Using VCLK = MCLK/2\n");
+		DPRINTK("Using VCLK = MCLK/2\n");
 		break;
 	case 49501 ... 50499:
 		*div = 1;
-		DPRINTK ("Using VCLK = MCLK\n");
+		DPRINTK("Using VCLK = MCLK\n");
 		break;
 	default:
 		*div = 0;
@@ -691,37 +683,42 @@ static int cirrusfb_check_var(struct fb_
 		den = 1;
 		break;		/* 4 bytes per pixel */
 	default:
-		printk ("cirrusfb: mode %dx%dx%d rejected...color depth not supported.\n",
+		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected..."
+			"color depth not supported.\n",
 			var->xres, var->yres, var->bits_per_pixel);
-		DPRINTK ("EXIT - EINVAL error\n");
+		DPRINTK("EXIT - EINVAL error\n");
 		return -EINVAL;
 	}
 
 	if (var->xres * nom / den * var->yres > cinfo->size) {
-		printk ("cirrusfb: mode %dx%dx%d rejected...resolution too high to fit into video memory!\n",
+		printk(KERN_ERR "cirrusfb: mode %dx%dx%d rejected..."
+			"resolution too high to fit into video memory!\n",
 			var->xres, var->yres, var->bits_per_pixel);
-		DPRINTK ("EXIT - EINVAL error\n");
+		DPRINTK("EXIT - EINVAL error\n");
 		return -EINVAL;
 	}
 
 	/* use highest possible virtual resolution */
 	if (var->xres_virtual == -1 &&
 	    var->yres_virtual == -1) {
-		printk ("cirrusfb: using maximum available virtual resolution\n");
+		printk(KERN_INFO
+		     "cirrusfb: using maximum available virtual resolution\n");
 		for (i = 0; modes[i].xres != -1; i++) {
 			if (modes[i].xres * nom / den * modes[i].yres < cinfo->size / 2)
 				break;
 		}
 		if (modes[i].xres == -1) {
-			printk ("cirrusfb: could not find a virtual resolution that fits into video memory!!\n");
-			DPRINTK ("EXIT - EINVAL error\n");
+			printk(KERN_ERR "cirrusfb: could not find a virtual "
+				"resolution that fits into video memory!!\n");
+			DPRINTK("EXIT - EINVAL error\n");
 			return -EINVAL;
 		}
 		var->xres_virtual = modes[i].xres;
 		var->yres_virtual = modes[i].yres;
 
-		printk ("cirrusfb: virtual resolution set to maximum of %dx%d\n",
-			var->xres_virtual, var->yres_virtual);
+		printk(KERN_INFO "cirrusfb: virtual resolution set to "
+			"maximum of %dx%d\n", var->xres_virtual,
+			var->yres_virtual);
 	}
 
 	if (var->xres_virtual < var->xres)
@@ -760,7 +757,7 @@ static int cirrusfb_check_var(struct fb_
 		break;
 
 	case 16:
-		if(isPReP) {
+		if (isPReP) {
 			var->red.offset = 2;
 			var->green.offset = -3;
 			var->blue.offset = 8;
@@ -775,7 +772,7 @@ static int cirrusfb_check_var(struct fb_
 		break;
 
 	case 24:
-		if(isPReP) {
+		if (isPReP) {
 			var->red.offset = 8;
 			var->green.offset = 16;
 			var->blue.offset = 24;
@@ -790,7 +787,7 @@ static int cirrusfb_check_var(struct fb_
 		break;
 
 	case 32:
-		if(isPReP) {
+		if (isPReP) {
 			var->red.offset = 8;
 			var->green.offset = 16;
 			var->blue.offset = 24;
@@ -825,15 +822,16 @@ static int cirrusfb_check_var(struct fb_
 		yres = (yres + 1) / 2;
 
 	if (yres >= 1280) {
-		printk (KERN_WARNING "cirrusfb: ERROR: VerticalTotal >= 1280; special treatment required! (TODO)\n");
-		DPRINTK ("EXIT - EINVAL error\n");
+		printk(KERN_ERR "cirrusfb: ERROR: VerticalTotal >= 1280; "
+			"special treatment required! (TODO)\n");
+		DPRINTK("EXIT - EINVAL error\n");
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
-static int cirrusfb_decode_var (const struct fb_var_screeninfo *var,
+static int cirrusfb_decode_var(const struct fb_var_screeninfo *var,
 				struct cirrusfb_regs *regs,
 				const struct fb_info *info)
 {
@@ -844,7 +842,7 @@ static int cirrusfb_decode_var (const st
 	int xres, hfront, hsync, hback;
 	int yres, vfront, vsync, vback;
 
-	switch(var->bits_per_pixel) {
+	switch (var->bits_per_pixel) {
 	case 1:
 		regs->line_length = var->xres_virtual / 8;
 		regs->visual = FB_VISUAL_MONO10;
@@ -887,7 +885,7 @@ static int cirrusfb_decode_var (const st
 	/* convert from ps to kHz */
 	freq = 1000000000 / var->pixclock;
 
-	DPRINTK ("desired pixclock: %ld kHz\n", freq);
+	DPRINTK("desired pixclock: %ld kHz\n", freq);
 
 	maxclock = cirrusfb_board_info[cinfo->btype].maxclock[maxclockidx];
 	regs->multiplexing = 0;
@@ -902,8 +900,9 @@ static int cirrusfb_decode_var (const st
 			break;
 
 		default:
-			printk (KERN_WARNING "cirrusfb: ERROR: Frequency greater than maxclock (%ld kHz)\n", maxclock);
-			DPRINTK ("EXIT - return -EINVAL\n");
+			printk(KERN_ERR "cirrusfb: Frequency greater "
+				"than maxclock (%ld kHz)\n", maxclock);
+			DPRINTK("EXIT - return -EINVAL\n");
 			return -EINVAL;
 		}
 	}
@@ -914,14 +913,16 @@ static int cirrusfb_decode_var (const st
 	case 16:
 	case 32:
 		if (regs->HorizRes <= 800)
-			freq /= 2;	/* Xbh has this type of clock for 32-bit */
+			/* Xbh has this type of clock for 32-bit */
+			freq /= 2;
 		break;
 	}
 #endif
 
-	bestclock (freq, &regs->freq, &regs->nom, &regs->den, &regs->div,
-		   maxclock);
-	regs->mclk = cirrusfb_get_mclk (freq, var->bits_per_pixel, &regs->divMCLK);
+	bestclock(freq, &regs->freq, &regs->nom, &regs->den, &regs->div,
+		  maxclock);
+	regs->mclk = cirrusfb_get_mclk(freq, var->bits_per_pixel,
+					&regs->divMCLK);
 
 	xres = var->xres;
 	hfront = var->right_margin;
@@ -948,7 +949,8 @@ static int cirrusfb_decode_var (const st
 	regs->HorizTotal = (xres + hfront + hsync + hback) / 8 - 5;
 	regs->HorizDispEnd = xres / 8 - 1;
 	regs->HorizBlankStart = xres / 8;
-	regs->HorizBlankEnd = regs->HorizTotal + 5;	/* does not count with "-5" */
+	/* does not count with "-5" */
+	regs->HorizBlankEnd = regs->HorizTotal + 5;
 	regs->HorizSyncStart = (xres + hfront) / 8 + 1;
 	regs->HorizSyncEnd = (xres + hfront + hsync) / 8 + 1;
 
@@ -976,23 +978,23 @@ static int cirrusfb_decode_var (const st
 	return 0;
 }
 
-
-static void cirrusfb_set_mclk (const struct cirrusfb_info *cinfo, int val, int div)
+static void cirrusfb_set_mclk(const struct cirrusfb_info *cinfo, int val,
+				int div)
 {
-	assert (cinfo != NULL);
+	assert(cinfo != NULL);
 
 	if (div == 2) {
 		/* VCLK = MCLK/2 */
-		unsigned char old = vga_rseq (cinfo->regbase, CL_SEQR1E);
-		vga_wseq (cinfo->regbase, CL_SEQR1E, old | 0x1);
-		vga_wseq (cinfo->regbase, CL_SEQR1F, 0x40 | (val & 0x3f));
+		unsigned char old = vga_rseq(cinfo->regbase, CL_SEQR1E);
+		vga_wseq(cinfo->regbase, CL_SEQR1E, old | 0x1);
+		vga_wseq(cinfo->regbase, CL_SEQR1F, 0x40 | (val & 0x3f));
 	} else if (div == 1) {
 		/* VCLK = MCLK */
-		unsigned char old = vga_rseq (cinfo->regbase, CL_SEQR1E);
-		vga_wseq (cinfo->regbase, CL_SEQR1E, old & ~0x1);
-		vga_wseq (cinfo->regbase, CL_SEQR1F, 0x40 | (val & 0x3f));
+		unsigned char old = vga_rseq(cinfo->regbase, CL_SEQR1E);
+		vga_wseq(cinfo->regbase, CL_SEQR1E, old & ~0x1);
+		vga_wseq(cinfo->regbase, CL_SEQR1F, 0x40 | (val & 0x3f));
 	} else {
-		vga_wseq (cinfo->regbase, CL_SEQR1F, val & 0x3f);
+		vga_wseq(cinfo->regbase, CL_SEQR1F, val & 0x3f);
 	}
 }
 
@@ -1001,7 +1003,7 @@ static void cirrusfb_set_mclk (const str
 
 	actually writes the values for a new video mode into the hardware,
 **************************************************************************/
-static int cirrusfb_set_par_foo (struct fb_info *info)
+static int cirrusfb_set_par_foo(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
 	struct fb_var_screeninfo *var = &info->var;
@@ -1011,15 +1013,15 @@ static int cirrusfb_set_par_foo (struct 
 	int offset = 0, err;
 	const struct cirrusfb_board_info_rec *bi;
 
-	DPRINTK ("ENTER\n");
-	DPRINTK ("Requested mode: %dx%dx%d\n",
+	DPRINTK("ENTER\n");
+	DPRINTK("Requested mode: %dx%dx%d\n",
 	       var->xres, var->yres, var->bits_per_pixel);
-	DPRINTK ("pixclock: %d\n", var->pixclock);
+	DPRINTK("pixclock: %d\n", var->pixclock);
 
-	init_vgachip (cinfo);
+	init_vgachip(cinfo);
 
 	err = cirrusfb_decode_var(var, &regs, info);
-	if(err) {
+	if (err) {
 		/* should never happen */
 		DPRINTK("mode change aborted.  invalid var.\n");
 		return -EINVAL;
@@ -1027,34 +1029,35 @@ static int cirrusfb_set_par_foo (struct 
 
 	bi = &cirrusfb_board_info[cinfo->btype];
 
-
 	/* unlock register VGA_CRTC_H_TOTAL..CRT7 */
-	vga_wcrt (regbase, VGA_CRTC_V_SYNC_END, 0x20);	/* previously: 0x00) */
+	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);	/* previously: 0x00) */
 
 	/* if debugging is enabled, all parameters get output before writing */
-	DPRINTK ("CRT0: %ld\n", regs.HorizTotal);
-	vga_wcrt (regbase, VGA_CRTC_H_TOTAL, regs.HorizTotal);
+	DPRINTK("CRT0: %ld\n", regs.HorizTotal);
+	vga_wcrt(regbase, VGA_CRTC_H_TOTAL, regs.HorizTotal);
 
-	DPRINTK ("CRT1: %ld\n", regs.HorizDispEnd);
-	vga_wcrt (regbase, VGA_CRTC_H_DISP, regs.HorizDispEnd);
+	DPRINTK("CRT1: %ld\n", regs.HorizDispEnd);
+	vga_wcrt(regbase, VGA_CRTC_H_DISP, regs.HorizDispEnd);
 
-	DPRINTK ("CRT2: %ld\n", regs.HorizBlankStart);
-	vga_wcrt (regbase, VGA_CRTC_H_BLANK_START, regs.HorizBlankStart);
+	DPRINTK("CRT2: %ld\n", regs.HorizBlankStart);
+	vga_wcrt(regbase, VGA_CRTC_H_BLANK_START, regs.HorizBlankStart);
 
-	DPRINTK ("CRT3: 128+%ld\n", regs.HorizBlankEnd % 32);	/*  + 128: Compatible read */
-	vga_wcrt (regbase, VGA_CRTC_H_BLANK_END, 128 + (regs.HorizBlankEnd % 32));
+	/*  + 128: Compatible read */
+	DPRINTK("CRT3: 128+%ld\n", regs.HorizBlankEnd % 32);
+	vga_wcrt(regbase, VGA_CRTC_H_BLANK_END,
+		 128 + (regs.HorizBlankEnd % 32));
 
-	DPRINTK ("CRT4: %ld\n", regs.HorizSyncStart);
-	vga_wcrt (regbase, VGA_CRTC_H_SYNC_START, regs.HorizSyncStart);
+	DPRINTK("CRT4: %ld\n", regs.HorizSyncStart);
+	vga_wcrt(regbase, VGA_CRTC_H_SYNC_START, regs.HorizSyncStart);
 
 	tmp = regs.HorizSyncEnd % 32;
 	if (regs.HorizBlankEnd & 32)
 		tmp += 128;
-	DPRINTK ("CRT5: %d\n", tmp);
-	vga_wcrt (regbase, VGA_CRTC_H_SYNC_END, tmp);
+	DPRINTK("CRT5: %d\n", tmp);
+	vga_wcrt(regbase, VGA_CRTC_H_SYNC_END, tmp);
 
-	DPRINTK ("CRT6: %ld\n", regs.VertTotal & 0xff);
-	vga_wcrt (regbase, VGA_CRTC_V_TOTAL, (regs.VertTotal & 0xff));
+	DPRINTK("CRT6: %ld\n", regs.VertTotal & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_TOTAL, (regs.VertTotal & 0xff));
 
 	tmp = 16;		/* LineCompare bit #9 */
 	if (regs.VertTotal & 256)
@@ -1071,34 +1074,34 @@ static int cirrusfb_set_par_foo (struct 
 		tmp |= 64;
 	if (regs.VertSyncStart & 512)
 		tmp |= 128;
-	DPRINTK ("CRT7: %d\n", tmp);
-	vga_wcrt (regbase, VGA_CRTC_OVERFLOW, tmp);
+	DPRINTK("CRT7: %d\n", tmp);
+	vga_wcrt(regbase, VGA_CRTC_OVERFLOW, tmp);
 
 	tmp = 0x40;		/* LineCompare bit #8 */
 	if (regs.VertBlankStart & 512)
 		tmp |= 0x20;
 	if (var->vmode & FB_VMODE_DOUBLE)
 		tmp |= 0x80;
-	DPRINTK ("CRT9: %d\n", tmp);
-	vga_wcrt (regbase, VGA_CRTC_MAX_SCAN, tmp);
+	DPRINTK("CRT9: %d\n", tmp);
+	vga_wcrt(regbase, VGA_CRTC_MAX_SCAN, tmp);
 
-	DPRINTK ("CRT10: %ld\n", regs.VertSyncStart & 0xff);
-	vga_wcrt (regbase, VGA_CRTC_V_SYNC_START, (regs.VertSyncStart & 0xff));
+	DPRINTK("CRT10: %ld\n", regs.VertSyncStart & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_SYNC_START, regs.VertSyncStart & 0xff);
 
-	DPRINTK ("CRT11: 64+32+%ld\n", regs.VertSyncEnd % 16);
-	vga_wcrt (regbase, VGA_CRTC_V_SYNC_END, (regs.VertSyncEnd % 16 + 64 + 32));
+	DPRINTK("CRT11: 64+32+%ld\n", regs.VertSyncEnd % 16);
+	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, regs.VertSyncEnd % 16 + 64 + 32);
 
-	DPRINTK ("CRT12: %ld\n", regs.VertDispEnd & 0xff);
-	vga_wcrt (regbase, VGA_CRTC_V_DISP_END, (regs.VertDispEnd & 0xff));
+	DPRINTK("CRT12: %ld\n", regs.VertDispEnd & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_DISP_END, regs.VertDispEnd & 0xff);
 
-	DPRINTK ("CRT15: %ld\n", regs.VertBlankStart & 0xff);
-	vga_wcrt (regbase, VGA_CRTC_V_BLANK_START, (regs.VertBlankStart & 0xff));
+	DPRINTK("CRT15: %ld\n", regs.VertBlankStart & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_BLANK_START, regs.VertBlankStart & 0xff);
 
-	DPRINTK ("CRT16: %ld\n", regs.VertBlankEnd & 0xff);
-	vga_wcrt (regbase, VGA_CRTC_V_BLANK_END, (regs.VertBlankEnd & 0xff));
+	DPRINTK("CRT16: %ld\n", regs.VertBlankEnd & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_V_BLANK_END, regs.VertBlankEnd & 0xff);
 
-	DPRINTK ("CRT18: 0xff\n");
-	vga_wcrt (regbase, VGA_CRTC_LINE_COMPARE, 0xff);
+	DPRINTK("CRT18: 0xff\n");
+	vga_wcrt(regbase, VGA_CRTC_LINE_COMPARE, 0xff);
 
 	tmp = 0;
 	if (var->vmode & FB_VMODE_INTERLACED)
@@ -1112,57 +1115,63 @@ static int cirrusfb_set_par_foo (struct 
 	if (regs.VertBlankEnd & 512)
 		tmp |= 128;
 
-	DPRINTK ("CRT1a: %d\n", tmp);
-	vga_wcrt (regbase, CL_CRT1A, tmp);
+	DPRINTK("CRT1a: %d\n", tmp);
+	vga_wcrt(regbase, CL_CRT1A, tmp);
 
 	/* set VCLK0 */
 	/* hardware RefClock: 14.31818 MHz */
 	/* formula: VClk = (OSC * N) / (D * (1+P)) */
 	/* Example: VClk = (14.31818 * 91) / (23 * (1+1)) = 28.325 MHz */
 
-	vga_wseq (regbase, CL_SEQRB, regs.nom);
+	vga_wseq(regbase, CL_SEQRB, regs.nom);
 	tmp = regs.den << 1;
 	if (regs.div != 0)
 		tmp |= 1;
 
+	/* 6 bit denom; ONLY 5434!!! (bugged me 10 days) */
 	if ((cinfo->btype == BT_SD64) ||
 	    (cinfo->btype == BT_ALPINE) ||
 	    (cinfo->btype == BT_GD5480))
-		tmp |= 0x80;	/* 6 bit denom; ONLY 5434!!! (bugged me 10 days) */
+		tmp |= 0x80;
 
-	DPRINTK ("CL_SEQR1B: %ld\n", (long) tmp);
-	vga_wseq (regbase, CL_SEQR1B, tmp);
+	DPRINTK("CL_SEQR1B: %ld\n", (long) tmp);
+	vga_wseq(regbase, CL_SEQR1B, tmp);
 
 	if (regs.VertRes >= 1024)
 		/* 1280x1024 */
-		vga_wcrt (regbase, VGA_CRTC_MODE, 0xc7);
+		vga_wcrt(regbase, VGA_CRTC_MODE, 0xc7);
 	else
 		/* mode control: VGA_CRTC_START_HI enable, ROTATE(?), 16bit
 		 * address wrap, no compat. */
-		vga_wcrt (regbase, VGA_CRTC_MODE, 0xc3);
+		vga_wcrt(regbase, VGA_CRTC_MODE, 0xc3);
 
-/* HAEH?        vga_wcrt (regbase, VGA_CRTC_V_SYNC_END, 0x20);  * previously: 0x00  unlock VGA_CRTC_H_TOTAL..CRT7 */
+/* HAEH?	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);
+ * previously: 0x00  unlock VGA_CRTC_H_TOTAL..CRT7 */
 
 	/* don't know if it would hurt to also program this if no interlaced */
 	/* mode is used, but I feel better this way.. :-) */
 	if (var->vmode & FB_VMODE_INTERLACED)
-		vga_wcrt (regbase, VGA_CRTC_REGS, regs.HorizTotal / 2);
+		vga_wcrt(regbase, VGA_CRTC_REGS, regs.HorizTotal / 2);
 	else
-		vga_wcrt (regbase, VGA_CRTC_REGS, 0x00);	/* interlace control */
+		vga_wcrt(regbase, VGA_CRTC_REGS, 0x00);	/* interlace control */
 
-	vga_wseq (regbase, VGA_SEQ_CHARACTER_MAP, 0);
+	vga_wseq(regbase, VGA_SEQ_CHARACTER_MAP, 0);
 
 	/* adjust horizontal/vertical sync type (low/high) */
-	tmp = 0x03;		/* enable display memory & CRTC I/O address for color mode */
+	/* enable display memory & CRTC I/O address for color mode */
+	tmp = 0x03;
 	if (var->sync & FB_SYNC_HOR_HIGH_ACT)
 		tmp |= 0x40;
 	if (var->sync & FB_SYNC_VERT_HIGH_ACT)
 		tmp |= 0x80;
-	WGen (cinfo, VGA_MIS_W, tmp);
+	WGen(cinfo, VGA_MIS_W, tmp);
 
-	vga_wcrt (regbase, VGA_CRTC_PRESET_ROW, 0);	/* Screen A Preset Row-Scan register */
-	vga_wcrt (regbase, VGA_CRTC_CURSOR_START, 0);	/* text cursor on and start line */
-	vga_wcrt (regbase, VGA_CRTC_CURSOR_END, 31);	/* text cursor end line */
+	/* Screen A Preset Row-Scan register */
+	vga_wcrt(regbase, VGA_CRTC_PRESET_ROW, 0);
+	/* text cursor on and start line */
+	vga_wcrt(regbase, VGA_CRTC_CURSOR_START, 0);
+	/* text cursor end line */
+	vga_wcrt(regbase, VGA_CRTC_CURSOR_END, 31);
 
 	/******************************************************
 	 *
@@ -1172,8 +1181,8 @@ static int cirrusfb_set_par_foo (struct 
 
 	/* programming for different color depths */
 	if (var->bits_per_pixel == 1) {
-		DPRINTK ("cirrusfb: preparing for 1 bit deep display\n");
-		vga_wgfx (regbase, VGA_GFX_MODE, 0);	/* mode register */
+		DPRINTK("cirrusfb: preparing for 1 bit deep display\n");
+		vga_wgfx(regbase, VGA_GFX_MODE, 0);	/* mode register */
 
 		/* SR07 */
 		switch (cinfo->btype) {
@@ -1184,71 +1193,85 @@ static int cirrusfb_set_par_foo (struct 
 		case BT_PICASSO4:
 		case BT_ALPINE:
 		case BT_GD5480:
-			DPRINTK (" (for GD54xx)\n");
-			vga_wseq (regbase, CL_SEQR7,
+			DPRINTK(" (for GD54xx)\n");
+			vga_wseq(regbase, CL_SEQR7,
 				  regs.multiplexing ?
 					bi->sr07_1bpp_mux : bi->sr07_1bpp);
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK (" (for GD546x)\n");
-			vga_wseq (regbase, CL_SEQR7,
-				vga_rseq (regbase, CL_SEQR7) & ~0x01);
+			DPRINTK(" (for GD546x)\n");
+			vga_wseq(regbase, CL_SEQR7,
+				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			break;
 
 		default:
-			printk (KERN_WARNING "cirrusfb: unknown Board\n");
+			printk(KERN_WARNING "cirrusfb: unknown Board\n");
 			break;
 		}
 
 		/* Extended Sequencer Mode */
 		switch (cinfo->btype) {
 		case BT_SD64:
-			/* setting the SEQRF on SD64 is not necessary (only during init) */
-			DPRINTK ("(for SD64)\n");
-			vga_wseq (regbase, CL_SEQR1F, 0x1a);		/*  MCLK select */
+			/* setting the SEQRF on SD64 is not necessary
+			 * (only during init)
+			 */
+			DPRINTK("(for SD64)\n");
+			/*  MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x1a);
 			break;
 
 		case BT_PICCOLO:
-			DPRINTK ("(for Piccolo)\n");
-/* ### ueberall 0x22? */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* ##vorher 1c MCLK select */
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* evtl d0 bei 1 bit? avoid FIFO underruns..? */
+			DPRINTK("(for Piccolo)\n");
+			/* ### ueberall 0x22? */
+			/* ##vorher 1c MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
+			/* evtl d0 bei 1 bit? avoid FIFO underruns..? */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
 			break;
 
 		case BT_PICASSO:
-			DPRINTK ("(for Picasso)\n");
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* ##vorher 22 MCLK select */
-			vga_wseq (regbase, CL_SEQRF, 0xd0);	/* ## vorher d0 avoid FIFO underruns..? */
+			DPRINTK("(for Picasso)\n");
+			/* ##vorher 22 MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
+			/* ## vorher d0 avoid FIFO underruns..? */
+			vga_wseq(regbase, CL_SEQRF, 0xd0);
 			break;
 
 		case BT_SPECTRUM:
-			DPRINTK ("(for Spectrum)\n");
-/* ### ueberall 0x22? */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* ##vorher 1c MCLK select */
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* evtl d0? avoid FIFO underruns..? */
+			DPRINTK("(for Spectrum)\n");
+			/* ### ueberall 0x22? */
+			/* ##vorher 1c MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
+			/* evtl d0? avoid FIFO underruns..? */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
 			break;
 
 		case BT_PICASSO4:
 		case BT_ALPINE:
 		case BT_GD5480:
 		case BT_LAGUNA:
-			DPRINTK (" (for GD54xx)\n");
+			DPRINTK(" (for GD54xx)\n");
 			/* do nothing */
 			break;
 
 		default:
-			printk (KERN_WARNING "cirrusfb: unknown Board\n");
+			printk(KERN_WARNING "cirrusfb: unknown Board\n");
 			break;
 		}
 
-		WGen (cinfo, VGA_PEL_MSK, 0x01);	/* pixel mask: pass-through for first plane */
+		/* pixel mask: pass-through for first plane */
+		WGen(cinfo, VGA_PEL_MSK, 0x01);
 		if (regs.multiplexing)
-			WHDR (cinfo, 0x4a);	/* hidden dac reg: 1280x1024 */
+			/* hidden dac reg: 1280x1024 */
+			WHDR(cinfo, 0x4a);
 		else
-			WHDR (cinfo, 0);	/* hidden dac: nothing */
-		vga_wseq (regbase, VGA_SEQ_MEMORY_MODE, 0x06);	/* memory mode: odd/even, ext. memory */
-		vga_wseq (regbase, VGA_SEQ_PLANE_WRITE, 0x01);	/* plane mask: only write to first plane */
+			/* hidden dac: nothing */
+			WHDR(cinfo, 0);
+		/* memory mode: odd/even, ext. memory */
+		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x06);
+		/* plane mask: only write to first plane */
+		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0x01);
 		offset = var->xres_virtual / 16;
 	}
 
@@ -1259,7 +1282,7 @@ static int cirrusfb_set_par_foo (struct 
 	 */
 
 	else if (var->bits_per_pixel == 8) {
-		DPRINTK ("cirrusfb: preparing for 8 bit deep display\n");
+		DPRINTK("cirrusfb: preparing for 8 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
 		case BT_PICCOLO:
@@ -1268,75 +1291,89 @@ static int cirrusfb_set_par_foo (struct 
 		case BT_PICASSO4:
 		case BT_ALPINE:
 		case BT_GD5480:
-			DPRINTK (" (for GD54xx)\n");
-			vga_wseq (regbase, CL_SEQR7,
+			DPRINTK(" (for GD54xx)\n");
+			vga_wseq(regbase, CL_SEQR7,
 				  regs.multiplexing ?
 					bi->sr07_8bpp_mux : bi->sr07_8bpp);
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK (" (for GD546x)\n");
-			vga_wseq (regbase, CL_SEQR7,
-				vga_rseq (regbase, CL_SEQR7) | 0x01);
+			DPRINTK(" (for GD546x)\n");
+			vga_wseq(regbase, CL_SEQR7,
+				vga_rseq(regbase, CL_SEQR7) | 0x01);
 			break;
 
 		default:
-			printk (KERN_WARNING "cirrusfb: unknown Board\n");
+			printk(KERN_WARNING "cirrusfb: unknown Board\n");
 			break;
 		}
 
 		switch (cinfo->btype) {
 		case BT_SD64:
-			vga_wseq (regbase, CL_SEQR1F, 0x1d);		/* MCLK select */
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x1d);
 			break;
 
 		case BT_PICCOLO:
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* ### vorher 1c MCLK select */
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
+			/* ### vorher 1c MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
 			break;
 
 		case BT_PICASSO:
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* ### vorher 1c MCLK select */
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
+			/* ### vorher 1c MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
 			break;
 
 		case BT_SPECTRUM:
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* ### vorher 1c MCLK select */
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
+			/* ### vorher 1c MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
 			break;
 
 		case BT_PICASSO4:
 #ifdef CONFIG_ZORRO
-			vga_wseq (regbase, CL_SEQRF, 0xb8);	/* ### INCOMPLETE!! */
+			/* ### INCOMPLETE!! */
+			vga_wseq(regbase, CL_SEQRF, 0xb8);
 #endif
-/*          vga_wseq (regbase, CL_SEQR1F, 0x1c); */
+/*	  		vga_wseq(regbase, CL_SEQR1F, 0x1c); */
 			break;
 
 		case BT_ALPINE:
-			DPRINTK (" (for GD543x)\n");
-			cirrusfb_set_mclk (cinfo, regs.mclk, regs.divMCLK);
+			DPRINTK(" (for GD543x)\n");
+			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			/* We already set SRF and SR1F */
 			break;
 
 		case BT_GD5480:
 		case BT_LAGUNA:
-			DPRINTK (" (for GD54xx)\n");
+			DPRINTK(" (for GD54xx)\n");
 			/* do nothing */
 			break;
 
 		default:
-			printk (KERN_WARNING "cirrusfb: unknown Board\n");
+			printk(KERN_WARNING "cirrusfb: unknown Board\n");
 			break;
 		}
 
-		vga_wgfx (regbase, VGA_GFX_MODE, 64);	/* mode register: 256 color mode */
-		WGen (cinfo, VGA_PEL_MSK, 0xff);	/* pixel mask: pass-through all planes */
+		/* mode register: 256 color mode */
+		vga_wgfx(regbase, VGA_GFX_MODE, 64);
+		/* pixel mask: pass-through all planes */
+		WGen(cinfo, VGA_PEL_MSK, 0xff);
 		if (regs.multiplexing)
-			WHDR (cinfo, 0x4a);	/* hidden dac reg: 1280x1024 */
+			/* hidden dac reg: 1280x1024 */
+			WHDR(cinfo, 0x4a);
 		else
-			WHDR (cinfo, 0);	/* hidden dac: nothing */
-		vga_wseq (regbase, VGA_SEQ_MEMORY_MODE, 0x0a);	/* memory mode: chain4, ext. memory */
-		vga_wseq (regbase, VGA_SEQ_PLANE_WRITE, 0xff);	/* plane mask: enable writing to all 4 planes */
+			/* hidden dac: nothing */
+			WHDR(cinfo, 0);
+		/* memory mode: chain4, ext. memory */
+		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
+		/* plane mask: enable writing to all 4 planes */
+		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
 		offset = var->xres_virtual / 8;
 	}
 
@@ -1347,72 +1384,84 @@ static int cirrusfb_set_par_foo (struct 
 	 */
 
 	else if (var->bits_per_pixel == 16) {
-		DPRINTK ("cirrusfb: preparing for 16 bit deep display\n");
+		DPRINTK("cirrusfb: preparing for 16 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
-			vga_wseq (regbase, CL_SEQR7, 0xf7);	/* Extended Sequencer Mode: 256c col. mode */
-			vga_wseq (regbase, CL_SEQR1F, 0x1e);		/* MCLK select */
+			/* Extended Sequencer Mode: 256c col. mode */
+			vga_wseq(regbase, CL_SEQR7, 0xf7);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x1e);
 			break;
 
 		case BT_PICCOLO:
-			vga_wseq (regbase, CL_SEQR7, 0x87);
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* MCLK select */
+			vga_wseq(regbase, CL_SEQR7, 0x87);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_PICASSO:
-			vga_wseq (regbase, CL_SEQR7, 0x27);
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* MCLK select */
+			vga_wseq(regbase, CL_SEQR7, 0x27);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_SPECTRUM:
-			vga_wseq (regbase, CL_SEQR7, 0x87);
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* MCLK select */
+			vga_wseq(regbase, CL_SEQR7, 0x87);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_PICASSO4:
-			vga_wseq (regbase, CL_SEQR7, 0x27);
-/*          vga_wseq (regbase, CL_SEQR1F, 0x1c);  */
+			vga_wseq(regbase, CL_SEQR7, 0x27);
+/*			vga_wseq(regbase, CL_SEQR1F, 0x1c);  */
 			break;
 
 		case BT_ALPINE:
-			DPRINTK (" (for GD543x)\n");
+			DPRINTK(" (for GD543x)\n");
 			if (regs.HorizRes >= 1024)
-				vga_wseq (regbase, CL_SEQR7, 0xa7);
+				vga_wseq(regbase, CL_SEQR7, 0xa7);
 			else
-				vga_wseq (regbase, CL_SEQR7, 0xa3);
-			cirrusfb_set_mclk (cinfo, regs.mclk, regs.divMCLK);
+				vga_wseq(regbase, CL_SEQR7, 0xa3);
+			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			break;
 
 		case BT_GD5480:
-			DPRINTK (" (for GD5480)\n");
-			vga_wseq (regbase, CL_SEQR7, 0x17);
+			DPRINTK(" (for GD5480)\n");
+			vga_wseq(regbase, CL_SEQR7, 0x17);
 			/* We already set SRF and SR1F */
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK (" (for GD546x)\n");
-			vga_wseq (regbase, CL_SEQR7,
-				vga_rseq (regbase, CL_SEQR7) & ~0x01);
+			DPRINTK(" (for GD546x)\n");
+			vga_wseq(regbase, CL_SEQR7,
+				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			break;
 
 		default:
-			printk (KERN_WARNING "CIRRUSFB: unknown Board\n");
+			printk(KERN_WARNING "CIRRUSFB: unknown Board\n");
 			break;
 		}
 
-		vga_wgfx (regbase, VGA_GFX_MODE, 64);	/* mode register: 256 color mode */
-		WGen (cinfo, VGA_PEL_MSK, 0xff);	/* pixel mask: pass-through all planes */
+		/* mode register: 256 color mode */
+		vga_wgfx(regbase, VGA_GFX_MODE, 64);
+		/* pixel mask: pass-through all planes */
+		WGen(cinfo, VGA_PEL_MSK, 0xff);
 #ifdef CONFIG_PCI
-		WHDR (cinfo, 0xc0);	/* Copy Xbh */
+		WHDR(cinfo, 0xc0);	/* Copy Xbh */
 #elif defined(CONFIG_ZORRO)
 		/* FIXME: CONFIG_PCI and CONFIG_ZORRO may be defined both */
-		WHDR (cinfo, 0xa0);	/* hidden dac reg: nothing special */
+		WHDR(cinfo, 0xa0);	/* hidden dac reg: nothing special */
 #endif
-		vga_wseq (regbase, VGA_SEQ_MEMORY_MODE, 0x0a);	/* memory mode: chain4, ext. memory */
-		vga_wseq (regbase, VGA_SEQ_PLANE_WRITE, 0xff);	/* plane mask: enable writing to all 4 planes */
+		/* memory mode: chain4, ext. memory */
+		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
+		/* plane mask: enable writing to all 4 planes */
+		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
 		offset = var->xres_virtual / 4;
 	}
 
@@ -1423,64 +1472,77 @@ static int cirrusfb_set_par_foo (struct 
 	 */
 
 	else if (var->bits_per_pixel == 32) {
-		DPRINTK ("cirrusfb: preparing for 24/32 bit deep display\n");
+		DPRINTK("cirrusfb: preparing for 24/32 bit deep display\n");
 		switch (cinfo->btype) {
 		case BT_SD64:
-			vga_wseq (regbase, CL_SEQR7, 0xf9);	/* Extended Sequencer Mode: 256c col. mode */
-			vga_wseq (regbase, CL_SEQR1F, 0x1e);		/* MCLK select */
+			/* Extended Sequencer Mode: 256c col. mode */
+			vga_wseq(regbase, CL_SEQR7, 0xf9);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x1e);
 			break;
 
 		case BT_PICCOLO:
-			vga_wseq (regbase, CL_SEQR7, 0x85);
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* MCLK select */
+			vga_wseq(regbase, CL_SEQR7, 0x85);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_PICASSO:
-			vga_wseq (regbase, CL_SEQR7, 0x25);
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* MCLK select */
+			vga_wseq(regbase, CL_SEQR7, 0x25);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_SPECTRUM:
-			vga_wseq (regbase, CL_SEQR7, 0x85);
-			vga_wseq (regbase, CL_SEQRF, 0xb0);	/* Fast Page-Mode writes */
-			vga_wseq (regbase, CL_SEQR1F, 0x22);		/* MCLK select */
+			vga_wseq(regbase, CL_SEQR7, 0x85);
+			/* Fast Page-Mode writes */
+			vga_wseq(regbase, CL_SEQRF, 0xb0);
+			/* MCLK select */
+			vga_wseq(regbase, CL_SEQR1F, 0x22);
 			break;
 
 		case BT_PICASSO4:
-			vga_wseq (regbase, CL_SEQR7, 0x25);
-/*          vga_wseq (regbase, CL_SEQR1F, 0x1c);  */
+			vga_wseq(regbase, CL_SEQR7, 0x25);
+/*			vga_wseq(regbase, CL_SEQR1F, 0x1c);  */
 			break;
 
 		case BT_ALPINE:
-			DPRINTK (" (for GD543x)\n");
-			vga_wseq (regbase, CL_SEQR7, 0xa9);
-			cirrusfb_set_mclk (cinfo, regs.mclk, regs.divMCLK);
+			DPRINTK(" (for GD543x)\n");
+			vga_wseq(regbase, CL_SEQR7, 0xa9);
+			cirrusfb_set_mclk(cinfo, regs.mclk, regs.divMCLK);
 			break;
 
 		case BT_GD5480:
-			DPRINTK (" (for GD5480)\n");
-			vga_wseq (regbase, CL_SEQR7, 0x19);
+			DPRINTK(" (for GD5480)\n");
+			vga_wseq(regbase, CL_SEQR7, 0x19);
 			/* We already set SRF and SR1F */
 			break;
 
 		case BT_LAGUNA:
-			DPRINTK (" (for GD546x)\n");
-			vga_wseq (regbase, CL_SEQR7,
-				vga_rseq (regbase, CL_SEQR7) & ~0x01);
+			DPRINTK(" (for GD546x)\n");
+			vga_wseq(regbase, CL_SEQR7,
+				vga_rseq(regbase, CL_SEQR7) & ~0x01);
 			break;
 
 		default:
-			printk (KERN_WARNING "cirrusfb: unknown Board\n");
+			printk(KERN_WARNING "cirrusfb: unknown Board\n");
 			break;
 		}
 
-		vga_wgfx (regbase, VGA_GFX_MODE, 64);	/* mode register: 256 color mode */
-		WGen (cinfo, VGA_PEL_MSK, 0xff);	/* pixel mask: pass-through all planes */
-		WHDR (cinfo, 0xc5);	/* hidden dac reg: 8-8-8 mode (24 or 32) */
-		vga_wseq (regbase, VGA_SEQ_MEMORY_MODE, 0x0a);	/* memory mode: chain4, ext. memory */
-		vga_wseq (regbase, VGA_SEQ_PLANE_WRITE, 0xff);	/* plane mask: enable writing to all 4 planes */
+		/* mode register: 256 color mode */
+		vga_wgfx(regbase, VGA_GFX_MODE, 64);
+		/* pixel mask: pass-through all planes */
+		WGen(cinfo, VGA_PEL_MSK, 0xff);
+		/* hidden dac reg: 8-8-8 mode (24 or 32) */
+		WHDR(cinfo, 0xc5);
+		/* memory mode: chain4, ext. memory */
+		vga_wseq(regbase, VGA_SEQ_MEMORY_MODE, 0x0a);
+		/* plane mask: enable writing to all 4 planes */
+		vga_wseq(regbase, VGA_SEQ_PLANE_WRITE, 0xff);
 		offset = var->xres_virtual / 4;
 	}
 
@@ -1490,48 +1552,67 @@ static int cirrusfb_set_par_foo (struct 
 	 *
 	 */
 
-	else {
-		printk (KERN_ERR "cirrusfb: What's this?? requested color depth == %d.\n",
+	else
+		printk(KERN_ERR "cirrusfb: What's this?? "
+			" requested color depth == %d.\n",
 			var->bits_per_pixel);
-	}
 
-	vga_wcrt (regbase, VGA_CRTC_OFFSET, offset & 0xff);
+	vga_wcrt(regbase, VGA_CRTC_OFFSET, offset & 0xff);
 	tmp = 0x22;
 	if (offset & 0x100)
 		tmp |= 0x10;	/* offset overflow bit */
 
-	vga_wcrt (regbase, CL_CRT1B, tmp);	/* screen start addr #16-18, fastpagemode cycles */
+	/* screen start addr #16-18, fastpagemode cycles */
+	vga_wcrt(regbase, CL_CRT1B, tmp);
 
 	if (cinfo->btype == BT_SD64 ||
 	    cinfo->btype == BT_PICASSO4 ||
 	    cinfo->btype == BT_ALPINE ||
 	    cinfo->btype == BT_GD5480)
-		vga_wcrt (regbase, CL_CRT1D, 0x00);	/* screen start address bit 19 */
+		/* screen start address bit 19 */
+		vga_wcrt(regbase, CL_CRT1D, 0x00);
 
-	vga_wcrt (regbase, VGA_CRTC_CURSOR_HI, 0);	/* text cursor location high */
-	vga_wcrt (regbase, VGA_CRTC_CURSOR_LO, 0);	/* text cursor location low */
-	vga_wcrt (regbase, VGA_CRTC_UNDERLINE, 0);	/* underline row scanline = at very bottom */
-
-	vga_wattr (regbase, VGA_ATC_MODE, 1);	/* controller mode */
-	vga_wattr (regbase, VGA_ATC_OVERSCAN, 0);		/* overscan (border) color */
-	vga_wattr (regbase, VGA_ATC_PLANE_ENABLE, 15);	/* color plane enable */
-	vga_wattr (regbase, CL_AR33, 0);	/* pixel panning */
-	vga_wattr (regbase, VGA_ATC_COLOR_PAGE, 0);	/* color select */
+	/* text cursor location high */
+	vga_wcrt(regbase, VGA_CRTC_CURSOR_HI, 0);
+	/* text cursor location low */
+	vga_wcrt(regbase, VGA_CRTC_CURSOR_LO, 0);
+	/* underline row scanline = at very bottom */
+	vga_wcrt(regbase, VGA_CRTC_UNDERLINE, 0);
+
+	/* controller mode */
+	vga_wattr(regbase, VGA_ATC_MODE, 1);
+	/* overscan (border) color */
+	vga_wattr(regbase, VGA_ATC_OVERSCAN, 0);
+	/* color plane enable */
+	vga_wattr(regbase, VGA_ATC_PLANE_ENABLE, 15);
+	/* pixel panning */
+	vga_wattr(regbase, CL_AR33, 0);
+	/* color select */
+	vga_wattr(regbase, VGA_ATC_COLOR_PAGE, 0);
 
 	/* [ EGS: SetOffset(); ] */
 	/* From SetOffset(): Turn on VideoEnable bit in Attribute controller */
-	AttrOn (cinfo);
+	AttrOn(cinfo);
 
-	vga_wgfx (regbase, VGA_GFX_SR_VALUE, 0);	/* set/reset register */
-	vga_wgfx (regbase, VGA_GFX_SR_ENABLE, 0);		/* set/reset enable */
-	vga_wgfx (regbase, VGA_GFX_COMPARE_VALUE, 0);	/* color compare */
-	vga_wgfx (regbase, VGA_GFX_DATA_ROTATE, 0);	/* data rotate */
-	vga_wgfx (regbase, VGA_GFX_PLANE_READ, 0);	/* read map select */
-	vga_wgfx (regbase, VGA_GFX_MISC, 1);	/* miscellaneous register */
-	vga_wgfx (regbase, VGA_GFX_COMPARE_MASK, 15);	/* color don't care */
-	vga_wgfx (regbase, VGA_GFX_BIT_MASK, 255);	/* bit mask */
+	/* set/reset register */
+	vga_wgfx(regbase, VGA_GFX_SR_VALUE, 0);
+	/* set/reset enable */
+	vga_wgfx(regbase, VGA_GFX_SR_ENABLE, 0);
+	/* color compare */
+	vga_wgfx(regbase, VGA_GFX_COMPARE_VALUE, 0);
+	/* data rotate */
+	vga_wgfx(regbase, VGA_GFX_DATA_ROTATE, 0);
+	/* read map select */
+	vga_wgfx(regbase, VGA_GFX_PLANE_READ, 0);
+	/* miscellaneous register */
+	vga_wgfx(regbase, VGA_GFX_MISC, 1);
+	/* color don't care */
+	vga_wgfx(regbase, VGA_GFX_COMPARE_MASK, 15);
+	/* bit mask */
+	vga_wgfx(regbase, VGA_GFX_BIT_MASK, 255);
 
-	vga_wseq (regbase, CL_SEQR12, 0x0);	/* graphics cursor attributes: nothing special */
+	/* graphics cursor attributes: nothing special */
+	vga_wseq(regbase, CL_SEQR12, 0x0);
 
 	/* finally, turn on everything - turn off "FullBandwidth" bit */
 	/* also, set "DotClock%2" bit where requested */
@@ -1542,8 +1623,8 @@ static int cirrusfb_set_par_foo (struct 
 	tmp |= 0x08;
 */
 
-	vga_wseq (regbase, VGA_SEQ_CLOCK_MODE, tmp);
-	DPRINTK ("CL_SEQR1: %d\n", tmp);
+	vga_wseq(regbase, VGA_SEQ_CLOCK_MODE, tmp);
+	DPRINTK("CL_SEQR1: %d\n", tmp);
 
 	cinfo->currentmode = regs;
 	info->fix.type = regs.type;
@@ -1551,27 +1632,27 @@ static int cirrusfb_set_par_foo (struct 
 	info->fix.line_length = regs.line_length;
 
 	/* pan to requested offset */
-	cirrusfb_pan_display (var, info);
+	cirrusfb_pan_display(var, info);
 
 #ifdef CIRRUSFB_DEBUG
-	cirrusfb_dump ();
+	cirrusfb_dump();
 #endif
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 	return 0;
 }
 
 /* for some reason incomprehensible to me, cirrusfb requires that you write
  * the registers twice for the settings to take..grr. -dte */
-static int cirrusfb_set_par (struct fb_info *info)
+static int cirrusfb_set_par(struct fb_info *info)
 {
-	cirrusfb_set_par_foo (info);
-	return cirrusfb_set_par_foo (info);
+	cirrusfb_set_par_foo(info);
+	return cirrusfb_set_par_foo(info);
 }
 
-static int cirrusfb_setcolreg (unsigned regno, unsigned red, unsigned green,
-			       unsigned blue, unsigned transp,
-			       struct fb_info *info)
+static int cirrusfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			      unsigned blue, unsigned transp,
+			      struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
 
@@ -1584,23 +1665,23 @@ static int cirrusfb_setcolreg (unsigned 
 		green >>= (16 - info->var.green.length);
 		blue >>= (16 - info->var.blue.length);
 
-		if (regno>=16)
+		if (regno >= 16)
 			return 1;
 		v = (red << info->var.red.offset) |
 		    (green << info->var.green.offset) |
 		    (blue << info->var.blue.offset);
 
 		switch (info->var.bits_per_pixel) {
-			case 8:
-				cinfo->pseudo_palette[regno] = v;
-				break;
-			case 16:
-				cinfo->pseudo_palette[regno] = v;
-				break;
-			case 24:
-			case 32:
-				cinfo->pseudo_palette[regno] = v;
-				break;
+		case 8:
+			cinfo->pseudo_palette[regno] = v;
+			break;
+		case 16:
+			cinfo->pseudo_palette[regno] = v;
+			break;
+		case 24:
+		case 32:
+			cinfo->pseudo_palette[regno] = v;
+			break;
 		}
 		return 0;
 	}
@@ -1609,9 +1690,8 @@ static int cirrusfb_setcolreg (unsigned 
 	cinfo->palette[regno].green = green;
 	cinfo->palette[regno].blue = blue;
 
-	if (info->var.bits_per_pixel == 8) {
-			WClut (cinfo, regno, red >> 10, green >> 10, blue >> 10);
-	}
+	if (info->var.bits_per_pixel == 8)
+		WClut(cinfo, regno, red >> 10, green >> 10, blue >> 10);
 
 	return 0;
 
@@ -1622,8 +1702,8 @@ static int cirrusfb_setcolreg (unsigned 
 
 	performs display panning - provided hardware permits this
 **************************************************************************/
-static int cirrusfb_pan_display (struct fb_var_screeninfo *var,
-				 struct fb_info *info)
+static int cirrusfb_pan_display(struct fb_var_screeninfo *var,
+				struct fb_info *info)
 {
 	int xoffset = 0;
 	int yoffset = 0;
@@ -1631,8 +1711,8 @@ static int cirrusfb_pan_display (struct 
 	unsigned char tmp = 0, tmp2 = 0, xpix;
 	struct cirrusfb_info *cinfo = info->par;
 
-	DPRINTK ("ENTER\n");
-	DPRINTK ("virtual offset: (%d,%d)\n", var->xoffset, var->yoffset);
+	DPRINTK("ENTER\n");
+	DPRINTK("virtual offset: (%d,%d)\n", var->xoffset, var->yoffset);
 
 	/* no range checks for xoffset and yoffset,   */
 	/* as fb_pan_display has already done this */
@@ -1655,11 +1735,13 @@ static int cirrusfb_pan_display (struct 
 		xpix = (unsigned char) ((xoffset % 4) * 2);
 	}
 
-        cirrusfb_WaitBLT(cinfo->regbase); /* make sure all the BLT's are done */
+	cirrusfb_WaitBLT(cinfo->regbase); /* make sure all the BLT's are done */
 
 	/* lower 8 + 8 bits of screen start address */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_START_LO, (unsigned char) (base & 0xff));
-	vga_wcrt (cinfo->regbase, VGA_CRTC_START_HI, (unsigned char) (base >> 8));
+	vga_wcrt(cinfo->regbase, VGA_CRTC_START_LO,
+		 (unsigned char) (base & 0xff));
+	vga_wcrt(cinfo->regbase, VGA_CRTC_START_HI,
+		 (unsigned char) (base >> 8));
 
 	/* construct bits 16, 17 and 18 of screen start address */
 	if (base & 0x10000)
@@ -1669,50 +1751,53 @@ static int cirrusfb_pan_display (struct 
 	if (base & 0x40000)
 		tmp |= 0x08;
 
-	tmp2 = (vga_rcrt (cinfo->regbase, CL_CRT1B) & 0xf2) | tmp;	/* 0xf2 is %11110010, exclude tmp bits */
-	vga_wcrt (cinfo->regbase, CL_CRT1B, tmp2);
+	/* 0xf2 is %11110010, exclude tmp bits */
+	tmp2 = (vga_rcrt(cinfo->regbase, CL_CRT1B) & 0xf2) | tmp;
+	vga_wcrt(cinfo->regbase, CL_CRT1B, tmp2);
 
 	/* construct bit 19 of screen start address */
 	if (cirrusfb_board_info[cinfo->btype].scrn_start_bit19) {
 		tmp2 = 0;
 		if (base & 0x80000)
 			tmp2 = 0x80;
-		vga_wcrt (cinfo->regbase, CL_CRT1D, tmp2);
+		vga_wcrt(cinfo->regbase, CL_CRT1D, tmp2);
 	}
 
-	/* write pixel panning value to AR33; this does not quite work in 8bpp */
-	/* ### Piccolo..? Will this work? */
+	/* write pixel panning value to AR33; this does not quite work in 8bpp
+	 *
+	 * ### Piccolo..? Will this work?
+	 */
 	if (info->var.bits_per_pixel == 1)
-		vga_wattr (cinfo->regbase, CL_AR33, xpix);
+		vga_wattr(cinfo->regbase, CL_AR33, xpix);
 
-	cirrusfb_WaitBLT (cinfo->regbase);
+	cirrusfb_WaitBLT(cinfo->regbase);
 
-	DPRINTK ("EXIT\n");
-	return (0);
+	DPRINTK("EXIT\n");
+	return 0;
 }
 
-
-static int cirrusfb_blank (int blank_mode, struct fb_info *info)
+static int cirrusfb_blank(int blank_mode, struct fb_info *info)
 {
 	/*
-	 *  Blank the screen if blank_mode != 0, else unblank. If blank == NULL
-	 *  then the caller blanks by setting the CLUT (Color Look Up Table) to all
-	 *  black. Return 0 if blanking succeeded, != 0 if un-/blanking failed due
-	 *  to e.g. a video mode which doesn't support it. Implements VESA suspend
-	 *  and powerdown modes on hardware that supports disabling hsync/vsync:
-	 *    blank_mode == 2: suspend vsync
-	 *    blank_mode == 3: suspend hsync
-	 *    blank_mode == 4: powerdown
+	 * Blank the screen if blank_mode != 0, else unblank. If blank == NULL
+	 * then the caller blanks by setting the CLUT (Color Look Up Table)
+	 * to all black. Return 0 if blanking succeeded, != 0 if un-/blanking
+	 * failed due to e.g. a video mode which doesn't support it.
+	 * Implements VESA suspend and powerdown modes on hardware that
+	 * supports disabling hsync/vsync:
+	 *   blank_mode == 2: suspend vsync
+	 *   blank_mode == 3: suspend hsync
+	 *   blank_mode == 4: powerdown
 	 */
 	unsigned char val;
 	struct cirrusfb_info *cinfo = info->par;
 	int current_mode = cinfo->blank_mode;
 
-	DPRINTK ("ENTER, blank mode = %d\n", blank_mode);
+	DPRINTK("ENTER, blank mode = %d\n", blank_mode);
 
 	if (info->state != FBINFO_STATE_RUNNING ||
 	    current_mode == blank_mode) {
-		DPRINTK ("EXIT, returning 0\n");
+		DPRINTK("EXIT, returning 0\n");
 		return 0;
 	}
 
@@ -1720,17 +1805,19 @@ static int cirrusfb_blank (int blank_mod
 	if (current_mode == FB_BLANK_NORMAL ||
 	    current_mode == FB_BLANK_UNBLANK) {
 		/* unblank the screen */
-		val = vga_rseq (cinfo->regbase, VGA_SEQ_CLOCK_MODE);
-		vga_wseq (cinfo->regbase, VGA_SEQ_CLOCK_MODE, val & 0xdf);	/* clear "FullBandwidth" bit */
+		val = vga_rseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE);
+		/* clear "FullBandwidth" bit */
+		vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, val & 0xdf);
 		/* and undo VESA suspend trickery */
-		vga_wgfx (cinfo->regbase, CL_GRE, 0x00);
+		vga_wgfx(cinfo->regbase, CL_GRE, 0x00);
 	}
 
 	/* set new */
-	if(blank_mode > FB_BLANK_NORMAL) {
+	if (blank_mode > FB_BLANK_NORMAL) {
 		/* blank the screen */
-		val = vga_rseq (cinfo->regbase, VGA_SEQ_CLOCK_MODE);
-		vga_wseq (cinfo->regbase, VGA_SEQ_CLOCK_MODE, val | 0x20);	/* set "FullBandwidth" bit */
+		val = vga_rseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE);
+		/* set "FullBandwidth" bit */
+		vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, val | 0x20);
 	}
 
 	switch (blank_mode) {
@@ -1738,21 +1825,21 @@ static int cirrusfb_blank (int blank_mod
 	case FB_BLANK_NORMAL:
 		break;
 	case FB_BLANK_VSYNC_SUSPEND:
-		vga_wgfx (cinfo->regbase, CL_GRE, 0x04);
+		vga_wgfx(cinfo->regbase, CL_GRE, 0x04);
 		break;
 	case FB_BLANK_HSYNC_SUSPEND:
-		vga_wgfx (cinfo->regbase, CL_GRE, 0x02);
+		vga_wgfx(cinfo->regbase, CL_GRE, 0x02);
 		break;
 	case FB_BLANK_POWERDOWN:
-		vga_wgfx (cinfo->regbase, CL_GRE, 0x06);
+		vga_wgfx(cinfo->regbase, CL_GRE, 0x06);
 		break;
 	default:
-		DPRINTK ("EXIT, returning 1\n");
+		DPRINTK("EXIT, returning 1\n");
 		return 1;
 	}
 
 	cinfo->blank_mode = blank_mode;
-	DPRINTK ("EXIT, returning 0\n");
+	DPRINTK("EXIT, returning 0\n");
 
 	/* Let fbcon do a soft blank for us */
 	return (blank_mode == FB_BLANK_NORMAL) ? 1 : 0;
@@ -1761,45 +1848,50 @@ static int cirrusfb_blank (int blank_mod
 /****************************************************************************/
 /**** BEGIN Internal Routines ***********************************************/
 
-static void init_vgachip (struct cirrusfb_info *cinfo)
+static void init_vgachip(struct cirrusfb_info *cinfo)
 {
 	const struct cirrusfb_board_info_rec *bi;
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
-	assert (cinfo != NULL);
+	assert(cinfo != NULL);
 
 	bi = &cirrusfb_board_info[cinfo->btype];
 
 	/* reset board globally */
 	switch (cinfo->btype) {
 	case BT_PICCOLO:
-		WSFR (cinfo, 0x01);
-		udelay (500);
-		WSFR (cinfo, 0x51);
-		udelay (500);
+		WSFR(cinfo, 0x01);
+		udelay(500);
+		WSFR(cinfo, 0x51);
+		udelay(500);
 		break;
 	case BT_PICASSO:
-		WSFR2 (cinfo, 0xff);
-		udelay (500);
+		WSFR2(cinfo, 0xff);
+		udelay(500);
 		break;
 	case BT_SD64:
 	case BT_SPECTRUM:
-		WSFR (cinfo, 0x1f);
-		udelay (500);
-		WSFR (cinfo, 0x4f);
-		udelay (500);
+		WSFR(cinfo, 0x1f);
+		udelay(500);
+		WSFR(cinfo, 0x4f);
+		udelay(500);
 		break;
 	case BT_PICASSO4:
-		vga_wcrt (cinfo->regbase, CL_CRT51, 0x00);	/* disable flickerfixer */
-		mdelay (100);
-		vga_wgfx (cinfo->regbase, CL_GR2F, 0x00);	/* from Klaus' NetBSD driver: */
-		vga_wgfx (cinfo->regbase, CL_GR33, 0x00);	/* put blitter into 542x compat */
-		vga_wgfx (cinfo->regbase, CL_GR31, 0x00);	/* mode */
+		/* disable flickerfixer */
+		vga_wcrt(cinfo->regbase, CL_CRT51, 0x00);
+		mdelay(100);
+		/* from Klaus' NetBSD driver: */
+		vga_wgfx(cinfo->regbase, CL_GR2F, 0x00);
+		/* put blitter into 542x compat */
+		vga_wgfx(cinfo->regbase, CL_GR33, 0x00);
+		/* mode */
+		vga_wgfx(cinfo->regbase, CL_GR31, 0x00);
 		break;
 
 	case BT_GD5480:
-		vga_wgfx (cinfo->regbase, CL_GR2F, 0x00);	/* from Klaus' NetBSD driver: */
+		/* from Klaus' NetBSD driver: */
+		vga_wgfx(cinfo->regbase, CL_GR2F, 0x00);
 		break;
 
 	case BT_ALPINE:
@@ -1807,153 +1899,207 @@ static void init_vgachip (struct cirrusf
 		break;
 
 	default:
-		printk (KERN_ERR "cirrusfb: Warning: Unknown board type\n");
+		printk(KERN_ERR "cirrusfb: Warning: Unknown board type\n");
 		break;
 	}
 
-	assert (cinfo->size > 0); /* make sure RAM size set by this point */
+	assert(cinfo->size > 0); /* make sure RAM size set by this point */
 
 	/* the P4 is not fully initialized here; I rely on it having been */
 	/* inited under AmigaOS already, which seems to work just fine    */
-	/* (Klaus advised to do it this way)                              */
+	/* (Klaus advised to do it this way)			      */
 
 	if (cinfo->btype != BT_PICASSO4) {
-		WGen (cinfo, CL_VSSM, 0x10);	/* EGS: 0x16 */
-		WGen (cinfo, CL_POS102, 0x01);
-		WGen (cinfo, CL_VSSM, 0x08);	/* EGS: 0x0e */
+		WGen(cinfo, CL_VSSM, 0x10);	/* EGS: 0x16 */
+		WGen(cinfo, CL_POS102, 0x01);
+		WGen(cinfo, CL_VSSM, 0x08);	/* EGS: 0x0e */
 
 		if (cinfo->btype != BT_SD64)
-			WGen (cinfo, CL_VSSM2, 0x01);
+			WGen(cinfo, CL_VSSM2, 0x01);
 
-		vga_wseq (cinfo->regbase, CL_SEQR0, 0x03);	/* reset sequencer logic */
+		/* reset sequencer logic */
+		vga_wseq(cinfo->regbase, CL_SEQR0, 0x03);
 
-		vga_wseq (cinfo->regbase, VGA_SEQ_CLOCK_MODE, 0x21);	/* FullBandwidth (video off) and 8/9 dot clock */
-		WGen (cinfo, VGA_MIS_W, 0xc1);	/* polarity (-/-), disable access to display memory, VGA_CRTC_START_HI base address: color */
+		/* FullBandwidth (video off) and 8/9 dot clock */
+		vga_wseq(cinfo->regbase, VGA_SEQ_CLOCK_MODE, 0x21);
+		/* polarity (-/-), disable access to display memory,
+		 * VGA_CRTC_START_HI base address: color
+		 */
+		WGen(cinfo, VGA_MIS_W, 0xc1);
 
-/*      vga_wgfx (cinfo->regbase, CL_GRA, 0xce);    "magic cookie" - doesn't make any sense to me.. */
-		vga_wseq (cinfo->regbase, CL_SEQR6, 0x12);	/* unlock all extension registers */
+		/* "magic cookie" - doesn't make any sense to me.. */
+/*      vga_wgfx(cinfo->regbase, CL_GRA, 0xce);   */
+		/* unlock all extension registers */
+		vga_wseq(cinfo->regbase, CL_SEQR6, 0x12);
 
-		vga_wgfx (cinfo->regbase, CL_GR31, 0x04);	/* reset blitter */
+		/* reset blitter */
+		vga_wgfx(cinfo->regbase, CL_GR31, 0x04);
 
 		switch (cinfo->btype) {
 		case BT_GD5480:
-			vga_wseq (cinfo->regbase, CL_SEQRF, 0x98);
+			vga_wseq(cinfo->regbase, CL_SEQRF, 0x98);
 			break;
 		case BT_ALPINE:
 			break;
 		case BT_SD64:
-			vga_wseq (cinfo->regbase, CL_SEQRF, 0xb8);
+			vga_wseq(cinfo->regbase, CL_SEQRF, 0xb8);
 			break;
 		default:
-			vga_wseq (cinfo->regbase, CL_SEQR16, 0x0f);
-			vga_wseq (cinfo->regbase, CL_SEQRF, 0xb0);
+			vga_wseq(cinfo->regbase, CL_SEQR16, 0x0f);
+			vga_wseq(cinfo->regbase, CL_SEQRF, 0xb0);
 			break;
 		}
 	}
-	vga_wseq (cinfo->regbase, VGA_SEQ_PLANE_WRITE, 0xff);	/* plane mask: nothing */
-	vga_wseq (cinfo->regbase, VGA_SEQ_CHARACTER_MAP, 0x00);	/* character map select: doesn't even matter in gx mode */
-	vga_wseq (cinfo->regbase, VGA_SEQ_MEMORY_MODE, 0x0e);	/* memory mode: chain-4, no odd/even, ext. memory */
+	/* plane mask: nothing */
+	vga_wseq(cinfo->regbase, VGA_SEQ_PLANE_WRITE, 0xff);
+	/* character map select: doesn't even matter in gx mode */
+	vga_wseq(cinfo->regbase, VGA_SEQ_CHARACTER_MAP, 0x00);
+	/* memory mode: chain-4, no odd/even, ext. memory */
+	vga_wseq(cinfo->regbase, VGA_SEQ_MEMORY_MODE, 0x0e);
 
 	/* controller-internal base address of video memory */
 	if (bi->init_sr07)
-		vga_wseq (cinfo->regbase, CL_SEQR7, bi->sr07);
+		vga_wseq(cinfo->regbase, CL_SEQR7, bi->sr07);
 
-	/*  vga_wseq (cinfo->regbase, CL_SEQR8, 0x00); *//* EEPROM control: shouldn't be necessary to write to this at all.. */
+	/*  vga_wseq(cinfo->regbase, CL_SEQR8, 0x00); */
+	/* EEPROM control: shouldn't be necessary to write to this at all.. */
 
-	vga_wseq (cinfo->regbase, CL_SEQR10, 0x00);		/* graphics cursor X position (incomplete; position gives rem. 3 bits */
-	vga_wseq (cinfo->regbase, CL_SEQR11, 0x00);		/* graphics cursor Y position (..."... ) */
-	vga_wseq (cinfo->regbase, CL_SEQR12, 0x00);		/* graphics cursor attributes */
-	vga_wseq (cinfo->regbase, CL_SEQR13, 0x00);		/* graphics cursor pattern address */
+	/* graphics cursor X position (incomplete; position gives rem. 3 bits */
+	vga_wseq(cinfo->regbase, CL_SEQR10, 0x00);
+	/* graphics cursor Y position (..."... ) */
+	vga_wseq(cinfo->regbase, CL_SEQR11, 0x00);
+	/* graphics cursor attributes */
+	vga_wseq(cinfo->regbase, CL_SEQR12, 0x00);
+	/* graphics cursor pattern address */
+	vga_wseq(cinfo->regbase, CL_SEQR13, 0x00);
 
 	/* writing these on a P4 might give problems..  */
 	if (cinfo->btype != BT_PICASSO4) {
-		vga_wseq (cinfo->regbase, CL_SEQR17, 0x00);		/* configuration readback and ext. color */
-		vga_wseq (cinfo->regbase, CL_SEQR18, 0x02);		/* signature generator */
+		/* configuration readback and ext. color */
+		vga_wseq(cinfo->regbase, CL_SEQR17, 0x00);
+		/* signature generator */
+		vga_wseq(cinfo->regbase, CL_SEQR18, 0x02);
 	}
 
 	/* MCLK select etc. */
 	if (bi->init_sr1f)
-		vga_wseq (cinfo->regbase, CL_SEQR1F, bi->sr1f);
+		vga_wseq(cinfo->regbase, CL_SEQR1F, bi->sr1f);
 
-	vga_wcrt (cinfo->regbase, VGA_CRTC_PRESET_ROW, 0x00);	/* Screen A preset row scan: none */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_CURSOR_START, 0x20);	/* Text cursor start: disable text cursor */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_CURSOR_END, 0x00);	/* Text cursor end: - */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_START_HI, 0x00);	/* Screen start address high: 0 */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_START_LO, 0x00);	/* Screen start address low: 0 */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_CURSOR_HI, 0x00);	/* text cursor location high: 0 */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_CURSOR_LO, 0x00);	/* text cursor location low: 0 */
-
-	vga_wcrt (cinfo->regbase, VGA_CRTC_UNDERLINE, 0x00);	/* Underline Row scanline: - */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_MODE, 0xc3);	/* mode control: timing enable, byte mode, no compat modes */
-	vga_wcrt (cinfo->regbase, VGA_CRTC_LINE_COMPARE, 0x00);	/* Line Compare: not needed */
+	/* Screen A preset row scan: none */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_PRESET_ROW, 0x00);
+	/* Text cursor start: disable text cursor */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_CURSOR_START, 0x20);
+	/* Text cursor end: - */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_CURSOR_END, 0x00);
+	/* Screen start address high: 0 */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_START_HI, 0x00);
+	/* Screen start address low: 0 */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_START_LO, 0x00);
+	/* text cursor location high: 0 */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_CURSOR_HI, 0x00);
+	/* text cursor location low: 0 */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_CURSOR_LO, 0x00);
+
+	/* Underline Row scanline: - */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_UNDERLINE, 0x00);
+	/* mode control: timing enable, byte mode, no compat modes */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_MODE, 0xc3);
+	/* Line Compare: not needed */
+	vga_wcrt(cinfo->regbase, VGA_CRTC_LINE_COMPARE, 0x00);
 	/* ### add 0x40 for text modes with > 30 MHz pixclock */
-	vga_wcrt (cinfo->regbase, CL_CRT1B, 0x02);	/* ext. display controls: ext.adr. wrap */
+	/* ext. display controls: ext.adr. wrap */
+	vga_wcrt(cinfo->regbase, CL_CRT1B, 0x02);
 
-	vga_wgfx (cinfo->regbase, VGA_GFX_SR_VALUE, 0x00);	/* Set/Reset registes: - */
-	vga_wgfx (cinfo->regbase, VGA_GFX_SR_ENABLE, 0x00);	/* Set/Reset enable: - */
-	vga_wgfx (cinfo->regbase, VGA_GFX_COMPARE_VALUE, 0x00);	/* Color Compare: - */
-	vga_wgfx (cinfo->regbase, VGA_GFX_DATA_ROTATE, 0x00);	/* Data Rotate: - */
-	vga_wgfx (cinfo->regbase, VGA_GFX_PLANE_READ, 0x00);	/* Read Map Select: - */
-	vga_wgfx (cinfo->regbase, VGA_GFX_MODE, 0x00);	/* Mode: conf. for 16/4/2 color mode, no odd/even, read/write mode 0 */
-	vga_wgfx (cinfo->regbase, VGA_GFX_MISC, 0x01);	/* Miscellaneous: memory map base address, graphics mode */
-	vga_wgfx (cinfo->regbase, VGA_GFX_COMPARE_MASK, 0x0f);	/* Color Don't care: involve all planes */
-	vga_wgfx (cinfo->regbase, VGA_GFX_BIT_MASK, 0xff);	/* Bit Mask: no mask at all */
+	/* Set/Reset registes: - */
+	vga_wgfx(cinfo->regbase, VGA_GFX_SR_VALUE, 0x00);
+	/* Set/Reset enable: - */
+	vga_wgfx(cinfo->regbase, VGA_GFX_SR_ENABLE, 0x00);
+	/* Color Compare: - */
+	vga_wgfx(cinfo->regbase, VGA_GFX_COMPARE_VALUE, 0x00);
+	/* Data Rotate: - */
+	vga_wgfx(cinfo->regbase, VGA_GFX_DATA_ROTATE, 0x00);
+	/* Read Map Select: - */
+	vga_wgfx(cinfo->regbase, VGA_GFX_PLANE_READ, 0x00);
+	/* Mode: conf. for 16/4/2 color mode, no odd/even, read/write mode 0 */
+	vga_wgfx(cinfo->regbase, VGA_GFX_MODE, 0x00);
+	/* Miscellaneous: memory map base address, graphics mode */
+	vga_wgfx(cinfo->regbase, VGA_GFX_MISC, 0x01);
+	/* Color Don't care: involve all planes */
+	vga_wgfx(cinfo->regbase, VGA_GFX_COMPARE_MASK, 0x0f);
+	/* Bit Mask: no mask at all */
+	vga_wgfx(cinfo->regbase, VGA_GFX_BIT_MASK, 0xff);
 	if (cinfo->btype == BT_ALPINE)
-		vga_wgfx (cinfo->regbase, CL_GRB, 0x20);	/* (5434 can't have bit 3 set for bitblt) */
+		/* (5434 can't have bit 3 set for bitblt) */
+		vga_wgfx(cinfo->regbase, CL_GRB, 0x20);
 	else
-		vga_wgfx (cinfo->regbase, CL_GRB, 0x28);	/* Graphics controller mode extensions: finer granularity, 8byte data latches */
+	/* Graphics controller mode extensions: finer granularity,
+	 * 8byte data latches
+	 */
+		vga_wgfx(cinfo->regbase, CL_GRB, 0x28);
 
-	vga_wgfx (cinfo->regbase, CL_GRC, 0xff);	/* Color Key compare: - */
-	vga_wgfx (cinfo->regbase, CL_GRD, 0x00);	/* Color Key compare mask: - */
-	vga_wgfx (cinfo->regbase, CL_GRE, 0x00);	/* Miscellaneous control: - */
-	/*  vga_wgfx (cinfo->regbase, CL_GR10, 0x00); *//* Background color byte 1: - */
-/*  vga_wgfx (cinfo->regbase, CL_GR11, 0x00); */
-
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE0, 0x00);	/* Attribute Controller palette registers: "identity mapping" */
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE1, 0x01);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE2, 0x02);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE3, 0x03);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE4, 0x04);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE5, 0x05);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE6, 0x06);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE7, 0x07);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE8, 0x08);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTE9, 0x09);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTEA, 0x0a);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTEB, 0x0b);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTEC, 0x0c);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTED, 0x0d);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTEE, 0x0e);
-	vga_wattr (cinfo->regbase, VGA_ATC_PALETTEF, 0x0f);
-
-	vga_wattr (cinfo->regbase, VGA_ATC_MODE, 0x01);	/* Attribute Controller mode: graphics mode */
-	vga_wattr (cinfo->regbase, VGA_ATC_OVERSCAN, 0x00);	/* Overscan color reg.: reg. 0 */
-	vga_wattr (cinfo->regbase, VGA_ATC_PLANE_ENABLE, 0x0f);	/* Color Plane enable: Enable all 4 planes */
-/* ###  vga_wattr (cinfo->regbase, CL_AR33, 0x00); * Pixel Panning: - */
-	vga_wattr (cinfo->regbase, VGA_ATC_COLOR_PAGE, 0x00);	/* Color Select: - */
+	vga_wgfx(cinfo->regbase, CL_GRC, 0xff);	/* Color Key compare: - */
+	vga_wgfx(cinfo->regbase, CL_GRD, 0x00);	/* Color Key compare mask: - */
+	vga_wgfx(cinfo->regbase, CL_GRE, 0x00);	/* Miscellaneous control: - */
+	/* Background color byte 1: - */
+	/*  vga_wgfx (cinfo->regbase, CL_GR10, 0x00); */
+	/*  vga_wgfx (cinfo->regbase, CL_GR11, 0x00); */
+
+	/* Attribute Controller palette registers: "identity mapping" */
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE0, 0x00);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE1, 0x01);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE2, 0x02);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE3, 0x03);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE4, 0x04);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE5, 0x05);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE6, 0x06);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE7, 0x07);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE8, 0x08);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTE9, 0x09);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTEA, 0x0a);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTEB, 0x0b);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTEC, 0x0c);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTED, 0x0d);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTEE, 0x0e);
+	vga_wattr(cinfo->regbase, VGA_ATC_PALETTEF, 0x0f);
+
+	/* Attribute Controller mode: graphics mode */
+	vga_wattr(cinfo->regbase, VGA_ATC_MODE, 0x01);
+	/* Overscan color reg.: reg. 0 */
+	vga_wattr(cinfo->regbase, VGA_ATC_OVERSCAN, 0x00);
+	/* Color Plane enable: Enable all 4 planes */
+	vga_wattr(cinfo->regbase, VGA_ATC_PLANE_ENABLE, 0x0f);
+/* ###  vga_wattr(cinfo->regbase, CL_AR33, 0x00); * Pixel Panning: - */
+	/* Color Select: - */
+	vga_wattr(cinfo->regbase, VGA_ATC_COLOR_PAGE, 0x00);
 
-	WGen (cinfo, VGA_PEL_MSK, 0xff);	/* Pixel mask: no mask */
+	WGen(cinfo, VGA_PEL_MSK, 0xff);	/* Pixel mask: no mask */
 
 	if (cinfo->btype != BT_ALPINE && cinfo->btype != BT_GD5480)
-		WGen (cinfo, VGA_MIS_W, 0xc3);	/* polarity (-/-), enable display mem, VGA_CRTC_START_HI i/o base = color */
+	/* polarity (-/-), enable display mem,
+	 * VGA_CRTC_START_HI i/o base = color
+	 */
+		WGen(cinfo, VGA_MIS_W, 0xc3);
 
-	vga_wgfx (cinfo->regbase, CL_GR31, 0x04);	/* BLT Start/status: Blitter reset */
-	vga_wgfx (cinfo->regbase, CL_GR31, 0x00);	/* - " -           : "end-of-reset" */
+	/* BLT Start/status: Blitter reset */
+	vga_wgfx(cinfo->regbase, CL_GR31, 0x04);
+	/* - " -	   : "end-of-reset" */
+	vga_wgfx(cinfo->regbase, CL_GR31, 0x00);
 
 	/* misc... */
-	WHDR (cinfo, 0);	/* Hidden DAC register: - */
+	WHDR(cinfo, 0);	/* Hidden DAC register: - */
 
-	printk (KERN_DEBUG "cirrusfb: This board has %ld bytes of DRAM memory\n", cinfo->size);
-	DPRINTK ("EXIT\n");
+	printk(KERN_DEBUG "cirrusfb: This board has %ld bytes of DRAM memory\n",
+		cinfo->size);
+	DPRINTK("EXIT\n");
 	return;
 }
 
-static void switch_monitor (struct cirrusfb_info *cinfo, int on)
+static void switch_monitor(struct cirrusfb_info *cinfo, int on)
 {
 #ifdef CONFIG_ZORRO /* only works on Zorro boards */
 	static int IsOn = 0;	/* XXX not ok for multiple boards */
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
 	if (cinfo->btype == BT_PICASSO4)
 		return;		/* nothing to switch */
@@ -1963,44 +2109,43 @@ static void switch_monitor (struct cirru
 		return;		/* nothing to switch */
 	if (cinfo->btype == BT_PICASSO) {
 		if ((on && !IsOn) || (!on && IsOn))
-			WSFR (cinfo, 0xff);
+			WSFR(cinfo, 0xff);
 
-		DPRINTK ("EXIT\n");
+		DPRINTK("EXIT\n");
 		return;
 	}
 	if (on) {
 		switch (cinfo->btype) {
 		case BT_SD64:
-			WSFR (cinfo, cinfo->SFR | 0x21);
+			WSFR(cinfo, cinfo->SFR | 0x21);
 			break;
 		case BT_PICCOLO:
-			WSFR (cinfo, cinfo->SFR | 0x28);
+			WSFR(cinfo, cinfo->SFR | 0x28);
 			break;
 		case BT_SPECTRUM:
-			WSFR (cinfo, 0x6f);
+			WSFR(cinfo, 0x6f);
 			break;
 		default: /* do nothing */ break;
 		}
 	} else {
 		switch (cinfo->btype) {
 		case BT_SD64:
-			WSFR (cinfo, cinfo->SFR & 0xde);
+			WSFR(cinfo, cinfo->SFR & 0xde);
 			break;
 		case BT_PICCOLO:
-			WSFR (cinfo, cinfo->SFR & 0xd7);
+			WSFR(cinfo, cinfo->SFR & 0xd7);
 			break;
 		case BT_SPECTRUM:
-			WSFR (cinfo, 0x4f);
+			WSFR(cinfo, 0x4f);
 			break;
 		default: /* do nothing */ break;
 		}
 	}
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 #endif /* CONFIG_ZORRO */
 }
 
-
 /******************************************/
 /* Linux 2.6-style  accelerated functions */
 /******************************************/
@@ -2012,15 +2157,17 @@ static void cirrusfb_prim_fillrect(struc
 	u32 color = (cinfo->info->fix.visual == FB_VISUAL_TRUECOLOR) ?
 		cinfo->pseudo_palette[region->color] : region->color;
 
-	if(cinfo->info->var.bits_per_pixel == 1) {
-		cirrusfb_RectFill(cinfo->regbase, cinfo->info->var.bits_per_pixel,
+	if (cinfo->info->var.bits_per_pixel == 1) {
+		cirrusfb_RectFill(cinfo->regbase,
+				  cinfo->info->var.bits_per_pixel,
 				  region->dx / 8, region->dy,
 				  region->width / 8, region->height,
 				  color,
 				  cinfo->currentmode.line_length);
 	} else {
-		m = ( cinfo->info->var.bits_per_pixel + 7 ) / 8;
-		cirrusfb_RectFill(cinfo->regbase, cinfo->info->var.bits_per_pixel,
+		m = (cinfo->info->var.bits_per_pixel + 7) / 8;
+		cirrusfb_RectFill(cinfo->regbase,
+				  cinfo->info->var.bits_per_pixel,
 				  region->dx * m, region->dy,
 				  region->width * m, region->height,
 				  color,
@@ -2029,7 +2176,8 @@ static void cirrusfb_prim_fillrect(struc
 	return;
 }
 
-static void cirrusfb_fillrect (struct fb_info *info, const struct fb_fillrect *region)
+static void cirrusfb_fillrect(struct fb_info *info,
+			      const struct fb_fillrect *region)
 {
 	struct cirrusfb_info *cinfo = info->par;
 	struct fb_fillrect modded;
@@ -2047,12 +2195,14 @@ static void cirrusfb_fillrect (struct fb
 
 	memcpy(&modded, region, sizeof(struct fb_fillrect));
 
-	if(!modded.width || !modded.height ||
+	if (!modded.width || !modded.height ||
 	   modded.dx >= vxres || modded.dy >= vyres)
 		return;
 
-	if(modded.dx + modded.width  > vxres) modded.width  = vxres - modded.dx;
-	if(modded.dy + modded.height > vyres) modded.height = vyres - modded.dy;
+	if (modded.dx + modded.width  > vxres)
+		modded.width  = vxres - modded.dx;
+	if (modded.dy + modded.height > vyres)
+		modded.height = vyres - modded.dy;
 
 	cirrusfb_prim_fillrect(cinfo, &modded);
 }
@@ -2061,14 +2211,14 @@ static void cirrusfb_prim_copyarea(struc
 				   const struct fb_copyarea *area)
 {
 	int m; /* bytes per pixel */
-	if(cinfo->info->var.bits_per_pixel == 1) {
+	if (cinfo->info->var.bits_per_pixel == 1) {
 		cirrusfb_BitBLT(cinfo->regbase, cinfo->info->var.bits_per_pixel,
 				area->sx / 8, area->sy,
 				area->dx / 8, area->dy,
 				area->width / 8, area->height,
 				cinfo->currentmode.line_length);
 	} else {
-		m = ( cinfo->info->var.bits_per_pixel + 7 ) / 8;
+		m = (cinfo->info->var.bits_per_pixel + 7) / 8;
 		cirrusfb_BitBLT(cinfo->regbase, cinfo->info->var.bits_per_pixel,
 				area->sx * m, area->sy,
 				area->dx * m, area->dy,
@@ -2078,8 +2228,8 @@ static void cirrusfb_prim_copyarea(struc
 	return;
 }
 
-
-static void cirrusfb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
+static void cirrusfb_copyarea(struct fb_info *info,
+			      const struct fb_copyarea *area)
 {
 	struct cirrusfb_info *cinfo = info->par;
 	struct fb_copyarea modded;
@@ -2101,89 +2251,99 @@ static void cirrusfb_copyarea(struct fb_
 	vxres = info->var.xres_virtual;
 	vyres = info->var.yres_virtual;
 
-	if(!modded.width || !modded.height ||
+	if (!modded.width || !modded.height ||
 	   modded.sx >= vxres || modded.sy >= vyres ||
 	   modded.dx >= vxres || modded.dy >= vyres)
 		return;
 
-	if(modded.sx + modded.width > vxres)  modded.width = vxres - modded.sx;
-	if(modded.dx + modded.width > vxres)  modded.width = vxres - modded.dx;
-	if(modded.sy + modded.height > vyres) modded.height = vyres - modded.sy;
-	if(modded.dy + modded.height > vyres) modded.height = vyres - modded.dy;
+	if (modded.sx + modded.width > vxres)
+		modded.width = vxres - modded.sx;
+	if (modded.dx + modded.width > vxres)
+		modded.width = vxres - modded.dx;
+	if (modded.sy + modded.height > vyres)
+		modded.height = vyres - modded.sy;
+	if (modded.dy + modded.height > vyres)
+		modded.height = vyres - modded.dy;
 
 	cirrusfb_prim_copyarea(cinfo, &modded);
 }
 
-static void cirrusfb_imageblit(struct fb_info *info, const struct fb_image *image)
+static void cirrusfb_imageblit(struct fb_info *info,
+			       const struct fb_image *image)
 {
 	struct cirrusfb_info *cinfo = info->par;
 
-        cirrusfb_WaitBLT(cinfo->regbase);
+	cirrusfb_WaitBLT(cinfo->regbase);
 	cfb_imageblit(info, image);
 }
 
-
 #ifdef CONFIG_PPC_PREP
 #define PREP_VIDEO_BASE ((volatile unsigned long) 0xC0000000)
 #define PREP_IO_BASE    ((volatile unsigned char *) 0x80000000)
-static void get_prep_addrs (unsigned long *display, unsigned long *registers)
+static void get_prep_addrs(unsigned long *display, unsigned long *registers)
 {
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
 	*display = PREP_VIDEO_BASE;
 	*registers = (unsigned long) PREP_IO_BASE;
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
 #endif				/* CONFIG_PPC_PREP */
 
-
 #ifdef CONFIG_PCI
-static int release_io_ports = 0;
+static int release_io_ports;
 
 /* Pulled the logic from XFree86 Cirrus driver to get the memory size,
  * based on the DRAM bandwidth bit and DRAM bank switching bit.  This
  * works with 1MB, 2MB and 4MB configurations (which the Motorola boards
  * seem to have. */
-static unsigned int cirrusfb_get_memsize (u8 __iomem *regbase)
+static unsigned int cirrusfb_get_memsize(u8 __iomem *regbase)
 {
 	unsigned long mem;
 	unsigned char SRF;
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
-	SRF = vga_rseq (regbase, CL_SEQRF);
+	SRF = vga_rseq(regbase, CL_SEQRF);
 	switch ((SRF & 0x18)) {
-	    case 0x08: mem = 512 * 1024; break;
-	    case 0x10: mem = 1024 * 1024; break;
-		/* 64-bit DRAM data bus width; assume 2MB. Also indicates 2MB memory
-		   * on the 5430. */
-	    case 0x18: mem = 2048 * 1024; break;
-	    default: printk ("CLgenfb: Unknown memory size!\n");
+	case 0x08:
+		mem = 512 * 1024;
+		break;
+	case 0x10:
+		mem = 1024 * 1024;
+		break;
+	/* 64-bit DRAM data bus width; assume 2MB. Also indicates 2MB memory
+	 * on the 5430.
+	 */
+	case 0x18:
+		mem = 2048 * 1024;
+		break;
+	default:
+		printk(KERN_WARNING "CLgenfb: Unknown memory size!\n");
 		mem = 1024 * 1024;
 	}
-	if (SRF & 0x80) {
-		/* If DRAM bank switching is enabled, there must be twice as much
-		   * memory installed. (4MB on the 5434) */
+	if (SRF & 0x80)
+	/* If DRAM bank switching is enabled, there must be twice as much
+	 * memory installed. (4MB on the 5434)
+	 */
 		mem *= 2;
-	}
+
 	/* TODO: Handling of GD5446/5480 (see XF86 sources ...) */
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 	return mem;
 }
 
-
-
-static void get_pci_addrs (const struct pci_dev *pdev,
-			   unsigned long *display, unsigned long *registers)
+static void get_pci_addrs(const struct pci_dev *pdev,
+			  unsigned long *display, unsigned long *registers)
 {
-	assert (pdev != NULL);
-	assert (display != NULL);
-	assert (registers != NULL);
+	assert(pdev != NULL);
+	assert(display != NULL);
+	assert(registers != NULL);
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
 	*display = 0;
 	*registers = 0;
@@ -2198,13 +2358,12 @@ static void get_pci_addrs (const struct 
 		*registers = pci_resource_start(pdev, 1);
 	}
 
-	assert (*display != 0);
+	assert(*display != 0);
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
-
-static void cirrusfb_pci_unmap (struct cirrusfb_info *cinfo)
+static void cirrusfb_pci_unmap(struct cirrusfb_info *cinfo)
 {
 	struct pci_dev *pdev = cinfo->pdev;
 
@@ -2219,19 +2378,18 @@ static void cirrusfb_pci_unmap (struct c
 }
 #endif /* CONFIG_PCI */
 
-
 #ifdef CONFIG_ZORRO
-static void __devexit cirrusfb_zorro_unmap (struct cirrusfb_info *cinfo)
+static void __devexit cirrusfb_zorro_unmap(struct cirrusfb_info *cinfo)
 {
 	zorro_release_device(cinfo->zdev);
 
 	if (cinfo->btype == BT_PICASSO4) {
 		cinfo->regbase -= 0x600000;
-		iounmap ((void *)cinfo->regbase);
-		iounmap ((void *)cinfo->fbmem);
+		iounmap((void *)cinfo->regbase);
+		iounmap((void *)cinfo->fbmem);
 	} else {
 		if (zorro_resource_start(cinfo->zdev) > 0x01000000)
-			iounmap ((void *)cinfo->fbmem);
+			iounmap((void *)cinfo->fbmem);
 	}
 	framebuffer_release(cinfo->info);
 }
@@ -2267,7 +2425,8 @@ static int cirrusfb_set_fbinfo(struct ci
 	/* monochrome: only 1 memory plane */
 	/* 8 bit and above: Use whole memory area */
 	info->fix.smem_start = cinfo->fbmem_phys;
-	info->fix.smem_len   = (var->bits_per_pixel == 1) ? cinfo->size / 4 : cinfo->size;
+	info->fix.smem_len   =
+		(var->bits_per_pixel == 1) ? cinfo->size / 4 : cinfo->size;
 	info->fix.type       = cinfo->currentmode.type;
 	info->fix.type_aux   = 0;
 	info->fix.visual     = cinfo->currentmode.visual;
@@ -2292,17 +2451,18 @@ static int cirrusfb_register(struct cirr
 	int err;
 	cirrusfb_board_t btype;
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
-	printk (KERN_INFO "cirrusfb: Driver for Cirrus Logic based graphic boards, v" CIRRUSFB_VERSION "\n");
+	printk(KERN_INFO "cirrusfb: Driver for Cirrus Logic based "
+		"graphic boards, v" CIRRUSFB_VERSION "\n");
 
 	info = cinfo->info;
 	btype = cinfo->btype;
 
 	/* sanity checks */
-	assert (btype != BT_NONE);
+	assert(btype != BT_NONE);
 
-	DPRINTK ("cirrusfb: (RAM start set to: 0x%p)\n", cinfo->fbmem);
+	DPRINTK("cirrusfb: (RAM start set to: 0x%p)\n", cinfo->fbmem);
 
 	/* Make pretend we've set the var so our structures are in a "good" */
 	/* state, even though we haven't written the mode to the hw yet...  */
@@ -2321,11 +2481,12 @@ static int cirrusfb_register(struct cirr
 
 	err = register_framebuffer(info);
 	if (err < 0) {
-		printk (KERN_ERR "cirrusfb: could not register fb device; err = %d!\n", err);
+		printk(KERN_ERR "cirrusfb: could not register "
+			"fb device; err = %d!\n", err);
 		goto err_dealloc_cmap;
 	}
 
-	DPRINTK ("EXIT, returning 0\n");
+	DPRINTK("EXIT, returning 0\n");
 	return 0;
 
 err_dealloc_cmap:
@@ -2335,24 +2496,23 @@ err_unmap_cirrusfb:
 	return err;
 }
 
-static void __devexit cirrusfb_cleanup (struct fb_info *info)
+static void __devexit cirrusfb_cleanup(struct fb_info *info)
 {
 	struct cirrusfb_info *cinfo = info->par;
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
-	switch_monitor (cinfo, 0);
+	switch_monitor(cinfo, 0);
 
-	unregister_framebuffer (info);
-	fb_dealloc_cmap (&info->cmap);
-	printk ("Framebuffer unregistered\n");
+	unregister_framebuffer(info);
+	fb_dealloc_cmap(&info->cmap);
+	printk("Framebuffer unregistered\n");
 	cinfo->unmap(cinfo);
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
-
 #ifdef CONFIG_PCI
-static int cirrusfb_pci_register (struct pci_dev *pdev,
+static int cirrusfb_pci_register(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
 	struct cirrusfb_info *cinfo;
@@ -2379,31 +2539,34 @@ static int cirrusfb_pci_register (struct
 	cinfo->pdev = pdev;
 	cinfo->btype = btype = (cirrusfb_board_t) ent->driver_data;
 
-	DPRINTK (" Found PCI device, base address 0 is 0x%lx, btype set to %d\n",
+	DPRINTK(" Found PCI device, base address 0 is 0x%lx, btype set to %d\n",
 		pdev->resource[0].start, btype);
-	DPRINTK (" base address 1 is 0x%lx\n", pdev->resource[1].start);
+	DPRINTK(" base address 1 is 0x%lx\n", pdev->resource[1].start);
 
-	if(isPReP) {
-		pci_write_config_dword (pdev, PCI_BASE_ADDRESS_0, 0x00000000);
+	if (isPReP) {
+		pci_write_config_dword(pdev, PCI_BASE_ADDRESS_0, 0x00000000);
 #ifdef CONFIG_PPC_PREP
-		get_prep_addrs (&board_addr, &cinfo->fbregs_phys);
+		get_prep_addrs(&board_addr, &cinfo->fbregs_phys);
 #endif
-		/* PReP dies if we ioremap the IO registers, but it works w/out... */
+	/* PReP dies if we ioremap the IO registers, but it works w/out... */
 		cinfo->regbase = (char __iomem *) cinfo->fbregs_phys;
 	} else {
-		DPRINTK ("Attempt to get PCI info for Cirrus Graphics Card\n");
-		get_pci_addrs (pdev, &board_addr, &cinfo->fbregs_phys);
-		cinfo->regbase = NULL;		/* FIXME: this forces VGA.  alternatives? */
+		DPRINTK("Attempt to get PCI info for Cirrus Graphics Card\n");
+		get_pci_addrs(pdev, &board_addr, &cinfo->fbregs_phys);
+		/* FIXME: this forces VGA.  alternatives? */
+		cinfo->regbase = NULL;
 	}
 
-	DPRINTK ("Board address: 0x%lx, register address: 0x%lx\n", board_addr, cinfo->fbregs_phys);
+	DPRINTK("Board address: 0x%lx, register address: 0x%lx\n",
+		board_addr, cinfo->fbregs_phys);
 
 	board_size = (btype == BT_GD5480) ?
-		32 * MB_ : cirrusfb_get_memsize (cinfo->regbase);
+		32 * MB_ : cirrusfb_get_memsize(cinfo->regbase);
 
 	ret = pci_request_regions(pdev, "cirrusfb");
-	if (ret <0) {
-		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, abort\n",
+	if (ret < 0) {
+		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, "
+		       "abort\n",
 		       board_addr);
 		goto err_release_fb;
 	}
@@ -2429,8 +2592,9 @@ static int cirrusfb_pci_register (struct
 	cinfo->size = board_size;
 	cinfo->unmap = cirrusfb_pci_unmap;
 
-	printk (" RAM (%lu kB) at 0xx%lx, ", cinfo->size / KB_, board_addr);
-	printk ("Cirrus Logic chipset on PCI bus\n");
+	printk(KERN_INFO " RAM (%lu kB) at 0xx%lx, ",
+		cinfo->size / KB_, board_addr);
+	printk(KERN_INFO "Cirrus Logic chipset on PCI bus\n");
 	pci_set_drvdata(pdev, info);
 
 	ret = cirrusfb_register(cinfo);
@@ -2453,14 +2617,14 @@ err_out:
 	return ret;
 }
 
-static void __devexit cirrusfb_pci_unregister (struct pci_dev *pdev)
+static void __devexit cirrusfb_pci_unregister(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
-	cirrusfb_cleanup (info);
+	cirrusfb_cleanup(info);
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
 static struct pci_driver cirrusfb_pci_driver = {
@@ -2477,7 +2641,6 @@ static struct pci_driver cirrusfb_pci_dr
 };
 #endif /* CONFIG_PCI */
 
-
 #ifdef CONFIG_ZORRO
 static int cirrusfb_zorro_register(struct zorro_dev *z,
 				   const struct zorro_device_id *ent)
@@ -2498,7 +2661,7 @@ static int cirrusfb_zorro_register(struc
 
 	info = framebuffer_alloc(sizeof(struct cirrusfb_info), &z->dev);
 	if (!info) {
-		printk (KERN_ERR "cirrusfb: could not allocate memory\n");
+		printk(KERN_ERR "cirrusfb: could not allocate memory\n");
 		ret = -ENOMEM;
 		goto err_out;
 	}
@@ -2507,9 +2670,9 @@ static int cirrusfb_zorro_register(struc
 	cinfo->info = info;
 	cinfo->btype = btype;
 
-	assert (z > 0);
-	assert (z2 >= 0);
-	assert (btype != BT_NONE);
+	assert(z > 0);
+	assert(z2 >= 0);
+	assert(btype != BT_NONE);
 
 	cinfo->zdev = z;
 	board_addr = zorro_resource_start(z);
@@ -2517,55 +2680,59 @@ static int cirrusfb_zorro_register(struc
 	cinfo->size = size;
 
 	if (!zorro_request_device(z, "cirrusfb")) {
-		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, abort\n",
+		printk(KERN_ERR "cirrusfb: cannot reserve region 0x%lx, "
+		       "abort\n",
 		       board_addr);
 		ret = -EBUSY;
 		goto err_release_fb;
 	}
 
-	printk (" RAM (%lu MB) at $%lx, ", board_size / MB_, board_addr);
+	printk(" RAM (%lu MB) at $%lx, ", board_size / MB_, board_addr);
 
 	ret = -EIO;
 
 	if (btype == BT_PICASSO4) {
-		printk (" REG at $%lx\n", board_addr + 0x600000);
+		printk(KERN_INFO " REG at $%lx\n", board_addr + 0x600000);
 
 		/* To be precise, for the P4 this is not the */
 		/* begin of the board, but the begin of RAM. */
 		/* for P4, map in its address space in 2 chunks (### TEST! ) */
 		/* (note the ugly hardcoded 16M number) */
-		cinfo->regbase = ioremap (board_addr, 16777216);
+		cinfo->regbase = ioremap(board_addr, 16777216);
 		if (!cinfo->regbase)
 			goto err_release_region;
 
-		DPRINTK ("cirrusfb: Virtual address for board set to: $%p\n", cinfo->regbase);
+		DPRINTK("cirrusfb: Virtual address for board set to: $%p\n",
+			cinfo->regbase);
 		cinfo->regbase += 0x600000;
 		cinfo->fbregs_phys = board_addr + 0x600000;
 
 		cinfo->fbmem_phys = board_addr + 16777216;
-		cinfo->fbmem = ioremap (cinfo->fbmem_phys, 16777216);
+		cinfo->fbmem = ioremap(cinfo->fbmem_phys, 16777216);
 		if (!cinfo->fbmem)
 			goto err_unmap_regbase;
 	} else {
-		printk (" REG at $%lx\n", (unsigned long) z2->resource.start);
+		printk(KERN_INFO " REG at $%lx\n",
+			(unsigned long) z2->resource.start);
 
 		cinfo->fbmem_phys = board_addr;
 		if (board_addr > 0x01000000)
-			cinfo->fbmem = ioremap (board_addr, board_size);
+			cinfo->fbmem = ioremap(board_addr, board_size);
 		else
-			cinfo->fbmem = (caddr_t) ZTWO_VADDR (board_addr);
+			cinfo->fbmem = (caddr_t) ZTWO_VADDR(board_addr);
 		if (!cinfo->fbmem)
 			goto err_release_region;
 
 		/* set address for REG area of board */
-		cinfo->regbase = (caddr_t) ZTWO_VADDR (z2->resource.start);
+		cinfo->regbase = (caddr_t) ZTWO_VADDR(z2->resource.start);
 		cinfo->fbregs_phys = z2->resource.start;
 
-		DPRINTK ("cirrusfb: Virtual address for board set to: $%p\n", cinfo->regbase);
+		DPRINTK("cirrusfb: Virtual address for board set to: $%p\n",
+			cinfo->regbase);
 	}
 	cinfo->unmap = cirrusfb_zorro_unmap;
 
-	printk (KERN_INFO "Cirrus Logic chipset on Zorro bus\n");
+	printk(KERN_INFO "Cirrus Logic chipset on Zorro bus\n");
 	zorro_set_drvdata(z, info);
 
 	ret = cirrusfb_register(cinfo);
@@ -2592,11 +2759,11 @@ err_out:
 void __devexit cirrusfb_zorro_unregister(struct zorro_dev *z)
 {
 	struct fb_info *info = zorro_get_drvdata(z);
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
-	cirrusfb_cleanup (info);
+	cirrusfb_cleanup(info);
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
 static struct zorro_driver cirrusfb_zorro_driver = {
@@ -2628,26 +2795,24 @@ static int __init cirrusfb_init(void)
 	return error;
 }
 
-
-
 #ifndef MODULE
 static int __init cirrusfb_setup(char *options) {
 	char *this_opt, s[32];
 	int i;
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
 	if (!options || !*options)
 		return 0;
 
-	while ((this_opt = strsep (&options, ",")) != NULL) {	
+	while ((this_opt = strsep(&options, ",")) != NULL) {
 		if (!*this_opt) continue;
 
 		DPRINTK("cirrusfb_setup: option '%s'\n", this_opt);
 
 		for (i = 0; i < NUM_TOTAL_MODES; i++) {
-			sprintf (s, "mode:%s", cirrusfb_predefined[i].name);
-			if (strcmp (this_opt, s) == 0)
+			sprintf(s, "mode:%s", cirrusfb_predefined[i].name);
+			if (strcmp(this_opt, s) == 0)
 				cirrusfb_def_mode = i;
 		}
 		if (!strcmp(this_opt, "noaccel"))
@@ -2657,7 +2822,6 @@ static int __init cirrusfb_setup(char *o
 }
 #endif
 
-
     /*
      *  Modularization
      */
@@ -2666,7 +2830,7 @@ MODULE_AUTHOR("Copyright 1999,2000 Jeff 
 MODULE_DESCRIPTION("Accelerated FBDev driver for Cirrus Logic chips");
 MODULE_LICENSE("GPL");
 
-static void __exit cirrusfb_exit (void)
+static void __exit cirrusfb_exit(void)
 {
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&cirrusfb_pci_driver);
@@ -2682,66 +2846,67 @@ module_init(cirrusfb_init);
 module_exit(cirrusfb_exit);
 #endif
 
-
 /**********************************************************************/
 /* about the following functions - I have used the same names for the */
 /* functions as Markus Wild did in his Retina driver for NetBSD as    */
 /* they just made sense for this purpose. Apart from that, I wrote    */
-/* these functions myself.                                            */
+/* these functions myself.					    */
 /**********************************************************************/
 
 /*** WGen() - write into one of the external/general registers ***/
-static void WGen (const struct cirrusfb_info *cinfo,
+static void WGen(const struct cirrusfb_info *cinfo,
 		  int regnum, unsigned char val)
 {
 	unsigned long regofs = 0;
 
 	if (cinfo->btype == BT_PICASSO) {
 		/* Picasso II specific hack */
-/*              if (regnum == VGA_PEL_IR || regnum == VGA_PEL_D || regnum == CL_VSSM2) */
+/*	      if (regnum == VGA_PEL_IR || regnum == VGA_PEL_D ||
+		  regnum == CL_VSSM2) */
 		if (regnum == VGA_PEL_IR || regnum == VGA_PEL_D)
 			regofs = 0xfff;
 	}
 
-	vga_w (cinfo->regbase, regofs + regnum, val);
+	vga_w(cinfo->regbase, regofs + regnum, val);
 }
 
 /*** RGen() - read out one of the external/general registers ***/
-static unsigned char RGen (const struct cirrusfb_info *cinfo, int regnum)
+static unsigned char RGen(const struct cirrusfb_info *cinfo, int regnum)
 {
 	unsigned long regofs = 0;
 
 	if (cinfo->btype == BT_PICASSO) {
 		/* Picasso II specific hack */
-/*              if (regnum == VGA_PEL_IR || regnum == VGA_PEL_D || regnum == CL_VSSM2) */
+/*	      if (regnum == VGA_PEL_IR || regnum == VGA_PEL_D ||
+		  regnum == CL_VSSM2) */
 		if (regnum == VGA_PEL_IR || regnum == VGA_PEL_D)
 			regofs = 0xfff;
 	}
 
-	return vga_r (cinfo->regbase, regofs + regnum);
+	return vga_r(cinfo->regbase, regofs + regnum);
 }
 
 /*** AttrOn() - turn on VideoEnable for Attribute controller ***/
-static void AttrOn (const struct cirrusfb_info *cinfo)
+static void AttrOn(const struct cirrusfb_info *cinfo)
 {
-	assert (cinfo != NULL);
+	assert(cinfo != NULL);
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
-	if (vga_rcrt (cinfo->regbase, CL_CRT24) & 0x80) {
+	if (vga_rcrt(cinfo->regbase, CL_CRT24) & 0x80) {
 		/* if we're just in "write value" mode, write back the */
 		/* same value as before to not modify anything */
-		vga_w (cinfo->regbase, VGA_ATT_IW,
-		       vga_r (cinfo->regbase, VGA_ATT_R));
+		vga_w(cinfo->regbase, VGA_ATT_IW,
+		      vga_r(cinfo->regbase, VGA_ATT_R));
 	}
 	/* turn on video bit */
-/*      vga_w (cinfo->regbase, VGA_ATT_IW, 0x20); */
-	vga_w (cinfo->regbase, VGA_ATT_IW, 0x33);
+/*      vga_w(cinfo->regbase, VGA_ATT_IW, 0x20); */
+	vga_w(cinfo->regbase, VGA_ATT_IW, 0x33);
 
 	/* dummy write on Reg0 to be on "write index" mode next time */
-	vga_w (cinfo->regbase, VGA_ATT_IW, 0x00);
+	vga_w(cinfo->regbase, VGA_ATT_IW, 0x00);
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
 /*** WHDR() - write into the Hidden DAC register ***/
@@ -2750,119 +2915,115 @@ static void AttrOn (const struct cirrusf
  * registers of their functional group) here is a specialized routine for
  * accessing the HDR
  */
-static void WHDR (const struct cirrusfb_info *cinfo, unsigned char val)
+static void WHDR(const struct cirrusfb_info *cinfo, unsigned char val)
 {
 	unsigned char dummy;
 
 	if (cinfo->btype == BT_PICASSO) {
 		/* Klaus' hint for correct access to HDR on some boards */
 		/* first write 0 to pixel mask (3c6) */
-		WGen (cinfo, VGA_PEL_MSK, 0x00);
-		udelay (200);
+		WGen(cinfo, VGA_PEL_MSK, 0x00);
+		udelay(200);
 		/* next read dummy from pixel address (3c8) */
-		dummy = RGen (cinfo, VGA_PEL_IW);
-		udelay (200);
+		dummy = RGen(cinfo, VGA_PEL_IW);
+		udelay(200);
 	}
 	/* now do the usual stuff to access the HDR */
 
-	dummy = RGen (cinfo, VGA_PEL_MSK);
-	udelay (200);
-	dummy = RGen (cinfo, VGA_PEL_MSK);
-	udelay (200);
-	dummy = RGen (cinfo, VGA_PEL_MSK);
-	udelay (200);
-	dummy = RGen (cinfo, VGA_PEL_MSK);
-	udelay (200);
+	dummy = RGen(cinfo, VGA_PEL_MSK);
+	udelay(200);
+	dummy = RGen(cinfo, VGA_PEL_MSK);
+	udelay(200);
+	dummy = RGen(cinfo, VGA_PEL_MSK);
+	udelay(200);
+	dummy = RGen(cinfo, VGA_PEL_MSK);
+	udelay(200);
 
-	WGen (cinfo, VGA_PEL_MSK, val);
-	udelay (200);
+	WGen(cinfo, VGA_PEL_MSK, val);
+	udelay(200);
 
 	if (cinfo->btype == BT_PICASSO) {
 		/* now first reset HDR access counter */
-		dummy = RGen (cinfo, VGA_PEL_IW);
-		udelay (200);
+		dummy = RGen(cinfo, VGA_PEL_IW);
+		udelay(200);
 
 		/* and at the end, restore the mask value */
 		/* ## is this mask always 0xff? */
-		WGen (cinfo, VGA_PEL_MSK, 0xff);
-		udelay (200);
+		WGen(cinfo, VGA_PEL_MSK, 0xff);
+		udelay(200);
 	}
 }
 
-
 /*** WSFR() - write to the "special function register" (SFR) ***/
-static void WSFR (struct cirrusfb_info *cinfo, unsigned char val)
+static void WSFR(struct cirrusfb_info *cinfo, unsigned char val)
 {
 #ifdef CONFIG_ZORRO
-	assert (cinfo->regbase != NULL);
+	assert(cinfo->regbase != NULL);
 	cinfo->SFR = val;
-	z_writeb (val, cinfo->regbase + 0x8000);
+	z_writeb(val, cinfo->regbase + 0x8000);
 #endif
 }
 
 /* The Picasso has a second register for switching the monitor bit */
-static void WSFR2 (struct cirrusfb_info *cinfo, unsigned char val)
+static void WSFR2(struct cirrusfb_info *cinfo, unsigned char val)
 {
 #ifdef CONFIG_ZORRO
 	/* writing an arbitrary value to this one causes the monitor switcher */
 	/* to flip to Amiga display */
-	assert (cinfo->regbase != NULL);
+	assert(cinfo->regbase != NULL);
 	cinfo->SFR = val;
-	z_writeb (val, cinfo->regbase + 0x9000);
+	z_writeb(val, cinfo->regbase + 0x9000);
 #endif
 }
 
-
 /*** WClut - set CLUT entry (range: 0..63) ***/
-static void WClut (struct cirrusfb_info *cinfo, unsigned char regnum, unsigned char red,
+static void WClut(struct cirrusfb_info *cinfo, unsigned char regnum, unsigned char red,
 	    unsigned char green, unsigned char blue)
 {
 	unsigned int data = VGA_PEL_D;
 
 	/* address write mode register is not translated.. */
-	vga_w (cinfo->regbase, VGA_PEL_IW, regnum);
+	vga_w(cinfo->regbase, VGA_PEL_IW, regnum);
 
 	if (cinfo->btype == BT_PICASSO || cinfo->btype == BT_PICASSO4 ||
 	    cinfo->btype == BT_ALPINE || cinfo->btype == BT_GD5480) {
 		/* but DAC data register IS, at least for Picasso II */
 		if (cinfo->btype == BT_PICASSO)
 			data += 0xfff;
-		vga_w (cinfo->regbase, data, red);
-		vga_w (cinfo->regbase, data, green);
-		vga_w (cinfo->regbase, data, blue);
+		vga_w(cinfo->regbase, data, red);
+		vga_w(cinfo->regbase, data, green);
+		vga_w(cinfo->regbase, data, blue);
 	} else {
-		vga_w (cinfo->regbase, data, blue);
-		vga_w (cinfo->regbase, data, green);
-		vga_w (cinfo->regbase, data, red);
+		vga_w(cinfo->regbase, data, blue);
+		vga_w(cinfo->regbase, data, green);
+		vga_w(cinfo->regbase, data, red);
 	}
 }
 
-
 #if 0
 /*** RClut - read CLUT entry (range 0..63) ***/
-static void RClut (struct cirrusfb_info *cinfo, unsigned char regnum, unsigned char *red,
+static void RClut(struct cirrusfb_info *cinfo, unsigned char regnum, unsigned char *red,
 	    unsigned char *green, unsigned char *blue)
 {
 	unsigned int data = VGA_PEL_D;
 
-	vga_w (cinfo->regbase, VGA_PEL_IR, regnum);
+	vga_w(cinfo->regbase, VGA_PEL_IR, regnum);
 
 	if (cinfo->btype == BT_PICASSO || cinfo->btype == BT_PICASSO4 ||
 	    cinfo->btype == BT_ALPINE || cinfo->btype == BT_GD5480) {
 		if (cinfo->btype == BT_PICASSO)
 			data += 0xfff;
-		*red = vga_r (cinfo->regbase, data);
-		*green = vga_r (cinfo->regbase, data);
-		*blue = vga_r (cinfo->regbase, data);
+		*red = vga_r(cinfo->regbase, data);
+		*green = vga_r(cinfo->regbase, data);
+		*blue = vga_r(cinfo->regbase, data);
 	} else {
-		*blue = vga_r (cinfo->regbase, data);
-		*green = vga_r (cinfo->regbase, data);
-		*red = vga_r (cinfo->regbase, data);
+		*blue = vga_r(cinfo->regbase, data);
+		*green = vga_r(cinfo->regbase, data);
+		*red = vga_r(cinfo->regbase, data);
 	}
 }
 #endif
 
-
 /*******************************************************************
 	cirrusfb_WaitBLT()
 
@@ -2870,10 +3031,10 @@ static void RClut (struct cirrusfb_info 
 *********************************************************************/
 
 /* FIXME: use interrupts instead */
-static void cirrusfb_WaitBLT (u8 __iomem *regbase)
+static void cirrusfb_WaitBLT(u8 __iomem *regbase)
 {
 	/* now busy-wait until we're done */
-	while (vga_rgfx (regbase, CL_GR31) & 0x08)
+	while (vga_rgfx(regbase, CL_GR31) & 0x08)
 		/* do nothing */ ;
 }
 
@@ -2883,15 +3044,17 @@ static void cirrusfb_WaitBLT (u8 __iomem
 	perform accelerated "scrolling"
 ********************************************************************/
 
-static void cirrusfb_BitBLT (u8 __iomem *regbase, int bits_per_pixel,
-			     u_short curx, u_short cury, u_short destx, u_short desty,
-			     u_short width, u_short height, u_short line_length)
+static void cirrusfb_BitBLT(u8 __iomem *regbase, int bits_per_pixel,
+			    u_short curx, u_short cury,
+			    u_short destx, u_short desty,
+			    u_short width, u_short height,
+			    u_short line_length)
 {
 	u_short nwidth, nheight;
 	u_long nsrc, ndest;
 	u_char bltmode;
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
 	nwidth = width - 1;
 	nheight = height - 1;
@@ -2911,9 +3074,13 @@ static void cirrusfb_BitBLT (u8 __iomem 
 		nsrc = (cury * line_length) + curx;
 		ndest = (desty * line_length) + destx;
 	} else {
-		/* this means start addresses are at the end, counting backwards */
-		nsrc = cury * line_length + curx + nheight * line_length + nwidth;
-		ndest = desty * line_length + destx + nheight * line_length + nwidth;
+		/* this means start addresses are at the end,
+		 * counting backwards
+		 */
+		nsrc = cury * line_length + curx +
+			nheight * line_length + nwidth;
+		ndest = desty * line_length + destx +
+			nheight * line_length + nwidth;
 	}
 
 	/*
@@ -2929,52 +3096,65 @@ static void cirrusfb_BitBLT (u8 __iomem 
 	   start/stop
 	 */
 
-        cirrusfb_WaitBLT(regbase);
+	cirrusfb_WaitBLT(regbase);
 
 	/* pitch: set to line_length */
-	vga_wgfx (regbase, CL_GR24, line_length & 0xff);	/* dest pitch low */
-	vga_wgfx (regbase, CL_GR25, (line_length >> 8));	/* dest pitch hi */
-	vga_wgfx (regbase, CL_GR26, line_length & 0xff);	/* source pitch low */
-	vga_wgfx (regbase, CL_GR27, (line_length >> 8));	/* source pitch hi */
+	/* dest pitch low */
+	vga_wgfx(regbase, CL_GR24, line_length & 0xff);
+	/* dest pitch hi */
+	vga_wgfx(regbase, CL_GR25, line_length >> 8);
+	/* source pitch low */
+	vga_wgfx(regbase, CL_GR26, line_length & 0xff);
+	/* source pitch hi */
+	vga_wgfx(regbase, CL_GR27, line_length >> 8);
 
 	/* BLT width: actual number of pixels - 1 */
-	vga_wgfx (regbase, CL_GR20, nwidth & 0xff);	/* BLT width low */
-	vga_wgfx (regbase, CL_GR21, (nwidth >> 8));	/* BLT width hi */
+	/* BLT width low */
+	vga_wgfx(regbase, CL_GR20, nwidth & 0xff);
+	/* BLT width hi */
+	vga_wgfx(regbase, CL_GR21, nwidth >> 8);
 
 	/* BLT height: actual number of lines -1 */
-	vga_wgfx (regbase, CL_GR22, nheight & 0xff);	/* BLT height low */
-	vga_wgfx (regbase, CL_GR23, (nheight >> 8));	/* BLT width hi */
+	/* BLT height low */
+	vga_wgfx(regbase, CL_GR22, nheight & 0xff);
+	/* BLT width hi */
+	vga_wgfx(regbase, CL_GR23, nheight >> 8);
 
 	/* BLT destination */
-	vga_wgfx (regbase, CL_GR28, (u_char) (ndest & 0xff));	/* BLT dest low */
-	vga_wgfx (regbase, CL_GR29, (u_char) (ndest >> 8));	/* BLT dest mid */
-	vga_wgfx (regbase, CL_GR2A, (u_char) (ndest >> 16));	/* BLT dest hi */
+	/* BLT dest low */
+	vga_wgfx(regbase, CL_GR28, (u_char) (ndest & 0xff));
+	/* BLT dest mid */
+	vga_wgfx(regbase, CL_GR29, (u_char) (ndest >> 8));
+	/* BLT dest hi */
+	vga_wgfx(regbase, CL_GR2A, (u_char) (ndest >> 16));
 
 	/* BLT source */
-	vga_wgfx (regbase, CL_GR2C, (u_char) (nsrc & 0xff));	/* BLT src low */
-	vga_wgfx (regbase, CL_GR2D, (u_char) (nsrc >> 8));		/* BLT src mid */
-	vga_wgfx (regbase, CL_GR2E, (u_char) (nsrc >> 16));	/* BLT src hi */
+	/* BLT src low */
+	vga_wgfx(regbase, CL_GR2C, (u_char) (nsrc & 0xff));
+	/* BLT src mid */
+	vga_wgfx(regbase, CL_GR2D, (u_char) (nsrc >> 8));
+	/* BLT src hi */
+	vga_wgfx(regbase, CL_GR2E, (u_char) (nsrc >> 16));
 
 	/* BLT mode */
-	vga_wgfx (regbase, CL_GR30, bltmode);	/* BLT mode */
+	vga_wgfx(regbase, CL_GR30, bltmode);	/* BLT mode */
 
 	/* BLT ROP: SrcCopy */
-	vga_wgfx (regbase, CL_GR32, 0x0d);		/* BLT ROP */
+	vga_wgfx(regbase, CL_GR32, 0x0d);	/* BLT ROP */
 
 	/* and finally: GO! */
-	vga_wgfx (regbase, CL_GR31, 0x02);		/* BLT Start/status */
+	vga_wgfx(regbase, CL_GR31, 0x02);	/* BLT Start/status */
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
-
 /*******************************************************************
 	cirrusfb_RectFill()
 
 	perform accelerated rectangle fill
 ********************************************************************/
 
-static void cirrusfb_RectFill (u8 __iomem *regbase, int bits_per_pixel,
+static void cirrusfb_RectFill(u8 __iomem *regbase, int bits_per_pixel,
 		     u_short x, u_short y, u_short width, u_short height,
 		     u_char color, u_short line_length)
 {
@@ -2982,93 +3162,95 @@ static void cirrusfb_RectFill (u8 __iome
 	u_long ndest;
 	u_char op;
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
 	nwidth = width - 1;
 	nheight = height - 1;
 
 	ndest = (y * line_length) + x;
 
-        cirrusfb_WaitBLT(regbase);
+	cirrusfb_WaitBLT(regbase);
 
 	/* pitch: set to line_length */
-	vga_wgfx (regbase, CL_GR24, line_length & 0xff);	/* dest pitch low */
-	vga_wgfx (regbase, CL_GR25, (line_length >> 8));	/* dest pitch hi */
-	vga_wgfx (regbase, CL_GR26, line_length & 0xff);	/* source pitch low */
-	vga_wgfx (regbase, CL_GR27, (line_length >> 8));	/* source pitch hi */
+	vga_wgfx(regbase, CL_GR24, line_length & 0xff);	/* dest pitch low */
+	vga_wgfx(regbase, CL_GR25, line_length >> 8);	/* dest pitch hi */
+	vga_wgfx(regbase, CL_GR26, line_length & 0xff);	/* source pitch low */
+	vga_wgfx(regbase, CL_GR27, line_length >> 8);	/* source pitch hi */
 
 	/* BLT width: actual number of pixels - 1 */
-	vga_wgfx (regbase, CL_GR20, nwidth & 0xff);	/* BLT width low */
-	vga_wgfx (regbase, CL_GR21, (nwidth >> 8));	/* BLT width hi */
+	vga_wgfx(regbase, CL_GR20, nwidth & 0xff);	/* BLT width low */
+	vga_wgfx(regbase, CL_GR21, nwidth >> 8);	/* BLT width hi */
 
 	/* BLT height: actual number of lines -1 */
-	vga_wgfx (regbase, CL_GR22, nheight & 0xff);		/* BLT height low */
-	vga_wgfx (regbase, CL_GR23, (nheight >> 8));		/* BLT width hi */
+	vga_wgfx(regbase, CL_GR22, nheight & 0xff);	/* BLT height low */
+	vga_wgfx(regbase, CL_GR23, nheight >> 8);	/* BLT width hi */
 
 	/* BLT destination */
-	vga_wgfx (regbase, CL_GR28, (u_char) (ndest & 0xff));	/* BLT dest low */
-	vga_wgfx (regbase, CL_GR29, (u_char) (ndest >> 8));	/* BLT dest mid */
-	vga_wgfx (regbase, CL_GR2A, (u_char) (ndest >> 16));		/* BLT dest hi */
+	/* BLT dest low */
+	vga_wgfx(regbase, CL_GR28, (u_char) (ndest & 0xff));
+	/* BLT dest mid */
+	vga_wgfx(regbase, CL_GR29, (u_char) (ndest >> 8));
+	/* BLT dest hi */
+	vga_wgfx(regbase, CL_GR2A, (u_char) (ndest >> 16));
 
 	/* BLT source: set to 0 (is a dummy here anyway) */
-	vga_wgfx (regbase, CL_GR2C, 0x00);	/* BLT src low */
-	vga_wgfx (regbase, CL_GR2D, 0x00);	/* BLT src mid */
-	vga_wgfx (regbase, CL_GR2E, 0x00);	/* BLT src hi */
+	vga_wgfx(regbase, CL_GR2C, 0x00);	/* BLT src low */
+	vga_wgfx(regbase, CL_GR2D, 0x00);	/* BLT src mid */
+	vga_wgfx(regbase, CL_GR2E, 0x00);	/* BLT src hi */
 
 	/* This is a ColorExpand Blt, using the */
 	/* same color for foreground and background */
-	vga_wgfx (regbase, VGA_GFX_SR_VALUE, color);	/* foreground color */
-	vga_wgfx (regbase, VGA_GFX_SR_ENABLE, color);	/* background color */
+	vga_wgfx(regbase, VGA_GFX_SR_VALUE, color);	/* foreground color */
+	vga_wgfx(regbase, VGA_GFX_SR_ENABLE, color);	/* background color */
 
 	op = 0xc0;
 	if (bits_per_pixel == 16) {
-		vga_wgfx (regbase, CL_GR10, color);	/* foreground color */
-		vga_wgfx (regbase, CL_GR11, color);	/* background color */
+		vga_wgfx(regbase, CL_GR10, color);	/* foreground color */
+		vga_wgfx(regbase, CL_GR11, color);	/* background color */
 		op = 0x50;
 		op = 0xd0;
 	} else if (bits_per_pixel == 32) {
-		vga_wgfx (regbase, CL_GR10, color);	/* foreground color */
-		vga_wgfx (regbase, CL_GR11, color);	/* background color */
-		vga_wgfx (regbase, CL_GR12, color);	/* foreground color */
-		vga_wgfx (regbase, CL_GR13, color);	/* background color */
-		vga_wgfx (regbase, CL_GR14, 0);	/* foreground color */
-		vga_wgfx (regbase, CL_GR15, 0);	/* background color */
+		vga_wgfx(regbase, CL_GR10, color);	/* foreground color */
+		vga_wgfx(regbase, CL_GR11, color);	/* background color */
+		vga_wgfx(regbase, CL_GR12, color);	/* foreground color */
+		vga_wgfx(regbase, CL_GR13, color);	/* background color */
+		vga_wgfx(regbase, CL_GR14, 0);	/* foreground color */
+		vga_wgfx(regbase, CL_GR15, 0);	/* background color */
 		op = 0x50;
 		op = 0xf0;
 	}
 	/* BLT mode: color expand, Enable 8x8 copy (faster?) */
-	vga_wgfx (regbase, CL_GR30, op);	/* BLT mode */
+	vga_wgfx(regbase, CL_GR30, op);	/* BLT mode */
 
 	/* BLT ROP: SrcCopy */
-	vga_wgfx (regbase, CL_GR32, 0x0d);	/* BLT ROP */
+	vga_wgfx(regbase, CL_GR32, 0x0d);	/* BLT ROP */
 
 	/* and finally: GO! */
-	vga_wgfx (regbase, CL_GR31, 0x02);	/* BLT Start/status */
+	vga_wgfx(regbase, CL_GR31, 0x02);	/* BLT Start/status */
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
-
 /**************************************************************************
  * bestclock() - determine closest possible clock lower(?) than the
  * desired pixel clock
  **************************************************************************/
-static void bestclock (long freq, long *best, long *nom,
+static void bestclock(long freq, long *best, long *nom,
 		       long *den, long *div, long maxfreq)
 {
 	long n, h, d, f;
 
-	assert (best != NULL);
-	assert (nom != NULL);
-	assert (den != NULL);
-	assert (div != NULL);
-	assert (maxfreq > 0);
+	assert(best != NULL);
+	assert(nom != NULL);
+	assert(den != NULL);
+	assert(div != NULL);
+	assert(maxfreq > 0);
 
 	*nom = 0;
 	*den = 0;
 	*div = 0;
 
-	DPRINTK ("ENTER\n");
+	DPRINTK("ENTER\n");
 
 	if (freq < 8000)
 		freq = 8000;
@@ -3085,7 +3267,7 @@ static void bestclock (long freq, long *
 			if (d > 31)
 				d = (d / 2) * 2;
 			h = (14318 * n) / d;
-			if (abs (h - freq) < abs (*best - freq)) {
+			if (abs(h - freq) < abs(*best - freq)) {
 				*best = h;
 				*nom = n;
 				if (d < 32) {
@@ -3102,7 +3284,7 @@ static void bestclock (long freq, long *
 			if (d > 31)
 				d = (d / 2) * 2;
 			h = (14318 * n) / d;
-			if (abs (h - freq) < abs (*best - freq)) {
+			if (abs(h - freq) < abs(*best - freq)) {
 				*best = h;
 				*nom = n;
 				if (d < 32) {
@@ -3116,14 +3298,13 @@ static void bestclock (long freq, long *
 		}
 	}
 
-	DPRINTK ("Best possible values for given frequency:\n");
-	DPRINTK ("        best: %ld kHz  nom: %ld  den: %ld  div: %ld\n",
-		 freq, *nom, *den, *div);
+	DPRINTK("Best possible values for given frequency:\n");
+	DPRINTK("	best: %ld kHz  nom: %ld  den: %ld  div: %ld\n",
+		freq, *nom, *den, *div);
 
-	DPRINTK ("EXIT\n");
+	DPRINTK("EXIT\n");
 }
 
-
 /* -------------------------------------------------------------------------
  *
  * debugging functions
@@ -3145,21 +3326,20 @@ static void bestclock (long freq, long *
  */
 
 static
-void cirrusfb_dbg_print_byte (const char *name, unsigned char val)
+void cirrusfb_dbg_print_byte(const char *name, unsigned char val)
 {
-	DPRINTK ("%8s = 0x%02X (bits 7-0: %c%c%c%c%c%c%c%c)\n",
-		 name, val,
-		 val & 0x80 ? '1' : '0',
-		 val & 0x40 ? '1' : '0',
-		 val & 0x20 ? '1' : '0',
-		 val & 0x10 ? '1' : '0',
-		 val & 0x08 ? '1' : '0',
-		 val & 0x04 ? '1' : '0',
-		 val & 0x02 ? '1' : '0',
-		 val & 0x01 ? '1' : '0');
+	DPRINTK("%8s = 0x%02X (bits 7-0: %c%c%c%c%c%c%c%c)\n",
+		name, val,
+		val & 0x80 ? '1' : '0',
+		val & 0x40 ? '1' : '0',
+		val & 0x20 ? '1' : '0',
+		val & 0x10 ? '1' : '0',
+		val & 0x08 ? '1' : '0',
+		val & 0x04 ? '1' : '0',
+		val & 0x02 ? '1' : '0',
+		val & 0x01 ? '1' : '0');
 }
 
-
 /**
  * cirrusfb_dbg_print_regs
  * @base: If using newmmio, the newmmio base address, otherwise %NULL
@@ -3172,25 +3352,26 @@ void cirrusfb_dbg_print_byte (const char
  */
 
 static
-void cirrusfb_dbg_print_regs (caddr_t regbase, cirrusfb_dbg_reg_class_t reg_class,...)
+void cirrusfb_dbg_print_regs(caddr_t regbase,
+			     cirrusfb_dbg_reg_class_t reg_class, ...)
 {
 	va_list list;
 	unsigned char val = 0;
 	unsigned reg;
 	char *name;
 
-	va_start (list, reg_class);
+	va_start(list, reg_class);
 
-	name = va_arg (list, char *);
+	name = va_arg(list, char *);
 	while (name != NULL) {
-		reg = va_arg (list, int);
+		reg = va_arg(list, int);
 
 		switch (reg_class) {
 		case CRT:
-			val = vga_rcrt (regbase, (unsigned char) reg);
+			val = vga_rcrt(regbase, (unsigned char) reg);
 			break;
 		case SEQ:
-			val = vga_rseq (regbase, (unsigned char) reg);
+			val = vga_rseq(regbase, (unsigned char) reg);
 			break;
 		default:
 			/* should never occur */
@@ -3198,15 +3379,14 @@ void cirrusfb_dbg_print_regs (caddr_t re
 			break;
 		}
 
-		cirrusfb_dbg_print_byte (name, val);
+		cirrusfb_dbg_print_byte(name, val);
 
-		name = va_arg (list, char *);
+		name = va_arg(list, char *);
 	}
 
-	va_end (list);
+	va_end(list);
 }
 
-
 /**
  * cirrusfb_dump
  * @cirrusfbinfo:
@@ -3214,13 +3394,11 @@ void cirrusfb_dbg_print_regs (caddr_t re
  * DESCRIPTION:
  */
 
-static
-void cirrusfb_dump (void)
+static void cirrusfb_dump(void)
 {
-	cirrusfb_dbg_reg_dump (NULL);
+	cirrusfb_dbg_reg_dump(NULL);
 }
 
-
 /**
  * cirrusfb_dbg_reg_dump
  * @base: If using newmmio, the newmmio base address, otherwise %NULL
@@ -3232,11 +3410,11 @@ void cirrusfb_dump (void)
  */
 
 static
-void cirrusfb_dbg_reg_dump (caddr_t regbase)
+void cirrusfb_dbg_reg_dump(caddr_t regbase)
 {
-	DPRINTK ("CIRRUSFB VGA CRTC register dump:\n");
+	DPRINTK("CIRRUSFB VGA CRTC register dump:\n");
 
-	cirrusfb_dbg_print_regs (regbase, CRT,
+	cirrusfb_dbg_print_regs(regbase, CRT,
 			   "CR00", 0x00,
 			   "CR01", 0x01,
 			   "CR02", 0x02,
@@ -3286,11 +3464,11 @@ void cirrusfb_dbg_reg_dump (caddr_t regb
 			   "CR3F", 0x3F,
 			   NULL);
 
-	DPRINTK ("\n");
+	DPRINTK("\n");
 
-	DPRINTK ("CIRRUSFB VGA SEQ register dump:\n");
+	DPRINTK("CIRRUSFB VGA SEQ register dump:\n");
 
-	cirrusfb_dbg_print_regs (regbase, SEQ,
+	cirrusfb_dbg_print_regs(regbase, SEQ,
 			   "SR00", 0x00,
 			   "SR01", 0x01,
 			   "SR02", 0x02,
@@ -3319,7 +3497,7 @@ void cirrusfb_dbg_reg_dump (caddr_t regb
 			   "SR1F", 0x1F,
 			   NULL);
 
-	DPRINTK ("\n");
+	DPRINTK("\n");
 }
 
 #endif				/* CIRRUSFB_DEBUG */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
git-alsa.patch
git-arm-master.patch
git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
