From: akpm@linux-foundation.org
Subject: - net-fix-tx-checksum-feature-check.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:41 -0700
Message-ID: <200706292041.l5TKff8e022596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43635 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900AbXF2UsH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:48:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     net: fix TX checksum feature check
has been removed from the -mm tree.  Its filename was
     net-fix-tx-checksum-feature-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net: fix TX checksum feature check
From: Herbert Xu <herbert@gondor.apana.org.au>

This patch fixes a boolean error in the new TX checksum check that causes
bogus TSO packets to be generated.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN net/core/dev.c~net-fix-tx-checksum-feature-check net/core/dev.c
--- a/net/core/dev.c~net-fix-tx-checksum-feature-check
+++ a/net/core/dev.c
@@ -1522,11 +1522,11 @@ int dev_queue_xmit(struct sk_buff *skb)
 		skb_set_transport_header(skb, skb->csum_start -
 					      skb_headroom(skb));
 
-		if (!(dev->features & NETIF_F_GEN_CSUM)
-		    || ((dev->features & NETIF_F_IP_CSUM)
-			&& skb->protocol == htons(ETH_P_IP))
-		    || ((dev->features & NETIF_F_IPV6_CSUM)
-			&& skb->protocol == htons(ETH_P_IPV6)))
+		if (!(dev->features & NETIF_F_GEN_CSUM) &&
+		    !((dev->features & NETIF_F_IP_CSUM) &&
+		      skb->protocol == htons(ETH_P_IP)) &&
+		    !((dev->features & NETIF_F_IPV6_CSUM) &&
+		      skb->protocol == htons(ETH_P_IPV6)))
 			if (skb_checksum_help(skb))
 				goto out_kfree_skb;
 	}
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

git-md-accel.patch
git-net.patch
git-cryptodev.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
