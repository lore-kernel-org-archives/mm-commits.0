From: akpm@linux-foundation.org
Subject: + synclink_gt-fix-transmit-dma-stall.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:25:40 -0700
Message-ID: <200707270525.l6R5PeXO007295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535AbXG0F0X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:26:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulkf@microgate.com


The patch titled
     synclink_gt: fix transmit DMA stall
has been added to the -mm tree.  Its filename is
     synclink_gt-fix-transmit-dma-stall.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synclink_gt: fix transmit DMA stall
From: Paul Fulghum <paulkf@microgate.com>

Fix transmit DMA stall when write() called in window after previous
transmit DMA completes but before previous serial transmission completes.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink_gt.c |   75 +++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff -puN drivers/char/synclink_gt.c~synclink_gt-fix-transmit-dma-stall drivers/char/synclink_gt.c
--- a/drivers/char/synclink_gt.c~synclink_gt-fix-transmit-dma-stall
+++ a/drivers/char/synclink_gt.c
@@ -1,5 +1,5 @@
 /*
- * $Id: synclink_gt.c,v 4.36 2006/08/28 20:47:14 paulkf Exp $
+ * $Id: synclink_gt.c,v 4.50 2007/07/25 19:29:25 paulkf Exp $
  *
  * Device driver for Microgate SyncLink GT serial adapters.
  *
@@ -93,7 +93,7 @@
  * module identification
  */
 static char *driver_name     = "SyncLink GT";
-static char *driver_version  = "$Revision: 4.36 $";
+static char *driver_version  = "$Revision: 4.50 $";
 static char *tty_driver_name = "synclink_gt";
 static char *tty_dev_prefix  = "ttySLG";
 MODULE_LICENSE("GPL");
@@ -477,6 +477,7 @@ static void tx_set_idle(struct slgt_info
 static unsigned int free_tbuf_count(struct slgt_info *info);
 static void reset_tbufs(struct slgt_info *info);
 static void tdma_reset(struct slgt_info *info);
+static void tdma_start(struct slgt_info *info);
 static void tx_load(struct slgt_info *info, const char *buf, unsigned int count);
 
 static void get_signals(struct slgt_info *info);
@@ -904,6 +905,8 @@ start:
 		spin_lock_irqsave(&info->lock,flags);
 		if (!info->tx_active)
 		 	tx_start(info);
+		else
+			tdma_start(info);
 		spin_unlock_irqrestore(&info->lock,flags);
  	}
 
@@ -3871,44 +3874,58 @@ static void tx_start(struct slgt_info *i
 			slgt_irq_on(info, IRQ_TXUNDER + IRQ_TXIDLE);
 			/* clear tx idle and underrun status bits */
 			wr_reg16(info, SSR, (unsigned short)(IRQ_TXIDLE + IRQ_TXUNDER));
-
-			if (!(rd_reg32(info, TDCSR) & BIT0)) {
-				/* tx DMA stopped, restart tx DMA */
-				tdma_reset(info);
-				/* set 1st descriptor address */
-				wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-				switch(info->params.mode) {
-				case MGSL_MODE_RAW:
-				case MGSL_MODE_MONOSYNC:
-				case MGSL_MODE_BISYNC:
-					wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
-					break;
-				default:
-					wr_reg32(info, TDCSR, BIT0); /* DMA enable */
-				}
-			}
-
 			if (info->params.mode == MGSL_MODE_HDLC)
 				mod_timer(&info->tx_timer, jiffies +
 						msecs_to_jiffies(5000));
 		} else {
-			tdma_reset(info);
-			/* set 1st descriptor address */
-			wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
-
 			slgt_irq_off(info, IRQ_TXDATA);
 			slgt_irq_on(info, IRQ_TXIDLE);
 			/* clear tx idle status bit */
 			wr_reg16(info, SSR, IRQ_TXIDLE);
-
-			/* enable tx DMA */
-			wr_reg32(info, TDCSR, BIT0);
 		}
-
+		tdma_start(info);
 		info->tx_active = 1;
 	}
 }
 
+/*
+ * start transmit DMA if inactive and there are unsent buffers
+ */
+static void tdma_start(struct slgt_info *info)
+{
+	unsigned int i;
+
+	if (rd_reg32(info, TDCSR) & BIT0)
+		return;
+
+	/* transmit DMA inactive, check for unsent buffers */
+	i = info->tbuf_start;
+	while (!desc_count(info->tbufs[i])) {
+		if (++i == info->tbuf_count)
+			i = 0;
+		if (i == info->tbuf_current)
+			return;
+	}
+	info->tbuf_start = i;
+
+	/* there are unsent buffers, start transmit DMA */
+
+	/* reset needed if previous error condition */
+	tdma_reset(info);
+
+	/* set 1st descriptor address */
+	wr_reg32(info, TDDAR, info->tbufs[info->tbuf_start].pdesc);
+	switch(info->params.mode) {
+	case MGSL_MODE_RAW:
+	case MGSL_MODE_MONOSYNC:
+	case MGSL_MODE_BISYNC:
+		wr_reg32(info, TDCSR, BIT2 + BIT0); /* IRQ + DMA enable */
+		break;
+	default:
+		wr_reg32(info, TDCSR, BIT0); /* DMA enable */
+	}
+}
+
 static void tx_stop(struct slgt_info *info)
 {
 	unsigned short val;
@@ -4642,8 +4659,8 @@ static unsigned int free_tbuf_count(stru
 			i=0;
 	} while (i != info->tbuf_current);
 
-	/* last buffer with zero count may be in use, assume it is */
-	if (count)
+	/* if tx DMA active, last zero count buffer is in use */
+	if (count && (rd_reg32(info, TDCSR) & BIT0))
 		--count;
 
 	return count;
_

Patches currently in -mm which might be from paulkf@microgate.com are

synclink_gt-fix-transmit-dma-stall.patch
