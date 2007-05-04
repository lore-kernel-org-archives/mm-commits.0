From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch added to -mm tree
Date: Thu, 03 May 2007 20:20:03 -0700
Message-ID: <200705040320.l443K32b028013@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754315AbXEDDU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:20:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, chas@cmf.nrl.navy.mil


The patch titled
     use mutex instead of binary semaphore in idt77252 driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of binary semaphore in idt77252 driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Use mutex instead of binary semaphore in idt77252 driver.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: chas williams <chas@cmf.nrl.navy.mil>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/idt77252.c |   24 ++++++++++++------------
 drivers/atm/idt77252.h |    2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/atm/idt77252.c~use-mutex-instead-of-binary-semaphore-in-idt77252-driver drivers/atm/idt77252.c
--- a/drivers/atm/idt77252.c~use-mutex-instead-of-binary-semaphore-in-idt77252-driver
+++ a/drivers/atm/idt77252.c
@@ -2435,7 +2435,7 @@ idt77252_open(struct atm_vcc *vcc)
 
 	set_bit(ATM_VF_ADDR, &vcc->flags);
 
-	down(&card->mutex);
+	mutex_lock(&card->mutex);
 
 	OPRINTK("%s: opening vpi.vci: %d.%d\n", card->name, vpi, vci);
 
@@ -2446,7 +2446,7 @@ idt77252_open(struct atm_vcc *vcc)
 		break;
 	default:
 		printk("%s: Unsupported AAL: %d\n", card->name, vcc->qos.aal);
-		up(&card->mutex);
+		mutex_unlock(&card->mutex);
 		return -EPROTONOSUPPORT;
 	}
 
@@ -2455,7 +2455,7 @@ idt77252_open(struct atm_vcc *vcc)
 		card->vcs[index] = kzalloc(sizeof(struct vc_map), GFP_KERNEL);
 		if (!card->vcs[index]) {
 			printk("%s: can't alloc vc in open()\n", card->name);
-			up(&card->mutex);
+			mutex_unlock(&card->mutex);
 			return -ENOMEM;
 		}
 		card->vcs[index]->card = card;
@@ -2484,14 +2484,14 @@ idt77252_open(struct atm_vcc *vcc)
 	if (inuse) {
 		printk("%s: %s vci already in use.\n", card->name,
 		       inuse == 1 ? "tx" : inuse == 2 ? "rx" : "tx and rx");
-		up(&card->mutex);
+		mutex_unlock(&card->mutex);
 		return -EADDRINUSE;
 	}
 
 	if (vcc->qos.txtp.traffic_class != ATM_NONE) {
 		error = idt77252_init_tx(card, vc, vcc, &vcc->qos);
 		if (error) {
-			up(&card->mutex);
+			mutex_unlock(&card->mutex);
 			return error;
 		}
 	}
@@ -2499,14 +2499,14 @@ idt77252_open(struct atm_vcc *vcc)
 	if (vcc->qos.rxtp.traffic_class != ATM_NONE) {
 		error = idt77252_init_rx(card, vc, vcc, &vcc->qos);
 		if (error) {
-			up(&card->mutex);
+			mutex_unlock(&card->mutex);
 			return error;
 		}
 	}
 
 	set_bit(ATM_VF_READY, &vcc->flags);
 
-	up(&card->mutex);
+	mutex_unlock(&card->mutex);
 	return 0;
 }
 
@@ -2520,7 +2520,7 @@ idt77252_close(struct atm_vcc *vcc)
 	unsigned long addr;
 	unsigned long timeout;
 
-	down(&card->mutex);
+	mutex_lock(&card->mutex);
 
 	IPRINTK("%s: idt77252_close: vc = %d (%d.%d)\n",
 		card->name, vc->index, vcc->vpi, vcc->vci);
@@ -2591,7 +2591,7 @@ done:
 		free_scq(card, vc->scq);
 	}
 
-	up(&card->mutex);
+	mutex_unlock(&card->mutex);
 }
 
 static int
@@ -2602,7 +2602,7 @@ idt77252_change_qos(struct atm_vcc *vcc,
 	struct vc_map *vc = vcc->dev_data;
 	int error = 0;
 
-	down(&card->mutex);
+	mutex_lock(&card->mutex);
 
 	if (qos->txtp.traffic_class != ATM_NONE) {
 	    	if (!test_bit(VCF_TX, &vc->flags)) {
@@ -2648,7 +2648,7 @@ idt77252_change_qos(struct atm_vcc *vcc,
 	set_bit(ATM_VF_HASQOS, &vcc->flags);
 
 out:
-	up(&card->mutex);
+	mutex_unlock(&card->mutex);
 	return error;
 }
 
@@ -3709,7 +3709,7 @@ idt77252_init_one(struct pci_dev *pcidev
 	membase = pci_resource_start(pcidev, 1);
 	srambase = pci_resource_start(pcidev, 2);
 
-	init_MUTEX(&card->mutex);
+	mutex_init(&card->mutex);
 	spin_lock_init(&card->cmd_lock);
 	spin_lock_init(&card->tst_lock);
 
diff -puN drivers/atm/idt77252.h~use-mutex-instead-of-binary-semaphore-in-idt77252-driver drivers/atm/idt77252.h
--- a/drivers/atm/idt77252.h~use-mutex-instead-of-binary-semaphore-in-idt77252-driver
+++ a/drivers/atm/idt77252.h
@@ -359,7 +359,7 @@ struct idt77252_dev
 	unsigned long		srambase;	/* SAR's sram  base address */
 	void __iomem		*fbq[4];	/* FBQ fill addresses */
 
-	struct semaphore	mutex;
+	struct mutex		mutex;
 	spinlock_t		cmd_lock;	/* for r/w utility/sram */
 
 	unsigned long		softstat;
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
