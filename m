From: akpm@linux-foundation.org
Subject: + parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard.patch added to -mm tree
Date: Wed, 12 Dec 2007 01:11:49 -0800
Message-ID: <200712120911.lBC9Bn07002502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbXLLJLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 04:11:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luis.p.mendes@gmail.com


The patch titled
     parport: add support for the Quatech SPPXP-100 Parallel port PCI E=
xpressCard
has been added to the -mm tree.  Its filename is
     parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-ex=
presscard.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: parport: add support for the Quatech SPPXP-100 Parallel port P=
CI ExpressCard
=46rom: Lu=EDs P Mendes <luis.p.mendes@gmail.com>

Added pci device id for the Quatech SPPXP-100 ExpressCard - 0x278 - to
include/linux/pci_id.h

Modified drivers/parport/parport_pc.c to support the Quatech SPPXP-100 =
Parallel port PCI ExpressCard

Signed-off-by: Lu=EDs P Mendes <luis.p.mendes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    5 +++++
 include/linux/pci_ids.h      |    3 +++
 2 files changed, 8 insertions(+)

diff -puN drivers/parport/parport_pc.c~parport-add-support-for-the-quat=
ech-sppxp-100-parallel-port-pci-expresscard drivers/parport/parport_pc.=
c
--- a/drivers/parport/parport_pc.c~parport-add-support-for-the-quatech-=
sppxp-100-parallel-port-pci-expresscard
+++ a/drivers/parport/parport_pc.c
@@ -2767,6 +2767,7 @@ enum parport_pc_pci_cards {
 	netmos_9755,
 	netmos_9805,
 	netmos_9815,
+	quatech_sppxp100,
 };
=20
=20
@@ -2843,6 +2844,7 @@ static struct parport_pc_pci {
         /* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },} },=
 /* untested */
 	/* netmos_9805 */               { 1, { { 0, -1 }, } }, /* untested */
 	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } }, /* =
untested */
+	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 };
=20
 static const struct pci_device_id parport_pc_pci_tbl[] =3D {
@@ -2926,6 +2928,9 @@ static const struct pci_device_id parpor
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9805 },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9815,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
+	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
+	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
 	{ 0, } /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci,parport_pc_pci_tbl);
diff -puN include/linux/pci_ids.h~parport-add-support-for-the-quatech-s=
ppxp-100-parallel-port-pci-expresscard include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~parport-add-support-for-the-quatech-sppxp=
-100-parallel-port-pci-expresscard
+++ a/include/linux/pci_ids.h
@@ -2477,3 +2477,6 @@
 #define PCI_DEVICE_ID_RME_DIGI32	0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
+
+#define PCI_VENDOR_ID_QUATECH		0x135c
+#define PCI_DEVICE_ID_QUATECH_SPPXP_100 0x0278
_

Patches currently in -mm which might be from luis.p.mendes@gmail.com ar=
e

parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-express=
card.patch
