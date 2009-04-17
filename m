From: akpm@linux-foundation.org
Subject: + synclink_gt-add-receive-pio-mode.patch added to -mm tree
Date: Fri, 17 Apr 2009 13:49:26 -0700
Message-ID: <200904172049.n3HKnQ7d030396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662AbZDQUwF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 16:52:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk


The patch titled
     synclink_gt: add receive pio mode
has been added to the -mm tree.  Its filename is
     synclink_gt-add-receive-pio-mode.patch

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
Subject: synclink_gt: add receive pio mode
From: Paul Fulghum <paulkf@microgate.com>

Add receive programmed IO mode to reduce receive latency when using low
data rates.  The receive FIFO trigger level of 128 bytes used in DMA mode
creates excessive latency when operating at low data rates.  PIO mode is
selected when user application requests data in blocks of less than 128
bytes.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   77 ++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 9 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-add-receive-pio-mode drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-add-receive-pio-mode
+++ a/drivers/char/synclink_gt.c
@@ -214,6 +214,7 @@ struct slgt_desc
 #define set_desc_next(a,b) (a).next   = cpu_to_le32((unsigned int)(b))
 #define set_desc_count(a,b)(a).count  = cpu_to_le16((unsigned short)(b))
 #define set_desc_eof(a,b)  (a).status = cpu_to_le16((b) ? (le16_to_cpu((a).status) | BIT0) : (le16_to_cpu((a).status) & ~BIT0))
+#define set_desc_status(a, b) (a).status = cpu_to_le16((unsigned short)(b))
 #define desc_count(a)      (le16_to_cpu((a).count))
 #define desc_status(a)     (le16_to_cpu((a).status))
 #define desc_complete(a)   (le16_to_cpu((a).status) & BIT15)
@@ -297,6 +298,7 @@ struct slgt_info {
 	u32 max_frame_size;       /* as set by device config */
 
 	unsigned int rbuf_fill_level;
+	unsigned int rx_pio;
 	unsigned int if_mode;
 	unsigned int base_clock;
 
@@ -331,6 +333,8 @@ struct slgt_info {
 	struct slgt_desc *rbufs;
 	unsigned int rbuf_current;
 	unsigned int rbuf_index;
+	unsigned int rbuf_fill_index;
+	unsigned short rbuf_fill_count;
 
 	unsigned int tbuf_count;
 	struct slgt_desc *tbufs;
@@ -2110,6 +2114,40 @@ static void ri_change(struct slgt_info *
 	info->pending_bh |= BH_STATUS;
 }
 
+static void isr_rxdata(struct slgt_info *info)
+{
+	unsigned int count = info->rbuf_fill_count;
+	unsigned int i = info->rbuf_fill_index;
+	unsigned short reg;
+
+	while (rd_reg16(info, SSR) & IRQ_RXDATA) {
+		reg = rd_reg16(info, RDR);
+		DBGISR(("isr_rxdata %s RDR=%04X\n", info->device_name, reg));
+		if (desc_complete(info->rbufs[i])) {
+			/* all buffers full */
+			rx_stop(info);
+			info->rx_restart = 1;
+			continue;
+		}
+		info->rbufs[i].buf[count++] = (unsigned char)reg;
+		/* async mode saves status byte to buffer for each data byte */
+		if (info->params.mode == MGSL_MODE_ASYNC)
+			info->rbufs[i].buf[count++] = (unsigned char)(reg >> 8);
+		if (count == info->rbuf_fill_level || (reg & BIT10)) {
+			/* buffer full or end of frame */
+			set_desc_count(info->rbufs[i], count);
+			set_desc_status(info->rbufs[i], BIT15 | (reg >> 8));
+			info->rbuf_fill_count = count = 0;
+			if (++i == info->rbuf_count)
+				i = 0;
+			info->pending_bh |= BH_RECEIVE;
+		}
+	}
+
+	info->rbuf_fill_index = i;
+	info->rbuf_fill_count = count;
+}
+
 static void isr_serial(struct slgt_info *info)
 {
 	unsigned short status = rd_reg16(info, SSR);
@@ -2125,6 +2163,8 @@ static void isr_serial(struct slgt_info 
 			if (info->tx_count)
 				isr_txeom(info, status);
 		}
+		if (info->rx_pio && (status & IRQ_RXDATA))
+			isr_rxdata(info);
 		if ((status & IRQ_RXBREAK) && (status & RXBREAK)) {
 			info->icount.brk++;
 			/* process break detection if tty control allows */
@@ -2141,7 +2181,8 @@ static void isr_serial(struct slgt_info 
 	} else {
 		if (status & (IRQ_TXIDLE + IRQ_TXUNDER))
 			isr_txeom(info, status);
-
+		if (info->rx_pio && (status & IRQ_RXDATA))
+			isr_rxdata(info);
 		if (status & IRQ_RXIDLE) {
 			if (status & RXIDLE)
 				info->icount.rxidle++;
@@ -2642,6 +2683,10 @@ static int rx_enable(struct slgt_info *i
 			return -EINVAL;
 		}
 		info->rbuf_fill_level = rbuf_fill_level;
+		if (rbuf_fill_level < 128)
+			info->rx_pio = 1; /* PIO mode */
+		else
+			info->rx_pio = 0; /* DMA mode */
 		rx_stop(info); /* restart receiver to use new fill level */
 	}
 
@@ -3841,15 +3886,27 @@ static void rx_start(struct slgt_info *i
 	rdma_reset(info);
 	reset_rbufs(info);
 
-	/* set 1st descriptor address */
-	wr_reg32(info, RDDAR, info->rbufs[0].pdesc);
-
-	if (info->params.mode != MGSL_MODE_ASYNC) {
-		/* enable rx DMA and DMA interrupt */
-		wr_reg32(info, RDCSR, (BIT2 + BIT0));
+	if (info->rx_pio) {
+		/* rx request when rx FIFO not empty */
+		wr_reg16(info, SCR, (unsigned short)(rd_reg16(info, SCR) & ~BIT14));
+		slgt_irq_on(info, IRQ_RXDATA);
+		if (info->params.mode == MGSL_MODE_ASYNC) {
+			/* enable saving of rx status */
+			wr_reg32(info, RDCSR, BIT6);
+		}
 	} else {
-		/* enable saving of rx status, rx DMA and DMA interrupt */
-		wr_reg32(info, RDCSR, (BIT6 + BIT2 + BIT0));
+		/* rx request when rx FIFO half full */
+		wr_reg16(info, SCR, (unsigned short)(rd_reg16(info, SCR) | BIT14));
+		/* set 1st descriptor address */
+		wr_reg32(info, RDDAR, info->rbufs[0].pdesc);
+
+		if (info->params.mode != MGSL_MODE_ASYNC) {
+			/* enable rx DMA and DMA interrupt */
+			wr_reg32(info, RDCSR, (BIT2 + BIT0));
+		} else {
+			/* enable saving of rx status, rx DMA and DMA interrupt */
+			wr_reg32(info, RDCSR, (BIT6 + BIT2 + BIT0));
+		}
 	}
 
 	slgt_irq_on(info, IRQ_RXOVER);
@@ -4467,6 +4524,8 @@ static void free_rbufs(struct slgt_info 
 static void reset_rbufs(struct slgt_info *info)
 {
 	free_rbufs(info, 0, info->rbuf_count - 1);
+	info->rbuf_fill_index = 0;
+	info->rbuf_fill_count = 0;
 }
 
 /*
_

Patches currently in -mm which might be from paulkf@microgate.com are

synclink_gt-add-receive-pio-mode.patch

