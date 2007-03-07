From: akpm@linux-foundation.org
Subject: - sdhci-handle-resumed-devices.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:56 -0800
Message-ID: <200703070421.l274Luuw018951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47095 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbXCGEWI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, drzeus@drzeus.cx, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     sdhci: handle resumed devices
has been removed from the -mm tree.  Its filename was
     sdhci-handle-resumed-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sdhci: handle resumed devices
From: Mark Lord <lkml@rtr.ca>

The interrupt is shared with another device, which resumes earlier than the
sdhci controller, and generates an interrupt.

The sdhci interrupt handler runs, sees 0xffffffff in its own device's
interrupt status, and tries to handle it..  The reason for the 0xffffffff
is that the device is still suspended, and *all* regs are reading back
0xffffffff.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/sdhci.c~sdhci-handle-resumed-devices drivers/mmc/sdhci.c
--- a/drivers/mmc/sdhci.c~sdhci-handle-resumed-devices
+++ a/drivers/mmc/sdhci.c
@@ -994,7 +994,7 @@ static irqreturn_t sdhci_irq(int irq, vo
 
 	intmask = readl(host->ioaddr + SDHCI_INT_STATUS);
 
-	if (!intmask) {
+	if (!intmask || intmask == 0xffffffff) {
 		result = IRQ_NONE;
 		goto out;
 	}
_

Patches currently in -mm which might be from lkml@rtr.ca are

origin.patch
