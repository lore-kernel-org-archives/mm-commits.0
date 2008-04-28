From: akpm@linux-foundation.org
Subject: - fbdev-intelfb-add-support-for-the-intel-integrated-graphics-controller-965g-965gm.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:38 -0700
Message-ID: <200804282159.m3SLxc4h018604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965560AbYD1WAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mbroemme@plusserver.de, Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, airlied@linux.ie, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     fbdev: intelfb: add support for the Intel Integrated Graphics Cont=
roller 965G/965GM
has been removed from the -mm tree.  Its filename was
     fbdev-intelfb-add-support-for-the-intel-integrated-graphics-contro=
ller-965g-965gm.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fbdev: intelfb: add support for the Intel Integrated Graphics =
Controller 965G/965GM
=46rom: Maik Broemme <mbroemme@plusserver.de>

Add support for the 965G and 965GM graphic chipsets to the intelfb driv=
er.  I
have a notebook with an Intel Mobile GM965/GL960 Integrated Graphics
Controller and with the attached patch the framebuffer comes up.  I hav=
e
tested it a bit with DirectFB to make sure it is working stable.

I also have an Intel Mobile GM945 and I compared the results, the progr=
amming
interface of the 9xx series from Intel is mostly the same, so I think t=
he
patch should add all the functionality which the 945GM has.

Signed-off-by: Maik Broemme <mbroemme@plusserver.de>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/intelfb.txt        |    2 ++
 drivers/video/Kconfig               |    4 ++--
 drivers/video/intelfb/intelfb.h     |   12 +++++++++---
 drivers/video/intelfb/intelfb_i2c.c |    2 ++
 drivers/video/intelfb/intelfbdrv.c  |   12 ++++++++++--
 drivers/video/intelfb/intelfbhw.c   |   16 +++++++++++++++-
 6 files changed, 40 insertions(+), 8 deletions(-)

diff -puN Documentation/fb/intelfb.txt~fbdev-intelfb-add-support-for-th=
e-intel-integrated-graphics-controller-965g-965gm Documentation/fb/inte=
lfb.txt
--- a/Documentation/fb/intelfb.txt~fbdev-intelfb-add-support-for-the-in=
tel-integrated-graphics-controller-965g-965gm
+++ a/Documentation/fb/intelfb.txt
@@ -14,6 +14,8 @@ graphics devices.  These would include:
 	Intel 915GM
 	Intel 945G
 	Intel 945GM
+	Intel 965G
+	Intel 965GM
=20
 B.  List of available options
=20
diff -puN drivers/video/Kconfig~fbdev-intelfb-add-support-for-the-intel=
-integrated-graphics-controller-965g-965gm drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-intelfb-add-support-for-the-intel-int=
egrated-graphics-controller-965g-965gm
+++ a/drivers/video/Kconfig
@@ -1119,7 +1119,7 @@ config FB_CARILLO_RANCH
 	  This driver supports the LE80578 (Carillo Ranch) board
=20
 config FB_INTEL
-	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G support (EXPERIM=
ENTAL)"
+	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM=
 support (EXPERIMENTAL)"
 	depends on FB && EXPERIMENTAL && PCI && X86
 	select AGP
 	select AGP_INTEL
@@ -1129,7 +1129,7 @@ config FB_INTEL
 	select FB_CFB_IMAGEBLIT
 	help
 	  This driver supports the on-board graphics built in to the Intel
-          830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets.
+          830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM =
chipsets.
           Say Y if you have and plan to use such a board.
=20
 	  If you say Y here and want DDC/I2C support you must first say Y to
diff -puN drivers/video/intelfb/intelfb.h~fbdev-intelfb-add-support-for=
-the-intel-integrated-graphics-controller-965g-965gm drivers/video/inte=
lfb/intelfb.h
--- a/drivers/video/intelfb/intelfb.h~fbdev-intelfb-add-support-for-the=
-intel-integrated-graphics-controller-965g-965gm
+++ a/drivers/video/intelfb/intelfb.h
@@ -12,9 +12,9 @@
 #endif
=20
 /*** Version/name ***/
-#define INTELFB_VERSION			"0.9.4"
+#define INTELFB_VERSION			"0.9.5"
 #define INTELFB_MODULE_NAME		"intelfb"
-#define SUPPORTED_CHIPSETS		"830M/845G/852GM/855GM/865G/915G/915GM/945=
G/945GM"
+#define SUPPORTED_CHIPSETS		"830M/845G/852GM/855GM/865G/915G/915GM/945=
G/945GM/965G/965GM"
=20
=20
 /*** Debug/feature defines ***/
@@ -58,6 +58,8 @@
 #define PCI_DEVICE_ID_INTEL_915GM	0x2592
 #define PCI_DEVICE_ID_INTEL_945G	0x2772
 #define PCI_DEVICE_ID_INTEL_945GM	0x27A2
+#define PCI_DEVICE_ID_INTEL_965G	0x29A2
+#define PCI_DEVICE_ID_INTEL_965GM	0x2A02
=20
 /* Size of MMIO region */
 #define INTEL_REG_SIZE			0x80000
@@ -158,6 +160,8 @@ enum intel_chips {
 	INTEL_915GM,
 	INTEL_945G,
 	INTEL_945GM,
+	INTEL_965G,
+	INTEL_965GM,
 };
