From: akpm@osdl.org
Subject: + remove-references-to-non-existent.patch added to -mm tree
Date: Mon, 11 Dec 2006 14:26:51 -0800
Message-ID: <200612112226.kBBMQpUu010276@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:43320 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937679AbWLKW1U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 17:27:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, jsimmons@infradead.org


The patch titled
     fbdev: remove references to non-existent fbmon_valid_timings()
has been added to the -mm tree.  Its filename is
     remove-references-to-non-existent.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: remove references to non-existent fbmon_valid_timings()
From: Geert Uytterhoeven <geert@linux-m68k.org>

Remove references to non-existent fbmon_valid_timings()

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/amifb.c          |    8 --------
 drivers/video/aty/atyfb_base.c |    4 ----
 include/linux/fb.h             |    2 --
 3 files changed, 14 deletions(-)

diff -puN drivers/video/amifb.c~remove-references-to-non-existent drivers/video/amifb.c
--- a/drivers/video/amifb.c~remove-references-to-non-existent
+++ a/drivers/video/amifb.c
@@ -2906,14 +2906,6 @@ static int ami_decode_var(struct fb_var_
 	par->crsr.spot_x = par->crsr.spot_y = 0;
 	par->crsr.height = par->crsr.width = 0;
 
-#if 0	/* fbmon not done.  uncomment for 2.5.x -brad */
-	if (!fbmon_valid_timings(pixclock[clk_shift], htotal, vtotal,
-				 &fb_info)) {
-		DPRINTK("mode doesn't fit for monitor\n");
-		return -EINVAL;
-	}
-#endif
-
 	return 0;
 }
 
diff -puN drivers/video/aty/atyfb_base.c~remove-references-to-non-existent drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~remove-references-to-non-existent
+++ a/drivers/video/aty/atyfb_base.c
@@ -1488,10 +1488,6 @@ static int atyfb_check_var(struct fb_var
 	else
 		info->var.accel_flags = 0;
 
-#if 0 /* fbmon is not done. uncomment for 2.5.x -brad */
-	if (!fbmon_valid_timings(pixclock, htotal, vtotal, info))
-		return -EINVAL;
-#endif
 	aty_crtc_to_var(&crtc, var);
 	var->pixclock = par->pll_ops->pll_to_var(info, &pll);
 	return 0;
diff -puN include/linux/fb.h~remove-references-to-non-existent include/linux/fb.h
--- a/include/linux/fb.h~remove-references-to-non-existent
+++ a/include/linux/fb.h
@@ -929,8 +929,6 @@ extern void fb_bl_default_curve(struct f
 #define FB_MODE_IS_FIRST	16
 #define FB_MODE_IS_FROM_VAR     32
 
-extern int fbmon_valid_timings(u_int pixclock, u_int htotal, u_int vtotal,
-			       const struct fb_info *fb_info);
 extern int fbmon_dpms(const struct fb_info *fb_info);
 extern int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var,
 		       struct fb_info *info);
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
m68k-work-around-binutils-tokenizer-change.patch
remove-references-to-non-existent.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

