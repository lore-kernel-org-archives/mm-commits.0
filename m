From: akpm@linux-foundation.org
Subject: + sdhci-handle-resumed-devices.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:17:42 -0800
Message-ID: <200703060417.l264Hgnq011575@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbXCFERy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:17:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkml@rtr.ca, drzeus@drzeus.cx, mlord@pobox.com


The patch titled
     sdhci: handle resumed devices
has been added to the -mm tree.  Its filename is
     sdhci-handle-resumed-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-2621-rfcomm-lockups.patch
sdhci-handle-resumed-devices.patch
