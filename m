From: akpm@linux-foundation.org
Subject: + spidernet-janitorial-typos.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:01:52 -0800
Message-ID: <200702251301.l1PD1snq029845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35645 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964918AbXBYNCt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:02:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linas@austin.ibm.com


The patch titled
     spidernet: janitorial, typos
has been added to the -mm tree.  Its filename is
     spidernet-janitorial-typos.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spidernet: janitorial, typos
From: Linas Vepstas <linas@austin.ibm.com>

Janitorial patch. Undo long lines, fix typo in err msg.

Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/spider_net.c |   13 +++++++------
 drivers/net/spider_net.h |    2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-janitorial-typos drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-janitorial-typos
+++ a/drivers/net/spider_net.c
@@ -1053,14 +1053,15 @@ static void show_rx_chain(struct spider_
 #endif
 
 /**
- * spider_net_decode_one_descr - processes an rx descriptor
+ * spider_net_decode_one_descr - processes an RX descriptor
  * @card: card structure
  *
- * Returns 1 if a packet has been sent to the stack, otherwise 0
+ * Returns 1 if a packet has been sent to the stack, otherwise 0.
  *
- * Processes an rx descriptor by iommu-unmapping the data buffer and passing
- * the packet up to the stack. This function is called in softirq
- * context, e.g. either bottom half from interrupt or NAPI polling context
+ * Processes an RX descriptor by iommu-unmapping the data buffer
+ * and passing the packet up to the stack. This function is called
+ * in softirq context, e.g. either bottom half from interrupt or
+ * NAPI polling context.
  */
 static int
 spider_net_decode_one_descr(struct spider_net_card *card)
@@ -1097,7 +1098,7 @@ spider_net_decode_one_descr(struct spide
 	if ( (status != SPIDER_NET_DESCR_COMPLETE) &&
 	     (status != SPIDER_NET_DESCR_FRAME_END) ) {
 		if (netif_msg_rx_err(card))
-			pr_err("%s: RX descriptor with unkown state %d\n",
+			pr_err("%s: RX descriptor with unknown state %d\n",
 			       card->netdev->name, status);
 		card->spider_stats.rx_desc_unk_state++;
 		goto bad_desc;
diff -puN drivers/net/spider_net.h~spidernet-janitorial-typos drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~spidernet-janitorial-typos
+++ a/drivers/net/spider_net.h
@@ -25,7 +25,7 @@
 #ifndef _SPIDER_NET_H
 #define _SPIDER_NET_H
 
-#define VERSION "1.6 C"
+#define VERSION "2.0 A"
 
 #include "sungem_phy.h"
 
_

Patches currently in -mm which might be from linas@austin.ibm.com are

s2io-add-pci-error-recovery-support.patch
sungem_phy-support-bcm5461-phy-autoneg.patch
spidernet-compile-break.patch
spidernet-autoneg-support-for-celleb.patch
spidernet-load-firmware-when-open.patch
spidernet-spidernet-add-support-for-celleb.patch
spidernet-remove-txram-full-logging.patch
spidernet-move-medium-variable-into-card-struct.patch
spidernet-separate-hardware-state-from-driver-state.patch
spidernet-fix-racy-double-free-of-skb.patch
spidernet-transmit-race.patch
spidernet-janitorial-typos.patch
spidernet-maintainership.patch
