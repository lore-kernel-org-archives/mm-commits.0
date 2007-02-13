From: akpm@linux-foundation.org
Subject: + br_if-oops-in-port_carrier_check.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:23:08 -0800
Message-ID: <200702130723.l1D7N8HD024879@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57521 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbXBMHXN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:23:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkao2@o2.pl


The patch titled
     br_if: oops in port_carrier_check
has been added to the -mm tree.  Its filename is
     br_if-oops-in-port_carrier_check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: br_if: oops in port_carrier_check
From: Jarek Poplawski <jarkao2@o2.pl>

On Mon, Feb 12, 2007 at 09:47:38AM -0800, Stephen Hemminger wrote:
> On Mon, 12 Feb 2007 11:28:48 +0100
> Jarek Poplawski <jarkao2@o2.pl> wrote:
>
> > Here is my patch proposal for testing.
> > If it doesn't work - forget about it.
> > (Prepared with 2.6.20-git6 but could
> > be applied to 2.6.20 also.)
> >
> > Jarek P.
> >
> >
> > dev_hold/dev_put added to prevent dev kfree
> > during port_carrier_check runnig, while dev
> > and port are removed.
>
> No, holding the reference just stops the kfree, it doesn't
> stop the device from being removed from the port.

But I wrote above it is only to prevent the kfree.

>        p = dev->br_port;
>        if (!p)
>                goto done;
>        br = p->br;

Then p is NULL here and we goto done.

Sorry, but the first version was wrong (incomplete).
Below I attach a new proposal.

Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bridge/br_if.c     |    8 ++++++--
 net/bridge/br_notify.c |    4 +++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN net/bridge/br_if.c~br_if-oops-in-port_carrier_check net/bridge/br_if.c
--- a/net/bridge/br_if.c~br_if-oops-in-port_carrier_check
+++ a/net/bridge/br_if.c
@@ -108,6 +108,7 @@ static void port_carrier_check(struct wo
 		spin_unlock_bh(&br->lock);
 	}
 done:
+	dev_put(dev);
 	rtnl_unlock();
 }
 
@@ -161,7 +162,8 @@ static void del_nbp(struct net_bridge_po
 
 	dev_set_promiscuity(dev, -1);
 
-	cancel_delayed_work(&p->carrier_check);
+	if (cancel_delayed_work(&p->carrier_check))
+		dev_put(dev);
 
 	spin_lock_bh(&br->lock);
 	br_stp_disable_port(p);
@@ -444,7 +446,9 @@ int br_add_if(struct net_bridge *br, str
 	spin_lock_bh(&br->lock);
 	br_stp_recalculate_bridge_id(br);
 	br_features_recompute(br);
-	schedule_delayed_work(&p->carrier_check, BR_PORT_DEBOUNCE);
+	if (schedule_delayed_work(&p->carrier_check, BR_PORT_DEBOUNCE))
+		dev_hold(dev);
+
 	spin_unlock_bh(&br->lock);
 
 	dev_set_mtu(br->dev, br_min_mtu(br));
diff -puN net/bridge/br_notify.c~br_if-oops-in-port_carrier_check net/bridge/br_notify.c
--- a/net/bridge/br_notify.c~br_if-oops-in-port_carrier_check
+++ a/net/bridge/br_notify.c
@@ -56,7 +56,9 @@ static int br_device_event(struct notifi
 
 	case NETDEV_CHANGE:
 		if (br->dev->flags & IFF_UP)
-			schedule_delayed_work(&p->carrier_check, BR_PORT_DEBOUNCE);
+			if (schedule_delayed_work(&p->carrier_check,
+						BR_PORT_DEBOUNCE))
+				dev_hold(dev);
 		break;
 
 	case NETDEV_FEAT_CHANGE:
_

Patches currently in -mm which might be from jarkao2@o2.pl are

origin.patch
br_if-oops-in-port_carrier_check.patch
