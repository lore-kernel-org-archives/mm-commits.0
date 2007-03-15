From: akpm@linux-foundation.org
Subject: - mv643xx-clear-pending-interrupts-before-calling-request_irq.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:58:41 -0800
Message-ID: <200703152158.l2FLwfd1027750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbXCOWBx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dale@farnsworth.org, pgiri@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     mv643xx: clear pending interrupts before calling request_irq
has been removed from the -mm tree.  Its filename was
     mv643xx-clear-pending-interrupts-before-calling-request_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mv643xx: clear pending interrupts before calling request_irq
From: Dale Farnsworth <dale@farnsworth.org>

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
Acked-by: Giridhar Pemmasani <pgiri@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mv643xx_eth.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/net/mv643xx_eth.c~mv643xx-clear-pending-interrupts-before-calling-request_irq drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c~mv643xx-clear-pending-interrupts-before-calling-request_irq
+++ a/drivers/net/mv643xx_eth.c
@@ -787,6 +787,12 @@ static int mv643xx_eth_open(struct net_d
 	unsigned int size;
 	int err;
 
+	/* Clear any pending ethernet port interrupts */
+	mv_write(MV643XX_ETH_INTERRUPT_CAUSE_REG(port_num), 0);
+	mv_write(MV643XX_ETH_INTERRUPT_CAUSE_EXTEND_REG(port_num), 0);
+	/* wait for previous write to complete */
+	mv_read (MV643XX_ETH_INTERRUPT_CAUSE_EXTEND_REG(port_num));
+
 	err = request_irq(dev->irq, mv643xx_eth_int_handler,
 			IRQF_SHARED | IRQF_SAMPLE_RANDOM, dev->name, dev);
 	if (err) {
@@ -875,10 +881,6 @@ static int mv643xx_eth_open(struct net_d
 
 	mv643xx_eth_rx_refill_descs(dev);	/* Fill RX ring with skb's */
 
-	/* Clear any pending ethernet port interrupts */
-	mv_write(MV643XX_ETH_INTERRUPT_CAUSE_REG(port_num), 0);
-	mv_write(MV643XX_ETH_INTERRUPT_CAUSE_EXTEND_REG(port_num), 0);
-
 	eth_port_start(dev);
 
 	/* Interrupt Coalescing */
_

Patches currently in -mm which might be from dale@farnsworth.org are

origin.patch
