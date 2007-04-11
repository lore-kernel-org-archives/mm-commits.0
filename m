From: akpm@linux-foundation.org
Subject: - cxgb3-avoid-deadlock-with-mac-watchdog.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:21:12 -0700
Message-ID: <200704112321.l3BNLCpo017554@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35894 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161357AbXDKXVX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:21:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     cxgb3: avoid deadlock with mac watchdog
has been removed from the -mm tree.  Its filename was
     cxgb3-avoid-deadlock-with-mac-watchdog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxgb3: avoid deadlock with mac watchdog
From: Divy Le Ray <divy@chelsio.com>

Fix a deadlock when the interface s configured down and the watchdog task is
sleeping on rtnl_lock.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-avoid-deadlock-with-mac-watchdog drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-avoid-deadlock-with-mac-watchdog
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -2119,7 +2119,9 @@ static void check_t3b2_mac(struct adapte
 {
 	int i;
 
-	rtnl_lock();                      /* synchronize with ifdown */
+	if (!rtnl_trylock())	/* synchronize with ifdown */
+		return;
+
 	for_each_port(adapter, i) {
 		struct net_device *dev = adapter->port[i];
 		struct port_info *p = netdev_priv(dev);
_

Patches currently in -mm which might be from divy@chelsio.com are

git-netdev-all.patch
