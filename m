From: akpm@linux-foundation.org
Subject: + spi-master-driver-for-xilinx-virtex-fix-2.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:18:47 -0700
Message-ID: <200706282218.l5SMIl2m002773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758226AbXF1WS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:18:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akonovalov@ru.mvista.com, david-b@pacbell.net, galak@gate.crashing.org, yfrolov@ru.mvista.com


The patch titled
     spi-master-driver-for-xilinx-virtex-fix 2
has been added to the -mm tree.  Its filename is
     spi-master-driver-for-xilinx-virtex-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi-master-driver-for-xilinx-virtex-fix 2
From: Andrei Konovalov <akonovalov@ru.mvista.com>

The comment is misleading: some of the other status register bits could be
set.  Those bits are masked in the interrupt enable register, and don't
produce interrupts.  We just clear them at the same time TX_EMPTY bit is
cleared.

Signed-off-by: Andrei Konovalov <akonovalov@ru.mvista.com>
Cc: Andrei Konovalov <akonovalov@ru.mvista.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Yuri Frolov <yfrolov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/xilinx_spi.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/spi/xilinx_spi.c~spi-master-driver-for-xilinx-virtex-fix-2 drivers/spi/xilinx_spi.c
--- a/drivers/spi/xilinx_spi.c~spi-master-driver-for-xilinx-virtex-fix-2
+++ a/drivers/spi/xilinx_spi.c
@@ -299,8 +299,6 @@ static irqreturn_t xilinx_spi_irq(int ir
 			 */
 			complete(&xspi->done);
 		}
-	} else {
-		/* spurious interrupt */
 	}
 
 	return IRQ_HANDLED;
_

Patches currently in -mm which might be from akonovalov@ru.mvista.com are

spi-master-driver-for-xilinx-virtex.patch
spi-master-driver-for-xilinx-virtex-fix.patch
spi-master-driver-for-xilinx-virtex-fix-2.patch
