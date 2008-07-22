From: akpm@linux-foundation.org
Subject: + intel_agp-official-name-for-gm45-chipset.patch added to -mm tree
Date: Tue, 22 Jul 2008 03:44:16 -0700
Message-ID: <200807221044.m6MAiG6v024112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753638AbYGVKok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 06:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenyu.z.wang@intel.com, airlied@linux.ie


The patch titled
     intel_agp: official name for GM45 chipset
has been added to the -mm tree.  Its filename is
     intel_agp-official-name-for-gm45-chipset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: intel_agp: official name for GM45 chipset
=46rom: Zhenyu Wang <zhenyu.z.wang@intel.com>

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-official-name-for-gm45=
-chipset drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-official-name-for-gm45-chi=
pset
+++ a/drivers/char/agp/intel-agp.c
@@ -32,8 +32,8 @@
 #define PCI_DEVICE_ID_INTEL_Q35_IG          0x29B2
 #define PCI_DEVICE_ID_INTEL_Q33_HB          0x29D0
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
-#define PCI_DEVICE_ID_INTEL_IGD_HB          0x2A40
-#define PCI_DEVICE_ID_INTEL_IGD_IG          0x2A42
+#define PCI_DEVICE_ID_INTEL_GM45_HB         0x2A40
+#define PCI_DEVICE_ID_INTEL_GM45_IG         0x2A42
 #define PCI_DEVICE_ID_INTEL_IGD_E_HB        0x2E00
 #define PCI_DEVICE_ID_INTEL_IGD_E_IG        0x2E02
 #define PCI_DEVICE_ID_INTEL_Q45_HB          0x2E10
@@ -55,7 +55,7 @@
 		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_82965G_HB || \
 		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_82965GM_HB || \
 		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_82965GME_HB || \
-		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_IGD_HB)
+		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_GM45_HB)
=20
 #define IS_G33 (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_G33=
_HB || \
 		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_Q35_HB || \
@@ -1182,7 +1182,7 @@ static unsigned long intel_i965_mask_mem
 static void intel_i965_get_gtt_range(int *gtt_offset, int *gtt_size)
 {
 	switch (agp_bridge->dev->device) {
-	case PCI_DEVICE_ID_INTEL_IGD_HB:
+	case PCI_DEVICE_ID_INTEL_GM45_HB:
 	case PCI_DEVICE_ID_INTEL_IGD_E_HB:
 	case PCI_DEVICE_ID_INTEL_Q45_HB:
 	case PCI_DEVICE_ID_INTEL_G45_HB:
@@ -2117,8 +2117,8 @@ static const struct intel_driver_descrip
 		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
 		NULL, &intel_g33_driver },
-	{ PCI_DEVICE_ID_INTEL_IGD_HB, PCI_DEVICE_ID_INTEL_IGD_IG, 0,
-	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_GM45_HB, PCI_DEVICE_ID_INTEL_GM45_IG, 0,
+	    "Mobile Intel=AE GM45 Express", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_IGD_E_HB, PCI_DEVICE_ID_INTEL_IGD_E_IG, 0,
 	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_Q45_HB, PCI_DEVICE_ID_INTEL_Q45_IG, 0,
@@ -2315,7 +2315,7 @@ static struct pci_device_id agp_intel_pc
 	ID(PCI_DEVICE_ID_INTEL_G33_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
-	ID(PCI_DEVICE_ID_INTEL_IGD_HB),
+	ID(PCI_DEVICE_ID_INTEL_GM45_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGD_E_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com ar=
e

intel_agp-official-name-for-gm45-chipset.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
