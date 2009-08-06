From: akpm@linux-foundation.org
Subject: [to-be-updated] cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:27:41 -0700
Message-ID: <200908062327.n76NRfEw010010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848AbZHFX1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew.patterson@hp.com, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: use mutex instead of flag to indicate busy initializing
has been removed from the -mm tree.  Its filename was
     cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: use mutex instead of flag to indicate busy initializing
From: Andrew Patterson <andrew.patterson@hp.com>

Convert busy_initializing from simple integer flag to mutex, so we can use
it to block and thus avoid some race conditions.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    9 +++++----
 drivers/block/cciss.h |    2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN drivers/block/cciss.c~cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing
+++ a/drivers/block/cciss.c
@@ -751,7 +751,7 @@ static int cciss_open(struct block_devic
 	printk(KERN_DEBUG "cciss_open %s\n", bdev->bd_disk->disk_name);
 #endif				/* CCISS_DEBUG */
 
-	if (host->busy_initializing || drv->busy_configuring)
+	if (mutex_is_locked(&host->busy_initializing) || drv->busy_configuring)
 		return -EBUSY;
 	/*
 	 * Root is allowed to open raw volume zero even if it's not configured
@@ -3915,7 +3915,8 @@ static int __devinit cciss_init_one(stru
 	if (i < 0)
 		return -1;
 
-	hba[i]->busy_initializing = 1;
+	mutex_init(&hba[i]->busy_initializing);
+	mutex_lock(&hba[i]->busy_initializing);
 	INIT_HLIST_HEAD(&hba[i]->cmpQ);
 	INIT_HLIST_HEAD(&hba[i]->reqQ);
 
@@ -4034,7 +4035,7 @@ static int __devinit cciss_init_one(stru
 
 	hba[i]->cciss_max_sectors = 2048;
 
-	hba[i]->busy_initializing = 0;
+	mutex_unlock(&hba[i]->busy_initializing);
 
 	rebuild_lun_table(hba[i], 1);
 	hba[i]->cciss_scan_thread = kthread_run(scan_thread, hba[i],
@@ -4062,7 +4063,7 @@ clean2:
 clean1:
 	cciss_destroy_hba_sysfs_entry(hba[i]);
 clean0:
-	hba[i]->busy_initializing = 0;
+	mutex_unlock(&hba[i]->busy_initializing);
 	/* cleanup any queues that may have been initialized */
 	for (j=0; j <= hba[i]->highest_lun; j++){
 		drive_info_struct *drv = &(hba[i]->drv[j]);
diff -puN drivers/block/cciss.h~cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing drivers/block/cciss.h
--- a/drivers/block/cciss.h~cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing
+++ a/drivers/block/cciss.h
@@ -107,7 +107,7 @@ struct ctlr_info 
 	int			nr_allocs;
 	int			nr_frees; 
 	int			busy_configuring;
-	int			busy_initializing;
+	struct mutex		busy_initializing;
 
 	/* This element holds the zero based queue number of the last
 	 * queue to be started.  It is used for fairness.
_

Patches currently in -mm which might be from andrew.patterson@hp.com are

origin.patch
cciss-use-mutex-instead-of-flag-to-indicate-busy-initializing.patch
cciss-use-only-one-scan-thread.patch
cciss-kick-off-logical-drive-topology-rescan-through-sysfs.patch

