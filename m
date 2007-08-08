From: akpm@linux-foundation.org
Subject: + uli526x-add-suspend-and-resume-routines.patch added to -mm tree
Date: Wed, 08 Aug 2007 09:36:41 -0700
Message-ID: <200708081636.l78GafDn015053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756495AbXHHQhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 12:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, grundler@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     uli526x: add suspend and resume routines
has been added to the -mm tree.  Its filename is
     uli526x-add-suspend-and-resume-routines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uli526x: add suspend and resume routines
From: Rafael J. Wysocki <rjw@sisk.pl>

Add suspend/resume support to the uli526x network driver (tested on x86_64,
with "Ethernet controller: ALi Corporation M5263 Ethernet Controller, rev 40").

This patch is based on the suspend/resume code in the tg3 driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/uli526x.c |  109 ++++++++++++++++++++++++++++++++--
 1 file changed, 103 insertions(+), 6 deletions(-)

diff -puN drivers/net/tulip/uli526x.c~uli526x-add-suspend-and-resume-routines drivers/net/tulip/uli526x.c
--- a/drivers/net/tulip/uli526x.c~uli526x-add-suspend-and-resume-routines
+++ a/drivers/net/tulip/uli526x.c
@@ -1110,19 +1110,15 @@ static void uli526x_timer(unsigned long 
 
 
 /*
- *	Dynamic reset the ULI526X board
  *	Stop ULI526X board
  *	Free Tx/Rx allocated memory
- *	Reset ULI526X board
- *	Re-initialize ULI526X board
+ *	Init system variable
  */
 
-static void uli526x_dynamic_reset(struct net_device *dev)
+static void uli526x_reset_prepare(struct net_device *dev)
 {
 	struct uli526x_board_info *db = netdev_priv(dev);
 
-	ULI526X_DBUG(0, "uli526x_dynamic_reset()", 0);
-
 	/* Sopt MAC controller */
 	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);	/* Disable Tx/Rx */
 	update_cr6(db->cr6_data, dev->base_addr);
@@ -1141,6 +1137,22 @@ static void uli526x_dynamic_reset(struct
 	db->link_failed = 1;
 	db->init=1;
 	db->wait_reset = 0;
+}
+
+
+/*
+ *	Dynamic reset the ULI526X board
+ *	Stop ULI526X board
+ *	Free Tx/Rx allocated memory
+ *	Reset ULI526X board
+ *	Re-initialize ULI526X board
+ */
+
+static void uli526x_dynamic_reset(struct net_device *dev)
+{
+	ULI526X_DBUG(0, "uli526x_dynamic_reset()", 0);
+
+	uli526x_reset_prepare(dev);
 
 	/* Re-initialize ULI526X board */
 	uli526x_init(dev);
@@ -1150,6 +1162,89 @@ static void uli526x_dynamic_reset(struct
 }
 
 
+#ifdef CONFIG_PM_SLEEP
+
+/*
+ *	Suspend the interface.
+ */
+
+static int uli526x_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	pci_power_t power_state;
+	int err;
+
+	ULI526X_DBUG(0, "uli526x_suspend", 0);
+
+	if (!(dev && netdev_priv(dev)))
+		return 0;
+
+	pci_save_state(pdev);
+
+	if (!netif_running(dev))
+		return 0;
+
+	netif_device_detach(dev);
+	uli526x_reset_prepare(dev);
+
+	power_state = pci_choose_state(pdev, state);
+	pci_enable_wake(pdev, power_state, 0);
+	err = pci_set_power_state(pdev, power_state);
+	if (err) {
+		netif_device_attach(dev);
+		/* Re-initialize ULI526X board */
+		uli526x_init(dev);
+		/* Restart upper layer interface */
+		netif_wake_queue(dev);
+	}
+
+	return err;
+}
+
+/*
+ *	Resume the interface.
+ */
+
+static int uli526x_resume(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+	struct uli526x_board_info *db = netdev_priv(dev);
+	int err;
+
+	ULI526X_DBUG(0, "uli526x_resume", 0);
+
+	if (!(dev && db))
+		return 0;
+
+	pci_restore_state(pdev);
+
+	if (!netif_running(dev))
+		return 0;
+
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err) {
+		printk(KERN_WARNING "%s: Could not put device into D0\n",
+			dev->name);
+		return err;
+	}
+
+	netif_device_attach(dev);
+	/* Re-initialize ULI526X board */
+	uli526x_init(dev);
+	/* Restart upper layer interface */
+	netif_wake_queue(dev);
+
+	return 0;
+}
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define uli526x_suspend	NULL
+#define uli526x_resume	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
+
 /*
  *	free all allocated rx buffer
  */
@@ -1689,6 +1784,8 @@ static struct pci_driver uli526x_driver 
 	.id_table	= uli526x_pci_tbl,
 	.probe		= uli526x_init_one,
 	.remove		= __devexit_p(uli526x_remove_one),
+	.suspend	= uli526x_suspend,
+	.resume		= uli526x_resume,
 };
 
 MODULE_AUTHOR("Peer Chen, peer.chen@uli.com.tw");
_

Patches currently in -mm which might be from rjw@sisk.pl are

hibernation-do-not-try-to-mark-invalid-pfns-as-nosave.patch
pm-fix-dependencies-of-config_suspend-and-config_hibernation-updated-2x.patch
uli526x-add-suspend-and-resume-routines.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
shrink_slab-handle-bad-shrinkers.patch
