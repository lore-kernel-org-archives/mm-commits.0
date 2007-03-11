From: akpm@linux-foundation.org
Subject: + mv643xx-clear-pending-interrupts-before-calling-request_irq.patch added to -mm tree
Date: Sun, 11 Mar 2007 02:00:47 -0800
Message-ID: <200703111000.l2BA0l23009356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42109 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXCKKEL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 06:04:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dale@farnsworth.org, pgiri@yahoo.com


The patch titled
     mv643xx: clear pending interrupts before calling request_irq
has been added to the -mm tree.  Its filename is
     mv643xx-clear-pending-interrupts-before-calling-request_irq.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mv643xx-clear-pending-interrupts-before-calling-request_irq.patch
mv643xx-ethernet-driver-irq-registration-fix.patch
