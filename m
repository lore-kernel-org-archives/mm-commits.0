From: akpm@linux-foundation.org
Subject: + bonding-fix-locking-in-sysfs-primary-active-selection.patch added to -mm tree
Date: Thu, 17 Jan 2008 16:40:38 -0800
Message-ID: <200801180040.m0I0ec9V022605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36735 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040AbYARAlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 19:41:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fubar@us.ibm.com, andy@greyhouse.net


The patch titled
     bonding: fix locking in sysfs primary/active selection
has been added to the -mm tree.  Its filename is
     bonding-fix-locking-in-sysfs-primary-active-selection.patch

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

git-netdev-all.patch
bonding-fix-locking-in-sysfs-primary-active-selection.patch
bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch
bonding-fix-locking-during-alb-failover-and-slave-removal.patch
bonding-release-slaves-when-master-removed-via-sysfs.patch
bonding-fix-up-parameter-parsing.patch
bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem.patch
bonding-dont-hold-lock-when-calling-rtnl_unlock.patch
