From: akpm@linux-foundation.org
Subject: + atyfb-use-a-pci-device-id-table.patch added to -mm tree
Date: Wed, 04 Jun 2008 16:45:19 -0700
Message-ID: <200806042345.m54NjJr7015318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759002AbYFDXqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 19:46:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: syrjala@sci.fi, adaplas@pol.net, krzysztof.h1@poczta.fm


The patch titled
     atyfb: use a PCI device ID table
has been added to the -mm tree.  Its filename is
     atyfb-use-a-pci-device-id-table.patch

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
Subject: atyfb: use a PCI device ID table
From: Ville Syrjala <syrjala@sci.fi>

Convert atyfb to use a PCI device ID table.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |   73 +++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 18 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-use-a-pci-device-id-table drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-use-a-pci-device-id-table
+++ a/drivers/video/aty/atyfb_base.c
@@ -3418,14 +3418,7 @@ static int __devinit atyfb_pci_probe(str
 	struct fb_info *info;
 	struct resource *rp;
 	struct atyfb_par *par;
-	int i, rc = -ENOMEM;
-
-	for (i = ARRAY_SIZE(aty_chips) - 1; i >= 0; i--)
-		if (pdev->device == aty_chips[i].pci_id)
-			break;
-
-	if (i < 0)
-		return -ENODEV;
+	int rc = -ENOMEM;
 
 	/* Enable device in PCI config */
 	if (pci_enable_device(pdev)) {
@@ -3456,7 +3449,7 @@ static int __devinit atyfb_pci_probe(str
 	par = info->par;
 	info->fix = atyfb_fix;
 	info->device = &pdev->dev;
-	par->pci_id = aty_chips[i].pci_id;
+	par->pci_id = pdev->device;
 	par->res_start = res_start;
 	par->res_size = res_size;
 	par->irq = pdev->irq;
@@ -3655,18 +3648,62 @@ static void __devexit atyfb_pci_remove(s
 	atyfb_remove(info);
 }
 
-/*
- * This driver uses its own matching table. That will be more difficult
- * to fix, so for now, we just match against any ATI ID and let the
- * probe() function find out what's up. That also mean we don't have
- * a module ID table though.
- */
 static struct pci_device_id atyfb_pci_tbl[] = {
-	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_BASE_CLASS_DISPLAY << 16, 0xff0000, 0 },
-	{ 0, }
+#ifdef CONFIG_FB_ATY_GX
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GX) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64CX) },
+#endif /* CONFIG_FB_ATY_GX */
+
+#ifdef CONFIG_FB_ATY_CT
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64CT) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64ET) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LT) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64VT) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GT) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64VU) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GU) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LG) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64VV) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GV) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GW) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GY) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GZ) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GB) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GD) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GI) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GP) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GQ) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LB) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LD) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LI) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LP) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LQ) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GM) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GN) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GO) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GR) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64GS) },
+
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LM) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LN) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LR) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_CHIP_MACH64LS) },
+#endif /* CONFIG_FB_ATY_CT */
+	{ }
 };
 
+MODULE_DEVICE_TABLE(pci, atyfb_pci_tbl);
+
 static struct pci_driver atyfb_driver = {
 	.name		= "atyfb",
 	.id_table	= atyfb_pci_tbl,
_

Patches currently in -mm which might be from syrjala@sci.fi are

fbdev-width-and-height-are-unsigned.patch
fbdev-xoffset-yoffset-and-yres-are-unsigned.patch
atyfb-remove-dead-code.patch
atyfb-correct_chipset-can-fail.patch
atyfb-use-a-pci-device-id-table.patch
atyfb-report-probe-errors.patch
atyfb-fix-a-cast.patch

