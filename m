From: akpm@linux-foundation.org
Subject: + dm-log-report-fault-status.patch added to -mm tree
Date: Tue, 08 May 2007 17:54:52 -0700
Message-ID: <200705090054.l490sqYu006388@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968414AbXEIAzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 20:55:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbrassow@redhat.com, agk@redhat.com


The patch titled
     dm log: report fault status
has been added to the -mm tree.  Its filename is
     dm-log-report-fault-status.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm log: report fault status
From: Jonathan E Brassow <jbrassow@redhat.com>

This patch reports the status of the log device so that userspace can detect
the error and take appropriate action.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c   |    7 ++++---
 drivers/md/dm-raid1.c |   11 +++++++----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/md/dm-log.c~dm-log-report-fault-status drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-log-report-fault-status
+++ a/drivers/md/dm-log.c
@@ -615,6 +615,7 @@ static int core_status(struct dirty_log 
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("1 %s", log->type->name);
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -630,17 +631,17 @@ static int disk_status(struct dirty_log 
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
-	char buffer[16];
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
+		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
+		       lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
-		format_dev_t(buffer, lc->log_dev->bdev->bd_dev);
 		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, buffer,
+		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
 	}
diff -puN drivers/md/dm-raid1.c~dm-log-report-fault-status drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-log-report-fault-status
+++ a/drivers/md/dm-raid1.c
@@ -1205,11 +1205,9 @@ static void mirror_resume(struct dm_targ
 static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	unsigned int m, sz;
+	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 
-	sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
-
 	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", ms->nr_mirrors);
@@ -1220,9 +1218,14 @@ static int mirror_status(struct dm_targe
 			(unsigned long long)ms->rh.log->type->
 				get_sync_count(ms->rh.log),
 			(unsigned long long)ms->nr_regions);
+
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+
 		break;
 
 	case STATUSTYPE_TABLE:
+		sz = ms->rh.log->type->status(ms->rh.log, type, result, maxlen);
+
 		DMEMIT("%d", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
 			DMEMIT(" %s %llu", ms->mirror[m].dev->name,
@@ -1234,7 +1237,7 @@ static int mirror_status(struct dm_targe
 
 static struct target_type mirror_target = {
 	.name	 = "mirror",
-	.version = {1, 0, 2},
+	.version = {1, 0, 3},
 	.module	 = THIS_MODULE,
 	.ctr	 = mirror_ctr,
 	.dtr	 = mirror_dtr,
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-log-fault-detection.patch
dm-log-report-fault-status.patch
dm-raid1-add-handle_errors-feature-flag.patch
dm-raid1-fix-to-commit-pending-clear-region-requests.patch
dm-raid1-switch-rh_in_sync-to-blocking-in-do_reads.patch
dm-log-fix-resume-failed-log-device.patch
