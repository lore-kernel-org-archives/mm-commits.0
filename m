From: akpm@linux-foundation.org
Subject: - pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:07 -0700
Message-ID: <200805010925.m419P7vw030169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277AbYEAJZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: sanitize the usage of #ifdef .. processing pxafb parameters
has been removed from the -mm tree.  Its filename was
     pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -71,11 +71,6 @@ static int pxafb_activate_var(struct fb_
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
@@ -1316,6 +1311,32 @@ static int __init pxafb_parse_options(st
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
@@ -1332,11 +1353,9 @@ static int __init pxafb_probe(struct pla
 	if (!inf)
 		goto failed;
 
-#ifdef CONFIG_FB_PXA_PARAMETERS
 	ret = pxafb_parse_options(&dev->dev, g_options);
 	if (ret < 0)
 		goto failed;
-#endif
 
 #ifdef DEBUG_VAR
 	/* Check for various illegal bit-combinations. Currently only
@@ -1449,31 +1468,11 @@ static struct platform_driver pxafb_driv
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
