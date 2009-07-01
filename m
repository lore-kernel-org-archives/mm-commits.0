From: akpm@linux-foundation.org
Subject: + rndis_host-use-netdev-stats-structure.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:33:33 -0700
Message-ID: <200907012233.n61MXXYD015866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754225AbZGAWeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: herbert@gondor.apana.org.au


The patch titled
     rndis_host: use netdev stats structure
has been added to the -mm tree.  Its filename is
     rndis_host-use-netdev-stats-structure.patch

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
cdc_eem-use-netdev-stats-structure.patch
dm9601-use-netdev-stats-structure.patch
net1080-use-netdev-stats-structure.patch
rndis_host-use-netdev-stats-structure.patch
smsc95xx-use-netdev-stats-structure.patch
usbnet-use-netdev-stats-structure.patch
usbnet-remove-private-stats-structure.patch

