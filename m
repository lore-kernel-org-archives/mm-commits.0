From: akpm@linux-foundation.org
Subject: + bonding-release-slaves-when-master-removed-via-sysfs.patch added to -mm tree
Date: Thu, 17 Jan 2008 16:40:44 -0800
Message-ID: <200801180040.m0I0eiFc022614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758113AbYARAlS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 19:41:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fubar@us.ibm.com


The patch titled
     bonding: release slaves when master removed via sysfs
has been added to the -mm tree.  Its filename is
     bonding-release-slaves-when-master-removed-via-sysfs.patch

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

git-netdev-all.patch
bonding-fix-locking-in-sysfs-primary-active-selection.patch
bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch
bonding-fix-locking-during-alb-failover-and-slave-removal.patch
bonding-release-slaves-when-master-removed-via-sysfs.patch
bonding-fix-up-parameter-parsing.patch
bonding-fix-lock-ordering-for-rtnl-and-bonding_rwsem.patch
bonding-dont-hold-lock-when-calling-rtnl_unlock.patch
