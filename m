From: akpm@linux-foundation.org
Subject: - parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:45 -0800
Message-ID: <200802070024.m170OQhP006607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934110AbYBGAoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luis.p.mendes@gmail.com, mm-commits@vger.kernel.org


The patch titled
     parport: add support for the Quatech SPPXP-100 Parallel port PCI E=
xpressCard
has been removed from the -mm tree.  Its filename was
     parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-ex=
presscard.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: parport: add support for the Quatech SPPXP-100 Parallel port P=
CI ExpressCard
=46rom: Lu=EDs P Mendes <luis.p.mendes@gmail.com>

Added pci device id for the Quatech SPPXP-100 ExpressCard - 0x278 - to
include/linux/pci_id.h

Modified drivers/parport/parport_pc.c to support the Quatech SPPXP-100 =
Parallel port PCI ExpressCard

[akpm@linux-foundation.org: build fix]
Signed-off-by: Lu=EDs P Mendes <luis.p.mendes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    5 +++++
 include/linux/pci_ids.h      |    1 +
 2 files changed, 6 insertions(+)

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
@@ -1765,6 +1765,7 @@
 #define PCI_DEVICE_ID_QUATECH_DSC100	0x0020
 #define PCI_DEVICE_ID_QUATECH_ESC100D	0x0050
 #define PCI_DEVICE_ID_QUATECH_ESC100M	0x0060
+#define PCI_DEVICE_ID_QUATECH_SPPXP_100 0x0278
=20
 #define PCI_VENDOR_ID_SEALEVEL		0x135e
 #define PCI_DEVICE_ID_SEALEVEL_U530	0x7101
_

Patches currently in -mm which might be from luis.p.mendes@gmail.com ar=
e

origin.patch
