From: akpm@linux-foundation.org
Subject: [merged] revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:28:25 -0800
Message-ID: <201001212128.o0LLSPsD030717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755377Ab0AUV3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, ben-linux@fluff.org, inki.dae@samsung.com, kmpark@infradead.org, krzysztof.h1@poczta.fm, m.szyprowski@samsung.com, stable@kernel.org, mm-commits@v


The patch titled
     revert "drivers/video/s3c-fb.c: fix clock setting for Samsung SoC Framebuffer"
has been removed from the -mm tree.  Its filename was
     revert-drivers-video-s3c-fbc-fix-clock-setting-for-samsung-soc-framebuffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: don't revert the correct bit]
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

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
@@ -301,7 +303,7 @@ static int s3c_fb_set_par(struct fb_info
 	/* use window 0 as the basis for the lcd output timings */
 
 	if (win_no == 0) {
-		clkdiv = s3c_fb_calc_pixclk(win_no, sfb, var->pixclock);
+		clkdiv = s3c_fb_calc_pixclk(sfb, var->pixclock);
 
 		data = sfb->pdata->vidcon0;
 		data &= ~(VIDCON0_CLKVAL_F_MASK | VIDCON0_CLKDIR);
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

