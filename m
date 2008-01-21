From: akpm@linux-foundation.org
Subject: - bonding-fix-locking-during-alb-failover-and-slave-removal.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:20 -0800
Message-ID: <200801212314.m0LNEKXN024989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761366AbYAUXTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fubar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     bonding: fix locking during alb failover and slave removal
has been removed from the -mm tree.  Its filename was
     bonding-fix-locking-during-alb-failover-and-slave-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bonding: fix locking during alb failover and slave removal
From: Jay Vosburgh <fubar@us.ibm.com>

alb_fasten_mac_swap (actually rlb_teach_disabled_mac_on_primary) requries RTNL
and no other locks.  This could cause dev_set_promiscuity and/or
dev_set_mac_address to be called with improper locking.

Changed callers to hold only RTNL during calls to alb_fasten_mac_swap or
functions calling it.  Updated header comments in affected functions to
reflect proper reality of locking requirements.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_alb.c  |   18 ++++++++++++------
 drivers/net/bonding/bond_main.c |   14 ++++++++------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff -puN drivers/net/bonding/bond_alb.c~bonding-fix-locking-during-alb-failover-and-slave-removal drivers/net/bonding/bond_alb.c
--- a/drivers/net/bonding/bond_alb.c~bonding-fix-locking-during-alb-failover-and-slave-removal
+++ a/drivers/net/bonding/bond_alb.c
@@ -979,7 +979,7 @@ static void alb_swap_mac_addr(struct bon
 /*
  * Send learning packets after MAC address swap.
  *
- * Called with RTNL and bond->lock held for read.
+ * Called with RTNL and no other locks
  */
 static void alb_fasten_mac_swap(struct bonding *bond, struct slave *slave1,
 				struct slave *slave2)
@@ -987,6 +987,8 @@ static void alb_fasten_mac_swap(struct b
 	int slaves_state_differ = (SLAVE_IS_OK(slave1) != SLAVE_IS_OK(slave2));
 	struct slave *disabled_slave = NULL;
 
+	ASSERT_RTNL();
+
 	/* fasten the change in the switch */
 	if (SLAVE_IS_OK(slave1)) {
 		alb_send_learning_packets(slave1, slave1->dev->dev_addr);
@@ -1031,7 +1033,7 @@ static void alb_fasten_mac_swap(struct b
  * a slave that has @slave's permanet address as its current address.
  * We'll make sure that that slave no longer uses @slave's permanent address.
  *
- * Caller must hold bond lock
+ * Caller must hold RTNL and no other locks
  */
 static void alb_change_hw_addr_on_detach(struct bonding *bond, struct slave *slave)
 {
@@ -1542,7 +1544,12 @@ int bond_alb_init_slave(struct bonding *
 	return 0;
 }
 
-/* Caller must hold bond lock for write */
+/*
+ * Remove slave from tlb and rlb hash tables, and fix up MAC addresses
+ * if necessary.
+ *
+ * Caller must hold RTNL and no other locks
+ */
 void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave)
 {
 	if (bond->slave_cnt > 1) {
@@ -1658,12 +1665,11 @@ void bond_alb_handle_active_change(struc
 				       bond->alb_info.rlb_enabled);
 	}
 
-	read_lock(&bond->lock);
-
 	if (swap_slave) {
 		alb_fasten_mac_swap(bond, swap_slave, new_slave);
+		read_lock(&bond->lock);
 	} else {
-		/* fasten bond mac on new current slave */
+		read_lock(&bond->lock);
 		alb_send_learning_packets(new_slave, bond->dev->dev_addr);
 	}
 
diff -puN drivers/net/bonding/bond_main.c~bonding-fix-locking-during-alb-failover-and-slave-removal drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-fix-locking-during-alb-failover-and-slave-removal
+++ a/drivers/net/bonding/bond_main.c
@@ -1746,7 +1746,9 @@ int bond_release(struct net_device *bond
 		 * has been cleared (if our_slave == old_current),
 		 * but before a new active slave is selected.
 		 */
+		write_unlock_bh(&bond->lock);
 		bond_alb_deinit_slave(bond, slave);
+		write_lock_bh(&bond->lock);
 	}
 
 	if (oldcurrent == slave) {
@@ -1905,6 +1907,12 @@ static int bond_release_all(struct net_d
 		slave_dev = slave->dev;
 		bond_detach_slave(bond, slave);
 
+		/* now that the slave is detached, unlock and perform
+		 * all the undo steps that should not be called from
+		 * within a lock.
+		 */
+		write_unlock_bh(&bond->lock);
+
 		if ((bond->params.mode == BOND_MODE_TLB) ||
 		    (bond->params.mode == BOND_MODE_ALB)) {
 			/* must be called only after the slave
@@ -1915,12 +1923,6 @@ static int bond_release_all(struct net_d
 
 		bond_compute_features(bond);
 
-		/* now that the slave is detached, unlock and perform
-		 * all the undo steps that should not be called from
-		 * within a lock.
-		 */
-		write_unlock_bh(&bond->lock);
-
 		bond_destroy_slave_symlinks(bond_dev, slave_dev);
 		bond_del_vlans_from_slave(bond, slave_dev);
 
_

Patches currently in -mm which might be from fubar@us.ibm.com are

origin.patch
git-net.patch
