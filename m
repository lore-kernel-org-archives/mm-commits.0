From: akpm@linux-foundation.org
Subject: - bonding-fix-sysfs-attribute-handling.patch removed from -mm tree
Date: Thu, 27 Mar 2008 15:45:49 -0700
Message-ID: <200803272245.m2RMjneF025721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbYC0Wqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 18:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lpechacek@suse.cz, davem@davemloft.net, fubar@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     bonding: fix sysfs attribute handling
has been removed from the -mm tree.  Its filename was
     bonding-fix-sysfs-attribute-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bonding: fix sysfs attribute handling
From: Libor Pechacek <lpechacek@suse.cz>

For bonding interfaces any attempt to read the sysfs directory contents after
module removal results in an oops.  The fix is to release sysfs attributes for
the interfaces upon module unload.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Acked-by: Jay Vosburgh <fubar@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/bonding/bond_main.c~bonding-fix-sysfs-attribute-handling drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-fix-sysfs-attribute-handling
+++ a/drivers/net/bonding/bond_main.c
@@ -4528,8 +4528,7 @@ static void bond_free_all(void)
 		netif_tx_unlock_bh(bond_dev);
 		/* Release the bonded slaves */
 		bond_release_all(bond_dev);
-		bond_deinit(bond_dev);
-		unregister_netdevice(bond_dev);
+		bond_destroy(bond);
 	}
 
 #ifdef CONFIG_PROC_FS
_

Patches currently in -mm which might be from lpechacek@suse.cz are

origin.patch

