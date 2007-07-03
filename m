From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver.patch added to -mm tree
Date: Tue, 03 Jul 2007 14:24:09 -0700
Message-ID: <200707032124.l63LO9wV016556@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757840AbXGCVYT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 17:24:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, samuel@sortiz.org


The patch titled
     use mutex instead of semaphore in VLSI 82C147 IrDA controller driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in VLSI 82C147 IrDA controller driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The VLSI 82C147 IrDA controller driver uses a semaphore as mutex.  Use the
mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/vlsi_ir.c |   27 ++++++++++++++-------------
 drivers/net/irda/vlsi_ir.h |    2 +-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/net/irda/vlsi_ir.c~use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver drivers/net/irda/vlsi_ir.c
--- a/drivers/net/irda/vlsi_ir.c~use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver
+++ a/drivers/net/irda/vlsi_ir.c
@@ -44,6 +44,7 @@ MODULE_LICENSE("GPL");
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
@@ -1660,8 +1661,8 @@ vlsi_irda_probe(struct pci_dev *pdev, co
 	idev = ndev->priv;
 
 	spin_lock_init(&idev->lock);
-	init_MUTEX(&idev->sem);
-	down(&idev->sem);
+	mutex_init(&idev->mtx);
+	mutex_lock(&idev->mtx);
 	idev->pdev = pdev;
 
 	if (vlsi_irda_init(ndev) < 0)
@@ -1689,12 +1690,12 @@ vlsi_irda_probe(struct pci_dev *pdev, co
 	IRDA_MESSAGE("%s: registered device %s\n", drivername, ndev->name);
 
 	pci_set_drvdata(pdev, ndev);
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 
 	return 0;
 
 out_freedev:
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 	free_netdev(ndev);
 out_disable:
 	pci_disable_device(pdev);
@@ -1716,12 +1717,12 @@ static void __devexit vlsi_irda_remove(s
 	unregister_netdev(ndev);
 
 	idev = ndev->priv;
-	down(&idev->sem);
+	mutex_lock(&idev->mtx);
 	if (idev->proc_entry) {
 		remove_proc_entry(ndev->name, vlsi_proc_root);
 		idev->proc_entry = NULL;
 	}
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 
 	free_netdev(ndev);
 
@@ -1751,7 +1752,7 @@ static int vlsi_irda_suspend(struct pci_
 		return 0;
 	}
 	idev = ndev->priv;	
-	down(&idev->sem);
+	mutex_lock(&idev->mtx);
 	if (pdev->current_state != 0) {			/* already suspended */
 		if (state.event > pdev->current_state) {	/* simply go deeper */
 			pci_set_power_state(pdev, pci_choose_state(pdev, state));
@@ -1759,7 +1760,7 @@ static int vlsi_irda_suspend(struct pci_
 		}
 		else
 			IRDA_ERROR("%s - %s: invalid suspend request %u -> %u\n", __FUNCTION__, pci_name(pdev), pdev->current_state, state.event);
-		up(&idev->sem);
+		mutex_unlock(&idev->mtx);
 		return 0;
 	}
 
@@ -1775,7 +1776,7 @@ static int vlsi_irda_suspend(struct pci_
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	pdev->current_state = state.event;
 	idev->resume_ok = 1;
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 	return 0;
 }
 
@@ -1790,9 +1791,9 @@ static int vlsi_irda_resume(struct pci_d
 		return 0;
 	}
 	idev = ndev->priv;	
-	down(&idev->sem);
+	mutex_lock(&idev->mtx);
 	if (pdev->current_state == 0) {
-		up(&idev->sem);
+		mutex_unlock(&idev->mtx);
 		IRDA_WARNING("%s - %s: already resumed\n",
 			     __FUNCTION__, pci_name(pdev));
 		return 0;
@@ -1814,7 +1815,7 @@ static int vlsi_irda_resume(struct pci_d
 		 * device and independently resume_ok should catch any garbage config.
 		 */
 		IRDA_WARNING("%s - hm, nothing to resume?\n", __FUNCTION__);
-		up(&idev->sem);
+		mutex_unlock(&idev->mtx);
 		return 0;
 	}
 
@@ -1824,7 +1825,7 @@ static int vlsi_irda_resume(struct pci_d
 		netif_device_attach(ndev);
 	}
 	idev->resume_ok = 0;
-	up(&idev->sem);
+	mutex_unlock(&idev->mtx);
 	return 0;
 }
 
diff -puN drivers/net/irda/vlsi_ir.h~use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver drivers/net/irda/vlsi_ir.h
--- a/drivers/net/irda/vlsi_ir.h~use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver
+++ a/drivers/net/irda/vlsi_ir.h
@@ -728,7 +728,7 @@ typedef struct vlsi_irda_dev {
 	struct timeval		last_rx;
 
 	spinlock_t		lock;
-	struct semaphore	sem;
+	struct mutex		mtx;
 
 	u8			resume_ok;	
 	struct proc_dir_entry	*proc_entry;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
git-netdev-all.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
use-mutex-instead-of-semaphore-in-philips-webcam-driver.patch
use-mutex-instead-of-semaphore-in-virtual-video-driver.patch
use-mutex-instead-of-semaphore-in-vlsi-82c147-irda-controller-driver.patch
