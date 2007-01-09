From: akpm@osdl.org
Subject: + bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:04:46 -0800
Message-ID: <200701092104.l09L4kuM015260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43982 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbXAIVEu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:04:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkmaillist@gmail.com


The patch titled
     bonding: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
has been added to the -mm tree.  Its filename is
     bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bonding: Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls
From: "Joe Jin" <lkmaillist@gmail.com>

Replace kmalloc() + memset() pairs with the appropriate kzalloc() calls in
the bonding driver.

Signed-off-by: Joe Jin <lkmaillist@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/bonding/bond_alb.c  |    6 ++----
 drivers/net/bonding/bond_main.c |    4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

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
@@ -788,7 +786,7 @@ static int rlb_initialize(struct bonding
 
 	spin_lock_init(&(bond_info->rx_hashtbl_lock));
 
-	new_hashtbl = kmalloc(size, GFP_KERNEL);
+	new_hashtbl = kzalloc(size, GFP_KERNEL);
 	if (!new_hashtbl) {
 		printk(KERN_ERR DRV_NAME
 		       ": %s: Error: Failed to allocate RLB hash table\n",
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

bonding-replace-kmalloc-memset-pairs-with-the-appropriate-kzalloc-calls.patch
