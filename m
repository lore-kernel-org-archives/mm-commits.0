From: akpm@linux-foundation.org
Subject: [merged] skge-dont-mark-carrier-down-at-start.patch removed from -mm tree
Date: Mon, 28 Feb 2011 13:11:07 -0800
Message-ID: <201102282111.p1SLB7uL029390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab1B1VLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 16:11:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, davem@davemloft.net, gbillios@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     skge: don't mark carrier down at start
has been removed from the -mm tree.  Its filename was
     skge-dont-mark-carrier-down-at-start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: skge: don't mark carrier down at start
From: Stephen Hemminger <shemminger@linux-foundation.org>

The API for network devices has changed so that setting carrier off at
probe is no longer required.  This should fix the IPv6 addrconf issue.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=29612

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Reported-by: George Billios <gbillios@gmail.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/skge.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/net/skge.c~skge-dont-mark-carrier-down-at-start drivers/net/skge.c
--- a/drivers/net/skge.c~skge-dont-mark-carrier-down-at-start
+++ a/drivers/net/skge.c
@@ -3856,9 +3856,6 @@ static struct net_device *skge_devinit(s
 	memcpy_fromio(dev->dev_addr, hw->regs + B2_MAC_1 + port*8, ETH_ALEN);
 	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
 
-	/* device is off until link detection */
-	netif_carrier_off(dev);
