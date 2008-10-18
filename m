From: akpm@linux-foundation.org
Subject: - intelfb-support-945gme-as-used-in-asus-eee-901.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:05 -0700
Message-ID: <200810182317.m9INH5ps029018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbYJRXRN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phil_wueww_endecott@chezphil.org, geoffroy.carrier@koon.fr, krzysztof.h1@wp.pl, spam_from_intelfb@chezphil.org, mm-commits@vger.kernel.org


The patch titled
     intelfb: support 945GME (as used in ASUS Eee 901)
has been removed from the -mm tree.  Its filename was
     intelfb-support-945gme-as-used-in-asus-eee-901.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: intelfb: support 945GME (as used in ASUS Eee 901)
=46rom: Phil Endecott <phil_wueww_endecott@chezphil.org>

Add support for Intel's 945GME graphics chip to the intelfb driver.  I
have assumed that the 945GME is identical to the already-supported 945G=
M
apart from its PCI IDs; this is based on a quick look at the X driver f=
or
these chips which seems to treat them identically.

The 945GME is used in the ASUS Eee 901, and I coded this in the hope th=
at
I'd be able to use it to get a console at the native 1024x600 resolutio=
n
which is not known to the BIOS.  I realised too late that the intelfb
driver does not support mode changing on laptops, so it won't be any
use for me.

Signed-off-by: Phil Endecott <spam_from_intelfb@chezphil.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/intelfb.txt        |    1 +
 drivers/video/intelfb/intelfb.h     |    7 +++++--
 drivers/video/intelfb/intelfb_i2c.c |    1 +
 drivers/video/intelfb/intelfbdrv.c  |    7 ++++++-
 drivers/video/intelfb/intelfbhw.c   |    7 +++++++
 5 files changed, 20 insertions(+), 3 deletions(-)

diff -puN Documentation/fb/intelfb.txt~intelfb-support-945gme-as-used-i=
n-asus-eee-901 Documentation/fb/intelfb.txt
--- a/Documentation/fb/intelfb.txt~intelfb-support-945gme-as-used-in-as=
us-eee-901
+++ a/Documentation/fb/intelfb.txt
@@ -14,6 +14,7 @@ graphics devices.  These would include:
 	Intel 915GM
 	Intel 945G
 	Intel 945GM
+	Intel 945GME
 	Intel 965G
 	Intel 965GM
=20
diff -puN drivers/video/intelfb/intelfb.h~intelfb-support-945gme-as-use=
d-in-asus-eee-901 drivers/video/intelfb/intelfb.h
--- a/drivers/video/intelfb/intelfb.h~intelfb-support-945gme-as-used-in=
-asus-eee-901
+++ a/drivers/video/intelfb/intelfb.h
@@ -12,9 +12,9 @@
 #endif
=20
 /*** Version/name ***/
-#define INTELFB_VERSION			"0.9.5"
+#define INTELFB_VERSION			"0.9.6"
 #define INTELFB_MODULE_NAME		"intelfb"
-#define SUPPORTED_CHIPSETS		"830M/845G/852GM/855GM/865G/915G/915GM/945=
G/945GM/965G/965GM"
+#define SUPPORTED_CHIPSETS		"830M/845G/852GM/855GM/865G/915G/915GM/945=
G/945GM/945GME/965G/965GM"
=20
=20
 /*** Debug/feature defines ***/
@@ -58,6 +58,7 @@
 #define PCI_DEVICE_ID_INTEL_915GM	0x2592
 #define PCI_DEVICE_ID_INTEL_945G	0x2772
 #define PCI_DEVICE_ID_INTEL_945GM	0x27A2
+#define PCI_DEVICE_ID_INTEL_945GME	0x27AE
 #define PCI_DEVICE_ID_INTEL_965G	0x29A2
 #define PCI_DEVICE_ID_INTEL_965GM	0x2A02
=20
@@ -160,6 +161,7 @@ enum intel_chips {
 	INTEL_915GM,
 	INTEL_945G,
 	INTEL_945GM,
+	INTEL_945GME,
 	INTEL_965G,
 	INTEL_965GM,
 };
@@ -363,6 +365,7 @@ struct intelfb_info {
 			((dinfo)->chipset =3D=3D INTEL_915GM) ||	\
 			((dinfo)->chipset =3D=3D INTEL_945G) ||	\
 			((dinfo)->chipset =3D=3D INTEL_945GM) ||	\
+			((dinfo)->chipset =3D=3D INTEL_945GME) ||	\
 			((dinfo)->chipset =3D=3D INTEL_965G) ||	\
 			((dinfo)->chipset =3D=3D INTEL_965GM))
