From: akpm@linux-foundation.org
Subject: + bonding-fix-sysfs-attribute-handling.patch added to -mm tree
Date: Sat, 22 Mar 2008 17:26:05 -0700
Message-ID: <200803230026.m2N0Q55t000697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbYCWA0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Mar 2008 20:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lpechacek@suse.cz, davem@davemloft.net, fubar@us.ibm.com


The patch titled
     bonding: fix sysfs attribute handling
has been added to the -mm tree.  Its filename is
     bonding-fix-sysfs-attribute-handling.patch

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
Subject: bonding: fix sysfs attribute handling
From: Libor Pechacek <lpechacek@suse.cz>

For bonding interfaces any attempt to read the sysfs directory contents after
module removal results in an oops.  The fix is to release sysfs attributes for
the interfaces upon module unload.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
Cc: Jay Vosburgh <fubar@us.ibm.com
Cc: "David S. Miller" <davem@davemloft.net>
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

bonding-fix-sysfs-attribute-handling.patch

