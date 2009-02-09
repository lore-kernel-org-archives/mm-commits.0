From: akpm@linux-foundation.org
Subject: + valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:46:55 -0800
Message-ID: <200902092346.n19NktSD005696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbZBIXrf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:47:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl


The patch titled
     valkyriefb: check fb_alloc_cmap return value and handle failure properly
has been added to the -mm tree.  Its filename is
     valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

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
Subject: valkyriefb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/valkyriefb.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/video/valkyriefb.c~valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/valkyriefb.c
--- a/drivers/video/valkyriefb.c~valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/valkyriefb.c
@@ -119,7 +119,7 @@ static void set_valkyrie_clock(unsigned 
 static int valkyrie_var_to_par(struct fb_var_screeninfo *var,
 	struct fb_par_valkyrie *par, const struct fb_info *fb_info);
 
-static void valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p);
+static int valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p);
 static void valkyrie_par_to_fix(struct fb_par_valkyrie *par, struct fb_fix_screeninfo *fix);
 static void valkyrie_init_fix(struct fb_fix_screeninfo *fix, struct fb_info_valkyrie *p);
 
@@ -381,18 +381,22 @@ int __init valkyriefb_init(void)
 
 	valkyrie_choose_mode(p);
 	mac_vmode_to_var(default_vmode, default_cmode, &p->info.var);
-	valkyrie_init_info(&p->info, p);
+	err = valkyrie_init_info(&p->info, p);
+	if (err < 0)
+		goto out_free;
 	valkyrie_init_fix(&p->info.fix, p);
 	if (valkyriefb_set_par(&p->info))
 		/* "can't happen" */
 		printk(KERN_ERR "valkyriefb: can't set default video mode\n");
 
 	if ((err = register_framebuffer(&p->info)) != 0)
-		goto out_free;
+		goto out_cmap_free;
 
 	printk(KERN_INFO "fb%d: valkyrie frame buffer device\n", p->info.node);
 	return 0;
 
+ out_cmap_free:
+	fb_dealloc_cmap(&p->info.cmap);
  out_free:
 	if (p->frame_buffer)
 		iounmap(p->frame_buffer);
@@ -538,14 +542,15 @@ static void valkyrie_par_to_fix(struct f
 		/* ywrapstep, xpanstep, ypanstep */
 }
 
-static void __init valkyrie_init_info(struct fb_info *info, struct fb_info_valkyrie *p)
+static int __init valkyrie_init_info(struct fb_info *info,
+		struct fb_info_valkyrie *p)
 {
 	info->fbops = &valkyriefb_ops;
 	info->screen_base = p->frame_buffer + 0x1000;
 	info->flags = FBINFO_DEFAULT;
 	info->pseudo_palette = p->pseudo_palette;
-	fb_alloc_cmap(&info->cmap, 256, 0);
 	info->par = &p->par;
+	return fb_alloc_cmap(&info->cmap, 256, 0);
 }
 
 
_

Patches currently in -mm which might be from dilinger@queued.net are

gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

