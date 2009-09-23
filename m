From: akpm@linux-foundation.org
Subject: [merged] viafb-make-viafb-a-first-class-citizen-using-pci_driver.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:37 -0700
Message-ID: <200909232002.n8NK2biL017574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888AbZIWUDL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     viafb: make viafb a first-class citizen using pci_driver
has been removed from the -mm tree.  Its filename was
     viafb-make-viafb-a-first-class-citizen-using-pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: make viafb a first-class citizen using pci_driver
From: Harald Welte <laforge@gnumonks.org>

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c       |  115 ++-------------------------------
 drivers/video/via/hw.h       |    5 -
 drivers/video/via/viafbdev.c |   52 ++++++++++++--
 3 files changed, 56 insertions(+), 116 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-make-viafb-a-first-class-citizen-using-pci_driver drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-make-viafb-a-first-class-citizen-using-pci_driver
+++ a/drivers/video/via/hw.c
@@ -21,22 +21,6 @@
 
 #include "global.h"
 
-static const struct pci_device_id_info pciidlist[] = {
-	{PCI_VIA_VENDOR_ID, UNICHROME_CLE266_DID, UNICHROME_CLE266},
-	{PCI_VIA_VENDOR_ID, UNICHROME_PM800_DID, UNICHROME_PM800},
-	{PCI_VIA_VENDOR_ID, UNICHROME_K400_DID, UNICHROME_K400},
-	{PCI_VIA_VENDOR_ID, UNICHROME_K800_DID, UNICHROME_K800},
-	{PCI_VIA_VENDOR_ID, UNICHROME_CN700_DID, UNICHROME_CN700},
-	{PCI_VIA_VENDOR_ID, UNICHROME_P4M890_DID, UNICHROME_P4M890},
-	{PCI_VIA_VENDOR_ID, UNICHROME_K8M890_DID, UNICHROME_K8M890},
-	{PCI_VIA_VENDOR_ID, UNICHROME_CX700_DID, UNICHROME_CX700},
-	{PCI_VIA_VENDOR_ID, UNICHROME_P4M900_DID, UNICHROME_P4M900},
-	{PCI_VIA_VENDOR_ID, UNICHROME_CN750_DID, UNICHROME_CN750},
-	{PCI_VIA_VENDOR_ID, UNICHROME_VX800_DID, UNICHROME_VX800},
-	{PCI_VIA_VENDOR_ID, UNICHROME_VX855_DID, UNICHROME_VX855},
-	{0, 0, 0}
-};
-
 static struct pll_map pll_value[] = {
 	{CLK_25_175M, CLE266_PLL_25_175M, K800_PLL_25_175M,
 	 CX700_25_175M, VX855_25_175M},
@@ -542,7 +526,8 @@ static void set_dvi_output_path(int set_
 static void set_lcd_output_path(int set_iga, int output_interface);
 static int search_mode_setting(int ModeInfoIndex);
 static void load_fix_bit_crtc_reg(void);
-static void init_gfx_chip_info(void);
+static void init_gfx_chip_info(struct pci_dev *pdev,
+				const struct pci_device_id *pdi);
 static void init_tmds_chip_info(void);
 static void init_lvds_chip_info(void);
 static void device_screen_off(void);
@@ -552,7 +537,6 @@ static void device_off(void);
 static void device_on(void);
 static void enable_second_display_channel(void);
 static void disable_second_display_channel(void);
-static int get_fb_size_from_pci(void);
 
 void viafb_write_reg(u8 index, u16 io_port, u8 data)
 {
@@ -1937,9 +1921,10 @@ void viafb_fill_crtc_timing(struct crt_m
 
 }
 
-void viafb_init_chip_info(void)
+void viafb_init_chip_info(struct pci_dev *pdev,
+			  const struct pci_device_id *pdi)
 {
-	init_gfx_chip_info();
+	init_gfx_chip_info(pdev, pdi);
 	init_tmds_chip_info();
 	init_lvds_chip_info();
 
@@ -2012,24 +1997,12 @@ void viafb_update_device_setting(int hre
 	}
 }
 
-static void init_gfx_chip_info(void)
+static void init_gfx_chip_info(struct pci_dev *pdev,
+			       const struct pci_device_id *pdi)
 {
-	struct pci_dev *pdev = NULL;
-	u32 i;
 	u8 tmp;
 
-	/* Indentify GFX Chip Name */
-	for (i = 0; pciidlist[i].vendor != 0; i++) {
-		pdev = pci_get_device(pciidlist[i].vendor,
-			pciidlist[i].device, 0);
-		if (pdev)
-			break;
-	}
-
-	if (!pciidlist[i].vendor)
-		return ;
-
-	viaparinfo->chip_info->gfx_chip_name = pciidlist[i].chip_index;
+	viaparinfo->chip_info->gfx_chip_name = pdi->driver_data;
 
 	/* Check revision of CLE266 Chip */
 	if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266) {
@@ -2060,8 +2033,6 @@ static void init_gfx_chip_info(void)
 				CX700_REVISION_700;
 		}
 	}
-
-	pci_dev_put(pdev);
 }
 
 static void init_tmds_chip_info(void)
@@ -2554,37 +2525,6 @@ void viafb_crt_enable(void)
 	viafb_write_reg_mask(CR36, VIACR, 0x0, BIT5 + BIT4);
 }
 
