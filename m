From: akpm@linux-foundation.org
Subject: [merged]
 drivers-parport-parport_pcc-remove-double-pci-id-for-netmos.patch removed
 from -mm tree
Date: Thu, 12 Dec 2013 12:47:48 -0800
Message-ID: <52aa20f4.zpiNRueduiGbq0Yc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3LLUrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Dec 2013 15:47:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, maks@stro.at, bigeasy@linutronix.de

Subject: [merged] drivers-parport-parport_pcc-remove-double-pci-id-for-netmos.patch removed from -mm tree
To: bigeasy@linutronix.de,maks@stro.at,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Dec 2013 12:47:48 -0800


The patch titled
     Subject: drivers/parport/parport_pc.c: remove double PCI ID for NetMos
has been removed from the -mm tree.  Its filename was
     drivers-parport-parport_pcc-remove-double-pci-id-for-netmos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: drivers/parport/parport_pc.c: remove double PCI ID for NetMos

In commit 85747f ("PATCH] parport: add NetMOS 9805 support") Max added the
PCI ID for NetMOS 9805 based on a Debian bug report from 2k4 which was at
the v2.4.26 time frame.  The patch made into 2.6.14.  Shortly before that
patch akpm merged commit 296d3c783b ("[PATCH] Support NetMOS based PCI
cards providing serial and parallel ports") which made into v2.6.9-rc1.

Now we have two different entries for the same PCI id.  I have here the
NetMos 9805 which claims to support SPP/EPP/ECP mode.  This patch takes
Max's entry for titan_1284p1 (base != -1 specifies the ioport for ECP
mode) and replaces akpm's entry for netmos_9805 which specified -1
(=none).  Both share the same PCI-ID (my card has subsystem 0x1000 /
0x0020 so it should match PCI_ANY).

While here I also drop the entry for titan_1284p2 which is the same as
netmos_9815.


The only runtime visible change I notice is with KERN_DEBUG being visible.
 The card details are the same, it always prints

|parport1: PC-style at 0xc120 (0xc128), irq 11, using FIFO
[PCSPP,TRISTATE,COMPAT,ECP]

However the ID that was used to detect the card is different:

| PCI parallel port detected: 1415:c118, I/O at 0xc120(0xc128), IRQ 11

vs

| PCI parallel port detected: 9710:9805, I/O at 0xc120(0xc128), IRQ 11

The wrong id print is printed for all devices which come after
PCI_DEVICE_ID_OXSEMI_PCIe840_G in the id table because the code that
prints the ID table assumes one id per entry.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Maximilian Attems <maks@stro.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/parport/parport_pc.c~drivers-parport-parport_pcc-remove-double-pci-id-for-netmos drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~drivers-parport-parport_pcc-remove-double-pci-id-for-netmos
+++ a/drivers/parport/parport_pc.c
@@ -2600,8 +2600,6 @@ enum parport_pc_pci_cards {
 	syba_2p_epp,
 	syba_1p_ecp,
 	titan_010l,
-	titan_1284p1,
-	titan_1284p2,
 	avlab_1p,
 	avlab_2p,
 	oxsemi_952,
@@ -2660,8 +2658,6 @@ static struct parport_pc_pci {
 	/* syba_2p_epp AP138B */	{ 2, { { 0, 0x078 }, { 0, 0x178 }, } },
 	/* syba_1p_ecp W83787 */	{ 1, { { 0, 0x078 }, } },
 	/* titan_010l */		{ 1, { { 3, -1 }, } },
-	/* titan_1284p1 */              { 1, { { 0, 1 }, } },
-	/* titan_1284p2 */		{ 2, { { 0, 1 }, { 2, 3 }, } },
 	/* avlab_1p		*/	{ 1, { { 0, 1}, } },
 	/* avlab_2p		*/	{ 2, { { 0, 1}, { 2, 3 },} },
 	/* The Oxford Semi cards are unusual: 954 doesn't support ECP,
@@ -2677,8 +2673,8 @@ static struct parport_pc_pci {
 	/* netmos_9705 */               { 1, { { 0, -1 }, } },
 	/* netmos_9715 */               { 2, { { 0, 1 }, { 2, 3 },} },
 	/* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },} },
-	/* netmos_9805 */               { 1, { { 0, -1 }, } },
-	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } },
+	/* netmos_9805 */		{ 1, { { 0, 1 }, } },
+	/* netmos_9815 */		{ 2, { { 0, 1 }, { 2, 3 }, } },
 	/* netmos_9901 */               { 1, { { 0, -1 }, } },
 	/* netmos_9865 */               { 1, { { 0, -1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
@@ -2722,8 +2718,6 @@ static const struct pci_device_id parpor
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, syba_1p_ecp },
 	{ PCI_VENDOR_ID_TITAN, PCI_DEVICE_ID_TITAN_010L,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, titan_010l },
-	{ 0x9710, 0x9805, 0x1000, 0x0010, 0, 0, titan_1284p1 },
-	{ 0x9710, 0x9815, 0x1000, 0x0020, 0, 0, titan_1284p2 },
 	/* PCI_VENDOR_ID_AVLAB/Intek21 has another bunch of cards ...*/
 	/* AFAVLAB_TK9902 */
 	{ 0x14db, 0x2120, PCI_ANY_ID, PCI_ANY_ID, 0, 0, avlab_1p},
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

origin.patch
linux-next.patch

