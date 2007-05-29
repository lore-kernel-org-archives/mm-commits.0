From: akpm@linux-foundation.org
Subject: + skeletonfb-fix-of-xxxfb_setup-ifdef.patch added to -mm tree
Date: Tue, 29 May 2007 15:51:44 -0700
Message-ID: <200705292251.l4TMpjso013630@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbXE2Wvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     skeletonfb: fix of xxxfb_setup ifdef
has been added to the -mm tree.  Its filename is
     skeletonfb-fix-of-xxxfb_setup-ifdef.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 15 insertions(+), 16 deletions(-)

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

skeletonfb-fix-of-xxxfb_setup-ifdef.patch
fbcon-smart-blitter-usage-for-scrolling.patch
