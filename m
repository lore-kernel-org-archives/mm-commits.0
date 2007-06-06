From: akpm@linux-foundation.org
Subject: + drivers-edac-change-from-semaphore-to-mutex-operation.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:50:38 -0700
Message-ID: <200706060150.l561ocpS007440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933534AbXFFBuu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:50:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, dougthompson@xmission.com


The patch titled
     drivers-edac: change from semaphore to mutex operation
has been added to the -mm tree.  Its filename is
     drivers-edac-change-from-semaphore-to-mutex-operation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: change from semaphore to mutex operation
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The EDAC core code uses a semaphore as mutex. use the mutex API
instead of the (binary) semaphore.

Matthaias wrote this, but since I had some patches ahead of it,
I need to modify it to follow my patches.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/edac/edac_mc.c~drivers-edac-change-from-semaphore-to-mutex-operation drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-change-from-semaphore-to-mutex-operation
+++ a/drivers/edac/edac_mc.c
@@ -35,7 +35,7 @@
 
 
 /* lock to memory controller's control array */
-static DECLARE_MUTEX(mem_ctls_mutex);
+static DEFINE_MUTEX(mem_ctls_mutex);
 static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
 
 #ifdef CONFIG_EDAC_DEBUG
@@ -334,7 +334,7 @@ int edac_mc_add_mc(struct mem_ctl_info *
 		}
 	}
 #endif
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	if (add_mc_to_global_list(mci))
 		goto fail0;
@@ -352,14 +352,14 @@ int edac_mc_add_mc(struct mem_ctl_info *
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
 		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
 
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	return 0;
 
 fail1:
 	del_mc_from_global_list(mci);
 
 fail0:
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	return 1;
 }
 EXPORT_SYMBOL_GPL(edac_mc_add_mc);
@@ -376,16 +376,16 @@ struct mem_ctl_info * edac_mc_del_mc(str
 	struct mem_ctl_info *mci;
 
 	debugf0("MC: %s()\n", __func__);
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	if ((mci = find_mci_by_dev(dev)) == NULL) {
-		up(&mem_ctls_mutex);
+		mutex_unlock(&mem_ctls_mutex);
 		return NULL;
 	}
 
 	edac_remove_sysfs_mci_device(mci);
 	del_mc_from_global_list(mci);
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
 		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
@@ -722,7 +722,7 @@ void edac_check_mc_devices(void)
 	struct mem_ctl_info *mci;
 
 	debugf3("%s()\n", __func__);
-	down(&mem_ctls_mutex);
+	mutex_lock(&mem_ctls_mutex);
 
 	list_for_each(item, &mc_devices) {
 		mci = list_entry(item, struct mem_ctl_info, link);
@@ -731,5 +731,5 @@ void edac_check_mc_devices(void)
 			mci->edac_check(mci);
 	}
 
-	up(&mem_ctls_mutex);
+	mutex_unlock(&mem_ctls_mutex);
 }
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

kcopyd-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
git-netdev-all.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
