From: akpm@linux-foundation.org
Subject: + user-of-the-jiffies-rounding-code-e1000.patch added to -mm tree
Date: Mon, 05 Feb 2007 18:12:41 -0800
Message-ID: <200702060212.l162CfCV007611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965444AbXBFCMv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 21:12:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, auke-jan.h.kok@intel.com, jeff@garzik.org


The patch titled
     user of the jiffies rounding code: e1000
has been added to the -mm tree.  Its filename is
     user-of-the-jiffies-rounding-code-e1000.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: user of the jiffies rounding code: e1000
From: Arjan van de Ven <arjan@linux.intel.com>

Use the round_jiffies() function in e1000.

These timers all were of the "about once a second" or "about once every X
seconds" variety and several showed up in the "what wakes the cpu up" profiles
that the tickless patches provide.  Some timers are highly dynamic based on
network load; but even on low activity systems they still show up so the
rounding is done only in cases of low activity, allowing higher frequency
timers in the high activity case.

The various hardware watchdogs are an obvious case; they run every 2 seconds
but aren't otherwise specific of exactly when they need to run.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~user-of-the-jiffies-rounding-code-e1000 drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~user-of-the-jiffies-rounding-code-e1000
+++ a/drivers/net/e1000/e1000_main.c
@@ -2652,7 +2652,7 @@ e1000_watchdog(unsigned long data)
 
 			netif_carrier_on(netdev);
 			netif_wake_queue(netdev);
-			mod_timer(&adapter->phy_info_timer, jiffies + 2 * HZ);
+			mod_timer(&adapter->phy_info_timer, round_jiffies(jiffies + 2 * HZ));
 			adapter->smartspeed = 0;
 		} else {
 			/* make sure the receive unit is started */
@@ -2669,7 +2669,7 @@ e1000_watchdog(unsigned long data)
 			DPRINTK(LINK, INFO, "NIC Link is Down\n");
 			netif_carrier_off(netdev);
 			netif_stop_queue(netdev);
-			mod_timer(&adapter->phy_info_timer, jiffies + 2 * HZ);
+			mod_timer(&adapter->phy_info_timer, round_jiffies(jiffies + 2 * HZ));
 
 			/* 80003ES2LAN workaround--
 			 * For packet buffer work-around on link down event;
@@ -2721,7 +2721,7 @@ e1000_watchdog(unsigned long data)
 		e1000_rar_set(&adapter->hw, adapter->hw.mac_addr, 0);
 
 	/* Reset the timer */
-	mod_timer(&adapter->watchdog_timer, jiffies + 2 * HZ);
+	mod_timer(&adapter->watchdog_timer, round_jiffies(jiffies + 2 * HZ));
 }
 
 enum latency_range {
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-libata-all.patch
git-netdev-all.patch
user-of-the-jiffies-rounding-code-networking.patch
mark-struct-file_operations-const-1.patch
mark-struct-file_operations-const-2.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-3.patch
mark-struct-file_operations-const-4.patch
mark-struct-file_operations-const-4-fix.patch
mark-struct-file_operations-const-5.patch
mark-struct-file_operations-const-6.patch
mark-struct-file_operations-const-7.patch
mark-struct-file_operations-const-8.patch
mark-struct-file_operations-const-9.patch
mark-struct-inode_operations-const-1.patch
mark-struct-inode_operations-const-2.patch
mark-struct-inode_operations-const-3.patch
