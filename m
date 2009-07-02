From: akpm@linux-foundation.org
Subject: [merged] net1080-use-netdev-stats-structure.patch removed from -mm tree
Date: Thu, 02 Jul 2009 11:33:26 -0700
Message-ID: <200907021833.n62IXQDd018073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbZGBSd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 14:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     net1080: use netdev stats structure
has been removed from the -mm tree.  Its filename was
     net1080-use-netdev-stats-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net1080: use netdev stats structure
From: Herbert Xu <herbert@gondor.apana.org.au>

Now that netdev has its own stats structure we should use that instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/net1080.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/net/usb/net1080.c~net1080-use-netdev-stats-structure drivers/net/usb/net1080.c
--- a/drivers/net/usb/net1080.c~net1080-use-netdev-stats-structure
+++ a/drivers/net/usb/net1080.c
@@ -433,7 +433,7 @@ static int net1080_rx_fixup(struct usbne
 		dbg("rx framesize %d range %d..%d mtu %d", skb->len,
 			net->hard_header_len, dev->hard_mtu, net->mtu);
 #endif
-		dev->stats.rx_frame_errors++;
+		dev->net->stats.rx_frame_errors++;
 		nc_ensure_sync(dev);
 		return 0;
 	}
@@ -442,12 +442,12 @@ static int net1080_rx_fixup(struct usbne
 	hdr_len = le16_to_cpup(&header->hdr_len);
 	packet_len = le16_to_cpup(&header->packet_len);
 	if (FRAMED_SIZE(packet_len) > NC_MAX_PACKET) {
-		dev->stats.rx_frame_errors++;
+		dev->net->stats.rx_frame_errors++;
 		dbg("packet too big, %d", packet_len);
 		nc_ensure_sync(dev);
 		return 0;
 	} else if (hdr_len < MIN_HEADER) {
-		dev->stats.rx_frame_errors++;
+		dev->net->stats.rx_frame_errors++;
 		dbg("header too short, %d", hdr_len);
 		nc_ensure_sync(dev);
 		return 0;
@@ -465,21 +465,21 @@ static int net1080_rx_fixup(struct usbne
 
 	if ((packet_len & 0x01) == 0) {
 		if (skb->data [packet_len] != PAD_BYTE) {
-			dev->stats.rx_frame_errors++;
+			dev->net->stats.rx_frame_errors++;
 			dbg("bad pad");
 			return 0;
 		}
 		skb_trim(skb, skb->len - 1);
 	}
 	if (skb->len != packet_len) {
-		dev->stats.rx_frame_errors++;
+		dev->net->stats.rx_frame_errors++;
 		dbg("bad packet len %d (expected %d)",
 			skb->len, packet_len);
 		nc_ensure_sync(dev);
 		return 0;
 	}
 	if (header->packet_id != get_unaligned(&trailer->packet_id)) {
-		dev->stats.rx_fifo_errors++;
+		dev->net->stats.rx_fifo_errors++;
 		dbg("(2+ dropped) rx packet_id mismatch 0x%x 0x%x",
 			le16_to_cpu(header->packet_id),
 			le16_to_cpu(trailer->packet_id));
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
linux-next.patch

