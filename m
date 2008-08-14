From: akpm@linux-foundation.org
Subject: - e1000e-increase-tx-timeout-factor-for-10mbps.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:32 -0700
Message-ID: <200808142354.m7ENsW2M003947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbYHNXye (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: increase Tx timeout factor for 10Mbps
has been removed from the -mm tree.  Its filename was
     e1000e-increase-tx-timeout-factor-for-10mbps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: increase Tx timeout factor for 10Mbps
From: Bruce Allan <bruce.w.allan@intel.com>

Prevent Tx hangs from happening on 10Mb flood ping by increasing the
timeout factor.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-increase-tx-timeout-factor-for-10mbps drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-increase-tx-timeout-factor-for-10mbps
+++ a/drivers/net/e1000e/netdev.c
@@ -3058,7 +3058,7 @@ static void e1000_watchdog_task(struct w
 			case SPEED_10:
 				txb2b = 0;
 				netdev->tx_queue_len = 10;
-				adapter->tx_timeout_factor = 14;
+				adapter->tx_timeout_factor = 16;
 				break;
 			case SPEED_100:
 				txb2b = 0;
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

git-net.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch

