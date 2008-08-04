From: akpm@linux-foundation.org
Subject: - bridge-send-correct-mtu-value-in-pmtu-revised.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:10 -0700
Message-ID: <200808042007.m74K7A18027754@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762156AbYHDUHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, siwu@hrz.tu-chemnitz.de, mm-commits@vger.kernel.org


The patch titled
     bridge: send correct MTU value in PMTU (revised)
has been removed from the -mm tree.  Its filename was
     bridge-send-correct-mtu-value-in-pmtu-revised.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bridge: send correct MTU value in PMTU (revised)
From: Stephen Hemminger <shemminger@linux-foundation.org>

When bridging interfaces with different MTUs, the bridge correctly chooses
the minimum of the MTUs of the physical devices as the bridges MTU.  But
when a frame is passed which fits through the incoming, but not through
the outgoing interface, a "Fragmentation Needed" packet is generated.

However, the propagated MTU is hardcoded to 1500, which is wrong in this
situation.  The sender will repeat the packet again with the same frame
size, and the same problem will occur again.

Instead of sending 1500, the (correct) MTU value of the bridge is now sent
via PMTU.  To achieve this, the corresponding rtable structure is stored
in its net_bridge structure.

Modified to get rid of fake_net_device as well.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bridge/br_if.c        |   26 +-------------------------
 net/bridge/br_netfilter.c |   18 ++++++++++++++++++
 net/bridge/br_private.h   |    5 +++--
 3 files changed, 22 insertions(+), 27 deletions(-)

diff -puN net/bridge/br_if.c~bridge-send-correct-mtu-value-in-pmtu-revised net/bridge/br_if.c
--- a/net/bridge/br_if.c~bridge-send-correct-mtu-value-in-pmtu-revised
+++ a/net/bridge/br_if.c
@@ -168,23 +168,6 @@ static void del_br(struct net_bridge *br
 	unregister_netdevice(br->dev);
 }
 
-#ifdef CONFIG_BRIDGE_NETFILTER
-/* We need these fake structures to make netfilter happy --
- * lots of places assume that skb->dst != NULL, which isn't
- * all that unreasonable.
- *
- * Currently, we fill in the PMTU entry because netfilter
- * refragmentation needs it, and the rt_flags entry because
- * ipt_REJECT needs it.  Future netfilter modules might
- * require us to fill additional fields. */
-struct net_device __fake_net_device = {
-	.hard_header_len	= ETH_HLEN,
-#ifdef CONFIG_NET_NS
-	.nd_net			= &init_net,
-#endif
-};
-#endif
-
 static struct net_device *new_bridge_dev(const char *name)
 {
 	struct net_bridge *br;
@@ -220,14 +203,7 @@ static struct net_device *new_bridge_dev
 	br->topology_change_detected = 0;
 	br->ageing_time = 300 * HZ;
 
-#ifdef CONFIG_BRIDGE_NETFILTER
-	atomic_set(&br->fake_rtable.u.dst.__refcnt, 1);
-	br->fake_rtable.u.dst.dev = &__fake_net_device;
-	br->fake_rtable.u.dst.path = &br->fake_rtable.u.dst;
-	br->fake_rtable.u.dst.metrics[RTAX_MTU - 1] = 1500;
-	br->fake_rtable.u.dst.flags	= DST_NOXFRM;
-	br->fake_rtable.rt_flags = 0;
-#endif
+	br_netfilter_rtable_init(br);
 
 	INIT_LIST_HEAD(&br->age_list);
 
diff -puN net/bridge/br_netfilter.c~bridge-send-correct-mtu-value-in-pmtu-revised net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c~bridge-send-correct-mtu-value-in-pmtu-revised
+++ a/net/bridge/br_netfilter.c
@@ -101,6 +101,24 @@ static inline __be16 pppoe_proto(const s
 	 pppoe_proto(skb) == htons(PPP_IPV6) && \
 	 brnf_filter_pppoe_tagged)
 
+/*
+ * Initialize bogus route table used to keep netfilter happy.
+ * Currently, we fill in the PMTU entry because netfilter
+ * refragmentation needs it, and the rt_flags entry because
+ * ipt_REJECT needs it.  Future netfilter modules might
+ * require us to fill additional fields.
+ */
+void br_netfilter_rtable_init(struct net_bridge *br)
+{
+	struct rtable *rt = &br->fake_rtable;
+
+	atomic_set(&rt->u.dst.__refcnt, 1);
+	rt->u.dst.dev = &br->dev;
+	rt->u.dst.path = &rt->u.dst;
+	rt->u.dst.metrics[RTAX_MTU - 1] = 1500;
+	rt->u.dst.flags	= DST_NOXFRM;
+}
+
 static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 {
 	struct net_bridge_port *port = rcu_dereference(dev->br_port);
diff -puN net/bridge/br_private.h~bridge-send-correct-mtu-value-in-pmtu-revised net/bridge/br_private.h
--- a/net/bridge/br_private.h~bridge-send-correct-mtu-value-in-pmtu-revised
+++ a/net/bridge/br_private.h
@@ -15,7 +15,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/if_bridge.h>
-#include <net/route.h>	/* struct rtable, RTAX_MTU */
+#include <net/route.h>
 
 #define BR_HASH_BITS 8
 #define BR_HASH_SIZE (1 << BR_HASH_BITS)
@@ -201,10 +201,11 @@ extern int br_ioctl_deviceless_stub(stru
 #ifdef CONFIG_BRIDGE_NETFILTER
 extern int br_netfilter_init(void);
 extern void br_netfilter_fini(void);
+extern void br_netfilter_rtable_init(struct net_bridge *);
 #else
 #define br_netfilter_init()	(0)
 #define br_netfilter_fini()	do { } while(0)
-extern struct net_device __fake_net_device;
+#define br_netfilter_rtable_init(x)
 #endif
 
 /* br_stp.c */
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
sky2-adapt-to-use-reworked-pci-pm-code.patch

