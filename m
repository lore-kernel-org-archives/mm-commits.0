From: akpm@linux-foundation.org
Subject: + bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch added to -mm tree
Date: Thu, 17 Jan 2008 16:40:40 -0800
Message-ID: <200801180040.m0I0eeaa022608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42364 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597AbYARAlq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 19:41:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fubar@us.ibm.com


The patch titled
     bonding: fix ASSERT_RTNL that produces spurious warnings
has been added to the -mm tree.  Its filename is
     bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch

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
Subject: bonding: fix ASSERT_RTNL that produces spurious warnings
From: Jay Vosburgh <fubar@us.ibm.com>

Move an ASSERT_RTNL down to where we should hold only RTNL; the existing check
produces spurious warnings because we hold additional locks at _bh, tripping a
debug warning in spin_lock_mutex().

Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/bonding/bond_alb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/net/bonding/bond_alb.c~bonding-fix-assert_rtnl-that-produces-spurious-warnings drivers/net/bonding/bond_alb.c
--- a/drivers/net/bonding/bond_alb.c~bonding-fix-assert_rtnl-that-produces-spurious-warnings
+++ a/drivers/net/bonding/bond_alb.c
@@ -1601,9 +1601,6 @@ void bond_alb_handle_active_change(struc
 	struct slave *swap_slave;
 	int i;
 
-	if (new_slave)
-		ASSERT_RTNL();
-
 	if (bond->curr_active_slave == new_slave) {
 		return;
 	}
@@ -1649,6 +1646,8 @@ void bond_alb_handle_active_change(struc
 	write_unlock_bh(&bond->curr_slave_lock);
 	read_unlock(&bond->lock);
 
+	ASSERT_RTNL();
+
 	/* curr_active_slave must be set before calling alb_swap_mac_addr */
 	if (swap_slave) {
 		/* swap mac address */
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
