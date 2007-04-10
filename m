From: akpm@linux-foundation.org
Subject: + cxgb3-avoid-deadlock-with-mac-watchdog.patch added to -mm tree
Date: Tue, 10 Apr 2007 14:40:49 -0700
Message-ID: <200704102140.l3ALenMO018167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46989 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbXDJVlF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 17:41:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: avoid deadlock with mac watchdog
has been added to the -mm tree.  Its filename is
     cxgb3-avoid-deadlock-with-mac-watchdog.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cxgb3-avoid-deadlock-with-mac-watchdog.patch
cxgb3-mac-watchdog-update.patch
cxgb3-missing-cpl-handler-and-register-setting.patch
