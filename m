From: akpm@linux-foundation.org
Subject: [merged] blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:06:42 -0700
Message-ID: <200904071906.n37J6g7l010951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760800AbZDGTKf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:10:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     Blackfin SPI Driver: add timeout while waiting for SPIF in dma irq handler
has been removed from the -mm tree.  Its filename was
     blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin SPI Driver: add timeout while waiting for SPIF in dma irq handler
From: Mike Frysinger <vapier.adi@gmail.com>

The "while" endless loop will cause the system hang if hardware error, so
we add timeout control to make the system alive.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~blackfin-spi-driver-add-timeout-while-waiting-for-spif-in-dma-irq-handler
+++ a/drivers/spi/spi_bfin5xx.c
@@ -557,6 +557,7 @@ static irqreturn_t dma_irq_handler(int i
 	struct driver_data *drv_data = dev_id;
 	struct chip_data *chip = drv_data->cur_chip;
 	struct spi_message *msg = drv_data->cur_msg;
+	unsigned long timeout;
 	unsigned short dmastat = get_dma_curr_irqstat(drv_data->dma_channel);
 	u16 spistat = read_STAT(drv_data);
 
@@ -582,8 +583,17 @@ static irqreturn_t dma_irq_handler(int i
 			cpu_relax();
 	}
 
+	dev_dbg(&drv_data->pdev->dev,
+		"in dma_irq_handler dmastat:0x%x spistat:0x%x\n",
+		dmastat, read_STAT(drv_data));
+
+	timeout = jiffies + HZ;
 	while (!(read_STAT(drv_data) & SPIF))
-		cpu_relax();
+		if (!time_before(jiffies, timeout)) {
+			dev_warn(&drv_data->pdev->dev, "timeout waiting for SPIF");
+			break;
+		} else
+			cpu_relax();
 
 	if ((dmastat & DMA_ERR) && (spistat & RBSY)) {
 		msg->state = ERROR_STATE;
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