=20
diff -puN drivers/video/intelfb/intelfb_i2c.c~intelfb-support-945gme-as=
-used-in-asus-eee-901 drivers/video/intelfb/intelfb_i2c.c
--- a/drivers/video/intelfb/intelfb_i2c.c~intelfb-support-945gme-as-use=
d-in-asus-eee-901
+++ a/drivers/video/intelfb/intelfb_i2c.c
@@ -171,6 +171,7 @@ void intelfb_create_i2c_busses(struct in
 		/* has some LVDS + tv-out */
 	case INTEL_945G:
 	case INTEL_945GM:
+	case INTEL_945GME:
 	case INTEL_965G:
 	case INTEL_965GM:
 		/* SDVO ports have a single control bus - 2 devices */
diff -puN drivers/video/intelfb/intelfbdrv.c~intelfb-support-945gme-as-=
used-in-asus-eee-901 drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~intelfb-support-945gme-as-used=
-in-asus-eee-901
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -2,7 +2,7 @@
  * intelfb
  *
  * Linux framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/91=
5G/915GM/
- * 945G/945GM/965G/965GM integrated graphics chips.
+ * 945G/945GM/945GME/965G/965GM integrated graphics chips.
  *
  * Copyright =C2=A9 2002, 2003 David Dawes <dawes@xfree86.org>
  *                   2004 Sylvain Meyer
@@ -102,6 +102,9 @@
  *
  *    04/2008 - Version 0.9.5
  *              Add support for 965G/965GM. (Maik Broemme <mbroemme@pl=
usserver.de>)
+ *
+ *    08/2008 - Version 0.9.6
+ *              Add support for 945GME. (Phil Endecott <spam_from_inte=
lfb@chezphil.org>)
  */
=20
 #include <linux/module.h>
@@ -183,6 +186,7 @@ static struct pci_device_id intelfb_pci_
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_915GM, PCI_ANY_ID, PCI_ANY=
_ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_915GM },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_945G, PCI_ANY_ID, PCI_ANY_=
ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_945G },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_945GM, PCI_ANY_ID, PCI_ANY=
_ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_945GM },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_945GME, PCI_ANY_ID, PCI_AN=
Y_ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_945GME },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_965G, PCI_ANY_ID, PCI_ANY_=
ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_965G },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_965GM, PCI_ANY_ID, PCI_ANY=
_ID, PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_965GM },
 	{ 0, }
@@ -555,6 +559,7 @@ static int __devinit intelfb_pci_registe
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_915GM) ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945G)  ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945GM) ||
+	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945GME) ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_965G) ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_965GM)) {
=20
diff -puN drivers/video/intelfb/intelfbhw.c~intelfb-support-945gme-as-u=
sed-in-asus-eee-901 drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~intelfb-support-945gme-as-used-=
in-asus-eee-901
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -143,6 +143,12 @@ int intelfbhw_get_chipset(struct pci_dev
 		dinfo->mobile =3D 1;
 		dinfo->pll_index =3D PLLS_I9xx;
 		return 0;
+	case PCI_DEVICE_ID_INTEL_945GME:
+		dinfo->name =3D "Intel(R) 945GME";
+		dinfo->chipset =3D INTEL_945GME;
+		dinfo->mobile =3D 1;
+		dinfo->pll_index =3D PLLS_I9xx;
+		return 0;
 	case PCI_DEVICE_ID_INTEL_965G:
 		dinfo->name =3D "Intel(R) 965G";
 		dinfo->chipset =3D INTEL_965G;
@@ -186,6 +192,7 @@ int intelfbhw_get_memory(struct pci_dev=20
 	case PCI_DEVICE_ID_INTEL_915GM:
 	case PCI_DEVICE_ID_INTEL_945G:
 	case PCI_DEVICE_ID_INTEL_945GM:
+	case PCI_DEVICE_ID_INTEL_945GME:
 	case PCI_DEVICE_ID_INTEL_965G:
 	case PCI_DEVICE_ID_INTEL_965GM:
 		/* 915, 945 and 965 chipsets support a 256MB aperture.
_

Patches currently in -mm which might be from phil_wueww_endecott@chezph=
il.org are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
