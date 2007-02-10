From: akpm@linux-foundation.org
Subject: - mips-pmag-ba-fb-convert-to-the-driver-model.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:26:08 -0800
Message-ID: <200702100526.l1A5Q8WV004626@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbXBJFaG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:30:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     mips: pmag-ba-fb: Convert to the driver model
has been removed from the -mm tree.  Its filename was
     mips-pmag-ba-fb-convert-to-the-driver-model.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mips: pmag-ba-fb: Convert to the driver model
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a set of changes to convert the driver to the driver model.  As a
side-effect the driver now supports building as a module.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig      |    4 -
 drivers/video/pmag-ba-fb.c |   95 +++++++++++++++++++----------------
 2 files changed, 56 insertions(+), 43 deletions(-)

diff -puN drivers/video/Kconfig~mips-pmag-ba-fb-convert-to-the-driver-model drivers/video/Kconfig
--- a/drivers/video/Kconfig~mips-pmag-ba-fb-convert-to-the-driver-model
+++ a/drivers/video/Kconfig
@@ -1444,8 +1444,8 @@ config FB_PMAG_AA
 	  used mainly in the MIPS-based DECstation series.
 
 config FB_PMAG_BA
-	bool "PMAG-BA TURBOchannel framebuffer support"
-	depends on (FB = y) && TC
+	tristate "PMAG-BA TURBOchannel framebuffer support"
+	depends on FB && TC
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
diff -puN drivers/video/pmag-ba-fb.c~mips-pmag-ba-fb-convert-to-the-driver-model drivers/video/pmag-ba-fb.c
--- a/drivers/video/pmag-ba-fb.c~mips-pmag-ba-fb-convert-to-the-driver-model
+++ a/drivers/video/pmag-ba-fb.c
@@ -15,7 +15,8 @@
  *	Michael Engel <engel@unix-ag.org>,
  *	Karsten Merker <merker@linuxtag.org> and
  *	Harald Koerfgen.
- *	Copyright (c) 2005  Maciej W. Rozycki
+ *	Copyright (c) 2005, 2006  Maciej W. Rozycki
+ *	Copyright (c) 2005  James Simmons
  *
  *	This file is subject to the terms and conditions of the GNU General
  *	Public License.  See the file COPYING in the main directory of this
@@ -28,26 +29,21 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/tc.h>
 #include <linux/types.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
 
-#include <asm/dec/tc.h>
-
 #include <video/pmag-ba-fb.h>
 
 
 struct pmagbafb_par {
-	struct fb_info *next;
 	volatile void __iomem *mmio;
 	volatile u32 __iomem *dac;
-	int slot;
 };
 
 
-static struct fb_info *root_pmagbafb_dev;
-
 static struct fb_var_screeninfo pmagbafb_defined __initdata = {
 	.xres		= 1024,
 	.yres		= 864,
@@ -145,24 +141,19 @@ static void __init pmagbafb_erase_cursor
 }
 
 
