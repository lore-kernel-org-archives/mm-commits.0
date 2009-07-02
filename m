From: akpm@linux-foundation.org
Subject: [merged] smsc95xx-use-netdev-stats-structure.patch removed from -mm tree
Date: Thu, 02 Jul 2009 11:33:30 -0700
Message-ID: <200907021833.n62IXUkh018131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716AbZGBSd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 14:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     smsc95xx: use netdev stats structure
has been removed from the -mm tree.  Its filename was
     smsc95xx-use-netdev-stats-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smsc95xx: use netdev stats structure
From: Herbert Xu <herbert@gondor.apana.org.au>

Now that netdev has its own stats structure we should use that instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/smsc95xx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/usb/smsc95xx.c~smsc95xx-use-netdev-stats-structure drivers/net/usb/smsc95xx.c
--- a/drivers/net/usb/smsc95xx.c~smsc95xx-use-netdev-stats-structure
+++ a/drivers/net/usb/smsc95xx.c
@@ -1108,18 +1108,18 @@ static int smsc95xx_rx_fixup(struct usbn
 		if (unlikely(header & RX_STS_ES_)) {
 			if (netif_msg_rx_err(dev))
 				devdbg(dev, "Error header=0x%08x", header);
-			dev->stats.rx_errors++;
-			dev->stats.rx_dropped++;
+			dev->net->stats.rx_errors++;
+			dev->net->stats.rx_dropped++;
 
 			if (header & RX_STS_CRC_) {
-				dev->stats.rx_crc_errors++;
+				dev->net->stats.rx_crc_errors++;
 			} else {
 				if (header & (RX_STS_TL_ | RX_STS_RF_))
-					dev->stats.rx_frame_errors++;
+					dev->net->stats.rx_frame_errors++;
 
 				if ((header & RX_STS_LE_) &&
 					(!(header & RX_STS_FT_)))
-					dev->stats.rx_length_errors++;
+					dev->net->stats.rx_length_errors++;
 			}
 		} else {
 			/* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
linux-next.patch

