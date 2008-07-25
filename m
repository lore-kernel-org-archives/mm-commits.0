From: akpm@linux-foundation.org
Subject: - devcgroup-relax-white-list-protection-down-to-rcu.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:30 -0700
Message-ID: <200807252258.m6PMwUfr003296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbYGYW7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, balbir@in.ibm.com, menage@google.com, paulmck@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     devcgroup: relax white-list protection down to RCU
has been removed from the -mm tree.  Its filename was
     devcgroup-relax-white-list-protection-down-to-rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devcgroup: relax white-list protection down to RCU
From: Pavel Emelyanov <xemul@openvz.org>

Currently this list is protected with a simple spinlock, even for reading
from one.  This is OK, but can be better.

Actually I want it to be better very much, since after replacing the
OpenVZ device permissions engine with the cgroup-based one I noticed, that
we set 12 default device permissions for each newly created container (for
/dev/null, full, terminals, ect devices), and people sometimes have up to
20 perms more, so traversing the ~30-40 elements list under a spinlock
doesn't seem very good.

Here's the RCU protection for white-list - dev_whitelist_item-s are added
and removed under the devcg->lock, but are looked up in permissions
checking under the rcu_read_lock.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN security/device_cgroup.c~devcgroup-relax-white-list-protection-down-to-rcu security/device_cgroup.c
--- a/security/device_cgroup.c~devcgroup-relax-white-list-protection-down-to-rcu
+++ a/security/device_cgroup.c
@@ -41,6 +41,7 @@ struct dev_whitelist_item {
 	short type;
 	short access;
 	struct list_head list;
+	struct rcu_head rcu;
 };
 
 struct dev_cgroup {
@@ -133,11 +134,19 @@ static int dev_whitelist_add(struct dev_
 	}
 
 	if (whcopy != NULL)
-		list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
+		list_add_tail_rcu(&whcopy->list, &dev_cgroup->whitelist);
 	spin_unlock(&dev_cgroup->lock);
 	return 0;
 }
 
+static void whitelist_item_free(struct rcu_head *rcu)
+{
+	struct dev_whitelist_item *item;
+
+	item = container_of(rcu, struct dev_whitelist_item, rcu);
+	kfree(item);
+}
+
 /*
  * called under cgroup_lock()
  * since the list is visible to other tasks, we need the spinlock also
@@ -161,8 +170,8 @@ static void dev_whitelist_rm(struct dev_
 remove:
 		walk->access &= ~wh->access;
 		if (!walk->access) {
-			list_del(&walk->list);
-			kfree(walk);
+			list_del_rcu(&walk->list);
+			call_rcu(&walk->rcu, whitelist_item_free);
 		}
 	}
 	spin_unlock(&dev_cgroup->lock);
@@ -269,15 +278,15 @@ static int devcgroup_seq_read(struct cgr
 	struct dev_whitelist_item *wh;
 	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
 
-	spin_lock(&devcgroup->lock);
-	list_for_each_entry(wh, &devcgroup->whitelist, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(wh, &devcgroup->whitelist, list) {
 		set_access(acc, wh->access);
 		set_majmin(maj, wh->major);
 		set_majmin(min, wh->minor);
 		seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
 			   maj, min, acc);
 	}
-	spin_unlock(&devcgroup->lock);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -510,8 +519,8 @@ int devcgroup_inode_permission(struct in
 	if (!dev_cgroup)
 		return 0;
 
-	spin_lock(&dev_cgroup->lock);
-	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
@@ -527,10 +536,10 @@ acc_check:
 			continue;
 		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
 			continue;
-		spin_unlock(&dev_cgroup->lock);
+		rcu_read_unlock();
 		return 0;
 	}
-	spin_unlock(&dev_cgroup->lock);
+	rcu_read_unlock();
 
 	return -EPERM;
 }
@@ -545,7 +554,7 @@ int devcgroup_inode_mknod(int mode, dev_
 	if (!dev_cgroup)
 		return 0;
 
-	spin_lock(&dev_cgroup->lock);
+	rcu_read_lock();
 	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
@@ -560,9 +569,9 @@ int devcgroup_inode_mknod(int mode, dev_
 acc_check:
 		if (!(wh->access & ACC_MKNOD))
 			continue;
-		spin_unlock(&dev_cgroup->lock);
+		rcu_read_unlock();
 		return 0;
 	}
-	spin_unlock(&dev_cgroup->lock);
+	rcu_read_unlock();
 	return -EPERM;
 }
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
reiser4.patch

