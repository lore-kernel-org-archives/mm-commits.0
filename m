From: akpm@linux-foundation.org
Subject: - ppp-dont-leak-an-sk_buff-on-interface-destruction.patch removed from -mm tree
Date: Mon, 26 Mar 2007 15:35:16 -0800
Message-ID: <200703262335.l2QNZGB7001157@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59020 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751AbXCZXfc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 19:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gl@dsa-ac.de, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ppp: don't leak an sk_buff on interface destruction
has been removed from the -mm tree.  Its filename was
     ppp-dont-leak-an-sk_buff-on-interface-destruction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ppp: don't leak an sk_buff on interface destruction
From: Guennadi Liakhovetski <gl@dsa-ac.de>

Signed-off-by: G. Liakhovetski <gl@dsa-ac.de>
Cc: Paul Mackerras <paulus@samba.org>

davem sayeth:

This is strange.

The PPP generic layer seems to be very careful about it's handling of
the ->xmit_pending packet.

When a packet is added to ->xmit_pending, immediately ppp_push() is
called, and ppp_push() gives the packet to the channels xmit function,
and unless the xmit function returns zero the ->xmit_pending is reset
to NULL because non-zero return from the channel xmit functions means
that the driver took the packet.

Now I checked irnet_ppp.c, which is the driver under scrutiny here,
and it never ever returns zero, under any circumstance, it always
return one.

So the ->xmit_pending should always be NULL'd out by ppp_push().

There is some funny BLOCK_WHEN_CONNECT code, which will return
0 in certain cases, but that define it never set during the
build.

Nevermind... that code does get enabled. :(

This looks like it might be a bug, perhaps you can only return zero
from the transmit function when your queue really is full and you plan
to wake things up properly when space appears (via
ppp_output_wakeup()).  You can't return 0 because of an event which
might never occur, that's what makes ->xmit_pending get stuck and
leak.

I'm really surprised this leak doesn't trigger already via the
ppp_synctty.c and ppp_async.c drivers, perhaps they do something to
make sure the transmitter gets purged properly when unregistering and
therefore ->xmit_pending does not get left non-NULL at unregister
time.
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ppp_generic.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/net/ppp_generic.c~ppp-dont-leak-an-sk_buff-on-interface-destruction drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~ppp-dont-leak-an-sk_buff-on-interface-destruction
+++ a/drivers/net/ppp_generic.c
@@ -2544,6 +2544,9 @@ static void ppp_destroy_interface(struct
 	ppp->active_filter = NULL;
 #endif /* CONFIG_PPP_FILTER */
 
+	if (ppp->xmit_pending)
+		kfree_skb(ppp->xmit_pending);
+
 	kfree(ppp);
 }
 
_

Patches currently in -mm which might be from gl@dsa-ac.de are

origin.patch
