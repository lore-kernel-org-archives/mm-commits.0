From: akpm@linux-foundation.org
Subject: - pm3fb-mtrr-support-and-noaccel-option.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:06 -0700
Message-ID: <200710162042.l9GKg6Z8015858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965267AbXJPVN7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:13:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm3fb: mtrr support and noaccel option
has been removed from the -mm tree.  Its filename was
     pm3fb-mtrr-support-and-noaccel-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm3fb: mtrr support and noaccel option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds usage of MTRR registers and two new options: noaccel and
nomtrr.

[bunk@kernel.org: make pm3fb_init() static again]
Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   40 ++++++++++++++++++++
 drivers/video/pm3fb.c |   80 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 118 insertions(+), 2 deletions(-)

diff -puN drivers/video/pm2fb.c~pm3fb-mtrr-support-and-noaccel-option drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm3fb-mtrr-support-and-noaccel-option
+++ a/drivers/video/pm2fb.c
@@ -38,6 +38,9 @@
 #include <linux/fb.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#ifdef CONFIG_MTRR
+#include <asm/mtrr.h>
+#endif
 
 #include <video/permedia2.h>
 #include <video/cvisionppc.h>
@@ -73,6 +76,11 @@ static char *mode __devinitdata = NULL;
  */
 static int lowhsync;
 static int lowvsync;
+static int noaccel __devinitdata;
+/* mtrr option */
+#ifdef CONFIG_MTRR
+static int nomtrr __devinitdata;
+#endif
 
 /*
  * The hardware state of the graphics card that isn't part of the
@@ -88,6 +96,7 @@ struct pm2fb_par
 	u32		mem_control;	/* MemControl reg at probe */
 	u32		boot_address;	/* BootAddress reg at probe */
 	u32		palette[16];
+	int		mtrr_handle;
 };
 
 /*
@@ -1316,6 +1325,15 @@ static int __devinit pm2fb_probe(struct 
 		goto err_exit_mmio;
 	}
 
+#ifdef CONFIG_MTRR
+	default_par->mtrr_handle = -1;
+	if (!nomtrr)
+		default_par->mtrr_handle =
+			mtrr_add(pm2fb_fix.smem_start,
+				 pm2fb_fix.smem_len,
+				 MTRR_TYPE_WRCOMB, 1);
+#endif
+
 	info->fbops		= &pm2fb_ops;
 	info->fix		= pm2fb_fix;
 	info->pseudo_palette	= default_par->palette;
@@ -1324,6 +1342,11 @@ static int __devinit pm2fb_probe(struct 
 				  FBINFO_HWACCEL_COPYAREA |
 				  FBINFO_HWACCEL_FILLRECT;
 
+	if (noaccel) {
+	    	printk(KERN_DEBUG "disabling acceleration\n");
+  		info->flags |= FBINFO_HWACCEL_DISABLED;
+	}
+
 	if (!mode)
 		mode = "640x480@60";
 
@@ -1375,6 +1398,11 @@ static void __devexit pm2fb_remove(struc
 
 	unregister_framebuffer(info);
 
+#ifdef CONFIG_MTRR
+	if (par->mtrr_handle >= 0)
+		mtrr_del(par->mtrr_handle, info->fix.smem_start,
+			 info->fix.smem_len);
+#endif /* CONFIG_MTRR */
 	iounmap(info->screen_base);
 	release_mem_region(fix->smem_start, fix->smem_len);
 	iounmap(par->v_regs);
@@ -1430,6 +1458,12 @@ static int __init pm2fb_setup(char *opti
 			lowhsync = 1;
 		} else if(!strcmp(this_opt, "lowvsync")) {
 			lowvsync = 1;
+#ifdef CONFIG_MTRR
+		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+			nomtrr = 1;
+#endif
+		} else if (!strncmp(this_opt, "noaccel", 7)) {
+			noaccel = 1;
 		} else {
 			mode = this_opt;
 		}
@@ -1474,6 +1508,12 @@ module_param(lowhsync, bool, 0);
 MODULE_PARM_DESC(lowhsync, "Force horizontal sync low regardless of mode");
 module_param(lowvsync, bool, 0);
 MODULE_PARM_DESC(lowvsync, "Force vertical sync low regardless of mode");
+module_param(noaccel, bool, 0);
+MODULE_PARM_DESC(noaccel, "Disable acceleration");
+#ifdef CONFIG_MTRR
+module_param(nomtrr, bool, 0);
+MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
+#endif
 
 MODULE_AUTHOR("Jim Hague <jim.hague@acm.org>");
 MODULE_DESCRIPTION("Permedia2 framebuffer device driver");
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
@@ -1244,6 +1254,13 @@ static int __devinit pm3fb_probe(struct 
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
@@ -1257,6 +1274,10 @@ static int __devinit pm3fb_probe(struct 
 			FBINFO_HWACCEL_IMAGEBLIT |
 			FBINFO_HWACCEL_FILLRECT;
 
+	if (noaccel) {
+	    	printk(KERN_DEBUG "disabling acceleration\n");
+  		info->flags |= FBINFO_HWACCEL_DISABLED;
+	}
 	info->pixmap.addr = kmalloc(PM3_PIXMAP_SIZE, GFP_KERNEL);
 	if (!info->pixmap.addr) {
 		retval = -ENOMEM;
@@ -1330,6 +1351,11 @@ static void __devexit pm3fb_remove(struc
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
@@ -1357,22 +1383,72 @@ static struct pci_driver pm3fb_driver = 
 
 MODULE_DEVICE_TABLE(pci, pm3fb_id_table);
 
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
 static int __init pm3fb_init(void)
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

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
