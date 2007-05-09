From: akpm@linux-foundation.org
Subject: + dm-log-fault-detection.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:50 -0700
Message-ID: <200705090054.l490soF7006385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968399AbXEIAy7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:54:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com


The patch titled
     dm log: fault detection
has been added to the -mm tree.  Its filename is
     dm-log-fault-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm log: fault detection
From: Jonathan E Brassow <jbrassow@redhat.com>

This patch gives the disk logging code the ability to store the fact that an
error occured on the log device.  In addition, an event is raised when an
error is encountered during I/O to the log device.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff -puN drivers/md/dm-log.c~dm-log-fault-detection drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-log-fault-detection
+++ a/drivers/md/dm-log.c
@@ -152,6 +152,7 @@ struct log_c {
 	/*
 	 * Disk log fields
 	 */
+	int log_dev_failed;
 	struct dm_dev *log_dev;
 	struct log_header header;
 
@@ -315,6 +316,7 @@ static int create_log_context(struct dir
 		lc->disk_header = NULL;
 	} else {
 		lc->log_dev = dev;
+		lc->log_dev_failed = 0;
 		lc->header_location.bdev = lc->log_dev->bdev;
 		lc->header_location.sector = 0;
 
@@ -437,6 +439,15 @@ static int count_bits32(uint32_t *addr, 
 	return count;
 }
 
+static void fail_log_device(struct log_c *lc)
+{
+	if (lc->log_dev_failed)
+		return;
+
+	lc->log_dev_failed = 1;
+	dm_table_event(lc->ti->table);
+}
+
 static int disk_resume(struct dirty_log *log)
 {
 	int r;
@@ -446,8 +457,12 @@ static int disk_resume(struct dirty_log 
 
 	/* read the disk header */
 	r = read_header(lc);
-	if (r)
+	if (r) {
+		DMWARN("%s: Failed to read header on mirror log device",
+		       lc->log_dev->name);
+		fail_log_device(lc);
 		return r;
+	}
 
 	/* set or clear any new bits -- device has grown */
 	if (lc->sync == NOSYNC)
@@ -472,7 +487,14 @@ static int disk_resume(struct dirty_log 
 	lc->header.nr_regions = lc->region_count;
 
 	/* write the new header */
-	return write_header(lc);
+	r = write_header(lc);
+	if (r) {
+		DMWARN("%s: Failed to write header on mirror log device",
+		       lc->log_dev->name);
+		fail_log_device(lc);
+	}
+
+	return r;
 }
 
 static uint32_t core_get_region_size(struct dirty_log *log)
@@ -516,7 +538,9 @@ static int disk_flush(struct dirty_log *
 		return 0;
 
 	r = write_header(lc);
-	if (!r)
+	if (r)
+		fail_log_device(lc);
+	else
 		lc->touched = 0;
 
 	return r;
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-log-fault-detection.patch
dm-log-report-fault-status.patch
dm-raid1-add-handle_errors-feature-flag.patch
dm-raid1-fix-to-commit-pending-clear-region-requests.patch
dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
dm-log-fix-resume-failed-log-device.patch
