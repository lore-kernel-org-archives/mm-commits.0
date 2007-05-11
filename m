From: akpm@linux-foundation.org
Subject: + fix-race-condition-about-network-device-name.patch added to -mm tree
Date: Thu, 10 May 2007 23:50:53 -0700
Message-ID: <200705110650.l4B6or4h009111@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620AbXEKGvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 02:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, davem@davemloft.net


The patch titled
     Fix race condition about network device name allocation
has been added to the -mm tree.  Its filename is
     fix-race-condition-about-network-device-name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix race condition about network device name allocation
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Fix the race condition between dev_alloc_name() and net device
unregistration.

dev_alloc_name checks `dev_base' list to find a suitable ID. On the
other hand, net devices are removed from that list on net device
unregistration. Both of them are done with holding rtnl lock. However,
removing sysfs entry is delayed until netdev_run_todo(), which doesn't
acquire rtnl lock. Therefore, on dev_alloc_name(), device name could
conflict with the device, which is unregistered, but its sysfs entry
still exist.

To fix this bug, change dev_alloc_name to check not only `dev_base'
list but also todo list and snapshot list.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/dev.c |   48 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff -puN net/core/dev.c~fix-race-condition-about-network-device-name net/core/dev.c
--- a/net/core/dev.c~fix-race-condition-about-network-device-name
+++ a/net/core/dev.c
@@ -229,6 +229,11 @@ extern void netdev_unregister_sysfs(stru
 #define	netdev_unregister_sysfs(dev)	do { } while(0)
 #endif
 
+/* Delayed registration/unregisteration */
+static DEFINE_SPINLOCK(net_todo_list_lock);
+static LIST_HEAD(net_todo_list);
+static LIST_HEAD(net_todo_snapshot_list);
+
 
 /*******************************************************************************
 
@@ -719,7 +724,32 @@ int dev_alloc_name(struct net_device *de
 				set_bit(i, inuse);
 		}
 
+		spin_lock(&net_todo_list_lock);
+		list_for_each_entry(d, &net_todo_list, todo_list) {
+			if (!sscanf(d->name, name, &i))
+				continue;
+			if (i < 0 || i >= max_netdevices)
+				continue;
+
+			/*  avoid cases where sscanf is not exact inverse of printf */
+			snprintf(buf, sizeof(buf), name, i);
+			if (!strncmp(buf, d->name, IFNAMSIZ))
+				set_bit(i, inuse);
+		}
+		list_for_each_entry(d, &net_todo_snapshot_list, todo_list) {
+			if (!sscanf(d->name, name, &i))
+				continue;
+			if (i < 0 || i >= max_netdevices)
+				continue;
+
+			/*  avoid cases where sscanf is not exact inverse of printf */
+			snprintf(buf, sizeof(buf), name, i);
+			if (!strncmp(buf, d->name, IFNAMSIZ))
+				set_bit(i, inuse);
+		}
 		i = find_first_zero_bit(inuse, max_netdevices);
+		spin_unlock(&net_todo_list_lock);
+
 		free_page((unsigned long) inuse);
 	}
 
@@ -2970,10 +3000,6 @@ static int dev_new_index(void)
 
 static int dev_boot_phase = 1;
 
-/* Delayed registration/unregisteration */
-static DEFINE_SPINLOCK(net_todo_list_lock);
-static struct list_head net_todo_list = LIST_HEAD_INIT(net_todo_list);
-
 static void net_set_todo(struct net_device *dev)
 {
 	spin_lock(&net_todo_list_lock);
@@ -3228,8 +3254,6 @@ static void netdev_wait_allrefs(struct n
 static DEFINE_MUTEX(net_todo_run_mutex);
 void netdev_run_todo(void)
 {
-	struct list_head list;
-
 	/* Need to guard against multiple cpu's getting out of order. */
 	mutex_lock(&net_todo_run_mutex);
 
@@ -3243,13 +3267,13 @@ void netdev_run_todo(void)
 
 	/* Snapshot list, allow later requests */
 	spin_lock(&net_todo_list_lock);
-	list_replace_init(&net_todo_list, &list);
+	list_replace_init(&net_todo_list, &net_todo_snapshot_list);
 	spin_unlock(&net_todo_list_lock);
 
-	while (!list_empty(&list)) {
+	while (!list_empty(&net_todo_snapshot_list)) {
 		struct net_device *dev
-			= list_entry(list.next, struct net_device, todo_list);
-		list_del(&dev->todo_list);
+			= list_entry(net_todo_snapshot_list.next,
+				     struct net_device, todo_list);
 
 		if (unlikely(dev->reg_state != NETREG_UNREGISTERING)) {
 			printk(KERN_ERR "network todo '%s' but state %d\n",
@@ -3269,6 +3293,10 @@ void netdev_run_todo(void)
 		BUG_TRAP(!dev->ip6_ptr);
 		BUG_TRAP(!dev->dn_ptr);
 
+		spin_lock(&net_todo_list_lock);
+		list_del(&dev->todo_list);
+		spin_unlock(&net_todo_list_lock);
+
 		/* It must be the very last action,
 		 * after this 'dev' may point to freed up memory.
 		 */
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

origin.patch
fix-race-condition-about-network-device-name.patch
fix-race-condition-about-network-device-name-fix.patch
