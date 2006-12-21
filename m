From: akpm@osdl.org
Subject: + mips-pmagb-b-fb-convert-to-the-driver-model.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:58:02 -0800
Message-ID: <200612210458.kBL4w2U2016098@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38099 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422731AbWLUE6N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org, ralf@linux-mips.org


The patch titled
     mips: pmagb-b-fb: Convert to the driver model
has been added to the -mm tree.  Its filename is
     mips-pmagb-b-fb-convert-to-the-driver-model.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: pmagb-b-fb: Convert to the driver model
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a set of changes to convert the driver to the driver model.  As a
side-effect the driver now supports building as a module.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/Kconfig      |    4 -
 drivers/video/pmagb-b-fb.c |   98 ++++++++++++++++++++---------------
 2 files changed, 58 insertions(+), 44 deletions(-)

diff -puN drivers/video/Kconfig~mips-pmagb-b-fb-convert-to-the-driver-model drivers/video/Kconfig
--- a/drivers/video/Kconfig~mips-pmagb-b-fb-convert-to-the-driver-model
+++ a/drivers/video/Kconfig
@@ -1454,8 +1454,8 @@ config FB_PMAG_BA
 	  used mainly in the MIPS-based DECstation series.
 
 config FB_PMAGB_B
-	bool "PMAGB-B TURBOchannel framebuffer support"
-	depends on (FB = y) && TC
+	tristate "PMAGB-B TURBOchannel framebuffer support"
+	depends on TC
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
diff -puN drivers/video/pmagb-b-fb.c~mips-pmagb-b-fb-convert-to-the-driver-model drivers/video/pmagb-b-fb.c
--- a/drivers/video/pmagb-b-fb.c~mips-pmagb-b-fb-convert-to-the-driver-model
+++ a/drivers/video/pmagb-b-fb.c
@@ -11,7 +11,7 @@
  *	Michael Engel <engel@unix-ag.org>,
  *	Karsten Merker <merker@linuxtag.org> and
  *	Harald Koerfgen.
- *	Copyright (c) 2005  Maciej W. Rozycki
+ *	Copyright (c) 2005, 2006  Maciej W. Rozycki
  *
  *	This file is subject to the terms and conditions of the GNU General
  *	Public License.  See the file COPYING in the main directory of this
@@ -25,18 +25,16 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/tc.h>
 #include <linux/types.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
 
