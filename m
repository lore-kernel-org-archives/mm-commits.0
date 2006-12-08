From: akpm@osdl.org
Subject: - dm-raid1-reset-sync_search-on-resume.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:15:29 -0800
Message-ID: <200612082015.kB8KFTce003300@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60025 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947007AbWLHUPg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:15:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbrassow@redhat.com, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm: raid1: reset sync_search on resume
has been removed from the -mm tree.  Its filename was
     dm-raid1-reset-sync_search-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm: raid1: reset sync_search on resume
From: Jonathan E Brassow <jbrassow@redhat.com>

Reset sync_search on resume.  The effect is to retry syncing all out-of-sync
regions when a mirror is resumed, including ones that previously failed.

Signed-off-by: Jonathan E Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-log.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/md/dm-log.c~dm-raid1-reset-sync_search-on-resume drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-raid1-reset-sync_search-on-resume
+++ a/drivers/md/dm-log.c
@@ -466,6 +466,7 @@ static int disk_resume(struct dirty_log 
 	/* copy clean across to sync */
 	memcpy(lc->sync_bits, lc->clean_bits, size);
 	lc->sync_count = count_bits32(lc->clean_bits, lc->bitset_uint32_count);
+	lc->sync_search = 0;
 
 	/* set the correct number of regions in the header */
 	lc->header.nr_regions = lc->region_count;
@@ -480,6 +481,13 @@ static uint32_t core_get_region_size(str
 	return lc->region_size;
 }
 
+static int core_resume(struct dirty_log *log)
+{
+	struct log_c *lc = (struct log_c *) log->context;
+	lc->sync_search = 0;
+	return 0;
+}
+
 static int core_is_clean(struct dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
@@ -621,6 +629,7 @@ static struct dirty_log_type _core_type 
 	.module = THIS_MODULE,
 	.ctr = core_ctr,
 	.dtr = core_dtr,
+	.resume = core_resume,
 	.get_region_size = core_get_region_size,
 	.is_clean = core_is_clean,
 	.in_sync = core_in_sync,
_

Patches currently in -mm which might be from jbrassow@redhat.com are

dm-raid1-reset-sync_search-on-resume.patch

