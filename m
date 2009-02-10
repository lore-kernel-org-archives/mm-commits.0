From: akpm@linux-foundation.org
Subject: + de2104x-force-correct-order-when-writing-to-rx-ring.patch added to -mm tree
Date: Mon, 09 Feb 2009 17:01:39 -0800
Message-ID: <200902100101.n1A11dLg011285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753557AbZBJBCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 20:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: risto.suominen@gmail.com, Risto.Suominen@gmail.com, grundler@parisc-linux.org


The patch titled
     de2104x: force correct order when writing to rx ring
has been added to the -mm tree.  Its filename is
     de2104x-force-correct-order-when-writing-to-rx-ring.patch

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
Subject: de2104x: force correct order when writing to rx ring
From: Risto Suominen <risto.suominen@gmail.com>

DescOwn should not be set, thus allowing the chip to use the descriptor,
before everything else is set up correctly.

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/de2104x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/tulip/de2104x.c~de2104x-force-correct-order-when-writing-to-rx-ring drivers/net/tulip/de2104x.c
--- a/drivers/net/tulip/de2104x.c~de2104x-force-correct-order-when-writing-to-rx-ring
+++ a/drivers/net/tulip/de2104x.c
@@ -464,13 +464,14 @@ static void de_rx (struct de_private *de
 			drop = 1;
 
 rx_next:
-		de->rx_ring[rx_tail].opts1 = cpu_to_le32(DescOwn);
 		if (rx_tail == (DE_RX_RING_SIZE - 1))
 			de->rx_ring[rx_tail].opts2 =
 				cpu_to_le32(RingEnd | de->rx_buf_sz);
 		else
 			de->rx_ring[rx_tail].opts2 = cpu_to_le32(de->rx_buf_sz);
 		de->rx_ring[rx_tail].addr1 = cpu_to_le32(mapping);
+		wmb();
+		de->rx_ring[rx_tail].opts1 = cpu_to_le32(DescOwn);
 		rx_tail = NEXT_RX(rx_tail);
 	}
 
_

Patches currently in -mm which might be from risto.suominen@gmail.com are

de2104x-force-correct-order-when-writing-to-rx-ring.patch
de2104x-support-for-systems-lacking-cache-coherence.patch

