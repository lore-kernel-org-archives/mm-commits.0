From: akpm@linux-foundation.org
Subject: - dm-log-update-dm-io-interface.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:02 -0700
Message-ID: <200705092149.l49Ln25M002656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758761AbXEIVtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heinzm@redhat.com, agk@redhat.com, mbroz@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm log: update dm io interface
has been removed from the -mm tree.  Its filename was
     dm-log-update-dm-io-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dm log: update dm io interface
From: Heinz Mauelshagen <heinzm@redhat.com>

This patch ports dm-log.c to the new dm-io interface in order to make it
scalable to have a large number of persistent dirty logs active in parallel.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-log.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff -puN drivers/md/dm-log.c~dm-log-update-dm-io-interface drivers/md/dm-log.c
--- a/drivers/md/dm-log.c~dm-log-update-dm-io-interface
+++ a/drivers/md/dm-log.c
@@ -149,6 +149,8 @@ struct log_c {
 		FORCESYNC,	/* Force a sync to happen */
 	} sync;
 
+	struct dm_io_request io_req;
+
 	/*
 	 * Disk log fields
 	 */
@@ -200,13 +202,20 @@ static void header_from_disk(struct log_
 	core->nr_regions = le64_to_cpu(disk->nr_regions);
 }
 
+static int rw_header(struct log_c *lc, int rw)
+{
+	lc->io_req.bi_rw = rw;
+	lc->io_req.mem.ptr.vma = lc->disk_header;
+	lc->io_req.notify.fn = NULL;
+
+	return dm_io(&lc->io_req, 1, &lc->header_location, NULL);
+}
+
 static int read_header(struct log_c *log)
 {
 	int r;
-	unsigned long ebits;
 
-	r = dm_io_sync_vm(1, &log->header_location, READ,
-			  log->disk_header, &ebits);
+	r = rw_header(log, READ);
 	if (r)
 		return r;
 
@@ -234,11 +243,8 @@ static int read_header(struct log_c *log
 
 static inline int write_header(struct log_c *log)
 {
-	unsigned long ebits;
-
 	header_to_disk(&log->header, log->disk_header);
-	return dm_io_sync_vm(1, &log->header_location, WRITE,
-			     log->disk_header, &ebits);
+	return rw_header(log, WRITE);
 }
 
 /*----------------------------------------------------------------
@@ -257,6 +263,7 @@ static int create_log_context(struct dir
 	uint32_t region_size;
 	unsigned int region_count;
 	size_t bitset_size, buf_size;
+	int r;
 
 	if (argc < 1 || argc > 2) {
 		DMWARN("wrong number of arguments to mirror log");
@@ -326,6 +333,15 @@ static int create_log_context(struct dir
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size, ti->limits.hardsect_size);
 		lc->header_location.count = buf_size >> SECTOR_SHIFT;
+		lc->io_req.mem.type = DM_IO_VMA;
+		lc->io_req.client = dm_io_client_create(dm_div_up(buf_size,
+								   PAGE_SIZE));
+		if (IS_ERR(lc->io_req.client)) {
+			r = PTR_ERR(lc->io_req.client);
+			DMWARN("couldn't allocate disk io client");
+			kfree(lc);
+			return -ENOMEM;
+		}
 
 		lc->disk_header = vmalloc(buf_size);
 		if (!lc->disk_header) {
@@ -426,6 +442,7 @@ static void disk_dtr(struct dirty_log *l
 
 	dm_put_device(lc->ti, lc->log_dev);
 	vfree(lc->disk_header);
+	dm_io_client_destroy(lc->io_req.client);
 	destroy_log_context(lc);
 }
 
_

Patches currently in -mm which might be from heinzm@redhat.com are

origin.patch
