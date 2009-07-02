From: akpm@linux-foundation.org
Subject: [merged] cdc_eem-use-netdev-stats-structure.patch removed from -mm tree
Date: Thu, 02 Jul 2009 11:33:21 -0700
Message-ID: <200907021833.n62IXLif017960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbZGBSd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 14:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     cdc_eem: use netdev stats structure
has been removed from the -mm tree.  Its filename was
     cdc_eem-use-netdev-stats-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cdc_eem: use netdev stats structure
From: Herbert Xu <herbert@gondor.apana.org.au>

Now that netdev has its own stats structure we should use that instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/cdc_eem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/cdc_eem.c~cdc_eem-use-netdev-stats-structure drivers/net/usb/cdc_eem.c
--- a/drivers/net/usb/cdc_eem.c~cdc_eem-use-netdev-stats-structure
+++ a/drivers/net/usb/cdc_eem.c
@@ -319,7 +319,7 @@ static int eem_rx_fixup(struct usbnet *d
 				return crc == crc2;
 
 			if (unlikely(crc != crc2)) {
-				dev->stats.rx_errors++;
+				dev->net->stats.rx_errors++;
 				dev_kfree_skb_any(skb2);
 			} else
 				usbnet_skb_return(dev, skb2);
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
linux-next.patch

