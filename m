From: akpm@linux-foundation.org
Subject: + wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code.patch added to -mm tree
Date: Sun, 29 Jun 2008 13:10:49 -0700
Message-ID: <200806292010.m5TKAnoZ004623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758328AbYF2UMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jun 2008 16:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, acme@redhat.com, davem@davemloft.net, jeff@garzik.org, stable@kernel.org


The patch titled
     wan: add missing skb->dev assignment in Frame Relay RX code
has been added to the -mm tree.  Its filename is
     wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wan: add missing skb->dev assignment in Frame Relay RX code
From: Krzysztof Halasa <khc@pm.waw.pl>

Commit 4c13eb6657fe9ef7b4dc8f1a405c902e9e5234e0 ([ETH]: Make
eth_type_trans set skb->dev like the other *_type_trans) removed skb->dev
assignment from hdlc_fr.c:fr_rx().  Unfortunately it was also needed for
cases other than eth_type_trans().

Add it back.

It's quite serious and may be a security risk as it causes a wrong input
interface indication (the physical hdlcX instead of logical pvcX). 
Probably -stable class fix.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/hdlc_fr.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wan/hdlc_fr.c~wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code drivers/net/wan/hdlc_fr.c
--- a/drivers/net/wan/hdlc_fr.c~wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code
+++ a/drivers/net/wan/hdlc_fr.c
@@ -1008,6 +1008,7 @@ static int fr_rx(struct sk_buff *skb)
 		stats->rx_bytes += skb->len;
 		if (pvc->state.becn)
 			stats->rx_compressed++;
+		skb->dev = dev;
 		netif_rx(skb);
 		return NET_RX_SUCCESS;
 	} else {
_

Patches currently in -mm which might be from khc@pm.waw.pl are

wan-add-missing-skb-dev-assignment-in-frame-relay-rx-code.patch

