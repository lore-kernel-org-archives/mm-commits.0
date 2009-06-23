From: akpm@linux-foundation.org
Subject: + synclink_gt-fix-transmit-race-and-timeout.patch added to -mm tree
Date: Mon, 22 Jun 2009 23:19:54 -0700
Message-ID: <200906230619.n5N6Jsm5009789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758135AbZFWGUC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 02:20:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk


The patch titled
     synclink_gt: fix transmit race and timeout
has been added to the -mm tree.  Its filename is
     synclink_gt-fix-transmit-race-and-timeout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: synclink_gt: fix transmit race and timeout
From: Paul Fulghum <paulkf@microgate.com>

Fix race condition when adding transmit data to active DMA buffer ring
that can cause transmit stall.

Update transmit timeout when adding data to active DMA buffer ring.

Base transmit timeout on amount of buffered data instead of using fixed
value.

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
