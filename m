From: akpm@linux-foundation.org
Subject: + pm3fb-mtrr-support-and-noaccel-option.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:32 -0700
Message-ID: <200707261900.l6QJ0WA7015634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41346 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934964AbXGZTBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:01:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm3fb: mtrr support and noaccel option
has been added to the -mm tree.  Its filename is
     pm3fb-mtrr-support-and-noaccel-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: mtrr support and noaccel option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds usage of MTRR registers and two new options: noaccel and
nomtrr.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |   84 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 81 insertions(+), 3 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-mtrr-support-and-noaccel-option drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-mtrr-support-and-noaccel-option
+++ a/drivers/video/pm3fb.c
@@ -32,6 +32,9 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#ifdef CONFIG_MTRR
+#include <asm/mtrr.h>
+#endif
 
 #include <video/pm3fb.h>
 
@@ -52,6 +55,12 @@
  * Driver data
  */
 static char *mode_option __devinitdata;
+static int noaccel   __devinitdata = 0;
+
+/* mtrr option */
+#ifdef CONFIG_MTRR
+static int nomtrr __devinitdata = 0;
+#endif
 
 /*
  * This structure defines the hardware state of the graphics card. Normally
@@ -65,6 +74,7 @@ struct pm3_par {
 	u32		video;		/* video flags before blanking */
 	u32		base;		/* screen base (xoffset+yoffset) in 128 bits unit */
 	u32		palette[16];
+	int		mtrr_handle;
 };
 
 /*
@@ -788,6 +798,8 @@ static void pm3fb_write_mode(struct fb_i
 /*
  * hardware independent functions
  */
+int pm3fb_init(void);
+
 static int pm3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	u32 lpitch;
@@ -1244,6 +1256,13 @@ static int __devinit pm3fb_probe(struct 
 	}
 	info->screen_size = pm3fb_fix.smem_len;
 
+#ifdef CONFIG_MTRR
+	if (!nomtrr) {
+		par->mtrr_handle = mtrr_add(pm3fb_fix.smem_start,
+						pm3fb_fix.smem_len,
+						MTRR_TYPE_WRCOMB, 1);
+	}
+#endif
 	info->fbops = &pm3fb_ops;
 
 	par->video = PM3_READ_REG(par, PM3VideoControl);
@@ -1257,6 +1276,10 @@ static int __devinit pm3fb_probe(struct 
 			FBINFO_HWACCEL_IMAGEBLIT |
 			FBINFO_HWACCEL_FILLRECT;
 
+	if (noaccel) {
+	    	printk(KERN_DEBUG "disabling acceleration\n");
+  		info->flags |= FBINFO_HWACCEL_DISABLED;
+	}
 	info->pixmap.addr = kmalloc(PM3_PIXMAP_SIZE, GFP_KERNEL);
 	if (!info->pixmap.addr) {
 		retval = -ENOMEM;
@@ -1330,6 +1353,11 @@ static void __devexit pm3fb_remove(struc
 		unregister_framebuffer(info);
 		fb_dealloc_cmap(&info->cmap);
 
+#ifdef CONFIG_MTRR
+	if (par->mtrr_handle >= 0)
+		mtrr_del(par->mtrr_handle, info->fix.smem_start,
+			 info->fix.smem_len);
+#endif /* CONFIG_MTRR */
 		iounmap(info->screen_base);
 		release_mem_region(fix->smem_start, fix->smem_len);
 		iounmap(par->v_regs);
@@ -1357,22 +1385,72 @@ static struct pci_driver pm3fb_driver = 
 
 MODULE_DEVICE_TABLE(pci, pm3fb_id_table);
 
-static int __init pm3fb_init(void)
+#ifndef MODULE
+	/*
+	 *  Setup
+	 */
+
+/*
+ * Only necessary if your driver takes special options,
+ * otherwise we fall back on the generic fb_setup().
+ */
+static int __init pm3fb_setup(char *options)
+{
+	char *this_opt;
+
+	/* Parse user speficied options (`video=pm3fb:') */
+	if (!options || !*options)
+		return 0;
+
+	while ((this_opt = strsep(&options, ",")) != NULL) {
+		if (!*this_opt)
+			continue;
+		else if (!strncmp(this_opt, "noaccel", 7)) {
+			noaccel = 1;
+#ifdef CONFIG_MTRR
+		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+			nomtrr = 1;
+#endif
+		} else {
+			mode_option = this_opt;
+		}
+	}
+	return 0;
+}
+#endif /* MODULE */
+
+int __init pm3fb_init(void)
 {
+	/*
+	 *  For kernel boot options (in 'video=pm3fb:<options>' format)
+	 */
 #ifndef MODULE
-	if (fb_get_options("pm3fb", NULL))
+	char *option = NULL;
+
+	if (fb_get_options("pm3fb", &option))
 		return -ENODEV;
+	pm3fb_setup(option);
 #endif
+
 	return pci_register_driver(&pm3fb_driver);
 }
 
+#ifdef MODULE
 static void __exit pm3fb_exit(void)
 {
 	pci_unregister_driver(&pm3fb_driver);
 }
 
-module_init(pm3fb_init);
 module_exit(pm3fb_exit);
+#endif
+module_init(pm3fb_init);
+
+module_param(noaccel, bool, 0);
+MODULE_PARM_DESC(noaccel, "Disable acceleration");
+#ifdef CONFIG_MTRR
+module_param(nomtrr, bool, 0);
+MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
+#endif
 
 MODULE_DESCRIPTION("Permedia3 framebuffer device driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