-#include <asm/dec/tc.h>
-
 #include <video/pmagb-b-fb.h>
 
 
 struct pmagbbfb_par {
-	struct fb_info *next;
 	volatile void __iomem *mmio;
 	volatile void __iomem *smem;
 	volatile u32 __iomem *sfb;
@@ -47,8 +45,6 @@ struct pmagbbfb_par {
 };
 
 
-static struct fb_info *root_pmagbbfb_dev;
-
 static struct fb_var_screeninfo pmagbbfb_defined __initdata = {
 	.bits_per_pixel	= 8,
 	.red.length	= 8,
@@ -190,8 +186,9 @@ static void __init pmagbbfb_osc_setup(st
 		69197, 66000, 65000, 50350, 36000, 32000, 25175
 	};
 	struct pmagbbfb_par *par = info->par;
+	struct tc_bus *tbus = to_tc_dev(info->device)->bus;
 	u32 count0 = 8, count1 = 8, counttc = 16 * 256 + 8;
-	u32 freq0, freq1, freqtc = get_tc_speed() / 250;
+	u32 freq0, freq1, freqtc = tc_get_speed(tbus) / 250;
 	int i, j;
 
 	gp0_write(par, 0);				/* select Osc0 */
@@ -249,26 +246,21 @@ static void __init pmagbbfb_osc_setup(st
 };
 
 
-static int __init pmagbbfb_init_one(int slot)
+static int __init pmagbbfb_probe(struct device *dev)
 {
-	char freq0[12], freq1[12];
+	struct tc_dev *tdev = to_tc_dev(dev);
+	resource_size_t start, len;
 	struct fb_info *info;
 	struct pmagbbfb_par *par;
-	unsigned long base_addr;
+	char freq0[12], freq1[12];
 	u32 vid_base;
 
-	info = framebuffer_alloc(sizeof(struct pmagbbfb_par), NULL);
+	info = framebuffer_alloc(sizeof(struct pmagbbfb_par), dev);
 	if (!info)
 		return -ENOMEM;
 
 	par = info->par;
-	par->slot = slot;
-	claim_tc_card(par->slot);
-
-	base_addr = get_tc_base_addr(par->slot);
-
-	par->next = root_pmagbbfb_dev;
-	root_pmagbbfb_dev = info;
+	dev_set_drvdata(dev, info);
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0)
 		goto err_alloc;
@@ -278,16 +270,22 @@ static int __init pmagbbfb_init_one(int 
 	info->var = pmagbbfb_defined;
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
 	par->sfb = par->mmio + PMAGB_B_SFB;
 	par->dac = par->mmio + PMAGB_B_BT459;
 
 	/* Frame buffer mapping setup.  */
-	info->fix.smem_start = base_addr + PMAGB_B_FBMEM;
+	info->fix.smem_start = start + PMAGB_B_FBMEM;
 	par->smem = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);
 	if (!par->smem)
 		goto err_mmio_map;
@@ -302,13 +300,15 @@ static int __init pmagbbfb_init_one(int 
 	if (register_framebuffer(info) < 0)
 		goto err_smem_map;
 
+	get_device(dev);
+
 	snprintf(freq0, sizeof(freq0), "%u.%03uMHz",
 		 par->osc0 / 1000, par->osc0 % 1000);
 	snprintf(freq1, sizeof(freq1), "%u.%03uMHz",
 		 par->osc1 / 1000, par->osc1 % 1000);
 
-	pr_info("fb%d: %s frame buffer device in slot %d\n",
-		info->node, info->fix.id, par->slot);
+	pr_info("fb%d: %s frame buffer device at %s\n",
+		info->node, info->fix.id, dev->bus_id);
 	pr_info("fb%d: Osc0: %s, Osc1: %s, Osc%u selected\n",
 		info->node, freq0, par->osc1 ? freq1 : "disabled",
 		par->osc1 != 0);
@@ -322,54 +322,68 @@ err_smem_map:
 err_mmio_map:
 	iounmap(par->mmio);
 
+err_resource:
+	release_mem_region(start, len);
+
 err_cmap:
 	fb_dealloc_cmap(&info->cmap);
 
 err_alloc:
-	root_pmagbbfb_dev = par->next;
-	release_tc_card(par->slot);
 	framebuffer_release(info);
 	return -ENXIO;
 }
 
-static void __exit pmagbbfb_exit_one(void)
+static int __exit pmagbbfb_remove(struct device *dev)
 {
-	struct fb_info *info = root_pmagbbfb_dev;
+	struct tc_dev *tdev = to_tc_dev(dev);
+	struct fb_info *info = dev_get_drvdata(dev);
 	struct pmagbbfb_par *par = info->par;
+	resource_size_t start, len;
 
+	put_device(dev);
 	unregister_framebuffer(info);
 	iounmap(par->smem);
 	iounmap(par->mmio);
+	start = tdev->resource.start;
+	len = tdev->resource.end - start + 1;
+	release_mem_region(start, len);
 	fb_dealloc_cmap(&info->cmap);
-	root_pmagbbfb_dev = par->next;
-	release_tc_card(par->slot);
 	framebuffer_release(info);
+	return 0;
 }
 
 
 /*
- * Initialise the framebuffer.
+ * Initialize the framebuffer.
  */
+static const struct tc_device_id pmagbbfb_tc_table[] = {
+	{ "DEC     ", "PMAGB-BA" },
+	{ }
+};
+MODULE_DEVICE_TABLE(tc, pmagbbfb_tc_table);
+
+static struct tc_driver pmagbbfb_driver = {
+	.id_table	= pmagbbfb_tc_table,
+	.driver		= {
+		.name	= "pmagbbfb",
+		.bus	= &tc_bus_type,
+		.probe	= pmagbbfb_probe,
+		.remove	= __exit_p(pmagbbfb_remove),
+	},
+};
+
 static int __init pmagbbfb_init(void)
 {
-	int count = 0;
-	int slot;
-
+#ifndef MODULE
 	if (fb_get_options("pmagbbfb", NULL))
 		return -ENXIO;
-
-	while ((slot = search_tc_card("PMAGB-BA")) >= 0) {
-		if (pmagbbfb_init_one(slot) < 0)
-			break;
-		count++;
-	}
-	return (count > 0) ? 0 : -ENXIO;
+#endif
+	return tc_register_driver(&pmagbbfb_driver);
 }
 
 static void __exit pmagbbfb_exit(void)
 {
-	while (root_pmagbbfb_dev)
-		pmagbbfb_exit_one();
+	tc_unregister_driver(&pmagbbfb_driver);
 }
 
 
_

Patches currently in -mm which might be from macro@linux-mips.org are

mips-if_fddih-add-a-missing-inclusion.patch
mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch

