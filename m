From: akpm@linux-foundation.org
Subject: - via-velocity-enable-perfect-filtering-for-multicast-packets.patch removed from -mm tree
Date: Mon, 17 Nov 2008 13:27:29 -0800
Message-ID: <200811172127.mAHLRT7d024304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbYKQV2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Nov 2008 16:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, jeff@garzik.org, joeyzhuo@via.com.tw, mm-commits@vger.kernel.org


The patch titled
     via-velocity: enable perfect filtering for multicast packets
has been removed from the -mm tree.  Its filename was
     via-velocity-enable-perfect-filtering-for-multicast-packets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

