From: akpm@linux-foundation.org
Subject: + mpsc-serial-driver-tx-locking.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:50:44 -0800
Message-ID: <200703070150.l271oiO3016172@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42710 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161204AbXCGBuy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:50:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djiang@mvista.com, mgreer@mvista.com


The patch titled
     MPSC serial driver tx locking
has been added to the -mm tree.  Its filename is
     mpsc-serial-driver-tx-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MPSC serial driver tx locking
From: Dave Jiang <djiang@mvista.com>

The MPSC serial driver assumes that interrupt is always on to pick up the
DMA transmit ops that aren't submitted while the DMA engine is active. 
However when irqs are off for a period of time such as operations under
kernel crash dump console messages do not show up due to additional DMA ops
are being dropped.  This makes console writes to process through all the tx
DMAs queued up before submitting a new request.

Also, the current locking mechanism does not protect the hardware registers
and ring buffer when a printk is done during the serial write operations. 
The additional per port transmit lock provides a finer granular locking and
protects registers being clobbered while printks are nested within UART
writes.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/mpsc.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/serial/mpsc.c~mpsc-serial-driver-tx-locking drivers/serial/mpsc.c
--- a/drivers/serial/mpsc.c~mpsc-serial-driver-tx-locking
+++ a/drivers/serial/mpsc.c
@@ -183,6 +183,7 @@ struct mpsc_port_info {
 	u8 *txb_p;		/* Phys addr of txb */
 	int txr_head;		/* Where new data goes */
 	int txr_tail;		/* Where sent data comes off */
+	spinlock_t tx_lock;	/* transmit lock */
 
 	/* Mirrored values of regs we can't read (if 'mirror_regs' set) */
 	u32 MPSC_MPCR_m;
@@ -1212,6 +1213,9 @@ mpsc_tx_intr(struct mpsc_port_info *pi)
 {
 	struct mpsc_tx_desc *txre;
 	int rc = 0;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&pi->tx_lock, iflags);
 
 	if (!mpsc_sdma_tx_active(pi)) {
 		txre = (struct mpsc_tx_desc *)(pi->txr +
@@ -1248,6 +1252,7 @@ mpsc_tx_intr(struct mpsc_port_info *pi)
 		mpsc_sdma_start_tx(pi);	/* start next desc if ready */
 	}
 
+	spin_unlock_irqrestore(&pi->tx_lock, iflags);
 	return rc;
 }
 
@@ -1338,11 +1343,16 @@ static void
 mpsc_start_tx(struct uart_port *port)
 {
 	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&pi->tx_lock, iflags);
 
 	mpsc_unfreeze(pi);
 	mpsc_copy_tx_data(pi);
 	mpsc_sdma_start_tx(pi);
 
+	spin_unlock_irqrestore(&pi->tx_lock, iflags);
+
 	pr_debug("mpsc_start_tx[%d]\n", port->line);
 	return;
 }
@@ -1625,6 +1635,16 @@ mpsc_console_write(struct console *co, c
 	struct mpsc_port_info *pi = &mpsc_ports[co->index];
 	u8 *bp, *dp, add_cr = 0;
 	int i;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&pi->tx_lock, iflags);
+
+	while (pi->txr_head != pi->txr_tail) {
+		while (mpsc_sdma_tx_active(pi))
+			udelay(100);
+		mpsc_sdma_intr_ack(pi);
+		mpsc_tx_intr(pi);
+	}
 
 	while (mpsc_sdma_tx_active(pi))
 		udelay(100);
@@ -1668,6 +1688,7 @@ mpsc_console_write(struct console *co, c
 		pi->txr_tail = (pi->txr_tail + 1) & (MPSC_TXR_ENTRIES - 1);
 	}
 
+	spin_unlock_irqrestore(&pi->tx_lock, iflags);
 	return;
 }
 
@@ -2005,7 +2026,8 @@ mpsc_drv_probe(struct platform_device *d
 		if (!(rc = mpsc_drv_map_regs(pi, dev))) {
 			mpsc_drv_get_platform_data(pi, dev, dev->id);
 
-			if (!(rc = mpsc_make_ready(pi)))
+			if (!(rc = mpsc_make_ready(pi))) {
+				spin_lock_init(&pi->tx_lock);
 				if (!(rc = uart_add_one_port(&mpsc_reg,
 					&pi->port)))
 					rc = 0;
@@ -2014,6 +2036,7 @@ mpsc_drv_probe(struct platform_device *d
 						(struct uart_port *)pi);
 					mpsc_drv_unmap_regs(pi);
 				}
+			}
 			else
 				mpsc_drv_unmap_regs(pi);
 		}
_

Patches currently in -mm which might be from djiang@mvista.com are

mpsc-serial-driver-tx-locking.patch
