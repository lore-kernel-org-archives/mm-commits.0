From: akpm@linux-foundation.org
Subject: + net-fix-tx-checksum-feature-check.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:32:30 -0700
Message-ID: <200706282232.l5SMWUHl003047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50654 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765129AbXF1WdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     net: fix TX checksum feature check
has been added to the -mm tree.  Its filename is
     net-fix-tx-checksum-feature-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
net-fix-tx-checksum-feature-check.patch
git-cryptodev.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
