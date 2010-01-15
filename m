From: akpm@linux-foundation.org
Subject: + revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch added to -mm tree
Date: Thu, 14 Jan 2010 16:15:08 -0800
Message-ID: <201001150015.o0F0F8WQ008268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757881Ab0AOAQh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 19:16:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, ben-linux@fluff.org, inki.dae@samsung.com, kmpark@infradead.org, krzysztof.h1@poczta.fm, m.szyprowski@samsung.com, stable@kernel.org


The patch titled
     revert "drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer"
has been added to the -mm tree.  Its filename is
     revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch

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
Subject: revert "drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer"
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Fix divide by zero and broken output Commit
600ce1a0faafeed1ce6bcfd421bc040b941cbbc1.  ("fix clock setting for Samsung
SoC Framebuffer") introduced a mandatory refresh parameter to the platform
data for the S3C framebuffer but did not introduce any validation code,
causing existing platforms (none of which have refresh set) to divide by
zero whenever the framebuffer is configured, generating warnings and
unusable output.

Ben Dooks noted several problems with the patch:

 - The platform data supplies the pixclk directly and should already
   have taken care of the refresh rate.
 - The addition of a window ID parameter doesn't help since only the
   root framebuffer can control the pixclk.
 - pixclk is specified in picoseconds (rather than Hz) as the patch
   assumed.

and suggests reverting the commit so do that.  Without fixing this no
mainline user of the driver will produce output.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/video/s3c-fb.c~revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer
+++ a/drivers/video/s3c-fb.c
@@ -211,21 +211,23 @@ static int s3c_fb_check_var(struct fb_va
 
 /**
  * s3c_fb_calc_pixclk() - calculate the divider to create the pixel clock.
- * @id: window id.
  * @sfb: The hardware state.
  * @pixclock: The pixel clock wanted, in picoseconds.
  *
  * Given the specified pixel clock, work out the necessary divider to get
  * close to the output frequency.
  */
-static int s3c_fb_calc_pixclk(unsigned char id, struct s3c_fb *sfb, unsigned int pixclk)
+static int s3c_fb_calc_pixclk(struct s3c_fb *sfb, unsigned int pixclk)
 {
-	struct s3c_fb_pd_win *win = sfb->pdata->win[id];
 	unsigned long clk = clk_get_rate(sfb->bus_clk);
+	unsigned long long tmp;
 	unsigned int result;
 
-	pixclk *= win->win_mode.refresh;
-	result = clk / pixclk;
+	tmp = (unsigned long long)clk;
+	tmp *= pixclk;
+
+	do_div(tmp, 1000000000UL);
+	result = (unsigned int)tmp / 1000;
 
 	dev_dbg(sfb->dev, "pixclk=%u, clk=%lu, div=%d (%lu)\n",
 		pixclk, clk, result, clk / result);
@@ -265,7 +267,6 @@ static int s3c_fb_set_par(struct fb_info
 	struct s3c_fb *sfb = win->parent;
 	void __iomem *regs = sfb->regs;
 	int win_no = win->index;
-	u32 osdc_data = 0;
 	u32 data;
 	u32 pagewidth;
 	int clkdiv;
@@ -301,7 +302,7 @@ static int s3c_fb_set_par(struct fb_info
 	/* use window 0 as the basis for the lcd output timings */
 
 	if (win_no == 0) {
-		clkdiv = s3c_fb_calc_pixclk(win_no, sfb, var->pixclock);
+		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
 
 		data = sfb->pdata->vidcon0;
 		data &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);
@@ -358,6 +359,8 @@ static int s3c_fb_set_par(struct fb_info
 
 	data = var->xres * var->yres;
 
+	u32 osdc_data = 0;
+
 	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
 		VIDISD14C_ALPHA1_G(0xf) |
 		VIDISD14C_ALPHA1_B(0xf);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch

