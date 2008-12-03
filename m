From: akpm@linux-foundation.org
Subject: + generic-swap-iphase-rename-swap-to-swap_byte_order.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:08 -0800
Message-ID: <200812030819.mB38J8VH010211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbYLCITL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, davem@davemloft.net


The patch titled
     generic swap(): iphase: rename swap() to swap_byte_order()
has been added to the -mm tree.  Its filename is
     generic-swap-iphase-rename-swap-to-swap_byte_order.patch

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

linux-next.patch
9p-convert-d_iname-references-to-d_namename.patch
nfs-remove-redundant-tests-on-reading-new-pages.patch
generic-swap-ath9k-rename-swap-to-swap_array.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
generic-swap-lib-sortc-rename-swap-to-swap_func.patch
generic-swap-introduce-global-macro-swapa-b.patch
generic-swap-ext3-remove-local-swap-macro.patch
generic-swap-ext4-remove-local-swap-macro.patch
generic-swap-sched-remove-local-swap-macro.patch
generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