-static int __init pmagbafb_init_one(int slot)
+static int __init pmagbafb_probe(struct device *dev)
 {
+	struct tc_dev *tdev = to_tc_dev(dev);
+	resource_size_t start, len;
 	struct fb_info *info;
 	struct pmagbafb_par *par;
-	unsigned long base_addr;
 
-	info = framebuffer_alloc(sizeof(struct pmagbafb_par), NULL);
+	info = framebuffer_alloc(sizeof(struct pmagbafb_par), dev);
 	if (!info)
 		return -ENOMEM;
 
 	par = info->par;
-	par->slot = slot;
-	claim_tc_card(par->slot);
-
-	base_addr = get_tc_base_addr(par->slot);
-
-	par->next = root_pmagbafb_dev;
-	root_pmagbafb_dev = info;
+	dev_set_drvdata(dev, info);
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
 		goto err_alloc;
@@ -172,15 +163,21 @@ static int __init pmagbafb_init_one(int 
 	info->var = pmagbafb_defined;
 	info->flags = FBINFO_DEFAULT;
 
+	/* Request the I/O MEM resource.  */
+	start = tdev->resource.start;
+	len = tdev->resource.end - start + 1;
+	if (!request_mem_region(start, len, dev->bus_id))
+		goto err_cmap;
+
 	/* MMIO mapping setup.  */
-	info->fix.mmio_start = base_addr;
+	info->fix.mmio_start = start;
 	par->mmio = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
 	if (!par->mmio)
-		goto err_cmap;
+		goto err_resource;
 	par->dac = par->mmio + PMAG_BA_BT459;
 
 	/* Frame buffer mapping setup.  */
-	info->fix.smem_start = base_addr + PMAG_BA_FBMEM;
+	info->fix.smem_start = start + PMAG_BA_FBMEM;
 	info->screen_base = ioremap_nocache(info->fix.smem_start,
 					    info->fix.smem_len);
 	if (!info->screen_base)
@@ -192,8 +189,10 @@ static int __init pmagbafb_init_one(int 
 	if (register_framebuffer(info) < 0)
 		goto err_smem_map;
 
-	pr_info("fb%d: %s frame buffer device in slot %d\n",
-		info->node, info->fix.id, par->slot);
+	get_device(dev);
+
+	pr_info("fb%d: %s frame buffer device at %s\n",
+		info->node, info->fix.id, dev->bus_id);
 
 	return 0;
 
@@ -204,54 +203,68 @@ err_smem_map:
 err_mmio_map:
 	iounmap(par->mmio);
 
+err_resource:
+	release_mem_region(start, len);
+
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
 
 err_alloc:
-	root_pmagbafb_dev = par->next;
-	release_tc_card(par->slot);
 	framebuffer_release(info);
 	return -ENXIO;
 }
 
-static void __exit pmagbafb_exit_one(void)
+static int __exit pmagbafb_remove(struct device *dev)
 {
-	struct fb_info *info = root_pmagbafb_dev;
+	struct tc_dev *tdev = to_tc_dev(dev);
+	struct fb_info *info = dev_get_drvdata(dev);
 	struct pmagbafb_par *par = info->par;
+	resource_size_t start, len;
 
+	put_device(dev);
 	unregister_framebuffer(info);
 	iounmap(info->screen_base);
 	iounmap(par->mmio);
+	start = tdev->resource.start;
+	len = tdev->resource.end - start + 1;
+	release_mem_region(start, len);
 	fb_dealloc_cmap(&info->cmap);
-	root_pmagbafb_dev = par->next;
-	release_tc_card(par->slot);
 	framebuffer_release(info);
+	return 0;
 }
 
 
 /*
- * Initialise the framebuffer.
+ * Initialize the framebuffer.
  */
+static const struct tc_device_id pmagbafb_tc_table[] = {
+	{ "DEC     ", "PMAG-BA " },
+	{ }
+};
+MODULE_DEVICE_TABLE(tc, pmagbafb_tc_table);
+
+static struct tc_driver pmagbafb_driver = {
+	.id_table	= pmagbafb_tc_table,
+	.driver		= {
+		.name	= "pmagbafb",
+		.bus	= &tc_bus_type,
+		.probe	= pmagbafb_probe,
+		.remove	= __exit_p(pmagbafb_remove),
+	},
+};
+
 static int __init pmagbafb_init(void)
 {
-	int count = 0;
-	int slot;
-
+#ifndef MODULE
 	if (fb_get_options("pmagbafb", NULL))
 		return -ENXIO;
-
-	while ((slot = search_tc_card("PMAG-BA")) >= 0) {
-		if (pmagbafb_init_one(slot) < 0)
-			break;
-		count++;
-	}
-	return (count > 0) ? 0 : -ENXIO;
+#endif
+	return tc_register_driver(&pmagbafb_driver);
 }
 
 static void __exit pmagbafb_exit(void)
 {
-	while (root_pmagbafb_dev)
-		pmagbafb_exit_one();
+	tc_unregister_driver(&pmagbafb_driver);
 }
 
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch
