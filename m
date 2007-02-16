From: akpm@linux-foundation.org
Subject: - add-delay-around-sl82c105_reset_engine-calls.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:03:03 -0800
Message-ID: <200702160803.l1G833WD023974@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58791 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423395AbXBPIDG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:03:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olaf@aepfle.de, mm-commits@vger.kernel.org


The patch titled
     add delay around sl82c105_reset_engine calls
has been removed from the -mm tree.  Its filename was
     add-delay-around-sl82c105_reset_engine-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add delay around sl82c105_reset_engine calls
From: Olaf Hering <olaf@aepfle.de>

The hald media changed polling does really confuse things.  Noone knows why
the delays are needed, but they give us access to the CD.

An udelay(50) will give reliable access to the drive, but there is still one
(or more) EH reset.  The drive works without EH resets with udelay(100).

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sl82c105.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/ata/pata_sl82c105.c~add-delay-around-sl82c105_reset_engine-calls drivers/ata/pata_sl82c105.c
--- a/drivers/ata/pata_sl82c105.c~add-delay-around-sl82c105_reset_engine-calls
+++ a/drivers/ata/pata_sl82c105.c
@@ -187,7 +187,9 @@ static void sl82c105_bmdma_start(struct 
 {
 	struct ata_port *ap = qc->ap;
 
+	udelay(100);
 	sl82c105_reset_engine(ap);
+	udelay(100);
 
 	/* Set the clocks for DMA */
 	sl82c105_configure_dmamode(ap, qc->dev);
@@ -216,6 +218,7 @@ static void sl82c105_bmdma_stop(struct a
 
 	ata_bmdma_stop(qc);
 	sl82c105_reset_engine(ap);
+	udelay(100);
 
 	/* This will redo the initial setup of the DMA device to matching
 	   PIO timings */
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
cleanup-variable-usage-in-mesh-interrupt-handler.patch
keep-track-of-network-interface-renaming.patch
