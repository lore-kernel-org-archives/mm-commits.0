From: akpm@linux-foundation.org
Subject: - r8169-rtnl-and-flush_scheduled_work-deadlock.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:10:15 -0800
Message-ID: <200702202010.l1KKAFvC018275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46935 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030397AbXBTUKY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:10:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     r8169: RTNL and flush_scheduled_work deadlock
has been removed from the -mm tree.  Its filename was
     r8169-rtnl-and-flush_scheduled_work-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: r8169: RTNL and flush_scheduled_work deadlock
From: Francois Romieu <romieu@fr.zoreil.com>

flush_scheduled_work() in net_device->close has a slight tendency to deadlock
with tasks on the workqueue that hold RTNL.

rtl8169_close/down simply need the recovery tasks to not meddle with the
hardware while the device is going down.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/r8169.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/net/r8169.c~r8169-rtnl-and-flush_scheduled_work-deadlock drivers/net/r8169.c
--- a/drivers/net/r8169.c~r8169-rtnl-and-flush_scheduled_work-deadlock
+++ a/drivers/net/r8169.c
@@ -1733,6 +1733,8 @@ rtl8169_remove_one(struct pci_dev *pdev)
 	assert(dev != NULL);
 	assert(tp != NULL);
 
+	flush_scheduled_work();
+
 	unregister_netdev(dev);
 	rtl8169_release_board(pdev, dev, tp->mmio_addr);
 	pci_set_drvdata(pdev, NULL);
@@ -2161,10 +2163,13 @@ static void rtl8169_reinit_task(struct w
 	struct net_device *dev = tp->dev;
 	int ret;
 
-	if (netif_running(dev)) {
-		rtl8169_wait_for_quiescence(dev);
-		rtl8169_close(dev);
-	}
+	rtnl_lock();
+
+	if (!netif_running(dev))
+		goto out_unlock;
+
+	rtl8169_wait_for_quiescence(dev);
+	rtl8169_close(dev);
 
 	ret = rtl8169_open(dev);
 	if (unlikely(ret < 0)) {
@@ -2179,6 +2184,9 @@ static void rtl8169_reinit_task(struct w
 		}
 		rtl8169_schedule_work(dev, rtl8169_reinit_task);
 	}
+
+out_unlock:
+	rtnl_unlock();
 }
 
 static void rtl8169_reset_task(struct work_struct *work)
@@ -2187,8 +2195,10 @@ static void rtl8169_reset_task(struct wo
 		container_of(work, struct rtl8169_private, task.work);
 	struct net_device *dev = tp->dev;
 
+	rtnl_lock();
+
 	if (!netif_running(dev))
-		return;
+		goto out_unlock;
 
 	rtl8169_wait_for_quiescence(dev);
 
@@ -2210,6 +2220,9 @@ static void rtl8169_reset_task(struct wo
 		}
 		rtl8169_schedule_work(dev, rtl8169_reset_task);
 	}
+
+out_unlock:
+	rtnl_unlock();
 }
 
 static void rtl8169_tx_timeout(struct net_device *dev)
@@ -2722,8 +2735,6 @@ static void rtl8169_down(struct net_devi
 
 	netif_stop_queue(dev);
 
-	flush_scheduled_work();
-
 core_down:
 	spin_lock_irq(&tp->lock);
 
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
