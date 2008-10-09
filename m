From: akpm@linux-foundation.org
Subject: - cxgb3-fix-race-in-eeh.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:17 -0700
Message-ID: <200810092228.m99MSHZi006058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbYJIW2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, mm-commits@vger.kernel.org


The patch titled
     cxgb3: fix race in EEH
has been removed from the -mm tree.  Its filename was
     cxgb3-fix-race-in-eeh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cxgb3: fix race in EEH
From: Divy Le Ray <divy@chelsio.com>

A SGE queue set timer might access registers while in EEH recovery,
triggering an EEH error loop.  Stop all timers early in EEH process.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/adapter.h    |    1 +
 drivers/net/cxgb3/cxgb3_main.c |    5 +++++
 drivers/net/cxgb3/sge.c        |   21 ++++++++++++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

diff -puN drivers/net/cxgb3/adapter.h~cxgb3-fix-race-in-eeh drivers/net/cxgb3/adapter.h
--- a/drivers/net/cxgb3/adapter.h~cxgb3-fix-race-in-eeh
+++ a/drivers/net/cxgb3/adapter.h
@@ -284,6 +284,7 @@ void t3_os_link_changed(struct adapter *
 
 void t3_sge_start(struct adapter *adap);
 void t3_sge_stop(struct adapter *adap);
+void t3_stop_sge_timers(struct adapter *adap);
 void t3_free_sge_resources(struct adapter *adap);
 void t3_sge_err_intr_handler(struct adapter *adapter);
 irq_handler_t t3_intr_handler(struct adapter *adap, int polling);
diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-fix-race-in-eeh drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-fix-race-in-eeh
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -479,6 +479,7 @@ static int setup_sge_qsets(struct adapte
 							     irq_idx,
 				&adap->params.sge.qset[qset_idx], ntxq, dev);
 			if (err) {
+				t3_stop_sge_timers(adap);
 				t3_free_sge_resources(adap);
 				return err;
 			}
@@ -2449,6 +2450,9 @@ static pci_ers_result_t t3_io_error_dete
 	    test_bit(OFFLOAD_DEVMAP_BIT, &adapter->open_device_map))
 		offload_close(&adapter->tdev);
 
+	/* Stop SGE timers */
+	t3_stop_sge_timers(adapter);
+
 	adapter->flags &= ~FULL_INIT_DONE;
 
 	pci_disable_device(pdev);
@@ -2801,6 +2805,7 @@ static void __devexit remove_one(struct 
 		    if (test_bit(i, &adapter->registered_device_map))
 			unregister_netdev(adapter->port[i]);
 
+		t3_stop_sge_timers(adapter);
 		t3_free_sge_resources(adapter);
 		cxgb_disable_msi(adapter);
 
diff -puN drivers/net/cxgb3/sge.c~cxgb3-fix-race-in-eeh drivers/net/cxgb3/sge.c
--- a/drivers/net/cxgb3/sge.c~cxgb3-fix-race-in-eeh
+++ a/drivers/net/cxgb3/sge.c
@@ -603,9 +603,6 @@ static void t3_free_qset(struct adapter 
 	int i;
 	struct pci_dev *pdev = adapter->pdev;
 
-	if (q->tx_reclaim_timer.function)
-		del_timer_sync(&q->tx_reclaim_timer);
-
 	for (i = 0; i < SGE_RXQ_PER_SET; ++i)
 		if (q->fl[i].desc) {
 			spin_lock_irq(&adapter->sge.reg_lock);
@@ -3009,6 +3006,24 @@ err:
 }
 
 /**
+ *	t3_stop_sge_timers - stop SGE timer call backs
+ *	@adap: the adapter
+ *
+ *	Stops each SGE queue set's timer call back
+ */
+void t3_stop_sge_timers(struct adapter *adap)
+{
+	int i;
+
+	for (i = 0; i < SGE_QSETS; ++i) {
+		struct sge_qset *q = &adap->sge.qs[i];
+
+		if (q->tx_reclaim_timer.function)
+			del_timer_sync(&q->tx_reclaim_timer);
+	}
+}
+
+/**
  *	t3_free_sge_resources - free SGE resources
  *	@adap: the adapter
  *
_

Patches currently in -mm which might be from divy@chelsio.com are

git-net.patch

