From: akpm@linux-foundation.org
Subject: - p54usb-regression-due-to-commit-b19fa1f.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:25:11 -0700
Message-ID: <200808142325.m7ENPCw6002718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbYHNXZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Larry.Finger@lwfinger.net, mm-commits@vger.kernel.org


The patch titled
     p54usb: regression  due to commit b19fa1f
has been removed from the -mm tree.  Its filename was
     p54usb-regression-due-to-commit-b19fa1f.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: p54usb: regression  due to commit b19fa1f
From: Larry Finger <Larry.Finger@lwfinger.net>

In commit b19fa1fa91845234961c64dbd564671aa7c0fd27, the configuration
parameter NETDEVICES_MULTIQUEUE was eliminated making multiple TX queues
the normal behavior.  For p54usb, enabling multiple queues broke the
driver.

A temporary hack that forces only one queue is presented here.  With it,
the driver works as before.  Obviously, a proper fix is needed in the long
run.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/p54/p54common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/p54/p54common.c~p54usb-regression-due-to-commit-b19fa1f drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c~p54usb-regression-due-to-commit-b19fa1f
+++ a/drivers/net/wireless/p54/p54common.c
@@ -150,7 +150,7 @@ void p54_parse_firmware(struct ieee80211
 		priv->tx_stats[1].limit = 4;
 		priv->tx_stats[2].limit = 3;
 		priv->tx_stats[3].limit = 1;
-		dev->queues = 4;
+		dev->queues = 1; /* temp. hack, set to 1 as 4 breaks p54usb */
 	}
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
_

Patches currently in -mm which might be from Larry.Finger@lwfinger.net are

net-ieee80211-adjust-error-handling.patch
p54usb-regression-due-to-commit-b19fa1f.patch

