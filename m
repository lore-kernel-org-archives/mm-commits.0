From: akpm@linux-foundation.org
Subject: - pm2fb-mtrr-support-and-noaccel-option.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:58:07 -0700
Message-ID: <200710160458.l9G4w7MN009887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760AbXJPE6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: mtrr support and noaccel option
has been removed from the -mm tree.  Its filename was
     pm2fb-mtrr-support-and-noaccel-option.patch

This patch was dropped because it was folded into pm3fb-mtrr-support-and-noaccel-option.patch

------------------------------------------------------
Subject: pm2fb: mtrr support and noaccel option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds usage of MTRR registers and two new options:
noaccel and nomtrr.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |   44 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff -puN drivers/video/pm2fb.c~pm2fb-mtrr-support-and-noaccel-option drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-mtrr-support-and-noaccel-option
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
@@ -71,8 +74,13 @@ static char *mode __devinitdata = NULL;
  * these flags allow the user to specify that requests for +ve sync
  * should be silently turned in -ve sync.
  */
-static int lowhsync;
-static int lowvsync;
+static int lowhsync __devinitdata;
+static int lowvsync __devinitdata;
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
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
tdfxfb-mtrr-support-fix-2.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
s3c2410fb-byte-ordering-fixes.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
s3fb-do-not-allow-incorrect-pixclock-settings.patch
cyber2000fb-checkpatch-fixes.patch
