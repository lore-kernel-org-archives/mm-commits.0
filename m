From: akpm@osdl.org
Subject: - sata_promise-2037x-patapi-support.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:29:04 -0800
Message-ID: <200701092029.l09KT4YF014348@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403AbXAIU3I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:29:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mikpe@it.uu.se, mm-commits@vger.kernel.org


The patch titled
     sata_promise: 2037x PATAPI support
has been removed from the -mm tree.  Its filename was
     sata_promise-2037x-patapi-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sata_promise: 2037x PATAPI support
From: Mikael Pettersson <mikpe@it.uu.se>

This patch adds ATAPI support for the PATA port on Promise 2037x chips.

First-generation chips don't support ATAPI on their SATA ports, so the patch
removes ATA_FLAG_NO_ATAPI from the 2037x common host flags, and adds it back
via the _port_flags[] entries for the SATA ports.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/sata_promise.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-2037x-patapi-support drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-2037x-patapi-support
+++ a/drivers/ata/sata_promise.c
@@ -187,7 +187,7 @@ static const struct ata_port_info pdc_po
 	/* board_2037x */
 	{
 		.sht		= &pdc_ata_sht,
-		.flags		= PDC_COMMON_FLAGS /* | ATA_FLAG_SATA */,
+		.flags		= PDC_COMMON_FLAGS /* | ATA_FLAG_NO_ATAPI | ATA_FLAG_SATA */,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
@@ -996,6 +996,10 @@ static int pdc_ata_init_one (struct pci_
        			probe_ent->n_ports = 2;
 		probe_ent->_port_flags[0] = ATA_FLAG_SATA;
 		probe_ent->_port_flags[1] = ATA_FLAG_SATA;
+		if (board_idx == board_2037x) {
+			probe_ent->_port_flags[0] |= ATA_FLAG_NO_ATAPI;
+			probe_ent->_port_flags[1] |= ATA_FLAG_NO_ATAPI;
+		}
 		break;
 	case board_20619:
 		probe_ent->n_ports = 4;
_

Patches currently in -mm which might be from mikpe@it.uu.se are

git-libata-all.patch
