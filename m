From: akpm@linux-foundation.org
Subject: - atyfb-report-probe-errors.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:35 -0700
Message-ID: <200807242332.m6ONWZMv011848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbYGXXcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     atyfb: report probe errors
has been removed from the -mm tree.  Its filename was
     atyfb-report-probe-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atyfb: report probe errors
From: Ville Syrjala <syrjala@sci.fi>

Properly propagate errors to the probe function.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-report-probe-errors drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-report-probe-errors
+++ a/drivers/video/aty/atyfb_base.c
@@ -2231,6 +2231,7 @@ static int __devinit aty_init(struct fb_
 	const char *ramname = NULL, *xtal;
 	int gtb_memsize, has_var = 0;
 	struct fb_var_screeninfo var;
+	int ret;
 
 	init_waitqueue_head(&par->vblank.wait);
 	spin_lock_init(&par->int_lock);
@@ -2612,7 +2613,8 @@ static int __devinit aty_init(struct fb_
 			var.yres_virtual = var.yres;
 	}
 
-	if (atyfb_check_var(&var, info)) {
+	ret = atyfb_check_var(&var, info);
+	if (ret) {
 		PRINTKE("can't set default video mode\n");
 		goto aty_init_exit;
 	}
@@ -2623,10 +2625,12 @@ static int __devinit aty_init(struct fb_
 #endif /* CONFIG_FB_ATY_CT */
 	info->var = var;
 
-	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
+	ret = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (ret < 0)
 		goto aty_init_exit;
 
-	if (register_framebuffer(info) < 0) {
+	ret = register_framebuffer(info);
+	if (ret < 0) {
 		fb_dealloc_cmap(&info->cmap);
 		goto aty_init_exit;
 	}
@@ -2652,7 +2656,7 @@ aty_init_exit:
 	    par->mtrr_aper = -1;
 	}
 #endif
-	return -1;
+	return ret;
 }
 
 static void aty_resume_chip(struct fb_info *info)
@@ -3467,7 +3471,8 @@ static int __devinit atyfb_pci_probe(str
 	pci_set_drvdata(pdev, info);
 
 	/* Init chip & register framebuffer */
-	if (aty_init(info))
+	rc = aty_init(info);
+	if (rc)
 		goto err_release_io;
 
 #ifdef __sparc__
_

Patches currently in -mm which might be from syrjala@sci.fi are

origin.patch

