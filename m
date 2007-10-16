From: akpm@linux-foundation.org
Subject: - tdfxfb-mtrr-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:49 -0700
Message-ID: <200710162042.l9GKgnfw015919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760191AbXJPVJX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:09:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: mtrr support
has been removed from the -mm tree.  Its filename was
     tdfxfb-mtrr-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tdfxfb: mtrr support
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds mtrr support to the tdfxfb driver.  It also kills one
redundant include and initialization value.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |   47 +++++++++++++++++++++++++++++++++++----
 include/video/tdfx.h   |    1 
 2 files changed, 44 insertions(+), 4 deletions(-)

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
+static inline int mtrr_add(unsigned long base, unsigned long size,
+				unsigned int type, char increment)
+{
+    return -ENODEV;
+}
+static inline int mtrr_del(int reg, unsigned long base,
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
@@ -1309,8 +1337,12 @@ static void tdfxfb_setup(char *options)
 			nopan = 1;
 		} else if (!strcmp(this_opt, "nowrap")) {
 			nowrap = 1;
-		} else if (!strcmp(this_opt, "hwcursor")) {
-			hwcursor = simple_strtoul(opt + 9, NULL, 0);
+		} else if (!strncmp(this_opt, "hwcursor=", 9)) {
+			hwcursor = simple_strtoul(this_opt + 9, NULL, 0);
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
+MODULE_PARM_DESC(nomtrr, "Disable MTRR support (default: enabled)");
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

origin.patch
git-alsa.patch
cyber2000fb-checkpatch-fixes.patch
