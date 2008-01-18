From: akpm@linux-foundation.org
Subject: + bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem.patch added to -mm tree
Date: Thu, 17 Jan 2008 16:40:48 -0800
Message-ID: <200801180040.m0I0emhq022620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756662AbYARAqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 19:46:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fubar@us.ibm.com


The patch titled
     bonding: fix lock ordering for rtnl and bonding_rwsem
has been added to the -mm tree.  Its filename is
     bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bonding: fix lock ordering for rtnl and bonding_rwsem
From: Jay Vosburgh <fubar@us.ibm.com>

Fix the handling of rtnl and the bonding_rwsem to always be acquired
in a consistent order (rtnl, then bonding_rwsem).

The existing code sometimes acquired them in this order, and sometimes
in the opposite order, which opens a window for deadlock between ifenslave
and sysfs.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c  |   19 ++++++++++++
 drivers/net/bonding/bond_sysfs.c |   43 ++++++++++-------------------
 2 files changed, 35 insertions(+), 27 deletions(-)

diff -puN drivers/net/bonding/bond_main.c~bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem
+++ a/drivers/net/bonding/bond_main.c
@@ -4874,9 +4874,22 @@ static struct lock_class_key bonding_net
 int bond_create(char *name, struct bond_params *params, struct bonding **newbond)
 {
 	struct net_device *bond_dev;
+	struct bonding *bond, *nxt;
 	int res;
 
 	rtnl_lock();
+	down_write(&bonding_rwsem);
+
+	/* Check to see if the bond already exists. */
+	list_for_each_entry_safe(bond, nxt, &bond_dev_list, bond_list)
+		if (strnicmp(bond->dev->name, name, IFNAMSIZ) == 0) {
+			printk(KERN_ERR DRV_NAME
+			       ": cannot add bond %s; it already exists\n",
+			       name);
+			res = -EPERM;
+			goto out_rtnl;
+		}
+
 	bond_dev = alloc_netdev(sizeof(struct bonding), name ? name : "",
 				ether_setup);
 	if (!bond_dev) {
@@ -4915,10 +4928,12 @@ int bond_create(char *name, struct bond_
 
 	netif_carrier_off(bond_dev);
 
+	up_write(&bonding_rwsem);
 	rtnl_unlock(); /* allows sysfs registration of net device */
 	res = bond_create_sysfs_entry(bond_dev->priv);
 	if (res < 0) {
 		rtnl_lock();
+		down_write(&bonding_rwsem);
 		goto out_bond;
 	}
 
@@ -4929,6 +4944,7 @@ out_bond:
 out_netdev:
 	free_netdev(bond_dev);
 out_rtnl:
+	up_write(&bonding_rwsem);
 	rtnl_unlock();
 	return res;
 }
@@ -4949,6 +4965,9 @@ static int __init bonding_init(void)
 #ifdef CONFIG_PROC_FS
 	bond_create_proc_dir();
 #endif
+
+	init_rwsem(&bonding_rwsem);
+
 	for (i = 0; i < max_bonds; i++) {
 		res = bond_create(NULL, &bonding_defaults, NULL);
 		if (res)
diff -puN drivers/net/bonding/bond_sysfs.c~bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem drivers/net/bonding/bond_sysfs.c
--- a/drivers/net/bonding/bond_sysfs.c~bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem
+++ a/drivers/net/bonding/bond_sysfs.c
@@ -109,11 +109,10 @@ static ssize_t bonding_store_bonds(struc
 {
 	char command[IFNAMSIZ + 1] = {0, };
 	char *ifname;
-	int res = count;
+	int rv, res = count;
 	struct bonding *bond;
 	struct bonding *nxt;
 
-	down_write(&(bonding_rwsem));
 	sscanf(buffer, "%16s", command); /* IFNAMSIZ*/
 	ifname = command + 1;
 	if ((strlen(command) <= 1) ||
@@ -121,39 +120,28 @@ static ssize_t bonding_store_bonds(struc
 		goto err_no_cmd;
 
 	if (command[0] == '+') {
-
-		/* Check to see if the bond already exists. */
-		list_for_each_entry_safe(bond, nxt, &bond_dev_list, bond_list)
-			if (strnicmp(bond->dev->name, ifname, IFNAMSIZ) == 0) {
-				printk(KERN_ERR DRV_NAME
-					": cannot add bond %s; it already exists\n",
-					ifname);
-				res = -EPERM;
-				goto out;
-			}
-
 		printk(KERN_INFO DRV_NAME
 			": %s is being created...\n", ifname);
-		if (bond_create(ifname, &bonding_defaults, &bond)) {
-			printk(KERN_INFO DRV_NAME
-			": %s interface already exists. Bond creation failed.\n",
-			ifname);
-			res = -EPERM;
+		rv = bond_create(ifname, &bonding_defaults, &bond);
+		if (rv) {
+			printk(KERN_INFO DRV_NAME ": Bond creation failed.\n");
+			res = rv;
 		}
 		goto out;
 	}
 
 	if (command[0] == '-') {
+		rtnl_lock();
+		down_write(&bonding_rwsem);
+
 		list_for_each_entry_safe(bond, nxt, &bond_dev_list, bond_list)
 			if (strnicmp(bond->dev->name, ifname, IFNAMSIZ) == 0) {
-				rtnl_lock();
 				/* check the ref count on the bond's kobject.
 				 * If it's > expected, then there's a file open,
 				 * and we have to fail.
 				 */
 				if (atomic_read(&bond->dev->dev.kobj.kref.refcount)
 							> expected_refcount){
-					rtnl_unlock();
 					printk(KERN_INFO DRV_NAME
 						": Unable remove bond %s due to open references.\n",
 						ifname);
@@ -164,6 +152,7 @@ static ssize_t bonding_store_bonds(struc
 					": %s is being deleted...\n",
 					bond->dev->name);
 				bond_destroy(bond);
+				up_write(&bonding_rwsem);
 				rtnl_unlock();
 				goto out;
 			}
@@ -171,6 +160,8 @@ static ssize_t bonding_store_bonds(struc
 		printk(KERN_ERR DRV_NAME
 			": unable to delete non-existent bond %s\n", ifname);
 		res = -ENODEV;
+		up_write(&bonding_rwsem);
+		rtnl_unlock();
 		goto out;
 	}
 
@@ -183,7 +174,6 @@ err_no_cmd:
 	 * get called forever, which is bad.
 	 */
 out:
-	up_write(&(bonding_rwsem));
 	return res;
 }
 /* class attribute for bond_masters file.  This ends up in /sys/class/net */
@@ -271,6 +261,9 @@ static ssize_t bonding_store_slaves(stru
 
 	/* Note:  We can't hold bond->lock here, as bond_create grabs it. */
 
+	rtnl_lock();
+	down_write(&(bonding_rwsem));
+
 	sscanf(buffer, "%16s", command); /* IFNAMSIZ*/
 	ifname = command + 1;
 	if ((strlen(command) <= 1) ||
@@ -336,12 +329,10 @@ static ssize_t bonding_store_slaves(stru
 				dev->mtu = bond->dev->mtu;
 			}
 		}
-		rtnl_lock();
 		res = bond_enslave(bond->dev, dev);
 		bond_for_each_slave(bond, slave, i)
 			if (strnicmp(slave->dev->name, ifname, IFNAMSIZ) == 0)
 				slave->original_mtu = original_mtu;
-		rtnl_unlock();
 		if (res) {
 			ret = res;
 		}
@@ -359,12 +350,10 @@ static ssize_t bonding_store_slaves(stru
 		if (dev) {
 			printk(KERN_INFO DRV_NAME ": %s: Removing slave %s\n",
 				bond->dev->name, dev->name);
-			rtnl_lock();
 			if (bond->setup_by_slave)
 				res = bond_release_and_destroy(bond->dev, dev);
 			else
 				res = bond_release(bond->dev, dev);
-			rtnl_unlock();
 			if (res) {
 				ret = res;
 				goto out;
@@ -389,6 +378,8 @@ err_no_cmd:
 	ret = -EPERM;
 
 out:
+	up_write(&(bonding_rwsem));
+	rtnl_unlock();
 	return ret;
 }
 
@@ -1423,8 +1414,6 @@ int bond_create_sysfs(void)
 	int ret = 0;
 	struct bonding *firstbond;
 
-	init_rwsem(&bonding_rwsem);
-
 	/* get the netdev class pointer */
 	firstbond = container_of(bond_dev_list.next, struct bonding, bond_list);
 	if (!firstbond)
_

Patches currently in -mm which might be from fubar@us.ibm.com are

git-netdev-all.patch
bonding-fix-locking-in-sysfs-primary-active-selection.patch
bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch
bonding-fix-locking-during-alb-failover-and-slave-removal.patch
bonding-release-slaves-when-master-removed-via-sysfs.patch
bonding-fix-up-parameter-parsing.patch
bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem.patch
bonding-dont-hold-lock-when-calling-rtnl_unlock.patch
