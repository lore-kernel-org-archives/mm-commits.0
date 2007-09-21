From: akpm@linux-foundation.org
Subject: + ahci-enable-ghcae-bit-before-set-ghchr.patch added to -mm tree
Date: Fri, 21 Sep 2007 03:29:46 -0700
Message-ID: <200709211029.l8LATk4m031014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbXIUK3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 06:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com


The patch titled
     ahci: enable GHC.AE bit before set GHC.HR
has been added to the -mm tree.  Its filename is
     ahci-enable-ghcae-bit-before-set-ghchr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ahci-enable-ghcae-bit-before-set-ghchr.patch
ahci-enable-ghcae-bit-before-set-ghchr-fix.patch
ahci-add-mcp79-support-to-ahci-driver.patch