=20
 struct intelfb_hwstate {
@@ -358,7 +362,9 @@ struct intelfb_info {
 #define IS_I9XX(dinfo) (((dinfo)->chipset =3D=3D INTEL_915G) ||	\
 			((dinfo)->chipset =3D=3D INTEL_915GM) ||	\
 			((dinfo)->chipset =3D=3D INTEL_945G) ||	\
-			((dinfo)->chipset=3D=3DINTEL_945GM))
+			((dinfo)->chipset =3D=3D INTEL_945GM) ||	\
+			((dinfo)->chipset =3D=3D INTEL_965G) ||	\
+			((dinfo)->chipset =3D=3D INTEL_965GM))
=20
 #ifndef FBIO_WAITFORVSYNC
 #define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
diff -puN drivers/video/intelfb/intelfb_i2c.c~fbdev-intelfb-add-support=
-for-the-intel-integrated-graphics-controller-965g-965gm drivers/video/=
intelfb/intelfb_i2c.c
--- a/drivers/video/intelfb/intelfb_i2c.c~fbdev-intelfb-add-support-for=
-the-intel-integrated-graphics-controller-965g-965gm
+++ a/drivers/video/intelfb/intelfb_i2c.c
@@ -169,6 +169,8 @@ void intelfb_create_i2c_busses(struct in
 		/* has some LVDS + tv-out */
 	case INTEL_945G:
 	case INTEL_945GM:
+	case INTEL_965G:
+	case INTEL_965GM:
 		/* SDVO ports have a single control bus - 2 devices */
 		dinfo->output[i].type =3D INTELFB_OUTPUT_SDVO;
 		intelfb_setup_i2c_bus(dinfo, &dinfo->output[i].i2c_bus,
diff -puN drivers/video/intelfb/intelfbdrv.c~fbdev-intelfb-add-support-=
for-the-intel-integrated-graphics-controller-965g-965gm drivers/video/i=
ntelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~fbdev-intelfb-add-support-for-=
the-intel-integrated-graphics-controller-965g-965gm
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -2,7 +2,7 @@
  * intelfb
  *
  * Linux framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/91=
5G/915GM/
- * 945G/945GM integrated graphics chips.
+ * 945G/945GM/965G/965GM integrated graphics chips.
  *
  * Copyright =C2=A9 2002, 2003 David Dawes <dawes@xfree86.org>
  *                   2004 Sylvain Meyer
@@ -99,6 +99,9 @@
  *              Add vram option to reserve more memory than stolen by =
BIOS
  *              Fix intelfbhw_pan_display typo
  *              Add __initdata annotations
+ *
+ *    04/2008 - Version 0.9.5
+ *              Add support for 965G/965GM. (Maik Broemme <mbroemme@pl=
usserver.de>)
  */
=20
 #include <linux/module.h>
@@ -180,6 +183,8 @@ static struct pci_device_id intelfb_pci_
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_915GM, PCI_ANY_ID, PCI_ANY=
_ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_915GM },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_945G, PCI_ANY_ID, PCI_ANY_=
ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_945G },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_945GM, PCI_ANY_ID, PCI_ANY=
_ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_945GM },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_965G, PCI_ANY_ID, PCI_ANY_=
ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_965G },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_965GM, PCI_ANY_ID, PCI_ANY=
_ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_965GM },
 	{ 0, }
 };
=20
@@ -549,7 +554,10 @@ static int __devinit intelfb_pci_registe
 	if ((ent->device =3D=3D PCI_DEVICE_ID_INTEL_915G) ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_915GM) ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945G)  ||
-	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945GM)) {
+	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945GM) ||
+	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_965G) ||
+	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_965GM)) {
+
 		aperture_bar =3D 2;
 		mmio_bar =3D 0;
 	}
diff -puN drivers/video/intelfb/intelfbhw.c~fbdev-intelfb-add-support-f=
or-the-intel-integrated-graphics-controller-965g-965gm drivers/video/in=
telfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~fbdev-intelfb-add-support-for-t=
he-intel-integrated-graphics-controller-965g-965gm
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -143,6 +143,18 @@ int intelfbhw_get_chipset(struct pci_dev
 		dinfo->mobile =3D 1;
 		dinfo->pll_index =3D PLLS_I9xx;
 		return 0;
+	case PCI_DEVICE_ID_INTEL_965G:
+		dinfo->name =3D "Intel(R) 965G";
+		dinfo->chipset =3D INTEL_965G;
+		dinfo->mobile =3D 0;
+		dinfo->pll_index =3D PLLS_I9xx;
+		return 0;
+	case PCI_DEVICE_ID_INTEL_965GM:
+		dinfo->name =3D "Intel(R) 965GM";
+		dinfo->chipset =3D INTEL_965GM;
+		dinfo->mobile =3D 1;
+		dinfo->pll_index =3D PLLS_I9xx;
+		return 0;
 	default:
 		return 1;
 	}
@@ -174,7 +186,9 @@ int intelfbhw_get_memory(struct pci_dev=20
 	case PCI_DEVICE_ID_INTEL_915GM:
 	case PCI_DEVICE_ID_INTEL_945G:
 	case PCI_DEVICE_ID_INTEL_945GM:
-		/* 915 and 945 chipsets support a 256MB aperture.
+	case PCI_DEVICE_ID_INTEL_965G:
+	case PCI_DEVICE_ID_INTEL_965GM:
+		/* 915, 945 and 965 chipsets support a 256MB aperture.
 		   Aperture size is determined by inspected the
 		   base address of the aperture. */
 		if (pci_resource_start(pdev, 2) & 0x08000000)
_

Patches currently in -mm which might be from mbroemme@plusserver.de are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
