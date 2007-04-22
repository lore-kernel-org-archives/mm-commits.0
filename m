From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm.patch added to -mm tree
Date: Sat, 21 Apr 2007 19:15:41 -0700
Message-ID: <200704220215.l3M2FfwX017692@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753989AbXDVCPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 22:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     use mutex instead of binary semaphore in FORE Systems 200E-series driver for ATM
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of binary semaphore in FORE Systems 200E-series driver for ATM
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

(akpm: remove CVS control string too)

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/fore200e.c |   20 +++++++++-----------
 drivers/atm/fore200e.h |    2 +-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/atm/fore200e.c~use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm drivers/atm/fore200e.c
--- a/drivers/atm/fore200e.c~use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm
+++ a/drivers/atm/fore200e.c
@@ -1,6 +1,4 @@
 /*
-  $Id: fore200e.c,v 1.5 2000/04/14 10:10:34 davem Exp $
-
   A FORE Systems 200E-series driver for ATM on Linux.
   Christophe Lizzi (lizzi@cnam.fr), October 1999-March 2003.
 
@@ -1502,9 +1500,9 @@ fore200e_open(struct atm_vcc *vcc)
     /* pseudo-CBR bandwidth requested? */
     if ((vcc->qos.txtp.traffic_class == ATM_CBR) && (vcc->qos.txtp.max_pcr > 0)) {
 	
-	down(&fore200e->rate_sf);
+	mutex_lock(&fore200e->rate_mtx);
 	if (fore200e->available_cell_rate < vcc->qos.txtp.max_pcr) {
-	    up(&fore200e->rate_sf);
+	    mutex_unlock(&fore200e->rate_mtx);
 
 	    kfree(fore200e_vcc);
 	    vc_map->vcc = NULL;
@@ -1513,7 +1511,7 @@ fore200e_open(struct atm_vcc *vcc)
 
 	/* reserve bandwidth */
 	fore200e->available_cell_rate -= vcc->qos.txtp.max_pcr;
-	up(&fore200e->rate_sf);
+	mutex_unlock(&fore200e->rate_mtx);
     }
     
     vcc->itf = vcc->dev->number;
@@ -1599,9 +1597,9 @@ fore200e_close(struct atm_vcc* vcc)
     /* release reserved bandwidth, if any */
     if ((vcc->qos.txtp.traffic_class == ATM_CBR) && (vcc->qos.txtp.max_pcr > 0)) {
 
-	down(&fore200e->rate_sf);
+	mutex_lock(&fore200e->rate_mtx);
 	fore200e->available_cell_rate += vcc->qos.txtp.max_pcr;
-	up(&fore200e->rate_sf);
+	mutex_unlock(&fore200e->rate_mtx);
 
 	clear_bit(ATM_VF_HASQOS, &vcc->flags);
     }
@@ -2064,16 +2062,16 @@ fore200e_change_qos(struct atm_vcc* vcc,
 
     if ((qos->txtp.traffic_class == ATM_CBR) && (qos->txtp.max_pcr > 0)) {
 
-	down(&fore200e->rate_sf);
+	mutex_lock(&fore200e->rate_mtx);
 	if (fore200e->available_cell_rate + vcc->qos.txtp.max_pcr < qos->txtp.max_pcr) {
-	    up(&fore200e->rate_sf);
+	    mutex_unlock(&fore200e->rate_mtx);
 	    return -EAGAIN;
 	}
 
 	fore200e->available_cell_rate += vcc->qos.txtp.max_pcr;
 	fore200e->available_cell_rate -= qos->txtp.max_pcr;
 
-	up(&fore200e->rate_sf);
+	mutex_unlock(&fore200e->rate_mtx);
 	
 	memcpy(&vcc->qos, qos, sizeof(struct atm_qos));
 	
@@ -2459,7 +2457,7 @@ fore200e_initialize(struct fore200e* for
 
     DPRINTK(2, "device %s being initialized\n", fore200e->name);
 
-    init_MUTEX(&fore200e->rate_sf);
+    mutex_init(&fore200e->rate_mtx);
     spin_lock_init(&fore200e->q_lock);
 
     cpq = fore200e->cp_queues = fore200e->virt_base + FORE200E_CP_QUEUES_OFFSET;
diff -puN drivers/atm/fore200e.h~use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm drivers/atm/fore200e.h
--- a/drivers/atm/fore200e.h~use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm
+++ a/drivers/atm/fore200e.h
@@ -869,7 +869,7 @@ typedef struct fore200e {
 
     struct stats*              stats;                  /* last snapshot of the stats         */
     
-    struct semaphore           rate_sf;                /* protects rate reservation ops      */
+    struct mutex               rate_mtx;               /* protects rate reservation ops      */
     spinlock_t                 q_lock;                 /* protects queue ops                 */
 #ifdef FORE200E_USE_TASKLET
     struct tasklet_struct      tx_tasklet;             /* performs tx interrupt work         */
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
use-mutex-instead-of-binary-semaphore-in-fore-systems-200e-series-driver-for-atm.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
fix-spinlock-usage-in-hysdn_log_close.patch
