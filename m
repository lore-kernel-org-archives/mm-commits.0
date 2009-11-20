From: akpm@linux-foundation.org
Subject: + i810fb-fix-stack-exploding.patch added to -mm tree
Date: Fri, 20 Nov 2009 13:21:30 -0800
Message-ID: <200911202121.nAKLLUHo019204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755287AbZKTVV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 16:21:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, alan@linux.intel.com


The patch titled
     i810fb: fix stack exploding
has been added to the -mm tree.  Its filename is
     i810fb-fix-stack-exploding.patch

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
Subject: i810fb: fix stack exploding
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Alan Cox has found that the i810fb function "uses a whopping 2.5K of stack".

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Reported-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810_dvt.c |   53 +++++++++++++++++---------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff -puN drivers/video/i810/i810_dvt.c~i810fb-fix-stack-exploding drivers/video/i810/i810_dvt.c
--- a/drivers/video/i810/i810_dvt.c~i810fb-fix-stack-exploding
+++ a/drivers/video/i810/i810_dvt.c
@@ -212,24 +212,29 @@ inline void round_off_yres(u32 *xres, u3
 	*yres = (*xres * 3) >> 2;
 }
 
-void i810fb_encode_registers(const struct fb_var_screeninfo *var,
-			     struct i810fb_par *par, u32 xres, u32 yres)
+static int i810fb_find_best_mode(u32 xres, u32 yres, u32 pixclock)
 { 
 	u32 diff = 0, diff_best = 0xFFFFFFFF, i = 0, i_best = 0; 
-	u8 hfl;
+	u8 hfl = (u8) ((xres >> 3) - 1);
 
-	hfl = (u8) ((xres >> 3) - 1);
 	for (i = 0; i < ARRAY_SIZE(std_modes); i++) { 
 		if (std_modes[i].cr01 == hfl) { 
-			if (std_modes[i].pixclock <= par->regs.pixclock)
-				diff = par->regs.pixclock - 
-					std_modes[i].pixclock;
+			if (std_modes[i].pixclock <= pixclock)
+				diff = pixclock - std_modes[i].pixclock;
 			if (diff < diff_best) {	 
 		    		i_best = i;
 		    		diff_best = diff;
 			}
 		}
 	}
+	return i_best;
+}
+
+void i810fb_encode_registers(const struct fb_var_screeninfo *var,
+			     struct i810fb_par *par, u32 xres, u32 yres)
+{
+	u32 i_best = i810fb_find_best_mode(xres, yres, par->regs.pixclock);
+
 	par->regs = std_modes[i_best];
 
 	/* overlay */
@@ -239,36 +244,36 @@ void i810fb_encode_registers(const struc
 
 void i810fb_fill_var_timings(struct fb_var_screeninfo *var)
 {
-	struct i810fb_par par;
 	u32 total, xres, yres;
+	u32 mode, pixclock;
 
 	xres = var->xres;
 	yres = var->yres;
 	
-	par.regs.pixclock = 1000000000/var->pixclock;
-	i810fb_encode_registers(var, &par, xres, yres);
+	pixclock = 1000000000 / var->pixclock;
+	mode = i810fb_find_best_mode(xres, yres, pixclock);
 	
-	total = ((par.regs.cr00 | (par.regs.cr35 & 1) << 8) + 3) << 3;
+	total = (std_modes[mode].cr00 | (std_modes[mode].cr35 & 1) << 8) + 3;
+	total <<= 3;
 	
-	var->pixclock = 1000000000/par.regs.pixclock;
-	var->right_margin = (par.regs.cr04 << 3) - xres;
-	var->hsync_len = ((par.regs.cr05 & 0x1F) - 
-			       (par.regs.cr04 & 0x1F)) << 3;
+	var->pixclock = 1000000000 / std_modes[mode].pixclock;
+	var->right_margin = (std_modes[mode].cr04 << 3) - xres;
+	var->hsync_len = ((std_modes[mode].cr05 & 0x1F) -
+			 (std_modes[mode].cr04 & 0x1F)) << 3;
 	var->left_margin = (total - (xres + var->right_margin + 
 				     var->hsync_len));
 	var->sync = FB_SYNC_ON_GREEN;
-	if (~(par.regs.msr & (1 << 6)))
+	if (~(std_modes[mode].msr & (1 << 6)))
 		var->sync |= FB_SYNC_HOR_HIGH_ACT;
-	if (~(par.regs.msr & (1 << 7)))
+	if (~(std_modes[mode].msr & (1 << 7)))
 		var->sync |= FB_SYNC_VERT_HIGH_ACT;
 
