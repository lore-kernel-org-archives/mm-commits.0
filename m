From: akpm@linux-foundation.org
Subject: + forcedeth-msi-bugfix.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:13:21 -0700
Message-ID: <200710172113.l9HLDLsv008611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757409AbXJQVNs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:13:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, aabdulla@nvidia.com, jeff@garzik.org, stable@kernel.org


The patch titled
     forcedeth msi bugfix
has been added to the -mm tree.  Its filename is
     forcedeth-msi-bugfix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth msi bugfix
From: Manfred Spraul <manfred@colorfullife.com>

pci_enable_msi() replaces the INTx irq number in pci_dev->irq with the new
MSI irq number.

The forcedeth driver did not update the copy in netdevice->irq and parts of
the driver used the stale copy.  See bugzilla.kernel.org, bug 9047.

The patch
- updates netdevice->irq
- replaces all accesses to netdevice->irq with pci_dev->irq.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-msi-bugfix drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-msi-bugfix
+++ a/drivers/net/forcedeth.c
@@ -128,7 +128,7 @@
 #else
 #define DRIVERNAPI
 #endif
-#define FORCEDETH_VERSION		"0.60"
+#define FORCEDETH_VERSION		"0.61"
 #define DRV_NAME			"forcedeth"
 
 #include <linux/module.h>
@@ -993,7 +993,7 @@ static void nv_enable_irq(struct net_dev
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq(dev->irq);
+			enable_irq(np->pci_dev->irq);
 	} else {
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_TX].vector);
@@ -1009,7 +1009,7 @@ static void nv_disable_irq(struct net_de
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq(dev->irq);
+			disable_irq(np->pci_dev->irq);
 	} else {
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_TX].vector);
@@ -1607,7 +1607,7 @@ static void nv_do_rx_refill(unsigned lon
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq(dev->irq);
+			disable_irq(np->pci_dev->irq);
 	} else {
 		disable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 	}
@@ -1625,7 +1625,7 @@ static void nv_do_rx_refill(unsigned lon
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq(dev->irq);
+			enable_irq(np->pci_dev->irq);
 	} else {
 		enable_irq(np->msi_x_entry[NV_MSI_X_VECTOR_RX].vector);
 	}
@@ -3556,10 +3556,12 @@ static int nv_request_irq(struct net_dev
 	if (ret != 0 && np->msi_flags & NV_MSI_CAPABLE) {
 		if ((ret = pci_enable_msi(np->pci_dev)) == 0) {
 			np->msi_flags |= NV_MSI_ENABLED;
+			dev->irq = np->pci_dev->irq;
 			if (request_irq(np->pci_dev->irq, handler, IRQF_SHARED, dev->name, dev) != 0) {
 				printk(KERN_INFO "forcedeth: request_irq failed %d\n", ret);
 				pci_disable_msi(np->pci_dev);
 				np->msi_flags &= ~NV_MSI_ENABLED;
+				dev->irq = np->pci_dev->irq;
 				goto out_err;
 			}
 
@@ -3622,7 +3624,7 @@ static void nv_do_nic_poll(unsigned long
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			disable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			disable_irq_lockdep(dev->irq);
+			disable_irq_lockdep(np->pci_dev->irq);
 		mask = np->irqmask;
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
@@ -3640,6 +3642,8 @@ static void nv_do_nic_poll(unsigned long
 	}
 	np->nic_poll_irq = 0;
 
+	/* disable_irq() contains synchronize_irq, thus no irq handler can run now */
+
 	if (np->recover_error) {
 		np->recover_error = 0;
 		printk(KERN_INFO "forcedeth: MAC in recoverable error state\n");
@@ -3676,7 +3680,6 @@ static void nv_do_nic_poll(unsigned long
 		}
 	}
 
-	/* FIXME: Do we need synchronize_irq(dev->irq) here? */
 
 	writel(mask, base + NvRegIrqMask);
 	pci_push(base);
@@ -3689,7 +3692,7 @@ static void nv_do_nic_poll(unsigned long
 		if (np->msi_flags & NV_MSI_X_ENABLED)
 			enable_irq_lockdep(np->msi_x_entry[NV_MSI_X_VECTOR_ALL].vector);
 		else
-			enable_irq_lockdep(dev->irq);
+			enable_irq_lockdep(np->pci_dev->irq);
 	} else {
 		if (np->nic_poll_irq & NVREG_IRQ_RX_ALL) {
 			nv_nic_irq_rx(0, dev);
@@ -4950,7 +4953,7 @@ static int nv_close(struct net_device *d
 #ifdef CONFIG_FORCEDETH_NAPI
 	napi_disable(&np->napi);
 #endif
-	synchronize_irq(dev->irq);
+	synchronize_irq(np->pci_dev->irq);
 
 	del_timer_sync(&np->oom_kick);
 	del_timer_sync(&np->nic_poll);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
forcedeth-msi-bugfix.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch
