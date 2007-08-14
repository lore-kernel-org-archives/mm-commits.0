From: akpm@linux-foundation.org
Subject: - pvr2fb-consolidated-cleanup-of-pvr2fbc.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:39 -0700
Message-ID: <200708140502.l7E52dxV031991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765983AbXHNFLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adrian@mcmen.demon.co.uk, adaplas@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     pvr2fb: Consolidated cleanup of pvr2fb.c
has been removed from the -mm tree.  Its filename was
     pvr2fb-consolidated-cleanup-of-pvr2fbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pvr2fb: Consolidated cleanup of pvr2fb.c
From: Adrian McMenamin <adrian@mcmen.demon.co.uk>

- better handling of the pvr2 registers based on more up to date information.

Testing shows that it seems to work pretty well at 16bpp, 24bpp and 32bpp -
including proper rendering of the boot logo at all levels (previously this was
a bit broken even at 16bpp) and giving white against black text.  Really
detailed testing (eg with X11) requires support for the maple bus - which
isn't (currently - next project assuming this is okay) available, but I have
no reason to think this is broken.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pvr2fb.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/video/pvr2fb.c~pvr2fb-consolidated-cleanup-of-pvr2fbc drivers/video/pvr2fb.c
--- a/drivers/video/pvr2fb.c~pvr2fb-consolidated-cleanup-of-pvr2fbc
+++ a/drivers/video/pvr2fb.c
@@ -94,6 +94,7 @@
 #define DISP_DIWCONF (DISP_BASE + 0xe8)
 #define DISP_DIWHSTRT (DISP_BASE + 0xec)
 #define DISP_DIWVSTRT (DISP_BASE + 0xf0)
+#define DISP_PIXDEPTH (DISP_BASE + 0x108)
 
 /* Pixel clocks, one for TV output, doubled for VGA output */
 #define TV_CLK 74239
@@ -600,6 +601,7 @@ static void pvr2_init_display(struct fb_
 
 	/* bits per pixel */
 	fb_writel(fb_readl(DISP_DIWMODE) | (--bytesperpixel << 2), DISP_DIWMODE);
+	fb_writel(bytesperpixel << 2, DISP_PIXDEPTH);
 
 	/* video enable, color sync, interlace,
 	 * hsync and vsync polarity (currently unused) */
@@ -808,6 +810,8 @@ static int __devinit pvr2fb_common_init(
 
 	if (register_framebuffer(fb_info) < 0)
 		goto out_err;
+	/*Must write PIXDEPTH to register before anything is displayed - so force init */
+	pvr2_init_display(fb_info);
 
 	modememused = get_line_length(fb_info->var.xres_virtual,
 				      fb_info->var.bits_per_pixel);
_

Patches currently in -mm which might be from adrian@mcmen.demon.co.uk are
