From: akpm@linux-foundation.org
Subject: [merged] samsung-soc-framebuffer-driver-add-alpha-channel-support.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:22 -0700
Message-ID: <200906171839.n5HIdMlK005454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760797AbZFQSkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:40:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeinki@gmail.com, ben-linux@fluff.org, inki.dae@samsung.com, kmpark@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Samsung SoC Framebuffer driver: add Alpha Channel support  
has been removed from the -mm tree.  Its filename was
     samsung-soc-framebuffer-driver-add-alpha-channel-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Samsung SoC Framebuffer driver: add Alpha Channel support  
From: InKi Dae <daeinki@gmail.com>

Add support for the ARGB1888 and ARGB4888 hardware to the Samsung SoC
Framebuffer driver (s3c-fb.c).

ARGB1888 and ARGB4888 is decided by var->transp.length and this variable
is set by s3c_fb_check_var().

In s3c_fb_check_var(), if var->vits_per_pixel is 25 or 28, then
var->transp.length would be 1 or 3.

Therefore alpha mode(ARGB1888 or ARGB4888) could be decided through that
variable.

For using alpha mode, you need to set the following: This code should be
added to your machine code as platform data.

static struct s3c_fb_pd_win xxx_fb_win0 = {
	/* this is to ensure we use win0 */
	.win_mode = {
		.pixclock		= (8+8+8+240)*(38+4+38+400),
		.left_margin	= 8,
		.right_margin	= 8,
		.upper_margin	= 38,
		.lower_margin	= 38,
		.hsync_len		= 8,
		.vsync_len		= 4,
		.xres			= 240,
		.yres			= 400,
	},
	.max_bpp		= 32,
	.default_bpp	= 24,
};

static struct s3c_fb_pd_win xxx_fb_win1 = {
	.win_mode = {
		.pixclock		= (8+8+8+240)*(38+4+38+400),
		.left_margin	= 8,
		.right_margin	= 8,
		.upper_margin	= 38,
		.lower_margin	= 38,
		.hsync_len		= 8,
		.vsync_len		= 4,
		.xres			= 240,
		.yres			= 400,
	},
	.max_bpp		= 32,
	.default_bpp	= 28,
};


static struct s3c_fb_platdata xxx_lcd_pdata __initdata = {
	.win[0]		= &ncp_fb_win0,
	.win[1]		= &ncp_fb_win1,
	.vidcon0	= VIDCON0_VIDOUT_RGB | VIDCON0_PNRMODE_RGB,
	.vidcon1	= VIDCON1_INV_HSYNC | VIDCON1_INV_VSYNC,
	.setup_gpio	= xxx_fb_gpio_setup,
};

s3c_fb_set_platdata(&xxx_lcd_pdata);


The above code sets pixelformat for window0 layer to RGB888 and window1
layer to ARGB4888.

Signed-off-by: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kyungmin Park <kmpark@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff -puN drivers/video/s3c-fb.c~samsung-soc-framebuffer-driver-add-alpha-channel-support drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~samsung-soc-framebuffer-driver-add-alpha-channel-support
+++ a/drivers/video/s3c-fb.c
@@ -358,9 +358,16 @@ static int s3c_fb_set_par(struct fb_info
 	writel(data, regs + VIDOSD_B(win_no));
 
 	data = var->xres * var->yres;
+
+	u32 osdc_data = 0;
+
+	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
+		VIDISD14C_ALPHA1_G(0xf) |
+		VIDISD14C_ALPHA1_B(0xf);
+
 	if (s3c_fb_has_osd_d(win_no)) {
 		writel(data, regs + VIDOSD_D(win_no));
-		writel(0, regs + VIDOSD_C(win_no));
+		writel(osdc_data, regs + VIDOSD_C(win_no));
 	} else
 		writel(data, regs + VIDOSD_C(win_no));
 
@@ -409,8 +416,12 @@ static int s3c_fb_set_par(struct fb_info
 				data |= WINCON1_BPPMODE_19BPP_A1666;
 			else
 				data |= WINCON1_BPPMODE_18BPP_666;
-		} else if (var->transp.length != 0)
-			data |= WINCON1_BPPMODE_25BPP_A1888;
+		} else if (var->transp.length == 1)
+			data |= WINCON1_BPPMODE_25BPP_A1888
+				| WINCON1_BLD_PIX;
+		else if (var->transp.length == 4)
+			data |= WINCON1_BPPMODE_28BPP_A4888
+				| WINCON1_BLD_PIX | WINCON1_ALPHA_SEL;
 		else
 			data |= WINCON0_BPPMODE_24BPP_888;
 
@@ -418,6 +429,20 @@ static int s3c_fb_set_par(struct fb_info
 		break;
 	}
 
+	/* It has no color key control register for window0 */
+	if (win_no > 0) {
+		u32 keycon0_data = 0, keycon1_data = 0;
+
+		keycon0_data = ~(WxKEYCON0_KEYBL_EN |
+				WxKEYCON0_KEYEN_F |
+				WxKEYCON0_DIRCON) | WxKEYCON0_COMPKEY(0);
+
+		keycon1_data = WxKEYCON1_COLVAL(0xffffff);
+
+		writel(keycon0_data, regs + WxKEYCONy(win_no-1, 0));
+		writel(keycon1_data, regs + WxKEYCONy(win_no-1, 1));
+	}
+
 	writel(data, regs + WINCON(win_no));
 	writel(0x0, regs + WINxMAP(win_no));
 
_

Patches currently in -mm which might be from daeinki@gmail.com are

origin.patch

