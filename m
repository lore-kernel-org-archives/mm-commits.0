From: akpm@linux-foundation.org
Subject: + qlogic-infinipath-convert-ipath_eep_sem-to-mutex.patch added to -mm tree
Date: Thu, 15 Nov 2007 15:23:25 -0800
Message-ID: <200711152323.lAFNNPHi021209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKOXXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:23:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, Michael.Albaugh@qlogic.com, arthur.jones@qlogic.com, rdreier@cisco.com


The patch titled
     QLogic InfiniPath: convert ipath_eep_sem to mutex
has been added to the -mm tree.  Its filename is
     qlogic-infinipath-convert-ipath_eep_sem-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: QLogic InfiniPath: convert ipath_eep_sem to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

QLogic InfiniPath: convert the semaphore ipath_eep_sem to the mutex
API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>
Acked-by: Michael Albaugh <Michael.Albaugh@qlogic.com>
Tested-by: Arthur Jones <arthur.jones@qlogic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_eeprom.c    |   20 ++++++++--------
 drivers/infiniband/hw/ipath/ipath_init_chip.c |    2 -
 drivers/infiniband/hw/ipath/ipath_kernel.h    |    3 +-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/infiniband/hw/ipath/ipath_eeprom.c~qlogic-infinipath-convert-ipath_eep_sem-to-mutex drivers/infiniband/hw/ipath/ipath_eeprom.c
--- a/drivers/infiniband/hw/ipath/ipath_eeprom.c~qlogic-infinipath-convert-ipath_eep_sem-to-mutex
+++ a/drivers/infiniband/hw/ipath/ipath_eeprom.c
@@ -510,10 +510,10 @@ int ipath_eeprom_read(struct ipath_devda
 {
 	int ret;
 
-	ret = down_interruptible(&dd->ipath_eep_sem);
+	ret = mutex_lock_interruptible(&dd->ipath_eep_lock);
 	if (!ret) {
 		ret = ipath_eeprom_internal_read(dd, eeprom_offset, buff, len);
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 	}
 
 	return ret;
@@ -524,10 +524,10 @@ int ipath_eeprom_write(struct ipath_devd
 {
 	int ret;
 
-	ret = down_interruptible(&dd->ipath_eep_sem);
+	ret = mutex_lock_interruptible(&dd->ipath_eep_lock);
 	if (!ret) {
 		ret = ipath_eeprom_internal_write(dd, eeprom_offset, buff, len);
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 	}
 
 	return ret;
@@ -616,9 +616,9 @@ void ipath_get_eeprom_info(struct ipath_
 		goto bail;
 	}
 
-	down(&dd->ipath_eep_sem);
+	mutex_lock(&dd->ipath_eep_lock);
 	eep_stat = ipath_eeprom_internal_read(dd, 0, buf, len);
-	up(&dd->ipath_eep_sem);
+	mutex_unlock(&dd->ipath_eep_lock);
 
 	if (eep_stat) {
 		ipath_dev_err(dd, "Failed reading GUID from eeprom\n");
@@ -764,14 +764,14 @@ int ipath_update_eeprom_log(struct ipath
 	/* Grab semaphore and read current EEPROM. If we get an
 	 * error, let go, but if not, keep it until we finish write.
 	 */
-	ret = down_interruptible(&dd->ipath_eep_sem);
+	ret = mutex_lock_interruptible(&dd->ipath_eep_lock);
 	if (ret) {
 		ipath_dev_err(dd, "Unable to acquire EEPROM for logging\n");
 		goto free_bail;
 	}
 	ret = ipath_eeprom_internal_read(dd, 0, buf, len);
 	if (ret) {
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 		ipath_dev_err(dd, "Unable read EEPROM for logging\n");
 		goto free_bail;
 	}
@@ -779,7 +779,7 @@ int ipath_update_eeprom_log(struct ipath
 
 	csum = flash_csum(ifp, 0);
 	if (csum != ifp->if_csum) {
-		up(&dd->ipath_eep_sem);
+		mutex_unlock(&dd->ipath_eep_lock);
 		ipath_dev_err(dd, "EEPROM cks err (0x%02X, S/B 0x%02X)\n",
 				csum, ifp->if_csum);
 		ret = 1;
@@ -849,7 +849,7 @@ int ipath_update_eeprom_log(struct ipath
 		csum = flash_csum(ifp, 1);
 		ret = ipath_eeprom_internal_write(dd, 0, buf, hi_water + 1);
 	}
-	up(&dd->ipath_eep_sem);
+	mutex_unlock(&dd->ipath_eep_lock);
 	if (ret)
 		ipath_dev_err(dd, "Failed updating EEPROM\n");
 
diff -puN drivers/infiniband/hw/ipath/ipath_init_chip.c~qlogic-infinipath-convert-ipath_eep_sem-to-mutex drivers/infiniband/hw/ipath/ipath_init_chip.c
--- a/drivers/infiniband/hw/ipath/ipath_init_chip.c~qlogic-infinipath-convert-ipath_eep_sem-to-mutex
+++ a/drivers/infiniband/hw/ipath/ipath_init_chip.c
@@ -348,7 +348,7 @@ static int init_chip_first(struct ipath_
 
 	spin_lock_init(&dd->ipath_gpio_lock);
 	spin_lock_init(&dd->ipath_eep_st_lock);
-	sema_init(&dd->ipath_eep_sem, 1);
+	mutex_init(&dd->ipath_eep_lock);
 
 done:
 	*pdp = pd;
diff -puN drivers/infiniband/hw/ipath/ipath_kernel.h~qlogic-infinipath-convert-ipath_eep_sem-to-mutex drivers/infiniband/hw/ipath/ipath_kernel.h
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h~qlogic-infinipath-convert-ipath_eep_sem-to-mutex
+++ a/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -41,6 +41,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <rdma/ib_verbs.h>
 
@@ -616,7 +617,7 @@ struct ipath_devdata {
 	/* control access to actual counters, timer */
 	spinlock_t ipath_eep_st_lock;
 	/* control high-level access to EEPROM */
-	struct semaphore ipath_eep_sem;
+	struct mutex ipath_eep_lock;
 	/* Below inc'd by ipath_snap_cntrs(), locked by ipath_eep_st_lock */
 	uint64_t ipath_traffic_wds;
 	/* active time is kept in seconds, but logged in hours */
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
git-dvb.patch
qlogic-infinipath-convert-ipath_eep_sem-to-mutex.patch
git-netdev-all.patch
megaraid-sas-convert-aen_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
