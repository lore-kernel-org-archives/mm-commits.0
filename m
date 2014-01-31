From: akpm@linux-foundation.org
Subject: +
 net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch added to
 -mm tree
Date: Fri, 31 Jan 2014 12:26:08 -0800
Message-ID: <52ec06e0.xIV4SSN6Rne4NTX6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbaAaU0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 15:26:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vyasevich@gmail.com, nicolas.dichtel@6wind.com, jiri@resnulli.us, davem@davemloft.net, yogeshgaur.83@gmail.com

Subject: + net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch added to -mm tree
To: yogeshgaur.83@gmail.com,davem@davemloft.net,jiri@resnulli.us,nicolas.dichtel@6wind.com,vyasevich@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 12:26:08 -0800


The patch titled
     Subject: net/core/rtnetlink.c: copy paste error in rtnl_bridge_notify()
has been added to the -mm tree.  Its filename is
     net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2571,7 +2571,7 @@ static int rtnl_bridge_notify(struct net
 
 	if ((!flags || (flags & BRIDGE_FLAGS_MASTER)) &&
 	    br_dev && br_dev->netdev_ops->ndo_bridge_getlink) {
-		err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, dev, 0);
+		err = br_dev->netdev_ops->ndo_bridge_getlink(skb, 0, 0, br_dev, 0);
 		if (err < 0)
 			goto errout;
 	}
_

Patches currently in -mm which might be from yogeshgaur.83@gmail.com are

net-core-rtnetlinkc-copy-paste-error-in-rtnl_bridge_notify.patch

