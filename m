From: akpm@linux-foundation.org
Subject: - bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:18 -0800
Message-ID: <200801212314.m0LNEINv024966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35798 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760610AbYAUXTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fubar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     bonding: fix ASSERT_RTNL that produces spurious warnings
has been removed from the -mm tree.  Its filename was
     bonding-fix-assert_rtnl-that-produces-spurious-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-net.patch
