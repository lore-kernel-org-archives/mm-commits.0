From: akpm@linux-foundation.org
Subject: - e1000e-return-1-instead-of-a-non-zero-value-for-link-up-indication.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:26 -0700
Message-ID: <200808142354.m7ENsQVL003938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYHNXy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: return 1 instead of a non-zero value for link up indication
has been removed from the -mm tree.  Its filename was
     e1000e-return-1-instead-of-a-non-zero-value-for-link-up-indication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: return 1 instead of a non-zero value for link up indication
From: Bruce Allan <bruce.w.allan@intel.com>

A number of users have mentioned they have tools that rely on a link-up
indication having a return value of 1 rather than a non-zero value.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/ethtool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e1000e/ethtool.c~e1000e-return-1-instead-of-a-non-zero-value-for-link-up-indication drivers/net/e1000e/ethtool.c
--- a/drivers/net/e1000e/ethtool.c~e1000e-return-1-instead-of-a-non-zero-value-for-link-up-indication
+++ a/drivers/net/e1000e/ethtool.c
@@ -177,7 +177,7 @@ static u32 e1000_get_link(struct net_dev
 	u32 status;
 	
 	status = er32(STATUS);
-	return (status & E1000_STATUS_LU);
+	return (status & E1000_STATUS_LU) ? 1 : 0;
 }
 
 static int e1000_set_spd_dplx(struct e1000_adapter *adapter, u16 spddplx)
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

git-net.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch

