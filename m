From: akpm@osdl.org
Subject: + via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets.patch added to -mm tree
Date: Thu, 25 Jan 2007 20:11:36 -0800
Message-ID: <200701260411.l0Q4BaVE007057@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030723AbXAZELr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 23:11:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: claas@rootdir.de, airlied@linux.ie, davej@codemonkey.org.uk


The patch titled
     via-agp and drm: adding support for CX700(M2), P4M890 and VT3336 chipsets
has been added to the -mm tree.  Its filename is
     via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: via-agp and drm: adding support for CX700(M2), P4M890 and VT3336 chipsets
From: Claas Langbehn <claas@rootdir.de>

* Adds support for the VIA CX700(M2), P4M890 and VT3336 chipsets to via-agp.c
* Adds PCI-IDs and DRM PCI_IDs for the VIA CX700(M2), P4M890 and VT3336 chipsets
* Removes AGP-support and PCI-IDs of PT880 Ultra
* Changes Kconfig explanation text for AGP and DRM slightly

This patch is based on the source code that VIA released here:
http://www.viaarena.com/Driver/cle266cn400cn-cx700cn800xorg40072-kernel-src_20061226.tgz

Signed-off-by: Claas Langbehn <claas@rootdir.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/agp/Kconfig   |    2 -
 drivers/char/agp/via-agp.c |   39 ++++++++++++++++++++++-------------
 drivers/char/drm/Kconfig   |    7 +++---
 include/linux/pci_ids.h    |    4 ++-
 4 files changed, 33 insertions(+), 19 deletions(-)

diff -puN drivers/char/agp/Kconfig~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets drivers/char/agp/Kconfig
--- a/drivers/char/agp/Kconfig~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets
+++ a/drivers/char/agp/Kconfig
@@ -106,7 +106,7 @@ config AGP_VIA
 	depends on AGP && X86
 	help
 	  This option gives you AGP support for the GLX component of
-	  X on VIA MVP3/Apollo Pro chipsets.
+	  X on VIA MVP3/Apollo Pro/UniChrome Pro chipsets.
 
 config AGP_I460
 	tristate "Intel 460GX chipset support"
diff -puN drivers/char/agp/via-agp.c~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets drivers/char/agp/via-agp.c
--- a/drivers/char/agp/via-agp.c~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets
+++ a/drivers/char/agp/via-agp.c
@@ -9,7 +9,7 @@
 #include <linux/agp_backend.h>
 #include "agp.h"
 
-static const struct pci_device_id agp_via_pci_table[];
+static struct pci_device_id agp_via_pci_table[];
 
 #define VIA_GARTCTRL	0x80
 #define VIA_APSIZE	0x84
@@ -347,12 +347,6 @@ static struct agp_device_ids via_agp_dev
 		.chipset_name	= "PT880",
 	},
 
-	/* PT880 Ultra */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_PT880ULTRA,
-		.chipset_name	= "PT880 Ultra",
-	},
-
 	/* PT890 */
 	{
 		.device_id	= PCI_DEVICE_ID_VIA_8783_0,
@@ -379,11 +373,26 @@ static struct agp_device_ids via_agp_dev
 		.device_id	= PCI_DEVICE_ID_VIA_3296_0,
 		.chipset_name	= "P4M800",
 	},
-	/* P4M800CE */
-	{
-		.device_id	= PCI_DEVICE_ID_VIA_P4M800CE,
-		.chipset_name	= "P4M800CE",
-	},
+     /* P4M800CE */
+     {
+         .device_id  = PCI_DEVICE_ID_VIA_P4M800CE,
+         .chipset_name   = "VT3314",
+     },
+     /* CX700 */
+     {
+         .device_id  = PCI_DEVICE_ID_VIA_CX700_AGP,
+         .chipset_name   = "CX700",
+     },
+     /* VT3336 */
+     {
+         .device_id  = PCI_DEVICE_ID_VIA_VT3336,
+         .chipset_name   = "VT3336",
+     },
+     /* P4M890 */
+     {
+         .device_id  = PCI_DEVICE_ID_VIA_P4M890,
+         .chipset_name   = "P4M890",
+     },
 
 	{ }, /* dummy final entry, always present */
 };
