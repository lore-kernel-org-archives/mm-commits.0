From: akpm@linux-foundation.org
Subject: + drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch added to -mm tree
Date: Thu, 02 Jul 2009 15:01:09 -0700
Message-ID: <200907022201.n62M19kx028563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbZGBWB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 18:01:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daeinki@gmail.com, inki.dae@samsung.com, kmpark@infradead.org, krzysztof.h1@poczta.fm, m.szyprowski@samsung.com


The patch titled
     drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer
has been added to the -mm tree.  Its filename is
     drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch

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
Subject: drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer
From: InKi Dae <daeinki@gmail.com>

Correct the CLKVAL_F field value of VIDEO MAIN CONTROLLER 0 REGITSTER.

Frame Rate is 1 / [ { (VSPW+1) + (VBPD+1) + (LIINEVAL + 1) + (VFPD+1)
} x {(HSPW+1) + (HBPD +1)
+ (HFPD+1) + (HOZVAL + 1) } x { ( CLKVAL+1 ) / ( Frequency of Clock
source ) } ] and VCLK = Video Clock Source / (CLKVAL +1).

therefore CLKVAL_F should be "CLKVAL_F = Frequency of Clock source / pixel
clock * refresh".

for this, I added refresh value in platform data like below.

static struct s3c_fb_pd_win xxx_fb_win0 = {
	/* this is to ensure we use win0 */
	.win_mode = {
		.refresh	= 60,
		.pixclock	= (66+4+2+480)*(15+5+3+800),
		.left_margin	= 66,
		.right_margin	= 2,
		.upper_margin	= 15,
		.lower_margin	= 3,
		.hsync_len	= 4,
		.vsync_len	= 5,
		.xres		= 480,
		.yres		= 800,
	},
	.max_bpp	= 32,
	.default_bpp	= 24,
};

static struct s3c_fb_platdata xxx_lcd_pdata __initdata = {
	.win[0]		= &xxx_fb_win0,
	.vidcon0	= VIDCON0_VIDOUT_RGB | VIDCON0_PNRMODE_RGB,
	.vidcon1	= VIDCON1_INV_HSYNC | VIDCON1_INV_VSYNC
			| VIDCON1_INV_VCLK | VIDCON1_INV_VDEN,
	.setup_gpio	= s5pc1xx_fb_gpio_setup_24bpp,
};

xxx_machine_init()
{
                   .
                   .
                   .
               s3c_fb_set_platdata(&xxx_lcd_pdata);
}

platform data defined in machine code should be setting using
s3c_fb_set_platdata().

Signed-off-by: InKi Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/video/s3c-fb.c~drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer
+++ a/drivers/video/s3c-fb.c
@@ -211,23 +211,21 @@ static int s3c_fb_check_var(struct fb_va
 
 /**
  * s3c_fb_calc_pixclk() - calculate the divider to create the pixel clock.
+ * @id: window id.
  * @sfb: The hardware state.
  * @pixclock: The pixel clock wanted, in picoseconds.
  *
  * Given the specified pixel clock, work out the necessary divider to get
  * close to the output frequency.
  */
-static int s3c_fb_calc_pixclk(struct s3c_fb *sfb, unsigned int pixclk)
+static int s3c_fb_calc_pixclk(unsigned char id, struct s3c_fb *sfb, unsigned int pixclk)
 {
+	struct s3c_fb_pd_win *win = sfb->pdata->win[id];
 	unsigned long clk = clk_get_rate(sfb->bus_clk);
-	unsigned long long tmp;
 	unsigned int result;
 
-	tmp = (unsigned long long)clk;
-	tmp *= pixclk;
-
-	do_div(tmp, 1000000000UL);
-	result = (unsigned int)tmp / 1000;
+	pixclk *= win->win_mode.refresh;
+	result = clk / pixclk;
 
 	dev_dbg(sfb->dev, "pixclk=%u, clk=%lu, div=%d (%lu)\n",
 		pixclk, clk, result, clk / result);
@@ -267,6 +265,7 @@ static int s3c_fb_set_par(struct fb_info
 	struct s3c_fb *sfb = win->parent;
 	void __iomem *regs = sfb->regs;
 	int win_no = win->index;
+	u32 osdc_data = 0;
 	u32 data;
 	u32 pagewidth;
 	int clkdiv;
@@ -302,7 +301,7 @@ static int s3c_fb_set_par(struct fb_info
 	/* use window 0 as the basis for the lcd output timings */
 
 	if (win_no == 0) {
-		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
+		clkdiv = s3c_fb_calc_pixclk(win_no, sfb, var->pixclock);
 
 		data = sfb->pdata->vidcon0;
 		data &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);
@@ -359,8 +358,6 @@ static int s3c_fb_set_par(struct fb_info
 
 	data = var->xres * var->yres;
 
-	u32 osdc_data = 0;
