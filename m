From: akpm@osdl.org
Subject: - dm-log-rename-complete_resync_work.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:25 -0800
Message-ID: <200612082015.kB8KFPdP003297@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947101AbWLHUPc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbrassow@redhat.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: log: rename complete_resync_work
has been removed from the -mm tree.  Its filename was
     dm-log-rename-complete_resync_work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: log: rename complete_resync_work
From: Jonathan E Brassow <jbrassow@redhat.com>

The complete_resync_work function only provides the ability to change an
out-of-sync region to in-sync.  This patch enhances the function to allow us
to change the status from in-sync to out-of-sync as well, something that is
needed when a mirror write to one of the devices or an initial resync on a
given region fails.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-log.c   |   15 +++++++++------
 drivers/md/dm-log.h   |   10 +++++-----
 drivers/md/dm-raid1.c |   17 ++++++++++++-----
 3 files changed, 26 insertions(+), 16 deletions(-)

diff -puN drivers/md/dm-log.c~dm-log-rename-complete_resync_work drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-log-rename-complete_resync_work
+++ a/drivers/md/dm-log.c
@@ -549,16 +549,19 @@ static int core_get_resync_work(struct d
 	return 1;
 }
 
-static void core_complete_resync_work(struct dirty_log *log, region_t region,
-				      int success)
+static void core_set_region_sync(struct dirty_log *log, region_t region,
+				 int in_sync)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
 	log_clear_bit(lc, lc->recovering_bits, region);
-	if (success) {
+	if (in_sync) {
 		log_set_bit(lc, lc->sync_bits, region);
                 lc->sync_count++;
-        }
+        } else if (log_test_bit(lc->sync_bits, region)) {
+		lc->sync_count--;
+		log_clear_bit(lc, lc->sync_bits, region);
+	}
 }
 
 static region_t core_get_sync_count(struct dirty_log *log)
@@ -625,7 +628,7 @@ static struct dirty_log_type _core_type 
 	.mark_region = core_mark_region,
 	.clear_region = core_clear_region,
 	.get_resync_work = core_get_resync_work,
-	.complete_resync_work = core_complete_resync_work,
+	.set_region_sync = core_set_region_sync,
 	.get_sync_count = core_get_sync_count,
 	.status = core_status,
 };
@@ -644,7 +647,7 @@ static struct dirty_log_type _disk_type 
 	.mark_region = core_mark_region,
 	.clear_region = core_clear_region,
 	.get_resync_work = core_get_resync_work,
-	.complete_resync_work = core_complete_resync_work,
+	.set_region_sync = core_set_region_sync,
 	.get_sync_count = core_get_sync_count,
 	.status = disk_status,
 };
diff -puN drivers/md/dm-log.h~dm-log-rename-complete_resync_work drivers/md/dm-log.h
--- a/drivers/md/dm-log.h~dm-log-rename-complete_resync_work
+++ a/drivers/md/dm-log.h
@@ -90,12 +90,12 @@ struct dirty_log_type {
 	int (*get_resync_work)(struct dirty_log *log, region_t *region);
 
 	/*
-	 * This notifies the log that the resync of an area has
-	 * been completed.  The log should then mark this region
-	 * as CLEAN.
+	 * This notifies the log that the resync status of a region
+	 * has changed.  It also clears the region from the recovering
+	 * list (if present).
 	 */
-	void (*complete_resync_work)(struct dirty_log *log,
-				     region_t region, int success);
+	void (*set_region_sync)(struct dirty_log *log,
+				region_t region, int in_sync);
 
         /*
 	 * Returns the number of regions that are in sync.
diff -puN drivers/md/dm-raid1.c~dm-log-rename-complete_resync_work drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-log-rename-complete_resync_work
+++ a/drivers/md/dm-raid1.c
@@ -344,6 +344,17 @@ static void dispatch_bios(struct mirror_
 	}
 }
 
+static void complete_resync_work(struct region *reg, int success)
+{
+	struct region_hash *rh = reg->rh;
+
+	rh->log->type->set_region_sync(rh->log, reg->key, success);
+	dispatch_bios(rh->ms, &reg->delayed_bios);
+	if (atomic_dec_and_test(&rh->recovery_in_flight))
+		wake_up_all(&_kmirrord_recovery_stopped);
+	up(&rh->recovery_count);
+}
+
 static void rh_update_states(struct region_hash *rh)
 {
 	struct region *reg, *next;
@@ -383,11 +394,7 @@ static void rh_update_states(struct regi
 	 */
 	list_for_each_entry_safe (reg, next, &recovered, list) {
 		rh->log->type->clear_region(rh->log, reg->key);
-		rh->log->type->complete_resync_work(rh->log, reg->key, 1);
-		dispatch_bios(rh->ms, &reg->delayed_bios);
-		if (atomic_dec_and_test(&rh->recovery_in_flight))
-			wake_up_all(&_kmirrord_recovery_stopped);
-		up(&rh->recovery_count);
+		complete_resync_work(reg, 1);
 		mempool_free(reg, rh->region_pool);
 	}
 
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-log-rename-complete_resync_work.patch
dm-raid1-reset-sync_search-on-resume.patch

