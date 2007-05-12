From: akpm@linux-foundation.org
Subject: - fix-pata_qdic-probe-code.patch removed from -mm tree
Date: Fri, 11 May 2007 22:14:18 -0700
Message-ID: <200705120514.l4C5EIqO001666@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537AbXELFOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:14:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Fix pata_qdi.c probe code
has been removed from the -mm tree.  Its filename was
     fix-pata_qdic-probe-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix pata_qdi.c probe code
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

There is a small typo in the probe code of pata_qdi.c.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_qdi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/ata/pata_qdi.c~fix-pata_qdic-probe-code drivers/ata/pata_qdi.c
--- a/drivers/ata/pata_qdi.c~fix-pata_qdic-probe-code
+++ a/drivers/ata/pata_qdi.c
@@ -375,7 +375,7 @@ static __init int qdi_init(void)
 				res = inb(port + 3);
 				if (res & 1) {
 					/* Single channel mode */
-					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04))
+					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
 						ct++;
 				} else {
 					/* Dual channel mode */
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
