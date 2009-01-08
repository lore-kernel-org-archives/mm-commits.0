From: akpm@linux-foundation.org
Subject: - generic-swap-iphase-rename-swap-to-swap_byte_order.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:12 -0800
Message-ID: <200901082251.n08MpC8N030347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763328AbZAHWvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     generic swap(): iphase: rename swap() to swap_byte_order()
has been removed from the -mm tree.  Its filename was
     generic-swap-iphase-rename-swap-to-swap_byte_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): iphase: rename swap() to swap_byte_order()
From: Wu Fengguang <fengguang.wu@intel.com>

In preparation for the introduction of a generic swap() macro.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/iphase.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/atm/iphase.c~generic-swap-iphase-rename-swap-to-swap_byte_order drivers/atm/iphase.c
--- a/drivers/atm/iphase.c~generic-swap-iphase-rename-swap-to-swap_byte_order
+++ a/drivers/atm/iphase.c
@@ -64,7 +64,7 @@
 #include <linux/jiffies.h>
 #include "iphase.h"		  
 #include "suni.h"		  
-#define swap(x) (((x & 0xff) << 8) | ((x & 0xff00) >> 8))  
+#define swap_byte_order(x) (((x & 0xff) << 8) | ((x & 0xff00) >> 8))
 
 #define PRIV(dev) ((struct suni_priv *) dev->phy_data)
 
@@ -1306,7 +1306,7 @@ static void rx_dle_intr(struct atm_dev *
           // get real pkt length  pwang_test
           trailer = (struct cpcs_trailer*)((u_char *)skb->data +
                                  skb->len - sizeof(*trailer));
-          length =  swap(trailer->length);
+	  length = swap_byte_order(trailer->length);
           if ((length > iadev->rx_buf_sz) || (length > 
                               (skb->len - sizeof(struct cpcs_trailer))))
           {
@@ -2995,7 +2995,7 @@ static int ia_pkt_tx (struct atm_vcc *vc
 		skb->len, PCI_DMA_TODEVICE);
 	wr_ptr->local_pkt_addr = (buf_desc_ptr->buf_start_hi << 16) | 
                                                   buf_desc_ptr->buf_start_lo;  
-	/* wr_ptr->bytes = swap(total_len);	didn't seem to affect ?? */  
+	/* wr_ptr->bytes = swap_byte_order(total_len); didn't seem to affect?? */
 	wr_ptr->bytes = skb->len;  
 
         /* hw bug - DLEs of 0x2d, 0x2e, 0x2f cause DMA lockup */
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

