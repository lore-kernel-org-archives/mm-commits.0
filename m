From: akpm@osdl.org
Subject: - spidernet-add-net_ratelimit-to-suppress-long-output.patch removed from -mm tree
Date: Tue, 26 Dec 2006 15:19:04 -0800
Message-ID: <200612262319.kBQNJ4mp027781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38042 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849AbWLZX2u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Dec 2006 18:28:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jklewis@us.ibm.com, jlinas@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Spidernet: add net_ratelimit to suppress long output
has been removed from the -mm tree.  Its filename was
     spidernet-add-net_ratelimit-to-suppress-long-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Spidernet: add net_ratelimit to suppress long output
From: James K Lewis <jklewis@us.ibm.com>

This patch adds net_ratelimit to many of the printks in order to limit
extraneous warning messages (created in response to Bug 28554).  This patch
supercedes all previous ratelimit patches.  This has been tested, please
apply.

Signed-off-by: James K Lewis <jklewis@us.ibm.com>
Signed-off-by: Linas Vepstas <jlinas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/spider_net.c |   11 +++++------
 drivers/net/spider_net.h |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/net/spider_net.c~spidernet-add-net_ratelimit-to-suppress-long-output drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~spidernet-add-net_ratelimit-to-suppress-long-output
+++ a/drivers/net/spider_net.c
@@ -1036,11 +1036,10 @@ spider_net_decode_one_descr(struct spide
 
 	if ( (status != SPIDER_NET_DESCR_COMPLETE) &&
 	     (status != SPIDER_NET_DESCR_FRAME_END) ) {
-		if (netif_msg_rx_err(card)) {
+		if (netif_msg_rx_err(card))
 			pr_err("%s: RX descriptor with state %d\n",
 			       card->netdev->name, status);
-			card->spider_stats.rx_desc_unk_state++;
-		}
+		card->spider_stats.rx_desc_unk_state++;
 		goto refill;
 	}
 
@@ -1359,7 +1358,7 @@ spider_net_handle_error_irq(struct spide
 	case SPIDER_NET_GRFAFLLINT: /* fallthrough */
 	case SPIDER_NET_GRMFLLINT:
 		if (netif_msg_intr(card) && net_ratelimit())
-			pr_debug("Spider RX RAM full, incoming packets "
+			pr_err("Spider RX RAM full, incoming packets "
 			       "might be discarded!\n");
 		spider_net_rx_irq_off(card);
 		tasklet_schedule(&card->rxram_full_tl);
@@ -1377,7 +1376,7 @@ spider_net_handle_error_irq(struct spide
 	case SPIDER_NET_GDCDCEINT: /* fallthrough */
 	case SPIDER_NET_GDBDCEINT: /* fallthrough */
 	case SPIDER_NET_GDADCEINT:
-		if (netif_msg_intr(card))
+		if (netif_msg_intr(card) && net_ratelimit())
 			pr_err("got descriptor chain end interrupt, "
 			       "restarting DMAC %c.\n",
 			       'D'-(i-SPIDER_NET_GDDDCEINT)/3);
@@ -1448,7 +1447,7 @@ spider_net_handle_error_irq(struct spide
 			break;
 	}
 
-	if ((show_error) && (netif_msg_intr(card)))
+	if ((show_error) && (netif_msg_intr(card)) && net_ratelimit())
 		pr_err("Got error interrupt on %s, GHIINT0STS = 0x%08x, "
 		       "GHIINT1STS = 0x%08x, GHIINT2STS = 0x%08x\n",
 		       card->netdev->name,
diff -puN drivers/net/spider_net.h~spidernet-add-net_ratelimit-to-suppress-long-output drivers/net/spider_net.h
--- a/drivers/net/spider_net.h~spidernet-add-net_ratelimit-to-suppress-long-output
+++ a/drivers/net/spider_net.h
@@ -24,7 +24,7 @@
 #ifndef _SPIDER_NET_H
 #define _SPIDER_NET_H
 
-#define VERSION "1.6 A"
+#define VERSION "1.6 B"
 
 #include "sungem_phy.h"
 
_

Patches currently in -mm which might be from jklewis@us.ibm.com are

git-netdev-all.patch
spidernet-rework-rx-linked-list.patch

