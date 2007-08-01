From: akpm@linux-foundation.org
Subject: + tdfxfb-mtrr-support.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:42:18 -0700
Message-ID: <200708012242.l71MgIwC021177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbXHAWnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     tdfxfb: mtrr support
has been added to the -mm tree.  Its filename is
     tdfxfb-mtrr-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tdfxfb: mtrr support
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds mtrr support to the tdfxfb driver.  It also kills one
redundant include and initialization value.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |   43 +++++++++++++++++++++++++++++++++++++--
 include/video/tdfx.h   |    1 
 2 files changed, 42 insertions(+), 2 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-mtrr-support drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-mtrr-support
+++ a/drivers/video/tdfxfb.c
@@ -67,7 +67,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <asm/io.h>
-#include <linux/spinlock.h>
 
 #include <video/tdfx.h>
 
@@ -78,6 +77,24 @@
 #define DPRINTK(a,b...)
 #endif
 
+#ifdef CONFIG_MTRR
+#include <asm/mtrr.h>
+#else
+/* duplicate asm/mtrr.h defines to work on archs without mtrr */
+#define MTRR_TYPE_WRCOMB     1
+
+static __inline__ int mtrr_add (unsigned long base, unsigned long size,
+				unsigned int type, char increment)
+{
+    return -ENODEV;
+}
+static __inline__ int mtrr_del (int reg, unsigned long base,
+				unsigned long size)
+{
+    return -ENODEV;
+}
+#endif
+
 #define BANSHEE_MAX_PIXCLOCK 270000
 #define VOODOO3_MAX_PIXCLOCK 300000
 #define VOODOO5_MAX_PIXCLOCK 350000
@@ -150,7 +167,9 @@ MODULE_DEVICE_TABLE(pci, tdfxfb_id_table
 static int nopan;
 static int nowrap = 1;      /* not implemented (yet) */
 static int hwcursor = 1;
-static char *mode_option __devinitdata = NULL;
+static char *mode_option __devinitdata;
+/* mtrr option */
+static int nomtrr __devinitdata;
 
 /* -------------------------------------------------------------------------
  *                      Hardware-specific funcions
@@ -1227,6 +1246,12 @@ static int __devinit tdfxfb_probe(struct
 
 	printk("fb: %s memory = %dK\n", tdfx_fix.id, tdfx_fix.smem_len >> 10);
 
+	default_par->mtrr_handle = -1;
+	if (!nomtrr)
+		default_par->mtrr_handle =
+			mtrr_add(tdfx_fix.smem_start, tdfx_fix.smem_len,
+				 MTRR_TYPE_WRCOMB, 1);
+
 	tdfx_fix.ypanstep	= nopan ? 0 : 1;
 	tdfx_fix.ywrapstep	= nowrap ? 0 : 1;
 
@@ -1276,6 +1301,9 @@ static int __devinit tdfxfb_probe(struct
 	return 0;
 
 out_err_iobase:
+	if (default_par->mtrr_handle >= 0)
+		mtrr_del(default_par->mtrr_handle, info->fix.smem_start,
+			 info->fix.smem_len);
 	release_mem_region(pci_resource_start(pdev, 2),
 			   pci_resource_len(pdev, 2));
 out_err_screenbase:
@@ -1311,6 +1339,10 @@ static void tdfxfb_setup(char *options)
 			nowrap = 1;
 		} else if (!strcmp(this_opt, "hwcursor")) {
 			hwcursor = simple_strtoul(opt + 9, NULL, 0);
+#ifdef CONFIG_MTRR
+		} else if (!strncmp(this_opt, "nomtrr", 6)) {
+			nomtrr = 1;
+#endif
 		} else {
 			mode_option = this_opt;
 		}
@@ -1333,6 +1365,9 @@ static void __devexit tdfxfb_remove(stru
 	struct tdfx_par *par = info->par;
 
 	unregister_framebuffer(info);
+	if (par->mtrr_handle >= 0)
+		mtrr_del(par->mtrr_handle, info->fix.smem_start,
+			 info->fix.smem_len);
 	iounmap(par->regbase_virt);
 	iounmap(info->screen_base);
 
@@ -1372,6 +1407,10 @@ MODULE_LICENSE("GPL");
 module_param(hwcursor, int, 0644);
 MODULE_PARM_DESC(hwcursor, "Enable hardware cursor "
 			"(1=enable, 0=disable, default=1)");
+#ifdef CONFIG_MTRR
+module_param(nomtrr, bool, 0);
+MODULE_PARM_DESC(nomtrr, "Disable MTRR support (0 or 1=disabled) (default=0)");
+#endif
 
 module_init(tdfxfb_init);
 module_exit(tdfxfb_exit);
diff -puN include/video/tdfx.h~tdfxfb-mtrr-support include/video/tdfx.h
--- a/include/video/tdfx.h~tdfxfb-mtrr-support
+++ a/include/video/tdfx.h
@@ -175,6 +175,7 @@ struct tdfx_par {
 	u32 palette[16];
 	void __iomem *regbase_virt;
 	unsigned long iobase;
+	int mtrr_handle;
 };
 
 #endif	/* __KERNEL__ */
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
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
