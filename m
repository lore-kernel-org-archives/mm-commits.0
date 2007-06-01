From: akpm@linux-foundation.org
Subject: - skeletonfb-fix-of-xxxfb_setup-ifdef.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:47:30 -0700
Message-ID: <200706011747.l51HlTXa015129@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761289AbXFARri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     skeletonfb: fix of xxxfb_setup ifdef
has been removed from the -mm tree.  Its filename was
     skeletonfb-fix-of-xxxfb_setup-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: skeletonfb: fix of xxxfb_setup ifdef
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes wrong ifdef around the xxxfb_setup. It also moves this
function to remove forward declaration.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-fix-of-xxxfb_setup-ifdef drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-fix-of-xxxfb_setup-ifdef
+++ a/drivers/video/skeletonfb.c
@@ -132,7 +132,6 @@ static struct fb_info info;
 static struct xxx_par __initdata current_par;
 
 int xxxfb_init(void);
-int xxxfb_setup(char*);
 
 /**
  *	xxxfb_open - Optional function. Called when the framebuffer is
@@ -975,6 +974,21 @@ static struct platform_device xxxfb_devi
 	.name = "xxxfb",
 };
 
+#ifndef MODULE
+    /*
+     *  Setup
+     */
+
+/*
+ * Only necessary if your driver takes special options,
+ * otherwise we fall back on the generic fb_setup().
+ */
+int __init xxxfb_setup(char *options)
+{
+    /* Parse user speficied options (`video=xxxfb:') */
+}
+#endif /* MODULE */
+
 static int __init xxxfb_init(void)
 {
 	int ret;
@@ -1006,21 +1020,6 @@ static void __exit xxxfb_exit(void)
 }
 #endif /* CONFIG_PCI */
 
-#ifdef MODULE
-    /*
-     *  Setup
-     */
-
-/* 
- * Only necessary if your driver takes special options,
- * otherwise we fall back on the generic fb_setup().
- */
-int __init xxxfb_setup(char *options)
-{
-    /* Parse user speficied options (`video=xxxfb:') */
-}
-#endif /* MODULE */
-
 /* ------------------------------------------------------------------------- */
 
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fbcon-smart-blitter-usage-for-scrolling.patch
pm2fb-white-spaces-clean-up.patch