@@ -487,7 +496,7 @@ static int agp_via_resume(struct pci_dev
 #endif /* CONFIG_PM */
 
 /* must be the same order as name table above */
-static const struct pci_device_id agp_via_pci_table[] = {
+static struct pci_device_id agp_via_pci_table[] = {
 #define ID(x) \
 	{						\
 	.class		= (PCI_CLASS_BRIDGE_HOST << 8),	\
@@ -519,13 +528,15 @@ static const struct pci_device_id agp_vi
 	ID(PCI_DEVICE_ID_VIA_8763_0),
 	ID(PCI_DEVICE_ID_VIA_8378_0),
 	ID(PCI_DEVICE_ID_VIA_PT880),
-	ID(PCI_DEVICE_ID_VIA_PT880ULTRA),
 	ID(PCI_DEVICE_ID_VIA_8783_0),
 	ID(PCI_DEVICE_ID_VIA_PX8X0_0),
 	ID(PCI_DEVICE_ID_VIA_3269_0),
 	ID(PCI_DEVICE_ID_VIA_83_87XX_1),
 	ID(PCI_DEVICE_ID_VIA_3296_0),
 	ID(PCI_DEVICE_ID_VIA_P4M800CE),
+	ID(PCI_DEVICE_ID_VIA_CX700_AGP),
+	ID(PCI_DEVICE_ID_VIA_VT3336),
+	ID(PCI_DEVICE_ID_VIA_P4M890),
 	{ }
 };
 
diff -puN drivers/char/drm/drm_pciids.h~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets drivers/char/drm/drm_pciids.h
diff -puN drivers/char/drm/Kconfig~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets drivers/char/drm/Kconfig
--- a/drivers/char/drm/Kconfig~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets
+++ a/drivers/char/drm/Kconfig
@@ -93,11 +93,12 @@ config DRM_SIS
           support is required for this driver to work.
 
 config DRM_VIA
-	tristate "Via unichrome video cards"
+	tristate "VIA UniChrome video cards"
 	depends on DRM
 	help
-	  Choose this option if you have a Via unichrome or compatible video
-	  chipset. If M is selected the module will be called via.
+	  Choose this option if you have a VIA UniChrome/UniChrome Pro
+	  or compatible video chipset. If M is selected the module will
+	  be called via.
 
 config DRM_SAVAGE
 	tristate "Savage video cards"
diff -puN include/linux/pci_ids.h~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets
+++ a/include/linux/pci_ids.h
@@ -1270,13 +1270,14 @@
 #define PCI_DEVICE_ID_VIA_8380_0	0x0204
 #define PCI_DEVICE_ID_VIA_3238_0	0x0238
 #define PCI_DEVICE_ID_VIA_PT880		0x0258
-#define PCI_DEVICE_ID_VIA_PT880ULTRA	0x0308
 #define PCI_DEVICE_ID_VIA_PX8X0_0	0x0259
 #define PCI_DEVICE_ID_VIA_3269_0	0x0269
 #define PCI_DEVICE_ID_VIA_K8T800PRO_0	0x0282
 #define PCI_DEVICE_ID_VIA_3296_0	0x0296
 #define PCI_DEVICE_ID_VIA_8363_0	0x0305
 #define PCI_DEVICE_ID_VIA_P4M800CE	0x0314
+#define PCI_DEVICE_ID_VIA_CX700_AGP	0x0324
+#define PCI_DEVICE_ID_VIA_P4M890	0x0327
 #define PCI_DEVICE_ID_VIA_K8M890CE	0x0336
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
@@ -1325,6 +1326,7 @@
 #define PCI_DEVICE_ID_VIA_8783_0	0x3208
 #define PCI_DEVICE_ID_VIA_8237		0x3227
 #define PCI_DEVICE_ID_VIA_8251		0x3287
+#define PCI_DEVICE_ID_VIA_VT3336	0x0336
 #define PCI_DEVICE_ID_VIA_8237A		0x3337
 #define PCI_DEVICE_ID_VIA_8231		0x8231
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
_

Patches currently in -mm which might be from claas@rootdir.de are

via-agp-and-drm-adding-support-for-cx700m2-p4m890-and-vt3336-chipsets.patch
