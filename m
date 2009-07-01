From: akpm@linux-foundation.org
Subject: + cdc_eem-use-netdev-stats-structure.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:33:27 -0700
Message-ID: <200907012233.n61MXRCK015730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbZGAWd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     cdc_eem: use netdev stats structure
has been added to the -mm tree.  Its filename is
     cdc_eem-use-netdev-stats-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
cdc_eem-use-netdev-stats-structure.patch
dm9601-use-netdev-stats-structure.patch
net1080-use-netdev-stats-structure.patch
rndis_host-use-netdev-stats-structure.patch
smsc95xx-use-netdev-stats-structure.patch
usbnet-use-netdev-stats-structure.patch
usbnet-remove-private-stats-structure.patch

