From: akpm@linux-foundation.org
Subject: - parport_pc-it887x-fix.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:25 -0700
Message-ID: <200707162058.l6GKwPvx002343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757483AbXGPVHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:07:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: niels.devos@wincor-nixdorf.com, mm-commits@vger.kernel.org


The patch titled
     parport_pc: it887x fix
has been removed from the -mm tree.  Its filename was
     parport_pc-it887x-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: parport_pc: it887x fix
From: Niels de Vos <niels.devos@wincor-nixdorf.com>

The IO port range requested by parport_pc.c:sio_ite_8872_probe is too small. 
The IO-ports of ttyS1 (0x2f8) will be missconfigured by the ITE-chip.  The ITE
starts looking for the chip a 0x2a0.  An IO-portrange of 32 will not overwrite
the ports of ttyS1.  Therefore register 0x60 should be written with
0xe5000000, enabling the ITE and setting IO-portsize to 32 bytes.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/parport/parport_pc.c~parport_pc-it887x-fix drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pc-it887x-fix
+++ a/drivers/parport/parport_pc.c
@@ -2424,7 +2424,6 @@ static int __devinit sio_ite_8872_probe 
 	u32 ite8872set;
 	u32 ite8872_lpt, ite8872_lpthi;
 	u8 ite8872_irq, type;
-	char *fake_name = "parport probe";
 	int irq;
 	int i;
 
@@ -2432,11 +2431,11 @@ static int __devinit sio_ite_8872_probe 
 	
 	// make sure which one chip
 	for(i = 0; i < 5; i++) {
-		base_res = request_region(inta_addr[i], 0x8, fake_name);
+		base_res = request_region(inta_addr[i], 32, "it887x");
 		if (base_res) {
 			int test;
 			pci_write_config_dword (pdev, 0x60,
-						0xe7000000 | inta_addr[i]);
+						0xe5000000 | inta_addr[i]);
 			pci_write_config_dword (pdev, 0x78,
 						0x00000000 | inta_addr[i]);
 			test = inb (inta_addr[i]);
_

Patches currently in -mm which might be from niels.devos@wincor-nixdorf.com are

origin.patch
serial-add-support-for-ite-887x-chips.patch
