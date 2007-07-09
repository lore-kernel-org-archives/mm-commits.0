From: akpm@linux-foundation.org
Subject: - spi-master-driver-for-xilinx-virtex-fix-2.patch removed from -mm tree
Date: Mon, 09 Jul 2007 15:07:06 -0700
Message-ID: <200707092207.l69M76Cp015364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbXGIWHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akonovalov@ru.mvista.com, david-b@pacbell.net, galak@gate.crashing.org, yfrolov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     spi-master-driver-for-xilinx-virtex-fix 2
has been removed from the -mm tree.  Its filename was
     spi-master-driver-for-xilinx-virtex-fix-2.patch

This patch was dropped because it was folded into spi-master-driver-for-xilinx-virtex.patch

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
spi-master-driver-for-xilinx-virtex-fix-2.patch
