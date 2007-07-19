From: akpm@linux-foundation.org
Subject: - drivers-edac-change-from-semaphore-to-mutex-operation.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:27 -0700
Message-ID: <200707192005.l6JK5RwZ020047@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760834AbXGSUP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: change from semaphore to mutex operation
has been removed from the -mm tree.  Its filename was
     drivers-edac-change-from-semaphore-to-mutex-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: change from semaphore to mutex operation
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

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
