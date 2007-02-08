From: akpm@linux-foundation.org
Subject: - bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:20 -0800
Message-ID: <200702082152.l18LqKsF027636@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423453AbXBHVwX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkmaillist@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bonding: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
has been removed from the -mm tree.  Its filename was
     bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bonding: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
From: "Joe Jin" <lkmaillist@gmail.com>

Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls in
the bonding driver.

Signed-off-by: Joe Jin <lkmaillist@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_alb.c  |    4 +---
 drivers/net/bonding/bond_main.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/net/bonding/bond_alb.c~bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls drivers/net/bonding/bond_alb.c
--- a/drivers/net/bonding/bond_alb.c~bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls
+++ a/drivers/net/bonding/bond_alb.c
@@ -184,7 +184,7 @@ static int tlb_initialize(struct bonding
 
 	spin_lock_init(&(bond_info->tx_hashtbl_lock));
 
-	new_hashtbl = kmalloc(size, GFP_KERNEL);
+	new_hashtbl = kzalloc(size, GFP_KERNEL);
 	if (!new_hashtbl) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Error: Failed to allocate TLB hash table\n",
@@ -195,8 +195,6 @@ static int tlb_initialize(struct bonding
 
 	bond_info->tx_hashtbl = new_hashtbl;
 
-	memset(bond_info->tx_hashtbl, 0, size);
-
 	for (i = 0; i < TLB_HASH_TABLE_SIZE; i++) {
 		tlb_init_table_entry(&bond_info->tx_hashtbl[i], 1);
 	}
diff -puN drivers/net/bonding/bond_main.c~bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls
+++ a/drivers/net/bonding/bond_main.c
@@ -1343,14 +1343,12 @@ int bond_enslave(struct net_device *bond
 			"inaccurate.\n", bond_dev->name, slave_dev->name);
 	}
 
-	new_slave = kmalloc(sizeof(struct slave), GFP_KERNEL);
+	new_slave = kzalloc(sizeof(struct slave), GFP_KERNEL);
 	if (!new_slave) {
 		res = -ENOMEM;
 		goto err_undo_flags;
 	}
 
-	memset(new_slave, 0, sizeof(struct slave));
-
 	/* save slave's original flags before calling
 	 * netdev_set_master and dev_open
 	 */
_

Patches currently in -mm which might be from lkmaillist@gmail.com are

git-net.patch
