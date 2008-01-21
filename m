From: akpm@linux-foundation.org
Subject: - bonding-release-slaves-when-master-removed-via-sysfs.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:23 -0800
Message-ID: <200801212314.m0LNEN6g024992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763337AbYAUXYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fubar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     bonding: release slaves when master removed via sysfs
has been removed from the -mm tree.  Its filename was
     bonding-release-slaves-when-master-removed-via-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bonding: release slaves when master removed via sysfs
From: Jay Vosburgh <fubar@us.ibm.com>

Add a call to bond_release_all in the bonding netdev event handler for the
master.  This releases the slaves for the case of, e.g., "echo -bond0 >
/sys/class/net/bonding_masters", which otherwise will spin forever waiting for
references to be released.

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/bonding/bond_main.c~bonding-release-slaves-when-master-removed-via-sysfs drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c~bonding-release-slaves-when-master-removed-via-sysfs
+++ a/drivers/net/bonding/bond_main.c
@@ -3401,9 +3401,7 @@ static int bond_master_netdev_event(unsi
 	case NETDEV_CHANGENAME:
 		return bond_event_changename(event_bond);
 	case NETDEV_UNREGISTER:
-		/*
-		 * TODO: remove a bond from the list?
-		 */
+		bond_release_all(event_bond->dev);
 		break;
 	default:
 		break;
_

Patches currently in -mm which might be from fubar@us.ibm.com are

origin.patch
git-net.patch
