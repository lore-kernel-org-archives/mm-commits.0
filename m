From: akpm@linux-foundation.org
Subject: [merged] obsolete-config-in-kernel-source-use_internal_timer.patch removed from -mm tree
Date: Thu, 18 Mar 2010 11:08:58 -0400
Message-ID: <201003181809.o2II9dU4007584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab0CRSRf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siccegge@stud.informatik.uni-erlangen.de, davem@davemloft.net, roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     obsolete config in kernel source: USE_INTERNAL_TIMER
has been removed from the -mm tree.  Its filename was
     obsolete-config-in-kernel-source-use_internal_timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: obsolete config in kernel source: USE_INTERNAL_TIMER
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

CONFIG_USE_INTERNAL_TIMER seems to be the remainings of some experiment. 
It is explicitely #undef-ed as not working, only referenced from one
source file and rather aged.

Hereby cleaning it from the kernel tree.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Acked-by: Roel Kluin <roel.kluin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/w83977af_ir.c |   36 -------------------------------
 1 file changed, 36 deletions(-)

diff -puN drivers/net/irda/w83977af_ir.c~obsolete-config-in-kernel-source-use_internal_timer drivers/net/irda/w83977af_ir.c
--- a/drivers/net/irda/w83977af_ir.c~obsolete-config-in-kernel-source-use_internal_timer
+++ a/drivers/net/irda/w83977af_ir.c
@@ -65,7 +65,6 @@
 #undef  CONFIG_NETWINDER_TX_DMA_PROBLEMS /* Not needed */
 #define CONFIG_NETWINDER_RX_DMA_PROBLEMS /* Must have this one! */
 #endif
-#undef  CONFIG_USE_INTERNAL_TIMER  /* Just cannot make that timer work */
 #define CONFIG_USE_W977_PNP        /* Currently needed */
 #define PIO_MAX_SPEED       115200 
 
@@ -533,25 +532,6 @@ static netdev_tx_t w83977af_hard_xmit(st
 		self->tx_buff.len = skb->len;
 		
 		mtt = irda_get_mtt(skb);
-#ifdef CONFIG_USE_INTERNAL_TIMER
-	        if (mtt > 50) {
-			/* Adjust for timer resolution */
-			mtt /= 1000+1;
-
-			/* Setup timer */
-			switch_bank(iobase, SET4);
-			outb(mtt & 0xff, iobase+TMRL);
-			outb((mtt >> 8) & 0x0f, iobase+TMRH);
-			
-			/* Start timer */
-			outb(IR_MSL_EN_TMR, iobase+IR_MSL);
-			self->io.direction = IO_XMIT;
-			
-			/* Enable timer interrupt */
-			switch_bank(iobase, SET0);
-			outb(ICR_ETMRI, iobase+ICR);
-		} else {
-#endif
 			IRDA_DEBUG(4, "%s(%ld), mtt=%d\n", __func__ , jiffies, mtt);
 			if (mtt)
 				udelay(mtt);
@@ -560,9 +540,6 @@ static netdev_tx_t w83977af_hard_xmit(st
 			switch_bank(iobase, SET0);
 	 		outb(ICR_EDMAI, iobase+ICR);
 	     		w83977af_dma_write(self, iobase);
-#ifdef CONFIG_USE_INTERNAL_TIMER
-		}
-#endif
 	} else {
 		self->tx_buff.data = self->tx_buff.head;
 		self->tx_buff.len = async_wrap_skb(skb, self->tx_buff.data, 
@@ -876,20 +853,7 @@ static int w83977af_dma_receive_complete
 			/* Check if we have transferred all data to memory */
 			switch_bank(iobase, SET0);
 			if (inb(iobase+USR) & USR_RDR) {
-#ifdef CONFIG_USE_INTERNAL_TIMER
-				/* Put this entry back in fifo */
-				st_fifo->head--;
-				st_fifo->len++;
-				st_fifo->entries[st_fifo->head].status = status;
-				st_fifo->entries[st_fifo->head].len = len;
-				
-				/* Restore set register */
-				outb(set, iobase+SSR);
-			
-				return FALSE; 	/* I'll be back! */
-#else
 				udelay(80); /* Should be enough!? */
-#endif
 			}
 						
 			skb = dev_alloc_skb(len+1);
_

Patches currently in -mm which might be from siccegge@stud.informatik.uni-erlangen.de are

origin.patch
linux-next.patch

