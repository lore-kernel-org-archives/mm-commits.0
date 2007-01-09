From: akpm@osdl.org
Subject: - sata_promise-unbreak-20619.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:29:01 -0800
Message-ID: <200701092029.l09KT1PK014344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41087 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbXAIU3J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:29:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     sata_promise: unbreak 20619
has been removed from the -mm tree.  Its filename was
     sata_promise-unbreak-20619.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_promise: unbreak 20619
From: Mikael Pettersson <mikpe@it.uu.se>

The PATA support patch for sata_promise appears, from code inspection, to
break the PATA-only 20619 chip.

The patch removes the SATA flag from the TX2plus SATA+PATA boards' common
flags, with the intention of adding it back via the _port_flags[] entries for
those boards' SATA ports.

However, it unconditionally marks ports 0 and 1 as SATA for all boards.  This
causes the 20619 (TX4000) to announce its first two PATA ports as SATA |
ATA_FLAG_SLAVE_POSS.

I don't have a TX4000 so I don't know what the actual consequences of this bug
are, but surely this isn't Ok.

Fixed by moving the port 0 and 1 settings as SATA into the TX4 and TX2plus
specific initialisation code.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/sata_promise.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-unbreak-20619 drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-unbreak-20619
+++ a/drivers/ata/sata_promise.c
@@ -957,9 +957,6 @@ static int pdc_ata_init_one (struct pci_
 	probe_ent->port[0].scr_addr = base + 0x400;
 	probe_ent->port[1].scr_addr = base + 0x500;
 
-	probe_ent->_port_flags[0] = ATA_FLAG_SATA;
-	probe_ent->_port_flags[1] = ATA_FLAG_SATA;
-	
 	/* notice 4-port boards */
 	switch (board_idx) {
 	case board_40518:
@@ -974,6 +971,8 @@ static int pdc_ata_init_one (struct pci_
 		probe_ent->port[2].scr_addr = base + 0x600;
 		probe_ent->port[3].scr_addr = base + 0x700;
 	
+		probe_ent->_port_flags[0] = ATA_FLAG_SATA;
+		probe_ent->_port_flags[1] = ATA_FLAG_SATA;
 		probe_ent->_port_flags[2] = ATA_FLAG_SATA;
 		probe_ent->_port_flags[3] = ATA_FLAG_SATA;
 		break;
@@ -995,6 +994,8 @@ static int pdc_ata_init_one (struct pci_
 		}
 		else
        			probe_ent->n_ports = 2;
+		probe_ent->_port_flags[0] = ATA_FLAG_SATA;
+		probe_ent->_port_flags[1] = ATA_FLAG_SATA;
 		break;
 	case board_20619:
 		probe_ent->n_ports = 4;
_

Patches currently in -mm which might be from mikpe@it.uu.se are

git-libata-all.patch
