From: akpm@linux-foundation.org
Subject: - bridge-eliminate-port_check-workqueue.patch removed from -mm tree
Date: Wed, 28 Feb 2007 15:53:31 -0800
Message-ID: <200702282353.l1SNrVOB031103@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932650AbXB1Xxn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 18:53:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     bridge: eliminate port_check workqueue
has been removed from the -mm tree.  Its filename was
     bridge-eliminate-port_check-workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bridge: eliminate port_check workqueue
From: Stephen Hemminger <shemminger@linux-foundation.org>

For testing purposes

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bridge/br_if.c      |   32 +++++++-------------------------
 net/bridge/br_notify.c  |   25 +++++++++++--------------
 net/bridge/br_private.h |    5 ++---
 3 files changed, 20 insertions(+), 42 deletions(-)

diff -puN net/bridge/br_if.c~bridge-eliminate-port_check-workqueue net/bridge/br_if.c
--- a/net/bridge/br_if.c~bridge-eliminate-port_check-workqueue
+++ a/net/bridge/br_if.c
@@ -77,26 +77,15 @@ static int port_cost(struct net_device *
  * Called from work queue to allow for calling functions that
  * might sleep (such as speed check), and to debounce.
  */
-static void port_carrier_check(struct work_struct *work)
+void br_port_carrier_check(struct net_bridge_port *p)
 {
-	struct net_bridge_port *p;
-	struct net_device *dev;
-	struct net_bridge *br;
-
-	dev = container_of(work, struct net_bridge_port,
-			   carrier_check.work)->dev;
-	work_release(work);
-
-	rtnl_lock();
-	p = dev->br_port;
-	if (!p)
-		goto done;
-	br = p->br;
+	struct net_device *dev = p->dev;
+	struct net_bridge *br = p->br;
 
 	if (netif_carrier_ok(dev))
 		p->path_cost = port_cost(dev);
 
-	if (br->dev->flags & IFF_UP) {
+	if (netif_running(br->dev)) {
 		spin_lock_bh(&br->lock);
 		if (netif_carrier_ok(dev)) {
 			if (p->state == BR_STATE_DISABLED)
@@ -107,9 +96,6 @@ static void port_carrier_check(struct wo
 		}
 		spin_unlock_bh(&br->lock);
 	}
-done:
-	dev_put(dev);
-	rtnl_unlock();
 }
 
 static void release_nbp(struct kobject *kobj)
@@ -162,9 +148,6 @@ static void del_nbp(struct net_bridge_po
 
 	dev_set_promiscuity(dev, -1);
 
-	if (cancel_delayed_work(&p->carrier_check))
-		dev_put(dev);
-
 	spin_lock_bh(&br->lock);
 	br_stp_disable_port(p);
 	spin_unlock_bh(&br->lock);
@@ -282,7 +265,6 @@ static struct net_bridge_port *new_nbp(s
 	p->port_no = index;
 	br_init_port(p);
 	p->state = BR_STATE_DISABLED;
-	INIT_DELAYED_WORK_NAR(&p->carrier_check, port_carrier_check);
 	br_stp_port_timer_init(p);
 
 	kobject_init(&p->kobj);
@@ -446,12 +428,12 @@ int br_add_if(struct net_bridge *br, str
 	spin_lock_bh(&br->lock);
 	br_stp_recalculate_bridge_id(br);
 	br_features_recompute(br);
-	if (schedule_delayed_work(&p->carrier_check, BR_PORT_DEBOUNCE))
-		dev_hold(dev);
-
 	spin_unlock_bh(&br->lock);
 
 	dev_set_mtu(br->dev, br_min_mtu(br));
+
+	br_port_carrier_check(p);
+
 	kobject_uevent(&p->kobj, KOBJ_ADD);
 
 	return 0;
diff -puN net/bridge/br_notify.c~bridge-eliminate-port_check-workqueue net/bridge/br_notify.c
--- a/net/bridge/br_notify.c~bridge-eliminate-port_check-workqueue
+++ a/net/bridge/br_notify.c
@@ -42,51 +42,48 @@ static int br_device_event(struct notifi
 
 	br = p->br;
 
-	spin_lock_bh(&br->lock);
 	switch (event) {
 	case NETDEV_CHANGEMTU:
 		dev_set_mtu(br->dev, br_min_mtu(br));
 		break;
 
 	case NETDEV_CHANGEADDR:
+		spin_lock_bh(&br->lock);
 		br_fdb_changeaddr(p, dev->dev_addr);
 		br_ifinfo_notify(RTM_NEWLINK, p);
 		br_stp_recalculate_bridge_id(br);
+		spin_unlock_bh(&br->lock);
 		break;
 
 	case NETDEV_CHANGE:
-		if (br->dev->flags & IFF_UP)
-			if (schedule_delayed_work(&p->carrier_check,
-						BR_PORT_DEBOUNCE))
-				dev_hold(dev);
+		br_port_carrier_check(p);
 		break;
 
 	case NETDEV_FEAT_CHANGE:
-		if (br->dev->flags & IFF_UP)
+		spin_lock_bh(&br->lock);
+		if (netif_running(br->dev))
 			br_features_recompute(br);
-
-		/* could do recursive feature change notification
-		 * but who would care??
-		 */
+		spin_unlock_bh(&br->lock);
 		break;
 
 	case NETDEV_DOWN:
+		spin_lock_bh(&br->lock);
 		if (br->dev->flags & IFF_UP)
 			br_stp_disable_port(p);
+		spin_unlock_bh(&br->lock);
 		break;
 
 	case NETDEV_UP:
+		spin_lock_bh(&br->lock);
 		if (netif_carrier_ok(dev) && (br->dev->flags & IFF_UP))
 			br_stp_enable_port(p);
+		spin_unlock_bh(&br->lock);
 		break;
 
 	case NETDEV_UNREGISTER:
-		spin_unlock_bh(&br->lock);
 		br_del_if(br, dev);
-		goto done;
+		break;
 	}
-	spin_unlock_bh(&br->lock);
 
- done:
 	return NOTIFY_DONE;
 }
diff -puN net/bridge/br_private.h~bridge-eliminate-port_check-workqueue net/bridge/br_private.h
--- a/net/bridge/br_private.h~bridge-eliminate-port_check-workqueue
+++ a/net/bridge/br_private.h
@@ -16,7 +16,6 @@
 #define _BR_PRIVATE_H
 
 #include <linux/netdevice.h>
-#include <linux/miscdevice.h>
 #include <linux/if_bridge.h>
 
 #define BR_HASH_BITS 8
@@ -29,7 +28,7 @@
 
 #define BR_PORT_DEBOUNCE (HZ/10)
 
-#define BR_VERSION	"2.2"
+#define BR_VERSION	"2.3"
 
 typedef struct bridge_id bridge_id;
 typedef struct mac_addr mac_addr;
@@ -82,7 +81,6 @@ struct net_bridge_port
 	struct timer_list		hold_timer;
 	struct timer_list		message_age_timer;
 	struct kobject			kobj;
-	struct delayed_work		carrier_check;
 	struct rcu_head			rcu;
 };
 
@@ -173,6 +171,7 @@ extern void br_flood_forward(struct net_
 		      int clone);
 
 /* br_if.c */
+extern void br_port_carrier_check(struct net_bridge_port *p);
 extern int br_add_bridge(const char *name);
 extern int br_del_bridge(const char *name);
 extern void br_cleanup_bridges(void);
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-netdev-all.patch
git-net.patch
