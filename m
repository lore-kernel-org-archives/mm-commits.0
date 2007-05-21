From: akpm@linux-foundation.org
Subject: - fix-race-condition-about-network-device-name-allocation.patch removed from -mm tree
Date: Mon, 21 May 2007 13:09:29 -0700
Message-ID: <200705212009.l4LK9SHf018771@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34189 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934847AbXEUUKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 16:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, kaneshige.kenji@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Fix race condition about network device name allocation
has been removed from the -mm tree.  Its filename was
     fix-race-condition-about-network-device-name-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix race condition about network device name allocation
From: Stephen Hemminger <shemminger@linux-foundation.org>

Kenji Kaneshige found this race between device removal and registration. 
On unregister it is possible for the old device to exist, because sysfs
file is still open.  A new device with 'eth%d' will select the same name,
but sysfs kobject register will fial.

The following changes the shutdown order slightly.  It hold a removes the
sysfs entries earlier (on unregister_netdevice), but holds a kobject
reference.  Then when todo runs the actual last put free happens.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c       |   10 ++++++----
 net/core/net-sysfs.c |    8 +++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN net/core/dev.c~fix-race-condition-about-network-device-name-allocation net/core/dev.c
--- a/net/core/dev.c~fix-race-condition-about-network-device-name-allocation
+++ a/net/core/dev.c
@@ -3258,7 +3258,6 @@ void netdev_run_todo(void)
 			continue;
 		}
 
-		netdev_unregister_sysfs(dev);
 		dev->reg_state = NETREG_UNREGISTERED;
 
 		netdev_wait_allrefs(dev);
@@ -3269,11 +3268,11 @@ void netdev_run_todo(void)
 		BUG_TRAP(!dev->ip6_ptr);
 		BUG_TRAP(!dev->dn_ptr);
 
-		/* It must be the very last action,
-		 * after this 'dev' may point to freed up memory.
-		 */
 		if (dev->destructor)
 			dev->destructor(dev);
+
+		/* Free network device */
+		kobject_put(&dev->dev.kobj);
 	}
 
 out:
@@ -3424,6 +3423,9 @@ void unregister_netdevice(struct net_dev
 	/* Notifier chain MUST detach us from master device. */
 	BUG_TRAP(!dev->master);
 
+	/* Remove entries from sysfs */
+	netdev_unregister_sysfs(dev);
+
 	/* Finish processing unregister after unlock */
 	net_set_todo(dev);
 
diff -puN net/core/net-sysfs.c~fix-race-condition-about-network-device-name-allocation net/core/net-sysfs.c
--- a/net/core/net-sysfs.c~fix-race-condition-about-network-device-name-allocation
+++ a/net/core/net-sysfs.c
@@ -456,9 +456,15 @@ static struct class net_class = {
 #endif
 };
 
+/* Delete sysfs entries but hold kobject reference until after all
+ * netdev references are gone.
+ */
 void netdev_unregister_sysfs(struct net_device * net)
 {
-	device_del(&(net->dev));
+	struct device *dev = &(net->dev);
+
+	kobject_get(&dev->kobj);
+	device_del(dev);
 }
 
 /* Create sysfs entries for network device. */
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-wireless.patch
pci-x-pci-express-read-control-interfaces.patch
pci-x-pci-express-read-control-interfaces-myrinet.patch
pci-x-pci-express-read-control-interfaces-mthca.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
pci-x-pci-express-read-control-interfaces-qla2xxx.patch
