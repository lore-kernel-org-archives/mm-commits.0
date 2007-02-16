From: akpm@linux-foundation.org
Subject: + s2io-rtnl-and-flush_scheduled_work-deadlock.patch added to -mm tree
Date: Thu, 15 Feb 2007 17:20:43 -0800
Message-ID: <200702160120.l1G1KhCK015325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbXBPBUq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 20:20:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com


The patch titled
     s2io: RTNL and flush_scheduled_work deadlock
has been added to the -mm tree.  Its filename is
     s2io-rtnl-and-flush_scheduled_work-deadlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: s2io: RTNL and flush_scheduled_work deadlock
From: Francois Romieu <romieu@fr.zoreil.com>

Mantra: don't use flush_scheduled_work with RTNL held.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/s2io.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff -puN drivers/net/s2io.c~s2io-rtnl-and-flush_scheduled_work-deadlock drivers/net/s2io.c
--- a/drivers/net/s2io.c~s2io-rtnl-and-flush_scheduled_work-deadlock
+++ a/drivers/net/s2io.c
@@ -3758,7 +3758,6 @@ static int s2io_close(struct net_device 
 {
 	struct s2io_nic *sp = dev->priv;
 
-	flush_scheduled_work();
 	netif_stop_queue(dev);
 	/* Reset card, kill tasklet and free Tx and Rx buffers. */
 	s2io_card_down(sp);
@@ -5847,9 +5846,14 @@ static void s2io_set_link(struct work_st
 	register u64 val64;
 	u16 subid;
 
+	rtnl_lock();
+
+	if (!netif_running(dev))
+		goto out_unlock;
+
 	if (test_and_set_bit(0, &(nic->link_state))) {
 		/* The card is being reset, no point doing anything */
-		return;
+		goto out_unlock;
 	}
 
 	subid = nic->pdev->subsystem_device;
@@ -5903,6 +5907,9 @@ static void s2io_set_link(struct work_st
 		s2io_link(nic, LINK_DOWN);
 	}
 	clear_bit(0, &(nic->link_state));
+
+out_unlock:
+	rtnl_lock();
 }
 
 static int set_rxd_buffer_pointer(struct s2io_nic *sp, struct RxD_t *rxdp,
@@ -6356,6 +6363,11 @@ static void s2io_restart_nic(struct work
 	struct s2io_nic *sp = container_of(work, struct s2io_nic, rst_timer_task);
 	struct net_device *dev = sp->dev;
 
+	rtnl_lock();
+
+	if (!netif_running(dev))
+		goto out_unlock;
+
 	s2io_card_down(sp);
 	if (s2io_card_up(sp)) {
 		DBG_PRINT(ERR_DBG, "%s: Device bring up failed\n",
@@ -6364,7 +6376,8 @@ static void s2io_restart_nic(struct work
 	netif_wake_queue(dev);
 	DBG_PRINT(ERR_DBG, "%s: was reset by Tx watchdog timer\n",
 		  dev->name);
-
+out_unlock:
+	rtnl_unlock();
 }
 
 /**
@@ -7173,6 +7186,8 @@ static void __devexit s2io_rem_nic(struc
 		return;
 	}
 
+	flush_scheduled_work();
+
 	sp = dev->priv;
 	unregister_netdev(dev);
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
r8169-rtnl-and-flush_scheduled_work-deadlock.patch
sis190-rtnl-and-flush_scheduled_work-deadlock.patch
8139too-rtnl-and-flush_scheduled_work-deadlock.patch
s2io-rtnl-and-flush_scheduled_work-deadlock.patch
