From: akpm@linux-foundation.org
Subject: - ahci-enable-ghcae-bit-before-set-ghchr.patch removed from -mm tree
Date: Fri, 21 Sep 2007 11:02:01 -0700
Message-ID: <200709211802.l8LI21FZ015716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbXIUSCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 14:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ahci: enable GHC.AE bit before set GHC.HR
has been removed from the -mm tree.  Its filename was
     ahci-enable-ghcae-bit-before-set-ghchr.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: ahci: enable GHC.AE bit before set GHC.HR
From: "Peer Chen" <peerchen@gmail.com>

According to the description of section 5.2.2.1 and 10.1.2 of AHCI
specification rev1_1/rev1_2, GHC.HR shall only be set to 1 by software when
GHC.AE is set to 1.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/ahci.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/ata/ahci.c~ahci-enable-ghcae-bit-before-set-ghchr drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~ahci-enable-ghcae-bit-before-set-ghchr
+++ a/drivers/ata/ahci.c
@@ -834,6 +834,10 @@ static int ahci_reset_controller(struct 
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	u32 tmp;
 
+        /* turn on AHCI mode before controller reset*/
+        writel(HOST_AHCI_EN, mmio + HOST_CTL);
+        (void) readl(mmio + HOST_CTL);  /* flush */
+
 	/* global controller reset */
 	tmp = readl(mmio + HOST_CTL);
 	if ((tmp & HOST_RESET) == 0) {
_

Patches currently in -mm which might be from peerchen@gmail.com are

alsa-add-the-mcp79-support-to-hda_intel-driver.patch
ahci-enable-ghcae-bit-before-set-ghchr.patch
ahci-add-mcp79-support-to-ahci-driver.patch
