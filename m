From: akpm@linux-foundation.org
Subject: - bonding-fix-locking-in-sysfs-primary-active-selection.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:15 -0800
Message-ID: <200801212314.m0LNEFDK024963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761109AbYAUXTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fubar@us.ibm.com, andy@greyhouse.net, mm-commits@vger.kernel.org


The patch titled
     bonding: fix locking in sysfs primary/active selection
has been removed from the -mm tree.  Its filename was
     bonding-fix-locking-in-sysfs-primary-active-selection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bonding: fix locking in sysfs primary/active selection
From: Jay Vosburgh <fubar@us.ibm.com>

Fix the functions that store the primary and active slave options via sysfs to
hold the correct locks in the correct order.

The bond_change_active_slave and bond_select_active_slave functions both
require rtnl, bond->lock for read and curr_slave_lock for write_bh, and no
other locks.  This is so that the lower level mode-specific functions (notably
for balance-alb mode) can release locks down to just rtnl in order to call,
e.g., dev_set_mac_address with the locks it expects (rtnl only).

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_sysfs.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/net/bonding/bond_sysfs.c~bonding-fix-locking-in-sysfs-primary-active-selection drivers/net/bonding/bond_sysfs.c
--- a/drivers/net/bonding/bond_sysfs.c~bonding-fix-locking-in-sysfs-primary-active-selection
+++ a/drivers/net/bonding/bond_sysfs.c
@@ -1075,7 +1075,10 @@ static ssize_t bonding_store_primary(str
 	struct slave *slave;
 	struct bonding *bond = to_bond(d);
 
-	write_lock_bh(&bond->lock);
+	rtnl_lock();
+	read_lock(&bond->lock);
+	write_lock_bh(&bond->curr_slave_lock);
+
 	if (!USES_PRIMARY(bond->params.mode)) {
 		printk(KERN_INFO DRV_NAME
 		       ": %s: Unable to set primary slave; %s is in mode %d\n",
@@ -1109,8 +1112,8 @@ static ssize_t bonding_store_primary(str
 		}
 	}
 out:
-	write_unlock_bh(&bond->lock);
-
+	write_unlock_bh(&bond->curr_slave_lock);
+	read_unlock(&bond->lock);
 	rtnl_unlock();
 
 	return count;
@@ -1190,7 +1193,8 @@ static ssize_t bonding_store_active_slav
 	struct bonding *bond = to_bond(d);
 
 	rtnl_lock();
-	write_lock_bh(&bond->lock);
+	read_lock(&bond->lock);
+	write_lock_bh(&bond->curr_slave_lock);
 
 	if (!USES_PRIMARY(bond->params.mode)) {
 		printk(KERN_INFO DRV_NAME
@@ -1247,7 +1251,8 @@ static ssize_t bonding_store_active_slav
 		}
 	}
 out:
-	write_unlock_bh(&bond->lock);
+	write_unlock_bh(&bond->curr_slave_lock);
+	read_unlock(&bond->lock);
 	rtnl_unlock();
 
 	return count;
_

Patches currently in -mm which might be from fubar@us.ibm.com are

origin.patch
git-net.patch
