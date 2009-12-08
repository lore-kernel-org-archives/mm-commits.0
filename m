From: akpm@linux-foundation.org
Subject: [folded] hpsa-rename-too-generic-variable-names.patch removed from -mm tree
Date: Tue, 08 Dec 2009 14:07:32 -0800
Message-ID: <200912082207.nB8M7Wuk003420@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966642AbZLHWH6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:07:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, James.Bottomley@HansenPartnership.com, achiang@hp.com, jens.axboe@oracle.com, mikem@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: rename too generic variable names
has been removed from the -mm tree.  Its filename was
     hpsa-rename-too-generic-variable-names.patch

This patch was dropped because it was folded into scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: rename too generic variable names
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Mike Miller <mikem@beardog.cce.hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |   50 ++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-rename-too-generic-variable-names drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-rename-too-generic-variable-names
+++ a/drivers/scsi/hpsa.c
@@ -196,9 +196,9 @@ static inline struct ctlr_info *sdev_to_
 }
 
 static struct task_struct *hpsa_scan_thread;
-static DEFINE_MUTEX(scan_mutex);
-static LIST_HEAD(scan_q);
-static int scan_thread(void *data);
+static DEFINE_MUTEX(hpsa_scan_mutex);
+static LIST_HEAD(hpsa_scan_q);
+static int hpsa_scan_func(void *data);
 
 /**
  * add_to_scan_list() - add controller to rescan queue
@@ -219,11 +219,15 @@ static int add_to_scan_list(struct ctlr_
 	if (h->busy_initializing)
 		return 0;
 
+	/*
+	 * If we don't get the lock, it means the driver is unloading
+	 * and there's no point in scheduling a new scan.
+	 */
 	if (!mutex_trylock(&h->busy_shutting_down))
 		return 0;
 
-	mutex_lock(&scan_mutex);
-	list_for_each_entry(test_h, &scan_q, scan_list) {
+	mutex_lock(&hpsa_scan_mutex);
+	list_for_each_entry(test_h, &hpsa_scan_q, scan_list) {
 		if (test_h == h) {
 			found = 1;
 			break;
@@ -231,10 +235,10 @@ static int add_to_scan_list(struct ctlr_
 	}
 	if (!found && !h->busy_scanning) {
 		INIT_COMPLETION(h->scan_wait);
-		list_add_tail(&h->scan_list, &scan_q);
+		list_add_tail(&h->scan_list, &hpsa_scan_q);
 		ret = 1;
 	}
-	mutex_unlock(&scan_mutex);
+	mutex_unlock(&hpsa_scan_mutex);
 	mutex_unlock(&h->busy_shutting_down);
 
 	return ret;
@@ -257,24 +261,24 @@ static void remove_from_scan_list(struct
 {
 	struct ctlr_info *test_h, *tmp_h;
 
-	mutex_lock(&scan_mutex);
-	list_for_each_entry_safe(test_h, tmp_h, &scan_q, scan_list) {
+	mutex_lock(&hpsa_scan_mutex);
+	list_for_each_entry_safe(test_h, tmp_h, &hpsa_scan_q, scan_list) {
 		if (test_h == h) { /* state 2. */
 			list_del(&h->scan_list);
 			complete_all(&h->scan_wait);
-			mutex_unlock(&scan_mutex);
+			mutex_unlock(&hpsa_scan_mutex);
 			return;
 		}
 	}
 	if (h->busy_scanning) { /* state 3. */
-		mutex_unlock(&scan_mutex);
+		mutex_unlock(&hpsa_scan_mutex);
 		wait_for_completion(&h->scan_wait);
 	} else { /* state 1, nothing to do. */
-		mutex_unlock(&scan_mutex);
+		mutex_unlock(&hpsa_scan_mutex);
 	}
 }
 
-/* scan_thread() - kernel thread used to rescan controllers
+/* hpsa_scan_func() - kernel thread used to rescan controllers
  * @data:	 Ignored.
  *
  * A kernel thread used scan for drive topology changes on
@@ -285,7 +289,7 @@ static void remove_from_scan_list(struct
  *
  * returns 0.
  **/
-static int scan_thread(__attribute__((unused)) void *data)
+static int hpsa_scan_func(__attribute__((unused)) void *data)
 {
 	struct ctlr_info *h;
 	int host_no;
@@ -297,22 +301,22 @@ static int scan_thread(__attribute__((un
 			break;
 
 		while (1) {
-			mutex_lock(&scan_mutex);
-			if (list_empty(&scan_q)) {
-				mutex_unlock(&scan_mutex);
+			mutex_lock(&hpsa_scan_mutex);
+			if (list_empty(&hpsa_scan_q)) {
+				mutex_unlock(&hpsa_scan_mutex);
 				break;
 			}
-			h = list_entry(scan_q.next, struct ctlr_info,
+			h = list_entry(hpsa_scan_q.next, struct ctlr_info,
 					scan_list);
 			list_del(&h->scan_list);
 			h->busy_scanning = 1;
-			mutex_unlock(&scan_mutex);
+			mutex_unlock(&hpsa_scan_mutex);
 			host_no = h->scsi_host ?  h->scsi_host->host_no : -1;
 			hpsa_update_scsi_devices(h, host_no);
 			complete_all(&h->scan_wait);
-			mutex_lock(&scan_mutex);
+			mutex_lock(&hpsa_scan_mutex);
 			h->busy_scanning = 0;
-			mutex_unlock(&scan_mutex);
+			mutex_unlock(&hpsa_scan_mutex);
 		}
 	}
 	return 0;
@@ -341,7 +345,7 @@ static int check_for_unit_attention(stru
 	 * except that it's quite likely that we will get more than one
 	 * REPORT_LUNS_CHANGED condition in quick succession, which means
 	 * that those which occur after the first one will likely happen
-	 * *during* the scan_thread's rescan.  And the rescan code is not
+	 * *during* the hpsa_scan_thread's rescan.  And the rescan code is not
 	 * robust enough to restart in the middle, undoing what it has already
 	 * done, and it's not clear that it's even possible to do this, since
 	 * part of what it does is notify the SCSI mid layer, which starts
@@ -3504,7 +3508,7 @@ static int __init hpsa_init(void)
 {
 	int err;
 	/* Start the scan thread */
-	hpsa_scan_thread = kthread_run(scan_thread, NULL, "hpsa_scan");
+	hpsa_scan_thread = kthread_run(hpsa_scan_func, NULL, "hpsa_scan");
 	if (IS_ERR(hpsa_scan_thread)) {
 		err = PTR_ERR(hpsa_scan_thread);
 		return -ENODEV;
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

origin.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
hpsa-rename-too-generic-variable-names.patch
hpsa-return-scsi_mlqueue_host_busy-on-command-allocation-failure.patch
hpsa-fix-incorrect-scsi-status-reporting.patch
hpsa-suppress-messages-due-to-unsupport-scsi-report_luns.patch
cciss-fix-bad-scsi-status-reporting.patch

