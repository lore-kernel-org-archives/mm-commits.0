From: akpm@linux-foundation.org
Subject: + via-velocity-enable-perfect-filtering-for-multicast-packets.patch added to -mm tree
Date: Fri, 07 Nov 2008 14:52:13 -0800
Message-ID: <200811072252.mA7MqDIO009604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbYKGWwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 17:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, jeff@garzik.org, joeyzhuo@via.com.tw


The patch titled
     via-velocity: enable perfect filtering for multicast packets
has been added to the -mm tree.  Its filename is
     via-velocity-enable-perfect-filtering-for-multicast-packets.patch

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
Subject: via-velocity: enable perfect filtering for multicast packets
From: Francois Romieu <romieu@fr.zoreil.com>

Signed-off-by: Joey Zhuo <joeyzhuo@via.com.tw>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-velocity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/via-velocity.c~via-velocity-enable-perfect-filtering-for-multicast-packets drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~via-velocity-enable-perfect-filtering-for-multicast-packets
+++ a/drivers/net/via-velocity.c
@@ -2294,7 +2294,7 @@ static void velocity_set_multi(struct ne
 		}
 
 		mac_set_cam_mask(regs, vptr->mCAMmask);
-		rx_mode = (RCR_AM | RCR_AB);
+		rx_mode = RCR_AM | RCR_AB | RCR_AP;
 	}
 	if (dev->mtu > 1500)
 		rx_mode |= RCR_AL;
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

via-velocity-enable-perfect-filtering-for-multicast-packets.patch

