From: akpm@linux-foundation.org
Subject: [nacked]
 net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch removed
 from -mm tree
Date: Thu, 03 Apr 2014 12:53:42 -0700
Message-ID: <533dbc46.1cgzm2y6LVpH6wWq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaDCTxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 15:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vyasevich@gmail.com, nicolas.dichtel@6wind.com, jiri@resnulli.us, davem@davemloft.net, yogeshgaur.83@gmail.com

Subject: [nacked] net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch removed from -mm tree
To: yogeshgaur.83@gmail.com,davem@davemloft.net,jiri@resnulli.us,nicolas.dichtel@6wind.com,vyasevich@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 12:53:42 -0700


The patch titled
     Subject: net/core/rtnetlink.c: copy paste error in rtnl_bridge_notify()
has been removed from the -mm tree.  Its filename was
     net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yogesh Gaur <yogeshgaur.83@gmail.com>
Subject: net/core/rtnetlink.c: copy paste error in rtnl_bridge_notify()

Seems to be copy paste error in calling ndo_bridge_getlink() func.

Signed-off-by: Yogesh Gaur <yogeshgaur.83@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/rtnetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/core/rtnetlink.c~net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify
+++ a/net/core/rtnetlink.c
@@ -2576,7 +2576,7 @@ static int rtnl_bridge_notify(struct net
 
 	if ((!flags || (flags & BRIDGE_FLAGS_MASTER)) &&
 	    br_dev && br_dev->netdev_ops->ndo_bridge_getlink) {
-		err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, dev, 0);
+		err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, br_dev, 0);
 		if (err < 0)
 			goto errout;
 	}
_

Patches currently in -mm which might be from yogeshgaur.83@gmail.com are


