From: akpm@linux-foundation.org
Subject: - xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:26 -0700
Message-ID: <200807242328.m6ONSQMw011262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031AbYGXXeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:34:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, akonovalov@ru.mvista.com, dbrownell@users.sourceforge.net, yfrolov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     xilinx_spi: test below 0 on unsigned irq in xilinx_spi_probe()
has been removed from the -mm tree.  Its filename was
     xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xilinx_spi: test below 0 on unsigned irq in xilinx_spi_probe()
From: Roel Kluin <12o3l@tiscali.nl>

xilinx_spi->irq is unsigned, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrei Konovalov <akonovalov@ru.mvista.com>
Cc: Yuri Frolov <yfrolov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/xilinx_spi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/spi/xilinx_spi.c~xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe drivers/spi/xilinx_spi.c
--- a/drivers/spi/xilinx_spi.c~xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe
+++ a/drivers/spi/xilinx_spi.c
@@ -353,11 +353,12 @@ static int __init xilinx_spi_probe(struc
 		goto put_master;
 	}
 
-	xspi->irq = platform_get_irq(dev, 0);
-	if (xspi->irq < 0) {
+	ret = platform_get_irq(dev, 0);
+	if (ret < 0) {
 		ret = -ENXIO;
 		goto unmap_io;
 	}
+	xspi->irq = ret;
 
 	master->bus_num = pdata->bus_num;
 	master->num_chipselect = pdata->num_chipselect;
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