-void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len)
-{
-	struct pci_dev *pdev = NULL;
-	u32 vendor, device;
-	u32 i;
-
-	for (i = 0; pciidlist[i].vendor != 0; i++)
-		if (viaparinfo->chip_info->gfx_chip_name ==
-			pciidlist[i].chip_index)
-			break;
-
-	if (!pciidlist[i].vendor)
-		return ;
-
-	vendor = pciidlist[i].vendor;
-	device = pciidlist[i].device;
-
-	pdev = pci_get_device(vendor, device, NULL);
-
-	if (!pdev) {
-		*mmio_base = 0;
-		*mmio_len = 0;
-		return ;
-	}
-
-	*mmio_base = pci_resource_start(pdev, 1);
-	*mmio_len = pci_resource_len(pdev, 1);
-
-	pci_dev_put(pdev);
-}
-
 static void enable_second_display_channel(void)
 {
 	/* to enable second display channel. */
@@ -2601,44 +2541,7 @@ static void disable_second_display_chann
 	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
 }
 
-void viafb_get_fb_info(unsigned int *fb_base, unsigned int *fb_len)
-{
-	struct pci_dev *pdev = NULL;
-	u32 vendor, device;
-	u32 i;
-
-	for (i = 0; pciidlist[i].vendor != 0; i++)
-		if (viaparinfo->chip_info->gfx_chip_name ==
-			pciidlist[i].chip_index)
-			break;
-
-	if (!pciidlist[i].vendor)
-		return ;
-
-	vendor = pciidlist[i].vendor;
-	device = pciidlist[i].device;
-
-	pdev = pci_get_device(vendor, device, NULL);
-
-	if (!pdev) {
-		*fb_base = viafb_read_reg(VIASR, SR30) << 24;
-		*fb_len = viafb_get_memsize();
-		DEBUG_MSG(KERN_INFO "Get FB info from SR30!\n");
-		DEBUG_MSG(KERN_INFO "fb_base = %08x\n", *fb_base);
-		DEBUG_MSG(KERN_INFO "fb_len = %08x\n", *fb_len);
-		return ;
-	}
-
-	*fb_base = (unsigned int)pci_resource_start(pdev, 0);
-	*fb_len = get_fb_size_from_pci();
-	DEBUG_MSG(KERN_INFO "Get FB info from PCI system!\n");
-	DEBUG_MSG(KERN_INFO "fb_base = %08x\n", *fb_base);
-	DEBUG_MSG(KERN_INFO "fb_len = %08x\n", *fb_len);
-
-	pci_dev_put(pdev);
-}
-
-static int get_fb_size_from_pci(void)
+int viafb_get_fb_size_from_pci(void)
 {
 	unsigned long configid, deviceid, FBSize = 0;
 	int VideoMemSize;
diff -puN drivers/video/via/hw.h~viafb-make-viafb-a-first-class-citizen-using-pci_driver drivers/video/via/hw.h
--- a/drivers/video/via/hw.h~viafb-make-viafb-a-first-class-citizen-using-pci_driver
+++ a/drivers/video/via/hw.h
@@ -901,14 +901,15 @@ void viafb_set_dpa_gfx(int output_interf
 int viafb_setmode(int vmode_index, int hor_res, int ver_res,
 	    int video_bpp, int vmode_index1, int hor_res1,
 	    int ver_res1, int video_bpp1);
-void viafb_init_chip_info(void);
+void viafb_init_chip_info(struct pci_dev *pdev,
+			  const struct pci_device_id *pdi);
 void viafb_init_dac(int set_iga);
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
 void viafb_update_device_setting(int hres, int vres, int bpp,
 			   int vmode_refresh, int flag);
-void viafb_get_mmio_info(unsigned long *mmio_base, u32 *mmio_len);
 
+int viafb_get_fb_size_from_pci(void);
 void viafb_set_iga_path(void);
 void viafb_set_primary_address(u32 addr);
 void viafb_set_secondary_address(u32 addr);
diff -puN drivers/video/via/viafbdev.c~viafb-make-viafb-a-first-class-citizen-using-pci_driver drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-make-viafb-a-first-class-citizen-using-pci_driver
+++ a/drivers/video/via/viafbdev.c
@@ -1842,7 +1842,8 @@ out_default:
 	*yres = 480;
 }
 
-static int __devinit via_pci_probe(void)
+static int __devinit via_pci_probe(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
 {
 	u32 default_xres, default_yres;
 	int vmode_index;
@@ -1885,8 +1886,9 @@ static int __devinit via_pci_probe(void)
 	/* Set up I2C bus stuff */
 	viafb_create_i2c_bus(viaparinfo);
 
-	viafb_init_chip_info();
-	viafb_get_fb_info(&viaparinfo->fbmem, &viaparinfo->memsize);
+	viafb_init_chip_info(pdev, ent);
+	viaparinfo->fbmem = pci_resource_start(pdev, 0);
+	viaparinfo->memsize = viafb_get_fb_size_from_pci();
 	viaparinfo->fbmem_free = viaparinfo->memsize;
 	viaparinfo->fbmem_used = 0;
 	viafbinfo->screen_base = ioremap_nocache(viaparinfo->fbmem,
@@ -1896,8 +1898,8 @@ static int __devinit via_pci_probe(void)
 		return -ENOMEM;
 	}
 
-	viafb_get_mmio_info(&viafbinfo->fix.mmio_start,
-		&viafbinfo->fix.mmio_len);
+	viafbinfo->fix.mmio_start = pci_resource_start(pdev, 1);
+	viafbinfo->fix.mmio_len = pci_resource_len(pdev, 1);
 	viafbinfo->node = 0;
 	viafbinfo->fbops = &viafb_ops;
 	viafbinfo->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
@@ -2065,7 +2067,7 @@ static int __devinit via_pci_probe(void)
 	return 0;
 }
 
-static void __devexit via_pci_remove(void)
+static void __devexit via_pci_remove(struct pci_dev *pdev)
 {
 	DEBUG_MSG(KERN_INFO "via_pci_remove!\n");
 	fb_dealloc_cmap(&viafbinfo->cmap);
@@ -2157,6 +2159,40 @@ static int __init viafb_setup(char *opti
 }
 #endif
 
+static struct pci_device_id viafb_pci_table[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CLE266_DID),
+	  .driver_data = UNICHROME_CLE266 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_PM800_DID),
+	  .driver_data = UNICHROME_PM800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K400_DID),
+	  .driver_data = UNICHROME_K400 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K800_DID),
+	  .driver_data = UNICHROME_K800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M890_DID),
+	  .driver_data = UNICHROME_CN700 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_K8M890_DID),
+	  .driver_data = UNICHROME_K8M890 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CX700_DID),
+	  .driver_data = UNICHROME_CX700 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_P4M900_DID),
+	  .driver_data = UNICHROME_P4M900 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_CN750_DID),
+	  .driver_data = UNICHROME_CN750 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX800_DID),
+	  .driver_data = UNICHROME_VX800 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, UNICHROME_VX855_DID),
+	  .driver_data = UNICHROME_VX855 },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, viafb_pci_table);
+
+static struct pci_driver viafb_driver = {
+	.name		= "viafb",
+	.id_table	= viafb_pci_table,
+	.probe		= via_pci_probe,
+	.remove		= __devexit_p(via_pci_remove),
+};
+
 static int __init viafb_init(void)
 {
 #ifndef MODULE
@@ -2168,13 +2204,13 @@ static int __init viafb_init(void)
 	printk(KERN_INFO
        "VIA Graphics Intergration Chipset framebuffer %d.%d initializing\n",
 	       VERSION_MAJOR, VERSION_MINOR);
-	return via_pci_probe();
+	return pci_register_driver(&viafb_driver);
 }
 
 static void __exit viafb_exit(void)
 {
 	DEBUG_MSG(KERN_INFO "viafb_exit!\n");
-	via_pci_remove();
+	pci_unregister_driver(&viafb_driver);
 }
 
 static struct fb_ops viafb_ops = {
_

Patches currently in -mm which might be from laforge@gnumonks.org are

origin.patch

