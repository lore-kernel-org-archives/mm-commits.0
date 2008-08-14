From: akpm@linux-foundation.org
Subject: - e1000e-increase-minimum-frame-size-allowed.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:34 -0700
Message-ID: <200808142354.m7ENsYnO003950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbYHNXyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000e: increase minimum frame size allowed
has been removed from the -mm tree.  Its filename was
     e1000e-increase-minimum-frame-size-allowed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: e1000e: increase minimum frame size allowed
From: Bruce Allan <bruce.w.allan@intel.com>

Setting an MTU value below 68 was disabling the network connection and
would not reconnect until the driver was reloaded.  Prevent changing the
MTU to anything below 68.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000e/netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/e1000e/netdev.c~e1000e-increase-minimum-frame-size-allowed drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~e1000e-increase-minimum-frame-size-allowed
+++ a/drivers/net/e1000e/netdev.c
@@ -3724,7 +3724,7 @@ static int e1000_change_mtu(struct net_d
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
 
-	if ((max_frame < ETH_ZLEN + ETH_FCS_LEN) ||
+	if ((new_mtu < ETH_ZLEN + ETH_FCS_LEN + VLAN_HLEN) ||
 	    (max_frame > MAX_JUMBO_FRAME_SIZE)) {
 		e_err("Invalid MTU setting\n");
 		return -EINVAL;
_

Patches currently in -mm which might be from bruce.w.allan@intel.com are

git-net.patch
e1000e-remove-inapplicable-test-for-ioport-checkpatch-fixes.patch

