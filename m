From: akpm@linux-foundation.org
Subject: + notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:23:20 -0700
Message-ID: <201106292223.p5TMNKNN015820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab1F2WXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:23:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, davem@davemloft.net, greg@kroah.com, rjw@sisk.pl


The patch titled
     notifiers: net: move netdevice notifiers into netdevice.h
has been added to the -mm tree.  Its filename is
     notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch

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
Subject: notifiers: net: move netdevice notifiers into netdevice.h
From: Amerigo Wang <amwang@redhat.com>

It is not necessary to share the same notifier.h.

Signed-off-by: WANG Cong <amwang@redhat.com>
Acked-by: David Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/netdevice.h |   36 +++++++++++++++++++++++++++++++++---
 include/linux/notifier.h  |   28 +---------------------------
 2 files changed, 34 insertions(+), 30 deletions(-)

diff -puN include/linux/netdevice.h~notifiers-net-move-netdevice-notifiers-into-netdeviceh include/linux/netdevice.h
--- a/include/linux/netdevice.h~notifiers-net-move-netdevice-notifiers-into-netdeviceh
+++ a/include/linux/netdevice.h
@@ -1561,6 +1561,39 @@ struct packet_type {
 
 #include <linux/notifier.h>
 
+/* netdevice notifier chain. Please remember to update the rtnetlink
+ * notification exclusion list in rtnetlink_event() when adding new
+ * types.
+ */
+#define NETDEV_UP	0x0001	/* For now you can't veto a device up/down */
+#define NETDEV_DOWN	0x0002
+#define NETDEV_REBOOT	0x0003	/* Tell a protocol stack a network interface
+				   detected a hardware crash and restarted
+				   - we can use this eg to kick tcp sessions
+				   once done */
+#define NETDEV_CHANGE	0x0004	/* Notify device state change */
+#define NETDEV_REGISTER 0x0005
+#define NETDEV_UNREGISTER	0x0006
+#define NETDEV_CHANGEMTU	0x0007
+#define NETDEV_CHANGEADDR	0x0008
+#define NETDEV_GOING_DOWN	0x0009
+#define NETDEV_CHANGENAME	0x000A
+#define NETDEV_FEAT_CHANGE	0x000B
+#define NETDEV_BONDING_FAILOVER 0x000C
+#define NETDEV_PRE_UP		0x000D
+#define NETDEV_PRE_TYPE_CHANGE	0x000E
+#define NETDEV_POST_TYPE_CHANGE	0x000F
+#define NETDEV_POST_INIT	0x0010
+#define NETDEV_UNREGISTER_BATCH 0x0011
+#define NETDEV_RELEASE		0x0012
+#define NETDEV_NOTIFY_PEERS	0x0013
+#define NETDEV_JOIN		0x0014
+
+extern int register_netdevice_notifier(struct notifier_block *nb);
+extern int unregister_netdevice_notifier(struct notifier_block *nb);
+extern int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
+
+
 extern rwlock_t				dev_base_lock;		/* Device list lock */
 
 
@@ -1643,12 +1676,9 @@ static inline void unregister_netdevice(
 extern int 		netdev_refcnt_read(const struct net_device *dev);
 extern void		free_netdev(struct net_device *dev);
 extern void		synchronize_net(void);
-extern int 		register_netdevice_notifier(struct notifier_block *nb);
-extern int		unregister_netdevice_notifier(struct notifier_block *nb);
 extern int		init_dummy_netdev(struct net_device *dev);
 extern void		netdev_resync_ops(struct net_device *dev);
 
-extern int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
 extern struct net_device	*dev_get_by_index(struct net *net, int ifindex);
 extern struct net_device	*__dev_get_by_index(struct net *net, int ifindex);
 extern struct net_device	*dev_get_by_index_rcu(struct net *net, int ifindex);
diff -puN include/linux/notifier.h~notifiers-net-move-netdevice-notifiers-into-netdeviceh include/linux/notifier.h
--- a/include/linux/notifier.h~notifiers-net-move-netdevice-notifiers-into-netdeviceh
+++ a/include/linux/notifier.h
@@ -187,33 +187,7 @@ static inline int notifier_to_errno(int 
  
 /* CPU notfiers are defined in include/linux/cpu.h. */
 
-/* netdevice notifier chain. Please remember to update the rtnetlink
- * notification exclusion list in rtnetlink_event() when adding new
- * types.
- */
-#define NETDEV_UP	0x0001	/* For now you can't veto a device up/down */
-#define NETDEV_DOWN	0x0002
-#define NETDEV_REBOOT	0x0003	/* Tell a protocol stack a network interface
-				   detected a hardware crash and restarted
-				   - we can use this eg to kick tcp sessions
-				   once done */
-#define NETDEV_CHANGE	0x0004	/* Notify device state change */
-#define NETDEV_REGISTER 0x0005
-#define NETDEV_UNREGISTER	0x0006
-#define NETDEV_CHANGEMTU	0x0007
-#define NETDEV_CHANGEADDR	0x0008
-#define NETDEV_GOING_DOWN	0x0009
-#define NETDEV_CHANGENAME	0x000A
-#define NETDEV_FEAT_CHANGE	0x000B
-#define NETDEV_BONDING_FAILOVER 0x000C
-#define NETDEV_PRE_UP		0x000D
-#define NETDEV_PRE_TYPE_CHANGE	0x000E
-#define NETDEV_POST_TYPE_CHANGE	0x000F
-#define NETDEV_POST_INIT	0x0010
-#define NETDEV_UNREGISTER_BATCH 0x0011
-#define NETDEV_RELEASE		0x0012
-#define NETDEV_NOTIFY_PEERS	0x0013
-#define NETDEV_JOIN		0x0014
+/* netdevice notifiers are defined in include/linux/netdevice.h */
 
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-vt-move-vt-notifiers-into-vth.patch

