From: akpm@linux-foundation.org
Subject: + smsc95xx-use-netdev-stats-structure.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:33:35 -0700
Message-ID: <200907012233.n61MXZer015895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbZGAWeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:34:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     smsc95xx: use netdev stats structure
has been added to the -mm tree.  Its filename is
     smsc95xx-use-netdev-stats-structure.patch

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
cdc_eem-use-netdev-stats-structure.patch
dm9601-use-netdev-stats-structure.patch
net1080-use-netdev-stats-structure.patch
rndis_host-use-netdev-stats-structure.patch
smsc95xx-use-netdev-stats-structure.patch
usbnet-use-netdev-stats-structure.patch
usbnet-remove-private-stats-structure.patch

