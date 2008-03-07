From: akpm@linux-foundation.org
Subject: + pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch added to -mm tree
Date: Thu, 06 Mar 2008 23:59:13 -0800
Message-ID: <200803070759.m277xDro012020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760749AbYCGH7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 02:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk


The patch titled
     pxafb: sanitize the usage of #ifdef .. processing pxafb parameters
has been added to the -mm tree.  Its filename is
     pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: sanitize the usage of #ifdef .. processing pxafb parameters
From: eric miao <eric.miao@marvell.com>

So to get a better coding style and centralize the pxafb parameters
handling code.

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   57 +++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters
+++ a/drivers/video/pxafb.c
@@ -70,11 +70,6 @@ static int pxafb_activate_var(struct fb_
 				struct pxafb_info *);
 static void set_ctrlr_state(struct pxafb_info *fbi, u_int state);
 
-#ifdef CONFIG_FB_PXA_PARAMETERS
-#define PXAFB_OPTIONS_SIZE 256
-static char g_options[PXAFB_OPTIONS_SIZE] __devinitdata = "";
-#endif
-
 static inline void pxafb_schedule_work(struct pxafb_info *fbi, u_int state)
 {
 	unsigned long flags;
@@ -1315,6 +1310,32 @@ static int __init pxafb_parse_options(st
 	}
 	return 0;
 }
+
+static char g_options[256] __devinitdata = "";
+
+#ifndef CONFIG_MODULES
+static int __devinit pxafb_setup_options(void)
+{
+	char *options = NULL;
+
+	if (fb_get_options("pxafb", &options))
+		return -ENODEV;
+
+	if (options)
+		strlcpy(g_options, options, sizeof(g_options));
+
+	return 0;
+}
+#else
+#define pxafb_setup_options()		(0)
+
+module_param_string(options, g_options, sizeof(g_options), 0);
+MODULE_PARM_DESC(options, "LCD parameters (see Documentation/fb/pxafb.txt)");
+#endif
+
+#else
+#define pxafb_parse_options(...)	(0)
+#define pxafb_setup_options()		(0)
 #endif
 
 static int __init pxafb_probe(struct platform_device *dev)
@@ -1331,11 +1352,9 @@ static int __init pxafb_probe(struct pla
 	if (!inf)
 		goto failed;
 
-#ifdef CONFIG_FB_PXA_PARAMETERS
 	ret = pxafb_parse_options(&dev->dev, g_options);
 	if (ret < 0)
 		goto failed;
-#endif
 
 #ifdef DEBUG_VAR
 	/* Check for various illegal bit-combinations. Currently only
@@ -1448,31 +1467,11 @@ static struct platform_driver pxafb_driv
 	},
 };
 
-#ifndef MODULE
-static int __devinit pxafb_setup(char *options)
-{
-# ifdef CONFIG_FB_PXA_PARAMETERS
-	if (options)
-		strlcpy(g_options, options, sizeof(g_options));
-# endif
-	return 0;
-}
-#else
-# ifdef CONFIG_FB_PXA_PARAMETERS
-module_param_string(options, g_options, sizeof(g_options), 0);
-MODULE_PARM_DESC(options, "LCD parameters (see Documentation/fb/pxafb.txt)");
-# endif
-#endif
-
 static int __devinit pxafb_init(void)
 {
-#ifndef MODULE
-	char *option = NULL;
+	if (pxafb_setup_options())
+		return -EINVAL;
 
-	if (fb_get_options("pxafb", &option))
-		return -ENODEV;
-	pxafb_setup(option);
-#endif
 	return platform_driver_register(&pxafb_driver);
 }
 
_

Patches currently in -mm which might be from eric.miao@marvell.com are

git-arm.patch
pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch
pxafb-fix-various-coding-style-issues-for-pxafb.patch
pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch
pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch
pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch
pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch
pxafb-introduce-register-independent-lcd-connection-type-for-pxafb.patch
pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch

