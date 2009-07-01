From: akpm@linux-foundation.org
Subject: + dm9601-use-netdev-stats-structure.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:33:29 -0700
Message-ID: <200907012233.n61MXTXd015733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbZGAWd7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     dm9601: use netdev stats structure
has been added to the -mm tree.  Its filename is
     dm9601-use-netdev-stats-structure.patch

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
Subject: dm9601: use netdev stats structure
From: Herbert Xu <herbert@gondor.apana.org.au>

Now that netdev has its own stats structure we should use that instead.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/dm9601.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/net/usb/dm9601.c~dm9601-use-netdev-stats-structure drivers/net/usb/dm9601.c
--- a/drivers/net/usb/dm9601.c~dm9601-use-netdev-stats-structure
+++ a/drivers/net/usb/dm9601.c
@@ -513,11 +513,11 @@ static int dm9601_rx_fixup(struct usbnet
 	len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
 	if (unlikely(status & 0xbf)) {
-		if (status & 0x01) dev->stats.rx_fifo_errors++;
-		if (status & 0x02) dev->stats.rx_crc_errors++;
-		if (status & 0x04) dev->stats.rx_frame_errors++;
-		if (status & 0x20) dev->stats.rx_missed_errors++;
-		if (status & 0x90) dev->stats.rx_length_errors++;
+		if (status & 0x01) dev->net->stats.rx_fifo_errors++;
+		if (status & 0x02) dev->net->stats.rx_crc_errors++;
+		if (status & 0x04) dev->net->stats.rx_frame_errors++;
+		if (status & 0x20) dev->net->stats.rx_missed_errors++;
+		if (status & 0x90) dev->net->stats.rx_length_errors++;
 		return 0;
 	}
 
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

