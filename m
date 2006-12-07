From: akpm@osdl.org
Subject: - parport_pc-add-support-for-ox16pci952-parallel-port.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:00 -0800
Message-ID: <200612072303.kB7N301f029926@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163811AbWLGXDG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nemesis@icequake.net, mm-commits@vger.kernel.org


The patch titled
     parport_pc: Add support for OX16PCI952 parallel port
has been removed from the -mm tree.  Its filename was
     parport_pc-add-support-for-ox16pci952-parallel-port.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parport_pc: Add support for OX16PCI952 parallel port
From: Ryan Underwood <nemesis@icequake.net>

Add support for the parallel port (implemented as separate PCI function) on
the Oxford Semiconductor OX16PCI952.

Signed-off-by: Ryan Underwood <nemesis@icequake.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/parport/parport_pc.c |    4 ++++
 include/linux/pci_ids.h      |    1 +
 2 files changed, 5 insertions(+)

diff -puN drivers/parport/parport_pc.c~parport_pc-add-support-for-ox16pci952-parallel-port drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-add-support-for-ox16pci952-parallel-port
+++ a/drivers/parport/parport_pc.c
@@ -2747,6 +2747,7 @@ enum parport_pc_pci_cards {
 	titan_1284p2,
 	avlab_1p,
 	avlab_2p,
+	oxsemi_952,
 	oxsemi_954,
 	oxsemi_840,
 	aks_0100,
@@ -2822,6 +2823,7 @@ static struct parport_pc_pci {
 	/* avlab_2p		*/	{ 2, { { 0, 1}, { 2, 3 },} },
 	/* The Oxford Semi cards are unusual: 954 doesn't support ECP,
 	 * and 840 locks up if you write 1 to bit 2! */
+	/* oxsemi_952 */		{ 1, { { 0, 1 }, } },
 	/* oxsemi_954 */		{ 1, { { 0, -1 }, } },
 	/* oxsemi_840 */		{ 1, { { 0, -1 }, } },
 	/* aks_0100 */                  { 1, { { 0, -1 }, } },
@@ -2895,6 +2897,8 @@ static const struct pci_device_id parpor
 	/* PCI_VENDOR_ID_AVLAB/Intek21 has another bunch of cards ...*/
 	{ 0x14db, 0x2120, PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1p}, /* AFAVLAB_TK9902 */
 	{ 0x14db, 0x2121, PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_2p},
+	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI952PP,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_952 },
 	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954PP,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, oxsemi_954 },
 	{ PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_12PCI840,
diff -puN include/linux/pci_ids.h~parport_pc-add-support-for-ox16pci952-parallel-port include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~parport_pc-add-support-for-ox16pci952-parallel-port
+++ a/include/linux/pci_ids.h
@@ -1864,6 +1864,7 @@
 #define PCI_DEVICE_ID_OXSEMI_16PCI95N	0x9511
 #define PCI_DEVICE_ID_OXSEMI_16PCI954PP	0x9513
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
+#define PCI_DEVICE_ID_OXSEMI_16PCI952PP	0x9523
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
 
_

Patches currently in -mm which might be from nemesis@icequake.net are

origin.patch

