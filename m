From: akpm@linux-foundation.org
Subject: + zd1201-avoid-null-ptr-access-of-skb-dev.patch added to -mm tree
Date: Wed, 17 Oct 2007 18:18:01 -0700
Message-ID: <200710180118.l9I1I1l0017804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbXJRBSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 21:18:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linville@tuxdriver.com, acme@ghostprotocols.net, davem@davemloft.net


The patch titled
     zd1201: avoid null ptr access of skb->dev
has been added to the -mm tree.  Its filename is
     zd1201-avoid-null-ptr-access-of-skb-dev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: zd1201: avoid null ptr access of skb->dev
From: "John W. Linville" <linville@tuxdriver.com>

skb->dev is not set until eth_type_trans is called...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/zd1201.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/zd1201.c~zd1201-avoid-null-ptr-access-of-skb-dev drivers/net/wireless/zd1201.c
--- a/drivers/net/wireless/zd1201.c~zd1201-avoid-null-ptr-access-of-skb-dev
+++ a/drivers/net/wireless/zd1201.c
@@ -327,8 +327,8 @@ static void zd1201_usbrx(struct urb *urb
 			memcpy(skb_put(skb, 6), &data[datalen-8], 6);
 			memcpy(skb_put(skb, 2), &data[datalen-24], 2);
 			memcpy(skb_put(skb, len), data, len);
-			skb->dev->last_rx = jiffies;
 			skb->protocol = eth_type_trans(skb, zd->dev);
+			skb->dev->last_rx = jiffies;
 			zd->stats.rx_packets++;
 			zd->stats.rx_bytes += skb->len;
 			netif_rx(skb);
@@ -384,8 +384,8 @@ static void zd1201_usbrx(struct urb *urb
 			memcpy(skb_put(skb, 2), &data[6], 2);
 			memcpy(skb_put(skb, len), data+8, len);
 		}
-		skb->dev->last_rx = jiffies;
 		skb->protocol = eth_type_trans(skb, zd->dev);
+		skb->dev->last_rx = jiffies;
 		zd->stats.rx_packets++;
 		zd->stats.rx_bytes += skb->len;
 		netif_rx(skb);
_

Patches currently in -mm which might be from linville@tuxdriver.com are

origin.patch
zd1201-avoid-null-ptr-access-of-skb-dev.patch
git-wireless.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
pm-qos-infrastructure-and-interface.patch
latencyc-use-qos-infrastructure.patch
define-global-bit-macro.patch
