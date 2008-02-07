From: akpm@linux-foundation.org
Subject: - mv643xx_eth-fix-byte-order-when-checksum-offload-is-enabled.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:31:06 -0800
Message-ID: <200802070030.m170Ul0g007422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932514AbYBGApS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byron.bbradley@gmail.com, dale@farnsworth.org, jeff@garzik.org, mlachwani@mvista.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mv643xx_eth: fix byte order when checksum offload is enabled
has been removed from the -mm tree.  Its filename was
     mv643xx_eth-fix-byte-order-when-checksum-offload-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mv643xx_eth: fix byte order when checksum offload is enabled
From: Byron Bradley <byron.bbradley@gmail.com>

The Marvell Orion system on chips have an integrated mv643xx MAC.  On these
little endian ARM devices mv643xx will oops when checksum offload is
enabled.  Swapping the byte order of the protocol and checksum solves this
problem.

Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Cc: Dale Farnsworth <dale@farnsworth.org>
Cc: Manish Lachwani <mlachwani@mvista.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mv643xx_eth.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/net/mv643xx_eth.c~mv643xx_eth-fix-byte-order-when-checksum-offload-is-enabled drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c~mv643xx_eth-fix-byte-order-when-checksum-offload-is-enabled
+++ a/drivers/net/mv643xx_eth.c
@@ -1652,6 +1652,11 @@ static void eth_tx_fill_frag_descs(struc
 	}
 }
 
+static inline __be16 sum16_as_be(__sum16 sum)
+{
+	return (__force __be16)sum;
+}
+
 /**
  * eth_tx_submit_descs_for_skb - submit data from an skb to the tx hw
  *
@@ -1689,7 +1694,7 @@ static void eth_tx_submit_descs_for_skb(
 	desc->buf_ptr = dma_map_single(NULL, skb->data, length, DMA_TO_DEVICE);
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		BUG_ON(skb->protocol != ETH_P_IP);
+		BUG_ON(skb->protocol != htons(ETH_P_IP));
 
 		cmd_sts |= ETH_GEN_TCP_UDP_CHECKSUM |
 			   ETH_GEN_IP_V_4_CHECKSUM  |
@@ -1698,10 +1703,10 @@ static void eth_tx_submit_descs_for_skb(
 		switch (ip_hdr(skb)->protocol) {
 		case IPPROTO_UDP:
 			cmd_sts |= ETH_UDP_FRAME;
-			desc->l4i_chk = udp_hdr(skb)->check;
+			desc->l4i_chk = ntohs(sum16_as_be(udp_hdr(skb)->check));
 			break;
 		case IPPROTO_TCP:
-			desc->l4i_chk = tcp_hdr(skb)->check;
+			desc->l4i_chk = ntohs(sum16_as_be(tcp_hdr(skb)->check));
 			break;
 		default:
 			BUG();
_

Patches currently in -mm which might be from byron.bbradley@gmail.com are

origin.patch
rewrite-rd-fix-2.patch
