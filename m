From: akpm@linux-foundation.org
Subject: - spi-fix-error-paths-on-txx9spi_probe.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:18 -0800
Message-ID: <200711152109.lAFL9IV7015432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126AbXKOVRu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix error paths on txx9spi_probe
has been removed from the -mm tree.  Its filename was
     spi-fix-error-paths-on-txx9spi_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: fix error paths on txx9spi_probe
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Some error paths in txx9spi_probe wrongly return 0.  This patch fixes them by
using the devres interfaces.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_txx9.c |   40 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/spi/spi_txx9.c~spi-fix-error-paths-on-txx9spi_probe drivers/spi/spi_txx9.c
--- a/drivers/spi/spi_txx9.c~spi-fix-error-paths-on-txx9spi_probe
+++ a/drivers/spi/spi_txx9.c
@@ -24,6 +24,7 @@
 #include <linux/spi/spi.h>
 #include <linux/err.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 #include <asm/gpio.h>
 
 
@@ -74,7 +75,6 @@ struct txx9spi {
 	struct list_head queue;
 	wait_queue_head_t waitq;
 	void __iomem *membase;
-	int irq;
 	int baseclk;
 	struct clk *clk;
 	u32 max_speed_hz, min_speed_hz;
@@ -350,12 +350,12 @@ static int __init txx9spi_probe(struct p
 	struct resource *res;
 	int ret = -ENODEV;
 	u32 mcr;
+	int irq;
 
 	master = spi_alloc_master(&dev->dev, sizeof(*c));
 	if (!master)
 		return ret;
 	c = spi_master_get_devdata(master);
-	c->irq = -1;
 	platform_set_drvdata(dev, master);
 
 	INIT_WORK(&c->work, txx9spi_work);
@@ -381,32 +381,36 @@ static int __init txx9spi_probe(struct p
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
-		goto exit;
-	c->membase = ioremap(res->start, res->end - res->start + 1);
+		goto exit_busy;
+	if (!devm_request_mem_region(&dev->dev,
+				     res->start, res->end - res->start + 1,
+				     "spi_txx9"))
+		goto exit_busy;
+	c->membase = devm_ioremap(&dev->dev,
+				  res->start, res->end - res->start + 1);
 	if (!c->membase)
-		goto exit;
+		goto exit_busy;
 
 	/* enter config mode */
 	mcr = txx9spi_rd(c, TXx9_SPMCR);
 	mcr &= ~(TXx9_SPMCR_OPMODE | TXx9_SPMCR_SPSTP | TXx9_SPMCR_BCLR);
 	txx9spi_wr(c, mcr | TXx9_SPMCR_CONFIG | TXx9_SPMCR_BCLR, TXx9_SPMCR);
 
-	c->irq = platform_get_irq(dev, 0);
-	if (c->irq < 0)
-		goto exit;
-	ret = request_irq(c->irq, txx9spi_interrupt, 0, dev->name, c);
-	if (ret) {
-		c->irq = -1;
+	irq = platform_get_irq(dev, 0);
+	if (irq < 0)
+		goto exit_busy;
+	ret = devm_request_irq(&dev->dev, irq, txx9spi_interrupt, 0,
+			       "spi_txx9", c);
+	if (ret)
 		goto exit;
-	}
 
 	c->workqueue = create_singlethread_workqueue(master->dev.parent->bus_id);
 	if (!c->workqueue)
-		goto exit;
+		goto exit_busy;
 	c->last_chipselect = -1;
 
 	dev_info(&dev->dev, "at %#llx, irq %d, %dMHz\n",
-		 (unsigned long long)res->start, c->irq,
+		 (unsigned long long)res->start, irq,
 		 (c->baseclk + 500000) / 1000000);
 
 	master->bus_num = dev->id;
@@ -418,13 +422,11 @@ static int __init txx9spi_probe(struct p
 	if (ret)
 		goto exit;
 	return 0;
+exit_busy:
+	ret = -EBUSY;
 exit:
 	if (c->workqueue)
 		destroy_workqueue(c->workqueue);
-	if (c->irq >= 0)
-		free_irq(c->irq, c);
-	if (c->membase)
-		iounmap(c->membase);
 	if (c->clk) {
 		clk_disable(c->clk);
 		clk_put(c->clk);
@@ -442,8 +444,6 @@ static int __exit txx9spi_remove(struct 
 	spi_unregister_master(master);
 	platform_set_drvdata(dev, NULL);
 	destroy_workqueue(c->workqueue);
-	free_irq(c->irq, c);
-	iounmap(c->membase);
 	clk_disable(c->clk);
 	clk_put(c->clk);
 	spi_master_put(master);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
clocksource-make-clocksource_mask-bullet-proof.patch
git-mips.patch
