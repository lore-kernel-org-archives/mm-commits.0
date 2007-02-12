From: akpm@linux-foundation.org
Subject: - isdn-rename-some-debugging-macros-to-not-resemble-config.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:46:13 -0800
Message-ID: <200702122246.l1CMkDes013785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45212 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030327AbXBLWqS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:46:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     ISDN: Rename some debugging macros to not resemble CONFIG options
has been removed from the -mm tree.  Its filename was
     isdn-rename-some-debugging-macros-to-not-resemble-config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ISDN: Rename some debugging macros to not resemble CONFIG options
From: "Robert P. J. Day" <rpjday@mindspring.com>

Rename some of the debugging macros for ISDN AVM so that they don't resemble
kernel config settings, as they're primarily for author debugging instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/avm/b1dma.c |   14 +++++++-------
 drivers/isdn/hardware/avm/c4.c    |   16 ++++++++--------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/isdn/hardware/avm/b1dma.c~isdn-rename-some-debugging-macros-to-not-resemble-config drivers/isdn/hardware/avm/b1dma.c
--- a/drivers/isdn/hardware/avm/b1dma.c~isdn-rename-some-debugging-macros-to-not-resemble-config
+++ a/drivers/isdn/hardware/avm/b1dma.c
@@ -29,7 +29,7 @@
 
 static char *revision = "$Revision: 1.1.2.3 $";
 
-#undef CONFIG_B1DMA_DEBUG
+#undef AVM_B1DMA_DEBUG
 
 /* ------------------------------------------------------------- */
 
@@ -391,16 +391,16 @@ static void b1dma_dispatch_tx(avmcard *c
 			_put_slice(&p, skb->data, len);
 		}
 		txlen = (u8 *)p - (u8 *)dma->sendbuf.dmabuf;
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 		printk(KERN_DEBUG "tx: put msg len=%d\n", txlen);
 #endif
 	} else {
 		txlen = skb->len-2;
-#ifdef CONFIG_B1DMA_POLLDEBUG
+#ifdef AVM_B1DMA_POLLDEBUG
 		if (skb->data[2] == SEND_POLLACK)
 			printk(KERN_INFO "%s: send ack\n", card->name);
 #endif
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 		printk(KERN_DEBUG "tx: put 0x%x len=%d\n", 
 		       skb->data[2], txlen);
 #endif
@@ -450,7 +450,7 @@ static void b1dma_handle_rx(avmcard *car
 	u32 ApplId, MsgLen, DataB3Len, NCCI, WindowSize;
 	u8 b1cmd =  _get_byte(&p);
 
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 	printk(KERN_DEBUG "rx: 0x%x %lu\n", b1cmd, (unsigned long)dma->recvlen);
 #endif
 	
@@ -515,7 +515,7 @@ static void b1dma_handle_rx(avmcard *car
 		break;
 
 	case RECEIVE_START:
-#ifdef CONFIG_B1DMA_POLLDEBUG
+#ifdef AVM_B1DMA_POLLDEBUG
 		printk(KERN_INFO "%s: receive poll\n", card->name);
 #endif
 		if (!suppress_pollack)
@@ -601,7 +601,7 @@ static void b1dma_handle_interrupt(avmca
 				rxlen = (dma->recvlen + 3) & ~3;
 				b1dma_writel(card, dma->recvbuf.dmaaddr+4, AMCC_RXPTR);
 				b1dma_writel(card, rxlen, AMCC_RXLEN);
-#ifdef CONFIG_B1DMA_DEBUG
+#ifdef AVM_B1DMA_DEBUG
 			} else {
 				printk(KERN_ERR "%s: rx not complete (%d).\n",
 					card->name, rxlen);
diff -puN drivers/isdn/hardware/avm/c4.c~isdn-rename-some-debugging-macros-to-not-resemble-config drivers/isdn/hardware/avm/c4.c
--- a/drivers/isdn/hardware/avm/c4.c~isdn-rename-some-debugging-macros-to-not-resemble-config
+++ a/drivers/isdn/hardware/avm/c4.c
@@ -28,8 +28,8 @@
 #include <linux/isdn/capilli.h>
 #include "avmcard.h"
 
-#undef CONFIG_C4_DEBUG
-#undef CONFIG_C4_POLLDEBUG
+#undef AVM_C4_DEBUG
+#undef AVM_C4_POLLDEBUG
 
 /* ------------------------------------------------------------- */
 
@@ -420,7 +420,7 @@ static void c4_dispatch_tx(avmcard *card
 
 	skb = skb_dequeue(&dma->send_queue);
 	if (!skb) {
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx underrun\n", card->name);
 #endif
 		return;
@@ -444,16 +444,16 @@ static void c4_dispatch_tx(avmcard *card
 			_put_slice(&p, skb->data, len);
 		}
 		txlen = (u8 *)p - (u8 *)dma->sendbuf.dmabuf;
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx put msg len=%d\n", card->name, txlen);
 #endif
 	} else {
 		txlen = skb->len-2;
-#ifdef CONFIG_C4_POLLDEBUG
+#ifdef AVM_C4_POLLDEBUG
 		if (skb->data[2] == SEND_POLLACK)
 			printk(KERN_INFO "%s: ack to c4\n", card->name);
 #endif
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 		printk(KERN_DEBUG "%s: tx put 0x%x len=%d\n",
 				card->name, skb->data[2], txlen);
 #endif
@@ -508,7 +508,7 @@ static void c4_handle_rx(avmcard *card)
 	u32 cidx;
 
 
-#ifdef CONFIG_C4_DEBUG
+#ifdef AVM_C4_DEBUG
 	printk(KERN_DEBUG "%s: rx 0x%x len=%lu\n", card->name,
 				b1cmd, (unsigned long)dma->recvlen);
 #endif
@@ -586,7 +586,7 @@ static void c4_handle_rx(avmcard *card)
 		break;
 
 	case RECEIVE_START:
-#ifdef CONFIG_C4_POLLDEBUG
+#ifdef AVM_C4_POLLDEBUG
 		printk(KERN_INFO "%s: poll from c4\n", card->name);
 #endif
 		if (!suppress_pollack)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
