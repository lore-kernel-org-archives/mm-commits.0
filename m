From: akpm@linux-foundation.org
Subject: [merged] rndis_host-use-netdev-stats-structure.patch removed from -mm tree
Date: Thu, 02 Jul 2009 11:33:28 -0700
Message-ID: <200907021833.n62IXScH018120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbZGBSd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 14:33:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     rndis_host: use netdev stats structure
has been removed from the -mm tree.  Its filename was
     rndis_host-use-netdev-stats-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rndis_host: use netdev stats structure
From: Herbert Xu <herbert@gondor.apana.org.au>

Now that netdev has its own stats structure we should use that instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/rndis_host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/rndis_host.c~rndis_host-use-netdev-stats-structure drivers/net/usb/rndis_host.c
--- a/drivers/net/usb/rndis_host.c~rndis_host-use-netdev-stats-structure
+++ a/drivers/net/usb/rndis_host.c
@@ -487,7 +487,7 @@ int rndis_rx_fixup(struct usbnet *dev, s
 		if (unlikely(hdr->msg_type != RNDIS_MSG_PACKET
 				|| skb->len < msg_len
 				|| (data_offset + data_len + 8) > msg_len)) {
-			dev->stats.rx_frame_errors++;
+			dev->net->stats.rx_frame_errors++;
 			devdbg(dev, "bad rndis message %d/%d/%d/%d, len %d",
 				le32_to_cpu(hdr->msg_type),
 				msg_len, data_offset, data_len, skb->len);
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
linux-next.patch

