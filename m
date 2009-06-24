From: akpm@linux-foundation.org
Subject: [merged] synclink_gt-fix-transmit-race-and-timeout.patch removed from -mm tree
Date: Wed, 24 Jun 2009 12:11:14 -0700
Message-ID: <200906241911.n5OJBEAE011512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35610 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758782AbZFXTLX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 15:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     synclink_gt: fix transmit race and timeout
has been removed from the -mm tree.  Its filename was
     synclink_gt-fix-transmit-race-and-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: fix transmit race and timeout
From: Paul Fulghum <paulkf@microgate.com>

If after adding transmit data to the transmit DMA ring the transmit DMA
controller has become inactive before reading the new data and the serial
transmitter is still active sending data already in the transmit FIFO
and/or shift register, then wait for the serial transmitter to become idle
before reactivating the transmit DMA controller.

Otherwise the transmit DMA controller may present the new data to the
serial transmitter in a small timing window just as the serial transmitter
transitions to the idle state.  Hitting this window results in the serial
transmitter entering an inconsistent state where it does not process the
new data and does not signal the transition to the idle state.

From the driver perspective, this condition appears as an active transmit
DMA controller (correct) with unsent DMA buffers (correct) and an active
serial transmitter (wrong), even though no data is actually being sent. 
When all the DMA buffers are full, no further data is accepted from a user
application calling write() until a timeout occurs and the transmitter and
DMA controller are reset.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   72 ++++++++++++++---------------------
 1 file changed, 30 insertions(+), 42 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-fix-transmit-race-and-timeout drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-fix-transmit-race-and-timeout
+++ a/drivers/char/synclink_gt.c
@@ -467,7 +467,6 @@ static unsigned int free_tbuf_count(stru
 static unsigned int tbuf_bytes(struct slgt_info *info);
 static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
-static void tdma_start(struct slgt_info *info);
 static void tx_load(struct slgt_info *info, const char *buf, unsigned int count);
 
 static void get_signals(struct slgt_info *info);
@@ -795,6 +794,18 @@ static void set_termios(struct tty_struc
 	}
 }
 
+static void update_tx_timer(struct slgt_info *info)
+{
+	/*
+	 * use worst case speed of 1200bps to calculate transmit timeout
+	 * based on data in buffers (tbuf_bytes) and FIFO (128 bytes)
+	 */
+	if (info->params.mode == MGSL_MODE_HDLC) {
+		int timeout  = (tbuf_bytes(info) * 7) + 1000;
+		mod_timer(&info->tx_timer, jiffies + msecs_to_jiffies(timeout));
+	}
+}
+
 static int write(struct tty_struct *tty,
 		 const unsigned char *buf, int count)
 {
@@ -838,8 +849,18 @@ start:
 		spin_lock_irqsave(&info->lock,flags);
 		if (!info->tx_active)
 		 	tx_start(info);
-		else
-			tdma_start(info);
+		else if (!(rd_reg32(info, TDCSR) & BIT0)) {
+			/* transmit still active but transmit DMA stopped */
+			unsigned int i = info->tbuf_current;
+			if (!i)
+				i = info->tbuf_count;
+			i--;
+			/* if DMA buf unsent must try later after tx idle */
+			if (desc_count(info->tbufs[i]))
+				ret = 0;
+		}
+		if (ret > 0)
+			update_tx_timer(info);
 		spin_unlock_irqrestore(&info->lock,flags);
  	}
 
@@ -1502,10 +1523,9 @@ static int hdlcdev_xmit(struct sk_buff *
 	/* save start time for transmit timeout detection */
 	dev->trans_start = jiffies;
 
-	/* start hardware transmitter if necessary */
 	spin_lock_irqsave(&info->lock,flags);
-	if (!info->tx_active)
-	 	tx_start(info);
+	tx_start(info);
+	update_tx_timer(info);
 	spin_unlock_irqrestore(&info->lock,flags);
 
 	return 0;
@@ -3946,50 +3966,19 @@ static void tx_start(struct slgt_info *i
 			slgt_irq_on(info, IRQ_TXUNDER + IRQ_TXIDLE);
 			/* clear tx idle and underrun status bits */
 			wr_reg16(info, SSR, (unsigned short)(IRQ_TXIDLE + IRQ_TXUNDER));
-			if (info->params.mode == MGSL_MODE_HDLC)
-				mod_timer(&info->tx_timer, jiffies +
-						msecs_to_jiffies(5000));
 		} else {
 			slgt_irq_off(info, IRQ_TXDATA);
 			slgt_irq_on(info, IRQ_TXIDLE);
 			/* clear tx idle status bit */
 			wr_reg16(info, SSR, IRQ_TXIDLE);
 		}
-		tdma_start(info);
+		/* set 1st descriptor address and start DMA */
+		wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
+		wr_reg32(info, TDCSR, BIT2 + BIT0);
 		info->tx_active = true;
 	}
 }
 
-/*
- * start transmit DMA if inactive and there are unsent buffers
- */
-static void tdma_start(struct slgt_info *info)
-{
-	unsigned int i;
-
-	if (rd_reg32(info, TDCSR) & BIT0)
-		return;
-
-	/* transmit DMA inactive, check for unsent buffers */
-	i = info->tbuf_start;
-	while (!desc_count(info->tbufs[i])) {
-		if (++i == info->tbuf_count)
-			i = 0;
-		if (i == info->tbuf_current)
-			return;
-	}
-	info->tbuf_start = i;
-
-	/* there are unsent buffers, start transmit DMA */
-
-	/* reset needed if previous error condition */
-	tdma_reset(info);
-
-	/* set 1st descriptor address */
-	wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-	wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
-}
